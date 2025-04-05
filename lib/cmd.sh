#!/usr/bin/env bash
__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base.sh"
load_lib "exception"


run_as(){
        local _user="$1"
        shift
        local _cmd="$*"

        getent passwd "$_user" &> /dev/null
        [[ $? -eq 0 ]] || raise InvalidUserException "Specified user doesn't exists."

        sudo -u $_user bash -c -- "$_cmd"
	return $?
}

