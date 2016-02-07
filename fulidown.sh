########################################################################################################################################################################
# die♂deutsche♂Orthopädie proundly presents
# ALL in ONE FuliDown Pronography Dump Script
# modified from all.in.one.sh
# 
# usage: 
# fulidown.sh [options] parameter
# 
# options: 
# 
# dump levels: 
# 	default: only gain info from opp.pk1024.net
# 	-d or --deep-analysis: deep analysis mode, will download file info from netdisks but NOT download any file from netdisks
# 	-D or --download: download mode, will download file info AND file from netdisks
# 
# oldforum/newforum: 
# 	default: traverse the new forum
# 	-O or --oldforum: traverse the old forum
# 		AND now you can define from which page to which page the script will dump: (added 15.11.25)
# 		--from=<frompage> AND/OR --to=<topage>
# 			will dump from FIRST page if <frompage> NOT defined
# 			will automatically determine LAST page if <topage> NOT defined
# 		--from and --to will JUST be VOID outside default mode and -S/--sidefield
# 		AND now you can define from which SINGLE page the script will dump: (added 15.11.28)
# 		--page=<page>
# 			equals --from=<page> AND --to=<page>
# 
# pages/threads: 
# default: dump all pages within pages specified above
# -T or --thread: dump single thread, will override page settings
# 
# download preview pictures: (added 15.10.04)
# 	-P or --pictures: download preview pictures from opp.pk1024.net or elsewhere, needs -D/--download
#
# save file info into webpage: (added 15.10.04)
#	-W or --webpage: save the thread file into <tid>.html inside its folder, needs -D/--download AND -P/--pictures
# 
# auto-unpack: (added 15.11.20)
# 	-A or --auto-unpack: attempt to unpack the .rar/.zip files
# 	usin' the password default password 1024
# 		if succeed, the original .rar/.zip will be deleted
# 		if failed due to incorrect password, 
# 		the original .rar/.zip will be left unchanged
# 	needs -D/--download
# 
# encryption: (added 15.11.20)
# 	-E or --encrypt: after download, calculate MD5, SHA1 and SHA256 of 
# 	<tid> directory and store individially, archive <tid> directory into a
# 	 .rar file with random 64-bit password, delete source files, and 
# 	 store filename-password infomations into pair.txt, needs -D/--download
# 
# limitation: (added 15.11.29)
# 	--limitation=<limitation>: after each page, check if total file size
# 	exceeds the limitation, if so the script will be stopped
# 		the unit of the limitation is MB
# 
# Theorically you CAN put contradictin' options together, 
# but ONLY the LAST ones will be accepted as final options
# 
# help: 
# 	-H or -h or --help: ask for help, just like other Linux programs
# 
# parameter (fid/tid): 
# 	fid: FuliDown Field ID
# 	tid: FuliDown Thread ID
# 
# HAVE A NICE DUMP, die♂deutsche♂Orthopädie out
# 
# ps. 
# 	长发都tm是怪物
# 	long hair girls are all fuckin' monsters
# 	短发才tm是萌妹
# 	short hair girls are all fuckin' moe girls
# 	短发大法好
# 	VIVA LA SHORT HAIR
########################################################################################################################################################################

########################                          Parameter Analysis                           ########################
parameters=`getopt -o dhCDNTHPWAEO -a -l deep-analysis,download,customlink,oldforum,thread,help,pictures,webpage,auto-unpack,encrypt,from:,to:,page:,limitation: -- "$@"`

if [ $? != 0 ]
then  
    echo "Houston, we have a problem: Unrecognized Option Detected, Terminating....." >&2  
    exit 1  
fi

eval set -- "$parameters" 

dlevel=0 # by default
mode=0 # by default
threadmode=0 # by default
picmode=0 # by default
webmode=0 # by default
autounpackmode=0 # by default
encryptmode=0 # by default
limitation=10000000 # by default, it's about 10TB

while true  
do  
    case "$1" in  
        -d | --deep-analysis)
			dlevel=1
            shift
            ;;  
        -D | --download)
			dlevel=2
            shift
            ;;  
		-O | --oldforum)
			mode=1
            shift
            ;;  
		-T | --thread)
			threadmode=1
            shift
            ;;
		-P | --pictures)
			picmode=1
			shift
			;;
		-W | --webpage)
			webmode=1
			shift
			;;
		-A | --auto-unpack)
			autounpackmode=1
			shift
			;;
		-E | --encrypt)
			encryptmode=1
			shift
			;;
		--from)
			from=$2
			shift 2
			;;
		--to)
			to=$2
			shift 2
			;;
		--page)
			from=$2
			to=$2
			shift 2
			;;
		--limitation)
			limitation=$2
			shift 2
			;;
		--attachment)
			dumpattachment=1
			shift
			;;
		-h | -H | --help)  
			echo "die♂deutsche♂Orthopädie proundly presents"
			echo "ALL in ONE FuliDown Pronography Dump Script"
			echo "modified from all.in.one.sh"
			echo
			echo "usage: "
			echo "fulidown.sh [options] parameter"
			echo
			echo "options: "
			echo
			echo "dump levels: "
			echo "	default: only gain info from dindingo.com"
			echo "	-d or --deep-analysis: deep analysis mode, will download file info from colayun.com aka colafile.com but NOT download any file from colafile"
			echo "	-D or --download: download mode, will download file info AND file from colayun.com aka colafile.com"
			echo
			echo "oldforum/newforum: "
			echo "	default: traverse the new forum"
			echo "	-O or --oldforum: traverse the old forum"
			echo "		AND now you can define from which page to which page the script will dump: (added 15.11.25)"
			echo "		--from=<frompage> AND/OR --to=<topage>"
			echo "			will dump from FIRST page if <frompage> NOT defined"
			echo "			will automatically determine LAST page if <topage> NOT defined"
			echo "		--from and --to will JUST be VOID outside default mode and -S/--sidefield"
			echo "		AND now you can define from which SINGLE page the script will dump: (added 15.11.28)"
			echo "		--page=<page>"
			echo "			equals --from=<page> AND --to=<page>"
			echo
			echo "pages/threads: "
			echo "	default: dump all pages within pages specified above"
			echo "	-T or --thread: dump single thread, will override page settings"
			echo
			echo "download preview pictures: (added 15.10.04)"
			echo "	-P or --pictures: download preview pictures from opp.pk1024.net or elsewhere, needs -D/--download"
			echo
			echo "save file info into webpage: (added 15.10.04)"
			echo "	-W or --webpage: save the thread file into <tid>.html inside its folder, needs -D/--download AND -P/--pictures"
			echo 
			echo "auto-unpack: (added 15.11.20)"
			echo "	-A or --auto-unpack: attempt to unpack the .rar/.zip files"
			echo "	usin' the password dumped from the thread page"
			echo "		if succeed, the original .rar/.zip will be deleted"
			echo "		if failed due to incorrect password, "
			echo "		the original .rar/.zip will be left unchanged"
			echo "	needs -D/--download"
			echo
			echo "encryption: (added 15.11.20)"
			echo "	-E or --encrypt: after download, calculate MD5, SHA1 and SHA256 of "
			echo "	<tid> directory and store individially, archive <tid> directory into a"
			echo "	.rar file with random 64-bit password, delete source files, and "
			echo "	store filename-password infomations into pair.txt, needs -D/--download"
			echo
			echo "limitation: (added 15.11.29)"
			echo "	--limitation=<limitation>: after each page, check if total file size"
			echo "	exceeds the limitation, if so the script will be stopped"
			echo "		the unit of the limitation is MB"
			echo
			echo "Theorically you CAN put contradictin' options together, "
			echo "but ONLY the LAST ones will be accepted as final options"
			echo
			echo "help: "
			echo "	-H or -h or --help: ask for help, just like other Linux programs"
			echo
			echo "parameter (fid/tid/folder/file): "
			echo "	fid: DinDinGo Field ID (10, 23, 116, 117, 118 are the prono fields, others are just fuckin' stupid camouflage)"
			echo "	tid: DinDinGo Thread ID"
			echo 
			echo "HAVE A NICE DUMP, die♂deutsche♂Orthopädie out"
			echo 
			echo "ps. "
			echo "	长发都tm是怪♂物"
			echo "	long hair girls are all fuckin' mons♂ters"
			echo "	短发才tm是萌♂妹"
			echo "	short hair girls are all fuckin' moe♂girls"
			echo "	短发大♂法好"
			echo "	VIVA♂LA SHORT HAIR"
			exit
            shift
            ;;  		
        --)
			parameter=$2
            shift  
            break  
            ;;  
        *)   
            echo "Internal error!"  
            exit 1  
            ;;  
        esac  
done

if [ -z "$parameter" ]
then
	echo "Houston, we have a problem: You MUST at least provide a parameter"
	exit 1
fi

if [ "$autounpackmode" == "1" ]
then # -E
if [ ! "$dlevel" == "2" ]
	then # -E & !-D
		echo "Houston, we have a problem: You CANNOT use -A/--auto-unpack without usin' -D/--download"
		exit 1
	fi
fi

if [ "$encryptmode" == "1" ]
then # -E
if [ ! "$dlevel" == "2" ]
	then # -E & !-D
		echo "Houston, we have a problem: You CANNOT use -E/--encrypt without usin' -D/--download"
		exit 1
	fi
fi

if [ "$picmode" == "1" ]
then # -P
if [ ! "$dlevel" == "2" ]
	then # -P & !-D
		echo "Houston, we have a problem: You CANNOT use -P/--pictures without usin' -D/--download"
		exit 1
	fi
fi

if [ "$webmode" == "1" ] 
then # -W
	if [ ! "$picmode" == "1" ]
	then # -W & !-P
		echo "Houston, we have a problem: You CANNOT use -W/--webpage without usin' -P/--pictures"
		exit 1
	else # -W & -P
		if [ ! "$dlevel" == "2" ]
		then # -W & -P & !-D
			echo "Houston, we have a problem: You CANNOT use -W/--webpage without usin' -D/--download" # 我向我短发姐姐的短♂发发誓执行不到这段代码（手动再见
			exit 1
		fi
	fi
fi

########################                          Parameter Analysis ends                           ########################

########################                          Cookies                           ########################
colafile_cookies="/tmp/colafile_cookies.txt"

the_163file_cookies="/tmp/163file_cookies.txt"

the_163file_username=""

the_163file_password=""

curl -c $the_163file_cookies -d "action=login&task=login&formhash=95d3049b&username=$the_163file_username&password=$the_163file_password" "http://www.163file.com/account.php" > /dev/null
########################                          Cookies ends                           ########################

########################                          Function: Generate Password                            ########################
function GeneratePW { 
	len=64
	str=(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0 短 发 大 法 好 \! \@ \# \$ \% \^ \& \* \( \) \- \_ \= \+ \\ \/ \' \" \; \: \[ \] \{ \} \, \. \?)
	for((i=1;i<=$len;i++))
	do
		arr[$i]=${str[$[$RANDOM%87]]}
	done
	echo "${arr[@]}"|tr -d " "
}
########################                          Function: Generate Password ends                            ########################

########################                          Function: Determine Last Page                            ########################
function dLastPage() # only be called in mainfield mode or sidefield mode
{
	fid=$1
	magicNumber=3 # don't ask me why 23333333333333
	case $mode in  
	0) # new forum
		echo $(curl "http://opp.pk1024.net/pw/thread.php?fid=$fid" | sed 's/>/\n/g ' | grep -m 1 -Eo "[0-9]\/[0-9]* " | sed 's/ //g ' | sed 's/1\///g ')
		if [ -z $lastpage ]
		then
			echo $magicNumber
		fi
		;;  
	1) # old forum
		echo $(curl "http://opp.pk1024.net/bbs/forum-$fid-1.html" | sed 's/>/\n/g ' | grep -m 1 -Eo "[0-9]\/[0-9]*" | sed 's/ //g ' | sed 's/1\///g ')
		if [ -z $lastpage ]
		then
			echo $magicNumber
		fi
		;;  
	*)   
		echo "Internal error!"
		exit 1  
		;;
	esac  
}
########################                          Function: Determine Last Page ends                            ########################

########################                          Function: Process Download Link                            ########################
function processDLLink() # will only be called when dlevel > 0
{
	singlelink=$1
	singlelink=${singlelink//colafile/coladrive}
	singlelink=${singlelink//colayun/coladrive}
	curl -b $colafile_cookies $singlelink > /tmp/temp.txt
	#rawlinkinfo=$(curl -b $colafile_cookies $singlelink)
	
	########################                          filename                           ########################
	#filename=$(grep -Eo "<div class=\"new-download-file-title\">.*<\/div>" /tmp/temp.txt | sed 's/<div class=\"new-download-file-title\">//g ' | sed 's/<\/div>//g ' )
	filename=$(grep -Eo "<div class=\"new-download-file-title\">.*<\/div>" /tmp/temp.txt | sed 's/<div class=\"new-download-file-title\">//g ' | sed 's/<\/div>//g ' )
	#filename=$(echo $rawlinkinfo | grep -Eo "<div class=\"new-download-file-title\">.*<\/div>" | sed 's/<div class=\"new-download-file-title\">//g ' | sed 's/<\/div>//g ' )
	echo "原文件名：$filename"
	########################                          filename ends                           ########################

	########################                          extension                           ########################
	extension=$(echo $filename | grep -Eo "part[0-9]*\..*")
	if [ -z "$extension" ]
	then
		extension=${filename##*.} 
	fi
	#echo $extension
	########################                          extension ends                           ########################

	########################                          link                           ########################
	# link=$(grep -Eo "http://vip.d.colayun.com.*\">" /tmp/temp.txt | sed 's/\">//g ')
	link=$(grep -Eo "http://vip.d.down002.com.*\">" /tmp/temp.txt | sed 's/\">//g ')
	# link=$(grep -Eo "http://vip.bak.d.down002.com.*\">" /tmp/temp.txt | sed 's/\">//g ')
	#link=$(echo $rawlinkinfo | grep -Eo "http://vip.d.colayun.com.*\">" | sed 's/\">//g ')
	echo "直链（很快就会失效，下载请用-D/--download选项）：$link"
	#echo $folder.$extension
	if [ "$dlevel" == "2" ]
	then
		wget $link -O "$filename"
	fi
	########################                          link ends                           ########################

	########################                          size                           ########################
	size=$(grep -Eo "<div class=\"new-download-file-size\">.*<\/div>" /tmp/temp.txt | sed 's/<div class=\"new-download-file-size\">//g ' | sed 's/<\/div>//g ' )
	#size=$(echo $rawlinkinfo | grep -Eo "<div class=\"new-download-file-size\">.*<\/div>" | sed 's/<div class=\"new-download-file-size\">//g ' | sed 's/<\/div>//g ' )
	if  [ "$autounpackmode" == "0" ] && [ "$dlevel" == "2" ]
	then
		echo "文件大小：$size<br />">> "$folder.html"
	fi
	# used for statistics
	echo "文件大小：$size"
	if [ "$size" == "${size% M}" ] # not xxx M
	then
		if [ "$size" == "${size% K}" ] # not xxx K
		then
			if [ "$size" == "${size% G}" ] # not xxx G
			then
				echo "WTF? "
			else
				size=${size//G/* 1000} # convert GB to MB
			fi
		else
			size=${size//K/\/ 1000} # convert KB to MB
		fi
	else
		size=${size% M}
	fi
	totalsize="$totalsize + ${size% M}"
	totalsize_in_page="$totalsize_in_page + ${size% M}"
	########################                          size ends                           ########################
	echo
}
########################                          Function: Process Download Link ends                            ########################

########################                          Function: Process Download Link for 163file                           ########################
function processDLLink_163file()
{
	singlelink=$1
	curl -b $the_163file_cookies $singlelink -o /tmp/temp.txt
	#rawlinkinfo=$(curl -b $colafile_cookies $singlelink)
	
	########################                          filename                           ########################
	#filename=$(grep -Eo "<div class=\"new-download-file-title\">.*<\/div>" /tmp/temp.txt | sed 's/<div class=\"new-download-file-title\">//g ' | sed 's/<\/div>//g ' )
	filename=$(grep -Eo "<h4>.*</h4>" /tmp/temp.txt | sed 's/<h4>文件下载//g ' | sed 's/<\/h4>//g ' | sed 's/&nbsp;&nbsp;//g ')
	#filename=$(echo $rawlinkinfo | grep -Eo "<div class=\"new-download-file-title\">.*<\/div>" | sed 's/<div class=\"new-download-file-title\">//g ' | sed 's/<\/div>//g ' )
	echo "原文件名：$filename"
	########################                          filename ends                           ########################

	########################                          extension                           ########################
	extension=$(echo $filename | grep -Eo "part[0-9]*\..*")
	if [ -z "$extension" ]
	then
		extension=${filename##*.} 
	fi
	#echo $extension
	########################                          extension ends                           ########################

	########################                          link                           ########################
	fileid=$(echo $singlelink | grep -Eo "file-[0-9]*" | grep -Eo "[0-9]*")
	link=$(curl -b $the_163file_cookies -d "action=load_down_addr2&file_id=$fileid" "http://www.163file.com/ajax.php")
	# link=$(echo $link | sed 's/"/\n/g ' | grep -Eo "http://haiwai.163file.com.*")
	link=$(echo $link | sed 's/"/\n/g ' | grep "vip")
	#link=$(curl -b $the_163file_cookies -d "action=load_down_addr2&file_id=$fileid" "http://www.163file.com/ajax.php" | sed 's/"/\n/g ' | grep -Eo "http://haiwai.163file.com.*")

	echo "直链（很快就会失效，下载请用-D/--download选项）：$link"
	if [ "$dlevel" == "2" ]
	then
		wget $link -O "$filename"
	fi
	########################                          link ends                           ########################

	########################                          size                           ########################
	size=$(grep -Eo "<b>文件大小：</b>.*[M|G|K]" /tmp/temp.txt | sed 's/<b>文件大小：<\/b>//g ')
	#size=$(echo $rawlinkinfo | grep -Eo "<div class=\"new-download-file-size\">.*<\/div>" | sed 's/<div class=\"new-download-file-size\">//g ' | sed 's/<\/div>//g ' )
	# used for statistics
	echo "文件大小：$size"
	if [ "$size" == "${size% M}" ] # not xxx M
	then
		if [ "$size" == "${size% K}" ] # not xxx K
		then
			if [ "$size" == "${size% G}" ] # not xxx G
			then
				echo "WTF? "
			else
				size=${size//G/* 1000} # convert GB to MB
			fi
		else
			size=${size//K/\/ 1000} # convert KB to MB
		fi
	else
		size=${size% M}
	fi

	totalsize="$totalsize + ${size% M}"
	totalsize_in_page="$totalsize_in_page + ${size% M}"
	########################                          size ends                           ########################
	echo
}
########################                          Function: Process Download Link for 163file ends                            ########################

########################                          Function: Process Single Thread (novus)                         ########################
function processSingleThread()
{	
	case $mode in  
		0)  
			tid=$1 # the tid is formatted as fid.date(YYMM).tid, need to convert to fid/date(YYMM)/tid
			#echo "http://www.dindingo.com/bbs/read.php?tid-$tid.html"
			downloaded=$(curl "http://opp.pk1024.net/pw/htm_data/${tid//.//}.html")
			folder=$tid
			;;
		1)  
			tid=$1
			#echo "http://www.dindingo.com/bbs/read.php?tid-$tid.html"
			downloaded=$(curl "http://opp.pk1024.net/bbs/thread-$tid-1-1.html")
			folder=$tid
			;;
		2)  
			echo "Not Finished"
			;;
		*)   
			echo "Internal error!"  
			exit 1  
			;;
	esac	
	#if [ ! -z "$(grep -Eo "下载地址：.*</div>" $filepath)" ]
	if [ -d "$folder" ]
	then
		echo "$folder already exists. "
	fi
	########################                          Dump instructions                         ########################
	# just simply add other if-then-fi blocks here to enable non-colafile content dumps
	# just simply add other if-then-fi blocks here to enable non-colafile content dumps
	# format:
	# 	if [ ! -z $(sign_appeared) (e. g. `echo $downloaded | grep -Eo "attachment-regexp-here" | postprocessin'`) ] && [ "$dlevel" == "2" ] (or whatever switch used to enable attachment dumps)
	# 	then
	# 		mkdir attachments
	# 		attachmentlink=$(echo $downloaded | grep -Eo "attachment-regexp-here" | postprocessin'2`)
	# 		dump $attachmentlink -O "attachments/$tid.rar" or whatever
	# 	fi
	# just simply add other if-then-fi blocks here to enable non-colafile content dumps
	########################                          Dump instructions ends                         ########################
	########################                          Dump from netdisks                         ########################
		if [ "$dlevel" == "2" ]
		then
			mkdir $folder
			cd $folder
			########################                          dl webpage                           ########################
			if [ "$picmode" == "1" ] && [ "$webmode" == "1" ]
			then
				case $mode in  
					0)  
						curl -o "$tid.html" "http://opp.pk1024.net/pw/htm_data/${tid//.//}.html"
						;;
					1)  
						curl -o "$tid.html" "http://opp.pk1024.net/bbs/thread-$tid-1-1.html"
						;;
					2)  
						echo "Not Finished"
						;;
					*)   
						echo "Internal error!"  
						exit 1  
						;;
				esac	
			fi
			########################                          dl webpage ends                           ########################
		fi
		echo
		
		########################                          dl link                           ########################
		for singlelink in $(echo $downloaded | sed 's/<br/\n/g ' | sed 's/<\/div>/\n/g ' | grep -Eo "http.*colafile.*\"" | grep -Eo "http.*colafile.com/file/[0-9][0-9][0-9][0-9]*") # colafile
		do
			echo $singlelink
			if [ "$dlevel" == "1" ] || [ "$dlevel" == "2" ]
			then
				processDLLink $singlelink
			fi
		done
		
		for singlelink in $(echo $downloaded | sed 's/<br/\n/g ' | sed 's/<\/div>/\n/g ' | grep -Eo "http.*163file.*\"" | sed 's/" target="_blank"//g ') # 163file
		do
			echo $singlelink
			if [ "$dlevel" == "1" ] || [ "$dlevel" == "2" ]
			then
				processDLLink_163file $singlelink
			fi
		done
		
		if [ "$dlevel" == "0" ]
		then
			echo
		fi

		########################                          dl link ends                           ########################
		if [ "$dlevel" == "2" ]
		then
			if [ "$autounpackmode" == "1" ]
			then
				password="1024" # mostly
				echo "NORMAL UNPACK"
				for rarfile in `echo *.rar`
				do
					/root/rar/rar x -ts -p"$password" "$rarfile"
					if  [ "$?" == "0" ]
					then
						rm -f "$rarfile"
					fi
				done
				for zipfile in `echo *.zip`
				do
					LANG=C 7za x -p"$password" "$zipfile"
					if  [ "$?" == "0" ]
					then
						rm -f "$zipfile"
					fi
					convmv -f GBK -t utf8 --notest -r .
				done
			fi
			
			if [ "$encryptmode" == "1" ]
			then
				# md5sum *.* > /tmp/md5
				find  -type f -print0 | xargs -0 md5sum > /tmp/md5
				# sha1sum *.* > /tmp/sha1
				find  -type f -print0 | xargs -0 sha1sum > /tmp/sha1
				# sha256sum *.* > /tmp/sha256
				find  -type f -print0 | xargs -0 sha256sum > /tmp/sha256
				mv /tmp/md5 $folder.md5
				mv /tmp/sha1 $folder.sha1
				mv /tmp/sha256 $folder.sha256
			fi
			
			cd ..
			
			if [ "$encryptmode" == "1" ]
			then
				password=`GeneratePW`
				# /root/rar/rar a -htb -m0 -ma5 -rr5 -ts -hp"$password" "$folder.rar" $folder
				currentdate=`date +%y.%m.%d`
				/root/rar/rar a -df -v2.33g -v1g -htb -m0 -ma5 -rr5 -ts -hp"$password" "$folder.$currentdate.rar" $folder
				echo "$folder♂$currentdate♂$password" > "pair.$folder.$currentdate.txt"
				echo "$folder♂$currentdate♂$password" >> pair.txt
			fi
		fi
		echo "SINGLE PAGE ENDS"
		echo
	########################                          Dump from netdisks ends                         ########################
}
########################                          Function: Process Single Thread (novus) ends                         ########################

########################                          Main Program                            ########################
totalsize="0"
if [ "$dlevel" == "3" ]
then
	mkdir DumpedThreads
fi

case $threadmode in
	0)
		if [ -z $from ]
		then
			from=1
		fi
		if [ -z $to ]
		then
			to=$(dLastPage $parameter)
		fi
		echo "From: Page $from"
		echo "To: Page $to"
		#echo "lastpage: $lastpage"
		for page in $(seq $from $to)
		do
			totalsize_in_page="0"
			echo "Page $page: "
			echo
			#echo $page
			case $mode in  
				0) # new forum
					for tid in $(curl "http://opp.pk1024.net/pw/thread.php?fid=$parameter" | sed 's/<\/h3>/<\/h3>\n/g ' | grep -Eo "<h3>.*</h3>" | grep -Eo "htm_data.*.html")
					do
						tid=${tid////.}
						tid=${tid//htm_data./}
						tid=${tid//.html/}
						processSingleThread $tid
						# sleep $timeinterval
					done
					;;
				1) # old forum
					for tid in $(curl "http://opp.pk1024.net/bbs/forum-$parameter-$page.html" | sed 's/<\/a>/<\/a>\n/g ' | grep -Eo "<td class=\"f_folder\"><a.*<\/a>" | grep -Eo "thread-.*.html")
					do
						processSingleThread $tid
						# sleep $timeinterval
					done
					;;
				*)   
					echo "Internal error!"
					exit 1
				;;
			esac
			echo "Page $page ends. "
			if [ "$dlevel" == "1" ] || [ "$dlevel" == "2" ]
			then
				totalsize_in_page=`echo $totalsize_in_page | bc -q`
				echo "Total file size in page $page: $totalsize_in_page MB"
				totalsize=`echo $totalsize | bc -q`
				echo "Total file size until this page: $totalsize MB"
				det=`echo "$totalsize >= $limitation" | bc -q`
				# echo "result for \"$totalsize >= $limitation\" : $det"
				if [ "$det" == "1" ]
				then
					echo
					echo "Total file size exceeded size limitation, "
					echo "and the script will be stopped. "
					echo "Total file size in this dump session: $totalsize MB"
					exit 2333
				fi
			fi
			# sleep $timeinterval
			# page=`expr $page + 1`
			let page+=1
			# ((page++))
			# page=$[$page+1]
			# page=$(( $page + 1 ))
			echo
		done
		;;
	1)
		processSingleThread $parameter
		# sleep $timeinterval
		;;	
	*)   
		echo "Internal error!"
		exit 1
		;;
esac
if [ "$dlevel" == "1" ] || [ "$dlevel" == "2" ]
then
	echo
	totalsize=`echo $totalsize | bc -q`
	echo "Total file size in this dump session: $totalsize MB"
fi
rm -f $the_163file_cookies $colafile_cookies
########################                          Main Program ends                            ########################
