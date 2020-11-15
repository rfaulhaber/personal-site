+++
title = "Critique of the Magic of Modern IDEs"
author = ["Ryan Faulhaber"]
date = 2020-11-15T13:19:00-05:00
tags = ["tooling", "meta"]
draft = false
+++

The StackOverflow blog recently posted [this article](https://stackoverflow.blog/2020/11/09/modern-ide-vs-vim-emacs/?cb=1) asking why so many people continue to use Vim and Emacs when modern editors like Atom exist. This is a question I have [personally addressed before](https://ryanfaulhaber.com/posts/try-emacs) with regards to Emacs, but I want to address this post specifically because I think it gets at a commonly held misunderstanding about these editors.

The basic point of the post explores why people would want to use an antiquated editor like Vim or Emacs, and that those who continue to use either are missing out on the so-called magic of a newer IDE.

I think that this post doesn't understand why someone would want to use Vim or Emacs in the first place, and is happy to throw them into the dustbin of history simply because they're old. In fact Vim and Emacs still have a lot to offer, and each are able to offer things that newer editors simply aren't interested in providing.


## What is an IDE? {#what-is-an-ide}

As anyone will tell you, an IDE is an integrated development environment. This is a catchall term for a special kind of text editor that provides special functionality for writing code. What separates Notepad on Windows from, say, IntelliJ IDEA is that the latter has features that enable you to compile and run programs, code completion, version control integration, and a whole host of other things.

Increasingly the line between IDE and text editor is blurring, however. Something like VS Code or Atom can be considered either depending on who you ask. Typically, I would consider Atom a text editor while I'd consider IntelliJ IDEA an IDE, because the latter is specifically suited for providing a Java development environment (and about a dozen other languages as well): it comes with Java-specific code completion, compiling and running commands, and so forth, while Atom inherently does not, though it _can_ be made to do so. Visual Studio can do the same for C#. Vim, Atom, VS Code, and Emacs inherently do not.


## The So-Called Magic of IDEs {#the-so-called-magic-of-ides}

In my first software class in college we wrote Java using Eclipse. The course mandated that you use Eclipse to compile your code, and the first class involved setting up our environment in such a way that we wouldn't have to worry about configuring our IDE for the rest of the course. This was the first time I wrote Java and for a long time didn't know that you could run Java code any other way.

I was in for a shock when I took my first C class a semester later. The professor forbade us from using an IDE, instead we had to use `gcc` with the `-ansi` flag. Per the requirements of the course I wrote all my code in gedit and compiled it manually in the terminal. Compiling code in this manner was frustrating: I didn't notice issues with my code until I ran `gcc`, and I wouldn't know if I had resolved my issue until I reran the command. Doing this with an IDE wouldn't be so frustrating, I thought!

This experience taught me three things, and it's a lesson I feel everyone who writes code sooner or later learns:

1.  You don't need an IDE to compile and run code. It seems obvious in retrospect but learning how to code in this way presents how code works in a mystified way.
2.  Your tools are only as good as you utilize them. While gedit didn't provide me with much useful feedback on my C code as I wrote it, `gcc` sure did. Learning to listen to the warnings saved me a bit of grief as I went through the course. Learning other tools like `make` also made my life easier at the time. This holds true for any editor as well: IntelliJ provides an astronomical amount of features, but if all I do is use this huge editor to just compile and run Java, what difference does it make if I wrote my code in gedit and compile my code from the command line?
3.  Usually you don't need a specific editor to write code. Code written in Vim is the same as code written in Visual Studio, but these are tools meant to assist _you_. Code running on a server somewhere doesn't care whether or not it was written in Emacs or Sublime.

All of this is to say that an IDE is a tool of mystification: it deliberately makes writing code easier, and does so by automating the more tedious aspects of the process. As a software developer I feel that it's important to know how to do these things yourself, as doing so will result in a deeper understanding of the code you write.


## The Cold Vim/Emacs War {#the-cold-vim-emacs-war}

I want to address the so-called war between Vim and Emacs, and I want to start by asking: what war is there?

If you had never heard of Vim or Emacs before this article you would think that there are deeply embedded communities who spend all day in flame wars over which editor they prefer, and their refusal to move on was holding back the whole of software engineering.

But where is this? The article points to a Medium article that talks about how a developer turned Atom into Vim, and says that this attitude is retrograde: the author is so entrenched in the past that they used Atom's customizability to turn it into something that more closely resembles Vim.

I have been using Vim for four years and Emacs for almost one (and in fact I use [Vim keybindings within Emacs](https://github.com/emacs-evil/evil)!), and I've never seen any serious hostility between Vim and Emacs users. The original antagonism between the two editors came from Richard Stallman's objection to Vi being closed source. This is no longer relevant, however, as both Vim and Emacs are both free and open source software. I think there are people who prefer to use one over the other, in the same way some people would prefer chocolate or vanilla ice cream, but I think any serious animosity between Vim and Emacs users dried up decades ago.


## Why use Vim or Emacs? {#why-use-vim-or-emacs}

It's at this point I wonder if either of the authors of this piece have ever used Vim or Emacs! They certainly don't understand what the appeal of either would be, or why you'd want to import features from Vim into Atom, and if there's a desire to import features from Vim or Emacs into a modern editor like Atom, then modern editors clearly lack something.

To sum up what each editor offers, Vim offers ergonomics and Emacs offers customizability, and each of these are things you truly cannot appreciate until you have used either.

Vim's keybindings are meant to maximize keyboard use and cut down on repetitive editing actions. If you want to change what's between a set of parentheses, Vim lets you do this by typing `ci(`. Rather than reach for the mouse and highlight the contents, Vim saves you from having to move your hands. It takes some getting used to but is well worth the effort to learn.

Emacs offers something more subtle and profound, I think: an editor that can do exactly what you want it to do, and as a software developer, this is an invaluable feature to me. As "hackable" as Atom is, Emacs takes it to a greater extreme, allowing you to change even the most fundamental behavior of your editor. Frequently I write small functions in Emacs Lisp to tweak the behavior of the editor. I'm an avid [Org mode](https://orgmode.org/) user, and I have a small handful of functions to automate otherwise tedious actions, such as converting numbers to links to tickets in JIRA.

To say that Vim and Emacs themselves or their users somehow hold back modern editors, or that newer developers shouldn't bother with these tools is absurd. I have only been a professional developer for about four years and I've spent three of them using either Vim or Vim plugins. I feel that I'm a much more productive developer now that I know Vim, and using Vim and Emacs in turn has taught me new ways to utilize the tools I use on a day-to-day basis. This isn't to say you should avoid more modern editors, but to assert that either is completely worthless misses why people would continue to use either in the first place.
