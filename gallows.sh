#!/bin/bash
mask=$(echo $1 | sed "s/?/*/g")
str=$(curl -s https://bezbukv.ru/mask/$mask)
count_page=$(echo $str | grep -E -i -w -o 'last.*page=[0-9]+' | grep -E -i -o 'e=[0-9]+' | grep -E -i -o '[0-9]+')
touch $(date +%m-%d-%Y).txt
echo $str | grep -E -i -o '<b>[0-9]+<\/b>\. [а-я]+' | grep -E -i -o '[а-я]+' > $(date +%m-%d-%Y).txt
for (( i = 1; i <= count_page; i++ )); do
	str=$(curl -s https://bezbukv.ru/mask/$mask?page=$i)
	echo $str | grep -E -i -o '<b>[0-9]+<\/b>\. [а-я]+' | grep -E -i -o '[а-я]+' >> $(date +%m-%d-%Y).txt
done
r=$(cat $(date +%m-%d-%Y).txt)
for i in $2; do
	r=$(echo "$r" | grep -v "$i")
done
echo "$r"
