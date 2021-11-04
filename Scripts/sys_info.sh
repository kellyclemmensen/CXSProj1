#!/bin/bash

# Assign Variable
output=~/research/sys_info.txt
files=('/etc/shadow' '/etc/passwd')

for file in ${files[@]};do
   ls -l $file >> $output
done


if [ $UID -eq 0 ]
then
echo "Do not run this command as root"
exit
fi

if [ ! -d ~/research ]
then
        mkdir ~/research
fi

#output=~/research/sys_info.txt

#echo $(uname) >> $output
#echo $(date) >> $output
#echo $(hostname -I) >> $output
#echo $(hostname) >> $output

#echo -e "\n777 Files:" >> $output
#find ~ -type f -perm 777 >> $output

#echo -e "\nTop 10 Processes:" >> $output
#ps aux -m | awk {'print $1,$2,$3,$4,$11'} | head >> $output