# Mastering Vim: Buffers, Windows, and Your Text Editing Arsenal

### Introduction

In this tutorial we will cover the basics of working with buffers and windows (called panes) in Vim using an example-driven approach. To get the most out of it, I strongly recommend that you keep Vim open and follow each step. Do not skip any steps. Just be patient and do each step, one at a time. Actively doing it will reinforce the concepts, making it easier to learn.

## Buffers: Your Textual Workspaces

A buffer is an area in memory that stores text. Every time you open a file, its contents are read into a buffer, allowing makes changes to that buffer without affecting the original file.

### Viewing Buffers

Let's begin by opening vim. By default you will have one unnamed buffer.  You can view all your buffers using `:ls` or `:buffers`.

Use `:ls`.

```vim
:ls
  1 %a   "[No Name]"                    line 1
```

The buffer list produced by `:ls` uses the following format:

```text
Number Indicator    Name                          Line
```

```vim
     1        %a   "[No Name]"                    line 1
```

All of these fields are self-explanatory except for Indicator. Here is an excerpt from the vim help for `:ls`:

```text
u    an unlisted buffer (only displayed when [!] is used)
        |unlisted-buffer|
 %   the buffer in the current window
 #   the alternate buffer for ":e #" and CTRL-^
 a   an active buffer: it is loaded and visible
 h   a hidden buffer: It is loaded, but currently not
        displayed in a window |hidden-buffer|
  -  a buffer with 'modifiable' off
  =  a readonly buffer
  R  a terminal buffer with a running job
  F  a terminal buffer with a finished job
  ?  a terminal buffer without a job: `:terminal NONE`
  +  a modified buffer
  x  a buffer with read errors
```

The Indicator in the above `:ls` output is `%a`, which specifies that the buffer is active (`a`) and in the current window or pane (`%`). `+` is useful; it tells you if a buffer is modified. We'll cover another useful one, `#`, later.

### Helper `:ls` Function

Throughout this article we will be issuing command-line commands followed by the `:ls` command. This would require us to use something like `:bd | ls`. This repetition can be tedious.  As a convenience I recommend adding the following function to your `.vimrc`:

```vim
" You must specify 'normal' for all normal-mode commands to work.
function! ExeCmdLs(cmd)
  if a:cmd =~ '^normal'
    exe a:cmd
    ls
  elseif empty(a:cmd)
    ls
  else
    exe a:cmd .. ' | ls'
  endif
endfunction

nnoremap <space>c :call ExeCmdLs('')<left><left>
```

In normal mode when you type `<space>c`, it places you in command-line mode and types `:call ExeCmdLs('_')`, placing your cursor at the `_`.

For the rest of the article where ever your see `:[command] | ls`, this translates to using the `<space>c[command]` macro.

### Saving Buffers to Files

Before we can create a new buffer, we need to save the active buffer to a file, effectively giving it a name. Add the text `File a.txt` to the buffer, and then use `:w a.txt | ls`.

```vim
"a.txt" [New] 1L, 11B written
  1 %a   "a.txt"                        line 1
```

Notice that the buffer is now named `a.txt`, it has a number of 1, and `%a` tells you it is the active buffer in the current window.

In addition to `:w`, you can save all open buffers using `:wa`, which stands for "write all." This saves all buffers.

### Creating Buffers

Use `:enew | ls` to create a new, unnamed buffer:

```vim
:call ExeCmdLs('enew')
  1 #    "a.txt"                        line 1
  3 %a   "[No Name]"                    line 1
```

Now we have named buffer 1, `a.txt`, and unnamed buffer 3, and buffer 3 is the active buffer. Enter the text "File b.txt", then use `:w b.txt | ls`.

```vim
"b.txt" [New] 1L, 11B written
  1      "a.txt"                        line 1
  3 %a   "b.txt"                        line 1
```

Now we have two files to work with.

### Deleting Buffers

Delete buffer 3, `b.txt` using `:bd | ls`.

```vim
"a.txt" 1L, 11B
  1 %a   "a.txt"                        line 1
```

Back to one buffer: `a.txt`.

### Opening Files Into Buffers

Open `b.txt` using `:e b.txt | ls`.

```vim
"b.txt" 1L, 11B
  1 #    "a.txt"                        line 1
  3 %a   "b.txt"                        line 1
```

Notice that buffer 1 has an indicator of `#`. This is the last edited buffer. You can use `:e #` to toggle between the current and last edited buffers. Use `:e # | ls` a few times and notice how the indicators change.

### Navigating Between Buffers

The following commands allow you to navigate between buffers:

- `:[N]bnext [N]` or `:[N]bn [N]`: move to next buffer, where N is the buffer number.
- `:[N]bprev [N]` or `:[N]bp [N]`: move to previous buffer, where N is the buffer number.
- `:[N]buffer [N]` or `:[N]b [N]`: move to specified buffer N, where N is the buffer number.
- `:bf[irst]`: move first buffer in buffer list.
- `:bl[ast]`: move to last buffer in buffer list.

From the previous `:ls` command, we have buffers 1 and 2 open, with 2 being the active buffer. Using `:bp | ls` navigates to buffer 1.

```vim
"a.txt" 1L, 10B
  1 %a   "a.txt"                        line 1
  2 #    "b.txt"                        line 1
```

Buffer 1 is now the active buffer; the `%a` indicator tells you this. Now use `:bp | ls`.

```vim
"b.txt" 1L, 11B
  1 #    "a.txt"                        line 1
  2 %a   "b.txt"                        line 1
```

Buffer 2 is now the active buffer, again, from the `%a` indicator. Similarly you can navigate to a specific buffer using `:buffer` or `:b`. Using `:b 1 | ls` navigates to buffer 1.

```vim
"a.txt" 1L, 10B
  1 %a   "a.txt"                        line 1
  2 #    "b.txt"                        line 1
```

### Iterating Over Buffers

Vim has a great command `:bufdo [command]` that allows you to perform a command over each buffer. Using `:bufdo bd` deletes all buffers.

```vim
:ls
  3 %a   "[No Name]"                    line 1
```

Let's use `:bufdo` to perform search-and-replace across multiple buffers. Open `a.txt` and `b.txt` back up using `:e a.txt | e b.txt | ls`.

```vim
"b.txt" 1L, 11B
  1 #    "a.txt"                        line 1
  2 %a   "b.txt"                        line 1
```

The contents of `a.txt` and `b.txt` are "File a.txt" and "File b.txt", respectively. Let's search-and-replace "File" with "File:". Use `:bufdo! s/File/&:/ | update`. Now, if you navigate between buffers using `:bn` and `:bp`, you will see both files have been changed.

Using `:bufdo!` prevents the `No write since last change` error. `:update` is a smarter version of `:w` in that it only saves the file if changes have been made.

### Exiting Vim

You can exit vim using the following commands:

- `:q`: Quit the current window, which can be either the pane or the Vim window. Fails when changes have been made.
- `:wq`: Write current file and close window. Quit if last edit. Writing fails when buffer is unnamed.
- `:x`: Like `:wq`, except write ony when changes have been made.

Let's look at a caveat of using quit commands. Save the active buffer and quit Vim using `:wq`. Now reopen `a.txt` and `b.txt` in Vim using the following command:

```bash
vim a.txt b.txt
```

Using `:ls` shows both files are open.

```vim
:ls
  1 %a   "a.txt"                        line 1
  2      "b.txt"                        line 0
```

Try to quit Vim using `:q`. It will say `E173: 1 more file to edit`. It seems that you have to activate every buffer before you can quit it.  Use `:bn | q` to navigate to the next buffer (2) and then quit. This should work.

> I noticed this problem when I tried to save all buffers and quit Vim using `:wa | q`, which failed.

### Buffer States

Buffer states are complex; it took me a while to understand them. Let's cover each of the six buffer states.

#### Unlisted

An unlisted buffer does not appear in the list produced using `:ls` or `:buffers`.

When would could you use an unlisted buffer? Whenever you want to temporarily create or edit text. Once you're done, you can delete the buffer and discard the changes. The following code creates an unlisted buffer:

```vim
" Create listed buffer
:enew 
" Make active buffer unlisted
:setlocal nobuflisted
```

The `:ls!` and `:ls u` commands display all buffers, both listed and unlisted. Using `:ls!` produces the following output:

```vim
:ls!
  1 #    "a.txt"                        line 1
  2      "b.txt"                        line 1
  3u%a   "[No Name]"                    line 1
```

#### Inactive

An inactive buffer is one that is not displayed in any pane. For example, using `:new` creates a new pane and buffer, thereby making the previously active buffer inactive.

#### Active

The active buffer is the one that is currently displayed in _any_ active pane. As mentioned before, the `a` indicator is a buffer list identifies an active buffer.

#### Hidden

You can have multiple buffers loaded in memory, but a pane can only display one buffer.
 In other words, any buffer not displayed in _any_ pane is hidden. You can make a buffer hidden using `:hide`.

#### Loaded

In Vim, a loaded buffer is one that has the contents of a file read into it. For example, if you open a file using `:edit a.txt`, that buffer is loaded.

#### Unloaded

`:bunload N` unloads a buffer from memory, and the contents of the file are removed from memory, but the buffer still appears in the buffer list.

## Summary

Vim's power lies in its unique approach to text management. By understanding buffers and windows (or panes), you'll unlock a new level of editing efficiency and flexibility. Let's delve deeper into these essential concepts and uncover the potential they hold for revolutionizing your Vim workflow.

## Windows (Panes): Viewing and Editing in Parallel

While buffers store your text, windows (often called panes) are sections within the Vim window that display it. Splitting your Vim window into multiple panes grants you the ability to edit and view different buffers simultaneously. This parallel editing capability empower you to streamline your workflow without constantly switching between files.

### Splitting and Navigating

Vim facilitates navigating and splitting panes using the following commands:

- `:new`: create a new pane and start editing an unnamed buffer.
- `:split {file}` `sp`: create a new pane and start editing file {file} in it. Works almost like `:split | edit {file}` when `{file}` is supplied.
- `:vsplit` `vs`: works like `:split` but split vertically.
- `:vnew`:

> Closing a pane is as simple as typing `:q` while the cursor rests within it. However, if you want to close both the pane and its associated buffer, `:bd` is your command of choice.

#### **Demonstrating `:new`**

Close and re-open vim. You have one pane and one unnamed buffer. Using `:new | ls` creates a pane below, but both panes are editing the same buffer.

```vim
:call ExeCmdLs('new')
  1 #a   "[No Name]"                    line 1
  2 %a   "[No Name]"                    line 1
```

You will notice the cursor is in the bottom pane. This is the active or current pane.

#### **Demonstrating `:vsplit`**

Now use `:vs` and notice how you now have one pane docked at the top and one pane docked on the bottom, with the bottom pane vertically divided into two sub-panes.

#### **Demonstrating `:split`**

Now let's create a different layout. Reset the buffers using `:bd | ls`.

```vim
:ls
  1 %a   "[No Name]"                    line 1
```

Use `:vs` and notice how you have one pane docked on the left and another docked on the right. Next, use `:sp` and notice how the right-docked pane is now divided horizontally into two panes.

#### Settings for `:new`, `:sp`, and `:vs`

There are settings that control the behavior of `:split` and `:vsplit`.

- `splitbelow` or `sb`: When on, splitting a pane will put the new pane below the current one.
- `splitright` or `spr`: When on, splitting a pane will put the new pane right the current one.

> You can unset a Vim option by prepending the setting with "no". For example, unset `splitbelow` using `:set nosplitbelow`.

#### Navigating Between Panes

You can navigate between panes using `:wincmd {arg}`.  Navigating between panes simply means moving the cursor from one pane to another, thus activating a new one.

- `:wincmd {arg}` or `:winc`: Changes active pane in direction specified by `{arg}`. For instance, to move cursor up, use `:winc k`.

Alternatively, you can use the hotkeys `:Ctrl-w h/j/k/l`.

> It's important to understand that both buffers and windows have numbers which identify them, and you use these numbers for navigation, as well as other functions. Understanding the difference between navigating between panes versus buffers will help you avoid getting lost when you have lots of open panes and buffers.

Similar to `:bufdo` there is a `:windo` command that lets you iterate over panes. Use `:windo echo winnr()` to display the pane number of each pane.

#### Deleting Panes

Similar to buffers, you can use `:x`, `:bd`, `:q`, and `:wq` to close a window.

> You can delete a buffer, or a buffer and a pane, but you can't delete a pane without deleting a buffer.

Let's do a test. Quite and open `a.txt` in Vim. Next, use `:vs b.txt | ls` to open `b.txt` in a right-docked pane.

```vim
"b.txt" 1L, 11B
  1 #a   "a.txt"                        line 0
  2 %a   "b.txt"                        line 1
```

> Notice how both `a.txt` and `b.txt` are active buffers, but `b.txt` is the current window (`%a`). Recall that the `%` indicator defines the active window.

Close the active pane using `:close | ls`.

```vim
:call ExeCmdLs('close')
  1 %a   "a.txt"                        line 1
  2 #    "b.txt"                        line 0
```

Both buffers still appear in the buffer list. Therefore, closing a pane doesn't delete its buffer. Reopen `b.txt` using `:vs b.txt`, and then use `:bd | ls`. You will notice that both the `b.txt` pane and buffer are removed.

```vim
:call ExeCmdLs('bd')
  1 %a   "a.txt"                        line 1
```

## Example Using Buffers and Panes

Here is an example of Vim commands that do the following. Begin by opening `a.txt`, `b.txt`, and `c.txt` in Vim.

```vim
:ls
  1 %a   "a.txt"                        line 1
  2      "b.txt"                        line 0
  3      "c.txt"                        line 0
```

Create unnamed buffer in right-docked pane, and then create unnamed buffer in bottom-docked sub-pane. You are now in the bottom right pane using `:vnew | new | ls`.

```vim
:vnew
:new
:ls
  1  a   "a.txt"                        line 0
  2      "b.txt"                        line 0
  3      "c.txt"                        line 0
  4 #a   "[No Name]"                    line 0
  5 %a   "[No Name]"                    line 1
```

Navigate to `c.txt` buffer using `:b c.txt | ls`.

```vim
:b c.txt
:ls
  1  a   "a.txt"                        line 0
  2      "b.txt"                        line 0
  3 %a   "c.txt"                        line 1
  4  a   "[No Name]"                    line 0
```

Notice how when you navigate to buffer `c.txt`, the unnamed buffer 5 is deleted.

Move cursor to top-right pane using `:winc k | ls`.

```vim
:winc k
:ls
  1 #a   "a.txt"                        line 0
  2      "b.txt"                        line 0
  3  a   "c.txt"                        line 1
  4 %a   "[No Name]"                    line 1
```

Navigate to `b.txt` buffer using `b b.txt | ls`.

```vim
:b b.txt
:ls
"b.txt" 1L, 11B
  1  a   "a.txt"                        line 0
  2 %a   "b.txt"                        line 1
  3  a   "c.txt"                        line 1
```

Always notice the indicators when you are creating multiple panes and buffers like this

You could have achieved the same thing using `:vs b.txt | sp c.txt | ls`.

```vim
:ls
  1  a   "a.txt"                        line 0
  2 #a   "b.txt"                        line 1
  3 %a   "c.txt"                        line 1
```

Notice that buffer 2 has the `#` indicator, which represents the alternate toggle buffer. Use `:e # | ls` to toggle to it.

```vim
"b.txt" 1 line --100%-- ((1) of 3)
  1  a   "a.txt"                        line 0
  2 %a   "b.txt"                        line 1
  3 #    "c.txt"                        line 1
```

Now buffer 2 is the active buffer. This is another useful indicator to look for.

Now toggle back to buffer 3 using `:e # | ls`, and then use `:bd | bd | ls` to delete buffers 2 and 3, and notice how deleting each buffer also closes its associated pane.

```vim
:bd
:bd
:ls
  1 %a   "a.txt"                        line 1
```

## Customizing and Optimizing

Beyond the fundamental commands, Vim offers a plethora of options to tailor your editing environment. By mastering buffer states (active, inactive, hidden, and unloaded), you gain a deeper understanding of Vim's text management and unlock further customization possibilities. Additionally, delve into creating and saving personalized window layouts, enabling you to craft a workspace perfectly suited to your specific tasks and preferences.

The vibrant Vim community also offers a wealth of plugins that can further enhance your buffer and window management experience. Explore these plugins to discover tools that streamline navigation, improve organization, and add even more powerful features to your arsenal.

## Embrace the Journey of Mastery

You made it! Hopefully this tutorial has demystified using buffers and panes in Vim. This barely scratches the surface of Vim's capabilities. I strongly recommend that you experiment go down rabbit holes using `:help`.

Well done, fiend. Now leave, please.
