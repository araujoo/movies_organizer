#constant list
readonly FILE_REGEXS=( '[sS][0-9]{2}[eE][0-9]{2}' '[0-9]{3}' '[0-9]x[0-9]{2}' '[0-9]{2}x[0-9]{2}' )
readonly EXTENSION_REGEX='\.[A-Za-z0-9]*$'
readonly COMPACT_EXTENSIONS=( ".rar" ".zip" )
readonly SUB_EXTENSIONS='.srt'
readonly MOV_EXTENSIONS='.mkv .mp4 .avi'
readonly SUBS_BKP_DIR='Subs'
readonly TORRENTS_BKP_DIR='Torrents'
readonly SOURCES_BKP_DIR='Sources'
readonly SPECIAL_CHARS_REGEX='[^A-Za-z0-9]'


#global var list
FILE_LIST=

#fatal error lists
readonly DEPENDENCIES_FAILURE=1
