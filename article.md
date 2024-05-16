# How to Make DigitalOcean Markdown Vim Plugin

### Introduction

Welcome to the world of vim plugins. In this tutorial you will create a plugin for generating markdown–specifically, DigitalOcean markdown–by exposing a set of insert-mode mappings for efficient markdown creation. Additionally, you will create a function that uses a vim API to search and reposition the cursor.

## Prerequisites

- You should be comfortable using a Linux terminal. Have a look at [An Introduction to the Linux Terminal](https://www.digitalocean.com/community/tutorials/an-introduction-to-the-linux-terminal).
- Experience using vim and some knowledge about creating mappings. Here is a good resource for that: [How To Use Vim for Advanced Editing of Plain Text or Code on a VPS](https://www.digitalocean.com/community/tutorials/how-to-use-vim-for-advanced-editing-of-plain-text-or-code-on-a-vps-2).

## Setting Up Plugin Files and Directories

In this section you will install vim and set up all the requisite files and directories. Let’s begin by installing vim.

## Step One -- Installing Vim

Install vim using the following command:

```sh
sudo apt update
sudo apt install vim-gtk3
```

You can verity the vim version using the following command:

```sh
vim --version
```

## Step Two -- Creating `.vimrc` and `.vim` Directories

You need a `.vimrc` file and a `.vim/plugin` directory structure. `.vimrc` is a configuration file with settings like mappings, syntax highlighting, and line numbers. Let’s create it first.

Change to your home directory using the following command:

```sh
cd
```

Use the `ls -al` command to look for `.vimrc` and `.vim`. If you don’t see one or the other, you will create them. Let’s assume you don’t see them, so you’ll create them. Use the following command to create `.vimrc`:

```sh
touch .vimrc
```

Use`mkdir` with a `-p` flag to create both the `.vim` and `.vim/plugin` folders:

```sh
mkdir -p ~/.vim/plugin
```

Your plugin goes in `~/.vim/plugin` and can be composed of a single file or a directory with multiple files. Your plugin will have multiple files, so create a directory for it using the following command:

```sh
mkdir ~/.vim/plugin/do_markdown
```

## Step Three –- Creating and Sourcing Plugin File

Change to your plugin directory and create your plugin file `do_markdown.vim` using the following commands:

```sh
cd ~/.vim/plugin/do_markdown
touch do_markdown.vim
```

To activate your plugin every time vim starts up, you need to modify `.vimrc` and source it. Edit `.vimrc` using the following command:

```sh
vim ~/.vimrc
```

Add the following line of code to the end of the file:

```vim
source ~/.vim/plugin/do_markdown/do_markdown.vim
```  

Save and exit vim using the `:x` command Good job! You just created all the plugin boilerplate.

## Building the Plugin

Markdown is a language used to format text documents with basic styles like headings, bold and italic, and block quotes. For instance, you can make text bold by surrounding–or bracketing–it with double asterisks as in \*\*Alert**.

DigitalOcean (DO) has its own cool looking markdown that works well with formatting code blocks and callouts. This plugin will generate DO markdown.

> **Note:** This plugin only generates a subset of the DO markdown. Feel free to add the rest!

This plugin creates two types of markdown: brackets and blocks. Brackets surround a string of text with symbols that apply formatting to it, and blocks are multiline sections of text enclosed in symbols. Let’s tackle brackets first.

### What Are Mappings?

Your plugin exposes a collection of mappings. A mapping is a shortcut that automates some repetitive task. Working efficiently is all about reducing keystrokes, and that is exactly what mappings do for you. As you know, vim has multiple modes of operation: insert, normal, command, and visual. Well, you can create mappings for each mode: imap, nmap, cmap, and vmap. For simplicity, this article refers to all of these generically as mappings.

## Step One -- Creating Bracket Mappings

It’s tedious to repeatedly type closing brackets, so your plugin will generate the closing bracket for you and move the cursor between the brackets. Change to your plugin’s directory and edit your plugin file using the following commands:

```sh
cd ~/.vim/plugin/do_markdown
vim do_markdown.vim
```

Enter the following code to the bottom of the file:

```vim
inoremap ** ****<left><left>
```

The following table shows what happens when you test the imap by entering insert-mode and typing `**`:

> **Note:** The **_** character represents the cursor location.

| Type: | Result         |
|-------|----------------|
| \*\*  | \*\***_**\**     |

As the table illustrates, when you type `**` in insert-mode, the mapping inserts four `*` characters and places the cursor between both pairs.

### A Problem With This Map

There is a problem with this imap: Once you finish typing `Note:` the cursor remains between the brackets as follows:

\*\*Note:**_**\**

Now you have to use `<esc>A` to move past the closing bracket. Wouldn’t it be easier if instead you could stay in insert-mode , type `;;`, and achieve the same thing--moving the cursor to the end of the line in insert-mode? Fortunately, you can create an imap to do this. The problem with using `<esc>A` is you have to move your hand off the home row, reach up and press `<esc>`, reposition your hand on the home row, then do a `<shift>a`. With an imap all you do is move your right pinky finger over slightly and press `;;`. Add the following imap to your plugin:

```vim
inoremap ;; <esc>A
```

The following table illustrates the result of using imap `;;` in conjunction with the bracket `imap **`. Begin by entering insert-mode.

| Step | Type: | Result         |
|------|-------|----------------|
| 1.   | \*\*  | \*\***_**\**     |
| 2.   | Note: | \*\*Note:**_**\** |
| 3.   | ;;    | \*\*Note:\****_** |

Observe the position of the cursor **`_`** during each step. When you test these macros, you’ll see what I mean firsthand.

There is another problem to solve: After typing `;;` you still have to tap `<space>` at the end. If you type `**` in insert-mode, and then type "Don't forget to save", this is what will happen:

\*\*Note:\**Don't forget to save

It's somewhat hard to notice, but there is no whitespace before "Don't". We need a space after it.

\*\*Note:\** Don't forget to save

**OR**

\*\*Note:\**\<space>Don't forget to save

To insert a space after \*\*Note:**, update the imap as follows:

```vim
inoremap ** ****<space><esc>2hi
```

### Mappings

Finally, here are all of the bracket imaps in this plugin. Copy them into your plugin file.

| map                                            | Type | Result  |
|--------------------------------------------    |------|---------|
| inoremap ** ****<space><esc>2hi  | \*\* | \*\***_**\*\* |
|inoremap \` \``<space><left><left>         | \`   | \`**_**\`   |
| inoremap _ __<space><left><left>            | _    | __     |
| inoremap ^ \<^>\<^><space><esc>3hi | ^    | \<^>**_**<^> |

Save and exit using the following vim command:

```vim
:x
```

### Updated `do_markdown.vim`

```vim
" UTILITIES
inoremap ;; <esc>A
nnoremap <F4> <esc>:w<cr>:so %<cr>

" BRACKETS
inoremap ** ****<space><esc>2hi
inoremap ` ``<space><left><left>
inoremap _ __<space><left><left>
inoremap ^ < ^><^><space><esc>3hi
```

## Step Two – Creating Block Templates and Mappings

Now you’ll create your block imaps, which generate multiline blocks of text using simple parameterized templates. Consider the following DO markdown code block:

````
```sh
vim test.py
```
````

You will create a template that substitutes XXX in sections that you will edit. Create a template named `code.txt` using the following command.

```sh
vim code.txt
```

Enter the following text:

```
...XXX
XXX
...
```

Save and close the file using the following vim command:

```vim
:wq
```

Reopen your plugin file using the following command:

```sh
vim do_markup.vim
```

Now you will make an imap that reads the template file into the active buffer. Add this to your plugin:

```vim
inoremap code<cr> <esc>:read code.txt<cr>kdd
```

> **Note:** The normal-mode `kdd` command deletes the blank line that gets added when you read file contents in.

Test it by entering insert-mode and typing `code<cr>`. It should dump the contents of `code.txt` at the cursor.

### Updated `do_markdown.vim`

```vim
" UTILITIES
inoremap ;; <esc>A
nnoremap <F4> <esc>:w<cr>:so %<cr>

" BRACKETS
inoremap ** ****<space><esc>2hi
inoremap ` ``<space><left><left>
inoremap _ __<space><left><left>
inoremap ^ < ^><^><space><esc>3hi

" BLOCKS
inoremap code<cr> <esc>:read code.txt<cr>kdd
```

Here is the most tedious part. You need to create all of the templates for all of the block imaps. Here are the download links for each file:

[code.txt](https://github.com/boonecabaldev)
[out.txt](https://github.com/boonecabaldev)
[lab.txt](https://github.com/boonecabaldev)
[crp.txt](https://github.com/boonecabaldev)
[ecod.txt](https://github.com/boonecabaldev)
[elab.txt](https://github.com/boonecabaldev)
[eout.txt](https://github.com/boonecabaldev)
[ecpr.txt](https://github.com/boonecabaldev)
[nowa.txt](https://github.com/boonecabaldev)
[note.txt](https://github.com/boonecabaldev)
[warn.txt](https://github.com/boonecabaldev)
[info.txt](https://github.com/boonecabaldev)
[drft.txt](https://github.com/boonecabaldev)
[col.txt](https://github.com/boonecabaldev)
[dets.txt](https://github.com/boonecabaldev)

You will create the rest of the block imaps later in the tutorial.

## Step Three -- Making Function to Load Templates

You’re going to make a lot of these imaps, so it wouldn’t hurt to use the following function to avoid code duplication. Add this to your plugin:

```vim
function LoadTemplate(template_filename)

  silent execute 'read ' . a:template_filename
  normal kdd

endfunction
```

Update your `imap code<cr>` to invoke `LoadTemplate` as follows:

```vim
inoremap code<cr> <esc>:call LoadTemplate('code.txt')<cr>
```

This is the basic structure you will use to create all of the block imaps in this plugin.

### Updated `do_markdown.vim`

```vim
" UTILITIES
inoremap ;; <esc>A
nnoremap <F4> <esc>:w<cr>:so %<cr>

function LoadTemplate(template_filename)

  silent execute 'read ' . a:template_filename
  normal kdd

endfunction

" BRACKETS
inoremap ** ****<space><esc>2hi
inoremap ` ``<space><left><left>
inoremap _ __<space><left><left>
inoremap ^ < ^><^><space><esc>3hi

" BLOCKS
inoremap code<cr> <esc>:call LoadTemplate('code.txt')<cr>
```

## Step Four – Creating Cursor Movement Function

After inserting the template file contents into the buffer, the next step is to move the cursor to the next XXX and replace it with the cursor in insert-mode. To accomplish this, you are going to create a function named `ToEndOrNext` that does the job of your `imap ;;` plus the aforementioned functionality. Below is the pseudo code for it:

```text
If there is no template_param in the file
  Move cursor to end of line in insert-mode
Else
  Move cursor to next template_param
Replace template_param with cursor in insert-mode
```

Add the following code to your plugin:

```vim
function ToEndOrNext(template_param)

  if search(a:template_param, 'n')
    execute "normal! /" . a:template_param . "\r"
    normal diw
    startinsert!
  else
    startinsert
  endif

endfunction

```

This uses the `search` VimL API to search for `template_param`. Using the `n` option allows you to search for a string without moving the cursor to the match–a look-ahead search, if you will.

Let’s test it. Save and source the plugin using the following vim commands:

```vim
:w
:so %
```

Create a new buffer using the following vim command:

```vim
:new
```

Enter insert-mode and type `code<cr>`. This will read in the `code.txt` template. Now, use the following vim command to test `ToEndOrNext`:

```vim
:call ToEndOrNext('XXX')
```

The cursor should have replaced the first XXX.  Use `:call ToEndOrNext('XXX')` again.  The next XXX should be replaced by the cursor. At this point both XXX strings should be gone. Now test `ToEndOrNext` by moving the cursor to the middle of a line, enter insert-mode, then use `<esc>:call ToEndOrNext('XXX')<cr>`. The cursor should move to the end of the line in insert-mode.

Next, update your `imap ;;` to invoke `ToEndOrNext` as follows:

```vim
inoremap ;; <esc>:call ToEndOrNext('XXX')<cr>
```

Almost there. After you load a template using `imap code<cr>`, you want it to move to the next XXX and replace it with the cursor in insert-mode.  Hence, you call `ToEndOrNext` from within `LoadTemplate`.

### Updated `do_markdown.vim`

```vim
" UTILITIES
inoremap ;; <esc>:call ToEndOrNext('XXX')<cr>
nnoremap <F4> <esc>:w<cr>:so %<cr>

function LoadTemplate(template_filename)

  silent execute 'read ' . a:template_filename
  normal kdd
  
  call ToEndOrNext('XXX')

endfunction

function ToEndOrNext(template_param)

  if search(a:template_param, 'n')
    execute "normal! /" . a:template_param . "\r"
    normal diw
    startinsert!
  else
    startinsert
  endif

endfunction

" BRACKETS
inoremap ** ****<space><esc>2hi
inoremap ` ``<space><left><left>
inoremap _ __<space><left><left>
inoremap ^ < ^><^><space><esc>3hi

" BLOCKS
inoremap code<cr> <esc>:call LoadTemplate('code.txt')<cr>
```

## Tying It All Together

The final step is to create the rest of your block imaps.  Remember when you downloaded all of the template files earlier?  Now it is only a matter of calling your `LoadTemplate` function, passing the name of the template file. Here is your complete plugin with the block imaps and everything else:

### Blocks

`inoremap code<cr> <esc>:call LoadTemplate('code.txt')<cr>`

##### code.txt

````
```_
XXX
```
````

`inoremap out<cr> <esc>:call LoadTemplate('out.txt')<cr>`

##### out.txt

````
```
[secondary_label Output]
_
```
````

`inoremap lab<cr> <esc>:call LoadTemplate('lab.txt')<cr>`

##### lab.txt

````
```
[label _]
XXX
```
````

`inoremap cpr<cr> <esc>:call LoadTemplate('crp.txt')<cr>`

##### crp.txt

````
```custom_prefix(_)
XXX
```
````

#### Environment Variations

`inoremap ecod<cr> <esc>:call LoadTemplate('ecod.txt')<cr>`

##### ecod.txt

````
```_
[environment XXX]
XXX
```
````

`inoremap elab<cr> <esc>:call LoadTemplate('elab.txt')<cr>`

##### elab.txt

````
```
[environment _]
[label XXX]
XXX
```
````

`inoremap eout<cr> <esc>:call LoadTemplate('eout.txt')<cr>`

##### eout.txt

````
```
[environment _]
[secondary_label Output] XXX
```
````

`inoremap ecpr<cr> <esc>:call LoadTemplate('ecpr.txt')<cr>`

##### ecpr.txt

````
```custom_prefix(XXX)
[environment XXX]
XXX
```
````

#### Callouts

 `inoremap nowa<cr> <esc>:call LoadTemplate('nowa.txt')<cr>`

##### nowa.txt

```text
<$>[_]
**XXX:** XXX
<$>
```

`inoremap note<cr> <esc>:call LoadTemplate('note.txt')<cr>`

##### note.txt

```text
<$>[note]
**Note:** _
<$>
```

`inoremap warn<cr> <esc>:call LoadTemplate('warn.txt')<cr>`

##### warn.txt

```text
<$>[warning]
**Warning:** _
<$>
```

`inoremap info<cr> <esc>:call LoadTemplate('info.txt')<cr>`

##### info.txt


````
```
<$>[info]
**Info:** _
<$>
```
````

`inoremap drft<cr> <esc>:call LoadTemplate('drft.txt')<cr>`

##### drft.txt

```text
<$>[draft]
**Draft:** _
<$>
```

**Formatting**

`inoremap col<cr> <esc>:call LoadTemplate('col.txt')<cr>`

##### col.txt

```text
[column
_
]
[column
XXX
]
```

[details `inoremap dets<cr> <esc>:call LoadTemplate('dets.txt')<cr>`

##### dets.txt

```text
[details _
XXX
]
```

### Updated do_markup.vim

```vim
" UTILITIES
inoremap ;; <esc>:call ToEndOrNext('XXX')<cr>
nnoremap <F4> <esc>:w<cr>:so %<cr>

function LoadTemplate(template_filename)

  silent execute 'read ' . a:template_filename
  normal kdd
  
  call ToEndOrNext('XXX')

endfunction

function ToEndOrNext(template_param)

  if search(a:template_param, 'n')
    execute "normal! /" . a:template_param . "\r"
    normal diw
    startinsert!
  else
    startinsert
  endif

endfunction

" BRACKETS
inoremap ** ****<space><esc>2hi
inoremap ` ``<space><left><left>
inoremap _ __<space><left><left>
inoremap ^ < ^><^><space><esc>3hi

" BLOCKS
inoremap code<cr> <esc>:call LoadTemplate('code.txt')<cr>
inoremap out<cr> <esc>:call LoadTemplate('out.txt')<cr>
inoremap lab<cr> <esc>:call LoadTemplate('lab.txt')<cr>
inoremap cpr<cr> <esc>:call LoadTemplate('crp.txt')<cr>
inoremap ecod<cr> <esc>:call LoadTemplate('ecod.txt')<cr>
inoremap elab<cr> <esc>:call LoadTemplate('elab.txt')<cr>
inoremap eout<cr> <esc>:call LoadTemplate('eout.txt')<cr>
inoremap ecpr<cr> <esc>:call LoadTemplate('ecpr.txt')<cr>
inoremap nowa<cr> <esc>:call LoadTemplate('nowa.txt')<cr>
inoremap note<cr> <esc>:call LoadTemplate('note.txt')<cr>
inoremap warn<cr> <esc>:call LoadTemplate('warn.txt')<cr>
inoremap info<cr> <esc>:call LoadTemplate('info.txt')<cr>
inoremap drft<cr> <esc>:call LoadTemplate('drft.txt')<cr>
inoremap col<cr> <esc>:call LoadTemplate('col.txt')<cr>
inoremap dets<cr> <esc>:call LoadTemplate('dets.txt')<cr>
```

## How I Use This Plugin

I use this plugin from VS Code. Using an extension called _Markdown Preview_, I preview a markdown file. Files dock to the top by default. Next, I open the markdown file in vim from a terminal, which docks to the bottom by default. Now, any time I change and save the markdown file in vim, the preview updates to reflect the change.

I typically use the following normal- and insert-mode mappings to quickly save the file.

```vim
nnoremap ;s :w<cr>
inoremap ;s <esc>:w:<cr>
```

## Conclusion

You’ve learned a little bit about mappings and VimL. I hope you use this knowledge to experiment with your own vim plugins. Have fun, friend.
