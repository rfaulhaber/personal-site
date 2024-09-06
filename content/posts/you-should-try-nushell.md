+++
title = "You Should Try Nushell"
author = ["Ryan Faulhaber"]
tags = ["nushell"]
draft = true
+++

Oh hey, I haven't written anything in almost three years! Hello again, world!

I'm breaking my long silence with publishing writing to tell you that I am a [Nushell](https://www.nushell.sh/) believer now. I'm not sure I've ever used a more consequential piece of software in my entire career than Nushell.

You see, for a long time, I was a very dedicated Zsh user, and terminal power user generally. I was using Zsh well before macOS made it the default shell. I felt that Zsh offered better completion options than Bash, while still being relatively Bash-compatible. I installed [Oh My Zsh](https://ohmyz.sh/) on every machine I used. I used to be one of those people who would advocate that you should learn `grep`, `sed`, `awk`, etc. to make your life in the shell easier. I was very dedicated to the Unix philosophy of using pipes, "doing one thing well", and plaintext.

And then I used Nushell. And everything changed.

Nushell is a shell like any other, but it is specifically not a POSIX-compliant shell like Bash or Zsh. It's more like Powershell: it's trying to do its own thing. For the dedicated Unix advocate, this might raise a red flag. But fear not! Where we're going, we don't need POSIX-compliance.

The first improvement Nushell makes is that it primarily deals in structured data, much like Powershell. Gone are the days of parsing plaintext! In most cases, Nushell does not even bother. Nushell comes with a built-in `ls` command, for example, which behaves like Unix's `ls`, but it outputs an object rather than text:

{{< figure src="/ox-hugo/Screenshot from 2024-09-06 13-54-50.png" >}}

This table is an object that we can manipulate in Nushell. To get a sense of the kind of data we're dealing with, we can export this to JSON by writing:

{{< highlight nushell >}}
ls | to json
{{< /highlight >}}

{{< highlight json >}}
[
  {
    "name": "hello.json",
    "type": "file",
    "size": 35,
    "modified": "2024-09-06 13:54:20.185255522 -04:00"
  },
  {
    "name": "hello.txt",
    "type": "file",
    "size": 11,
    "modified": "2024-09-06 13:53:40.068277380 -04:00"
  }
]
{{< /highlight >}}

Nushell adopts two major concepts from the Unix philosophy and POSIX shells: doing one thing well, and pipelines. Pipelines in Nushell however are more like function composition than stdio redirection, although they can be used for stdio redirection. Let's say, for whatever reason, you wanted to find the length of each filename in your current directory. You could write the following:

{{< highlight nushell >}}
ls | insert "name length" { |row| $row.name | str length }
{{< /highlight >}}

This takes the object returned by `ls`, appends a column named "name length" that is derived by the function `{ |row| $row.name | str length }`, which calculates the string length of each `name` on each row. There's nothing special happening in this function, by the way. This is just regular Nushell syntax.

The output of the `ls` command is not special. It's just a [table](https://www.nushell.sh/book/working_with_tables.html). We could even make our own tables by writing something like:

{{< highlight nushell >}}
[[name type]; ["hello.txt" "file"] ["world.txt" "file"]]
{{< /highlight >}}

This CSV-like notation creates a table with two columns, name and type, and two rows.

Nushell has many built-in commands that allow for writing very ergonomic and modular commands. For example, continuing with our `ls` example, you could filter our `ls` output with `where`, much like SQL:

{{< highlight nushell >}}
ls | where type == dir
{{< /highlight >}}

will return a list of directories. This is the equivalent of writing this equally valid code:

{{< highlight nushell >}}
ls | filter { |row| $row.type == dir }
{{< /highlight >}}

In much the same way as Bash is both a command interface and a programming language in its own right, [Nushell is the same way](https://www.nushell.sh/book/nu_fundamentals.html). And unlike our friends the POSIX shells, I'd argue, much more rational. Commands in Nushell are just functions. For example, evaluating this in your shell:

{{< highlight nushell >}}
def hello [] -> string {
  "hello world"
}
{{< /highlight >}}

will add a `hello` command:

{{< figure src="/ox-hugo/Screenshot from 2024-09-06 14-00-38.png" >}}

Nushell will even provide a default `--help` flag!

{{< figure src="/ox-hugo/Screenshot from 2024-09-06 14-00-55.png" >}}

Nushell provides a number of ways to bring data into Nushell. Nushell comes with a JSON parser. If you took our JSON output from earlier, put it a file called `dir.json`, you could write:

{{< highlight nil >}}
open dir.json
{{< /highlight >}}

And Nushell would print the same table that `ls` printed earlier! Or, if you have something that can output JSON, you could read it in. Running:

{{< highlight nil >}}
docker container ls --format '{{json .}}' | lines | each { from json }
{{< /highlight >}}

reads `docker container ls` (a regular Docker command, Nushell calls this an external command) line by line, converts each line from JSON, and outputs a table with the same column names that Docker provides in its output!

And all of this is just the tip of the iceberg.

Being a "hardcore" Linux user, I was very reluctant to want to switch to Nushell. But gone are my days of stringing plaintext through several different arcane programs. If Bash is like C, Nushell is like (insert your favorite new programming language from the last 10 years here): pleasantly easy to write, plenty of useful built-in features, and comes with lots of helpful error messages.

This is a far from comprehensive write up, but I hope it's enough for you to at least consider trying Nushell. It's been a total game changer for me. If I can help it, I don't want to have to deal with Bash or any POSIX shells again.
