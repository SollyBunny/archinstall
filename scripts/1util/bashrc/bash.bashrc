
# Hostname
if [ -z "$HOSTNAME" ]; then
	export HOSTNAME="$(cat /etc/hostname)"
fi

# Config Paths
if [ -d /etc/micro ]; then
	export MICRO_CONFIG_HOME=/etc/micro/
fi
export KITTY_CONFIG_DIRECTORY=/etc/
# export XDG_CURRENT_DESKTOP=gtk
# export GTK_USE_PORTAL=0

# Editor
if command -v micro >/dev/null 2>&1; then
	export EDITOR=micro
elif command -v nano >/dev/null 2>&1; then
	export EDITOR=nano
fi

# Add complete
if command -v complete >/dev/null 2>&1; then
	complete -cf doas
	complete -cf sudo
fi

# Alias
alias "ls"="ls -h -A"
alias "reset"="tput reset"
alias "pm"="pacman"

# Theme color!
case $(whoami) in
    "solly")
        THEME_COLOR="255;221;255"
    ;;
    "install")
        THEME_COLOR="255;255;200"
    ;;
    "toshibasrv")
        THEME_COLOR="128;255;128"
    ;;
    "icosrv")
        THEME_COLOR="128;255;255"
    ;;
    "root")
        THEME_COLOR="255;255;255"
    ;;
esac
export THEME_COLOR
case $TERM in
    *kitty*)   TERM_EMU="kitty";;
    *st*)      TERM_EMU="st";;
    *xt*)      TERM_EMU="xterm";;
    *)         TERM_EMU="term";;
esac
export TERM_EMU

printf "\e[38;2;%sm%s@%s\n" "$THEME_COLOR" "$(whoami)" "$HOSTNAME"

if command -v fetch >/dev/null 2>&1; then
	fetch
fi
printf "\e[38;2;%sm%s\n" "$THEME_COLOR" "$(date)"

# Config
NUMCMDS=1
_exitstatus() {
	RETURN="$?"
	if [ "$RETURN" -ne 0 ] && [ "$RETURN" -ne 130 ] && [ "$RETURN" -ne 127 ]; then
		echo "!$RETURN"
	else
		echo "$NUMCMDS"
	fi
	return $RETURN
}
_postexec() {
	if [ -n "$BASH_COMMAND" ]; then
		printf "\e]2;%s: %s\a" "$TERM_EMU" "$BASH_COMMAND"
	fi
	NUMCMDS=$((NUMCMDS+1))
}
export PS2='\[\e]2;${TERM_EMU}: >\a\e[0;30m\e[48;2;${THEME_COLOR}m\] > \[\e[0m\] '
export PS1='\[\e]2;${TERM_EMU}\a\e[0;30m\e[48;2;${THEME_COLOR}m\] $(_exitstatus) \W \[\e[0m\e[38;2;${THEME_COLOR}m\] \$\[\e[0m\] '
printf "\e]2;%s\a" "$TERM_EMU"

trap _postexec DEBUG
