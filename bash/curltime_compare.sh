#!/bin/bash

########
# USAGE
# 1. add api endpoints in the file
# 2. ./curltime_compare.sh /path
########

touch curl-format.txt
echo "
          http_code:  %{http_code}\\n
    time_namelookup:  %{time_namelookup}\\n
       time_connect:  %{time_connect}\\n
    time_appconnect:  %{time_appconnect}\\n
   time_pretransfer:  %{time_pretransfer}\\n
      time_redirect:  %{time_redirect}\\n
 time_starttransfer:  %{time_starttransfer}\\n
                    ----------\\n
         time_total:  %{time_total}\\n
         server_time: %{time_total} - %{time_connect} \\n
" >> curl-format.txt


curltime () {
   echo "SPEC: $1"
   echo "URL: $2"
   curl -w "@curl-format.txt" -o /dev/null -s $2 1> out
   cat out

   time_connect=$(cat out | grep "time_connect:" | cut -d ":" -f2)
   time_total=$(cat out | grep "time_total:" | cut -d ":" -f2)
   server_time=$(echo "$time_total - $time_connect" | bc)
   echo "         server_time: $server_time"
   echo
   rm out
}



# path="/...."
path=$@

curltime "API v1" "https://apiv1.com$path"
curltime "API v1" "https://apiv2.com$path"

rm curl-format.txt

