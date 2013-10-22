---
layout: post
title: "Integrating GitHub with Trello with Heroku"
date: 2012-09-14 18:46
comments: true
categories: [github, trello]
---

I was pretty miffed at the lack of documentation and how-to on getting some sort of useful connection between [GitHub](https://github.com/) and [Trello](https://trello.com/). All I needed was something simple:

- Commits would add the messages to cards.
- Some commands could move cards through a Kanban flow.

I wanted to do things like this:

    git commit -m 'added a bunch of code to start 24'

And have card 24 move from my "Ready for Development" list to my "Doing" list, adding the commit message to the card as a comment.

I started with the work of [CodyClark](https://github.com/CodyClark/github-trello) and [zanker](https://github.com/zanker/github-trello) but modified / simplified it a great deal so that I could get it up an running on Heroku with my limited knowledge of that and Ruby.

#This is the one you want: [jrobertfox/github-trello](https://github.com/jasonrobertfox/github-trello)

This post will serve as a general set up guide for the whole *thang.*

##Set up Heroku
Go get a free account [here](http://www.heroku.com/). Follow the instructions to install the terminal tools. Login with your account.

##Gather config values
- **api_key** - Go to [https://trello.com/1/appKey/generate](https://trello.com/1/appKey/generate)<br> ![](http://media.tumblr.com/tumblr_mablr1SXWm1r1y0wi.png)
- **oauth_token** - Go to _https://trello.com/1/authorize?response_type=token&name=Trello+Github+Integration&scope=read,write&expiration=never&key=[your-key-here]_ replacing __[your-key-here]__ with the **api_key** from above. Authorize the request:<br> ![](http://media.tumblr.com/tumblr_mablrk95521r1y0wi.png) <br> and record the token.<br> ![](http://media.tumblr.com/tumblr_mablrxjGZG1r1y0wi.png)
- **board_id** - You can get the board id from the URL, for example https://trello.com/board/trello-development/4d5ea62fd76aa1136000000c the board id is _4d5ea62fd76aa1136000000ca_.
- **…list_target_id** - These can be found by opening a card in the list, exporting it as json, and grabbing the "idList" value.

##Deploy to Heroku
Follow these steps replacing the flagged values with the ones you gathered above:

- clone [this repo.](https://github.com/jasonrobertfox/github-trello)
- `cd github-trello` - go into that directory
- `heroku create` - create the Heroku app
- `heroku config:add api_key=<API_KEY> oauth_token=<OATH_TOKEN> board_id=<BOARD_ID> start_list_target_id=<ID> finish_list_target_id=<ID>` - add all your details
- `git push heroku master` - deploy! <br> ![](http://media.tumblr.com/tumblr_mablsi8NDc1r1y0wi.png)

Now the server should be running on Heroku.

##Set up GitHub
Simply add you your Heroku app url + "/posthook" as a WebHook url under "Admin" for your repository. Example:

`http://crazy-cow-123.herokuapp.com/posthook`

![](http://media.tumblr.com/tumblr_mablsyCtn31r1y0wi.png)

##Thats it!

Now when you commit to your git repo with the right flags:

- `start` and `per` will move the card to a list specified in configuration by the `start_list_target_id` parameter.
- `finish` and `fix` will move the card to a list specified in configuration by the `finish_list_target_id` parameter.

Your Trello card will be updated with a comment or moved between lists, something like this:

![](http://media.tumblr.com/tumblr_mablt77kQK1r1y0wi.png)

Have fun!
