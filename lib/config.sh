#!/usr/bin/env bash
__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base.sh"
load_lib "logger"
load_lib "exception"

# read config, if exists, return file content with removed:
# commented lines
# empty lines
# whitespaces at start and end of line
read_config_by_lines(){
	local config_name="$1"
	config_file="$__CONFIG_DIR__/$config_name"

	[ -z "$config_name" ] && raise ArgumentMissingException "Can't read config, name not provided."
	[ -f "$config_file" ] || raise InvalidValueException "Can't find config file."

	cat "$config_file" | sed -e '/^\s*#/d' -e '/^\s*$/d' -e 's/^\s*//' -e 's/\s*$//'
}


load_config_as_bash(){
	local config_name="$1"
	config_file="$__CONFIG_DIR__/$config_name"

	[ -z "$config_name" ] && raise ArgumentMissingException "Can't load config, name not provided."
	[ -f "$config_file" ] || raise InvalidValueException "Can't find config file."

	. "$config_file"
}


