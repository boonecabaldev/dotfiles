# Vim9script Tutorial

### Introduction

## Prequisites

- XXX

### Difference Between `vimscript` and `vim9script`

- `vim9script` is a major upgrade for 

| Feature           | Legacy Vimscript (VimL)                     | Vim9script                                  |
| :---------------- | :------------------------------------------ | :------------------------------------------ |
| **Performance** | Interpreted, slower (1x)                    | Compiled, much faster (10-100x)             |
| **Syntax** | Looser, more Vim-specific quirks            | Stricter, more like modern languages        |
| **Comments** | `"`                                         | `#`                                         |
| **Variables** | `let myvar = value`, dynamic typing         | `var myVar: type = value`, static typing    |
| **Functions** | `function! MyFunc()`, `a:`, `l:` dicts      | `def MyFunc(arg: type): type`, no `a:`, `l:` |
| **Call Functions**| `call MyFunc()`                             | `MyFunc()`                                  |
| **String Ops** | `str1 . str2` (concatenation)               | `str1 .. str2`, `$"interpolation {var}"`    |
| **Line Cont.** | `\` often required                          | Generally not needed                        |
| **Scope Default** | Global (`g:`)                               | Script-local                                |
| **Modules** | No formal module system                     | `import`/`export` system                    |
| **Error Handling**| Simpler mechanisms                          | `try`/`catch`/`finally` blocks              |