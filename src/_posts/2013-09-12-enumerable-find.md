---
layout: post
title: "Quick Tip: Raising an Exception with Ruby's Enumerable Find"
date: 2013-09-12 11:54
comments: true
categories: [quick-tips, ruby]
twitter: [ruby, enumerable, coding]
---
I struggled with this a little today and thought it be worth a tip. Perhaps I was just trying to pound a square peg into a round hole, but eventually I got it and learned a little more about the Ruby language in the process.

##A Verbose Way
My goal was simple, I want to find something in an array of objects, and if it is not found raise an exception. This makes sense for the [Repository Pattern](http://martinfowler.com/eaaCatalog/repository.html) in a "load" context, where something *should* be found, and if it is not found, then there is a problem. Here is the simplified, original code:

{% codeblock lang:ruby %}
all_objects.each do |obj|
  if obj.property == argument
    return obj
  end
end
raise ArgumentError, "Obj for argument \"#{argument}\" not found."
{% endcodeblock %}

I think this could be more compact and a little cleaner, especially since Ruby provides the [`find` ](http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-find) method to those classes that include the [Enumerable](http://ruby-doc.org/core-1.9.3/Enumerable.html) module, such as `Array` in this case.

##Slightly Confusing Documentation
However I was slightly confused by the documentation:


> find(ifnone = nil) {| obj | block } → obj or nil click to toggle source

> find(ifnone = nil) → an_enumerator

> Passes each entry in enum to block. Returns the first for which block is not false. **If no object matches, calls ifnone and returns its result** when it is specified, or returns nil otherwise.

> If no block is given, an enumerator is returned instead.


The bold above is mine, as this is the part that confused me. It is not just a matter of doing this:

{% codeblock lang:ruby %}
all_objects.find(raise ArgumentError, "Obj for argument \"#{argument}\" not found.") do |obj|
  obj.property == argument
end
{% endcodeblock %}

If fact, doing the above just causes the exception to be raised as the procedure is executed, which is not what we want.

##Lambda (Duh)
What I needed here was an anonymous function. Of course. But being rather new to Ruby it didn't immediately occur to me. We can use the new-fangled lambda syntax: `-> { … }` and wrap the exception raising in an anonymous function to be called "if no object matches." The correct, final code looks like:

{% codeblock lang:ruby %}
all_objects.find(-> { raise ArgumentError, "Obj for argument \"#{argument}\" not found." }) do |obj|
  obj.property == argument
end
{% endcodeblock %}

Now how clean and simple is that?
