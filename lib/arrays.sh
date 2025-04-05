__FILE__=`realpath "${BASH_SOURCE[0]}"`
__PWD__=`dirname "$__FILE__"`

. "$__PWD__/base.sh"
load_lib "logger"
load_lib "exception"


# array_init <array_name>
array_init(){
	local _name="$1"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` && raise ArrayExistsException "Array/Variable with same name already exists."

	declare -n arr_ref=$_name
	arr_ref=()
	unset -n arr_ref
}


# array_push <array_name> <data>
array_push(){
	local _name="$1"
	local _val="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	declare -n arr_ref=$_name
	arr_ref+=("$_val")
	unset -n arr_ref
}



# array_push_all <array_name> <array_name_to_push>
array_push_all(){
	local _name="$1"
	local _val="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	[[ "$_val" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."
	`set | grep -oq "^$_val="` || raise ArrayNotFoundException "Array doesn't exists."

	declare -n arr_ref=$_name
	declare -n arr_ref2=$_val

	arr_ref+=("${arr_ref2[@]}")
	unset -n arr_ref
	unset -n arr_ref2
}


# array_pop_first <array_name> <ret_var_name>
# array_pop_first <array_name>
array_pop_first(){
	local _name="$1"
	local _ret_var_name="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	declare -n arr_ref=$_name
	local _len=-1
	local _el=""

	_len=${#arr_ref[@]}
	_len=$(( _len - 1 ))
	[[ $_len -eq -1 ]] && raise "ArrayEmptyException" "Can't pop, array is empty."

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



# array_pop_last <array_name> <ret_var_name>
# array_pop_last <array_name>
array_pop_last(){
        local _name="$1"
        local _ret_var_name="$2"

        [ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
        [[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
        `set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

        declare -n arr_ref=$_name
        local _len=-1
        local _el=""

        _len=${#arr_ref[@]}
        _len=$(( _len - 1 ))
        [[ $_len -eq -1 ]] && raise "ArrayEmptyException" "Can't pop, array is empty."

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

# array_insert_at <array_name> <loc> <data>
array_insert_at(){
	local _name="$1"
	local _loc="$2"
	local _data="$3"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[ -z "$_loc" ] && raise EmptyArgException "Argument value not supplied."

	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	[[ "$_loc" =~ ^[0-9]+$ ]] || raise InvalidLocException "Array loc is invalid, it must be an integer."
	[[ "$_loc" -lt 0 ]] || raise InvalidLocException "Array loc is invalid, it must be a non-negative integer."

	declare -n arr_ref=$_name
	arr_ref=("${arr_ref[@]:0:$_loc}" "$_data" "${arr_ref[@]:$_loc}")
	unset -n arr_ref
}


# array_insert_all_at <array_name> <loc> <array_name_to_insert>
array_insert_at(){
	local _name="$1"
	local _loc="$2"
	local _data_arr="$3"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[ -z "$_loc" ] && raise EmptyArgException "Argument value not supplied."
	[ -z "$_data_arr" ] && raise EmptyArgException "Argument value not supplied."

	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."
	[[ "$_data_arr" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_data_arr="` || raise ArrayNotFoundException "Array doesn't exists."

	[[ "$_loc" =~ ^[0-9]+$ ]] || raise InvalidLocException "Array loc is invalid, it must be an integer."
	[[ "$_loc" -lt 0 ]] || raise InvalidLocException "Array loc is invalid, it must be a non-negative integer."

	declare -n arr_ref=$_name
	declare -n arr_ref2=$_data_arr
	arr_ref=("${arr_ref[@]:0:$_loc}" "${arr_ref2[@]}" "${arr_ref[@]:$_loc}")
	unset -n arr_ref
	unset -n arr_ref2
}

# array_el_loc <array_name> <element> <ret_var_name>
# array_el_loc <array_name> <element>
array_el_loc(){
	local _name="$1"
	local _data="$2"
        local _ret_var_name="$3"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	declare -n arr_ref=$_name
	local _loc=-1
	local _l=
	for _l in ${!arr_ref[@]}; do
		[ "${arr_ref[$_l]}" == "$_data" ] && { _loc=$_l; break; }
	done

	unset -n arr_ref
	[[ $_loc  -eq -1 ]] && raise NoSuchElementException "Element doesn't exists."
        if [ -z "$_ret_var_name" ]; then
                printf "%s" "$_loc"
        else
                declare -n ref_tmp="$_ret_var_name"
                ref_tmp="$_loc"
                unset -n ref_tmp
        fi
}


# array_loc_el <array_name> <loc> <ret_var_name>
# array_loc_el <array_name> <loc>
array_loc_el(){
	local _name="$1"
	local _loc="$2"
        local _ret_var_name="$3"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	[[ "$_loc" =~ ^[0-9]+$ ]] || raise InvalidLocException "Array loc is invalid, it must be an integer."
	[[ "$_loc" -lt 0 ]] || raise InvalidLocException "Array loc is invalid, it must be a non-negative integer."

	declare -n arr_ref=$_name
        if [ -z "$_ret_var_name" ]; then
                printf "%s" "${arr_ref[$_loc]}"
        else
                declare -n ref_tmp="$_ret_var_name"
                ref_tmp="${arr_ref[$_loc]}"
                unset -n ref_tmp
        fi
	unset -n arr_ref
}


# array_del_el <array_name> <data>
array_del_el(){
	local _name="$1"
	local _data="$2"
	local _eloc=

	array_el_loc "$_name" "$_data" "_eloc"

	local _size=
	[[ "$_eloc" -eq 0 ]] && _size=1 || _size=$_eloc

	declare -n arr_ref=$_name
	arr_ref=("${arr_ref[@]:0:$_size}" "${arr_ref[@]:$(( _eloc + 1 ))}")
	unset -n arr_ref
}


# array_del_at <array_name> <loc>
array_del_at(){
	local _name="$1"
	local _loc="$2"

	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	[[ "$_loc" =~ ^[0-9]+$ ]] || raise InvalidLocException "Array loc is invalid, it must be an integer."
	[[ "$_loc" -lt 0 ]] || raise InvalidLocException "Array loc is invalid, it must be a non-negative integer."
	local _size=
	[[ "$_loc" -eq 0 ]] && _size=1 || _size=$_loc

	declare -n arr_ref=$_name
	arr_ref=("${arr_ref[@]:0:$_size}" "${arr_ref[@]:$(( _loc + 1 ))}")
	unset -n arr_ref
}


# array_print <array_name> <element_seperator>
# array_print <array_name>
array_print(){
	local _name="$1"
	local _sep="$2"
	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."

	declare -n arr_ref=$_name

	printf "%s$_sep" "${arr_ref[@]}"
	unset -n arr_ref
}


# array_del <array_name>
array_del(){
	local _name="$1"
	[ -z "$_name" ] && raise EmptyArgException "Argument value not supplied."
	[[ "$_name" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] || raise InvalidNameException "Array name is invalid."
	`set | grep -oq "^$_name="` || raise ArrayNotFoundException "Array doesn't exists."
	declare -n arr_ref=$_name
	unset arr_ref
	unset -n arr_ref
}

