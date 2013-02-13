Motivation
==========


Consistency
-----------

Ruby's API docs are wildly inconsistent, particularly with respect to the Ruby
core and standard library API docs.  Different snippets make varying assumptions
about the reader, increasing the barrier to comprehension.

**Goal:** an API reference that appears as if it were written by one person.


Completeness
------------

Ruby's current documentation is quite brief; a lot of behavior has to be
inferred or determined via experimentation.  As a side effect, many
implementation details become encoded as part of the public API due to the
assumptions that have been forced to be made about the behavior of various components.

**Goal:** the API reference should have coverage over each and every function in
the public interface of Ruby core and the standard library.

**Goal:** the API reference should summarize each method/class/module, _as well
as_ provide in depth coverage where possible with common patterns, gotchas, etc.


Centrality
----------

Ruby documentation is strewn throughout the web.  It is _extremely difficult_ to
know where to go to find coverage of core concepts.

Stack Overflow should _not_ be the canonical reference of Ruby.

**Goal:** the documentation should act as a central repository for all: core
language concepts (syntax, keywords, etc), guides for beginners, API reference,
etc.


Community
---------

Ruby's community is _freakin' fantastic_, but similar to above, it is strewn all
over the place.  Often, some of the best insights are found deep in the comments
of blog posts, etc.  It is also daunting to contribute to existing
documentation.

**Goal:** the documentation should have an _extremely low barrier_ to anyone who
wishes to contribute.

**Goal:** there should be a community aspect to the documentation (biggest
unknown - maybe something akin to php.net's commenting?)
