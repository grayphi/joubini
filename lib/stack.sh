__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base.sh"
load_lib "logger"
load_lib "exception"


# stack_init <stack_name>
stack_init(){
	local _name="$1"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Stack name is invalid."
	`set | grep -oq "^$_name="` && raise StackExistsException "Stack/Variable with same name already exists."

	declare -n arr_ref=$_name
	arr_ref=()
	unset -n arr_ref
}


# stack_push <stack_name> <data>
stack_push(){
	local _name="$1"
	local _val="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Stack name is invalid."
	`set | grep -oq "^$_name="` || raise StackNotFoundException "Stack doesn't exists."

	declare -n arr_ref=$_name
	arr_ref+=("$_val")
	unset -n arr_ref
}


# stack_pop <stack_name> <ret_var_name>
# stack_pop <stack_name>
stack_pop(){
	local _name="$1"
	local _ret_var_name="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Stack name is invalid."
	`set | grep -oq "^$_name="` || raise StackNotFoundException "Stack doesn't exists."

	declare -n arr_ref=$_name
	local _len=-1
	local _el=""

	_len=${#arr_ref[@]}
	_len=$(( _len - 1 ))
	[[ $_len -eq -1 ]] && raise "StackEmptyException" "Can't pop, stack is empty."

	_el="${arr_ref[$_len]}"
	unset arr_ref[$_len]
	unset -n arr_ref

	if [ -z "$_ret_var_name" ]; then
		printf "%s" "$_el"
	else
		declare -n ref_tmp="$_ret_var_name"
		ref_tmp="$_el"
		unset -n ref_tmp
	fi
}


# stack_peek <stack_name> <ret_var_name>
# stack_peek <stack_name>
stack_peek(){
	local _name="$1"
	local _ret_var_name="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Stack name is invalid."
	`set | grep -oq "^$_name="` || raise StackNotFoundException "Stack doesn't exists."

	declare -n arr_ref=$_name
	local _len=-1
	local _el=""

	_len=${#arr_ref[@]}
	_len=$(( _len - 1 ))
	[[ $_len -eq -1 ]] && raise "StackEmptyException" "Can't peek, stack is empty."

	_el="${arr_ref[$_len]}"

	unset -n arr_ref
	if [ -z "$_ret_var_name" ]; then
		printf "%s" "$_el"
	else
		declare -n ref_tmp="$_ret_var_name"
		ref_tmp="$_el"
		unset -n ref_tmp
	fi
}


# stack_print <stack_name> <element_seperator>
# stack_print <stack_name>
stack_print(){
	local _name="$1"
	local _sep="$2"
	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Stack name is invalid."
	`set | grep -oq "^$_name="` || raise StackNotFoundException "Stack doesn't exists."

	declare -n arr_ref=$_name

	printf "%s$_sep" "${arr_ref[@]}"
	unset -n arr_ref
}


# stack_del <stack_name>
stack_del(){
	local _name="$1"
	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Stack name is invalid."
	`set | grep -oq "^$_name="` || raise StackNotFoundException "Stack doesn't exists."
	declare -n arr_ref=$_name
	unset arr_ref
	unset -n arr_ref
}

