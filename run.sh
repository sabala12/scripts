#!/usr/bin/env bash
#===============================================================================
#
#          FILE: run.sh
# 
#         USAGE: ./run.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ERAN SABALA (sabalah21@gmail.com), 
#  ORGANIZATION: 
#       CREATED: 20/04/17 22:20:05
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o errexit                              # Exit on command failure

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

source $__dir/utils/utils.sh

if [[ "$#" -lt "1" ]]; then
    printErr "missing arg #1! img path is not specified." 1  
fi

IMG=$1

qemu-system-i386 -kernel $IMG
