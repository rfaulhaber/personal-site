+++
title = "Quest for a Better Scripting Language"
author = ["Ryan Faulhaber"]
date = 2021-04-27T17:19:00-04:00
tags = ["languages", "shell"]
draft = false
+++

I've been a Linux user for quite a few years now, and writing shell scripts is a pretty common thing for me. I have written many little scripts to do repetitive tasks in various languages. In this post I want to think out loud about what makes a worthwhile scripting language.

Also please note that these are purely my opinions based on subjective experience, I'm not really interested in making any objective claims in this post. Your mileage may very with any of these languages.


## The Goal {#the-goal}

Before we set out on our tour of languages, I want to make clear what I'm looking for: I'm not looking for the perfect programming language, I'm looking for a language that makes automating tasks easier. Such tasks may include anything like renaming every file in a directory, parsing Git CLI output, automating AWS tasks, and so on. These are things I do on a daily basis that are repetitive and could be automated, and I'm looking for a tool that makes doing these things easiest. These tasks also tend to be _ad hoc_ as well and not something that could be solved by simply using GitKraken or something.

So in my experience, this is the kind of thing where you'd reach for a language like Bash over, say, Java. Although you could write a full-blown tool to solve some problem in Java, more often than not it's a little overkill (I don't fault anyone who does this! To each their own, but I'm looking for something more lightweight).

What I want is something that:

-   Writes to stdout and reads stdin easily
-   Runs commands trivially
-   Is easy to write on the fly, such as in a REPL
-   Is portable and doesn't expect much from its user (i.e. should either use software that one can reasonably expect to be installed on a system or requires minimal installation such as running `brew install` or similar)

With that, let's review the languages I've used.


## Bash {#bash}

Bash is a natural candidate: it comes on every Unix-like system, it's trivial to run commands with, it uses stdin and stdout trivially, and it has a long history behind it, with lots of resources online for how to accomplish tasks. I have written many Bash scripts myself and for many years used it as my shell (I now use Zsh though).

Bash would be much less useful without many of the programs that also come standard on a Unix system though, such as `sed` and `tail`. Programs like these let you write very modular and robust commands, such as:

{{< highlight bash >}}
git tag | tail -n 1 | xargs -I {} jq -n --arg tag {} '{tag: $tag}'
{{< /highlight >}}

These programs don't have to know anything about the other, but through the magic of stdin and stdout, they can communicate with one another.

The biggest downside to Bash though is that it's a weird language, and that its simplicity sometimes makes it obtuse. Bash has functions for example, but they can only return status codes and not values. Bash is also difficult to test: you can't just do a dry-run of your script without changing your environment somehow (sure you could run your script in a Docker container or something, but that's not exactly trivial). I almost consider writing more than about 10 lines of Bash to be a red flag.

To summarize, Bash is good at what it does and almost gets me where I need, but it's idiosyncrasies cause easy mistakes, and surely we can do better.


## Python {#python}

It's hard not to mention Python, one of the most popularly used languages. I've never been paid to write Python but I have written quite a bit of it (and overall I have very mixed feelings about Python as a language). When I was in college, and for a bit of time after, I wrote lots of Python to do tasks around my computer. Python seems to be a modern Perl in that regard.

Python isn't a shell language. You can't just open it up and type `ls` and expect it to do something. But otherwise, coming with all the bells and whistles of a full-blown programming language, it's easy to write. And to its credit, Python is a very expressive language.

For me, Python is what I'd reach for when I want to do something more complicated that would be a pain to do in Bash.


## Ruby {#ruby}

With the decline in popularity of Rails it seems that Ruby isn't as popular as it once was. That said, when it was more popular, I wrote a ton of Ruby scripts to do various tasks.

Ruby to me has always been just "Python but better." Python seems to suffer from years of incoherent design while Ruby does less so. Ruby also just has a lot of interesting language features.

Like Python, Ruby is not a shell language. That said, Ruby is at least as good as Python and comes with a lot of neat little utilities to make writing code easier.

I have a soft spot for Ruby but don't write much of it anymore.


## JavaScript {#javascript}

JavaScript is not a perfect language but despite that fact I will die on a hill defending it. Although I believe that JavaScript is often unfairly maligned and is a better language than most people think, this is one regard where I cannot stand by it.

Writing any JavaScript code that interacts with the file system is a chore at best, though this is perhaps the fault of Node than it is JavaScript in particular. JavaScript is, while not the most verbose language out there, still requires a lot of code to do simple things around the system. I personally find JavaScript unsuitable for such tasks. It's better for writing applications.[^fn:1]


## Emacs Lisp {#emacs-lisp}

This is something of a wild card in this list.

[I use Emacs](https://ryanfaulhaber.com/posts/try-emacs/), and once you really get into the Emacs world, you tend to want to just do everything in Emacs, and Emacs is more than happy to let you do that. You can customize Emacs with Emacs Lisp, a cousin of Common Lisp.

I don't think that Lisps are necessarily hard to write, but they can be hard to read if you're not used to mentally parsing a million parentheses. Emacs Lisp isn't the best Lisp in the world but it does make customizing Emacs pretty easy.

Emacs Lisp is pretty good at interacting with files and running commands.

{{< highlight emacs-lisp >}}
;; emacs lisp has built-in functions that can do similar things,
;; but for the sake of an example...
(let ((output (shell-command-to-string "ls *.org")))
  (length (split-string output "\n")))
{{< /highlight >}}

Emacs also came to mind because Emacs comes with a built-in Emacs Lisp shell, called Eshell. Eshell is like any other shell, except that instead of, say, using the Bash language, it uses Emacs Lisp. Eshell is an okay shell and is good for doing things here and there, but the idea of a Lisp shell is pretty interesting to me. I've never seen any other Lisp shells, however.

Although personally I feel that Emacs Lisp is an acceptable solution for personal use, it does depend on Emacs. Emacs runs on all my systems so for my own personal use it's also acceptable in that regard. You may be out of luck though if your coworker, who does not use Emacs, needs a solution to a problem you've already solved with Emacs Lisp.


## Conclusions {#conclusions}

By writing this post I feel like I've hit a limit with the tools that I have. I feel like in the above languages I've only found partial solutions. The problem with existing shells is that the languages tend to be obtuse and fall apart for more complicated tasks, and the programming languages have the inverse problem. I feel that there must be a solution out there that resolves this apparent contradiction between shell scripting and full-blown programming languages. I can't help but feel that maybe it's time for a new tool to this end.

What would a new language look like? Much like the goals above, I think it would:

-   Be interactive, e.g. typing `ls` and hitting enter runs `ls`
-   Support commands as first class (see Bash)
-   Have enough language support that it would be relatively easy to write longer scripts
-   Use modern language conventions to make writing longer scripts easier while also not bogging down the expressiveness of the language
-   Support redirection and piping as syntax (perhaps Bash's biggest strength)


## Honorable mentions {#honorable-mentions}

Here is a brief discussion on possible candidates that I don't know enough about but look interesting.


### Perl {#perl}

I don't know any Perl and there's a chance I probably never well, I can't help but feel that I missed the boat on this one. Recent developments in the Perl world make it seem interesting, and it seems that the Perl community has done a lot of work to improve the language in recent years.


### AWK {#awk}

It's a shame I don't know AWK and I've been meaning to fix this for years. The very little AWK I know is interesting, and my impression of AWK is that it seems like a way to write _ad hoc_ programs in the middle of a Bash script. Maybe you want something `sed` can do but it's just kind of a pain to write in `sed`? AWK can probably do it.


### Lua {#lua}

I just started writing Lua as I recently discovered [Hammerspoon](https://www.hammerspoon.org). Lua reminds me a lot of JavaScript and seems like it'd be a good Python / Ruby replacement. I don't know much about it otherwise.


### Tcl {#tcl}

I stumbled across Tcl recently and I'm pretty intrigued by it. It seems like a deliberate attempt to improve a language like Bash, and it has a shell called Tclsh. Tcl has more "proper" language features that I think would eliminate a number of pain points with Bash, but I'm not sure how it would fare for large, complicated tasks. It might be worth investigating.


### Koi {#koi}

[Koi](https://koi-lang.dev/) is a little language I stumbled across on GitHub. It seems like it hits the sweet spot of being both interactive and easy to write. I haven't had much of a chance to mess around with it but it seems really cool and is exactly what I'd want out of a language like this.

[^fn:1]: To be clear, I should mention that I'm not just singling out JavaScript in this regard. Other languages such as Java, C#, Go, Rust, etc. likely fit this bill to for similar reasons, but I mention JavaScript in particular only because I've tried to write scripts with it.
