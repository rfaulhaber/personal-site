+++
title = "Some First Impressions of Nix"
author = ["Ryan Faulhaber"]
date = 2020-08-28T22:06:00-04:00
tags = ["linux", "tooling"]
draft = false
+++

In my relatively few years of software development I've seen first hand how hard it can be to set up a consistent environment, development or otherwise, across a team, and I think Nix might be a solution.

<!--more-->

Docker is notably a solution for this: rather than bring everyone's environments up to speed, Docker brings the environment to you in the form of containers. Since Docker containers are deterministic, you also know that if your application works on your computer in a container, it'll work on a server in a container. Very handy.

I recently learned about [NixOS](https://nixos.org/) and the Nix package manager, and it's very appealing to me as a developer and a Linux user for a few reasons. The goal of NixOS and its related software seems to be the ability to create systems and environments declaratively. This may sound like Docker, but unlike Docker, the end goal is your system, not a system apart from your environment.

I've been working with it all for a few weeks now, and here are some thoughts I have.

## Nix, the operating system (NixOS) {#nix-the-operating-system--nixos}

NixOS is the Linux distro that uses the Nix package manager first class. This is maybe the part of the Nix ecosystem I have the least experience with, as I've only been running it in a VM so far. My goal is to take my current setup in Arch and reproduce it in a configuration.nix file, get that out of the VM, and use it to set up a new NixOS installation. The fact that this is even possible is pretty cool, and with relatively little work I've already gotten a decent amount of my system reproduced (though along the way I've also decided to make a few adjustments, like switch from [bspwm](https://github.com/baskerville/bspwm) to [SwayWM](https://swaywm.org/)).

## Nix, the package manager (`nix`, `nix-*`) {#nix-the-package-manager--nix-nix}

Calling Nix a package manager is underselling it, I think, because Nix is unlike any other package manager I've ever used.

For one thing, its usage isn't limited to NixOS, or even Linux: you can install and run packages using Nix on Mac as well. This, it turns out, is very handy on Mac.

On Ubuntu, you might install a package like:

```text
apt install nodejs
```

On Nix, the equivalent would be:

```text
nix-env -i nodejs
```

This is not the preferred way to install something, though, because when you regenerate your system's configuration, `node` won't be there. The only "permanent" packages are those that are specified in your system's configuration. That way, you always know exactly what's installed. The upside to this is that Nix proivdes a way of "trying" packages without letting you commit to keeping them on your system. The downside is that you have to reload your whole system just to permanently install something. A small price to pay, I suppose!

These aspects of Nix also have another upside: rollbacks to a specific state. If you mess up your configuration, as is easy to do in Linux, you can roll back your entire system to a time where it wasn't messed up.

## `nix-shell`, the portable environment builder {#nix-shell-the-portable-environment-builder}

A brief aside.

The Nix package manager comes with a fascinating tool called `nix-shell`. Its purpose is also similar to that of Docker: provide a declarative build envronment.

What it does is, according to a `shell.nix` file or a specific command, it will generate a shell environment suited to that configuration, keeping it separate from the "main" environment.

For example, let's say I want to work on a Node project. I could run the following:

```text
nix-shell -p nodejs
```

After some output to the terminal, I'm dropped into a new shell environment where `node` is now an executable. This way, you can specify the tools you need for a particular project without installing them in your main environment. I find this useful for Python, which, for some reason, has always given me a lot of trouble on my Mac.[^fn:1]

## Nix, the programming language {#nix-the-programming-language}

Finally, Nix is also a programming language. I mean, it _is_ a full blown functional programming language, but it's also kind of a configuration language, or at least had configuration languages in mind while it was designed. Imagine of JSON, YAML, or TOML also had functions and could be evaluated, and that's kind of what Nix is (or at least, how it reads to me!).

A sample piece of Nix configuration, taken from the NixOS manual, looks like this:

{{< highlight nix >}}
users.users.alice = {
isNormalUser = true;
home = "/home/alice";
description = "Alice Foobar";
extraGroups = [ "wheel" "networkmanager" ];
};
{{< /highlight >}}

This is part of a larger configuration, and if you're familiar with JSON you can probably imagine what this is setting. What's interesting though is that obviously this configuration actually corresponds to something on your system and would produce an actual user named "alice" with that home directory and those groups, etc.

The language itself isn't terribly complicated conceptually if you're familiar with other functional programming languages, but I have found it hard to get used to. I find it very hard to know what's possible, and I also find it difficult to know what is set where. While writing my configuration.nix file for what'll hopefully be my new NixOS install, I've frequently found myself asking things like "How do I enable such and such setting?" or "When would I need to use `mkOption`?" I'm sure I'll pick it up in time, though.

## Final thoughts {#final-thoughts}

The Nix ecosystem is very fascinating. For as long as I've been writing code I've long wondered how to consistenly reproduce developer environments, and I think if Nix isn't a full blown solution to this problem, it seems on track to being one. I'm very eager to learn more Nix!

[^fn:1]: Sorry Python fans, say what you will about `node_modules`, there's plenty to criticize, but at least I haven't had _multiple_ CLI programs just not work because they're expecting Python3 and not Python2 or vice versa! To be fair to the Python fan though, I think this is Apple's fault and not Python's.
