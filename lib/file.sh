#!/usr/bin/env bash
__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base.sh"
load_lib "exception"


open_file(){
   local _file="$1"

   [ -z "$_file" ] && raise EmptyArgException "Argument value not supplied."
   [ -f "$_file" ] || raise InvaildFileException "Provided file is either invalid, or doesn't exists."

   declare -p __OPENED_FILES_CUR_LINE__ &> /dev/null || declare -Ag __OPENED_FILES_CUR_LINE__
   declare -p __OPENED_FILES_TOT_LINES__ &> /dev/null || declare -Ag __OPENED_FILES_TOT_LINES__
   declare -p __OPENED_FILES_NAMES__ &> /dev/null || declare -Ag __OPENED_FILES_NAMES__

   local _fd=$RANDOM

   while [[ ",`printf '%s,' "${!__OPENED_FILES_CUR_LINE__[@]}"`" =~ ,${_fd}, ]]; do
      _fd=$RANDOM
   done

   __OPENED_FILES_NAMES__[$_fd]="`realpath "$_file"`"
   __OPENED_FILES_CUR_LINE__[$_fd]=1
   __OPENED_FILES_TOT_LINES__[$_fd]="`wc -l --total=only "$_file"`"

   printf "%s" "$_fd"
}


has_next_line(){
   local _fd="$1"

   [ -z "$_fd" ] && raise EmptyArgException "Argument value not supplied."

   [[ ",`printf '%s,' "${!__OPENED_FILES_NAMES__[@]}"`" =~ ,${_fd}, ]] || raise InvalidFileDescriptorException "Provided file descriptor is invalid."

   [[ "${__OPENED_FILES_CUR_LINE__["$_fd"]}" -le "${__OPENED_FILES_TOT_LINES__["$_fd"]}" ]] && {
      echo /usr/bin/true;
      return true;
   } || {
      echo /usr/bin/false;
      return false;
   }
}


read_line(){
   local _fd="$1"

   has_next_line > /dev/null && {
      local n="${__OPENED_FILES_CUR_LINE__["$_fd"]}" ;
      sed -n "${n}p" "${__OPENED_FILES_NAMES__["$_fd"]}";
      n=$(( n + 1 )) ;
      __OPENED_FILES_CUR_LINE__["$_fd"]=$n
   } || raise EOLReachedException "Can't read, EOL reached."

}



peek_next_line(){}
seek_line(){}
seek_line_0(){}
close_file(){}

