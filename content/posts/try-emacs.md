+++
title = "You Should Try Emacs"
author = ["Ryan Faulhaber"]
date = 2020-07-13T16:00:00-04:00
draft = false
+++

No, really, you should try Emacs. I gave it a shot a few months ago and now I'm hooked.

I know Emacs isn't the most trendy thing these days, in fact it seems that VS Code is the new hotness. But Emacs deserves your attention.

Let me start by telling you how I arrived at Emacs: some time ago I used IntelliJ for work, almost exclusively. IntelliJ is great, honestly. You can do _a lot_ without having to leave the editor, which I came to realize was something I wanted from an editor.

Some time later I switched to VS Code, and I switched for a lot of little reasons: there were a lot of plugins, the editor looked nice, the editor was more lightweight than IntelliJ, some languages I used were better supported. VS Code is also great.

Then I learned Vim, and that's where I think the real journey to Emacs began. At first I just learned Vim keybindings (press `i` to enter "insert mode", press `viw` to highlight a word, etc.), and fortunately the Vim plugins for VS Code and IntelliJ supported most of what I needed to do. But whenever I'd use Vim proper in the terminal, I always realized it could do _a lot_ more, and the thing I started to realize was that I wanted all those features. The Vim plugins for VS Code and IntelliJ are, for all intents and purposes though, black boxes. Sure you could open a PR and implement some feature yourself, but why bother when Vim itself has those features? Or so was my reasoning.

So for some time I switched between three editors to get various tasks done, but I still felt it wasn't enough. I felt all three missed _something_, but I couldn't quite articulate what.

Then I learned about [Acme](https://www.youtube.com/watch?v=dP1xVpMPn8M), the editor from the [Plan 9 operating system](https://9p.io/plan9/about.html), and my mind was blown. Acme wasn't without its own issues, sure, but the idea that the editor itself should require almost no additional work from the user in order to gain extra features was incredible to me. In Acme, you don't need a built-in editor command to sort a bunch of lines. Instead, you can pipe your lines through Unix's `sort` command and pipe the output back into the editor. Acme was as extensible as your own system was.

Unfortunately, using Acme was somewhat unfeasible. I really needed syntax highlighting and Vim keybindings (once you learn them they're very difficult to forget, and you tend to want to use them everywhere!), and that was a showstopper for me.

Enter Emacs. Someone I know who was a Vim user made the switch to Emacs and was telling me how incredible it was, and at first I was skeptical. I thought Emacs was some old dusty program from the 70s that was as arcane as something like Prolog. Plus I had tried the tutorial years ago, and I thought the keybindings were weird. I was assured, though, that Emacs had a plugin called [Evil](https://github.com/emacs-evil/evil) that could emulate Vim keybindings, and maybe even better than VS Code or IntelliJ (spoiler alert, it does). "Very well," I thought, "It wouldn't hurt to try." I was not prepared for what Emacs had to offer.

Four months in and Emacs is now the _only_ editor I use. I will say though, in the beginning, Emacs was extremely daunting. It was maybe the second hardest editor to learn after Vim (Vim took me a good month before I was productive with it). What is most daunting about Emacs though is why it's taken over my life: it's infinitely extensible.

You may be skeptical. You might think "Well VS Code is extensible!" Indeed, it is. But Emacs is extensible to a degree that's easy to underestimate. For all intents and purposes, Emacs is a [Lisp machine](https://en.wikipedia.org/wiki/Lisp%5Fmachine). Emacs, much like your browser, provides an entire platform upon which functionality can be built. In your browser's case, that functionality is written in JavaScript. In Emacs, it's Lisp (specifically Emacs Lisp). Moving the cursor in any direction, for example, is a binding between a key press and a Lisp function.

I'd argue that extensibility and customizability are crucial for productivity. Everyone is different and as such I imagine we all use our computers a bit differently. Emacs is extremely accommodating to whatever your workflow is, provided you're willing to put in a bit of effort to customize Emacs.

In some ways, Emacs is the equal but opposite of Acme. Emacs provides _a lot_ of tools. But unlike an editor like VS Code, editing Emacs is as easy as opening a new buffer (a collection of text that may or may not correspond to a file), writing some Emacs Lisp, evaluating it on the fly, and with just a few lines of Lisp you have a new plugin.

I've emphasized Emacs's extensibility thus far, and I think that should be its main selling point. Emacs is so extensible that there are pre-configurations of Emacs to [make it look something like VS Code](https://github.com/hlissner/doom-emacs) (Doom Emacs is wonderful. It's what I use and what got me into Emacs). It's so extensible that it can be used [as an email client](https://www.djcbsoftware.nl/code/mu/mu4e.html) and [Twitter browser](https://github.com/hayamiz/twittering-mode). And what's incredible about all these extensions is that Emacs will carry all your configuration and keybindings around to all these different contexts. If you're a Vim user, being able to do things like check your email or use [Emacs's Git client](https://magit.vc/) with Vim keybindings is wonderful.

(Side note: I never actually used a Git client before using Emacs. Magit is maybe the only one I could ever see myself using.)

And lest I forget, Emacs also has something called [Org mode](https://orgmode.org/). For a more comprehensive introduction, I recommend [this video](https://youtu.be/SzA2YODtgK4). Org mode on its surface can be thought of a more feature-complete Markdown: it's a plaintext syntax that is designed with the intention of rendering as something else, including but not limited to HTML. However Org mode in its own right is very powerful because it's backed up by Emacs. Org mode documents can be used as interactive todo lists and agendas. Like Markdown, Org mode supports source code blocks. Unlike Markdown (at least inherently), Emacs can actually evaluate Org source code blocks for some supported languages. You can use this to write documentation to, for example, illustrate what some block of code prints to the console. Or, since Org mode can evaluate Emacs Lisp, you could [write your entire Emacs confugration as an Org document](https://github.com/hrs/dotfiles/blob/main/emacs/dot-emacs.d/configuration.org).

So, if you're in the business of text editing, and you're used to having to fine-tune configuration to get the exact outcome you want, I strongly suggest at least giving Emacs a try. I feel like Emacs is an often forgotten about editor, and I think it deserves a shot.
