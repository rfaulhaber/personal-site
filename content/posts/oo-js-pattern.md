+++
title = "Please Don't Use OO Patterns in JavaScript"
author = ["Ryan Faulhaber"]
tags = ["js", "oo"]
draft = true
+++

A lot of newcomers to JavaScript that I've seen usually have some kind of experience with a 90's object-oriented language like Java or C#, and as such have been trained in how to approach common problems in terms of "patterns". Many of these patterns in JavaScript are redundant.

<!--more-->

## What are patterns? {#what-are-patterns}

If you went to college for computer science or otherwise came up in the OO tradition, you likely encountered a book called _Design Patterns: Elements of Reusable Object-Oriented Software_, sometimes referred to as "Gang of Four Design Patterns". This book outlines a number of ways of structuring code for solving common programming problems. For example, if you're writing Java and you're in a situation where you need only a single instance of an object shared across multiple contexts, the book prescribes using the singleton pattern, which roughly looks like this:

```java
public class MySingleton {
    private static instance = new MySingleton();

    private MySingleton() {}

    public static getInstance() {
        return this.instance;
    }
}
```

One use case I've heard for the singleton pattern is a shopping cart on a website. No matter where you are in the application, a user should only have a single instance of a shopping cart containing all the items they've added.

This explains what patterns are, but it doesn't explain why they're needed. Although I don't always agree with Rob Pike (one of the creators of the Go programming language), I strongly agree with his sentiments in [this video](https://youtu.be/5kj5ApnhPAE?t=240). To paraphrase him (who paraphrases Peter Norvig), patterns are a demonstration of weakness of a language. By "weakness" he means, I take to mean, a lack of expressiveness. In languages with more expressivity than Java or C#, many of the Gang of Four patterns are redundant, and JavaScript, for all its faults, is much more expressive than either.

To be clear, I don't fault people for applying what they've learned previously and try to apply that in JavaScript. That shows critical thinking, and is certainly something we all should have! But JavaScript is not Java or C# and there is no benefit in pretending it is. It's a different language with different paradigms.

Also, this **isn't** to say that patterns are useless in their respective languages. They tend to be very useful, in fact. This **is** to say, however, that the existence of these patterns illustrate a lack of expressiveness in the languages they exist in, and that (I believe) JavaScript is more expressive.

## Redundant Patterns in JavaScript {#redundant-patterns-in-javascript}

Let's walk through a few examples illustrating redundant patterns in JavaScript. Most popular patterns are redundant in JavaScript for at least one of two reasons:

1.  A number of patterns involve getting around the static typing of Java or C#. JavaScript, not being statically typed, doesn't have such problems.
2.  JavaScript has higher order functions.

In all the following examples I'll be using Java, as I'm more familiar with Java than C#.

### Factory {#factory}

The Factory pattern is used when you need to generate a concrete instance of an object that implements a particular interface. In Java, the Factory pattern look something like this:

```java
interface Foo {
    void bar();
}

public OneFoo implements Foo {
    public void bar() {
        System.out.println("I'm a OneFoo!");
    }
}

public TwoFoo implements Foo {
    public void bar() {
        System.out.println("I'm a TwoFoo!");
    }
}

public class FooFactory {
    public Foo createFoo(String type) {
        switch (type) {
            case "one":
                return new OneFoo();
            case "two":
                return new TwoFoo();
            default:
                return null;
        }
    }
}
```

`OneFoo` and `TwoFoo` implement the `Foo` interface, so we know they'll have a `bar()` method. In Java, this might be necessary because you might not care what the underlying implementation of `Foo` is, and maybe a real world object would be more tedious to create.

In JavaScript, it's not uncommon to have code that creates objects like a factory. However all of this code could be done with a function:

```js
function makeFoo(type) {
  switch (type) {
    case "one":
      return {
        bar() {
          console.log("I'm a OneFoo!");
        },
      };
    case "two":
      return {
        bar() {
          console.log("I'm a TwoFoo!");
        },
      };
    default:
      return null;
  }
}
```

In this case, the function is returning an object with a `bar()` method whose implementation depends on the `type` parameter. The resulting object isn't an instance of a class (though with some extra code it certainly could be), but is functionally equivalent. JavaScript, because of its lack of static typing, allows us to do this.

### Decorator {#decorator}

The Decorator pattern allows objects to receive new behavior at runtime. In Java, an example might look like:

```java
// adapted from Wikipedia's example: https://en.wikipedia.org/wiki/Decorator_pattern#Java

interface Window {
    void draw();
}

class SimpleWindow implements Window() {
    public void draw() {
        // draw window
    }
}

abstract class WindowDecorator implements Window {
    private Window w;
    public WindowDecorator(Window w) {
        this.w = w;
    }

    @Override
    public void draw() {
        w.draw();
    }
}

class ScrollbarWindow extends WindowDecorator {
    @Override
    public void draw() {
        super.draw();

        drawScrollBar();
    }
}
```

What's happening here? The idea behind `ScrollbarWindow` is that it should add a scroll bar to a window whenever -n the window is drawn. By doing this we separate out responsibilites: `ScrollbarWindow`, given any `Window` object, applies a scrollbar to `Window`. `Window` doesn't necessarily care about what gets applied to it.

How might this look in JavaScript? There's a few ways of tackling this problem. First, let's try to implement this in a way that's most similar to the Java example above:

```js
class Window {
  draw() {
    // draw window
  }
}

class WindowDecorator {
  constructor(window) {
    this.window = window;
  }

  draw() {
    this.window.draw();
  }
}

class ScrollbarWindow extends WindowDecorator {
  draw() {
    super.draw();
    drawScrollBar();
  }
}
```

This is more or less the same as the Java version above, and will get you the same results. What I don't like about this though is that it uses classes and inheritance to add new behavior. The middle class, `WindowDecorator`, feels unnecessary. In JavaScript, there's what I would consider a better way of doing this while acheiving similar results. We'll assume the `Window` class is a given.

```js
function scrollbarWindow(windowType) {
  return class {
    constructor(window) {
      this.window = window;
    }

    draw() {
      this.window.draw();
      drawScrollbar();
    }
  };
}
```

In the above example we're actually returning a new _class_ itself from a function. We could use it like:

```js
// note that we're passing the Window class, not an insance of a window object.
const ScrollWindow = scrollbarWindow(Window);
const sw = new ScrollWindow();
```

By returning an anonymous class we can tack on a call to `drawScrollbar` to any kind of object that has a `draw()` method. Admittedly, this example undersells how flexible this solution is, because the anonymous class returned could take on all kinds of different behavior based on the function's parameters.

In the ideal world, however, I think functional composition would be the best solution. Rather than dealing with classes or inheritance, we could build an object by chaining together a series of functions. It would look something like this:

```js
const scrollWindow = withScrollbar(newWindow());
scrollWindow.draw();
```

### State {#state}

The last pattern I want to talk about is the State pattern. This pattern is used for when you want to keep track of stateful transitions between objects. Consider a vending machine, which has three states: waiting for payment, waiting for selection, and then dispersing selection. Very often our applications are stateful: a page displays different information depending on whether or not a user is logged in or if the page is loading, etc.

Let's consider a todo app. The app should maintain a list of visible tasks and display tasks differently depending on whether or not they're open, in progress, or closed. Also, they should only ever progress in that fashion and not skip a step.

In Java, the implementation of the state pattern might look like this (again, adapted from [Wikipedia](https://en.wikipedia.org/wiki/State%5Fpattern)):

```java
interface TodoState {
    String getStatus();
    void updateStatus(TodoStateContext context);
}

class TodoStateContext {
    private TodoState state;

    public void setState(TodoState state) {
        this.state = state;
    }

    public String getStatusPrefix {
        return this.state.getStatus();
    }
}

class OpenState implements TodoState {
    @Override
    public String getStatus() {
        return "[ ]";
    }

    @Override
    public void updateStatus(TodoStateContext context) {
        context.setState(new InProgressState());
    }
}

class InProgressState implements TodoState {
    @Override
    public String getStatus() {
        return "[-]";
    }

    @Override
    public void updateStatus(TodoStateContext context) {
        context.setState(new ClosedState());
    }
}

class ClosedState implements TodoState {
    @Override
    public String getStatus() {
        return "[X]";
    }

    @Override
    public void updateStatus(TodoStateContext context) {
        context.setState(new ClosedState());
    }
}
```

## Abstractions should additions, not starting points {#abstractions-should-additions-not-starting-points}
