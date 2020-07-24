+++
title = "Ways Emacs Has Changed What I Do"
author = ["Ryan Faulhaber"]
date = 2020-07-23T22:58:00-04:00
tags = ["emacs"]
draft = false
+++

[Previously](https://ryanfaulhaber.com/posts/try-emacs/) I had written about trying Emacs, but looking back on that post I felt like I was bit vague about the ways in which it's changed the things I do, so I wanted to provide some examples. Emacs has replaced a number of programs in my life, and not all of them are developer related.

<!--more-->

## Programming {#programming}

If you can believe it, this is maybe the most underwhelming part. Don't get me wrong, though! Emacs is a great editor obviously, and it has all the conveniences of a more modern editor and much more. I did want to talk about what it's like to write code in Emacs though, briefly.

Being a web developer I write a lot of JavaScript, and as you'd imagine there's a bunch of extensions in Emacs for writing JavaScript. Emacs has a package called [quickrun](https://github.com/emacsorphanage/quickrun) that can evaluate code in buffers on the fly.

{{< figure src="/images/quickrun.png" >}}

As someone who sometimes needs a reminder on the particularities of how certain JavaScript methods work, this is very useful!

## Journaling {#journaling}

I've always wanted to get into the habit of journaling. For the last few years of my life I've been through a couple of journaling apps, some of which I've paid for! Bur for whatever reason I could never get into the habit. I'd start out strong and then stop a week or two in, only to sporadically update.

With Emacs, I've been journaling almost every day for the last two months or so, and it's all thanks to [org-journal](https://github.com/bastibe/org-journal) (I also think it has something to do with the fact that my journal and all my other Org documents live in the same place, and that Emacs provides a very convenient way of creating new journal entries).

## Blogging {#blogging}

The biggest benefit of Org mode, like Markdown, is that it's a format that can be easily translated into another format. [ox-hugo](https://ox-hugo.scripter.co/), an Org exporter geared towards converting Org documents into Hugo-compatible Markdown files, is now what I use to manage my blog. Blogging is new to me and I only have a few posts under my belt, but almost all of them have been written as Org documents and exported via ox-hugo (or just as GitHub-flavored Markdown when I post the same thing on dev.to).

## Note-taking {#note-taking}

This is the biggest change.

A lot of what I read could be called academic. Before Emacs I had used Evernote, Notion, Trello, physical notebooks, and other apps that I'm probably forgetting to take notes. For some reason it had never occurred to me to take notes as plaintext (I never took notes as Markdown files), but when I learned about Org mode, it seemed natural that I'd use it to take notes.

But Emacs let me take it one step further.

I had been reading about [Zettelkasten](https://zettelkasten.de/) and learned about [Roam Research](https://roamresearch.com/). The idea of having a flat note hierarchy with links between all your notes (structurally similar to but functionally different than a Wiki) was immediately appealing to me. Of course, because the Emacs ecosystem is so fully featured, there's a package for that: [org-roam](https://github.com/org-roam/org-roam), which is truly a marvel of an Emacs package.

Although I'm still in the process of figuring out how the Zettelkasten method can work with a Roam-like system, I've already taken extensive notes using org-roam: my org-roam directory currently sits at 323 files, though not all of those files have content.

## Email {#email}

I never thought I'd be this person. When you hear about people "living" in Emacs, this is just part of what they mean.

I host my own private email server (for a guide on how to do this yourself, I strongly recommend [this one](https://www.c0ffee.net/blog/mail-server-guide/). It's the one I used), and I've never found a great or consistent email client for the desktop. The closest I came was Mailspring, which, although it is nice, it's a bit slow for what it is.

When I first started learning Emacs, I knew you could check your email with it. [mu4e](https://www.djcbsoftware.nl/code/mu/mu4e.html) will let you do this. You can read, manage, and send email all from Emacs. You can even write emails as Org documents! It's surprisingly easy and consistent to use. It's best used when your emails are plaintext, but [that's generally true too](https://useplaintext.email/).

## And plenty more... {#and-plenty-more-dot-dot-dot}

Emacs has changed a lot of what I do in a lot of small ways that I can't really count. It's really a wonderful program, and I can't believe how much I've come to really love using it. Every day I feel like I'm learning something new about it, and it's all such a joy to use! As I said in my last post, you really should give it a try.
