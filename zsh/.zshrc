# Path to your oh-my-zsh installation.
export ZSH=/home/depau/.oh-my-zsh

source ~/.consolecolor
source ~/.fonts/*.sh

export EDITOR=vim

export KEYTIMEOUT=1

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
_term_bak=$(echo $TERM)
if [[ $TERM == *"256color" ]]; then
	POWERLEVEL9K_MODE='awesome-fontconfig'
else
	TERM="xterm-256color"
fi
ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="davidoulaj"
#"random"
#"robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(archlinux gitfast command-not-found common-aliases dirhistory compleat git-extras pip python sublime systemd history-substring-search sudo docker docker-compose)

if [ -z ${WAYLAND_DISPLAY+x} ]; then
	xorg_plugins=(notify)
	plugins=($plugins $xorg_plugins)
fi

# User configuration

# export PATH="/usr/local/heroku/bin:/home/depaulicious/Stuff/arm-eabi-4.6/bin:/home/depaulicious/.bin:/home/depaulicious/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/depaulicious/Stuff/gcc-arm-none-eabi-4.9/bin"
 # export PATH="/home/depaulicious/.bin:/home/depaulicious/bin:/home/depaulicious/Stuff/gcc-arm-none-eabi-4.9/bin:$PATH
export PATH="$HOME/.bin:$HOME/bin:$HOME/.local/bin:/usr/lib/ccache:/usr/local/bin:/usr/bin:/bin:/usr/games:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/.zsh_aliases

#export POWERLINE_CONFIG="/usr/share/powerline/config_files"
if [[ $TERM != *"256color" ]]; then
	#export POWERLINE_CONFIG="/usr/share/powerline/config_files"
	export POWERLINE_COMMAND_ARGS="-c common.default_top_theme=\"ascii\" $POWERLINE_COMMAND_ARGS"
	export POWERLINE_CONFIG_OVERRIDES="common.default_top_theme=\"ascii\""
fi
#export POWERLINE_CONFIG_COMMAND="/usr/bin/powerline-config -p \"${POWERLINE_CONFIG}\""

#powerline-daemon -q
#source /usr/share/powerline/bindings/zsh/powerline.zsh

transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }


# Show more info in framebuffer console 
typeset -gAH DEPAU_ICONS
if [[ $_term_bak == *"256color" ]]; then
	DEPAU_ICONS=(
		wifi		' \uf1eb '
		clock		' \uf017'
		superuser	'\uf0e7'
	)
else
	DEPAU_ICONS=(
		wifi		''
		clock		''
		superuser	"#"
	)
fi

prompt_wifi_signal(){
	local signal=$(nmcli device wifi | grep -E '^[*] ' | grep -v SECURITY | awk '{print $7}')
	local ssid="$(iwgetid -r)"
	local color='%K{yellow}'
	local current_state=mid
	typeset -AH wifi_states
	wifi_states=(
		'low'  'red'
		'mid'  'yellow'
		'high' 'green'
		'disconnected' "$DEFAULT_COLOR"
		)
	local fg_color="$DEFAULT_COLOR"
	[[ $signal -gt 75 ]] && current_state='high' # color='%K{green}'
	[[ $signal -lt 50 ]] && current_state='low'  # color='%K{red}'
	[[ $signal -eq "" ]] && current_state='disconnected' && fg_color="red" && signal='!'
	#echo -n "%{$color%}\u1f4f6  $signal%{%f%}" # \u1f4f6 is 📶
	#echo -n "%{$color%}\uf1eb $signal%{%k%}
	"$1_prompt_segment" "prompot_custom_wifi_signal_${current_state}" "$2" "${wifi_states[$current_state]}" "$fg_color" "$ssid${DEPAU_ICONS[wifi]}" ''
}
prompt_root_indicator() {
	if [[ "$UID" -eq 0 ]]; then
		"$1_prompt_segment" "$0" "$2" "red" "yellow" "${DEPAU_ICONS[superuser]}" ""
	fi
}

POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
POWERLEVEL9K_HOME_FOLDER_ABBREVIATION=""
#POWERLEVEL9K_DIR_PATH_SEPARATOR="%F{$DEFAULT_COLOR_INVERTED} $(print_icon 'LEFT_SUBSEGMENT_SEPARATOR') %F{black}"
POWERLEVEL9K_HOME_SUB_ICON='\uF015'
POWERLEVEL9K_FOLDER_ICON='\uF07C'
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'"${DEPAU_ICONS[clock]}"
POWERLEVEL9K_DIR_HOME_BACKGROUND='003'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='003'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='003'
POWERLEVEL9K_DIR_HOME_FOREGROUND='black'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='black'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'
POWERLEVEL9K_IP_BACKGROUND='003'
POWERLEVEL9K_IP_FOREGROUND='black'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator dir)
#POWERLEVEL9K_VIRTUALENV_ICON="\ue63c"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs vcs virtualenv dir_writable ip)

if [[ $_term_bak != *"256color" ]]; then
	additional=(wifi_signal battery time)
	POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=($POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS $additional)
	function zle-line-init() {}
	function zle-line-finish() {}
	POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
	POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
	POWERLEVEL9K_HOME_ICON=''
	POWERLEVEL9K_HOME_SUB_ICON=''
	POWERLEVEL9K_FOLDER_ICON=''
	POWERLEVEL9K_HOME_FOLDER_ABBREVIATION="~"
fi
export TERM=$_term_bak

zstyle ':notify:*' error-icon "$HOME/.icons/200_s.gif"
zstyle ':notify:*' error-title "wow such fail"
zstyle ':notify:*' success-icon "$HOME/.icons/b55a1805f5650495a74202279036ecd2.jpg"
zstyle ':notify:*' success-title "very success. wow"


if [ !$WINDOWID ] && [ $TILIX_ID ] && [ -z ${WAYLAND_DISPLAY+x} ]; then
	sleep 0.2
	export WINDOWID=$(xdotool getactivewindow)
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
