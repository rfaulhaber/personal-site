+++
title = "You Should Try Linux"
author = ["Ryan Faulhaber"]
date = 2020-08-05T21:51:00-04:00
tags = ["linux"]
draft = false
+++

I've been using Linux since about 2013 and it's been a consistently rewarding experience. Not only am I far more productive on Linux than I am on macOS or Windows, I have the satisfaction of using a system that's uniquely mine.

<!--more-->

When I first started using Linux I was beginning my computer science education. I had a consistent problem with the tools the classes I was taking called for. It always seemed like there were normal install instructions, and install instructions for Windows (I had a big clunky Windows laptop at the time). The computer lab had all the software I'd need but it was a pain to always be going to the computer lab to get my work done. It just so happened that my dad, who works in IT, had a customer give him an old Dell laptop and he told me I could have it if I wanted it. It didn't come with a Windows license so I had to make do. I installed Ubuntu onto it and started down the Linux journey I'm on now.

If your daily driver is macOS or Windows, I want to try and convince you to at least try Linux.

## Linux is easier to use than you think {#linux-is-easier-to-use-than-you-think}

A lot of people I've talked to avoid Linux because they hear it's hard to use. It doesn't support x piece of software or y isn't compatible with it. Sometimes those are fair points, and sometimes Linux does require you to adjust how you do things. For example, if you're locked into Office 365 and don't want to switch, Linux indeed will probably not be much help in this case.

However, if you're flexible in the software you use, Linux can provide alternatives to a lot of software that isn't supported on it (instead of Microsoft Office you could use LibreOffice. I know it's not the same but for being free and open source it's _very_ fully featured).

Installing Linux can also be pretty simple. The more well-supported distros have graphical installers that don't require a ton of technical knowledge (a distro is "flavor" of Linux: each distro comes with the Linux kernel but might provide a different user experience. Ubuntu, Debian, Mint, and Arch are all distros). Of course, if you wanted to get into the nitty-gritty of Linux installation, [there are ways](https://wiki.archlinux.org/index.php/installation%5Fguide) [of going about that](http://www.linuxfromscratch.org/) too.

## Linux is everywhere {#linux-is-everywhere}

Linux is the world's most used operating system in every domain except for desktops (that honor belongs to Windows). If you choose to use a Linux desktop, the skills you learn by using and customizing your desktop are things you can take with you into other domains. When I first started learning how to use AWS, I wasn't intimidated at all by EC2 because I knew it was just a Linux server of some kind. When AWS told me how to set up my SSH keys, provision and update my server, and so on, this was all stuff I already had a sense of how to do, just because I was already doing a lot of that stuff on my desktop!

## Linux comes from the Unix tradition (kind of) {#linux-comes-from-the-unix-tradition--kind-of}

If you're a Windows user, you honestly have no idea on what you're missing out on in this regard.

Linux is not a Unix, but it was designed to be a clone of Unix. This means that there's a lot of crossover (at a certain level) between how things work on Linux and how things work on Unix systems (Unix systems include any of the BSDs and macOS). The terminal experience, for example, will for all intents and purposes be nearly the same. It's not until you get into the lower level details that things start to make a difference (fun fact: the `ls` program has different implementations between Linux and Unix, though they behave similarly).

I had never used macOS until I got my first job, where they asked me if I'd rather have a Windows laptop or a Macbook. I chose a Macbook, opened the terminal, and felt mostly at home.

## Linux is yours {#linux-is-yours}

This, to me, has become the main selling point. I have a Macbook, I have a Windows partition on my computer, but the reason why I keep using Linux most of the time is because my Linux desktop is _uniquely_ mine.

I mean this both in terms of the customization and maintenance of my system. I'm an Arch Linux user (maybe soon-to-be NixOS user?) and one of the things I've come to value about Arch is that, if I'm willing to put in the work, I can make my system look and feel pretty much however I want. I've become enamored with [tiling window managers](https://github.com/baskerville/bspwm).

With Windows and macOS, although they may have their merits, the way you interact with them is largely at the whims of Microsoft and Apple respectively. If you don't like what Apple decided to do this year with macOS, too bad! With Linux, you are not stuck to such a fate.

If you're willing to put in the work and learn how to do it, customizing your system exactly how you want can be very rewarding. It's a trade-off though: you must put in the time and learn the skills to do it. You'll likely learn a lot doing it along the way, though. If you feel so inclined you can look for inspiration from [r/unixporn](https://www.reddit.com/r/unixporn/), where users show off their system customizations.

## How can I try Linux? {#how-can-i-try-linux}

If you're just starting out with Linux, I'd recommend one of the more well supported distros, like Ubuntu or Linux Mint. I've also heard good things about Elementary, Pop!\_OS and Fedora, although I've never used any of those. If you rely on graphical software especially these distros will make the transition easier.

To get a good sense of what's out there, [Distrowatch](https://distrowatch.com) has information on nearly every distro out there that you could think of, and has links to where to find more information about particular distros. If you don't want to commit a partition of your hard drive to it, you can also always try it [in a VM.](https://www.virtualbox.org/)

## How can I learn Linux? {#how-can-i-learn-linux}

I think I'll be putting out a series of posts with the intention of teaching people how to use Linux from an absolute beginner's perspective, so watch my feed!

Back when I was getting started with Linux I read [Learn Linux The Hard Way](https://archive.is/Akjau), which served as a wonderful introduction to Linux overall (the site seems to have since been taken down, but it can be accessed through that archive.org page). In the meantime, this should serve as a good crash course.

Aside form the book above, I learned Linux two ways:

1.  Starting with the question "How can I do this more efficiently?", doing some Googling, and learning about all kinds of things I didn't know before.
2.  Doing as much as possible in the terminal
3.  Seeing other people's dotfiles

With Linux comes a tradition of nearly 30 years of computing, and over the course of that 30 or so probably every problem you can think of as an individual has been solved. If you think there's an easier way to do something in Linux, there probably is, but might involve writing a script.
