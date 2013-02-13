`BasicObject`
=============

INTRODUCED: 1.9

`BasicObject` is a blank class, and the root of all Ruby classes.  It implements
the absolute minimum functionality required for a Ruby object.

In most cases, you probably want to base your class off of [`Object`](../object)
(the implicit class used if you don't provide one to a
[`class`](../../language/keywords/class.md) definition).

However, `BasicObject` is quite useful when:

* You would like to create class hierarchies that are independent of Ruby's core
  hierarchy.

* You need to build a proxy object that must override as little as possible.

* Or any other case where you want to avoid polluting - or being polluted by -
  the methods provided by [`Object`](../object).


Implementation Notes
--------------------

WARNING:

  **Do not modify `BasicObject` directly!**

  Make sure that you are creating subclasses of `BasicObject` rather than
  opening the class.  `BasicObject` is used extensively in the core and
  libraries for the reasons outlined above.  Modifying it breaks that contract.

WARNING:

  `BasicObject` _does not_ include [`Kernel`](../kernel), which means that the
  object does not have access to common methods like
  [`puts`](../kernel/instance_methods/puts).  To work around this, you probably
  want to refer to them explicitly, such as: `::Kernel::puts "output"`.


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

Private Instance Methods
------------------------

* [`method_missing`](instance_methods/method_missing.md)
* [`singleton_method_added`](instance_methods/singleton_method_added.md)
* [`singleton_method_removed`](instance_methods/singleton_method_removed.md)
* [`singleton_method_undefined`](instance_methods/singleton_method_undefined.md)
