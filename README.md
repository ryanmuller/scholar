A command line tool suite for reading text and writing about what you read.

## Features and usage

* Start by running scholar.rb with a directory of text files ("articles"):

```
ruby scholar.rb path/to/files
```
(See http://github.com/ryanmuller/wwwtxt for acquiring text files. More to come.)

* This opens the library view. Three random articles are listed. Choose one by pressing `1`, `2`, or `3`, then enter. (TODO: better article navigation)
* Press `n`/`p` to navigate the article. Your place in the article is remembered. (TODO: Persist between session, better article display.)
* Type `c [category name]` to set the category. The category defines which notebook is used. (TODO: Also use category to suggest articles.)
* Type `w [your note]` to write a note in the current notebook.
* Press `v` to view the current notebook. You can use the same navigation as with an article.
* Press `s` to save the current displayed text as a quote in the current notebook. (TODO: I don't think this is working.)
* Press `l` to return to the library.
* Press `q` to quit Scholar.

other features TODO:

* Read commands without needing `<CR>`.
* Open notebook in external editor.
* Map notes to places in articles.
