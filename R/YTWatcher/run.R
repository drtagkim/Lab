source('R/setting.R')

# Test --------------------------------------------------------------------
literal <- yaml::read_yaml('literal.yaml')

login_youtube(literal$my_api_key) #my_api_key.yaml

collect_channel_info()
