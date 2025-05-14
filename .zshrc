# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="robbyrussell"  # 使用默认主题
     

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

# 按功能对别名进行分组
# 系统操作
alias c="clear"
alias update="sudo pacman -Syyu"
alias x="startx"
alias P="sleep 300 && shutdown now"
alias R="systemctl reboot"
alias rsyncdir="rsync -avzh --delete"  # 同步目录，删除目标端多余文件

# 配置文件编辑
alias zshconfig="vim ~/.zshrc"
alias picomconfig="vim ~/.config/picom.conf"
alias ohmyzsh="ranger ~/.oh-my-zsh"

# 目录导航
alias cdconfig="cd /home/huai/.config"
alias cdfree="cd /home/huai/free"
alias cdlinux="cd /home/huai/linux"
alias cdstacks="cd /home/huai/stacks"
alias cddata="cd /home/huai/data"
alias cdappdata="cd /home/huai/data/appdata"
alias cdusb="cd /home/huai/usb"
alias cdwww="cd /home/huai/data/www"
alias cdsingbox="cd /home/huai/data/appdata/singbox"
alias cdclash="cd /home/huai/data/appdata/clash"

# 音频控制
alias audio0="pactl set-default-sink alsa_output.usb-DeSheng_Electronics_Inc._Star_Y360-00.analog-stereo"
alias audio1="pactl set-default-sink alsa_output.usb-Generic_USB2.0_Device_20130100ph0-00.analog-stereo"
alias vol='pactl set-sink-volume @DEFAULT_SINK@'
alias volup="pactl set-sink-volume @DEFAULT_SINK@ +10%"
alias voldown="pactl set-sink-volume @DEFAULT_SINK@ -10%"
alias volmute="pactl set-sink-mute @DEFAULT_SINK@ toggle"

# MPD控制
alias mstop="mpc stop"
alias mplay="mpc play" 
alias mnext="mpc next"
alias mpause="mpc pause"
alias mpl="vim /home/huai/.config/mpd/playlists/all.m3u"

# 远程连接
alias nas="ssh admin@10.0.0.21"
alias cloud="ssh root@ssh.202309.xyz -p 2086"
alias sshmc="ssh root@ssh.082500.xyz -p 2086"
alias openwrt="ssh root@10.0.0.1"
alias ax6s="ssh root@10.0.0.2"

# 脚本和程序
alias hypr="Hyprland"
alias win="sh /home/huai/.config/windows.sh"
alias repo="sh /home/huai/.config/repo.sh"
alias np="sh /home/huai/.config/swww.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
     

   
   
export LANG=en_US.UTF-8
export VISUAL=vim
export EDITOR=vim
export TERM=xterm-256color
