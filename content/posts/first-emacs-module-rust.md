+++
title = "Writing an Emacs module in Rust"
author = ["Ryan Faulhaber"]
date = 2020-08-14T14:30:00-04:00
tags = ["rust", "emacs", "experiment"]
draft = false
+++

Recently I learned that Emacs supports linking with dynamic modules, so I tried writing one in Rust.

<!--more-->

I'm a new Emacs user. I made the jump to Emacs from VSCode / IntelliJ / Vim back in March, and it's been a mind-blowing experience. I cannot sing Emacs's praise enough, it's a truly incredible piece of software.

I'm also a new Rust developer. I don't write Rust professionally but I made my way through the wonderful and informative [Rust book](https://doc.rust-lang.org/book/) and I fell head-over-heels for this language. I never thought of myself as having any interest in systems programming until I learned Rust, and Rust has allowed me to very easily bridge that gap.

So recently I learned that Emacs allows you to write dynamically-loaded modules written in C. In case you don't know, if you want to customize Emacs, you must write Emacs Lisp code. This is no different than if you want to customize VS Code and writing JavaScript or TypeScript, although Emacs Lisp is far more robust in terms of what it will allow you to customize. Not all Emacs Lisp code is written in Emacs Lisp, though. Some functions that have to interact with the system on a lower-level [are written in C](https://www.gnu.org/software/emacs/manual/html%5Fnode/eintr/Primitive-Functions.html#Primitive-Functions) but can be called like Emacs Lisp functions. Emacs also lets you write such functions yourself.

I would hardly consider myself an expert in the fields of C or systems programming, but I've always wanted a good excuse to mess around with rust-bindgen. I also realize there's already [Emacs bindings for Rust](https://github.com/ubolonton/emacs-module-rs), but for the sake of learning we'll ignore that for now.

Here's how I tried to write a module for Emacs in Rust.


## How it works {#how-it-works}

According to the [Emacs documentation](https://www.gnu.org/software/emacs/manual/html%5Fnode/elisp/Module-Initialization.html#Module-Initialization) on the matter, if we were writing C, writing an Emacs module requires the following steps:

1.  Include the `emacs-module.h` header file
2.  Specify `int plugin_is_GPL_compatible;` in your code
3.  Implement the `emacs_module_init` function, which Emacs will call upon loading our module

And that's pretty much it. But obviously we're dealing with Rust, so our plan of attack will instead be to generate bindings using [`rust-bindgen`](https://github.com/rust-lang/rust-bindgen) and implement our init function in Rust.


## Setup {#setup}

I started this like I begin all new Rust projects: by calling `cargo new --lib emacs-module-test`.

My Cargo.toml file was edited to contain the following:

{{< highlight toml "linenos=table, linenostart=1" >}}
[package]
name = "emacs-module-test"
version = "0.1.0"
authors = ["Ryan Faulhaber <faulhaberryan@gmail.com>"]
edition = "2018"
# let's make our code GPL-compatible!
license = "GPL-3.0-or-later"

[lib]
path = "src/lib.rs"

# we need to specify "cdylib" because our project has to output a shared object
# file
crate-type = ["cdylib"]

[dependencies]
# we'll need some help from libc to interact with C's types
libc = "0.2"

[build-dependencies]
# and of course we'll need bindgen
bindgen = "0.54.1"
{{< /highlight >}}

Next, we'll a build step, as per bindgen's instructions:

{{< highlight rust "linenos=table, linenostart=1" >}}
// build.rs
extern crate bindgen;

use std::env;
use std::path::PathBuf;

fn main() {
    let bindings = bindgen::Builder::default()
        // I just imported it straight from where it was on my computer.
        // If we were building a real module we might not want to do this!
        // Also if you're trying this on macOS this header file may not be
        // in this particular location
        .header("/usr/include/emacs-module.h")
        // We want to specify our own emacs_module_init function, so we won't
        // generate one in Rust automatically
        .blacklist_function("emacs_module_init")
        // Generate the bindings
        .generate()
        // Explode if something goes wrong
        .expect("Unable to generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}
{{< /highlight >}}

This is mostly lifted straight from `rust-bindgen`'s documentation.

Finally, we'll start the lib.rs file:

{{< highlight rust "linenos=table, linenostart=1" >}}
// lib.rs
// this is also borrowed from rust-bindgen. C code obviously has different
// stylistic conventions. For the sake of simplicity we'll write stylistically
// unconventional code
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

// this dumps the contents of bindings.rs into this file upon compilation
include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
{{< /highlight >}}

So far so good. The project should compile (`cargo build`) without issues. This would also be the time to drop [a copy of the GPL-3.0 license](https://www.gnu.org/licenses/gpl-3.0.en.html) into a file called LICENSE.


## Looking through `bindings.rs` {#looking-through-bindings-dot-rs}

Before we get started we should take a look at the bindings that `rust-bindgen` generated. The path will be something different for you, but to give you a sense of where to look, the path on my machine was: `target/debug/build/emacs-module-84a415ae9d763afd/out/bindings.rs`

There's a few types that we should make note of.


### `emacs_runtime` {#emacs-runtime}

In the code we'll be writing Emacs provides us with an instance of this struct that represents the Emacs runtime, so we don't have to worry about creating it (I would be interested in mocking it though...). The most important part of this struct is the `get_environment` member, which is a function pointer. As the signature implies it returns an instance of `emacs_env`, so let's check that out.


### `emacs_env` {#emacs-env}

Since I'm running Emacs 26 there are two version of this struct. I'm only concerned with `emacs_env_26`.

This is the more important struct, as a number of its members are function pointers to crucial functions we'll need to interact with Emacs. I won't go over them all now, but the ones that we'll be using are:

-   `make_function`, which creates the body of a function
-   `make_string`, which converts a string from C (Rust) into an `emacs_value`
-   `intern`, which allows us to create symbols in Emacs
-   `funcall`, which allows us to call Emacs functions and receive their return value


### `emacs_value` {#emacs-value}

This is a representation of a value in Emacs Lisp in C (Rust). It's not entirely clear to me how it works internally, but fortunately it doesn't really matter for what we're doing.


## Writing the module {#writing-the-module}

For the sake of simplicity, we'll write a dead simple module, one that's so simple we could write it in Emacs Lisp:

{{< highlight elisp "linenos=table, linenostart=1" >}}
(defun my-message-from-rust ()
  "Returns a message from Rust"
  "Hello Emacs, I'm from Rust")

(defun my-sum (&rest args)
  "Returns the sum of ARGS"
  (apply '+ args))

(provide 'my-rust-mod)
{{< /highlight >}}

Our module will provide two functions, `my-message-from-rust` and `my-sum`. The former simply returns a string literal, while the latter sums up all the values passed to it. That should be easy enough.

As I mentioned earlier, the documentation says that we'll have to implement a function called `emacs_module_init`. This is where our Rust code will define its functions.[^fn:1]

In Emacs, it's conventional to register your module with the list of features available to Emacs. The `provide` call tells Emacs that `'my-rust-mod` is now a feature within Emacs.

Let's at least set up the function first. Our `lib.rs` file should look like:

{{< highlight rust "linenos=table, linenostart=1" >}}
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

// you shouldn't have to put this at the top of your file, but I noticed that
// rust-analyer got a little confused on my computer when I put it after my code
include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

// we'll be using these later
use std::ffi::CString;
use std::os::raw;

#[no_mangle]
#[allow(non_upper_case_globals)]
// Rust doesn't allow uninitialized static values, and Emacs doesn't care what
// the value of this variable is, as long as it's there
pub static plugin_is_GPL_compatible: libc::c_int = 0;

// ordinarily the Rust compiler will mangle funciton names. we don't want to do
// that, since the C code won't know what code to call.
// we'll also want to use `unsafe` because we need access to raw pointers
#[no_mangle]
pub unsafe extern "C" fn emacs_module_init(ert: *mut emacs_runtime) -> libc::c_int {
    let env = (*ert)
        .get_environment
        // for simplicity's sake we'll be getting a lot of mileage out of
        // .expect()!
        .expect("cannot get environment from Emacs")
        // remember, these are function pointers we're dealing with!
        (ert);

    // to be used later
    let make_function = (*env).make_function.except("cannot get make_function!");

    todo!("Finish writing this function!")
}
{{< /highlight >}}

Now let's write some functions.


### `my-message-from-rust` {#my-message-from-rust}

First, the actual Rust code:

{{< highlight rust "linenos=table, linenostart=1" >}}
// no need to no-mangle it since it'll never be called by name
unsafe extern "C" fn message_from_rust(
    env: *mut emacs_env,
    nargs: isize,
    args: *mut emacs_value,
    data: *mut raw::c_void,
) -> emacs_value {
    // our actual message
    let s = "Hello Emacs! I'm from Rust!";
    // function pointer to make_string, provided by Emacs
    let make_string = (*env).make_string.unwrap();
    // converted to a CString
    let c_string = CString::new(s).unwrap();
    // grab the size in bytes, as needed by Emacs
    let len = c_string.as_bytes().len() as isize;
    // return the emacs_value returned by make_string
    make_string(env, c_string.as_ptr(), len)
}
{{< /highlight >}}

Now, let's return to our init function and add the following:

{{< highlight rust "linenos=table, linenostart=1" >}}
let my_message_func = make_function(
    // a reference to our Emacs environment, of course
    env,
    // min_arity argument
    0,
    // max_arity argument
    0,
    // our actual function
    Some(message_from_rust),
    // docstring, so users can check the documentation for this funciton in
    // Emacs
    CString::new("This will print a nice message from Rust code!")
        .unwrap()
        .as_ptr(),
    // data argument. we are not passing this function any additional data, so
    // we give it `null`
    std::ptr::null_mut(),
);
{{< /highlight >}}

What's important to note about what we're doing here is that we're creating a new function _value_. Functions in Emacs Lisp (and indeed any functional programming language I've ever heard of) are just values, like integers or strings. Much like our call to `make_string` earlier, we're just creating a new value on Emacs's terms. In fact it's probably more like creating an anonymous function. If this was the only code we wrote, our users would have no way of calling our code from within Emacs. We'll get to that later, though.


### `my-sum` {#my-sum}

This one is a bit more interesting because we want our function to accept an indefinite amount of arguments. The actual function code:

{{< highlight rust "linenos=table, linenostart=1" >}}
// again, no need to no-mangle
unsafe extern "C" fn my_sum(
    env: *mut emacs_env,
    nargs: isize,
    args: *mut emacs_value,
    data: *mut raw::c_void,
) -> emacs_value {
    // Emacs provides us with a way of grabbing an integer value out of an
    // emacs_value object
    let extract_integer = (*env)
        .extract_integer
        .expect("could not get extract_integer");

    let mut numbers = Vec::new();

    // Emacs is kind enough to tell us how many values were passed to our
    // function, so we don't really have to worry about whether or not the size
    // of `args` is the same as `nargs`
    for i in 0..nargs {
        // pointer arithmetic! how unsafe!
        numbers.push(extract_integer(env, *args.offset(i)));
    }

    // some good old Rust iterators
    let sum = numbers.iter().fold(0, |acc, n| acc + n);

    // again, we have to rely on Emacs to convert to the proper type
    let make_integer = (*env).make_integer.expect("could not get make_integer");

    make_integer(env, sum)
}
{{< /highlight >}}

And again, we have to register it with the system in a similar way to our other function.

{{< highlight rust "linenos=table, linenostart=1" >}}
let my_sum_func = make_function(
    env,
    0,
    // this is a special value provided to us by Emacs letting it know that we
    // want our fuction to accept an indefinite amount of arguments
    emacs_variadic_function as isize,
    Some(my_sum),
    CString::new("Sums a series of integers")
        .unwrap()
        .as_ptr(),
    std::ptr::null_mut(),
);
{{< /highlight >}}


### Finishing up module init {#finishing-up-module-init}

As I mentioned earlier, we have to associate our new function values to names in order to call them. At the moment they're sort of floating out in the ether with only memory addresses to reference them, and that's not particularly useful.

First, we need some symbols to associate to these functions. A symbol in Lisp is more or less just an identifier, but in order to create them they must first be _interned_. This is where we can use the `intern` function.

Let's add the following to our init function:

{{< highlight rust "linenos=table, linenostart=1" >}}
let intern = (*env).intern.expect("could not get intern");

// creates "my-message-from-rust symbol"
let my_message_sym = intern(env, CString::new("my-message-from-rust").unwrap().as_ptr());
// creates "my-sum"
let my_sum_sym = intern(env, CString::new("my-sum").unwrap().as_ptr());
{{< /highlight >}}

Next, we'll need to associate our functions with said symbols:

{{< highlight rust "linenos=table, linenostart=1" >}}
// intern will return a symbol if it's already defined.
// we're going to use `fset` to associate our functions to symbols
let fset = intern(env, CString::new("fset").unwrap().as_ptr());

// we also want to actually call fset, so we'll need funcall
let funcall = (*env).funcall.expect("could not get funcall");

// in Emacs Lisp this is like:
// (fset 'my-message-from-rust (lambda () ...))
funcall(env, fset, 2, [my_message_sym, my_message_func].as_mut_ptr());
funcall(env, fset, 2, [my_sum_sym, my_sum_func].as_mut_ptr());
{{< /highlight >}}

Finally, we'll want to provide our new feature:

{{< highlight rust "linenos=table, linenostart=1" >}}
let provide = intern(env, CString::new("provide").unwrap().as_ptr());
let feat_name = intern(env, CString::new("my-rust-mod").unwrap().as_ptr());
let provide_args = [feat_name].as_mut_ptr();

// equivalent of (provide 'my-rust-mod)
funcall(env, provide, 1, provide_args);

// and finally, we can return from this function!
0
{{< /highlight >}}


## Does it work? {#does-it-work}

Let's run a `cargo build` to make sure everything at least compiles.

Rust should give us a file called `libemacs_module.so` in `target/debug` (or `libemacs_module.dylib` if you're on macOS) assuming your project name is called `emacs_module`. There are a few ways of trying to run our code:

1.  Open Emacs, run `(module-load "path/to/your/libemacs_module.so")`, and running the functions yourself
2.  From the terminal, running:

    ```bash
       emacs -Q -l path/to/your/libemacs_module.so --batch --eval '(message "%s" (my-message-from-rust))'
    ```

Either way, the functions you defined in Rust should now be runnable from Emacs.


## Things I couldn't figure out {#things-i-couldn-t-figure-out}

This article was written based on my own experience and process of writing the example code I've walked you through. There's a few things, though, I don't understand about what I've done:

1.  If I compile this with `cargo build --release`, I suddenly get type errors from Emacs. I suspect it's a configuration error but as of the time of writing this I'm not sure what the issue is.
2.  I'm not sure how you'd write an interactive function, if at all.
3.  I'm not sure how you'd deal with more complex data types, like alists. How would you create them or manipulate them?
4.  There's quite a bit of verbose `CString` construction happening. I found that if I put that behind a function I suddenly get segfaults. I'm not sure why.
5.  Similarly, refactoring this code to make `intern` its own Rust function leads to segfaults.


## What's the point of all this? {#what-s-the-point-of-all-this}

If you've never used Emacs before and you've read this whole thing, you might realize that Emacs isn't exactly a _normal_ editor.[^fn:2] It's not every day we're compiling and linking code to our editor. But why would we want to do this? Here are two reasons I can think of:

1.  Performance. Emacs Lisp is often good enough (at least, in my experience) but for more significant computation it might not be a bad idea to offload that to Rust code.
2.  Further extensibility. Emacs is already very extensible, and Emacs has decades of history behind it. Emacs Lisp can do a lot language-wise, but it has its limits. Code written in Rust (or even C, of course) wouldn't have such limits.

In any event, I just think it's a pretty handy feature to have. Maybe in the future I'll be writing a more extensive dynamic module for Emacs![^fn:3]

If you want to see the code I wrote, you can check it out [here](https://github.com/rfaulhaber/emacs-module-test).

[^fn:1]: One thing that gets lost in understanding how interpreted languages work is that things like function definitions, blocks of code that seemingly don't _do_ anything until called, are also technically "run." Interpreted languages will evaluate your files from top to bottom, "doing" stuff as they interpret your code. Whether or not those functions get called is another question. In the above Emacs Lisp example, we're defining two functions, which, if that file were to be evaluated by the Emacs Lisp interpreter, would create two function definitions within the environment. It wouldn't _call_ them, but it would allow for them to be called later. This is why we're going to define our code within the init function.
[^fn:2]: Emacs's "normalcy" is relative, I think. The first draft of this article said: "How many editors do you know that have a full blown language interpreter built into them?" Though as I said that I realized I could think of at least two: VS Code and Atom, which, both running Chromium, have the V8 engine running them. If you've never used Emacs it's hard to describe the world of difference between how Emacs Lisp interacts with the editor and how a VS Code plugin interacts with the editor. Atom might be closer in terms of "hackability," but I still think Emacs simply cannot be beaten in this department. Having gotten to know Emacs as well as I have recently though it does feel like Emacs kind of anticipated Electron apps a little bit.
[^fn:3]: I'll be using [`emacs-module-rs`](https://github.com/ubolonton/emacs-module-rs) for that though!
