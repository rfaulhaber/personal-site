
# Table of Contents

1.  [First Class Functions in JavaScript](#first-class-functions-in-javascript)
2.  [(Re)-Introducing Callbacks](#re-introducing-callbacks)
3.  [Enter Promises](#enter-promises)
4.  [Promisifying](#promisifying)
5.  [`async` / `await`](#enter-async-await)
6.  [Conclusion](#conclusion)
7.  [Further reading](#further-reading)

Although the `async` and `await` keywords are now part of standard JavaScript, under the hood they ultimately use Promises. Here we&rsquo;ll explore what Promises are, why they&rsquo;re needed, and how you can &ldquo;promisify&rdquo; callbacks in JavaScript.

I find a lot of newcomers are often confused by terms like &ldquo;callbacks&rdquo;, &ldquo;Promises&rdquo;, and what exactly `async` and `await` do. I hope to clear that up with this article.

For the sake of clarity, this guide will use `function` syntax, and not arrow functions. If you know how to use arrow functions, you can replace much of this code with arrow functions and have it behave similarly. Also, some of these code samples are more verbose than they need to be. Methods like `Promise.resolve()` can cut down on boilerplate code.

<a id="first-class-functions-in-javascript"></a>

# First Class Functions in JavaScript

In JavaScript, functions can be used like any other variable. This makes them *first class*. For example:

{{< highlight js >}}
function callFunc(val, f) {
    return f(val);
}

// a simple function that adds 10 to any number
function add10(x) {
    return x + 10;
}

// here we're passing the `add10` function to another function
callFunc(3, add10); // => 13
{{</ highlight >}}

Note that in the above example, `callFunc` is calling the function we pass it and passing in a value itself. Here `f` could be replaced with any function.

In JavaScript functions can be **anonymous**, simply meaning that they aren&rsquo;t named<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup>.

You can pass an anonymous function to another function directly if you so choose. We can rewrite the call to `callFunc` using an anonymous function in the following way:

{{< highlight js >}}
callFunc(3, function(x) {
    return x.toString();
}); // => '3'
{{<

One interesting aspect of this feature is that it allows for a deferral of execution of sorts. The function we pass to `callFunc` doesn&rsquo;t actually get called until the function itself calls it.

<a id="re-introducing-callbacks"></a>

# (Re)-Introducing Callbacks

A **callback** is an extension of this concept. Some definitions of callbacks make them sound just like first class functions, but a more specific definition would be: a function that is invoked at the end of an asynchronous operation.

A classic example is with JavaScript&rsquo;s `setTimeout` function:

{{< highlight js >}}
setTimeout(function() {
    console.log('hello world!');
}, 2000);
{{<

In the above example, &ldquo;hello world!&rdquo; will get printed after two seconds. You can think of `setTimeout` as performing an operation, in this case, waiting for two seconds, and then calling the anonymous function after that time has passed. We don&rsquo;t have any control over what `setTimeout` is doing, but we know that it will wait for 2000 milliseconds, and are able to provide it a function to be executed once it&rsquo;s done (of course we expect `setTimeout` to do this). This is generally what callbacks are.

Callbacks developed as a pattern in JavaScript because they were an easy way to know when some asynchronous actions ended. Fetching data from a server, for example, usually involved writing a callback to handle that resulting data.

Although callbacks do get the job done, they do lead to very confusing code, and this is perhaps the biggest problem with them. Consider the following example. Suppose we have a function called `getDataFromServer` that takes some data necessary for a database query and a callback, to be executed upon the completion of that callout:

{{< highlight js >}}
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
{{<

It&rsquo;s possible to rewrite the above code using named functions but it doesn&rsquo;t make it much less confusing.

{{< highlight js >}}
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
{{<

This is referred to as &ldquo;callback hell&rdquo;, because, aside from *looking* like hell, it creates a maintenance issue: we&rsquo;re left with a bunch of callbacks that may be difficult to read and mentally parse through.

Neither of these examples consider variables that live outside the context of these functions. Code like this used to be quite commonplace. Maybe you need to update something on the DOM once you get the first query. Very confusing!

<a id="enter-promises"></a>

# Enter Promises

A `Promise` in some sense is a glorified callback. They allow you to transform code that utilize callbacks into something that appears more synchronous.

A `Promise` is just an object. In its most common usage it can be constructed as such:

{{< highlight js >}}
const myPromise = new Promise(executor);
{{<

`executor` is a function that takes two arguments provided by the `Promise` object, `resolve` and `reject`, which are each functions themselves. `executor` usually contains some asynchronous code and is evaluated as soon as the `Promise` is constructed.

A trivial example of a `Promise` can be seen with `setTimeout`

{{< highlight js >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        const message = 'hello world';
        console.log('message in promise: ', message);
        resolve(message);
    }, 2000);
});
{{<

This code is a little different than our original `setTimeout` code. In addition to printing &ldquo;hello world&rdquo; to the console, we&rsquo;re passing that string to the `resolve` function. If you run this code, `message in promise: hello world` gets printed to the console after two seconds.

At this point, it may not be clear why Promises are useful. So far we&rsquo;ve just added some more decorum around our callback code.

In order to make this code a little more useful, we&rsquo;ll invoke the Promise&rsquo;s `.then()` method:

{{< highlight js >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        resolve('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message);
});
{{<

By calling `.then()` we can actually use the value passed to `resolve`. `.then()` takes a function itself, and that function&rsquo;s arguments are whatever get passed into the `resolve` function. In the above code we&rsquo;re passing `'hello world'` and we can expect it to be passed to whatever function we give `.then()`.

It&rsquo;s important to note that `.then()` actually returns another `Promise`. This lets you chain `Promise` calls together. Whatever is returned in the function passed to a `.then()` is passed to the next `.then()`.

{{< highlight js >}}
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
{{<

There is an additional method, `.catch()`, which is used for error handling. This is where the `reject` function comes into play. The `.catch()` callback will be called not only if the `reject` function is called, but if *any* of the `.then()` callbacks throw an error.

{{< highlight js >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        reject('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message); // this will not get called
}).catch(function(err) {
    console.log('error:', err); // this will log "error: hello world"
});
{{<

One last note on `.then()` methods, and this may be somewhat confusing: it actually takes two parameters. The first is the callback for when the `Promise` is fulfilled, and the second being for when the `Promise` is rejected.

The above code could just as well be written:

{{< highlight js >}}
const myPromise = new Promise(function(resolve, reject) {
    setTimeout(function() {
        reject('hello world');
    }, 2000);
}).then(function(message) {
    console.log('message: ', message); // this will not get called
}, function(err) {
    console.log('error:', err); // this will log "error: hello world"
});
{{<

Note that we&rsquo;re passing two callbacks into the `.then()`. What distinguishes this from using a `.catch()` is that this form corresponds directly to a specific handler. This is useful if you need to handle the failure of one callback specifically.

<a id="promisifying"></a>

# Promisifying

Converting a function that uses callbacks into one that utilizes `Promise` objects is done in the following steps:

1.  Wrap the code that uses a callback in a new `Promise`
2.  In the success condition of your callback, pass whatever result you get into the `resolve` function, if applicable
3.  In the error condition of your callback, pass whatever failure you get into the `reject` function, if applicable

We can make our `getDataFromServer` function asynchronous by wrapping it in a `Promise` as described:

{{< highlight js >}}
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
{{<

This allows us to chain the `Promise` returned.

{{< highlight js >}}
getDataFromServerAsync(data)
    .then(function(result) {
        return getDataFromServerAsync(result);
    }).then(function(result) {
        // do something with the result of the second query
    })
    .catch(function(error) {
        // do something with any rejected call
    });
{{<

And this is the ultimate benefit of Promises: rather than getting lost in callback after callback, we can simply chain a series of functions together.

There is one noticeable problem with all that we&rsquo;ve gone over, however. Despite the more logical structuring that is delivered by a `Promise`, having code that deals with values not directly inside the callback scope is still an issue.

For example, I&rsquo;ve seen newcomers to `Promise` write code similar to the following:

{{< highlight js >}}
let resultVal;

new Promise(function(resolve) {
    setTimeout(function() {
        resolve('foo');
    }, 1);
}).then(function(val) {
    resultVal = val;
});

console.log('resultVal', resultVal);
{{<

If you run this code, `resultVal` will print `undefined`. This is because the `console.log` statement actually gets run before the code in the `.then()` callback. This *may* be desirable if you know `resultVal` wouldn&rsquo;t be used after some time, but it leaves your program in (what I would consider) an invalid state: your code is waiting on something to be set that it has no direct control over.

There are ways around this, but there&rsquo;s no easy, simple, or sure-fire way around it. Usually you just end up putting more code in the `.then()` callbacks and mutate some kind of state.

The most straightforward way around this, however, is to use a new feature&#x2026;

<a id="enter-async-await"></a>

# `async` / `await`

A few years ago the latest JavaScript standards added `async` and `await` keywords. Now that we know how to use Promises, we can explore these keywords further.

`async` is a keyword used to designate a function that returns a `Promise`.

Consider a simple function:

{{< highlight js >}}
function foo() {
    // note that there exists a function called `Promise.resolve`
    // which, when used, is equivalent to the following code
    return new Promise(function(resolve) {
        resolve('hello world');
    });
}
{{<

All this function does is just return `'hello world'` in a Promise.<sup><a id="fnr.2" class="footref" href="#fn.2">2</a></sup>

The equivalent code using `async` is:

{{< highlight js >}}
async function foo() {
    return 'hello world';
}
{{<

You can then think of `async` as syntactic sugar that rewrites your function such that it returns a new `Promise`.

The `await` keyword is a little different though, and it&rsquo;s where the magic happens. A few examples ago we saw how if we tried logging `resultVal` it would be `undefined` because logging it would happen before the value was set. `await` lets you get around that.

If we have a function that uses our `getDataFromServerAsync` function above, we can use it in an `async` function as such:

{{< highlight js >}}
async function doSomething() {
    const data = await getDataFromServerAsync();
    console.log('data', data);
}
{{<

`data` will be set to whatever `getDataFromServerAsync` passes to the `resolve` function.

On top of that, `await` will block, and the following `console.log` won&rsquo;t be executed until `getDataFromServerAsync` is done.

But what if `getDataFromServerAsync` is rejected? It will throw an exception! We can, of course, handle this in a `try/catch` block:

{{< highlight js >}}
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
{{<

At this point you may find yourself thinking &ldquo;Wow! This `async` stuff is great! Why would I ever want to write Promises again?&rdquo; As I said it&rsquo;s important to know that `async` and `await` are just syntactic sugar for Promises, and the `Promise` object has methods on it that can let you get more out of your `async` code, such as [`Promise.all`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all), which allows you to wait for an array of Promises to complete.


<a id="conclusion"></a>

# Conclusion

Promises are an important part of the JavaScript ecosystem. If you use libraries from NPM that do any kind of callouts to server, the odds are the API calls will return `Promise` objects (if it was written recently).

Even though the new versions of JavaScript provide keywords that allow you to get around writing Promises directly in simple cases, it&rsquo;s hopefully obvious by now that knowing how they work under the hood is still important!

If you still feel confused about Promises after reading all this, I strongly recommend trying to write code that uses Promises. Experiment and see what you can do with them. Try using [fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch), for example, to get data from APIs. It&rsquo;s something that may take some time to get down!

---

I&rsquo;m a software developer based in Cleveland, OH and I&rsquo;m trying to start writing more! Follow me on [dev.to](https://dev.to/rfaulhaber), [GitHub](https://github.com/rfaulhaber), and [Twitter](https://twitter.com/ryan_faulhaber)!

This article was written using [Org Mode](https://orgmode.org) for Emacs. If you would like the Org mode version of this article, see my [writings repo](https://github.com/rfaulhaber/writings), where the .org file will be published!


<a id="further-reading"></a>

# Further reading

-   [Promises on MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
-   [Async/Await on MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)


# Footnotes

<sup><a id="fn.1" href="#fnr.1">1</a></sup> A brief explanation of named and anonymous functions:

{{< highlight js >}}
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
{{<

<sup><a id="fn.2" href="#fnr.2">2</a></sup> This function&rsquo;s body can also be written as:
`return Promise.resolve('hello world');`
