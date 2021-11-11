source('r/setting.R')

# Test --------------------------------------------------------------------
my_api_key <- file.choose()
login_youtube(my_api_key) #my_api_key.yaml

emailconf=yaml.load_file('email.yaml')




#channel_stats
# https://commentpicker.com/youtube-channel-id.php
x2=get_channel_videos_stat("UCknq-MUI6gpsG6pUzcnQ6Tg")
path_output=tempfile(pattern='yt_channel_',fileext='.xlsx')
writexl::write_xlsx(x2,path_output)
email <- emayili::envelope() %>% 
  from(emailconf$from) %>% 
  to(c('snumuse@naver.com')) %>% 
  subject(emailconf$subject) %>% 
  text('hello') %>% 
  attachment(path_output)
smtp <- emayili::server(
  host = emailconf$host,
  port = emailconf$port,
  username = emailconf$user,
  password = emailconf$password
)
smtp(email,verbose=F)
