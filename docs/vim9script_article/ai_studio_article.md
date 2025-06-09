# Supercharge Your Vim: An Introduction to Vim9script

For decades, Vim's power has been synonymous with its extensibility. The engine behind this customization has always been Vimscript (often called legacy Vimscript). While powerful, it has its quirks: a unique syntax, and performance that can lag in complex plugins.

Enter **Vim9script**, the most significant evolution in Vim's scripting language since its inception. Introduced in Vim 9.0, it's a ground-up rewrite designed to be faster, cleaner, and more familiar to developers coming from modern languages like Python or JavaScript.

This article will explain what Vim9script is, why it was created, and how you can start using its powerful features today.

### Why Was Vim9script Created?

Vim's creator, Bram Moolenaar, set out to solve the long-standing pain points of legacy Vimscript:

1. **Performance:** Legacy Vimscript is interpreted line by line. For simple tasks, this is fine. But for complex plugins that process large amounts of text or data, this interpretation becomes a significant bottleneck. Vim9script is **compiled into bytecode** before execution, resulting in a dramatic speed increase—often 10 to 100 times faster.
2. **Syntax:** Legacy syntax is inconsistent. You `call` a function but `let` a variable. String concatenation is done with a dot (`.`). The syntax feels dated and can be a barrier for new plugin developers.
3. **Error Handling:** Legacy script can often fail silently or produce cryptic error messages. It's easy to make a typo in a variable name and have it evaluate to `0` without any warning. Vim9script is much stricter, catching errors early and providing clearer feedback.

### Getting Started: The `vim9script` Command

To tell Vim you are writing Vim9script, simply add this command as the **very first line** of your script file (`.vim` file) or function block:

```vim
vim9script
```

Any code in that file will now be parsed and executed by the Vim9 engine. If this line is absent, Vim will treat the file as legacy Vimscript for backward compatibility.

### Key Features and Examples

Let's dive into the core differences and see how they make scripting more intuitive.

#### 1. Modern Variable and Function Declarations

The verbose `let` and `function` keywords are streamlined.

- **Variables:** Use `var` to declare a variable. Re-assignment doesn't require any keyword.
- **Functions:** Use `def` to define a function.

**Legacy Vimscript:**

```vim
let s:greeting = "Hello"
function! s:Greet(name)
  return s:greeting . ', ' . a:name . '!'
endfunction
```

**Vim9script:**

```vim
vim9script

var greeting = "Hello" # Script-local by default (s: is implied)
def Greet(name: string): string # Functions are script-local by default
  return `${greeting}, {name}!`
enddef
```

*Notice: `s:` for script-local scope is now the default for `var` and `def`. Global scope (`g:`) and other scopes still require the prefix.*

#### 2. Type Safety (Optional but Powerful)

You can (and should) declare types for variables, function arguments, and return values. This helps catch bugs and makes code self-documenting.

```vim
vim9script

var score: number = 0
var names: list<string> = ['Alice', 'Bob']

# This function must be called with a number and must return a string.
def GetMessage(points: number): string
  if points > 100
    return "Excellent work!"
  endif
  return "Keep trying."
enddef
```

If you tried to assign a string to `score` or call `GetMessage("abc")`, Vim9 would raise an error immediately.

#### 3. No More `call` and `let`

The keywords `call` (for functions) and `let` (for re-assignment) are gone. You call functions and assign variables just like in most other languages.

**Legacy Vimscript:**

```vim
let my_var = 10
let my_var = my_var + 5
call MyLegacyFunction()
```

**Vim9script:**

```vim
vim9script

var my_var = 10
my_var += 5         # Re-assignment is clean
MyVim9Function()    # Direct function call
```

#### 4. Modern Comments and String Interpolation

Vim9script adopts common conventions for comments and strings.

- **Comments:** Use `#` instead of `"`. This aligns with a huge number of modern languages.
- **String Interpolation:** Use backticks and `${...}` (template literals), similar to JavaScript, for cleaner string formatting.

**Legacy Vimscript:**

```vim
" Greet the user
let user = "Alex"
echo "Hello, " . user . ". Welcome back."
```

**Vim9script:**

```vim
vim9script

# Greet the user
var user = "Alex"
echo `Hello, {user}. Welcome back.` # So much cleaner!
```

#### 5. Compiled Functions

Functions defined with `def` are compiled for performance. You can also add the `compile` keyword to a legacy function to gain some speed, but `def` is the native, fully-optimized way.

```vim
vim9script

# This function is compiled to bytecode for maximum speed.
def ProcessLines()
  for i in 1 .. 10000
    # ... do some intensive work
  endfor
enddef
```

### Side-by-Side Comparison: A Practical Example

Let's write a simple function that capitalizes the current word under the cursor and reports it.

#### Legacy Vimscript Example (`~/.vim/plugin/legacy_util.vim`)

```vim
" legacy_util.vim
" A function to capitalize the current word

function! s:CapitalizeWord()
  " Save cursor position
  let l:save_cursor = getpos('.')

  " Visually select the word under the cursor
  normal! viw

  " Yank the word, convert to uppercase, and get it into a variable
  let l:word = getreg('"')
  let l:upper_word = toupper(l:word)

  " Replace the word in the buffer
  execute "normal! c" . l:upper_word . "\<Esc>"

  " Restore cursor position
  call setpos('.', l:save_cursor)

  " Report to user
  echo "Capitalized: " . l:upper_word
endfunction

command! Capitalize call s:CapitalizeWord()
```

#### Vim9script Example (`~/.vim/plugin/vim9_util.vim`)

```vim
# vim9_util.vim
# A function to capitalize the current word, written in Vim9script

vim9script

def CapitalizeWord()
  # Save cursor position
  var save_cursor = getpos('.')

  # Visually select the word under the cursor
  normal! viw

  # Yank, convert, and store the word
  var word = getreg('"')
  var upper_word = toupper(word)

  # Replace the word. Note the clean execute() and template literal
  execute 'normal!' `c{upper_word}`
  normal! <Esc>

  # Restore cursor position
  setpos('.', save_cursor)

  # Report to user with a template literal
  echo `Capitalized: {upper_word}`
enddef

command! CapitalizeV9 CapitalizeWord()
```

The Vim9script version is more readable, less cluttered, and for more complex operations, would be significantly faster.

### Who Should Use Vim9script?

- **Plugin Developers:** The performance gains are a compelling reason to write new plugins in Vim9script or even migrate existing ones.
- **Vim Power Users:** If your `vimrc` or `init.vim` is growing complex with many custom functions, switching to Vim9script can make it cleaner, faster, and easier to debug.
- **Anyone Learning Vim Scripting:** For newcomers, Vim9script is a much gentler introduction. Its syntax is more conventional and its error-checking will help you learn faster.

### Conclusion

Vim9script is a leap forward for Vim. It respects the editor's heritage while embracing modern programming concepts. By offering a massive **performance boost**, a **cleaner syntax**, and **robust type-checking**, it empowers users to build more powerful and reliable tools than ever before.

The next time you write a new function or script for Vim, start it with `vim9script` and give it a try. You'll be building on a foundation designed for the future.

For the definitive guide, always refer to Vim's built-in help: `:help vim9script`.

Of course! Here is the next part of the article, continuing from the introduction and diving into more advanced and practical features of Vim9script.

---

## Vim9script: Diving Deeper into Advanced Features

In the first part of our guide, we covered the "why" of Vim9script and its foundational changes: the `vim9script` declaration, modern `var` and `def` syntax, type safety, and cleaner string handling. Now that you have a feel for the basics, let's explore the features that truly unlock its potential for building complex and organized Vim configurations and plugins.

We'll dive into enhanced data structures, powerful looping, the new module system, and a more robust way to handle scope.

### 5. Enhanced Lists and Dictionaries

While lists and dictionaries existed in legacy script, Vim9 makes them first-class citizens with stricter typing and a more familiar syntax.

#### Typed Data Structures

You can declare lists and dictionaries that only hold specific types. This prevents runtime errors where you might accidentally insert a number into a list of strings.

```vim
vim9script

# A list that can only contain numbers
var scores: list<number> = [99, 87, 100]
# scores->add("failed") # This would cause an error!

# A dictionary mapping strings to strings
var user_data: dict<string> = {
  name: "Alice",
  role: "admin",
}
# user_data['id'] = 123 # This would also cause an error!

# For mixed types, use the 'any' type
var mixed_bag: list<any> = [1, "two", [3, 4]]
```

This strictness is a huge benefit for writing reliable code, as Vim can catch type mismatches before your script even runs.

#### Cleaner Syntax

The syntax for defining and accessing these structures is now cleaner and more aligned with languages like Python.

**Legacy Vimscript:**

```vim
let s:my_list = [1, 2, 3]
let s:my_dict = {'key1': 'val1', 'key2': 'val2'}
call add(s:my_list, 4)
echo s:my_dict.key1
```

**Vim9script:**

```vim
vim9script

var my_list = [1, 2, 3]
var my_dict = {key1: 'val1', key2: 'val2'} # Quotes on keys are optional

my_list->add(4)  # Method-style calls on variables
echo my_dict.key1
```

*Notice the `->` syntax for calling methods like `add()` on a variable. This is a consistent pattern in Vim9script.*

### 6. Powerful Looping Constructs

Loops are the heart of any script that processes multiple lines or items. Vim9 streamlines them significantly.

The standard `for` loop is still here, but it's now part of the compiled, faster engine.

**Legacy Vimscript:**

```vim
for i in range(1, 3)
  echo "Legacy loop item " . i
endfor
```

**Vim9script:**

```vim
vim9script

for i in range(1, 3)
  echo `Vim9 loop item {i}`
endfor
```

Where Vim9 truly shines is in iterating over data structures. A common pattern is needing both the index and the value of a list item.

```vim
vim9script

var players = ["Archer", "Lana", "Cyril"]

# Get both index and value, similar to Python's enumerate()
for [i, name] in players->items()
  echo `Player {i + 1}: {name}`
endfor

# Output:
# Player 1: Archer
# Player 2: Lana
# Player 3: Cyril
```

This destructuring assignment (`[i, name]`) is a powerful and expressive feature that makes code much more readable than managing a separate counter variable.

### 7. Understanding Scope in Vim9script

Scope determines where a variable or function is accessible. Vim9 simplifies this by making the most common scope—**script-local**—the default.

- `var my_var`: This is a **script-local** variable (equivalent to `s:my_var` in legacy script). It can only be accessed from within the same `.vim` file.
- `def MyFunction()`: This is a **script-local** function (equivalent to `s:MyFunction` in legacy script).

If you need to use other scopes, you must declare them explicitly, just as you did in legacy script. This makes your intention clear.

```vim
vim9script

# Script-local (default, most common)
var script_var = "I'm only in this file"

# Global scope (accessible everywhere)
var g:my_plugin_setting = true

# Buffer-local scope (tied to the current buffer)
var b:did_format_on_save = false

# Window-local scope
var w:my_window_id = 1

# Tab-local scope
var t:my_tab_name = "docs"
```

This "default to local" philosophy prevents polluting the global namespace, a common problem in larger Vim configurations that can lead to name collisions between different plugins.

### 8. Autoloading and Modules with `import` and `export`

This is one of the most transformative features for plugin authors. In the past, sharing code between files meant relying on the `autoload` mechanism, which involved calling functions with long, clunky names.

**The Old Way (Legacy Autoload):**
You would have a file `~/.vim/autoload/my/utils.vim` and call a function from it like this: `call my#utils#sharedFunction()`.

Vim9 introduces a true module system with `import` and `export`.

#### The Module: `export`

Let's create a utility module. We'll place it in the traditional autoload directory so Vim can find it.

**File: `~/.vim/autoload/my_utils.vim`**

```vim
# ~/.vim/autoload/my_utils.vim

vim9script

# This function will be available for other scripts to import.
export def GetTimestamp(): string
  return strftime('%Y-%m-%d %H:%M:%S')
enddef

# You can also export constants.
export const PLUGIN_VERSION = "1.0.0"

# This function is NOT exported, so it's private to this file.
def privateHelper()
  # ...
enddef
```

By using `export`, you are explicitly marking which parts of your script are part of its public API.

#### The Consumer: `import`

Now, in another script (or your `vimrc`), you can import and use this functionality directly.

**File: `~/.vim/plugin/my_plugin.vim`**

```vim
# ~/.vim/plugin/my_plugin.vim

vim9script

# Import specific items from our module.
# Vim automatically searches the 'autoload' directories.
import GetTimestamp, PLUGIN_VERSION from "my_utils.vim"

# You can also import everything with a wildcard.
# import * from "my_utils.vim"

def ShowInfo()
  # Use the imported function and constant directly!
  var message = `Plugin v{PLUGIN_VERSION} loaded at {GetTimestamp()}`
  echo message
enddef

command! MyPluginInfo ShowInfo()
```

This system is:

- **Cleaner:** No more `my#utils#...` prefixes.
- **Safer:** You only get access to what was explicitly exported.
- **More Performant:** Imported scripts are compiled and loaded only once.

### The Journey Continues

With features like typed data structures, modern loops, and a real module system, Vim9script is not just a faster version of legacy script—it's a fundamentally more powerful and modern language. It provides the tools to build sophisticated, well-organized, and performant plugins that were previously much more difficult to create and maintain.

As you continue your journey, the best resource is Vim's own documentation. Run these commands to learn even more:

- `:help vim9-differences` (A comprehensive list of differences from legacy script)
- `:help vim9-export` (Details on the import/export system)
- `:help :def` (The full story on compiled functions)

Happy scripting

Of course! Here is the third and final part of the article, covering advanced control structures, object-oriented patterns, and interoperability with legacy script.

---

## Mastering the Flow: Advanced Control and Organization in Vim9script

We've journeyed from the basics of Vim9script's syntax to its powerful module system. Now, we'll explore the final pieces of the puzzle: features that allow for professional-grade scripting, including robust error handling, object-oriented patterns, and seamless integration with the vast ecosystem of legacy Vimscript.

These advanced features are what elevate Vim9script from a simple configuration language to a serious development environment inside your editor.

### 9. Robust Error Handling with `try...catch`

One of the most significant weaknesses of legacy Vimscript was its brittle error handling. A single unexpected error could halt an entire script. Vim9 introduces a `try...catch` block, a familiar construct for anyone who's used JavaScript, Python, or Java.

This allows you to gracefully handle potential failures, such as file I/O errors or invalid user input, without crashing your plugin.

The structure is `try...catch...finally...endtry`.

- **`try`**: Contains the code that might fail.
- **`catch`**: This block executes *only if* an error occurs in the `try` block. You can inspect the error message through the built-in `v:exception` variable.
- **`finally`**: This block *always* executes, whether an error occurred or not. It's perfect for cleanup tasks, like closing a file or restoring a setting.

**Example: Safely Reading a Configuration File**

```vim
vim9script

def LoadConfig(path: string): dict<any>
  var config = {}
  try
    # This line might fail if the file doesn't exist or we can't read it
    var file_lines = readfile(path)
    config = json_decode(join(file_lines))
    echo "Configuration loaded successfully."
  catch
    # An error occurred! Report it gracefully.
    echowarn `Could not load config from {path}. Using defaults.`
    echowarn `Reason: {v:exception}`
    # v:exception contains the error message, e.g., "E484: Can't open file..."
  finally
    # This code runs no matter what.
    echo "Config loading process finished."
  endtry
  return config
enddef

# Let's try to load a file that probably doesn't exist
var my_config = LoadConfig('/tmp/nonexistent_config.json')
```

Using `try...catch` is essential for writing resilient plugins that can handle the unpredictable nature of user systems.

### 10. Object-Oriented Style with Dictionaries and Methods

While Vim9script doesn't have a formal `class` keyword like other languages, it allows you to achieve a powerful object-oriented style by attaching functions directly to dictionaries. This lets you bundle state (data) and behavior (functions) together into a single, cohesive unit.

You can define a function directly inside a dictionary literal.

**Example: A Simple Counter "Object"**

```vim
vim9script

# This function will become a method of our 'Counter' object
export def CreateCounter(initial_value = 0): dict<any>
  var counter_obj = {
    count: initial_value,

    # This function is attached to the dictionary instance
    # It automatically has access to 'this', which refers to the dictionary itself
    def Increment()
      this.count += 1
    enddef,

    def GetValue(): number
      return this.count
    enddef,
  }
  return counter_obj
enddef

# --- In another file, or later in the same script ---
# import CreateCounter from "my_counter_module.vim"

var counterA = CreateCounter()
counterA.Increment()
counterA.Increment()
echo `Counter A is: {counterA.GetValue()}` # Output: Counter A is: 2

var counterB = CreateCounter(100)
counterB.Increment()
echo `Counter B is: {counterB.GetValue()}` # Output: Counter B is: 101
```

This pattern is incredibly useful for managing complex state within a plugin, preventing global variables and making your code much more organized and reusable.

### 11. Lambdas and Functional Programming

For quick, one-off operations, defining a full named function can be overkill. Vim9 introduces **lambdas** (also known as anonymous functions) for this exact purpose. They are lightweight, inline functions that are especially useful with list-processing functions like `map()` and `filter()`.

The syntax is `(arguments) => expression`.

**Example: Filtering and Mapping a List of Numbers**

```vim
vim9script

var numbers = [1, 2, 3, 4, 5, 6, 7, 8]

# Without lambdas, you would need a separate function.
# With lambdas, the logic is right where you need it.

# 1. Filter out all odd numbers
var even_numbers = numbers->filter((idx, val) => val % 2 == 0)
# even_numbers is now [2, 4, 6, 8]

# 2. Square each of the remaining numbers
var squares = even_numbers->map((idx, val) => val * val)
# squares is now [4, 16, 36, 64]

echo squares
```

Lambdas make your code more concise and declarative, allowing you to express *what* you want to do with a list rather than explicitly writing the loop to do it.

### 12. Interacting with Legacy Vimscript

You won't rewrite your entire Vim ecosystem overnight. For a long time, Vim9script will need to coexist with legacy scripts. Fortunately, interoperability is straightforward.

#### Calling Legacy Code from Vim9script

You can call legacy functions directly. If it's a script-local legacy function, you'll need a way to reference it. The easiest way is to use the `s:` prefix explicitly. For autoloaded functions, you use the standard `autoload#` syntax.

```vim
vim9script

# Assuming legacy_functions.vim is sourced and contains:
# function! s:OldGreet(name)
#   return "Greetings, " . a:name
# endfunction

# You need to use <SID> to get the script ID of the legacy file
# and then call the function.
# NOTE: This is complex. The better way is to use autoload.

# A better example: calling an autoloaded legacy function
var result = legacy#utils#DoSomething("data")
echo result
```

#### Calling Vim9 Code from Legacy Script

This is the more common and recommended pattern for migration. You can gradually rewrite parts of your plugin in Vim9script and call them from the legacy parts.

To make a Vim9 function callable from outside its file, it must be **exported**. Legacy script can then call it using the standard `autoload#` syntax.

**File: `~/.vim/autoload/new_utils.vim`**

```vim
vim9script

export def Greet(name: string): string
  return `Hello from Vim9, {name}!`
enddef
```

**From your `vimrc` or a legacy plugin file:**

```vim
" Now call the Vim9 function from legacy script
let message = new_utils#Greet('world')
echo message
" Output: Hello from Vim9, world!
```

This `export`-and-call pattern is the bridge that allows for a smooth, piece-by-piece migration to Vim9script.

### Conclusion: The Future is Compiled

From its foundational syntax to its advanced control structures, Vim9script represents a paradigm shift for Vim customization. We've seen how it offers:

- **Speed:** Through just-in-time compilation.
- **Readability:** With a modern, less-cluttered syntax.
- **Reliability:** Thanks to type safety, stricter error checking, and robust `try...catch` blocks.
- **Organization:** Via a true module system and object-oriented patterns.

Whether you are a seasoned plugin author or a user looking to organize a sprawling `vimrc`, Vim9script provides the tools to write faster, cleaner, and more powerful code. The future of Vim extensibility is here, and it's faster than ever. It's time to start that new plugin idea or refactor that old, slow function. Your editor will thank you for it.

Of course. This part of the series will shift from theory to practice, demonstrating how to apply the concepts from the previous articles by building a small, useful plugin from scratch.

---

## Vim9script in Action: Building a Practical Notes Manager

In the previous parts of this series, we explored the syntax, features, and advanced patterns of Vim9script. We've learned about its speed, modern syntax, and powerful organizational tools. Now, it's time to put that knowledge to work.

Theory is essential, but building something tangible is where the concepts truly solidify. In this article, we'll walk through the creation of a simple, yet practical, notes manager plugin. This project will touch upon everything we've covered: modules, error handling, modern data structures, and creating user-facing commands.

### The Goal: A Simple Notes Plugin

Our plugin will have three core features:

1. **`NotesNew {title}`**: Creates a new note with a given title.
2. **`NotesEdit`**: Presents a list of existing notes and lets the user open one for editing.
3. **`NotesList`**: Prints a list of all available notes.

This simple feature set requires us to handle file I/O, user input, and string manipulation—common tasks in any Vim plugin.

### Step 1: Structuring the Plugin

A well-structured plugin separates its core logic from its user-facing interface (commands and mappings). This makes the code easier to maintain and test. We'll follow this best practice by creating two files:

1. **`~/.vim/autoload/notes.vim`**: This will be our **module**. It will contain all the core logic for creating, finding, and listing notes. Using the `autoload` directory means Vim will only load and compile this script when one of its functions is first called.
2. **`~/.vim/plugin/notes_ui.vim`**: This will be our **entry point**. It will define the user commands (`:NotesNew`, etc.) and will `import` the functionality from our `notes.vim` module. Files in the `plugin` directory are sourced automatically when Vim starts.

### Step 2: Writing the Core Logic (The Module)

Let's start with the heart of our plugin. Create the file `~/.vim/autoload/notes.vim` and add the following code, which we'll break down piece by piece.

**File: `~/.vim/autoload/notes.vim`**

```vim
# ~/.vim/autoload/notes.vim
# Core logic for the notes manager plugin

vim9script

# Use a constant for the notes directory. This is good practice.
# expand('~/.config/vim/notes') might be better on modern systems.
export const NOTES_DIR = expand('~/vim-notes')

# A private helper function. It is not exported, so it's only usable
# within this file.
def EnsureNotesDir()
  if !isdirectory(NOTES_DIR)
    echo `Creating notes directory: {NOTES_DIR}`
    mkdir(NOTES_DIR, "p")
  endif
enddef

# Sanitizes a title to be a valid filename.
# e.g., "My First Note!" -> "my-first-note"
def SanitizeTitle(title: string): string
  var filename = tolower(title)
  filename = substitute(filename, '\s\+', '-', 'g')      # spaces -> hyphens
  filename = substitute(filename, '[^a-z0-9-]', '', 'g') # remove invalid chars
  return filename
enddef

# --- Exported API ---

export def CreateNote(title: string)
  EnsureNotesDir()
  var filename = SanitizeTitle(title)
  if empty(filename)
    echowarn "Cannot create note with an empty title."
    return
  endif

  var filepath = $"{NOTES_DIR}/{filename}.md"

  try
    # 'x' flag fails if the file already exists.
    writefile([], filepath, 'x')
    echo `Created note: {filepath}`
    # Open the new note for the user
    execute 'edit' filepath
  catch /E739:/ # Specific error code for "File exists"
    echowarn `Note '{filename}.md' already exists. Opening it.`
    execute 'edit' filepath
  catch
    echohl ErrorMsg
    echo `Failed to create note. Reason: {v:exception}`
    echohl None
  endtry
enddef

export def GetNoteList(): list<string>
  EnsureNotesDir()
  # Use globpath() to find all markdown files in our directory
  var files = globpath(NOTES_DIR, '*.md', 1, 1)
  if empty(files)
    return []
  endif

  # Use map() and a lambda to clean up the filenames for display
  return files->map((_, val) => fnamemodify(val, ':t:r'))
enddef

export def EditNote()
  var notes = GetNoteList()
  if empty(notes)
    echowarn "No notes found. Create one with :NotesNew"
    return
  endif

  # Use Vim's built-in inputlist() for a simple selection menu
  var choice_nr = inputlist(['Please choose a note to edit:'] + notes)

  if choice_nr > 0 && choice_nr <= len(notes)
    var note_name = notes[choice_nr - 1]
    var filepath = $"{NOTES_DIR}/{note_name}.md"
    execute 'edit' filepath
  endif
enddef
```

#### Breakdown of the Logic Module

- **`vim9script` and `export const`**: We declare a Vim9 file and export a constant for our notes directory. Exporting it allows our UI file to know where the notes are stored if needed.
- **Private Functions (`EnsureNotesDir`, `SanitizeTitle`)**: These helpers are not exported. They are implementation details. This is good encapsulation.
- **Error Handling (`CreateNote`)**: The `try...catch` block is a perfect example of robust scripting. We specifically catch the "File exists" error (`E739`) to provide a helpful message, and then have a general `catch` for any other unexpected I/O errors.
- **Lambda and `map()` (`GetNoteList`)**: Instead of a manual `for` loop, we use the functional `map()` method with a concise lambda `(idx, val) => ...` to transform a list of full file paths into a clean list of note titles.
- **User Interaction (`EditNote`)**: We use the built-in `inputlist()` function to create a simple, dependency-free selection menu. This demonstrates how to interact with the user from the core logic.

### Step 3: Creating the User Interface (The Commands)

Now that our engine is built, we just need to hook it up to some commands. This file is much simpler, as it only needs to delegate to the module.

Create the file `~/.vim/plugin/notes_ui.vim`.

**File: `~/.vim/plugin/notes_ui.vim`**

```vim
# ~/.vim/plugin/notes_ui.vim
# Defines user commands by importing from the notes.vim module

vim9script

# Import the functions we need from our autoloaded module.
# The .vim extension is optional.
import CreateNote, EditNote, GetNoteList from "notes"

# Create the user commands.

# -nargs=1 requires the user to provide exactly one argument.
# <q-args> passes that argument as a string to our function.
command! -nargs=1 NotesNew CreateNote(<q-args>)

# -nargs=0 means the command takes no arguments.
command! -nargs=0 NotesEdit EditNote()

command! -nargs=0 NotesList echo join(GetNoteList(), "\n")
```

#### Breakdown of the UI File

- **`import`**: This is the magic. Vim9's module system cleanly imports the `export`ed functions from our `autoload/notes.vim` file, making them available as if they were defined locally.
- **`command!`**: We define three simple commands. Each one is a one-liner that calls the corresponding imported function. This separation makes the code incredibly clean. The logic is in one place, and the UI definition is in another.

### Using Your New Plugin

That's it! Restart Vim or source the files (`:source ~/.vim/plugin/notes_ui.vim`), and you can now use your new commands:

- `:NotesNew My First Note` -> Creates and opens `~/vim-notes/my-first-note.md`.
- `:NotesNew Another Great Idea` -> Creates and opens `~/vim-notes/another-great-idea.md`.
- `:NotesEdit` -> Shows a menu:

    ```
    Please choose a note to edit:
    1: my-first-note
    2: another-great-idea
    ```

- `:NotesList` -> Prints the list of notes to the command line.

### Final Thoughts and Next Steps

This walkthrough demonstrates how the features of Vim9script come together to create a well-structured, readable, and robust plugin. We used modules for organization, `try...catch` for resilience, lambdas for concise data processing, and modern syntax for clarity.

This mini-plugin is just a starting point. You can now use your Vim9script knowledge to expand it:

- Create a `:NotesDelete` command.
- Integrate with a fuzzy finder like `fzf.vim` for a more powerful `NotesEdit` experience.
- Add a `:NotesSearch` command that uses `grep` to search through all notes.

You have successfully built a real tool. This practical application is the true power of Vim9script—enabling you to extend and mold your editor to perfectly fit your workflow, faster and more effectively than ever before.

Of course. This final article in the series focuses on the professional aspects of plugin development: ensuring your code is fast, correct, and maintainable.

---

## Polishing Your Vim9script: Profiling, Testing, and Best Practices

Across this series, we've journeyed from the fundamentals of Vim9script to building a functional notes-management plugin. You now have the skills to write code that extends Vim in powerful ways. But writing a script that *works* is only the first step. Creating a plugin that is *high-quality*—fast, reliable, and easy to maintain—requires another set of tools and disciplines.

In this final installment, we'll cover the three pillars of professional Vimscript development: profiling to ensure speed, testing to guarantee correctness, and best practices to maintain code quality for the long haul.

### 1. Profiling: Finding and Fixing Bottlenecks

A primary motivation for Vim9script was performance. But even with a compiled language, inefficient algorithms or slow operations (like frequent shell calls) can bog down your editor. Vim's built-in profiler is your essential tool for hunting down these performance bottlenecks.

The `:profile` command measures the execution time of every line and function in your script.

#### How to Profile Your Code

The process is straightforward:

1. **Start profiling:** Tell Vim what to watch.
2. **Execute the code:** Run the command or function you want to measure.
3. **Stop profiling (optional):** The profile automatically stops when the script finishes.
4. **Analyze the results:** Dump the collected data to a file for inspection.

**Example: Profiling a Slow Function**

Let's imagine our notes plugin has a function to count the total number of words across all notes. A naive implementation might use an external `wc` command for each file.

```vim
# In your notes.vim module
export def CountTotalWordsSlowly(): number
  var total = 0
  var notes = globpath(NOTES_DIR, '*.md', 1, 1)
  for note_path in notes
    # system() is expensive! It starts a new shell process.
    var word_count_str = system($"wc -w < {note_path}")
    total += str2nr(word_count_str)
  endfor
  return total
enddef
```

Now, let's profile it. In Vim's command line:

```vim
" 1. Start profiling and target our autoload file.
:profile start /tmp/profile.log
:profile file ~/.vim/autoload/notes.vim

" 2. Execute the function.
:call notes#CountTotalWordsSlowly()

" 3. The profile is automatically written to /tmp/profile.log.
"    Now, open the log file to see the results.
:edit /tmp/profile.log
```

The `profile.log` will contain detailed timing information. You'll see something like this:

```
FUNCTION  notes#CountTotalWordsSlowly()
Called 1 time
Total time:   0.054321
 Self time:   0.001234

count  total (s)   self (s)
    1              0.000010   def CountTotalWordsSlowly(): number
    1   0.000005   0.000005     var total = 0
    ...
   10   0.052876   0.000123     for note_path in notes
   10   0.052753   0.052753       var word_count_str = system($"wc -w < {note_path}")
   10   0.000100   0.000100       total += str2nr(word_count_str)
    1   0.000021   0.000021     return total
```

**How to Read the Output:**

- **TOTAL time:** The total time spent inside a function, including time spent in other functions it called.
- **SELF time:** The time spent on a specific line or in the function *itself*, excluding calls to other functions.

In our example, the line with `system()` has a massive **SELF time**. This is our bottleneck!

**A Better Implementation:**

Let's rewrite the function using pure Vimscript, which is much faster than spawning shell processes in a loop.

```vim
export def CountTotalWordsFast(): number
  var total = 0
  var notes = globpath(NOTES_DIR, '*.md', 1, 1)
  for note_path in notes
    var content = readfile(note_path)->join(' ')
    total += len(split(content))
  endfor
  return total
enddef
```

Profiling this new version would show drastically lower execution times. Always profile your code when you suspect slowness; the results often surprise you.

### 2. Testing: Ensuring Reliability with vim-themis

How can you be sure that a change you made didn't break something else? The answer is **automated testing**. A test suite acts as a safety net, allowing you to refactor and add features with confidence.

The most popular testing framework for Vimscript is [vim-themis](https://github.com/thinca/vim-themis).

#### Setting Up a Test

Let's write a test for the `SanitizeTitle` function from our notes plugin.

1. **Install vim-themis** using your favorite plugin manager.
2. **Create a test directory structure:**

    ```
    ~/.vim/
    ├── autoload/
    │   └── notes.vim
    └── test/
        └── notes_spec.vim
    ```

3. **Write the test file:**

**File: `~/.vim/test/notes_spec.vim`**

```vim
vim9script

# Import the themis framework and our code to be tested.
import * as themis from "themis"
import SanitizeTitle from "notes"

# 'describe' groups related tests.
themis.describe("notes.vim SanitizeTitle", () => {
  # 'it' defines a single test case.
  it("should sanitize spaces and special characters", () => {
    var input = "My First Note! (2023)"
    var expected = "my-first-note-2023"
    # 'assert.equals' checks if two values are the same.
    themis.assert.equals(SanitizeTitle(input), expected)
  })

  it("should handle leading/trailing spaces", () => {
    var input = "  another note  "
    var expected = "another-note"
    themis.assert.equals(SanitizeTitle(input), expected)
  })

  it("should return an empty string for only invalid characters", () => {
    var input = "!@#$%^&*"
    var expected = ""
    themis.assert.equals(SanitizeTitle(input), expected)
  })
})
```

4. **Run the tests:**
    Open Vim and run the command `:Themis`.

You'll get a clean output report:

```
notes.vim SanitizeTitle
  ✓ should sanitize spaces and special characters
  ✓ should handle leading/trailing spaces
  ✓ should return an empty string for only invalid characters

3 examples, 0 failures
```

By building a suite of these tests, you can verify your plugin's correctness automatically every time you make a change. For functions with side effects (like creating files), use `themis.before` and `themis.after` blocks to set up and tear down a temporary environment.

### 3. Best Practices and Linting

Finally, writing good code is about adhering to conventions that make it readable and maintainable for yourself and others.

#### Linting Your Code

A "linter" is a tool that automatically analyzes your code for stylistic errors and potential bugs. For Vimscript, the standard linter is [vint](https://github.com/Kuniwak/vint).

After installing it (e.g., via `pip install vim-vint`), you can run it from your terminal:

```bash
vint ~/.vim/autoload/notes.vim
```

Vint will point out issues like unused variables, inconsistent styling, or bad practices, helping you keep your code clean and professional.

#### A Checklist of Vim9script Best Practices

- **Separate Logic and UI:** Keep core logic in `autoload` modules and user-facing commands/mappings in `plugin` files. This was the core principle of our notes plugin.
- **Embrace Types:** Use type annotations (`name: string`, `scores: list<number>`) whenever possible. It prevents bugs and makes your code self-documenting. Use `any` as a last resort.
- **Prefer `const` for Immutability:** If a variable's value should never change (like our `NOTES_DIR`), declare it with `const`.
- **Use `import` Over Legacy Autoloads:** The `import` system is cleaner, safer, and more performant.
- **Document Your Public API:** Add comments to your `export`ed functions explaining what they do, their parameters, and what they return. Your future self will thank you.
- **Handle Errors Gracefully:** Use `try...catch` for any operation that might fail, especially file I/O or user input parsing. Never let your plugin crash Vim.
- **Write Pure Functions When Possible:** Functions like `SanitizeTitle` that don't have side effects are easy to reason about and test. Isolate complex logic into pure functions whenever you can.

### The End of the Beginning

This series has taken you from a beginner to a capable Vim9script developer, equipped not only to write code but to engineer high-quality plugins. You've learned the syntax, mastered the features, and now understand the disciplines of profiling, testing, and adhering to best practices.

The world of Vim customization is now truly at your fingertips. Go forth and build amazing tools, streamline your workflows, and perhaps even share your creations with the community. The journey of a Vim master is one of continuous learning and refinement, and you now have a solid foundation for the path ahead. Happy Vimming
