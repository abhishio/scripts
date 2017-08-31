#!/bin/bash

################################################################################
#   Script to Alert the Curl  and File Modification status
#   Author: Abhishek Kumar
#   Github: git.abhish.io
#   use: ./CurlFileStatus.sh
################################################################################

# Variables
url="http://google.com/"          # Complete Curl request
urlAlert="200 OK"     # Alert Check
fileLoc="/home/oodles/e-scripts/MediaCatapult/CurlFileCheck.sh"      # File location
fileAlert="1"    # Numeric Numbers only, In hours
sendFrom="noreply@abhish.io"     # Sender's email address
subject="CurlFile Test"      # Email Subject
mailList="me@abhish.io" # Enter Multiple mail list separated by spaces

function send_alert {
    msg="$1"
    echo "$msg" | mail -s "$subject"   $mailList
}

function curl_check {
    curlHit="$(curl -ISLs $url)"
    curlStatus="$?"
    curlResponse="$(echo $curlHit | grep -Po "$urlAlert" )"

    if [[  "$curlResponse" != "$urlAlert" ]]
    then
        send_alert "Error while sending request to $url : $curlHit"
    else
        echo "Curl Request working properly"
    fi
}

function file_check {
    if [[ -n "$1" ]]
    then
        fileLoc="$1"
    fi
    currentDate="$(date +'%s')"
    fileLastMod="$(( (( $currentDate - $(stat -c %Y $fileLoc) )) / 60 / 60 ))"
    echo "File last modified Since $fileLastMod Hours"
    if [[ $fileLastMod -ge $fileAlert ]]
    then
        send_alert "File $fileLoc has not been Modified Since $fileLastMod Hours"
    else
        echo "Recently Modified"
    fi

}

file_check      # Execute file_check function
curl_check      # Execute file check function
