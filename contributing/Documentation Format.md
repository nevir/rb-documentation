Documentation Format
====================

The documentation uses several extensions to
[the Markdown syntax](http://daringfireball.net/projects/markdown/syntax), and
has a relatively strict Markdown style.

TODO:

  We could really use a validator/linter that:

  * Ensures adherence to the Markdown style.

  * Checks for broken references.

  * Etc.


General Style
-------------

* We deviate from traditional markdown and use **two spaces** of indentation
  instead of four.

* Lines should wrap at 80 characters - not because it is the default terminal
  width, but because it helps readability.  Long links are an exception and are
  allowed to extend past the 80 character column.

* Use punctuation to complete sentences.

* If you are enumerating a set of options, prefer to use a (concise) bulleted
  list instead of enumerating in a paragraph of prose.  Helps the user scan the
  page.


Headers
-------

All headers...

* All headers should have one or two blank lines as margin above them (unless at
  the top of the file).

* All headers should have one blank line as margin below them.

* First- and second-level headers should follow the underlined (Setext) style.

* All other header levels should follow the hash (atx) style.

```markdown
First Level Header
==================

I'm expanding on the first point here.


Second Level Header
-------------------

The second point makes a good point, don't you think?

### Third Level Header

The third point expands even more!
```


File Header
-----------

Each file should start with a level one header, followed by a short paragraph
that describes it.  Availability tags (INTRODUCED:, DEPRECATED:) should precede
the description paragraph.

Depending on the type of doc file, the header text should follow a given format:

* Classes/Modules:   `` `ClassOrModule` ``
* Singleton Methods: `` `ClassOrModule.singleton_method` ``
* Instance Methods:  `` `ClassOrModule#instance_method` ``

```markdown
`BasicObject`
=============

INTRODUCED: 1.9

`BasicObject` is a blank class, and the root of all Ruby classes.  It implements
the absolute minimum functionality required for a Ruby object.

Extended description follows...
```

The headers and short description are explicitly parsed and used as metadata for
indexing and summarizing various portions of the documentation.


Section Outlines
----------------

Any `README.md` section labeled "Outline" is considered to be a special section.
Any lists of items that are pure links will be extracted, along with any sub
headings, as the outline for that particular directory.

This is used to group methods/classes/modules by area of responsibility.  They
are also extracted to provide navigation throughout the documentation.

A common pattern is to group instance and singleton methods for a class, and
further break them down by responsibility:

```markdown
`BasicObject`
=============

...


Outline
=======

Class Methods
-------------

* [`new`](class_methods/new.md)

Instance Methods
----------------

### Comparisons

* [`!`](instance_methods/negation_operator.md)
* [`!=`](instance_methods/inequality_operator.md)
* [`==`](instance_methods/equality_operator.md)
* [`equal?`](instance_methods/equality_operator.md)

### Object Metadata

* [`__id__`](instance_methods/reserved_id.md)

### Message Sending & Execution

* [`__send__`](instance_methods/reserved_send.md)
* [`instance_eval`](instance_methods/instance_eval.md)
* [`instance_exec`](instance_methods/instance_exec.md)
```


Annotations
-----------

We extend markdown with the concept of annotations, with a similar syntax to
that used by (the Rails guides)[http://guides.rubyonrails.org/]).

An annotation is an ALL_CAPS: label followed either by a short line of text, or
indented block of markdown.

Annotations are used depending on the context an situation.  The known
annotation types are:


### INTRODUCED:

Describes which Ruby or VM version a given doc file was introduced with.

```
INTRODUCED: 1.9, jruby 1.6.5
```


### DEPRECATED:

Describes which Ruby or VM version a given doc file was deprecated with.

```
DEPRECATED: 2.0
```


### ALIASES:

Indicates that the described method is also aliased to one or more other names.

```
ALIASES: `equal?`, `eql?`
```


### PARENT:

Indicates that the current class inherits from another class.

```
PARENT: [`Object`](../object)
```


### INCLUDES:

Similar to PARENT:, except this indicates which module the class explicitly
mixes in.

```
INCLUDES: [`Enumerable`](../enumerable), [`Enumerator`](../enumerator)
```


### WARNING:

Used to describe gotchas and other less obvious issues one may encounter when
dealing with the described piece of code.


### TODO:

A _documentation related_ todo.


References
----------

We try to reference related documents as frequently as possible.  References are
standard Markdown links, with a _relative_ path.

Relative links help generic Markdown tools to properly set up the links, as well
as navigation on GitHub.

TODO: The format should support smart links to symbols, etc.
