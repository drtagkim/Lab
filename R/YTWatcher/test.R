source('r/setting.R')

# Test --------------------------------------------------------------------
my_api_key <- file.choose()
login_youtube(my_api_key) #my_api_key.yaml

#channel_stats
# https://commentpicker.com/youtube-channel-id.php
x1=get_channel_videos_stat("UChhOtjq-3QyyLmP2jv9amrg")
