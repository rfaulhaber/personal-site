+++
title = "Cool Emacs Things: Dired"
author = ["Ryan Faulhaber"]
tags = ["emacs"]
draft = false
series = ["Cool Emacs Things"]
date = 2021-05-28T03:25:00-04:00
+++

Today we continue [my ongoing series on Emacs](https://ryanfaulhaber.com/series/cool-emacs-things/) with a feature of Emacs that feels genuinely magical: Dired.

One of the first things I did when I became a Linux user was to learn how to use the terminal. The terminal is an indispensable tool in the Unix world broadly because of its versatility. I got to a point where I used the terminal so heavily that eventually on Linux I stopped installing file explorers, and on macOS I had entire directories that never had those annoying `.DS_Store` files. Personally, managing files in the terminal is often much simpler and more direct than a graphical file explorer.

Navigating your file system without a graphical file explorer requires you to know two standard Unix programs: `cd` (change directory) and `ls` (list directory contents). `ls` in particular can print out very detailed information about the files in your system:

{{< highlight bash "linenos=false">}}
# navigate to a project directory
cd ~/Projects/dial
# print contents
ls -lh
{{< /highlight >}}

| total      | 32K |      |       |      |     |   |       |            |
|------------|-----|------|-------|------|-----|---|-------|------------|
| drwxr-xr-x | 3   | ryan | users | 4.0K | May | 1 | 15:48 | bin        |
| -rw-r--r-- | 1   | ryan | users | 7.2K | May | 2 | 12:39 | Cargo.lock |
| -rw-r--r-- | 1   | ryan | users | 78   | May | 1 | 15:53 | Cargo.toml |
| drwxr-xr-x | 3   | ryan | users | 4.0K | May | 1 | 15:49 | dial-core  |
| drwxr-xr-x | 3   | ryan | users | 4.0K | May | 1 | 15:53 | parse      |
| -rw-r--r-- | 1   | ryan | users | 186  | May | 1 | 15:36 | README.org |
| drwxr-xr-x | 3   | ryan | users | 4.0K | May | 1 | 15:49 | target     |

From left-to-right, these columns represent: file permissions (modifiable by `chmod`), links to this file, file owner (modifiable by `chown`), group owner (modifiable by `chgrp`), file size, last modified timestamp, and file name.

Dired defies explanation for those who haven't used it, and while writing this I struggled with how to explain it exactly. I'm tempted to describe it as "interactive `ls`".

Imagine if, when you typed `ls` and got a list of files, you could click on those names. If the name is a directory, your terminal would automatically `cd` to that directory and invoke `ls` again. If that name is a file, your terminal opens that file in your favorite text editor. If your favorite text editor is Emacs, I have good news for you: this is what Dired is.

<a id="org91c9f1f"></a>

{{< figure src="/ox-hugo/Screenshot from 2021-05-25 13-55-14.png" caption="Dired mode. Mine looks a little weird because I have `exa` aliased to `ls`." >}}

But Dired does a little more than just navigation: Dired is a file explorer in its own right. From Dired you can move, copy, rename, and delete files, make links, [run rsync](https://github.com/stsquad/dired-rsync) (with an extra package), `diff` files, and more.

But that's not all! Dired has a sibling called [wdired-mode](https://www.gnu.org/software/emacs/manual/html%5Fnode/emacs/Wdired.html), or "writable Dired." wdired lets you edit a Dired buffer, thereby allowing you to rename files with all the editing powers of Emacs. So, for example, replacing all of your `.js` to `.ts` files is just a matter of finding and replacing `js` with `ts`. wdired will also let you change file permissions, so you could change `rw-r--r--` to, say, `rw-rw-rw-` by simply changing the text without having to break out `chmod`.

This is why I navigate my file explorer in Emacs rather than my terminal now.
