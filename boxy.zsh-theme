# line 1
# user / host name
local user_name="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n%{$reset_color%}"
local host_name="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%m%{$reset_color%}"
local user_host="${user_name}@${host_name} "
# working directory
local replace_sep="%{$reset_color%}/%{$fg_bold[green]%}"
local current_dir='${(%):-%1~}'
local replaced_parent_dir='${${${(%):-%~}%%${(%):-%1~}}//\//$replace_sep}'
local formatted_dir="%{$fg_bold[green]%}${replaced_parent_dir}%{$reset_color%}%{$fg_bold[white]%}${current_dir}%{$reset_color%} "
# git
if [[ -n $(whence git_super_status) ]]
then
    # use git-prompt plugin if available
    local vcs_branch='$(git_super_status)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%}%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_SEPARATOR=""

    ZSH_THEME_GIT_PROMPT_CLEAN=""
    ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{●%G%}"
    ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{●%G%}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}%{+%G%}"
    ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg_bold[red]%}%{✖%G%}"

    ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[blue]%}%{▼%G%}"
    ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%}%{▲%G%}"

    ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[magenta]%}%{⚑%G%}"
else
    # fallback to oh-my-zsh git lib
    local vcs_branch='$(git_prompt_info)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●%{$fg[yellow]%}"
fi
# last command's return code
local return_code="%(?..%{$fg[red]%}%?↲%{$reset_color%})"
# line 2
local user_symbol='%{$fg_bold[white]%}%(!.#.$)%{$reset_color%}'

PROMPT="┌─ ${user_host}${formatted_dir}${vcs_branch}${return_code}
└─ ${user_symbol} "
RPROMPT=""

# time the command was started
preexec () {
  local curr_date
  curr_date=`date +"%Y-%m-%d %H:%M:%S"`
  local curr_date_pad=$(($COLUMNS-${#curr_date}-2))
  echo -e -n "\033[1A\033[${curr_date_pad}C ${curr_date} "
}
