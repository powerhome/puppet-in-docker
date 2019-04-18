#!/bin/sh

for file in $(find /etc/webhook/ -iname '*.tmpl'); do
    newFile=${file%%\.tmpl}
    echo "Writing webhook secret from ${file} into ${newFile}..."
    sed -e "s/%{HOOKS_SECRET}/${HOOKS_SECRET}/g" ${file} > ${newFile}
done
