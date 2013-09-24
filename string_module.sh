
#######################
# Filename : string_module.sh
# Version  : 1.0.0
# Create   : 2012/03/16 15:01
# Update   : 2012/10/10
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
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=()


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


######
#  STRING MODULE
# Date: 2012/03/16 15:01
# Version: 1.0.0
# Author: SpunkMars++
# Support: spunkmars@163.com
######


function substr {
    local output_string
    local intput_string=$1
    local start_point=$2
    local split_number=$3
    eval output_string=\$\(echo \$intput_string\|awk \'\{print substr\(\$1,$start_point,$split_number\)\}\'\)
    #output_string=${output_string:start_point:split_number} # modify 2012/10/15
    echo $output_string
}


function substr1 {
    local out_s
    local s_point=$1
    local numbers=$2
    shift 2
    local in_s="$*"
    let s_point=${s_point}-1
    [ $s_point -lt 0 ] && s_point=0
    out_s=${in_s:s_point:numbers}
    echo "$out_s"
}