# Version  : 1.0.1
# Create   : 2013/02/28 10:30
# Update   : 2013/02/28 10:30
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


PROG_NAME='msg_module'
MOD_NAME='msg_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(array_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


send_alert_msg() {
    local m_mailto=$1
    local m_type='EMAIL_SMTP'
    local m_content=$3
    local m_sub=$2
    local http_uri=""
    local http_response=$( /usr/bin/wget "${http_uri}" -O -   2>&1)

}


get_alert_emails() {
    local alert_emails
    declare -a alert_emails
    local email_file="${MODS_DIR}/email.conf"
    [ -f "$email_file" ] && alert_emails=( `cat $email_file|grep -v '^#'|awk '{print $1}'` )
    return_array  ${alert_emails[@]}
}


send_m_email() {
    local m_sub=$1
    local m_content=$2
    local alert_emails
    declare -a alert_emails
    alert_emails=$(get_alert_emails)
    local email
    for email in ${alert_emails[@]}
    do
        [ -n "$email" ] && send_alert_msg "$email" "$m_sub" "$m_content"
    done
}