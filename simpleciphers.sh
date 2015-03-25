die () {
	echo >&2 "Error: $@"
	exit 1
}

argC=5
[ "$#" -eq $argC ] || die "use [encrypt/decrypt] INPUTFILE OUTPUTFILE [substitution/transposition] KEYVALUE"

BUFFSIZE=32
toCut=$(($BUFFSIZE+2))

WHICHWAY=$1
INPUTF=$2
OUTPUTF=$3
CIPHER=$4
KEY=$5


substitution(){
    #contents=$(cat "$FILENAME")
    contents=$(xxd -g 1 -c "$BUFFSIZE" "$INPUTF" | cut -f -"$toCut" -d " " | awk -v kVal="$KEY" -v cut="$toCut" '{
        printf "%s ", $1
        for(i = 2; i < cut; i++){
            if($i){
            x = "0x"$i
            y = strtonum(x)+kVal
            y = y % strtonum("0xff")
            $i = y
            printf "%02X ", $i
            }
        }
        printf "\n"
        }'
    )
    contents=$(echo "$contents" | head -c -1 | xxd -g 1 -c "$BUFFSIZE" -r)
    echo "$contents" | head -c -1  > "$OUTPUTF"
    
}

transposition(){
    contents=$(xxd -g 1 -c "$BUFFSIZE" "$INPUTF" | cut -f -"$toCut" -d " " | awk -v kVal="$KEY" '{
        len = NF - 1;
        printf "%s ", $1
        for(i = 1; i <= kVal; i++){
            p = i;
            while(p <= len){
                temp = p + 1
                printf "%s ", $temp
                p = p + kVal
            }
        }
        printf "\n"
        }')
    #echo "$contents"
    contents=$(echo "$contents" | head -c -1 | xxd -g 1 -c "$BUFFSIZE" -r)
    echo "$contents" | head -c -1  > "$OUTPUTF"
}

detrans(){
    contents=$(xxd -g 1 -c "$BUFFSIZE" "$INPUTF" | cut -f -"$toCut" -d " " | awk -v kVal="$KEY" '{
        len = NF - 1;
        printf "%s ", $1
        totCols = int((len+kVal - 1)/kVal)
        
        empty = (totCols*kVal)-len
        col = 0 
        row = 0
        for(i = 1; i <= len; i++){
            temp = i + 1
            tArr[col][row] = $temp
            col++
            if(col == totCols || (col == totCols-1 && row >= kVal-empty)){
                col=0
                row++
            }
        }
        for(t in tArr){
            for(el in tArr[t]){
                printf "%s ", tArr[t][el]
            }
        }
        delete tArr
        printf "\n"
        }')
    #echo "$contents"
    contents=$(echo "$contents"  | head -c -1 | xxd -g 1 -c "$BUFFSIZE" -r)
    echo "$contents" | head -c -1  > "$OUTPUTF"
}


if [ "$CIPHER" = "substitution" ]
then
    if [ "$WHICHWAY" = "decrypt" ]
    then
        KEY=$(($KEY * -1))
    fi
    substitution
fi
if [ "$CIPHER" = "transposition" ]
then
    if [ "$WHICHWAY" = "decrypt" ]
    then
        detrans
    else
        transposition
    fi
fi
