+++
title = "Cool Emacs Things: Magit"
author = ["Ryan Faulhaber"]
date = 2020-11-21T15:46:00-05:00
tags = ["emacs"]
draft = false
series = ["Cool Emacs Things"]
+++

This is part of an [ongoing series](https://ryanfaulhaber.com/series/cool-emacs-things) where I talk about the little things that make Emacs a nice editor. Today's entry: [Magit](https://magit.vc/), a Git interface for Emacs.

I'm not much of a Git client person myself. I don't use or particularly like Sourcetree or GitKraken. VS Code and JetBrains IDEs have some nice features, especially when it comes to merging and rebasing, but they're still not quite like Magit.

Until I used Magit I interacted with Git through the command line, because Git in the command line supported all of Git's features. I didn't have to worry about whether GitKraken supported viewing the reflog or file history, I could run `git reflog` and `git log file` and not have to worry about it.

Magit on its surface isn't all that different from the VS Code Git integration: you can pull and push code, see diffs, read the Git log, and so on. But what makes Magit special is that its integration with Emacs makes it very ergonomic to use.

I'll illustrate with an example of committing some changes. After making some changes, I'll go to the Magit buffer and see this:

{{< figure src="/ox-hugo/Screenshot from 2020-11-21 11-13-34.png" >}}

This is roughly the same as running `git status`: I see a list of files I've modified and whether they're staged. If I move my cursor down and hit Enter on the file name, it'll take me to the file in question.

If I hover over the filename and type `d` I'm presented with some choices regarding seeing the differences. After hitting `d` again I'm presented with a window that shows the diffs:

{{< figure src="/ox-hugo/Screenshot from 2020-11-21 11-18-48.png" >}}

I can stage individual files by typing `s` over the filenames, or staging groups of files by highlighting several and hitting `s`.

Finally, if I want to make a commit, I type `c` from the Magit buffer and presented with a number of useful options, not unfamiliar to us Git command-line users:

{{< figure src="/ox-hugo/Screenshot from 2020-11-21 11-21-19.png" >}}

Each one of these arguments are actual Git arguments that will be applied to your Git commit.

Finally, the commit window.

{{< figure src="/ox-hugo/Screenshot from 2020-11-21 11-22-39.png" >}}

Magit provides a normal text buffer for writing a commit message (with all of the conveniences of Emacs of course). The first line is only supposed to be 50 characters long so Magit will mark any extra text in red. Below is the diff for the commit you're making.

Once I'm ready to commit, I type `C-c C-c`.

Magit supports not only what appears to be most Git functionality, but you can modify this behavior using actual options that Git gives you. In terms of the interface, Magit makes it very easy to understand what Git commands it'll be running, and in turn passes along greater control to you. If, for example, I wanted to force push this code for some reason, I'd run `M-x magit-push` (or simply `p` from a Magit buffer), I'll see this:

{{< figure src="/ox-hugo/Screenshot from 2020-11-21 11-04-45.png" >}}

This looks similar to the commit window we saw earlier.

After typing `-f` I've turned on the `--force` flag, and Magit will run `git push --force` instead.

I like Magit because, unlike Sourcetree or even the terminal you don't have to leave the editor to do Git things, and unlike VS Code or IntelliJ, I can perform all these Git actions without ever having to touch the mouse.

[Magit can do a lot more than this](https://emacsair.me/2017/09/01/magit-walk-through/), of course, but even if this was all it could do it would probably still be my favorite Git client. To me it's yet another reason to use Emacs.
