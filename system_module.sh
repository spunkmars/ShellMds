
#######################
# Filename : system_module.sh
# Version  : 1.0.1
# Create   : 2012/10/10 22:11
# Update   : 2013/02/28 16:11
# Author   : SpunkMars++
# Contact  : spunkmars@gmail.com, spunkmars@163.com
# Site     : http://www.spunkmars.org
# Description :
# Notes:
#
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


PROG_NAME='system_module'
MOD_NAME='system_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(msg_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


function is_run_fg {
    #check script run in the foreground or background.

    if [[  -t 0 ]];then
        echo 1
    else
        echo 0
    fi
}


function get_pid() {
    local pid_file=$1
    local pid_n='null'
    [ -f $pid_file ] && let pid_n=`cat $pid_file`
    echo $pid_n
}


function set_pid() {
    local pid_file=$1
    echo $$ > ${pid_file}
    echo $$
}


function unset_pid() {
    local pid_file=$1
    [[ -f $pid_file ]] && rm -f $pid_file
}


function is_proc_active() {
    local pid_num=$1
    local proc_state=0
    if [ "${pid_num}" != 'null' ];then
        if [ ${pid_num} -gt 0 -a -d /proc/${pid_num} ];then
            proc_state=1
        else
            proc_state=0

        fi
    else
        proc_state=0
    fi
    echo $proc_state

}


function kill_proces() {
    local all_procs=`ps -Af|grep -v 'grep'|grep $1|awk '{print $2}'`
    local proc
    for proc in ${all_procs[@]}
    do
        [[ $$ -eq $proc ]] && continue
        echo "kill proc [${proc}] .. "
        kill -n TERM ${proc}
    done
}


function kill_signal_proc() {
    local pid_file=$1
    local s_pid
    s_pid=$(get_pid "$pid_file")
    if [[ $(is_proc_active $s_pid) -eq 1 ]];then
          kill -n TERM $s_pid
    fi
}


function wait_p() {
    local t_secs=${1-3}
    local p_str=${2-'.'}
    echo -n "Wait for ${t_secs} seconds ";
    for (( i=0; i<t_secs; i++ ))
    do
        echo -n "${p_str}";sleep 1
    done
    echo
}


function worker_manager() {
    local job_num=${1-1}
    local worker_func=$2
    for (( i=0; i<job_num; i++ ))
    do
        (${worker_func} "${@:3}") &
    done
    wait
}


function is_func() {
    local func_name=$1
    local r_type=$(type -t ${func_name} 2>/dev/null)
    if [[ "${r_type}" == 'function' ]];then
        echo 1
    else
        echo 0
    fi

}


function overtime_func() {
    local curr_date=$(date)
    local prog_id=$1
    local prog_pid=$2
    local overtime_action=${3:null}
    echo "alert:${prog_id} is overtime !"
    local m_content="${curr_date} > ${prog_id} is overtime !"
    local m_sub="${curr_date} alert:${prog_id}"
    send_m_email "$m_sub"  "$m_content"

    case  "$overtime_action" in 
       kill1)
           kill_signal_proc "${prog_pid}"
           ;;
       kill2)
           kill_signal_proc "${prog_pid}"
           kill_proces "${prog_id}"
           ;;
       null|*)
       ;;
    esac

}
