
#######################
# Filename : http_module.sh
# Version  : 1.0.0
# Create   : 2012/10/12
# Update   : 2012/10/12 23: 42
# Author   : SpunkMars++
# Contact  : spunkmars@gmail.com, spunkmars@163.com
# Site     : http://www.spunkmars.org
# Description :
# Notes:
#
#
######## Changlog #####
#Version 1.0.0
# xxx xxx xxx xxxx
#------------------
#
#Version 1.0.1
# xxx xxx xxx xxx
#######################


PROG_NAME='http_module'
MOD_NAME='http_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(socket_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


function urlencode {
    # Title      :      urlencode - encode URL data
    # Author     :      Heiner Steven (heiner.steven@odn.de)
    # Date       :      2000-03-15
    # Requires   :      awk
    # Categories :      File Conversion, WWW, CGI
    # SCCS-Id.   :      @(#) urlencode  1.4 06/10/29



    #LANG=C     export LANG

    local EncodeEOL='yes'
    local encoded_str=`echo "$*" | awk 'BEGIN {
        EOL = "%0A"             # "end of line" string (encoded)
        split ("1 2 3 4 5 6 7 8 9 A B C D E F", hextab, " ")
        hextab [0] = 0
        for (i=1; i<=255; ++i) {
            ord [ sprintf ("%c", i) "" ] = i + 0
        }
        if ("'"$EncodeEOL"'" == "yes") {
            EncodeEOL = 1;
        } else {
            EncodeEOL = 0
        }
    }
    {
        encoded = ""
        for (i=1; i<=length($0); ++i) {
            c = substr ($0, i, 1)
            if ( c ~ /[a-zA-Z0-9.-]/ ) {
                encoded = encoded c             # safe character
            } else if ( c == " " ) {
                encoded = encoded "+"   # special handling
            } else {
                # unsafe character, encode it as a two-digit hex-number
                lo = ord [c] % 16
                hi = int (ord [c] / 16);
                encoded = encoded "%" hextab [hi] hextab [lo]
            }
        }
        if ( EncodeEOL ) {
            printf ("%s", encoded EOL)
        } else {
            print encoded
        }
    }' 2>/dev/null`
    encoded_str=${encoded_str//+/%20}
    echo "${encoded_str}"
}


function uri_encoder {

    #local encoded_string=`/usr/bin/perl  /data/scripts/lib/shell_modules/encoder_for_shell.pl "$*"`
    #local encoded_string=`echo -n "$*"|od -An -tx1|tr ' ' %|sed 's/ /%/g'`
    local encoded_string=$(urlencode "$*")
    echo "${encoded_string}"
}


function get_uri_proto {

    local uri="$*"
    local uri_proto
    uri_proto=`echo "${uri}"|awk -F'://' '{print $1}'`
    echo "${uri_proto}"
}


function get_uri_host {

    local uri="$*"
    local uri_host
    uri_host=`echo "${uri}"|awk -F'://' '{print $2}'|awk -F'/' '{print $1}'|awk -F':' '{print $1}'`
    echo "${uri_host}"
}


function get_uri_port {

    local uri="$*"
    local uri_port=''
    uri_port=`echo "${uri}"|awk -F'://' '{print $2}'|awk -F'/' '{print $1}'|awk -F':' '{if(NF<2){print ""} else {print $2}}'`
    echo ${uri_port}
}


function get_uri_file {

    local uri="$*"
    local uri_file=`echo "${uri}"|awk -F'://' '{print $2}'|awk -F'?' '{print $1}'|awk -F'/' 'BEGIN{ORS=""} {if (NF<2){print "/"} else { for(bi=2;bi<=NF;bi++) printf("/%s",$bi)} }'`
    echo "${uri_file}"
}


function get_uri_param {

    local uri="$*"
    local uri_param=''
    uri_param=`echo "${uri}"|awk -F'?' '{if (NF<2){print ""} else {print $2}}'`
    echo "${uri_param}"
}


function http_get {

    if [ $# -lt 4 ];then
        echo 'invi option !'
        exit 1
    fi

    local remote_host=$1
    local remote_port=${2-80}
    [ $remote_port == '' ] && remote_port=80
    local pipe_channel=${3-8}
    local http_get_data=${4-test}
    local socket_msg
    local remote_response
    shell_socket 'open' ${remote_host} 'tcp' ${remote_port}  ${pipe_channel}
    socket_msg="GET ${http_get_data} HTTP/1.0\r\nHost: ${remote_host}\r\nContent-Type: application/x-www-form-urlencoded\r\nConnection: Close\r\n\r\n"
    remote_response=$(put_socket_request ${pipe_channel} ${socket_msg})
    shell_socket 'close' ${remote_host}  'tcp' ${remote_port} ${pipe_channel}
    echo ${remote_response[@]}

}


function http_post {
    local aa=''

}


function http_head {
    local aa=''

}


function shell_wget {

    local uri="$*"
    local uri_host=$(get_uri_host $uri)
    local uri_port=$(get_uri_port $uri)
    local uri_file=$(get_uri_file $uri)
    local uri_param=$(get_uri_param $uri)


    local http_data="${uri_file}?${uri_param}"

    http_get ${uri_host} ${uri_port} '8' ${http_data}

}


function get_http_response_head {

    echo 'ooo'

}


function get_http_response_status {

    echo '200'

}


function get_http_response_content {

    echo 'xxx'

}