#~/bin/bash
# by Kelly Clemmensen v1.

states=('Nebraska' 'California' 'Texas' 'Hawaii' 'Washington')
mynums=$(echo {0..9})

# Create a loop that looks for 'Hawaii'
for state in ${states[@]}
  do
  if [ $state == 'Hawaii' ]
  then
     echo "Hawaii is the best!"
  else
     echo "I'm not a fan of Hawaii"
  fi
done

#list of numbers
for num in ${mynums[@]}; do
   if [ $num = 3 ] || [ $num = 5 ] || [ $num = 7 ]; then
   echo $num
   fi
done