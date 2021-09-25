#!/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 E='echo -e';    # -e включить поддержку вывода Escape последовательностей
 e='echo -en';   # -n не выводить перевод строки
 trap "R;exit" 2 # 
    ESC=$( $e "\e")
   TPUT(){ $e "\e[${1};${2}H" ;}
  CLEAR(){ $e "\ec";}
# 25 возможно это 
  CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
MARK(){ $e "\e[102m";}
# 0 это цвет списка
 UNMARK(){ $e "\e[31m";}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
# R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";}; # в этом варианте закрашивается весь фон терминала
# R(){ CLEAR ;stty sane;$e "\ec\e[0;45m\e[";};   # в этом варианте закрашивается только фон меню
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm="\033[31m+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+\033[0m"
HEAD(){ for (( a=2; a<=24; a++ ))
 do
  TPUT $a 1
       $E "\033[31m\xE2\x94\x82                                                         \xE2\x94\x82\033[0m";
 done
 TPUT 3 2
        $E "\033[1;32m  [ ] Tor \033[0m \033[31m";
 TPUT 5 2
        $E "\033[32m Cервис Tor\033[31m";
 TPUT 9 2
        $E "\033[32m toriptables2\033[31m";
 TPUT 16 2
        $E "\033[32m Bнешний IP-адрес\033[31m";
 TPUT 22 2
        $E "\033[32m Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter\033[31m";
 MARK;TPUT 1 1
        $E "$mm";UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
 FOOT(){ MARK;TPUT 25 1
        $E "$mm";UNMARK;}
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then 
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]];then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
#
 M0(){ TPUT  6 3; $e " \033[31m[ 0] Установка сервиса                               \033[0m";}
 M1(){ TPUT  7 3; $e " \033[31m[ 1] Запуск/остановка cервиса                        \033[0m";}
 M2(){ TPUT  8 3; $e " \033[31m[ 2] Добавить службу Tor в автозагрузку              \033[0m";}
#
 M3(){ TPUT 10 3; $e " \033[31m[ 3] Установка toriptables2                          \033[0m";}
 M4(){ TPUT 11 3; $e " \033[31m[ 4] Использование                              usage\033[0m";}
 M5(){ TPUT 12 3; $e " \033[31m[ 5] Перенаправления всего TCP трафика через сеть Tor\033[0m";}
 M6(){ TPUT 13 3; $e " \033[31m[ 6] Выходить в Интернет не используя сеть Tor       \033[0m";}
 M7(){ TPUT 14 3; $e " \033[31m[ 7] Изменит схему и даст новый IP-адрес             \033[0m";}
 M8(){ TPUT 15 3; $e " \033[31m[ 8] Выведет текущий публичный  IP-адрес             \033[0m";}
#
 M9(){ TPUT 17 3; $e " \033[31m[ 9] ifconfig                                        \033[0m";}
M10(){ TPUT 18 3; $e " \033[31m[10] opendns                                         \033[0m";}
M11(){ TPUT 19 3; $e " \033[31m[11] host                                            \033[0m";}
M12(){ TPUT 20 3; $e " \033[31m[12] google                                          \033[0m";}
M13(){ TPUT 21 3; $e " \033[31m[13] wget                                            \033[0m";}
#
M14(){ TPUT 23 3; $e " \033[31m[14] EXIT                                            \033[0m";}
LM=14
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
   0) S=M0 ;SC;if [[ $cur == enter ]];then R;echo " sudo apt-get install tor ";ES;fi;;
   1) S=M1 ;SC;if [[ $cur == enter ]];then R;echo "
 sudo systemctl start tor
#
 sudo systemctl stop tor
 ";ES;fi;;
   2) S=M2 ;SC;if [[ $cur == enter ]];then R;echo " sudo systemctl enable tor";ES;fi;;
   3) S=M3 ;SC;if [[ $cur == enter ]];then R;echo "
 git clone https://github.com/ruped24/toriptables2
 cd toriptables2/
 sudo mv toriptables2.py /usr/local/bin/
 cd
#
 sudo apt install python2 
";ES;fi;;
   4) S=M4 ;SC;if [[ $cur == enter ]];then R;echo "
 toriptables2.py -h
#
 toriptables2.py --help";ES;fi;;
   5) S=M5 ;SC;if [[ $cur == enter ]];then R;echo "
 sudo toriptables2.py -l
#
 sudo toriptables2.py --load";ES;fi;;
   6) S=M6 ;SC;if [[ $cur == enter ]];then R;echo "
 sudo toriptables2.py -f
#
 sudo toriptables2.py --flush";ES;fi;;
   7) S=M7 ;SC;if [[ $cur == enter ]];then R;echo "
 sudo toriptables2.py -r
#
 sudo toriptables2.py --refresh";ES;fi;;
   8) S=M8 ;SC;if [[ $cur == enter ]];then R;echo "
 sudo toriptables2.py -i
#
 sudo toriptables2.py --ip";ES;fi;;
   9) S=M9 ;SC;if [[ $cur == enter ]];then R;echo "
 curl ifconfig.me
#
 curl ifconfig.me/ip
";ES;fi;;
  10) S=M10 ;SC;if [[ $cur == enter ]];then R;echo "
 host myip.opendns.com resolver1.opendns.com
";ES;fi;;
  11) S=M11 ;SC;if [[ $cur == enter ]];then R;echo "
 host myip.opendns.com resolver1.opendns.com
";ES;fi;;
  12) S=M12 ;SC;if [[ $cur == enter ]];then R;echo "
 dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'\"' '{ print \$2}'
";ES;fi;;
  13) S=M13 ;SC;if [[ $cur == enter ]];then R;echo "
 wget -qO- eth0.me
 wget -qO- ipinfo.io/ip
 wget -qO- ipecho.net/plain
 wget -qO- icanhazip.com
 wget -qO- ipecho.net
 wget -qO- ident.me
 wget -qO- myip.gelma.net
";ES;fi;;
#
  14) S=M14;SC;if [[ $cur == enter ]];then R;ls -l;exit 0;fi;;
 esac;POS;done
