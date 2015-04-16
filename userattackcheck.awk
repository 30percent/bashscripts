#!/bin/gawk

BEGIN {
	curDate=systime()-86400
	suSuc=0
	suFail=0
	loginFail=0
	loginSuc=0
	perSuF=0
	perLuF=0
}
{
	getEpoch="date -d\""$1" "$2" "$3"\" +%s"
	getEpoch | getline epoDate
	if(epoDate > curDate){
		if($5 ~ /su/){
			if($0 ~ /FAILED su/) {suFail++;}
			else if($0 ~ /Successful su/) {suSuc++;}
			#else if (/incorrect password/) {suFail++} #sudo failures
			#else {suSuc++} #sudo successes
			
		} else if($0 ~ /authentication failure/){
			loginFail++
		} else if($0 ~ /session opened fo/){
			loginSuc++
		}
	}
}
END {
	perSuF= suFail/(suSuc+suFail)
	perLoF= loginFail/(loginSuc+loginFail)
	assess="OK"
	if(perSuF > .66 || perLoF > .66){
		asses="UNDER ATTACK"
	} else if(perSuF > .33 || perLoF > .33){
		assess="STRANGE"
	}
	printf strftime("%b %d %H:%M:%S",systime())
	printf ": %s, su:%d,%d, auth:%d,%d\n", assess, suSuc, suFail, loginSuc, loginFail
}
