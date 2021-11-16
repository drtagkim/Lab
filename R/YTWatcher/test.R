source('r/setting.R')

# Test --------------------------------------------------------------------
my_api_key <- file.choose()
login_youtube(my_api_key) #my_api_key.yaml

tic()
x=collect_channel_info()
toc()