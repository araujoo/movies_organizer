get_new_file_name()
{
	local NEW_FILE_NAME RC_CODE

	#test wich regex applies to the given filename
	for i in ${!FILE_REGEXS[@]}
	do
		#echo "testing ${1} with ${FILE_REGEXS[i]}"
		NEW_FILE_NAME=''
	    NEW_FILE_NAME="$(echo ${1} | egrep -o ${SPECIAL_CHARS_REGEX}${FILE_REGEXS[$i]}${SPECIAL_CHARS_REGEX}* )"
		if [ -n "${NEW_FILE_NAME}" ]
		then
			break
		fi
	done

	if [ -n "${NEW_FILE_NAME}" ]
	then

		#cleans the filename
		NEW_FILE_NAME="$( echo ${NEW_FILE_NAME} | sed "s:${SPECIAL_CHARS_REGEX}::g" )"
		case ${i} in
			0)
				NEW_FILE_NAME="$( echo ${NEW_FILE_NAME} | tr '[:lower:]' '[:upper:]' )"
				RC_CODE=0
				;;
			1)
				NEW_FILE_NAME="$(echo "S0${NEW_FILE_NAME:0:1}E${NEW_FILE_NAME:1:2}" )"
				RC_CODE=0
				;;
			2)  
				NEW_FILE_NAME="$(echo "S0${NEW_FILE_NAME:0:1}E${NEW_FILE_NAME:2:2}" )"
				RC_CODE=0
				;;
				
			3)  
				NEW_FILE_NAME="$(echo "S0${NEW_FILE_NAME:0:2}E${NEW_FILE_NAME:2:2}" )"
				RC_CODE=0
				;;
				
			*)
				NEW_FILE_NAME="${PATTERN_NOT_IDENTIFIED}"
				RC_CODE=1
				;;
		esac
	else
		NEW_FILE_NAME="${PATTERN_NOT_IDENTIFIED}"
		RC_CODE=1
		;;
	fi
	echo "${NEW_FILE_NAME}"
	return ${RC_CODE}
}

extract_file()
{
	local EXTENS
	#echo "extract file"
	EXTENS="$( get_file_extension ${1} )"
	#echo "extens = ${EXTENS}"
	case "${EXTENS}" in
		".rar")	unrar e "${1}" > '/dev/null'
				;;
		".zip")	unzip "${1}" > '/dev/null'
				;;
	esac
}

get_file_extension()
{
	echo "$( echo ${1} | grep -oE $EXTENSION_REGEX )"
}

check_file_in_list()
{
	local RC_CODE IFS

	#set IFS for comparison
	IFS=':'

	#fetch
	for f in ${2}
	do
		#echo "comparing ${f} with ${1}"
		if [ "${f}" == "${1}" ] && [ -n "${f}" ]
		then
			RC_CODE=0;
			break
		fi
	done
	return ${RC_CODE=1}
}

check_dependencies()
{
	echo -n "Checking dependencies"
	if [ $(bash --version > /dev/null && echo $?) -ne 0 ]
	then
		echo "missing bash"
		exit $DEPENDENCIES_FAILURE
	elif [ $(unrar --version > /dev/null && echo $?) -ne 0 ]
	then
		echo "missing unrar"
		exit $DEPENDENCIES_FAILURE
	elif [ $(unzip -v > /dev/null && echo $?) -ne 0 ]
	then
		echo "missing unzip"
		exit $DEPENDENCIES_FAILURE
	fi
	echo " ....OK"
}
