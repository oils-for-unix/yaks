Yaks
====

A language that's like our use of Python and mycpp:

- Dynamic semantics, and an interpreter with REPL
- If it's 100% statically typed, then it can be compiled to fast C++, on our runtime
  - Not sure if we want gradual typing, you might be forced to go from leaves
- Extra
  - Dynamic semantics produce either JSON, or ASDL-like "pickles" (squeeze and freeze?)
  - These can be frozen into a C++ binary as static data (zero runtime cost)
  - So it's like a comptime

## Slogans

- Yaks: A Tiny Typed Language From Scratch, With All the Bells and Whistles
  - For Yaks-TAPL

- Yaks: A Tiny Statically Typed Language, with Comptime
  - Yaks-Mandelbrot

- Yaks: A Statically Typed Language Implemented in Itself
  - Yaks-Bootstrapped

- Yaks: A Flexible Statically Typed Language You Can Write Like Python or
  JavaScript (or Lisp)
  - Yaks IR / Yaks mycpp / Yaks Oils

## Why work on this?

- To learn to write type checking algorithms
  - See lang-table.md -- there are surprisingly few static langauges
    implemented in static languages.

- To experiment with something like Zig's comptime, C++ constexpr/consteval
  - Should replace a lot of code gen in Oils?
  - This requires an **interpreter** for a static language, which is
    interesting

- To experiment with mixing dynamic and static styles --
  - Python/mycpp pair 
  - JavaScript/TypeScript pair -- matklad noted the visitor issue is more dynamic
  - Similar pie in the sky wishes: 
    - "TypeScript as fast as Rust" - https://news.ycombinator.com/item?id=30947680
    - Wants a hybrid of level 2 (Java Go) and level 3 (MyPy TypeScript), giving
      "RustScript"
      https://gist.github.com/xixixao/8e363dbd3663b6729cd5b6d74dbbf9d4
      - well mycpp is compiled, so it's more like Java/Go.  And it's also
        interpreted, all the way up to level 4.
    - I think these ideas aren't fleshed out in terms of interop and semantics
      -- they're very concerned with syntax -- but it seems like the desire is
      real
    - "The best part is that all three languages share pretty much the same syntax, and they are built so that calling from higher level to lower level variant is effortless. This gives us the ability to use the rich Rust ecosystem from a level 2/3 or even level 4 language."
      - there is a problem with mixed stacks, and composition
    - This is hinting at the "language cacophony" problem

- To experiment with unifying typed Python and JavaScript
    - Static TypeScript - https://news.ycombinator.com/item?id=20873693
    - lots of good feedback here

- Problem statement from Jamie Brandon:
  - REPL'd and fast Go/Swift/Rust/C++/Zig, i.e. language with value types and memory control
  - https://news.ycombinator.com/item?id=37267822

- Experiment with VALUE TYPES
  - Neither Python nor JS source code has a way of representing that!
  - C#, a GC language, also seems a bit weird -- it has 'struct'
    - wouldn't it make sense to have pointers and values?  Not struct and
      class?  This seems non-orthogonal

- Text format for parsed languages is kind of interesting
  - it has full location info
  - implement it in a statically typed language
  - similar to WASM text format
    - though I wonder if "\n" style escaping is a limitation or not

- LATER: experiment with module systems
  - that's the main thing bad with mycpp
    - fix the problems with default arguments in headers
    - with inheritance across modules
    - with hard-coded ordering
  - Each directory is a module, and compiles to a single C++ translation unit and header
  - dependencies are enforced to be acyclic

Lower Priority

- Experiment with unified Linter/formatter/translator
  - and syntax highlighter?

### Questions

- What's the smallest statically typed language implemented in itself?
  - must have a type checker
  - C4 is close, but it's dynamically typed, with just char and int.

## Four Dialects of Yaks?

- Yaks TAPL -- the arithmetic language 
  - forms: if, unary and binary ops
  - types: Bool, Int
  - Do we also want the compiler here? 

- Yaks Comptime WASM ?  (or Yaks C, to be traditional)
  - forms: fn, apply, var, set, do -- also if is IMPERATIVE
  - types: Bool, Num, Vec/Array
  - Key point: it's NOT homoniconic
    - so no macros
    - no recursion / tail style!
    - doseq?

- Yaks Bootstrapped
  - what does it take to write it in itself?
  - You need sum and product types I think
  - what do we do about the REGEX?
    - write our own little Pike inspired regex interpreter?
    - he parsed the regex and interpreted it at the same time though
    - we need char classes

- Yaks IR for Oils/mycpp
  - AN IR for compiling to C++
  - Why?  Because we want the mycpp to stand on its own a bit.
  - We want some notion of correctness, not just generating textual C++
  - See [IR.md][IR.md]

These are all IMPERATIVE langauges.  They are not Lispy; they are not
homoiconic!

We just use the Lisp syntax since it's simple to parse.

- Later: Yaks Dynamic?
  - rewrite dynamic semantics for Yaks in Yaks?

- what about Shak: a Lisp with SON -- Shak Object Notation
  - a shell?
  - MACROS for Shak
    - ASDL generating Yaks type definitions
    - well does comptime change that?  You can generate types on the fly?
    - what about the lexer?
      - would you write a mini re2c?

## Four Syntaxes for Yaks IR?

- Typed Python (mycpp)
- TypeScript subset -- stretch goal, but I like the Union types.  I wonder if
  they can become Zephyr ASDL -> C++.
- The Clojure- and WASM-inspired s-expression format can be typed directly
- Tea -- a language woven into Oils / YSH

### ASDL Implemented with macros?

- Enum Data - desguaring to classes
  - are these macros that generate (Class)  or (def x Class) ?
  - would make sense
  - And this is where you need quoting like \\()

- or are these constexpr?

- Honestly I think textual code generation has some benefits -- you can read
  the code
  - well you can read the Yaks IR - these can be separate Unix-processes, or
    they can communicate YON to avoid lexing and parsing
  just like you can read

- Infix

## Differences from Lisp

- We have the 'transform' stage
  - it does special forms, at PARSE time, not runtime

  - but does this make sense?
    - `((fn [x] (+ x 1)) 42)` is the issue
    - you eval the first one

- TODO: rename parse to read?   I like parse though because it's creating
  recursive structure.  That's different than reading.
  - Also Lisp has a bunch of syntax!

## Type Checker and Compiler for Yaks, in Yaks

This makes sense!

Port your damn type checker

Well then you need a dict type, but that's OK

    (set [d "key"] 42)
    (set [d name] 42)   # place is []

    (defn check [
      (, expr Expr)
      (, types (Dict Expr Type))
      (, errors (List Error))
      (-> (or Type null))
    ] 
      (def ok true)
      (def [result (or Type null)] null)

      (switch [expr.tag]  # reader macro (. expr tag)
        (case 'Name'
          (throw ShouldNotGetHere))

        (case (list 'Bool' 'Name')
          (throw ShouldNotGetHere))
    )

And then statically type it

You need Dict and switch

This is what I was doing with Python
  - turn Python into mycpp/Tea, by implementing a type checker in Python (MyPy)
  - and then they typed MyPy

- serialize the CST
  - Bool | Int | Str | List ? 
    - `(+ a b 42)` gives you a `[Str, Name, Name, Num]` ?
      - does `("+" a b)` make sense?
        - Clojure says "cannot call + as a function"
      - does `('+ a b)` 
      - does `((quote +) a b)`  ?


## Comptime / Freezing

- Dynamic semantics can give you JSON-like data literals?  That you include in
  your SCRIPT!
- Static semantics give you structs and arrays, using C++ literals syntax?

## Example of Code that could work in both dynamic and static modes

Maybe all this can work?

I wrote it dynamically.  Seems like it can be static too.

Use of strings for tags everywhere is interesting.

```
function parseList(p: Parser, end_id: string): List {
  next(p); // eat (

  if (p.current.id !== 'name') {
    throw { message: 'Expected name after (', loc: p.pos };
  }
  let list: List = {
    tag: 'List',
    name: tokenValue(p.current),
    loc: p.pos,
    children: [],
  };
  next(p); // move past head

  while (p.current.id !== end_id) {
    list.children.push(parseNode(p));
  }
  next(p); // eat rparen / rbrack

  return list;
}
```

### Shak - Shell Written in Yaks

HTML literals for lexer modes?

    (echo <p>hello</p>)

This is annoying to type

---

Maybe shell style literals in braces:

    (defn foo [x]
      (if true
        (do
          { ls /tmp/$mydir | sort | wc -l > out }
          { PYTHONPATH=. ./foo.py }))
      (def x $( ls /tmp )))

Are those reader macros?  For { } and $() arguably

    (pipe
      (cmd (list ls /tmp/$mydir))
      (cmd (list sort))
      (cmd (list wc -l) (redir > out))  # redirs are prefix ops
    )
    (cmd (list ./foo.py) (env PYTHONPATH .))

Shorter:

    (cmd (env PYTHONPATH .) foo.py)
    (cmd (redir > out) echo hi)

Probably shares the lexer?  So you have string interpolation

    (echo "hello \(name)")

    (echo "hello \(fn yo)")

    (echo "hello \$(hostname)")

So I guess you wite a recursive descent parser

I guess reuse the dynamic semantics of Yak for this?  Interpreted, without type checking

This is the same as unifying mycpp and YSH -- Tea/Oils

