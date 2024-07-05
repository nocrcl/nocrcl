#!/bin/bash

safety="safe" #safe, sketchy, unsafe
image=$(($#-1))
szuru_token="y0urT0k3nHeR3=" # base64 encoded username and token. you can generate it using duckduckgo.com. Enter "base64 username:token" in the search bar
api_url="https://yourszurubooruinstan.ce:8080"

while [ $image -ge 0 ]; do
    echo "Uploading " ${BASH_ARGV[$image]}

# Use pngcheck and jq to extract the tags from the png and format the output
    json_tags=$(pngcheck -t -q "${BASH_ARGV[$image]}" | awk 'NR>2 && NR<23' | jq '.Input | {tags: (.prompt | rtrimstr(",")| split(" *(\\.|,) *"; null) | map(gsub("(\\s)+"; "_")|gsub("(\\+)+";"")) | map(select(. != "")) ), safety: "'$safety'"}')

    curl -X POST -H "Authorization: Token $szuru_token" -H "Content-Type: multipart/form-data" -H "Accept: application/json" -F "content=@${BASH_ARGV[$image]}" -F "metadata=$json_tags" $api_url/api/posts/
    image=$((image-1))
    echo "\n"
done
