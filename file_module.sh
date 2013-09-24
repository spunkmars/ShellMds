
#######################
# Filename : file_module.sh
# Version  : 1.0.1
# Create   : 2012/03/16 15:01
# Update   : 2012/12/13 17:10
# Author   : SpunkMars++
# Contact  : spunkmars@gmail.com, spunkmars@163.com
# Site     : http://www.spunkmars.org
# Description :
# Notes:
#
######## Changlog #####
#Version 1.0.0
# xxx xxx xxx xxxx
#------------------
#
#Version 1.0.1
# xxx xxx xxx xxx
#######################


PROG_NAME='file_module'
MOD_NAME='file_module'
VERSION='1.0.1'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(date_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


######
#  FILE MODULE
# Update: 2012/10/10 10:48
# Create: 2012/12/13 17:10
# Version: 1.0.1
# Author: SpunkMars++
# Support: spunkmars@163.com
######





function is_file_exist {
    local file_path=$1
    if [[ $file_path ]];then
        if [[ -e $file_path ]];then
            echo 1
        else
            echo 0
        fi
    else
        echo 0
    fi

}


function filter_path {

    if [ $# -gt 0 ];then
        local in_p="$*"
        local temp_1=`echo "${in_p}"|sed -e 's#/*$##g'`
        echo "$temp_1"|sed -e 's#/\{2,\}#/#g'
    else
        echo ""
    fi

}


function get_parent_dir {

    local in_p="$*"
    [ $# -gt 0 ] && local temp_dir=$( dirname "$(filter_path "$in_p")" )
    echo "${temp_dir}"
}


function get_file_name {

    local in_p="$*"
    [ $# -gt 0 ] && local temp_dir=$( basename "$(filter_path "${in_p}")" )
    echo "${temp_dir}"

}


function get_extra_name {

    local in_p="$*"
    [ $# -gt 0 ] &&  echo "$(get_file_name $in_p)"|awk -F'.' '{if (NF<2){print ""} else { if ($0 ~/.*\/$/){print $(NF-1)} else {print $NF}} }'

}


function get_base_name {

    if [ $# -gt 0 ];then
        local in_p="$*"
        local match_string=$(get_extra_name "$in_p")
        if [[ ! $match_string == '' ]];then
            match_string=`echo "$match_string"|sed -e 's/\/|\.//'`
            eval "echo \"$(get_file_name "$in_p")\"|sed -e 's/.$match_string\$//'"
        else
            echo "$(get_file_name "$in_p")"
        fi
    fi
}


function split_path {
    local path=$1
    local path_type=$2
    local output_string

    case "$path_type" in
        basename|filename)
            output_string=$(echo "$path"|awk -F'/' '{if ($0 ~/.*\/$/){print $(NF-1)} else {print $NF}}')
            ;;
        directory)
            output_string=$(echo "$path"|awk -F'/' '{if ($0 ~/^\/.*\/$/){x=2;y=NF-2} else if ($0 ~/^\/.*/){x=2;y=NF-1} else if ($0 ~/.*\/$/){x=1;y=NF-2} else {x=1;y=NF-1};for(i=x;i<=y;i++)printf ("/%s",$i)}')
            ;;
    esac

    echo  "$output_string"

}


function auto_rename_if_exist {

    local file_path=$1
    local date_string=$(get_date today full_format)
    local backup_path=$(split_path $file_path directory)/.back
    local new_file_path=${backup_path}/$(split_path $file_path filename)_${date_string}

    if [[ ! -e $backup_path ]];then
        mkdir -p $backup_path
    fi

    if [[ $file_path && $(is_file_exist $file_path) -eq 1 ]];then
        mv  $file_path  $new_file_path
    fi

}


function set_running_lock {
    local lock_path=$1
    local lock_time=$2
    local lock_action=$3
    local lock_callback=$4
    local lock_timestamp
    local curr_timestamp
    local time_difference
    lock_time=$( time_converter "$lock_time" )
    let curr_timestamp=`date +%s`
    #lock_action='e'

    if [[ -f $lock_path ]];then
        let lock_timestamp=`cat $lock_path`
        let time_difference=curr_timestamp-lock_timestamp
        if [[ $time_difference -gt $lock_time ]];then
            case "$lock_action" in
                'e')
                    echo "The lock[${lock_path}] is overdue ! exit  ."
                    exit 0
                    ;;
                'c')
                    echo "The lock[${lock_path}] is overdue ! run callback ."
                    [ $lock_callback ] && $lock_callback  ${@:5}
                    exit 0
                    ;;
                'r')
                    echo "The lock[${lock_path}] is overdue ! reset it ."
                    echo "$curr_timestamp" >$lock_path

                    ;;
                'n'|*)
                    echo "The lock[${lock_path}] is overdue ! reset it and run callback ."
                    echo "$curr_timestamp" >$lock_path
                    [ $lock_callback ] && $lock_callback  ${@:5}
                    ;;
            esac
        else
            echo "The lock[${lock_path}] is unexpired ! exit ."
            exit 0
        fi
    else
        echo "set lock [${lock_path}] ."
        echo "$curr_timestamp" >$lock_path
    fi
}


function unset_running_lock() {
    local lock_path=$1
    [ -f $lock_path ] && rm -f $lock_path
}



