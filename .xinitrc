#!/bin/sh

xrdb -merge ~/.Xresources		# terminal styling
sh ~/.fehbg &				# set background
sxhkd &					# key bindings
xset m 2/3 &				# slow down mouse
xsetroot -cursor_name left_ptr		# set default cursor to usual, not X11's X
redshift -l 40.815472:-73.959071 &
numlockx &
dropbox & 
tmux new -d -s cmux; tmux send-keys -t cmux 'cmus' C-m # Start cmus in tmux session

exec bspwm
