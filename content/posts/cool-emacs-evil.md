+++
title = "Cool Emacs Things: Evil"
author = ["Ryan Faulhaber"]
date = 2021-09-19T11:53:00-04:00
tags = ["emacs"]
draft = false
series = ["Cool Emacs Things"]
+++

Evil mode makes Emacs more Vim than Vim.

<!--more-->

I like Vim a lot. I've been a Vim user for almost my entire professional career at this point. I learned Vim because the idea of editing text without touching the mouse appealed to me (also because I was tired of not knowing how to use Vim in environments without graphical editors. Pro tip, if you're in this situation and don't want to learn Vim: use [Nano](https://www.nano-editor.org/)). Now I can't edit text without it. For a while I used Vim proper, and then I used other editors with their Vim emulators.

Once I learned Vim, Vim proper was my editor for a while. I learned all about plugins and [had a small configuration file](https://github.com/rfaulhaber/dotfiles/blob/f895c6c8536a149bd536cfba942e811000bcd47d/config/nvim/init.vim) (now a [Nix configuration](https://github.com/rfaulhaber/dotfiles/blob/master/nix/modules/programs/neovim/default.nix)). After a while though I found Vim itself cumbersome, and realized every other editor had a Vim plugin. So for a while I used IdeaVim, Atom's Vim plugin, and then finally VSCode's Vim plugin.

In my own experience, I've noticed that even Vim users underestimate Vim. Many Vim users I've known only learn the motions and stop there. Vim has some powerful functionality that a good number of people aren't aware of or don't use. Many Vim users seem satisfied to know the motions and leave it at that. And that's fine! I was that way for a very long time. But sometimes, I found myself wanting more advanced functionality that plugins couldn't offer.

Finally, I started using Emacs through Spacemacs, and then changed to Doom Emacs. Each configuration comes with Vim emulation through a package called Evil, the very cleverly named Extensible VI Layer for Emacs.

As a baseline, Evil does, at the very least, everything every other Vim plugin does. If you're familiar with Vim keybindings, motions, macros, marks, and the like, Evil supports those. But I wouldn't be writing about Evil if that was all it did! In fact I think it's safe to say that Evil is the most complete Vim emulator out there outside of Vim itself.

To me, one of the most noteworthy differences from other Vim emulators is that Evil has extensive Ex support. Ex commands are not very well supported in the other Vim plugins I've tried. Evil supports many of the basic Ex commands, such as `:r`, `:w`, `:!`, and so on, but also `:normal`, `:global`, and ranges. Evil doesn't implement every Ex command, though, since a good deal of Ex commands would be redundant in Emacs, such as ones like `:set`. It's also easy to define your own Ex commands. Evil provides `evil-ex-define-cmd`, allowing you to implement your own Ex commands. Doom [provides some useful extras](https://github.com/hlissner/doom-emacs/blob/develop/modules/editor/evil/%2Bcommands.el) on top of Evil.

But the biggest difference between Evil and other Vim emulators is that Evil is an Emacs extension. When you configure Evil, you write Emacs Lisp, the same as any other configuration for Emacs. So Evil does not provide commands like `:nnoremap`. This is not so with, for example, IdeaVim or VSCode's Vim plugins. That said, you could think of Emacs Lisp as a stand in for Vimscript[^fn:1]. This means that any Evil customization will use all Emacs's ability for customization and text-editing. The things Evil does not implement, as far as I can tell, would be redundant in Emacs.

This, to me, is the biggest advantage of Evil: it's as extensible as Emacs itself is. While Evil may not offer complete feature parity with Vim (I can't imagine having or even wanting a Vimscript interpreter, for example), it contains all the important parts, and a lot more than any other emulator I've used.

Were it not for Evil, I would not have continued using Emacs. For me, it's a crucial package.

[^fn:1]: One might argue that each is equally esoteric! I prefer Emacs Lisp, if only because it's a Lisp, and there are other Lisps out there. I have always found Vimscript difficult.
