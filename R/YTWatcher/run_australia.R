source('R/setting.R')

literal <- yaml::read_yaml('literal.yaml')

literal$Channel_file <- "channels/channels_Australia.yaml"

login_youtube(literal$my_api_key) #my_api_key.yaml

collect_channel_info()
