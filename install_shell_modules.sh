#!/bin/bash

install_dest_dir='/data/scripts/lib/shell_modules'

echo  "INSTALL ALL SHELL MODULES TO DIR[${install_dest_dir}]"

mkdir -p ${install_dest_dir}

cp -f ./*_module.sh  $install_dest_dir
