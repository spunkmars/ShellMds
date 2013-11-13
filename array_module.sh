
#######################
# Filename : array_module.sh
# Version  : 1.0.0
# Create   : 2012/10/10 16:10
# Update   : 2012/10/10 16:10
# Author   : SpunkMars++
# Contact  : spunkmars@gmail.com, spunkmars@163.com
# Site     : http://www.spunkmars.org
# Description :
# Notes:
#
#----------------------
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


PROG_NAME='array_module'
MOD_NAME='array_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=()


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


function return_array {
    while [ $# -gt 0 ]
    do
        echo "$1"
        shift
    done

}

