source allsfunc.sh

FOO_TRACK=0

#@param1 : function prefix
#@param2 : return string of list, space separated
getFoos () {
	ret="$(compgen -A function | grep $1 )"
	ret="${ret//[$'\t\r\n ']/ }"
	ret="${ret//$1}"
	eval "$2='$ret'"
}


chooseFoo() {
	getFoos "$1" foos
	array=( $foos )
	echo "Available Functions: "
	i="0"
	while [ $i -lt ${#array[@]} ]
	do
		echo "$i. ${array[$i]}"
		i=$[$i+1]
	done
	read choice
	$1${array[$choice]}
}

fl_extension () {
	if [ $FOO_TRACK -ne 1 ]
	then
		exit
	fi
	echo "Extension list (space separated):"
	IFS=" "
	read extList
	if [ $(expr index "$extList" " ") -ne 0 ]
	then
		extList="{${extList// /,}}"
	fi
	LIST=$( eval echo "*.$extList" )
	echo "${LIST}"
}

fl_filename () {
	echo "start of filename"
	read choice
	array="($choice.*)"
	echo "$array"
}

file_filelist () {
	FOO_TRACK=1
	chooseFoo fl_
}

file_fileiter () {
	
echo "Provide file to read in and nonexistent file to write to."
read inFile outFile
awk -v iter=1 '{ print iter "." $0; print "";iter++ }' inFile > outFile

}

top_fileFuncs () {
	chooseFoo file_
}

