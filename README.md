# AdequateErrors

Overcoming limitation of Rails model errors API:

* more expressive `where` query
* turn off message's attribute prefix.
* lazy evaluation of messages

## Introduction

Rails errors API is simple to use, but can be inadequate when coping with more complex requirements.

The existing API was originally a collection of message strings without much meta data, making it very restrictive. Though `details` hash was added later for storing meta information, many fundamental issues can not be fixed without altering the API and the architecture.

This gem redesigned the API, placing it in its own object, co-existing with existing Rails API. Thus nothing will break, allowing you to migrate the code one at a time.

## Quick start

To access the AdequateErrors object, call:

    model.errors.adequate

From this object, many convenience methods are provided, for example this would return an array of AdequateErrors::Error objects, which matches the where query.

    model.errors.adequate.where(attribute:'title', :type => :too_short, length: 5)

The following prints out each error's full message one by one:

    model.errors.adequate.each {|error| puts error.message }
    
The following returns an array of all message strings:

    model.errors.adequate.messages
    
For full documentation, please see http://www.rubydoc.info/github/lulalala/adequate_errors

## Key difference to Rails own errors API

Errors are stored as Ruby objects instead of message strings, this makes more fine-grained query possible.

Error messages are evaluated lazily, which means it can be rendered in a different locale at view rendering time.

The messages in the locale file are looked up in its own `adequate_errors` namespace, for example:

    en:
      adequate_errors:
        messages:
          invalid: "%{attribute} is invalid"

Note that each message by default has the `attribute` prefix. This allow easy removal of attribute prefix by overriding each message in the locale file. You no longer need to attach errors to `:base` for that purpose. This allows prefix to be changed per language.

Calls to Rails' API are synced to AdequateErrors object, but not the reverse.

## We want to hear your issues too

If you also have issues with exsting API, share it by filing that issue here.

We collect use cases in issues and analyze the problem in wiki (publicly editable):

[So come to our wiki, see what's going on, and join us!](https://github.com/lulalala/adequate_errors/wiki)

---

This repo was called Rails Error API Redesign Initiative.  
This is a fan project and is not affiliated to Rails Core team,  
but my wish is that one day this can be adapted into Rails too.
