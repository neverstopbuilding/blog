---
layout: post
title: "Use the Accept Header to Set Your Return Data with Zend Framework 2"
comments: true
date: 2013-02-18 11:05
category: web development
tags:  [zend framework 2, api, accept header, http headers, json]
---

In this article I detail the process by which you can set up your controller actions in Zend Framework 2 to return either the default HTML, or JSON data depending on the "Accept Header" in the request. It incorporates changes related to a security update added since [this very helpful article](http://akrabat.com/zend-framework-2/returning-json-using-the-accept-header-in-zf2/) was written, and expands on some of the intricacies of making your web layer objects better "json providers."

##Why do I care?
If you are using some of the [many javascript mvc frameworks](http://todomvc.com/) out there to make your front end shine, it is often necessary to scaffold your view, and then populate it with data asynchronously or change it depending on user interaction. You could do things like this:

    http://fromthesea.com/clams?json

    http://fromthesea.com/clams?format=json

    http://fromthesea.com/clams/json

    http://fromthesea.com/clams-json

To list all your clams, but I think that is kinda messy and may very well require some code duplication and extra actions. Why not leverage the request's accept header to determine which data to send back? Then you can use the same route, to return the correct view template, or a json representation of your data.

##Setting Up Zend Framework 2
To begin we need add a view strategy to our application model that will allow our controllers to return json. In an `*.ini` style configuration you can add this line to your module config file:

    [view_manager]
    strategies.json = "ViewJsonStrategy"

Or if you are using the the `module.config.php` then ensure your view manager array contains:

    'view_manager' => array(
        'strategies' => array(
            'ViewJsonStrategy'
        )
    )

Obviously there will likely be more settings in both cases, but they are omitted for simplicity.

##Preparing our Controller
As noted in [these release notes](http://www.readability.com/articles/ycfvxsho) we have to explicitly specify which types of data we want to return to the view. I'll list the full code of the controller action and then we can go over each area:

```php
<?php
public function clamsAction()
{
    $acceptCriteria = array(
    'Zend\View\Model\ViewModel' => array(
        'text/html',
    ),
    'Zend\View\Model\JsonModel' => array(
        'application/json',
    ));

    $viewModel = $this->acceptableViewModelSelector($acceptCriteria);

    Json::$useBuiltinEncoderDecoder = true;

    $clamList = $this->getClamList();

    return $viewModel->setVariables(array("clams" => $clamList));
}
```

- On line 4 we define which types of view models should be created depending on the accept header, so for an Accept header of `application/json` we will return a `JsonModel` but for a `text/html` Accept header then we return just the regular old `ViewModel`.

- On line 12 we pass the accept criteria to the controller plugin `acceptableViewModelSelector`.

- On line 14 we tell our application to use the Zend Framework json encoder, more on this later.

- Line 16 simple gets our fictitious web layer object, a `ClamList`.

- Finally on line 18 we add our properties to the view model and return it.

That is pretty much it, now when you browse to the `/clams` route you would see whatever view you have defined, let's assume it sets up some basic layouts and adds some javascript properties to view elements. When the javascript executes and accesses the same route, as long as it passes the correct accept header, it will return JSON data!

If you wanted to test this example (and you went to the trouble of mocking up this sample application) you could simply run a curl call:

    curl -H "Accept: application/json" http://fromthesea.com/clams

##Writing Serializable Web Layer Objects
You will notice that I simply threw the `$clamList` object right into the view model variables and was done with it. Here is where I'll explain why we decided to use the Zend Framework JSON encoder instead of the the default PHP one. The [`json_encode`](http://php.net/manual/en/function.json-encode.php) function will encode php objects to JSON, but only if their properties are public. In general it is not advisable to make an object's properties public, but rather provide accessors to the properties. Doing this adds some complication when you want to turn one of your web layer objects into JSON.

However, there is a solution, if the object has a `toJson` method, the Zend Framework JSON encoder will use that method, expecting a JSON representation to be returned. Now you can control exactly how your web objects are converted to JSON. Maybe you only want to expose a subset of properties, or add additional information that would be helpful for the client developers.

To achieve this in a clean way, we first define a simple interface:

```php
<?php
interface JsonProvider
{
    public function toJson();
}
```

And then have our delicious `ClamList` object implement it:

```php
<?php
class ClamList implements JsonProvider
{
    private $clams = array();
    private $batchNumber = null;

    public function addClam($clam)
    {
        $this->clams[] = $clam;
    }

    public function toJson()
    {
        $object = new \stdClass();
        $object->batchNumber = $this->batchNumber;
        $object->clams = $this->clams;
        return Json::Encode($object);
    }
}
```

The above is a rather simplified example, but the idea is that only inside your `toJson` method do you assemble an object with public properties, which is ultimately returned as JSON data.

##Final Thoughts
I hope you found this discussion helpful to building out a clean web app api. There are likely other ways to achieve this, some things that occurred to me included:

- Building out a custom view strategy, using reflection to extract the object properties.
- Creating a controller plugin to transform web objects to JSON.

If you try either of these or something else, please let me know!
