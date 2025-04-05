#!/usr/bin/env bash

__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base_loader.sh"
load_lib "logger"
load_lib "exception"


log_debug "this is debug message."

log_info "now raising exception."

raise SomeRandomException "This is an example of random exception."

