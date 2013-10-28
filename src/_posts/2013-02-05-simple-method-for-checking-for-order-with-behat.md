---
layout: post
title: "Simple Method for Checking for Order with Behat"
date: 2013-02-05 10:06
category: test driven development
tags:  [behat, behavior driven development, bdd, tdd, context function]
---
Today I'd like to share with you a little context function I wrote that is helpful for checking for the order of specific elements in your automated UI tests. Let's start with the business requirement:

    In order to quickly find an employee to distract
    As a manager
    I need to see a list of employees in alphabetical order

This one is pretty simple, just list out employees in alphabetical order. A simple way to lightly verify this with an automated test would be to check that one name proceeds the other. Using the built in browser automation context functions in the [Mink](http://mink.behat.org/) library we can construct a simple scenario:

    Scenario: Workers are in the correct order
        Given I am on "/employees"
        Then I should see "Badworker, John"
        And I should see "Goodworker, Jane"
        And "Badworker, John" should precede "Goodworker, Jane"

This pretty much gets the point across, however, the key here is how do we determine that one arbitrary string "precedes" another in a list or table or whatever. My suggestion is that we use a css query to extract a list of elements containing the strings in question. For example, if the employees were in a table of some sort:

<table class="in-post">
<thead><tr><th>Name</th><th>Status</th></tr></thead>
<tbody>
<tr><td>Badworker, John</td><td>Dismal</td></tr>
<tr><td>Goodworker, Jane</td><td>Pleasant</td></tr>
</tbody>
</table>


Then we could use a css query to extract the text from the first cell of each row, modifying our original scenario like so:

    Scenario: Workers are in the correct order
        Given I am on "/employees"
        Then I should see "Badworker, John"
        And I should see "Goodworker, Jane"
        And "Badworker, John" should precede "Goodworker, Jane" for the query "table.employees tr td:first-child"

The query here `table.results-table tr td:first-child` simply selects the `td` element that is the first child of the `tr` tag in the table with the class `employees`. Because the headings are specified with the `th` tag, we ignore them. Now you have a generic requirement description that can be used to check precedence for strings found by any arbitrary css query, be it lists, headings, or custom classes.

##Implementing the Context
Of course the key to tying this all together is to implement a context function that will determine the precedence. One implementation of the the context is as follows:

```php
<?php
    /**
     * @Then /^"([^"]*)" should precede "([^"]*)" for the query "([^"]*)"$/
     */
    public function shouldPrecedeForTheQuery($textBefore, $textAfter, $cssQuery)
    {
        $items = array_map(
            function ($element) {
                return $element->getText();
            },
            $this->getPage()->findAll('css', $cssQuery)
        );
        assertGreaterThan(
            array_search($textBefore, $items),
            array_search($textAfter, $items),
            "$textBefore does not proceed $textAfter"
        );
    }
```

I wanted to avoid a `foreach` loop so this function simply gathers all the elements found by the css query, and then maps an anonymous function that returns the text from the element onto the found elements.

At this point you can simply use the array index to check precedence, in this case we depend on the PHPUnit `assertGreaterThan` function to check that the index value of the `$textAfter` is greater than that for the `$textBefore`.

You may also be able to implement an extended implementation that checks the list for correct order, but this is a simple solution that will help you check for the correct order for strings in your application using Behat!
