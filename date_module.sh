
#######################
# Filename : date_module.sh
# Version  : 1.0.0
# Create   : 2012/03/16 15:01
# Update   : 2012/10/10
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


PROG_NAME='date_module'
MOD_NAME='date_module'
VERSION='1.0.0'
MODS_DIR='/data/scripts/lib/shell_modules'
REQUEST_MODS=(string_module)


####### LOAD INIT MODULE ########
source ${MODS_DIR}/init_module.sh
#################################


function get_date {
# EXP:  get_date      #output current date
#       get_date ago "" 2 days   #output the date of 2 days ago
#       get_date today year  #output current year of date
    local output_date_name=$1
    local output_date_format=$2
    local output_date_format_unit=$4
    local unit
    local date_format
    local output_date
    local some_number=$3

    if [[ $output_date_format_unit ]];then
        case "$output_date_format_unit" in
            years)
                unit='years'
                ;;
            months)
                unit='months'
                ;;
            days)
                unit='days'
                ;;
            *)
                unit='days'
                ;;
        esac
    else
        unit='days'
    fi

    if [[ $output_date_format ]];then
        case "$output_date_format" in
            year)
                date_format='%Y'
                ;;
            month)
                date_format='%m'
                ;;
            day)
                date_format='%d'
                ;;
            time)
                date_format='%H%M%S'
                ;;
            hour)
                date_format='%H'
                ;;
            minute)
                date_format='%M'
                ;;
            second)
                date_format='%S'
                ;;
            full_format)
                date_format='%Y%m%d%H%M%S'
                ;;
            *)
                date_format='%Y%m%d'
                ;;
        esac
    else
        date_format='%Y%m%d'
    fi

    case "$output_date_name" in
        today|current)
            output_date=`date --date='today' +"$date_format"`
            ;;
        yesterday)
            output_date=`date --date='yesterday' +"$date_format"`
            ;;
        tomorrow)
            output_date=`date --date='tomorrow' +"$date_format"`
            ;;
        ago)
            output_date=`date --date="$some_number $unit  ago" +"$date_format"`
            ;;
        later)
            output_date=`date --date="$some_number $unit" +"$date_format"`
            ;;
        *)
            output_date=`date --date="today" +"$date_format"`
            ;;
    esac

    echo "$output_date"

}



function number_to_month {

         local months_name=("NONE" "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
         if [[ 10#$1 -lt 10 ]];then
                local month_index=$(substr "$1" 2 1)
         else
                local month_index=$1
         fi
         echo ${months_name[$month_index]}
}



function month_to_number {
         local i
         local months_name=("NONE" "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
         local LIMIT=${#months_name[*]}
         for ((i=1; i <= LIMIT ; i++))
         do
            if [ "${months_name[$i]}" == "$1" ]
            then
                break
            fi
         done
         if [[ 10#$i -lt 10 ]];then
                echo "0$i"
         else
                echo $i
         fi
}




function split_date {

    local split_date=$1
    local split_date_type=$3
    local split_output
    local split_output_type=$2
    case "$split_output_type" in
        date)
            split_output=$(substr "$split_date" 1 8)
            ;;

        year)
            split_output=$(substr "$split_date" 1 4)
            ;;

        month)
            split_output=$(substr "$split_date" 5 2)
            ;;

        day)
            split_output=$(substr "$split_date" 7 2)
            ;;

        time)
            split_output=$(substr "$split_date" 9 6)
            ;;

        hour)
            split_output=$(substr "$split_date" 9 2)
            ;;

        minute)
            split_output=$(substr "$split_date" 11 2)
            ;;

        second)
            split_output=$(substr "$split_date" 13 2)
            ;;

    esac

    echo $split_output
}



function is_leapyear {
    if [[ $1%400 -eq 0 ]];then
        echo 1
    else
        if [[  ($1%4 -eq 0 && ! $1%100 -eq 0) ]];then
                echo  1
            else
        echo  0
            fi
    fi

}


function time_converter {
    local lock_time=$1
    local total_secs=0
    local hour=0
    local sec=0
    local min=0

    local min_str=$(echo "$lock_time" | grep -Eo '[0-9]{1,}m')
    min=$(echo "$min_str" | grep -Eo '[0-9]{1,}')

    local hour_str=$(echo "$lock_time" | grep -Eo '[0-9]{1,}h')
    hour=$(echo "$hour_str" | grep -Eo '[0-9]{1,}')

    local sec_str=$(echo "$lock_time" | grep -Eo '[0-9]{1,}s')
    sec=$(echo "$sec_str" | grep -Eo '[0-9]{1,}')

    let total_secs=min*60+hour*60*60+sec
    echo "$total_secs"
}


function output_date {
    local start_date=$1
    local end_date=$2
    local exec_command=$3
    local exec_command_parameter=$4
    local start_year=$(split_date $start_date  year)
    local start_month=$(split_date $start_date  month)
    local start_day=$(split_date $start_date  day)
    local end_year=$(split_date $end_date  year)
    local end_month=$(split_date $end_date  month)
    local end_day=$(split_date $end_date  day)
    local days_of_month_1=("0" "31" "29" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31")
    local days_of_month_2=("0" "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31")
    local i
    local x
    local y
    local output_date
    local days
    local month
    local is_first_exec=1
    local is_leap

    if [[ 10#$start_day -lt 10 ]];then
        start_day=$(substr "$start_day" 2 1)
    fi

    if [[ 10#$start_month -lt 10 ]];then
        start_month=$(substr "$start_month" 2 1)
    fi

    for (( i = start_year; i <= end_year; i++))
    do
        if [[ $is_first_exec -eq 1 ]];then
            x=$start_month
        else
            x=1
        fi

        for ((; x <= 12; x++))
        do
            is_leap=$(is_leapyear $i)
            if [[ "$is_leap" == "1" ]];then
                days=${days_of_month_1[$x]}
            else
                days=${days_of_month_2[$x]}
            fi

            if [[ $is_first_exec -eq 1 ]];then
                y=$start_day
            else
                y=1
            fi

            for (( ; y <= days; y++))
            do
                if [[ 10#$x -lt 10 ]];then
                    month="0"$x
                else
                    month=$x
                fi

                if [[ 10#$y -lt 10 ]];then
                    output_date=$i$month"0"$y
                else
                    output_date=$i$month$y
                fi

                if [[ $exec_command ]];then
#                    $exec_command $output_date $exec_command_parameter
                    $exec_command "$output_date" "${@:4}"

                fi

                if [[ $output_date == $end_date ]];then
                    return
                fi
                is_first_exec=0
            done
            is_first_exec=0
        done
        is_first_exec=0
    done

}



