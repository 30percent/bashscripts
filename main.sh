#!/bin/bash
shopt -s nullglob
shopt -s extglob
oldIFS=$IFS
IFS=" "

source filefunctions.sh

main () {
	chooseFoo top_
}

main

IFS=$oldIFS
