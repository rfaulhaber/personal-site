+++
title = "Lessons Learned from Functional Programming"
author = ["Ryan Faulhaber"]
date = 2020-08-02T14:41:00-04:00
tags = ["js", "fp"]
draft = false
summary = "Learning about functional programming has changed the way I write and think about code. These are some ideas I've tried to import back into JavaScript."
+++

When I went to college the majority of my programming classes were taught with Java. As a result I learned what I like to call "classical" object-oriented programming. As I started writing more JavaScript I realized I had a lot of issues importing the OO lessons I learned. At some point I read Kyle Simpson's [Functional-Light JS](https://github.com/getify/Functional-Light-JS) and my whole world turned upside down. From there I dove into the world of functional programming and internalized many of the lessons I learned. I write JavaScript completely differently now, and I feel as though I'm a better programmer for it overall in any language I write. Here are some of the lessons I learned.


## Data should be externally immutable {#data-should-be-externally-immutable}

_Mutable_ data generally means data that can be changed. Consider the following JavaScript:

{{< highlight js "linenos=table, linenostart=1" >}}
const x = [1, 2, 3]

console.log('before:', x);

x[1] = 4;

console.log('after:', x);
{{< /highlight >}}

Here we are _mutating_ the `x` array by changing the item at `1`. Many proper functional programming languages do not have a means for letting you do this. Instead, new data is _derived_. In functional programming, the equivalent code would basically do this:

{{< highlight js "linenos=table, linenostart=1" >}}
const x = [1, 2, 3];
const y = [...x.slice(0, 1), 4, ...x.slice(2, 3)];

console.log('y:', y);
{{< /highlight >}}

That is, it copies every element except the one we want to change, and return a new array.


### Why is it important? {#why-is-it-important}

In languages that have implicit referencing (e.g. Java, JavaScript), having functions that mutate objects can lead to confusing and hard to trace code. For example:

{{< highlight js "linenos=table, linenostart=1" >}}
function changeFirst(arr) {
    arr[0] = 'first';
}

const x = [1, 2, 3];

changeFirst(x);
console.log('x:', x);
{{< /highlight >}}

If you were working in a large codebase, and you didn't happen to know what `changeFirst` did, this could lead to potentially confusing code. If `changeFirst` treated `x` as immutable, you'd know that after `x` was passed to it you wouldn't have to worry what the value is. This, I think, would be clearer:

{{< highlight js "linenos=table, linenostart=1" >}}
function changeFirst(arr) {
    return ['first', ...arr.slice(1)];
}

const x = [1, 2, 3];
// --- don't have to worry about x after this point ---
// (unless we need to derive more data from it of course)
const newX = changeFirst(x);
console.log('x', x);
console.log('newX', newX);
{{< /highlight >}}

And of course by _externally_ mutable I mean that a function should be free to mutate data within itself, but should not mutate a function's arguments or anything in the outside world.


## Functions should reduce side effects {#functions-should-reduce-side-effects}

A **side effect** is when a function modifies some value outside of its current scope. Contrary to popular belief, though, side effects are not in themselves _bad_, nor are they necessarily _hidden_. Side effects do tend to create code that's harder to reason about, though.

Kyle Simpson's [chapter on side effects in JavaScript](https://github.com/getify/Functional-Light-JS/blob/master/manuscript/ch5.md/#chapter-5-reducing-side-effects) is wonderful, but I'll try to do it justice here.

Unfortunately, object-oriented languages have side effects baked into their design, and I think that's part of the reason why there's so much literature written around "clean code" and things like that.

For example, consider the following Java code:

{{< highlight java "linenos=table, linenostart=1" >}}
public class Foo {
    private int number = 0;

    public void inc() {
        number++;
    }
}
{{< /highlight >}}

In this case, a call to `Foo`'s `inc` method produces a side effect of modifying an instance of `Foo`'s state. See what I mean when I say they're baked in?

Again, though, this isn't to say that they're bad. The problem with this code though is that it's not immediately obvious what's happening to the outside.

An example in JavaScript would be the following:

{{< highlight js "linenos=table, linenostart=1" >}}
let x = 1;

function doSomething() {
    x++;
}
{{< /highlight >}}

`doSomething` here modifies `x`, which is definitely outside of the scope of its function.


### Why is it important? {#why-is-it-important}

[The Wikipedia article on side effects](https://en.wikipedia.org/wiki/Side%5Feffect%5F(computer%5Fscience)) mentions some interesting concepts: referential transparency and idempotence.

**Referential transparency** is simply when an expression is written in such a way that you could replace the expression itself with its resulting value. Consider the following:

{{< highlight js "linenos=table, linenostart=1" >}}
function add(x, y) {
    return x + y;
}

const number = add(2, 3);
{{< /highlight >}}

`add` is referentially transparent because we could replace its call with the number `5` and it would make no difference to the behavior of our program.

**Idempotence** is similar. It can be thought of as having a similar definition to "deterministic." An idempotent function basically means that you can call the same function more than once with the same arguments and achieve the same results. The best example is REST endpoints, where a lot of REST API callouts are expected to do the same thing. An API call like `GET /user?id=123` would be expected to return a specific user. You could call that endpoint a hundred times and it would do the same thing.

I think these two concepts, above all else, help with making code readable and reasonable. If we know our functions have little side effects and always do the same things, we can spend less time worrying how they effect the system.

In general, reducing side effects requires some discipline, especially in OO languages. I try to stick to writing functions that operate only on their function parameters as much as possible and return a value somehow derived from the arguments. This way I hope to write more predictable and deterministic code.


## Classes aren't always necessary {#classes-aren-t-always-necessary}

This was a hard thing for me to (un-)learn while learning JavaScript (and subsequently newer languages that aren't strictly OO, like Go and Rust).

One of the problems with learning Java or C# as your first language (Java was mine), I tend to find, is that it forces you to think of problems in terms of object interactions. Java and C# don't give you much option in this regard: your entire application has to be expressed in terms of classes, so you have to use them. This, to me, is the fatal flaw of both languages. Not all problems necessitate classes.

In languages such as JavaScript where you don't have to express everything in terms of classes, where is the line drawn? For me, it's a question of statefulness. Does the part of my application I'm currently working on need to keep track of anything directly? In writing JavaScript, I find that a majority of the time it usually does not.

In JavaScript, there are mainly two types of classes I create:

1.  Component classes. If I'm writing React, for example, and I find that I need a stateful component, I will declare it as a class. Otherwise it's a function.
2.  Useful types. I don't create these often but sometimes you find yourself needing to collect data in a way that standard objects don't allow for. If I were writing a parser for example, the parser itself would probably be a class.

The rest of my code lives in functions.

In statically typed languages, there's a third type of class I'd create: what the programming language Kotlin calls "data classes." A data class is just a class that wraps data and has no internal logic to it. It's a class with all public fields that is meant to take advantage of a language's static typing. Such classes tend to be things like REST API requests or responses.


## In conclusion {#in-conclusion}

The above are all lessons I've learned from not only reading about functional programming but trying to learn functional languages. Functional programming languages are different than what most people are used to, I think, but they also offer a different way of thinking about programs, even if most of the time we can't write programs functionally.

I don't write purely functional JavaScript, but I've tried to import the lessons I've learned from functional programming where possible to make my JavaScript clearer. JavaScript can be confusing as it is and it doesn't need any help in that regard, but I feel that trying to write more functional code as made my JavaScript clearer.
