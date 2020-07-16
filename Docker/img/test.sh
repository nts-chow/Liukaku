#ÅI/bin/bash

GET_USER=$1
NEED_PARAM=1
echo $NEED_PARAM
########################################################
INPUT_DATE='/bin/date'
INPUT_FILE="/bin/date"
########################################################
readonly NEED_PARAM
unset NEED_PARAM
echo ${#NEED_PARAM}
########################################################
:<<EOF
íçéﬂ
íçéﬂ
EOF
########################################################
cat <<EOF
hello,world
EOF
########################################################
cat <<-EOF
hello,world
	EOF
########################################################
:<<'
íçéﬂ
íçéﬂ
'
########################################################
-eq =, -ne ÅÇ,-gt >,-lt < -le <=
########################################################
BASH_DIR=`/usr/bin/dirname $0`
. ${BASE_DIR}/FRW001UCD.sh -d0 1
${BASE_DIR}/FRW001UCD.sh -r JABORT
########################################################
function fun(){
	echo "123456"
}

fun
########################################################
echo ${GET_UID}":"${GET_SHELL}":"${GET_BASH}|tee -a ${OUTPUT_FILE1}

if [ $? -ne 0 ]; then
	MESSAGE_OUTPUT "0003"
	exit 1
fi	
########################################################
if [ $AAA -ne 0 ]; then
	date
elif [ $BBB -ne 0 ]; then	
	date
else
	date
fi
########################################################
if test -e ./bash.txt -o -e ./notfile
if test -e ./bash.txt -a -e ./notfile
then
	echo "is file"
else
	echo "is not file"
fi

if [ ! $? -ne 0 ]; then
	echo "ok"
fi
########################################################
if [ $sta=a $stb=b ]; then echo "1234567890"
if [ $sta=a ] && [ $stb=b ]; then echo "123"
if [ $sta=a -o $stb=b ]; then echo "123"
if [ $sta=a ] || [ $stb=b ]; then echo "123"
########################################################
if test ${num1} = ${num2}           --- !=
then
	echo "equal"
else
	echo "is not"
fi
########################################################
if [ -n "äøéö" ]; then          ----- -z
if [ ! -r $CNL_ZAI657HG7724 ]   ------read å†å¿
then
	$FRW00_BATCH_BIN/FRW00CCC001 -s E -j 1 -m
	$FRW00_BATCH_BIN/FRW00CCC002 -s -E -i
	exit $EXIT_NG	
fi
########################################################
case $a in 
a)
	free  
b)
	find /etc -name httpd.confÅ@
*)
	whereis vim
	;;
esac
########################################################
declare -i NUM_0
while [ $NUM -lt 10 ]
do
	NUM=$(($NUM+1))
	let NUM=$NUM +1
	NUM=$[ $NUM+1 ]
	yum install package_name
	rpm -ivh package.rpm               ----à¿ëïàÍò¢rpmïÔ 
done
########################################################
for i in {1..10}
for i in $(seq 1 10)
for ((i=1; i<=10; i++))
for i in `ls`
do
	mv dir1 new_dir
	echo ${i}
done
########################################################
select program in `ls -F` pwd date
do
	$program
done
########################################################
NUMS=(1 2 3 4 5 6 7)
a=${NUMS[0]}

for days in ${NUMS[*]}
do
	mount /dev/fd0 /mnt/floppy 
	echo $days
done
########################################################
for i in ${!NUMS[@]}
do
	echo $NUMS[$i]
done
########################################################
declare -i i=0
while [$i -lt ${#names[*]}]
do
	echo ${names[$i]}
	let i ++
done
########################################################
declare -i a=0
util [ ! $a -lt 10 ] && [ $a -ge 10 ]
do
	echo $a
	a=`expr $a + 1`
done
########################################################
while :
do
	echo -n "imput num pls"
	read aNum
	case $aNum in
	1|2|3|4|5|6)
		echo $aNum
	;;
	*)
	continue
		echo "is worng"
	break1 break2 break3 break4
	;;
done
########################################################
function fun(){
	echo "pls input 1"
	read num1
	echo "pls input 2"
	read num2
	return $(($num1+$num2))
}

fun
echo "sum is $? !"
########################################################
function fun(){
	echo ${1}
	echo ${2}
	echo $#
	echo $*
	return 1
}

fun 45
echo "sum is $? !"

fun 12 33 44 55
########################################################
sed '1d' hosts
sed '1,3d' hosts
sed -ri '2p' hosts
########################################################
awk 'BEGIN{print 1}{print "ok"} END{print "++++++++++++"}'
awk 'BEGIN{FS=":"} {print $1} END{print "+++++++++"}'
awk -F":" '{
	if($3>1)
	{print $0}
	else
	{print $1}
}' profile
########################################################
#!/bin/bash
decalre -i num=0
while read -r line
do
	echo ${line}
	num=$(($num+1))
done < $1
echo "$num $1"
########################################################
for line in `cat file1`
do
	echo $line
done
########################################################
#!/bin/bash
.xxxx
########################################################
grep 'root' passwd

########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################