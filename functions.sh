get_new_file_name()
{
	local NEW_FILE_NAME RC_CODE
	
	#test wich regex applies to the given filename
	for i in ${!FILE_REGEXS[@]}
	do
		#echo "testing ${1} with ${FILE_REGEXS[i]}"
		NEW_FILE_NAME=''
	    NEW_FILE_NAME="$(echo ${1} | egrep -o ${FILE_REGEXS[i]} )"
		if [ ! -z "${NEW_FILE_NAME}" ]
		then
			break
		fi
	done

	if [ ! -z "${NEW_FILE_NAME}" ]
	then
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
				NEW_FILE_NAME="Failed to identify pattern. Please, add a new one."
				RC_CODE=1
				;;
		esac
	fi
	echo "${NEW_FILE_NAME}"
	return ${RC_CODE}
}

extract_file()
{
	echo "extract file estou em $PWD"
	local extens="$( get_file_extension ${1} )"
	echo "extens = ${extens}"
	case "${extens}" in
		".rar")	echo "entrei no caso .rar"
				unrar e "${1}"
				;;
		".zip")	echo "entrei no caso .zip"
				unzip "${1}"
				;;
	esac
}

get_file_extension()
{
	echo "$( echo ${1} | grep -oE $EXTENSION_REGEX )"
}

check_file_in_list()
{
	local RC_CODE

	#set IFS for comparing
	IFS=':'

	#fetch
	for f in ${2}
	do
		#echo "comparing ${f} with ${1}"
		if [ "${f}" == "${1}" -a -z "${f}" ]
		then
			RC_CODE=0;
		fi
	done
	RC_CODE=1
	unset IFS
	return ${RC_CODE}
}
