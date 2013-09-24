

#######################
# Filename : socket_module.sh
# Version  : 1.0.0
# Create   : 2012/10/12
# Update   : 2012/10/12
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


PROG_NAME='socket_module'
MOD_NAME='socket_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(net_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


function shell_socket {
    local net_host=${2-localhost}
    local net_protocal=${3-tcp}
    local net_port=${4-80}
    local pipe_channel=${5-8}
    case $1 in
        open)
            eval "exec ${pipe_channel}<>/dev/${net_protocal}/${net_host}/${net_port}"
            #[ $? -eq 0 ] && echo ${pipe_channel}
            ;;
        close)
                eval "exec ${pipe_channel}<&-"
                eval "exec ${pipe_channel}>&-"
            ;;
        *)
            echo 'invi option !'
            exit 1
            ;;
    esac

}


function get_socket_response {
    local pipe_channel=${1-8}
    local line_s
    while read -u ${pipe_channel} -d $'\r' line_s;
    do
        echo "${line_s}";
    done


}


function put_socket_request {

    local pipe_channel=${1-8}
    shift 1
    local msg="$@"
    echo "$@"
    eval "echo -ne '$@'>&${pipe_channel}"
    get_socket_response ${pipe_channel}

}