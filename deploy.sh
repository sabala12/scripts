#!/usr/bin/env bash
#===============================================================================
#
#          FILE: deploy.sh
# 
#         USAGE: ./deploy.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ERAN SABALA (sabalah21@gmail.com), 
#  ORGANIZATION: 
#       CREATED: 20/04/17 22:27:48
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o errexit                              # Exit on command failure

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

IMG_NAME="bare-bones.bin"
BUILD_DIR="./bare-bones/build"
SOURCE_TREE="./bare-bones/src"

$__dir/build.sh -s ./bare-bones/src -o ./bare-bones/build -n $IMG_NAME
$__dir/run.sh $BUILD_DIR/$IMG_NAME
