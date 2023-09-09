Brainstorming on Transformations
================

A list of "nanopass" transformations on the Yaks IR.  See [IR.md](ID.md).

Not all of  these will make sense.  It's just brainstorming.

## General

- Strip location info
  - or add it

## Oils Metalanguages

### re2c

- regex to state machine
  - would need `goto` in Yaks IR!
- Also push vs. pull
  - `--storable-state` flag
  - possibly useful for line-based syntax highlighters?  Although we only lex
    line by line now anyway

### ASDL 

The whole thing!

- data / enum -> `class`

### mycpp

- extract const string to top level values
  - `const_pass.py`

### C++ Can Be Considered a Metalanguage on top of C

- That's what template instantiations are.
- LLVM is kind of like C, and C++ is "macros" for that.

## Counter-argument: re2c, ASDL, mycpp, and C++ are Unix-y code generators!

We're **reusing** code via text.  Why rewrite it?

Well, here are things that are awkward:

- I don't like `with tagswitch` -- but it certainly works
  - and the `UP_node` casting pattern
- I don't like always having separate ASDL files and py files.  Sometimes a
  type is used locally.
  - but it certainly works
- I don't like the implicit membership algorithm
  - well it hasn't caused a problem recently ?
  - `def __init__` and `self` initialization certainly works

So yes this is a **valid** counter-argument.  Don't rewrite what's already been
written!

The only argument is to expose it to users, but I think `#distributed-shell` is
more interesting, important, and unique as a language.

## Decouple from C++ -- transform Oils to lower level C or WASM

- No exceptions
  - there is a 2020 paper on Hacker News about C++ exceptions for embedded
    systems
  - it's a straighforward rewrite the first param is an error, and then you
    check for it
    - seems expensive

- Decouple from monomorphization
  - `List<T*>` becomes `List<void*`> 
  - does the C++ compiler already do this?

- Context Managers -> explicit constructor and destructor calls 
  - this is what a C++ compiler does

### Runtime Changes

- Would need small string optimization in C
  - probably awkward to express

- Would need GC in C
  - probably awkward to express

Again this sounds like a bad idea.

### Rooting and GC

- We can decouple Oils from our specific GC algorithm, and mylib.MaybeCollect()

Though again, I think those are making solid engineering choices, and the only
reason for the decoupling would be WASM.

That is a fairly weak reason.

The first pass of WASM should be 

- making build system and codebase more modular
- factoring out I/O, e.g. `fork()` and `core/process`
- Build a new binary that doesn't depend on the OS
- Use native C++ -> WASM compiler.  Don't write your own!

This is a long way off, and doesn't have a concrete use case.








