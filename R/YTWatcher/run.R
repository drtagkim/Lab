source('r/setting.R')

# Test --------------------------------------------------------------------
my_api_key <- file.choose()
login_youtube(literal$my_api_key) #my_api_key.yaml

collect_channel_info()
