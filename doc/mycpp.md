Minimal Yaks, replacing mycpp
============

A small amount of work that's useful.

[transform.md](transform.md) is the most general thing, encompassing re2c ASDL
mycpp and C++.  But that's too much.


## Goal

- Make type checking fast - it takes >5 seconds now, would like it to be 1
  second
  - Make translation fast - Not sure exactly how long it takes, but it's
    obviously more than  5 seconds.
    - I think we should be able to do type checking AND translation of our 50K
      line codebase in less than 1 sec!
  - Make C++ compilation fast.  The `oils_for_unix.mycpp.cc` translation is too
    big to compile fast.

- Get rid of Oils -> MyPy dependency

- Make the metalanguage well-defined.  Improve experience for contributors
  - Although Python is a friendlier metalanguage than something we write
    ourselves!
  - One thing we can do with our own type checker for Python is change the
    casting rules!
    - get rid of `UP_node` pattern.  Yes!

### Sub-goals

- Make a well-defined interface to the mycpp runtime 
  - the data structures and garbage collector.
  - The build and module system!
  - The build system is probably most important, since we want a modular
    interpreter that builds fast

- Rewrite the messiness of mycpp
  - Define what the language is
  - Does it have globals?

- Get rid of "invariants not checked"
  - we don't mutate global dicts

### Small Demo

- Start with `mycpp/examples/foo.py`
  - translate to C++
- Create `lib/bar.yaks` - write it by hand
  - translate to C++
- Link them all together with the mycpp runtime

Later:

- `mycpp/examples/foo.py` -> `foo.yaks` with **location info**
  - And then on type errors, you can highlight the Python code
- And then translate a **directory** / module of `*.yaks`  files to a single
  C++ translation unit

## Tweaking Python syntax

Tools we use for Oils dev:

- Interpreter - python2
- Type Checker - old MyPy version
- Linter - `devtools/py2_lint.py` uses an old version of pyflakes
  - which uses `ast.parse()` under the hood
- Formatter - yapf

Suppose we wanted to add this syntax:

    var x: List[int] = []

Then we would would have to

- patch the interpreter to accept `var`, and `: List[int]`
- use that same AST for our OWN type checker ?
- print the code to normal Python 2, and run the linter?
  - preserve the line numbers

- formatter
  - hm this one is tough
  - but I don't really like yapf either
  - I guess we need a Python AST

### Yaks formatter?

- Can the IR support physical source code too?

- Not just logical?

- I think we would want
  - INDENT DEDENT tokens

- And then INSIGNIFICANT tokens -- Ignored_* in OilS
  - whitespace
    - an entire whitespace line, and intra-line too?
  - comment
  - line continuation

And I wonder if we could do a Yaks -> Yaks transformation, and then print it back?

It's just mutating whitespace tokens
