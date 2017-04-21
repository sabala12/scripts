#!/bin/bash - 
#===============================================================================
#
#          FILE: compiler.sh
# 
#         USAGE: ./compiler.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ERAN SABALA (sabalah21@gmail.com), 
#  ORGANIZATION: 
#       CREATED: 11/04/17 19:01:25
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

COMPILER_WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $COMPILER_WORKING_DIR/utils.sh

verifyMultiboot()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $#

    local __img=${!1}
    if grub-file --is-x86-multiboot $__img; then
        echo "multiboot confirmed"
    else
        printErr "the file is not multiboot" 3
    fi
}

buildFiles()
{
    local __argc=4
    checkArgs $FUNCNAME $__argc $#
    
    local __dir=$(realpath $1)
    local __dest=$(realpath $2)
    local __ext="$3"
    local __command="$4"
    
    local __files=$(find $__dir -name "*$__ext" -type "f")

    for __file_path in $__files; do
        local __file_name=$(basename "$__file_path")
        __clean_file_name="${__file_name%.*}"
        __file_dir=$(dirname $__file_path)"/"
        __obj_file=$__file_dir$__clean_file_name".o"
        __command=$(echo $__command | sed "s|ARG_1|$__file_path|g")
        __command=$(echo $__command | sed "s|ARG_2|$__obj_file|g")

        eval $__command
        mv $__obj_file $__dest
        echo $__obj_file
    done
}

buildAssembler()
{
    local __argc=2
    checkArgs $FUNCNAME $__argc $#
    
    local __dir="${!1}"
    local __dest="${!2}"
    local __ext=".s"
    local __command='i686-elf-as ARG_1 -o ARG_2'

    buildFiles $__dir $__dest $__ext "$__command"
}

buildC()
{
    local __argc=2
    checkArgs $FUNCNAME $__argc $#
    
    local __dir="${!1}"
    local __dest="${!2}"
    local __ext=".c"
    local __command="i686-elf-gcc -c ARG_1 -o ARG_2 -std=gnu99 -ffreestanding -O2 -Wall -Wextra"
    
    buildFiles $__dir $__dest $__ext "$__command"
}

buildCpp()
{
    local __argc=2
    checkArgs $FUNCNAME $__argc $#
    
    local __dir="${!1}"
    local __dest="${!2}"
    local __ext=".cpp"
    local __command="i686-elf-g++ -c ARG_1 -o ARG_2 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti"

    buildFiles $__dir $__dest $__ext "$__command"
}

linkObj()
{
    local __argc=3
    checkArgs $FUNCNAME $__argc $#
    
    local __dir="${!1}"
    local __linker="${!2}"
    local __output="${!3}"

    local __objects=$(find $__dir -name '*.o' | xargs -I file basename file | tr '\n' ' ' | rev | cut -c 1- | rev)
    cd $__dir
    local __command="i686-elf-gcc -T $__linker -o $__output -ffreestanding -O2 -nostdlib $__objects -lgcc"
    eval $__command
    echo $__output
}
