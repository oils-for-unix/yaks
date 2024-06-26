Yaks
====

## Slogans

Mashing up:

- Oils code representation: lexing/parsing/errors 
- TAPL Typed Airth / Bool Int Language (by way of matklad),
- Norvig's Lispy (syntax and evaluator)

## Docs

- [TODO.md](doc/TODO.md) - my working stuff
- [yaks.md](doc/yaks.md) - design
  - [data-types.md](doc/data-types.md) - `Bool Int` -> `Float Func` -> `Class`
  - [syntax.md](doc/syntax.md) - Ideas for Yaks syntax
  - [blog.md](doc/blog.md) - What I might want to put on the blog
- Blog
  - [lang-table.md](doc/lang-table.md) - Related Work
  - [notes.md](doc/notes.md) - Experiences with TypeScript etc.

## Notes on Stages

- Lexing: use regex for exhaustive reasoning.
  - Weird JavaScript API, "sticky bit"
- Reading: important to write out the grammar!
  - Added [] synonym for (), allowing Clojure-like sugar
- Why separate reading and parsing?
  - CPython has parser and transformer
    - homogeneous -> heterogeneous tree (untyped or "tagged" with dynamic type,
      to TYPED)
  - Matklad's type inference code operated on a heterogeneous
  - "Reader" will be useful for JSON

### List of Errors

- Lexing -- there are no errors - but BAD uses
- Reading -- matching `() []`, EOF, etc.
- Transforming -- `if` and `+` have right arity
- Inference / Type checking -- `+` has right args, etc.
- Runtime -- 1/0 divide by zero

## Naming Ideas

- Nerd: because I was nerd-sniped!
  - NON: Nerd Object Notation is s-expressions, maybe with a more C-like accent

- Yaks: Was also OK

- Tydy -- Dynamically typed, and statically typed
  - interpreted AND compiled
  - (taken by a current company)

- Shapes: Dyad, Knot, Coil

