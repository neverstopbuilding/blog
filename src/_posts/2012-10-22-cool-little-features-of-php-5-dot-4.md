---
layout: post
title: "Cool Little Features of PHP 5.4"
date: 2012-10-22 15:23
category: web development
tags:  [php, php5, zendcon, type hinting, json serializable interface, session handler interface]
---
Just got out of a energetic talk by [Ilia Alshanetsky](https://twitter.com/iliaa) at [ZendCon](http://zendcon.com/) about the new features of the [PHP5.4](http://php.net/releases/5_4_0.php) release. Some of the "little ones" seemed most immediately applicable, here is a run down of some of my favorites!

##Accessing Values From Returned Arrays Directly
It always pissed me off when I had to do this:

    $tempArray = $object->getArray();
    $whatIWant = $tempArray[1];

But now with PHP5.4 you can just do this:

    $whatIWant = $object->getArray()[1];

Nice.
##Printing Short Tag Availability
I'm not a huge fan of these different tags, but now you can always be certain that using the `<?= ?>` tags will be available for printing, and ini settings won't mess up your view scripts. You have view scripts don't you?

##Compact Array Syntax
Typing the word `array` can get REAL OLD. Am I right?

    $myArray = array(1,2,3);                              //Don't do this old man…
    $otherArray = array('id' => 1, 'name' => 'Jason');    //...or this geezer.

    $myArray = [1,2,3];                                   //This is now we do it…
    $otherArray = ['id' => 1, 'name' => 'Jason'];         //...php5.4 style.

For more go [here](http://docs.php.net/manual/en/language.types.array.php).
##JsonSerializable Interface
As Ilia explained in his talk, more and more are php applications being used to pass back data to a view layer for fancy processing with javascript. As such it makes sense to be able consistently pass back json data. By implementing the `JsonSerializable` interface, if you pass an instance of your object to `json_encode` it will be transformed to json in whatever way you want:

    class MessOfData implements JsonSerializable{

        //A bunch of code, including a getId and getName function

        public function jsonSerialize{
            return ['id' => $this->getId(), 'name' => $this->getName()]
        }
    }

See above for the minimal array syntax. Now you can just do this for your json fun:

    $myMess = new MessOfData();
    echo json_encode($myMess);

For more go [here](http://php.net/manual/en/jsonserializable.jsonserialize.php).
##SessionHandlerInterface
No need to repeat the documentation here, this is just a nice OOP way to implement your own session handler to be passed to `session_set_save_handler()`. Off the top of my head maybe you want to handle all your user sessions with MongoDB and do it with composition, here is an example:

    class MongoUserSessionHandler implements SessionHandlerInterface{

        public function __construct(MongoUserRepository $userRepo){
            //...
        }

        //implement the SessionHandlerInterface methods
    }

Now you can set your save handler in some sort of initialization event and rock and roll.

For more go [here](http://php.net/manual/en/class.sessionhandlerinterface.php).
##Type Hinting for Callables
Let's say you have have a function that requires an anonymous function as an argument. Well now you can type hint that with the `callable` hint:

    $myFunction = function(){
        echo "BLAM!";
    }

    public function callFunction(callable $function){
        //call the $function as needed
    }

##Availability of $this in Anonymous Functions
Finally, PHP5.4 allows us to access the `$this` variable from within anonymous functions, something like this:

    class myClass{
        private $name = 'Jason';

        public function sayName(){
            $name = function(){
                return $this->name;
            }
            echo $name;
        }
    }

Convoluted, but you can do it.

For more go [here](http://php.net/manual/en/functions.anonymous.php).


Thanks a lot for a great presentation [@iliaa](https://twitter.com/iliaa)! I'll probably pull together a more detailed post on the "traits" feature soon.
