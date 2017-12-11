# AdequateErrors

Overcoming limitation of Rails model errors API:

* fine-grained `where` query
* object-oriented Error object
* turn off message's attribute prefix.
* lazy evaluation of messages

## Introduction

Rails errors API is simple to use, but can be inadequate when coping with more complex requirements.

Examples of how existing Rails API is limiting are listed here: http://lulalala.logdown.com/posts/2909828-adequate-errors

The existing API was originally a collection of message strings without much meta data, making it very restrictive. Though `details` hash was added later for storing meta information, many fundamental issues can not be fixed without altering the API and the architecture.

This gem redesigned the API, placing it in its own object, co-existing with existing Rails API. Thus nothing will break, allowing you to migrate the code one at a time.


## Quick start

To access the AdequateErrors, call:

    model.errors.adequate

From this `Errors` object, many convenience methods are provided:

Return an array of AdequateErrors::Error objects, matching a condition:

    model.errors.adequate.where(attribute:'title', :type => :too_short, length: 5)

Prints out each error's full message one by one:

    model.errors.adequate.each {|error| puts error.message }
    
Return an array of all message strings:

    model.errors.adequate.messages
    
## `Error` object

An `Error` object provides the following:

* `attribute` is the model attribute the error belongs to.
* `type` is the error type.
* `options` is a hash containing additional information such as `:count` or `:length`.
* `message` is the error message. It is full message by design.

## `where` query

Use `where` method to find errors matching different conditions. An array of Error objects are returned.

To find all errors of `title` attribute, pass it with `:attribute` key:

    model.errors.adequate.where(:attribute => :title)
    
You can also filter by error type using the `:type` key:

    model.errors.adequate.where(:type => :too_short)
    
Custom attributes passed can also be used to filter errors:

    model.errors.adequate.where(:attribute => :title, :type => :too_short, length: 5)
    
    
## `include?`

Same as Rails, provide the attribute name to see if that attribute has errors.

## `add`, `delete`

Same as built-in counterparts.

## Message and I18n

Error message strings reside under `adequate_errors` namespace. Unlike Rails, there is no global prefixing of attributes. Instead, `%{attribute}` is added into each error message when needed.

```yaml
en:
  adequate_errors:
    messages:
      invalid: "%{attribute} is invalid"
      inclusion: "%{attribute} is not included in the list"
      exclusion: "%{attribute} is reserved"
```

This allows omission of attribute prefix. You no longer need to attach errors to `:base` for that purpose.

Built-in Rails error types already have been prefixed out of the box, but error types from other gems have to be handled manually by copying entries to the  `adequate_errors` namespace and prefixing with attributes.

Error messages are evaluated lazily, which means it can be rendered in a different locale at view rendering time.


## `messages`

Returns an array of all messages.

    model.errors.adequate.messages

## `messages_for`

Returns an array of messages, filtered by conditions. Method argument is the same as `where`.

    model.errors.adequate.messages_for(:attribute => :title, :type => :too_short, length: 5)
    
## Full documentation

http://www.rubydoc.info/github/lulalala/adequate_errors

## Note

Calls to Rails' API are synced to AdequateErrors object, but not in reverse. Deprecated methods such as `[]=`, `get` and `set` are not sync'ed however.

The gem is developed from ActiveModel 5.1, but it should work with earlier versions.

## We want to hear your issues too

If you also have issues with exsting API, share it by filing that issue here.

We collect use cases in issues and analyze the problem in wiki (publicly editable):

[So come to our wiki, see what's going on, and join us!](https://github.com/lulalala/adequate_errors/wiki)

---

This repo was called Rails Error API Redesign Initiative.  
This is a fan project and is not affiliated to Rails Core team,  
but my wish is that one day this can be adapted into Rails too.
