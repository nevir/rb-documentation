Spec Layout
===========

[common/](common/)
------------------

Shared spec contexts are stored here.  Pay special attention to [global.rb](common/global.rb),
as it sets up additions for _every_ spec's context.

Any file placed in this directory will be loaded **prior** to Spork forking a
test process.  _Do not_ require any library code at load time!


[unit/](unit/)
--------------

Houses all the unit tests for the library, with a spec file per function.  Unit
tests are expected to pass full [mutation coverage](https://github.com/mbj/mutant).

To run mutation all tests, run `rake mutate`.  You can also pick a particular
constant or method to focus on:

    rake mutate Markdown::Base # Documentation::Markdown::Base (all methods)
    rake mutate .context_for   # Documentation.context_for
    rake mutate Context#root   # Documentation::Context#root


[integration/](integration/)
----------------------------

Renders [every fixture document](fixtures/) in each supported format, diffing
the output against the files in this directory.
