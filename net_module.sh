
#######################
# Filename : net_module.sh
# Version  : 1.0.0
# Create   : 2012/08/16 16:10
# Update   : 2012/08/16 16:10
# Author   : SpunkMars++
# Contact  : spunkmars@gmail.com, spunkmars@163.com
# Site     : http://www.spunkmars.org
# Description :
# Notes:
#
######## Changlog #####
#Version 1.0.0
# first version!
# xxx xxx xxx xxxx
#------------------
#
#Version 1.0.0
# xxx xxx xxx xxx
#######################


PROG_NAME='net_module'
MOD_NAME='net_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(array_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################



######
#  NET MODULE
# Date: 2012/08/16 15:54
# Version: 1.0.0
# Author: SpunkMars++
# Support: spunkmars@163.com
######


function get_all_ips {
    local net_config_path='/etc/sysconfig/network-scripts'
    local ifcfg_list=`find  $net_config_path  -name 'ifcfg-*'`
    local i=0
    local ifcfg
    local ips
    for ifcfg in $ifcfg_list
    do
        ips[$i]=`cat $ifcfg |grep 'IPADDR'|awk -F= '{print $2}'`
        let i++
    done

    return_array ${ips[@]}
}

function get_ip {
    local ipsc=$(get_all_ips)
    local i=0
    local ip
    local inv_ips
    for ip in $ipsc
    do
        if [[ $ip != '127.0.0.1' ]];then
            inv_ips[$i]=$ip
            let i++
        fi
    done
    return_array ${inv_ips[@]}
}


function get_ip_string {
    local ips=$(get_ip)
    local ip_string
    local ip
    local i=0
    for ip in $ips
    do
        if [[ $i -eq 0 ]];then
            ip_string=$ip
        else
            ip_string="${ip_string}|${ip}"
        fi
        let i++
    done
    echo "$ip_string"
}


function is_port_used {
    local s_port=${1-80}
    local s_protocol=${2-'TCP'}
    local s_hostdir=$3
    local s_ipv=${4-4}
    local opts
    if [ -z "$s_hostdir" ];then
        opts="${s_ipv}${s_protocol}:${s_port}"
    else
        opts="${s_ipv}${s_protocol}@${s_hostdir}:${s_port}"
    fi

    if [[ $(lsof -i "${opts}" ) ]];then
        echo 1
    else
        echo 0
    fi
}