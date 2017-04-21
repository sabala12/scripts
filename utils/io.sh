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

IO_WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $IO_WORKING_DIR/utils.sh

checkPathExist()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $# 
    local __path="${!1}"

    if [[ ! -e $__path ]]; then
        echo "$__path does not exist!"
        exit 2
    fi
}
checkPathDir()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $# 
    local __path="${!1}"

    if [[ ! -d $__path ]]; then
        echo '$__path is not a directory!'
        exit 2
    fi
}
cleanDir()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $#
    local __dir="${!1}"

	find $__dir -type 'f' | xargs -I __file rm __file
}
