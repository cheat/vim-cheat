vim-cheat
=========
`vim-cheat` is a natural-language snippet manager for `vim`, built atop
[cheat][] and [fzf][].

While the goal of most snippet managers is to minimize keystrokes, `vim-cheat`
aims to reduce the cognitive load associated with common programming tasks. It
does so by providing a task-focused repository of snippets that can be
queried with natural language.

`vim-cheat` is context-aware, and can be configured to return only snippets
that are relevant to the `filetype` of the current buffer. This makes
"polyglot" work less mentally taxing by reducing the cost of context-switching
among languages.

Use `vim-cheat` in conjunction with [snippets][].


Example
-------
`vim-cheat` works by leveraging `cheat`'s tagging mechanism: `vim-cheat` uses
`fzf.vim` to filter and retrieve cheatsheets by tag.

As a concrete example, imagine that we're writing a Go application that must
connect to MySQL. Which method does this?

Is it `mysql_connect`? Err, no - that's PHP. I think it's `mysql.createConnection`?
Wait, no - that's Node. Is it `mysql.connector.connect`? Ah, no - that's
Python.

`vim-cheat` frees us from having to remember these details. Run `:Cheat` and
type `connect database` into the prompt, and the appropriate Go snippet will
be pasted into your buffer. (Snippets can be pasted from insert mode as well.)


Installation
------------
`vim-cheat` can be installed as described in `:help packages`, or by using a
package manager like Pathogen, Vundle, or Plug.

`vim-cheat` additionally requires that the following dependencies be
installed:

- `cheat`:   https://github.com/cheat/cheat
- `fzf`:     https://github.com/junegunn/fzf
- `fzf.vim`: https://github.com/junegunn/fzf.vim

You are encouraged cultivate a snippet collection that best serves your
personal needs. With that said, the following repository serves as a starting
point:

https://github.com/cheat/snippets


Functions
---------
#### cheat#read_ft ####
Read a snippet into the current buffer. The `fzf` selection menu will contain
only cheatsheets that are tagged with the buffer's `filetype`.


#### cheat#read_all ####

Read a snippet into the current buffer. The `fzf` selection menu will contain
all cheatsheets available on all cheatpaths.


#### cheat#read_smart ####
Read a snippet into the current buffer. If the buffer's `filetype` is known,
the `fzf` selection menu will contain only cheatsheets that are tagged with
the buffer's `filetype`. Otherwise, the selection menu will contain all
cheatsheets available on all cheatpaths.


#### cheat#edit_ft ####
Open an existing cheatsheet for editing. The `fzf` selection menu will contain
only cheatsheets that are tagged with the buffer's `filetype`. (Note that it
is not currently possible to create a new cheatsheet using this function.)


#### cheat#edit_all ####
Open a cheatsheet for editing. The `fzf` selection menu will contain all
cheatsheets available on all cheatpaths. (Note that it is not currently
possible to create a new cheatsheet using this function.)


#### cheat#edit_smart ####
Open an existing cheatsheet for editing. If the buffer's `filetype` is known,
the `fzf` selection menu will contain only cheatsheets that are tagged with
the buffer's `filetype`. Otherwise, the selection menu will contain all
cheatsheets available on all cheatpaths. (Note that it is not currently
possible to create a new cheatsheet using this function.)


#### cheat#dirs ####
Display the configured cheatsheet directories. (This function simply wraps the
`cheat -d` command.)


#### cheat#tags ####
Display the cheatsheet tags that are in use. (This function simply wraps the
`cheat -T` command.)


#### cheat#version ####
Display the current `cheat` version. (This function simply wraps the `cheat -v`
command.)


Options
-------
#### cheat_bin ####
The path to the `cheat` executable. Defaults to `cheat`.


#### cheat_fzf_options ####
Options that will be passed to `fzf`. Defaults to the following:


```vim
g:cheat_fzf_options = [
      \    '--header-lines',
      \    '1',
      \    '--tiebreak',
      \    'begin',
      \    '--preview-window',
      \    'right:40%',
      \    '--preview',
      \    g:cheat_fzf_preview,
      \]
```


#### cheat_fzf_preview ####
The command `fzf` will use for generating a cheatsheet preview. Defaults to the
following:

```bash
  cheat --colorize `echo {} | cut -f1 -d" "`
```


## Config ##
You should map the functions exposed by this plugin to convenient wrappers in
your `vimrc`. The following is an example configuration:

```vim
" ex-mode commands:
command Cheat call cheat#read_smart()
command CheatDirs call cheat#dirs()
command CheatEdit call cheat#edit_smart()
command CheatVersion call cheat#version()

" insert-mode: press Ctrl+s to open snippet selection menu:
inoremap <c-s> <c-o>:call cheat#read_smart()<CR>
```

Because `vim-cheat` wraps the `cheat` executable, you must configure your
`cheatpaths` as well. Example:

```yaml
cheatpaths:
  - name: snippet-community
    path: ~/path/to/community/snippets
    tags: [ snippet ]
    readonly: true

  - name: snippet-personal
    path: ~/path/to/personal/snippets
    tags: [ snippet, personal ]
    readonly: false
```

See the `cheat` project documentation for more information on configuring
`cheatpaths`:

https://github.com/cheat/cheat/#cheatpaths

See Also
--------
`vim-cheat` pairs nicely with [vim-so][].

[cheat]:    https://github.com/cheat/cheat
[fzf.vim]:  https://github.com/junegunn/fzf.vim
[fzf]:      https://github.com/junegunn/fzf
[snippets]: https://github.com/cheat/snippets
[vim-so]:   https://github.com/cheat/vim-so
