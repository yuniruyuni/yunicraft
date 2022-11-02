#!/bin/bash

CC_COMPUTER_PATH='C:\Users\yuniruyuni\curseforge\minecraft\Instances\YuniruCraft\saves\YuniruCraft\computercraft\computer'

for FILE in `ls ${CC_COMPUTER_PATH}`
do
    FULLPATH="${CC_COMPUTER_PATH}\\${FILE}"
    if [ -d $FULLPATH ]; then
        echo "copying git content into ${FULLPATH}"
        rm -rf "${FULLPATH}"
        mkdir -p "${FULLPATH}"
        cp -r ./* "${FULLPATH}"
    fi
done
