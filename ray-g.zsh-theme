# -*- mode: shell-script;  -*-
# vim: ft=shell: sw=2:

#################################################################
# Oh-My-Zsh Theme
#################################################################

function get_pwd
{
    echo "${PWD/$HOME/~}"
}

function put_spacing
{
    local git=$(git_prompt_info)
    if [ ${#git} != 0 ]; then
        ((git=${#git} - 10))
    else
        git=0
    fi

    local termwidth
    (( termwidth = ${COLUMNS} - 6 - ${#USER} - ${#HOST} - ${#$(get_pwd)} - ${git} ))

    local spacing=""
    local i=""
    for i in {1..$termwidth}; do
        spacing="${spacing} "
    done
    echo "$spacing"
}

VIRTUAL_ENV_DISABLE_PROMPT=true
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo "[venv: $(basename $virtualenv_path)]"
  elif which pyenv &> /dev/null; then
    echo "[venv: $(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')]"
  fi
}

function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function set_theme() {
    DISABLE_AUTO_TITLE="true"
    DISABLE_AUTO_UPDATE="true"

    exit_code="%(?,,%{$fg[red]%}[C:%?]%{$reset_color%})"
    ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

    ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
    ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
    ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]"
    ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

    PROMPT='%{$fg_bold[grey]%}╭%n@%m: %{$fg_bold[grey]%}$(get_pwd)  $(git_prompt_info) $(prompt_virtualenv)
%{$fg_bold[grey]%}╰${ret_status}${exit_code}%{$reset_color%} '

    if [ -z "${MY_TITLE_NAME+xxx}" ]; then
        MY_TITLE_NAME="Terminal"
    fi

    if [ -z "${MY_TITLE_NUM+xxx}" ]; then
        MY_TITLE_NUM="0"
    fi
}

function update_title()
{
    title "$MY_TITLE_NAME ☢#$MY_TITLE_NUM"
    #title "$MY_TITLE_NAME"
}
function set_title_num()
{
    MY_TITLE_NUM=$1
    update_title
}
function set_title_name()
{
    MY_TITLE_NAME=$1
    update_title
}
function set_title()
{
    MY_TITLE_NAME=$1
    MY_TITLE_NUM=$2
    update_title
}

function set_theme_alias() {
    alias tl='set_title'
    alias tt='set_title_name'
    alias tn='set_title_num'
}

if [ -z "$ZSH_THEME" ]; then
    set_theme
    set_theme_alias
fi
