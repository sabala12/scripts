#!/bin/bash - 
#===============================================================================
#
#          FILE: io.sh
# 
#         USAGE: ./io.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ERAN SABALA (sabalah21@gmail.com), 
#  ORGANIZATION: 
#       CREATED: 11/04/17 11:59:54
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o errexit								# Exit when command failes

checkArgs()
{
	local __argc=3
    if [[ "$__argc" -gt "$#" ]]; then
            $FUNCNAME $FUNCNAME $__argc $#
    fi

    local __function_name=$1
    local __expected_args=$2
    local __real_args=$3

    if [[ "$__expected_args" -gt "$__real_args" ]]; then
            echo "$__function_name(): wrong number of arguments"
            echo "$__function_name(): expected $__expected_args, actual $__real_args"
            exit 1
    fi
}
setVal() 
{
    local __argc=2
    checkArgs $FUNCNAME $__argc $#
    local __result_var=$1
    local __result_val=$2
    eval "$__result_var='$__result_val'"
}
printErr()
{
    local __argc=2
    checkArgs $FUNCNAME $__argc $#
    local __err_msg=$1
    local __exit_code=$2
    echo $__err_msg
    local __err=$(declare -f usage > /dev/null; echo $?)
    if [[ $__err == "0" ]]; then
            usage
    fi
    exit $__exit_code
}
checkOption()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $#
    
    local __value="${!1:-}"
    if [[ -z ${__value} ]]; then
            printErr "option $1 is not set!" 1
    fi
}
sleepSeconds()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $#
    local __seconds="$1"
	
    if [[ ! "$__seconds" -eq "$__seconds" ]] 2> /dev/null; then
        printErr "$FUNCNAME: arg 1 must be an integer!" 2
    fi

    for ((__i=0; __i<=$__seconds; __i++)) do
        local __sec_i=$((__seconds-__i))
        echo -e "$__sec_i"
        sleep 1
    done
}
