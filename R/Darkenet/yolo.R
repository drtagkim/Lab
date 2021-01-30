#install


install_darknet <- function() {
  reqPkg('remotes')
  install_github("bnosac/image", subdir = "image.darknet", build_vignettes = TRUE)  
}


# Library -----------------------------------------------------------------
library(image.darknet)
library(Rcpp)
library(dplyr)
library(tidyr)
library(here)
library(pbapply)
# Util --------------------------------------------------------------------

reqPkg <- function(PKG) {
  REPO="https://cran.rstudio.com"
  suppressMessages({
    if(!require(PKG,character.only=TRUE,quietly=TRUE)) install.packages(PKG,repos=REPO,quiet=TRUE)
    require(PKG,character.only=TRUE,quietly=TRUE)
  })
}
# Functions ---------------------------------------------------------------
detect_model <- image_darknet_model(
  type = "detect",
  model = "tiny-yolo-voc.cfg",
  weights = system.file(package = "image.darknet", "models", "tiny-yolo-voc.weights"),
  labels = system.file(package = "image.darknet", "include", "darknet", "data", "voc.names")
)
# function to be applied to images
detect_objects <- function(x,path,output) {
  filename <- paste(path, x, sep = "/")
  prediction <- image_darknet_detect(
    file = filename,
    object = detect_model,
    threshold = 0.3
  )
  file.rename("predictions.png", paste0(output,"/", x))
  return(prediction)
}

cppFunction('void redir(){FILE* F=freopen("capture.txt","w+",stdout);}')
cppFunction('void resetredir(){FILE* F=freopen("CON","w+",stdout);}')

test <- function(a) here(a)

process_images <- function(x1,x2='pred') {
  #img - image directory
  #pred - prediction output
  path <- here(x1)
  images <- dir(path = path, pattern = "\\.png|\\.jpg|\\.jpeg")
  dir.create(x2)
  redir()
  d <- pblapply(images, detect_objects,path,x2) 
  resetredir()
  d <- data.frame(txt = unlist(readLines("capture.txt"))) 
  
  ## Take out all the lines that we don't need.
  d <- d %>% 
    filter(!grepl("Boxes", txt)) %>% 
    filter(!grepl("pandoc", txt)) %>% 
    filter(!grepl("unnamed", txt))
  
  ## Find the lines that contain the file names. Make a logical vector called "isfile"
  d$isfile <- grepl(path, d$txt)
  
  ## Take out the path and keep only the file names
  d$txt <- gsub(paste0(path, '/'), "", d$txt)
  
  ## Make a column called file that contains either file names or NA
  d$file <- ifelse(d$isfile, d$txt, NA)
  
  ## All the other lines of text refer to the objects detected
  d$object <- ifelse(!d$isfile, d$txt, NA)
  
  ## Fill down
  d <- tidyr::fill(d, "file")
  
  ## Take out NAs and select the last two columns
  d <- na.omit(d)[, 3:4]
  
  # Separate the text that is held in two parts
  d <- d %>% separate(file, into = c("file", "time"), sep = ":")
  d <- d %>% separate(object, into = c("object", "prob"), sep = ":")
  d <- d %>% filter(!is.na(prob))
  
  # Keep only the prediction time
  d$time <- gsub("Predicted in (.+).$", "\\1", d$time)
  
  # Convert probabilities to numbers
  d$prob <- as.numeric(sub("%", "", d$prob)) / 100
  
  # Optionally remove the file
  file.remove("capture.txt")
  #d %>% knitr::kable()
  d
}

x=process_images('img','pred')
x
