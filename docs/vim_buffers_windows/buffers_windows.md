## Buffers
A buffer is an area in memory that stores text. When you open a file, its content is read into a buffer.  When you makes changes to that buffer and save it to a file, vim copies the buffer to a file on the hard drive.

A buffer doesn't display the text, a window, or "pane",  does. 

> This tutorial will use the term pane instead of window. A 

A pane is is a section within the window. A pane can only display one buffer at a time. For simplicity, we'll assume we're working in a single pane.  We'll cover panes in more detail later.

### Viewing Buffers

Let's begin by opening vim. By default you will have one pane and one buffer.  You can view all your buffers using `:ls` or `:buffers`.

The `:ls` command produces a listing with the following format:

```text
Number  Indicator  Name     Line #
```

```vim
     1  #          "a.txt"  line 1
```

All of these fields are self-explanitory except Indicator. Indicator gives you more data about the buffer and can have any number of values or combination of values. Covering them all is outside the scope of this tutorial, so we'll only cover a few.

> For more information about Indicators, use `:help ls`.

-----------------------
| XXX | XXX |
----------------



### Creating Buffers

In order to create another buffer, you need to name the current one. Add some text to the buffer save it to a file using `:w a.txt`, and view buffers using `:ls`.

```vim
:ls
  1 %a   "a.txt"                        line 1
```

Create a new, unnamed buffer using`:enew`, and then view buffers using `:ls`.

```vim
:ls
  1 #    "a.txt"                        line 1
  3 %a   "[No Name]"                    line 1
```

Now you have two unnamed buffers.

### Navigating Between Buffers

When you have multiple buffers in memory, you can use the following commands to navigate between them.

- `:bnext`: move to next buffer.
- `:bprev`: move to previous buffer.
- `:buffer N` or `:b N`: move to buffer with number (N).

> Each time you navigate to a buffer, that buffer becomes the **active** buffer, and the previously opened buffer becomes a hidden buffer.

Let's try these commands out.  Remember from the buffers listing above that the second buffer had a number of 3. Therefore, to navigate to it use `:buffer 2` and then `:buffer 1` to navigate back to buffer 1.

Notice how both buffers are unnamed.

### Saving Buffers to Files

Buffer 1 should be active. Make some changes to it, and save it to file named `a.txt` using `:w a.txt`. Next, navigate to buffer 2 using `:buffer 2`. Give it a name using [name it]. View buffers using `:ls`, and notice how buffers 1 and 2 have the names "`a.txt`" and "`b.txt`", respectively.

```vim
[ls]
```
### Deleting Buffers

You can delete a buffer using `:bdelete`. Navigate to buffer 2 using `:buffer 2`, delete it using `:bdelete`, and view buffers using `:ls`.

```vim
[ls]
```

Now you only have buffer 1 (`a.txt`).

If you have unsaved changes to a buffer and try to delete it using `:bdelete`, vim will prompt you with [research]. You can override this and discard changes using  `:bdelete!`.

> You can delete buffers using `:q`, `:x`, and `:wq`.
> 
> - `:q`: XXX
> - `:x`: XXX
> - `:wq`: XXX

Create a new buffer using `:enew`, makes changes to it, save it to a file named `b.txt` using `:w b.txt`, and then view buffers using`:ls`.

```vim
[ls]
```
You have named buffers for both files, and buffer 2 is the active buffer.

Save changes to buffer 2 and then quit using `:wq`, and view buffers using `:ls`.

```vim
[ls]
```
Buffer 1 is the only buffer. 

Let's demonstrate deleting all buffers. Open `b.txt` using `:edit b.txt`, and view buffers using `:ls`.

```vim
[ls]
```

Both buffers are opened again. Now delete both using `:XXX`, and view buffers using `:ls`.

```vim
[ls]
```
As you can see, we are back to square one: one unnamed buffer.

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

Understand: `:ls!`, `:ls u`, and `:buffers!` display all buffers, both listed and unlisted. Conversely, `:ls` and `:buffers` _do not_ display unlisted buffers. The following code illustrates this:

```vim
" Create unlisted buffer
:enew
" List all listed and unlisted buffers
:ls!
```
#### Inactive

An inactive buffer is one that is not displayed in any pane. Using the `:new` command creates a new pane and buffer, thereby making the previously active buffer inactive.

#### Active

The active buffer is the one that is currently displayed in *any* active pane.

#### Hidden

You can have multiple buffers loaded in memory, but a pane can only display one buffer.

> All your buffers are in memory, and one buffer is displayed in the active pane.

 Any buffer not displayed in *any* pane is hidden. You can make a buffer hidden using `:hide`.

#### Loaded

Editing a file places its buffer in a loaded state. For example, if you open a file using `:edit a.txt`, that buffer is loaded.

#### Unloaded

An unloaded buffer is one that has been removed from memory; `:bunload N` does this.

#### Buffer State Examples

```vim
[examples]
```

## Panes

You can create multiple panes, allowing you to edit different buffers. Alternatively, you can edit the same buffer in multiple panes, allowing you to view and edit multiple parts of the same buffer.

Similar to how you can only have one active buffer, you can only have one active pane, and each pane has its own active buffer. Therefore, you can have multiple active buffers. Whichever pane contains the cursor is the active pane. 

> You may need to reread this a few times to understand.

### Creating Panes

There are useful settings that control how window creation and splitting work with the `:new`, `:split`, and `:vsplit` commands.

- `:new` 
- `:split` 
- `:vsplit` 

Close and re-open vim. You have one pane and one unnamed buffer. Use `:new` to create a second pane and buffer, and then `:ls` to view buffers.

```vim
[buffers]
```

Notice how the new pane contains the cursor; this is the active pane, and its fresh, unnamed buffer is the active buffer.

**DEMONSTRATE `:split`**

**DEMONSTRATE `:vsplit`**

### Pane Settings

There are settings that control the behavior of `:split` and `:vsplit`.

XXX

### Navigating Between Panes

You can navigate between panes using `:bnext`, `:bprev`, and `:buffer N`. Understand that navigating between panes simply means moving the cursor from one pane to another, thus activating a new one.

- `:wincmd j`
- `:wincmd XXX`
- `:wincmd XXX`
- `:wincmd XXX`
-  `:Ctrl-w h/j/k/l`

It's important to understand that both buffers and windows have numbers which identify them, and you use these numbers for navigation, as well as other functions. Understanding the difference between navigating between panes versus buffers will help you avoid getting lost when you have lots of open panes and buffers.

### Deleting Panes

Similar to buffers, you can use `:x`, `:bd`, `:q`, and `:wq` to close a window. 

Understand that some commands delete buffers, and some delete both panes and buffers. You can delete a buffer, or a buffer and a pane, but you can't delete a pane without deleting a buffer.

Delete the active pane using `:close`. Now you have one pane and one unnamed buffer. Confirm with `:ls`.

```vim
[ls]
```

## Challenging Example - Working With Multiple Buffers and Panes

```text
- buffers a.txt, b.txt, c.txt, d.txt
- 3 windows
- pane 1: a.txt, a.txt
- pane 2: b.txt
- pane 3: c.txt
- c.txt is hidden
- delete pane 1, a.txt, b.txt
- :ls to confirm a.txt, b.txt are deleted
- state:
-   pane 2: b.txt
-   pane 3: c.txt
- open c.txt in pane 3
- delete pane 3
- state
-   pane 2 has b.txt
- bd
- init vim state
```
