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

BUILD_WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $BUILD_WORKING_DIR/utils/utils.sh
source $BUILD_WORKING_DIR/utils/io.sh
source $BUILD_WORKING_DIR/utils/compiler.sh

usage()
{
cat << EOF
usage: $0 options

This scripts build a new kernel.

OPTIONS:
    -h      show this message
    -s      source code PATH
    -o      output object_files PATH
    -n      output image name

EOF
}

while getopts ":h:s:o:n:" OPTION
do
    case $OPTION in
        h)  usage
            exit 0
            ;;
        s)  SRC_DIR=${OPTARG}
            ;;
        o)  OBJ_FILES_DEST=${OPTARG}
            ;;
        n)  OUT_IMG_NAME=${OPTARG}
            ;;
        *)
            usage
            exit 1
            ;;
     esac
done

checkOption SRC_DIR
checkOption OBJ_FILES_DEST
checkOption OUT_IMG_NAME

checkPathExist SRC_DIR
checkPathExist OBJ_FILES_DEST

checkPathDir SRC_DIR
checkPathDir OBJ_FILES_DEST

echo "Permanently deleting files from $OBJ_FILES_DEST"
cleanDir OBJ_FILES_DEST
#sleepSeconds 1

echo "Creating object files.."
LINKER=$BUILD_WORKING_DIR"/linker.ld"

buildAssembler      SRC_DIR             OBJ_FILES_DEST
buildCpp            SRC_DIR             OBJ_FILES_DEST
linkObj             OBJ_FILES_DEST      LINKER              OUT_IMG_NAME

verifyMultiboot     OUT_IMG_NAME
