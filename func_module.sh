
function  is_define_func {

   if [[ $(declare -f "$1") ]];then
        echo 1
   else
        echo 0
    fi

}