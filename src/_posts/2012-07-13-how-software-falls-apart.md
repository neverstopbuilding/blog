---
layout: post
title: "How Software Falls Apart"
date: 2012-07-13 15:37
category: software engineering
tags:  [rants, craftsmanship, quality, software design, design patterns, domain driven design]
---

I recently attended an excellent lecture by [Dr. "Mac" Louthan](http://2011.nysc.org/presenters/maclouthan/) while I was a guest at the [National Youth Science Camp](http://www.nysf.com/w/programs/nysc/). It was entitled "How Things Fall Apart". It focuses on materials science but also conveyed great ethical messages and timeless wisdom. As the title of this post might indicate I was inspired by the themes of his lecture to relate them to my world of software engineering and product management. Here are the the six reasons, and my thoughts, as to why software falls apart:

##Improper Design
This one goes without saying, without a reasonable design or architecture, software is sure to fall apart. The causes for this are typically rushed deadline or failure to examine the greater consequences of a design. Failure to architect software in a flexible way is the best way to require massive rework as soon as the requirements change, and they will! Ways to improve design include:

- Really spend time considering your problem domain and an addequet model to represent it.
- Eliminate dependencies as much as possible, as things change you may be able to swap out old components for newer, more functional ones.
- KISS - As a fan of minimalism myself, it is much easier to design something well if it only fulfills the most basic needs. Keep it simple, and leave all the bells and whistles to your (stupid) competition.

##Poor Materials Selection
In this context I take "Poor Materials Selection" to be about the team. We build software with code, and we build code with engineers. And, sorry to say, if the engineers are bad, then you will have software that falls apart. The nuance here is that you can have very talented and smart engineers but they would still be a "poor material". Pick engineers with these qualities:

- Confident, but not cocky, humble, and always willing to learn a new thing.
- A team player, someone who will discuss ideas and not "go it alone."
- Someone who is a craftsman, hacks are good in rare situations, but carefully built code is always welcome.
- Ownership. An engineer who takes ownership of the product will think about more than just their assignment, or that days goal.

##Defects In Materials
Similar to the above point, if you have found yourself with a team then you may find that some of the "materials" have defects (and this happens even with the best choice of materials.) Managing these defects can prevent problems. An important thing to note here is that as is the case in materials science, usually it is not until a material is stressed, or fatigue that the defects will cause catastrophic failure. Hairline cracks in a motor housing are fine until it is pushed past its limit and the housing explodes.

I have noticed that we all have various defects, but they only really become a problem we we are stressed. I get very cold and to the point for example, lacking compassion and empathy. Others just shut down and can't get any work done; others snap and become emotional. None of this is wrong, but preventing it is a key to keeping a team together, and keeping stress driven decisions out of the software. Some things to remember:

- Don't overload your team, too many priorities are hard to manage and create stress.
- Practice carful planning, working late is a sign of failed planning or a bad culture.
- Take breathers, encourage your team to take real breaks, not bitch sessions around the coffee machine. An hour at the gym is less time lost than 4 hours staring at a computer complaining with your co-workers over IM.
- Learn about other materials, if you know about the defects in others, you can better manage your team to not aggravate them.

##Improper Processing
The key word here is "processing", be it processing your "materials", that is training your team, or processing your work, that is your development process. Either way without a healthy process software will not only fall apart, but may not even become something in the first place. In the Agile workplace, discipline to a minimal, but effective process is paramount. Additionally, it is not enough to just create a good process but each team member must be trained in its use and ideals. Some tips:

- Start small, sheet metal is not rolled from a brick to a sheet in one pass, and neither can your team go from chaos to heroess in one training. It takes multiple passes, slow introduction and mastery of concepts.
- Build a process around the best practices of Agile and the strengths of your team, you can't mandate one size fits all, and self organizing teams always tweak the process to get the best results.
- Remember, process is both a framework and set of tools, and not the be-all-and-end-all. When you have it right, discussion of process disappears, and everyone just flows. When you have it wrong, process seems like the only thing discussed.

##Errors in Assembly
To me errors in assembly sound a lot like "bugs". A bug can be either a true failure in expected outcome because of design or language skill, or a failure in performing certain requirements. Some amount of assembly errors are to be expected as engineers gain competency with the systems and languages. Others often arise because of a lack of communication between engineering and business stakeholders. Some ways to avoid bugs:

- Define a common language for your problem that can be spoken by the CEO, the mail boy, the product owner, the designer, the developer, whoever. A widget is a widget is a widget. This way everyone is on the same page in discussions.
- Constant involvement of all stakeholders at every step of the process. You would be amazed how a simple conversation can clear up a ream of requirements documents.
- Behavior/Acceptance Criteria/Test Driven development. By defining your desired outcomes first, especially in a simple language you can not only get everyone on the same page, but you can continuously validate your software to be free of errors.

##Inadequate Service
Dr. Louthan said "Don't leave [service] to someone else." In software I take this to be about documentation, customer support, and code maintenance and refactoring. Software is a living artifact of a problem solving strategy. It can be perfect on release, but as time marches on, and requirements, customers, and the team changes it will start to age. Knowledge will be lost, hacks and patches will be introduced. Entropy will take its deadly toll. As such you MUST maintain your code base and provide clear documentation and self documenting code. And when I say "you", I mean YOU, the person reading this is responsible, no one else will do it. Seriously, refactor two lines of code right now!

**Done?**

Ok, here are some tips:

- Budget time for refactoring in every sprint or iteration, this should be non-negotiable and understood all the way up to the head of the company.
- Implement automated documentation tools and release notes; providing easy access to good current documentation will accelerate the learning process for new team members.
- Take the initiative to mentor and train anyone you can on the nuances of your software, keeping the oral tradition alive will clear up confusion as opposed to written documentation which is almost always out of date.

##The Big Picture
All of these causes of failure really can be boiled down to one: Software will fall apart if you try to build it without the big picture in mind. Having a unified design, vision, and team will do wonders for producing amazing products!

###Some Resources

- [Domain Driven Design](http://www.infoq.com/minibooks/domain-driven-design-quickly/)
- [Martin Fowler's Design Patterns](http://martinfowler.com/eaaCatalog/)
- [Agile Software Development](http://en.wikipedia.org/wiki/Agile_software_development)
- [Lean Software Development ](http://en.wikipedia.org/wiki/Lean_software_development)
- [Behavior Driven Development](http://behaviour-driven.org/)
- [Behat](http://behat.org/) (BDD Framework for PHP)
- [PHPDocumentor](http://www.phpdoc.org/) (Automated documentation for PHP)
