__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base.sh"
load_lib "logger"
load_lib "exception"


# queue_init <queue_name>
queue_init(){
	local _name="$1"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Queue name is invalid."
	`set | grep -oq "^$_name="` && raise QueueExistsException "Queue/Variable with same name already exists."

	declare -n arr_ref=$_name
	arr_ref=()
	unset -n arr_ref
}


# queue_push <queue_name> <data>
queue_push(){
	local _name="$1"
	local _val="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Queue name is invalid."
	`set | grep -oq "^$_name="` || raise QueueNotFoundException "Queue doesn't exists."

	declare -n arr_ref=$_name
	arr_ref+=("$_val")
	unset -n arr_ref
}


# queue_pop <queue_name> <ret_var_name>
# queue_pop <queue_name>
queue_pop(){
	local _name="$1"
	local _ret_var_name="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Queue name is invalid."
	`set | grep -oq "^$_name="` || raise QueueNotFoundException "Queue doesn't exists."

	declare -n arr_ref=$_name
	local _len=-1
	local _el=""

	_len=${#arr_ref[@]}
	_len=$(( _len - 1 ))
	[[ $_len -eq -1 ]] && raise "QueueEmptyException" "Can't pop, queue is empty."

	_el="${arr_ref[0]}"
	unset arr_ref[0]
	arr_ref=("${arr_ref[@]}")
	unset -n arr_ref

	if [ -z "$_ret_var_name" ]; then
		printf "%s" "$_el"
	else
		declare -n ref_tmp="$_ret_var_name"
		ref_tmp="$_el"
		unset -n ref_tmp
	fi
}


# queue_peek <queue_name> <ret_var_name>
# queue_peek <queue_name>
queue_peek(){
	local _name="$1"
	local _ret_var_name="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Queue name is invalid."
	`set | grep -oq "^$_name="` || raise QueueNotFoundException "Queue doesn't exists."

	declare -n arr_ref=$_name
	local _len=-1
	local _el=""

	_len=${#arr_ref[@]}
	_len=$(( _len - 1 ))
	[[ $_len -eq -1 ]] && raise "QueueEmptyException" "Can't peek, queue is empty."

	_el="${arr_ref[0]}"

	unset -n arr_ref
	if [ -z "$_ret_var_name" ]; then
		printf "%s" "$_el"
	else
		declare -n ref_tmp="$_ret_var_name"
		ref_tmp="$_el"
		unset -n ref_tmp
	fi
}


# queue_print <queue_name> <element_seperator>
# queue_print <queue_name>
queue_print(){
	local _name="$1"
	local _sep="$2"
	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Queue name is invalid."
	`set | grep -oq "^$_name="` || raise QueueNotFoundException "Queue doesn't exists."

	declare -n arr_ref=$_name

	printf "%s$_sep" "${arr_ref[@]}"
	unset -n arr_ref
}


# queue_del <queue_name>
queue_del(){
	local _name="$1"
	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Queue name is invalid."
	`set | grep -oq "^$_name="` || raise QueueNotFoundException "Queue doesn't exists."
	declare -n arr_ref=$_name
	unset arr_ref
	unset -n arr_ref
}

