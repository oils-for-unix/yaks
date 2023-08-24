Yaks IR for Oils mycpp
===

## Top Level

- modules: import   (Import ?)
- func   
- class  (Class Fn Init Destroy)
  - including methods, inheritance
  - constructor and destructor for context manager

## Within a function

- var set
  - not def?  Because (set [a i] 0) is different and useful
  - I guess Yaks TAPL can use def
- scope  : with - for scope { }
- looping: for, while
- cond   : if switch (tagswitch)
- errors : try catch throw

## Infix Expressions?

I think these are the interesting ones:

- `(myfunc obj.field)`
- `(obj.method arg1 arg2)`
- Probably `(+ 1 2)` is OK -- this is a rough IR
  - Also I wonder about formatting
    - that could be `\()` or something?  But sometimes you want dynamic
      formats?  So printf can be OK

## Data Types
 
- `Bool Int Float Str`
- `(List T) (Dict K V)`

Basically I want to make an interpreter with the same semantics as mycpp We
already have that -- it's Python

But this is a static interpreter I guess

## TYPY - Subset of TypeScript and MyPy semantics?

### Issues

- TypeScript doesn't have 'with'
  - but it has classes -- does it have destructors?

- mylib has some shims, like mylib.iteritems()
  - well to be honest, this is what I want to clean up
  - the IR I guess decouples that from Python

- mylib.tagswitch papers over Python's lack of switch
  - well Python 3 has match, we could do it

### String Semantics: Python 2 vs. Python 3 vs. JavaScript

- `s[1]` in JavaScript will give the UTF-16 code unit `\u03bc`
- slice() works in 16-bit units as well

Can we simulate this on UTF-8 strings?

- In Python, our API is s[0] and s[1:2]

Ideas:

- `s.width2At() s.width2Slice()` in C++
- `s.width4At() s.width4Slice()`

- `s.index_(1, UTF_16)  s.index_(1, UTF_32)` -- this is Python I think?
  - this is different because of surrogate pairs -- those can't be represented
    at all, but I think it's good
  - JS strings can represent invalid UTF-16 strings (single surrogates)
  - Byte strings can represent invalid UTF-8
  - the intersection of them is VALID strings
  - So I guess you have to handle the issue when CREATING strings, at decode time
    - But the mycpp runtime does control that
    - Oh yeah this is what WTF-8 is for?
    - It's an INTERNAL representation only
- `s.slice(3, 5, UTF_16)  s.index_(3, 5, UTF_32)` -- this is Python I think?

Default is byte indexing.

The representation is always

### Number Semantics

- JavaScript has BigInteger, but TypeScript only has `number`
- How to get `Int` for loop indices then?
  - rely on some kind of inference?
- Yeah this is an issue, TypeScript doesn't have the distinction

You could have a flag

- make number -> float
- make number -> int

OK that's probably OK.

### Dict/Map Ordering

- Python 3 dicts

- neither JS objects or Python 2 dicts are ordddictorder

### Dict keys

- `Map<int, V>` would be necessary in TypeScript


## Notes on Integrating with Oils

Key questions

- Do you type check the Python AST created with ast.parse() ?
- Or do you serialize to YIR, and then type check that?

There's also no reason to involve TypeScript, other than to test the YIR design

Choices:

- Parallel parse -> Pickle -> Typecheck AST directly
- Parallel parse + YIR transform -> Text format -> Typecheck YIR
  - does YIR preserve everything you need for error messages?

Problem: generating/parsing text format slower than pickle in Python?  Can test
that out

In the name of minimalism, you can just use pickle.  Let's test that now.

---

I think for Oils itself, YIR is overly general.  There's no reason to involve
another toolchain, unless you actually want to change the metalanguage to
TypeScript or Oils itself.

It really should be 3 languages:

(Typed Python subset, TypeScript subset, Tea a YSH dialect) -> YIR
  -> mycpp runtime, or WebAssembly, etc.

But that is crazy, and will slow things down.  It's a separate project (that's
why this isn't in the Oils repo)

### Question

- Does the type checker and code generator themselves need to be translated to C++?
- Or do they just need to be type safe with MyPy?
  - match() expressions and so forth

- The key problem is that the ast.parse() call can't be translated to C+

Crazy idea:

- Maybe you can use our Packle subset?  But that's also dynamically typed

## What does YIR abstract over?

- C++ headers, forward declarations
- Global constants
  - `(comptime gFoo "foo")` becomes GLOBAL_STR(gFoo, "foo");

