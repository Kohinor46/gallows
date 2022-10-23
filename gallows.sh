#!/bin/bash
mask=$(echo $1 | sed "s/?/*/g")
#получаю список слов по маске с первой страницы
str=$(curl -s https://bezbukv.ru/mask/$mask)
#проверяю количество страниц для парсинга
count_page=$(echo $str | grep -E -i -w -o 'last.*page=[0-9]+' | grep -E -i -o 'e=[0-9]+' | grep -E -i -o '[0-9]+')
#создаю файл для хранения списка
touch $(date +%m-%d-%Y).txt
#парсилка слов
echo $str | grep -E -i -o '<b>[0-9]+<\/b>\. [а-я]+' | grep -E -i -o '[а-я]+' > $(date +%m-%d-%Y).txt
for (( i = 1; i <= count_page; i++ )); do
	#получаю список слов со следующей страницы
	str=$(curl -s https://bezbukv.ru/mask/$mask?page=$i)
	#парсилка ответа
	echo $str | grep -E -i -o '<b>[0-9]+<\/b>\. [а-я]+' | grep -E -i -o '[а-я]+' >> $(date +%m-%d-%Y).txt
done
r=$(cat $(date +%m-%d-%Y).txt)
#убираю слова содержащие буквы которых нет
for i in $2; do
	r=$(echo "$r" | grep -v "$i")
done
#убираю слова в которых нет букв которые есть, но их место неизвестно
for i in $3; do
	r=$(echo "$r"| grep $i)
done
#отдаю результат
echo "$r"
#считаю количество букв для определения наиболее оптимального слова
alphabet="а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ы ь э ю я"
for i in $alphabet; do
	n=$(echo "$r" | grep $i | wc -l | sed 's/ //g')
	if [[ $n == "0" ]]; then
		continue
	fi
	echo "$i - $n"
done
