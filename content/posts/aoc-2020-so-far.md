+++
title = "My Advent of Code 2020 So Far"
author = ["Ryan Faulhaber"]
date = 2020-12-13T14:53:00-05:00
tags = ["meta", "fp", "aoc2020"]
draft = false
+++

This is my first year participating in [Advent of Code](https://adventofcode.com/). I enjoy doing coding challenges but I'm not competitive about it, so I tend to use them as a learning opportunity. Like for most people, the end of the year is a time of reflection, and when I look back on what I wanted to do this year, I often found myself saying "that's a language I wish I knew better." So, I thought, what better way to turn that potential regret into an opportunity, and use Advent of Code to try out a bunch of languages!

What follows are some reflections on the languages I've used so far and what I've learned.


## Elixir {#elixir}

[I started off Advent of Code with Elixir](https://github.com/rfaulhaber/aoc-2020/blob/main/1/solution.exs) (please be kind, that's the first Elixir code I've ever written!). Elixir is a language that's getting a lot of attention as of late, and I figured I'd jump on the bandwagon. Elixir is one of the more interesting languages I've used. It feels, to me, like if Ruby were more functional instead of object-oriented.

My favorite part of Elixir so far was finally being able to get to use the pipeline operator, which [might be coming to JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Pipeline%5Foperator). It's a bit like piping in Unix:

{{< highlight elixir >}}
def inc(x)
    x + 1
end

def double(x)
    x * 2
end

# "normal" way
result = double(inc(inc(1))) # => 6

# with pipeline
res_with_pipes = 1 |> inc |> inc |> double # => 6
{{< /highlight >}}

I very much like the way Elixir thinks about things, and I'm excited to play around with it more as AoC goes on.


## Haskell {#haskell}

I came into AoC with some knowledge of Haskell, but I've learned quite a bit this time around. I can safely say that Haskell is probably the most fun language to write out of any of these, and I feel like there's always more to learn with Haskell. That said, I still feel like I don't know how to think in Haskell; I know how to think in functional JavaScript and I'm just translating that to Haskell.

Haskell has a lot of features which I like, including:

-   Automatic currying. Currying is a functional programming technique of taking a function with `n` parameters and turning it into `n` functions of 1 parameter, until all parameters have been specified. In JavaScript, a curried function might look like:

    {{< highlight js >}}
        const f = (x, y, z) => x + y + z;

        // given a curry function from lodash or ramda...
        const curriedF = curry(f); // creates a new curried function
        curriedF(1, 2, 3) // => 6
        curriedF(1, 2)(3) // => 6
        curriedF(1)(2, 3) // => 6
        // this is the most crucial line
        curriedF(1)(2)(3) // => 6
    {{< /highlight >}}

    The last example illustrates what's going on here: when you call `curriedF` with anything less than 3 arguments, it returns a function with those arguments fixed.

    Haskell does this automatically:

    {{< highlight haskell >}}
        f :: Int -> Int -> Int -> Int
        f a b c = a + b + c

        f 1 2 3 -- => 6
        -- define a new function, g
        g = f 1
        g 2 3 -- => 6

        -- ...and so on
    {{< /highlight >}}

    This is a very handy feature.

-   Functional composition as syntax. Functional composition is the creation of a new function from a series of other functions. It's similar to the pipline operator in Elixir, except the pipeline operator calls functions, while function composition is about the creation of new functions.

    The mathematical definition of functional composition, where `∘` (ring operator) denotes composition, is:

    {{< highlight nil >}}
        (f ∘ g ∘ h)(x) = h(g(f(x)))
    {{< /highlight >}}

    Note that what's happening is that `x` is first passed to `f`, and the result is passed to `g`, and the result of that is passed to `h`.

    In JavaScript, using Lodash or Ramda, you could write the following code:

    {{< highlight js >}}
        const upper = s => s.toUpperCase();
        const exclaim = s => `${s}!`;
        const reverse = s => s.split('').reverse().join('');

        // the equivalent of writing:
        // s => exclaim(upper(reverse(s)))
        const reverseExclaim = compose(exclaim, upper, reverse);
        console.log(reverseExclaim('foo')); // prints 'OOF!'
    {{< /highlight >}}

    Haskell has this built in:

    {{< highlight haskell >}}
        import Data.Char

        exclaim :: String -> String
        exclaim s = s ++ "!"

        -- as far as I know Haskell only has a 'toUpper' function for chars,
        -- so we can use automatic currying to create our own!
        upper :: String -> String
        upper = map toUpper

        reverseExclaim :: String -> String
        -- the dot operator when used like this is for functional composition
        reverseExclaim = exclaim . upper . reverse

        reverseExclaim "foo" -- => "OOF!"
    {{< /highlight >}}

I've gone on long enough, but I could go on even longer.

Suffice it to say that I've gained more experience with Haskell this AoC, and I've learned about new things such as the (apparently controversial) `$` operator, and I've used a couple of `do` blocks as well.

Haskell is fun because it really forces you to break your problem down into very small functions and then build up a solution out of those pieces. The two solutions I've done in Haskell have, for that reason, been extremely modular.


## Racket {#racket}

I've never written any Racket before but I really wanted to give it a try. My impression of it was that it's a very fully fleshed-out Scheme with strong language parsing abilities.

I'm not a Lisp expert but Lisp has become part of my life again after becoming a full-time Emacs user. Emacs Lisp, however, is extremely different than most other popular Lisps out there (except for maybe Common Lisp?) so in some ways I felt as though I was starting at zero with Racket.

[The solution I wrote with Racket](https://github.com/rfaulhaber/aoc-2020/blob/main/4/solution.rkt) ended up being very simple (albeit repetitive), but I think what I spent most of my lines of code on was string parsing, which was a little tedious. For fun I tried using Racket's `struct` feature, which worked well for what I was trying to do.

Given that Racket is a Scheme though some of the syntax (Scheme-specific or Racket-specific) was unusual to me. Let-bindings include square brackets, like so:

{{< highlight racket >}}
(let ([foo 123]
      [bar 456])
  (+ foo bar))
{{< /highlight >}}

And function definitions are a little different too:

{{< highlight racket >}}
; the fact that the function id is included with the parameters confused me at
; first. I'm used to Emacs Lisp, which does not do this
(define (my-add a b)
  (+ a b))
{{< /highlight >}}

I'll have to give Racket more chances, though. I feel as though I wasn't taking full advantage of it for my solution (the case with most of these solutions, honestly!).


## Clojure {#clojure}

Ah, Clojure. The Lisp to end all Lisps. I have played around with Clojure in the past but not as extensively as I have for Advent of Code.

I really like Clojure syntax. It's a clean break from other Lisps and it feels more readable to me. Clojure also takes advantage of keyword arguments, sometimes making s-expressions read more like HTML than a Lisp function call. Clojure also has a very extensive and searchable standard library, which helped me while trying to solve a problem.

[My Clojure solution](https://github.com/rfaulhaber/aoc-2020/blob/main/6/solution.clj) is pretty lackluster though. I call `map` everywhere and I feel like there's a more effective solution than what I have. Clojure will also be revisited over the course of my time with Advent of Code.


## Bonus: Emacs + NixOS for temporary dev environments {#bonus-emacs-plus-nixos-for-temporary-dev-environments}

I wrote all my solutions in Emacs (of course), but I did something I had never done before.

I use Doom Emacs, which comes with language configurations that you can enable or disable. Clojure, for example, comes with packages that enable syntax highlighting, a REPL, LSP, and so on.

I also use NixOS, which allows for users to create ad-hoc development environments using `nix-shell`. I didn't install Elixir's or Haskell's interpreters, for example, I just created Nix shells that contained those programs and ran my solutions in them.

But then I learned about a package called [nix-buffer](https://github.com/shlevy/nix-buffer), an Emacs package that simulates `nix-shell` inside of an Emacs buffer. This was a game changer! Rather than leave Emacs and run my solution in my terminal, nix-buffer allows me to take full advantage of the in-editor language features while not committing to fully installing them onto my system. I was able to evaluate my Haskell buffers as I wrote them, and `ghc` would be removed from my system with any subsequent calls to `nix-collect-garbage`.

It's been a very fun and educational Advent of Code so far. I'm a few days behind but I'm going to try to provide a solution to each problem at some point, and I hope to continue to learn more about these languages!
