#!/bin/bash
DAT_FILE='todo.dat'

function show() {
	if [ ! -s $DAT_FILE ]; then
		info "Empty Todo list. Please add items"
	else
		nl $DAT_FILE
	fi
}

function add() {
	local todo=$1
	echo $todo >> $DAT_FILE
}

function error() {
	local ERROR_MESSAGE=$1
	echo "[Error] $ERROR_MESSAGE"
}

function info() {
	local INFO_MESSAGE=$1
	echo "[Info] $INFO_MESSAGE"
}

function remove() {
	local TMP_FILE=tmpfile
	local lineno=$1
	local lineCount=$(cat $DAT_FILE | wc -l)
	local firstLineCount=$(( lineno - 1 ))
	local secondLineCount=$(( lineCount - lineno ))

	if [ $lineno -gt $lineCount ]; then
		error "wrong line number"
		
		return 1
	fi
	
	head -n $firstLineCount $DAT_FILE > $TMP_FILE
	tail -n $secondLineCount $DAT_FILE >> $TMP_FILE
	cat $TMP_FILE > $DAT_FILE
	rm $TMP_FILE
	
}

function clear_screen() {
	clear
}

function menu() {
	echo '''
------------ Menu -----------
	s: show the todo list
	a: add a todo item
	r: remove a todo item
	m: show this menu
	c: clear screen
	q: quit
-----------------------------
'''
}

function main() {
	menu
	while :
	do
		read -p "> " option
	
		case $option in
			s)
				show
				;;
			a)
				read -p "Add todo item: " todo
				add "$todo"
				show
				;;
			r)
				read -p "Remove line No: " no
				remove $no && show
				;;
			r[1-9])
				remove ${option:1} && show
				;;
			c)
				clear_screen
				;;
			m)
				menu
				;;
			q)
				exit 0
				;;
			"")
				;;
			*)
				echo "invalid option"
				# menu
				;;
		esac
	done
}


main
