# How to Create a Lightweight Dotfiles Repository

### Introduction

If you frequently create GitHub Codespaces, configuring your customizations can be tedious and repetitive. This tutorial will show you how to consolidate all of your customizations in a dotfiles GitHub repository. Along the way you will learn some handy Linux and vim techniques. 

The goal is to create a minimalist, well structured, boilerplate repository that you can augment as you see fit. The bulk of the tutorial consists of building the repository one file at a time with commentary describing key points. When you're done, you will have created a generic repository with the following:

- Good generic `.bashrc` settings
- Small but powerful set of bash functions and aliases for navigation 
- Good generic settings for vim

## Prerequisites

This is a fairly advanced tutorial. You should consider yourself an intermediate level user of Linux and Vim.

- Be comfortable working a Linux terminal. Start with the article [A Linux Command Line Primer](https://www.digitalocean.com/community/tutorials/a-linux-command-line-primer). It wouldn't hurt to check out the article [Top 50+ Linux Commands You MUST Know](https://www.digitalocean.com/community/tutorials/linux-commands) either.
- Have a decent understanding of the Vim text editor. Check out the article [How To Use Vim for Advanced Editing of Plain Text or Code on a VPS](https://www.digitalocean.com/community/tutorials/how-to-use-vim-for-advanced-editing-of-plain-text-or-code-on-a-vps-2).
- The article [How To Use Git to Manage your User Configuration Files on a Linux VPS](https://www.digitalocean.com/community/tutorials/how-to-use-git-to-manage-your-user-configuration-files-on-a-linux-vps) by Justin Ellingwood presents another solution to this problem using GitLab. I recommend reading it.


## Dotfiles

I conferred with my AI assistant Google Gemini about how to create a GitHub repository for my customizations. It recommended utilizing a "dotfiles" repository. A dotfile refers to any hidden configuration file beginning with a `.` character, like `.bashrc`. This led me to research dotfiles, and I learned that this is a known issue with many solutions. The dotfiles solution you will create in this tutorial is the result of that research.

## The Dotfiles Directory Structure

It is essential to have a logically organized directory structure for your repository. For this tutorial you will use the following directory structure, which divides the configuration files between bash and vim:

```text
dotfiles
  shell
    .vars
    .prompt
    .aliases
    .functions

  .vim
    plugin
    set.vim
    maps.vim
    autoload.vim

  backups

  .bashrc
  .vimrc

  install.sh
```

`.bashrc` is a configuration file for bash that can grow to be very large and convoluted over time. We are going to solve this problem using a divide-and-conquer strategy by breaking `.bashrc` into the smaller modules (files) `.vars`, `.prompt`, `.aliases`, and `.functions`; `.bashrc` then simply loads each of these modules. We will use the same approach with `.vimrc`, the primary configuration file for the text editor Vim, breaking it into the modules `set.vim`, `maps.vim`, and `autoload.vim`.

> **Note:** Your setup might require you to use different configuration files like `.bash_profile`. Make whatever changes you need to this repository.

## Test Everything

As you create each file, test it. Confirm it is doing exactly what you expect it to do, and do not proceed any further in the tutorial until you have. Making too many changes without testing them can create some big headaches for you. Be patient and take it one step at a time, friend.

## Complete Code Listings

By including the full code listings for each file, though it bloats the article somewhat, makes it easier to copy and paste the code as you proceed through it.

## Step One -- Creating the Files and Directories

Let's start building your dotfiles repository. Log in to your GitHub account and create a new Codespace. Once VS Code finishes loading, open a terminal use the following command to create all of your dotfiles directories:

```sh
mkdir -p .vim/plugin shell backups
```

Use the following command to create the files:

```sh
touch .bashrc .vimrc install.sh shell/.{functions,vars,aliases,prompt} .vim/{set,maps,autoload}.vim
```

It's pretty cool to create all these files in one command. The shell uses brace expansions to create every possible combination of the expressions in the braces. 

It wouldn't hurt to confirm all the directories and files have been created.

## Step Two -- Creating `install.sh`

Let's create an installation script that creates symbolic links from your dotfiles in your `dotfiles/` directory to your home directory. Open the script using the following command:

```sh
vim install.sh
```

Add the following code to your `install.sh`:

```sh
CS_HOME="$(pwd)"
DATE="$(date +%Y%m%d%H%M%S)"

if [ -f ~/.bashrc ]; then
  cp ~/.bashrc "$CS_HOME/backups/.bashrc.bak.$DATE"
  mv –-no-clobber ~/.bashrc "$CS_HOME/.bashrc" 2>/dev/null
  rm ~/.bashrc
fi
ln -s "$CS_HOME/.bashrc" ~/.bashrc

if [ -f ~/.vimrc ]; then
  cp ~/.vimrc "$CS_HOME/backups/.vimrc.bak.$DATE"
  mv –-no-clobber ~/.vimrc "$CS_HOME/.vimrc" 2>/dev/null
  rm ~/.vimrc
fi
ln -s "$CS_HOME/.vimrc" ~/.vimrc

rm -r ~/shell 2>/dev/null
ln -s "$CS_HOME/shell" ~/shell

rm -r ~/.vim 2>/dev/null
ln -s "$CS_HOME/.vim" ~/.vim
```

This script adds symbolic links to your home directory pointing to your dotfiles directory. Much of this code suppresses error messages.  The `--no-clobber` option for `mv` prevents it from overwriting, and `2>/dev/null` suppresses error messages by redirecting them to the trash can of `/dev/null`.

Every time you run `install.sh` it creates backups of `.bashrc` and `.vimrc` in the `backups/` directory.

Before you run this script, you need to give it execute permissions using the following command:

```sh
chmod +x install.sh
```

Now run it using the following command:

```sh
./install.sh
```

Take a moment to confirm all your directories and files exist.

Now would be a good time to add your project to source control.  Add all your changes, commit them with a meaningful message, and then push.

## Step Three -- Creating `.bashrc`

Change to the dotfiles directory and edit your `.bashrc` file using the following command:

```sh
vim .bashrc
```

Add the following code to `.bashrc`:

```sh
# Loop through files starting with a dot in the current directory
for file in $(find -L ~/shell -type f -name ".*"); do

  # Source the file using the dot (.) operator
  . "$file"
  echo "Sourced file: $file"

done
```

This streamlined script loads every dotfile it finds in your `dotfiles/` directory tree. Now, you can add more dotfiles without changing your `.bashrc`.

In the next steps, you will create each of the other `.bashrc` modules.

### Before Continuing

It's a good idea to use the following command every time you modify one of your `shell/` dotfiles:

```sh
. ~/.bashrc
```

This is how you can activate your changes and test them.

## Step Four -- Creating `.functions`

Define all of your custom bash functions in `.functions`. Open it using the following command:

```sh
vim shell/.functions
```

I have included some functions I have found useful. Add these to your `.functions`:

```sh
dir ()
{
  ls -alF --color=auto --color=always "$@" | less -rEF
  echo
}

cl() {
  if [ -n "$1" ]; then
    cd "$1" 2>/dev/null

    # check if cd was successful
    if [ $? -ne 0 ]; then
      echo -e "Error: Could not change directory to '$1'.\n"
      return 0
    fi
  fi

  clear
  dir
}

hgrep() {
  history | grep "$@"
}

setenv()
{ 
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "Usage: setenv VAR VALUE\n"
    return 1
  fi

  eval $1=\$2;
  export $1;
}

```

### dir

The `dir` function generates a colored listing and pipes the output to `less`, allowing you to scroll through a long listing.  To preserve the color in `less`, you have to use the `--color=always` option for `ls` and the `-r` option for `less`.

### cl

The `cl` is a very useful function that combines `ls`, `clear`, `cd`, and `less`.  It changes to the argument directory--if one is provided--clears the screen, and then produces a detailed, colored listing.  Additionally, if the listing is larger than the viewport, the `less` command takes over, allowing you to navigate the listing.

### setenv

`setenv` is a quick way to create an environment variable.  Here is how you would use it:

```sh
setenv X 'thine dork lord'
```

### hgrep

The `hgrep` function allows you to search your command history using `grep`. Here is an example of using the it:

```sh
hgrep 'ls'
```

Here is some possible output:

```text
85  cd dotfiles/
86  ll
87  cd ..
88  rm -r dotfiles/
89  ll
```

You can then execute the command `rm -r` dotfiles/ using `!88`.

> **Note:** The `hgrep` function makes use of `$@` which when evaluated in double quotes represents all of the arguments passed in.

I strongly recommend acquainting yourself with bash's command history.

## Step Five -- Creating `.vars` File

You will include your environment variables and miscellaneous settings in `.vars`. Open it using the following command:

```sh
vim shell/.vars
```

Include whichever settings you find amusing.  Here are some boilerplate settings:

```sh
# make less not clear screen at end
export LESS="-X"

# restrict write permissions for others
umask 0002

export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"

HISTCONTROL=ignoreboth
HISTSIZE=999
HISTFILESIZE=1999

# append to the history file, don't overwrite it
shopt -s histappend
```

Let’s look at the first three settings:

* `export LESS="-X"` alters the behavior of the `less` command by preventing it from clearing the terminal once you reach the end of its output. Recall that we use `less` in our `dir` function.
* `export LS_OPTIONS='--color=auto'` and `eval "$(dircolors -b)"` change the color of the output of the `ls` command.
* `unmask 0002` is a security setting that gives the owner (you) full permissions and restricts write permissions for others.

The other settings affect your command history. By default bash adds your executed commands to a file called `.bash_history`. Here are some settings affecting your command history:

* `HISTCONTROL=ignoreboth` combines two other settings: `ignorespace`, which ignores leading whitespace on commands, and `ignoredups`, which prevents duplicate commands from being added to command history.
* `shopt -s histappend` makes bash write all your current session's commands to `.bash_history`, making them available in future sessions.

## Step Six -- Creating `.prompt`

Open `.prompt` using the following command:

```sh
vim shell/.prompt
```

This `.prompt` file produces a nice, colored prompt that also shows the current git branch if there is one. I like how it defines a variable for each color.

```sh
# Define colors
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
YELLOW="\[\033[0;33m\]"
RESET="\[\033[0m\]"

# Function to get the current Git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \(\1\)/'
}

# Function to set the colored prompt
set_prompt() {
    # Get the current Git branch
    BRANCH=$(parse_git_branch)

    # Set the prompt
    PS1="${GREEN}\u${RESET}@${BLUE}\h${RESET}\n : ${YELLOW}\w${RESET}${PURPLE}${BRANCH}${RESET} $ "
}

# Call the set_prompt function whenever a new prompt is needed
PROMPT_COMMAND=set_prompt
```

> **Note:** Credit goes to the Claude 3 A.I. for generating this prompt.

This prompt appears as follows:

```text
(green)  username
(blue)   hostname
(orange) current-directory
(purple) git-branch

 username:hostname
 : current-directory (git-branch) $ 
```

## Step Seven -- Creating `.aliases`

Your aliases go here. Open `.aliases` using the following command:

```sh
vim shell/.aliases
```

Here are some aliases I use:

```sh
alias sup='sudo apt-get update && sudo apt-get upgrade -y'
alias bs=". ~/.bashrc"

alias b="cd ~-"
alias l='cl'
alias ..='l ..'
alias ...='l ../..'
```

A couple of interesting things here.

- `alias b="cd ~-"` uses the `~-` expression, which represents the previous directory. This is a very nice back function.
- the `l`, `..`, and `...` aliases all invoke our previously defined `cl` function in `.functions`.

## Step Eight -- Creating the Vim Files

In this section, we will create `.vimrc` and all of its constituent files.

### .vimrc

Open `.vimrc` using the following command:

```sh
vim .vimrc
```

Add the following to your `.vimrc`:

```vim
" Global
source ~/.vim/set.vim
source ~/.vim/maps.vim
source ~/.vim/autoload.vim

" Plugins

" My plugins
" This is a plugin I wrote
"source ~/.vim/plugin/run_command.vim

" Other
" I use the following third-party plugin
"source ~/.vim/plugin/auto-pairs.vim
```

The commented-out lines show how to include your custom plugins and third-party plugins.

> **Note:** I strongly recommend browsing vim.org for plugins, which has a large database of plugins that do all sorts of great things for you: intellisense-like completion menus, a file explorer, custom color schemes, syntax files, and more. The tutorial [How To Use Vundle to Manage Vim Plugins on a Linux VPS](https://www.digitalocean.com/community/tutorials/how-to-use-vundle-to-manage-vim-plugins-on-a-linux-vps) by Justin Ellingwood teaches you how to use the Vundle vim plugin manager to install plugins.

### .vim/autoload.vi

Open `autoload.vim` using the following command:
```sh
vim .vim/autoload.vim
```
This is a very bare bones file:

```vim
" Basic indentation for comments (optional)
autocmd FileType html xml setlocal commentstring=autoload FileType css setlocal commentstring=/* %s */
```

### .vim/maps.vim

Open `maps.vim` using the following command:

```sh
vim .vim/maps.vim
```

Maps are really specific to each user. These happen to be useful to me.

```vim
" Miscellaneous
"
nnoremap <leader>O mpO<esc>`p
nnoremap <leader>o mpo<esc>`p

" Moving around
"
inoremap <leader><leader> <esc>A

" Buffers and windows
"
nnoremap <leader>wu :wincmd p<CR>
nnoremap <leader>wd :wincmd j<CR>

nnoremap Bd :bd!<cr>

" Saving Files
"
nnoremap <F4> :w<cr>:so %<cr>

nnoremap <leader>s :w<cr>a
inoremap <leader>s <esc>:w<cr>a
```

### .vim/set.vim

Open `set.vim` using the following command:

```sh
vim .vim/set.vim
```

Here is a very good collection of vim settings.

```vim
syntax on
set number

" Disable swap files
set noswapfile

" Enable spell checking
set spelllang=en_us
autocmd FileType text,markdown setlocal spell

" Enable wildmenu
set wildmenu
set wildmode=longest,list

" Display cursor position
set ruler

" Highlight current line
set cursorline

set expandtab
set tabstop=2
set shiftwidth=2

"set relativenumber
"set foldmethod=indent
"set foldnestmax=3

set splitbelow
set splitright

set mouse=a

colorscheme delek
set background=dark

set wrap
set linebreak

set showmatch

set incsearch
set nohlsearch

set autoindent
set smartindent

let mapleader=';'
```

Here are some key takeaways:

```vim
set expandtab
set tabstop=2
set shiftwidth=2
```

These settings make vim use tabs--two spaces in size-whenever possible.

```vim
"set relativenumber
"set foldmethod=indent
"set foldnestmax=3
```

I commented this out because I haven't been writing too much code lately. If you write a lot of code, I recommend trying these settings out. They enable folding for indented blocks of code and shows line numbers relative to the cursor position.

```vim
" Disable swap files
set noswapfile
```

Those vim `.swp` swap files are ignoring. This shuts them off.

```vim
set mouse=a
```

This lets you use the mouse. I didn't know this one existed until I talked to Claude 3.

```vim
set splitbelow
set splitright
```

By default `:sp` splits above and `:vs` splits right. These settings change the directions to below and left, respectively.

```vim
" Highlight current line
set cursorline
```

This is an interesting setting. It shows a horizontal line below the cursor, making it easier to see where you are.

## Step Nine -- Updating Your Repository

Congratulations for making this far. You have successfully built your dotfiles project. The last step is to update your remote repository. 

You're done! Your dotfiles repository is ready to use!

## Using Your Dotfiles Repository

Let's consume our dotfiles repository.  Create a new Codespace and launch a terminal once VS Code finishes loading. Next, change to your home directory and clone the dotfiles repository using the following commands:

```sh
# Clone the repo in home directory
cd
git clone https://github.com/username/dotfiles.git
```

> **Note:** Replace `username` above with your GitHub username.

Change to the dotfiles directory and run the installation script using the following commands:

```sh
cd !$

# Run the installation script
chmod +x ./install.sh
./install.sh

# Reload the terminal
source ~/.bashrc
```

> **Note:** `!$` represents the last argument passed to the last command.

Now all your customizations are in place. Don't forget to test everything.

## Conclusion

Congratulations for making it all the way through this tutorial! Now when you create a new Codespace, you have all of your customizations set up and you're ready to start working. Thanks for reading. Now leave, please.
