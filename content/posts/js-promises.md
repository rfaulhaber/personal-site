+++
title = "A Guide to Promises in JavaScript"
author = ["Ryan Faulhaber"]
date = 2020-06-02T14:00:00-04:00
draft = false
+++

Although the `async` and `await` keywords are now part of standard JavaScript, under the hood they ultimately use Promises. Here we'll explore what Promises are, why they're needed, and how you can "promisify" callbacks in JavaScript.

I find a lot of newcomers are often confused by terms like "callbacks", "Promises", and what exactly `async` and `await` do. I hope to clear that up with this article.

For the sake of clarity, this guide will use `function` syntax, and not arrow functions. If you know how to use arrow functions, you can replace much of this code with arrow functions and have it behave similarly. Also, some of these code samples are more verbose than they need to be. Methods like `Promise.resolve()` can cut down on boilerplate code.


## First Class Functions in JavaScript {#first-class-functions-in-javascript}

In JavaScript, functions can be used like any other variable. This makes them _first class_. For example:

{{< highlight js "linenos=table, linenostart=1" >}}
function callFunc(val, f) {
    return f(val);
}

// a simple function that adds 10 to any number
function add10(x) {
    return x + 10;
}

// here we're passing the `add10` function to another function
callFunc(3, add10); // => 13
{{< /highlight >}}

Note that in the above example, `callFunc` is calling the function we pass it and passing in a value itself. Here `f` could be replaced with any function.

In JavaScript functions can be **anonymous**, simply meaning that they aren't named[^fn:1].

You can pass an anonymous function to another function directly if you so choose. We can rewrite the call to `callFunc` using an anonymous function in the following way:

{{< highlight js "linenos=table, linenostart=1" >}}
callFunc(3, function(x) {
    return x.toString();
}); // => '3'
{{< /highlight >}}

One interesting aspect of this feature is that it allows for a deferral of execution of sorts. The function we pass to `callFunc` doesn't actually get called until the function itself calls it.


## (Re)-Introducing Callbacks {#re-introducing-callbacks}

A **callback** is an extension of this concept. Some definitions of callbacks make them sound just like first class functions, but a more specific definition would be: a function that is invoked at the end of an asynchronous operation.

A classic example is with JavaScript's `setTimeout` function:

{{< highlight js "linenos=table, linenostart=1" >}}
setTimeout(function() {
    console.log('hello world!');
}, 2000);
{{< /highlight >}}

```text
undefinedhello world!
```

In the above example, "hello world!" will get printed after two seconds. You can think of `setTimeout` as performing an operation, in this case, waiting for two seconds, and then calling the anonymous function after that time has passed. We don't have any control over what `setTimeout` is doing, but we know that it will wait for 2000 milliseconds, and are able to provide it a function to be executed once it's done (of course we expect `setTimeout` to do this). This is generally what callbacks are.

Callbacks developed as a pattern in JavaScript because they were an easy way to know when some asynchronous actions ended. Fetching data from a server, for example, usually involved writing a callback to handle that resulting data.

Although callbacks do get the job done, they do lead to very confusing code, and this is perhaps the biggest problem with them. Consider the following example. Suppose we have a function called `getDataFromServer` that takes some data necessary for a database query and a callback, to be executed upon the completion of that callout:

{{< highlight js "linenos=table, linenostart=1" >}}
// `getDataFromServer` takes a callback and data and passes `data` and
// `error` to whatever callback we provide
getDataFromServer(someInitialData, function(data, error) {
    if (data) {
        // here we do our second query
        getDataFromServer(data, function(nextData, error) {
            // here we get our next result
            if (nextData) {
                doSomethingElse();
            }
        });
    }
    // ...
});
{{< /highlight >}}

It's possible to rewrite the above code using named functions but it doesn't make it much less confusing.

{{< highlight js "linenos=table, linenostart=1" >}}
getDataFromServer(initialData, firstRetrieval);

function firstRetrieval(data, error) {
    if (data) {
        getDataFromServer(nextRetrieval, data);
    }
    // ...
}

function nextRetrieval(data, error) {
    if (data) {
        doSomethingElse();
    }
    // ...
}
{{< /highlight >}}

This is referred to as "callback hell", because, aside from _looking_ like hell, it creates a maintenance issue: we're left with a bunch of callbacks that may be difficult to read and mentally parse through.

Neither of these examples consider variables that live outside the context of these functions. Code like this used to be quite commonplace. Maybe you need to update something on the DOM once you get the first query. Very confusing!


## Enter Promises {#enter-promises}

A `Promise` in some sense is a glorified callback. They allow you to transform code that utilize callbacks into something that appears more synchronous.

A `Promise` is just an object. In its most common usage it can be constructed as such:

{{< highlight js "linenos=table, linenostart=1" >}}
const myPromise = new Promise(executor);
{{< /highlight >}}

`executor` is a function that takes two arguments provided by the `Promise` object, `resolve` and `reject`, which are each functions themselves. `executor` usually contains some asynchronous code and is evaluated as soon as the `Promise` is constructed.

A trivial example of a `Promise` can be seen with `setTimeout`

{{< highlight js "linenos=table, linenostart=1" >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        const message = 'hello world';
        console.log('message in promise: ', message);
        resolve(message);
    }, 2000);
});
{{< /highlight >}}

This code is a little different than our original `setTimeout` code. In addition to printing "hello world" to the console, we're passing that string to the `resolve` function. If you run this code, `message in promise: hello world` gets printed to the console after two seconds.

At this point, it may not be clear why Promises are useful. So far we've just added some more decorum around our callback code.

In order to make this code a little more useful, we'll invoke the Promise's `.then()` method:

{{< highlight js "linenos=table, linenostart=1" >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        resolve('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message);
});
{{< /highlight >}}

By calling `.then()` we can actually use the value passed to `resolve`. `.then()` takes a function itself, and that function's arguments are whatever get passed into the `resolve` function. In the above code we're passing `'hello world'` and we can expect it to be passed to whatever function we give `.then()`.

It's important to note that `.then()` actually returns another `Promise`. This lets you chain `Promise` calls together. Whatever is returned in the function passed to a `.then()` is passed to the next `.then()`.

{{< highlight js "linenos=table, linenostart=1" >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        resolve('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message); // logs "message: hello world"
    return message.toUpperCase();
}).then(function(message) {
    console.log('message: ', message); // logs "message: HELLO WORLD"
});
{{< /highlight >}}

There is an additional method, `.catch()`, which is used for error handling. This is where the `reject` function comes into play. The `.catch()` callback will be called not only if the `reject` function is called, but if _any_ of the `.then()` callbacks throw an error.

{{< highlight js "linenos=table, linenostart=1" >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        reject('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message); // this will not get called
}).catch(function(err) {
    console.log('error:', err); // this will log "error: hello world"
});
{{< /highlight >}}

One last note on `.then()` methods, and this may be somewhat confusing: it actually takes two parameters. The first is the callback for when the `Promise` is fulfilled, and the second being for when the `Promise` is rejected.

The above code could just as well be written:

{{< highlight js "linenos=table, linenostart=1" >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        reject('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message); // this will not get called
}, function(err) {
    console.log('error:', err); // this will log "error: hello world"
});
{{< /highlight >}}

Note that we're passing two callbacks into the `.then()`. What distinguishes this from using a `.catch()` is that this form corresponds directly to a specific handler. This is useful if you need to handle the failure of one callback specifically.


## Promisifying {#promisifying}

Converting a function that uses callbacks into one that utilizes `Promise` objects is done in the following steps:

1.  Wrap the code that uses a callback in a new `Promise`
2.  In the success condition of your callback, pass whatever result you get into the `resolve` function, if applicable
3.  In the error condition of your callback, pass whatever failure you get into the `reject` function, if applicable

We can make our `getDataFromServer` function asynchronous by wrapping it in a `Promise` as described:

{{< highlight js "linenos=table, linenostart=1" >}}
function getDataFromServerAsync(data) {
    return new Promise(function(resolve, reject) {
        getDataFromServer(data, function(result, error) {
            // we'll assume that if error !== null,
            // something went wrong
            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        });
    });
}
{{< /highlight >}}

This allows us to chain the `Promise` returned.

{{< highlight js "linenos=table, linenostart=1" >}}
getDataFromServerAsync(data)
    .then(function(result) {
        return getDataFromServerAsync(result);
    }).then(function(result) {
        // do something with the result of the second query
    })
    .catch(function(error) {
        // do something with any rejected call
    });
{{< /highlight >}}

And this is the ultimate benefit of Promises: rather than getting lost in callback after callback, we can simply chain a series of functions together.

There is one noticeable problem with all that we've gone over, however. Despite the more logical structuring that is delivered by a `Promise`, having code that deals with values not directly inside the callback scope is still an issue.

For example, I've seen newcomers to `Promise` write code similar to the following:

{{< highlight js "linenos=table, linenostart=1" >}}
let resultVal;

new Promise(function(resolve) {
    setTimeout(function() {
        resolve('foo');
    }, 1);
}).then(function(val) {
    resultVal = val;
});

console.log('resultVal', resultVal);      (1)
{{< /highlight >}}

If you run this code, `resultVal` will print `undefined`. This is because the `console.log` statement actually gets run before the code in the `.then()` callback. This _may_ be desirable if you know `resultVal` wouldn't be used after some time, but it leaves your program in (what I would consider) an invalid state: your code is waiting on something to be set that it has no direct control over.

There are ways around this, but there's no easy, simple, or sure-fire way around it. Usually you just end up putting more code in the `.then()` callbacks and mutate some kind of state.

The most straightforward way around this, however, is to use a new feature...


## `async` / `await` {#enter-async-await}

A few years ago the latest JavaScript standards added `async` and `await` keywords. Now that we know how to use Promises, we can explore these keywords further.

`async` is a keyword used to designate a function that returns a `Promise`.

Consider a simple function:

{{< highlight js "linenos=table, linenostart=1" >}}
function foo() {
    // note that there exists a function called `Promise.resolve`
    // which, when used, is equivalent to the following code
    return new Promise(function(resolve) {
        resolve('hello world');
    });
}
{{< /highlight >}}

All this function does is just return `'hello world'` in a Promise.[^fn:2]

The equivalent code using `async` is:

{{< highlight js "linenos=table, linenostart=1" >}}
async function foo() {
    return 'hello world';
}
{{< /highlight >}}

You can then think of `async` as syntactic sugar that rewrites your function such that it returns a new `Promise`.

The `await` keyword is a little different though, and it's where the magic happens. A few examples ago we saw how if we tried logging `resultVal` it would be `undefined` because logging it would happen before the value was set. `await` lets you get around that.

If we have a function that uses our `getDataFromServerAsync` function above, we can use it in an `async` function as such:

{{< highlight js "linenos=table, linenostart=1" >}}
async function doSomething() {
    const data = await getDataFromServerAsync();
    console.log('data', data);
}
{{< /highlight >}}

`data` will be set to whatever `getDataFromServerAsync` passes to the `resolve` function.

On top of that, `await` will block, and the following `console.log` won't be executed until `getDataFromServerAsync` is done.

But what if `getDataFromServerAsync` is rejected? It will throw an exception! We can, of course, handle this in a `try/catch` block:

{{< highlight js "linenos=table, linenostart=1" >}}
async function doSomething() {
    try {
        const data = await rejectMe();
        console.log('data', data);
    } catch(e) {
        console.error('error thrown!', e); // => 'error thrown! rejected!' will print
    }
}

function rejectMe() {
    return new Promise(function(resolve, reject) {
        reject('rejected!');
    });
}

doSomething();
{{< /highlight >}}

At this point you may find yourself thinking "Wow! This `async` stuff is great! Why would I ever want to write Promises again?" As I said it's important to know that `async` and `await` are just syntactic sugar for Promises, and the `Promise` object has methods on it that can let you get more out of your `async` code, such as [`Promise.all`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global%5FObjects/Promise/all), which allows you to wait for an array of Promises to complete.


## Conclusion {#conclusion}

Promises are an important part of the JavaScript ecosystem. If you use libraries from NPM that do any kind of callouts to server, the odds are the API calls will return `Promise` objects (if it was written recently).

Even though the new versions of JavaScript provide keywords that allow you to get around writing Promises directly in simple cases, it's hopefully obvious by now that knowing how they work under the hood is still important!

If you still feel confused about Promises after reading all this, I strongly recommend trying to write code that uses Promises. Experiment and see what you can do with them. Try using [fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch%5FAPI/Using%5FFetch), for example, to get data from APIs. It's something that may take some time to get down!

---

I'm a software developer based in Cleveland, OH and I'm trying to start writing more! Follow me on [dev.to](https://dev.to/rfaulhaber), [GitHub](https://github.com/rfaulhaber), and [Twitter](https://twitter.com/ryan%5Ffaulhaber)!

This article was written using [Org Mode](https://orgmode.org) for Emacs. If you would like the Org mode version of this article, see my [writings repo](https://github.com/rfaulhaber/writings), where the .org file will be published!


## Further reading {#further-reading}

-   [Promises on MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global%5FObjects/Promise)
-   [Async/Await on MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async%5Ffunction)


## Footnote {#footnotes}

[^fn:1]: A brief explanation of named and anonymous functions: 
{{< highlight js "linenostart=1" >}}
// named, function declaration
function foo() {}

// named function expression
// this is "named" because of "function bar()",
// not because we're assigning it to a variable named "foo"
// doing this is optional and may make reading stack
// traces or writing a recursive function easier
const foo = function bar() {};

// the right hand side of this assignment is an
// anonymous function expression
const foo = function() {};

// arrow function, nearly equivalent to form above.
// arrow functions are always anonymous
const foo = () => {};
{{< /highlight >}}
[^fn:2]: This function's body can also be written as: `return Promise.resolve('hello world');`
