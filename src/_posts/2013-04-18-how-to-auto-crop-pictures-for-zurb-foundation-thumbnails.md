---
layout: post
title: "How to Auto Crop Pictures for Zurb Foundation Thumbnails"
date: 2013-04-18 16:57
category: web development
tags:  [css, zurb foundation, auto crop, thumbnails, image gallery]
---
One of the problems you may run across while building a website is dealing with galleries of unequally sized images. I think I would rather eat paint that manually resize all of them or make thumbnails. Especially because now with the great css framework [Zurb Foundation](http://foundation.zurb.com/) we can make a sweet looking image gallery really quick.

##Stock Clearing Gallery
Here is what I am trying to avoid:
![Images of different heights.](/images/post-content/clearing-avoid.png)

Which is achieved with something like this:

```html
<ul class="large-block-grid-4 clearing-thumbs" data-clearing>
    <li>
      <a class="th" href="/image.jpg">
          <img src="/image.jpg" />
      </a>
    </li>
...
</ul>
```

In this situation Zurb's `clearing` javascript will construct the light box, while the `th` class styles the thumbnails correctly.

##Make The Image Transparent
First thing we need to do is to make the image transparent. Seems like a strange idea, but it will soon become important. This can be achieved with something like this:

```html
<img class="transparent" src="/image.jpg" />
```

I am using [Compass](http://compass-style.org/) mixins below:
```css
.transparent{
    @include opacity(0);
}
```

Now you should have a bunch of empty boxes. Ut oh… Well not quite.

##Show Your Thumbnail as a Background
Oh. Duh. Yeah that makes perfect sense. All we need to do is make our thumbnail the background of the anchor link:

```html
<ul class="large-block-grid-4 clearing-thumbs" data-clearing>
    <li>
      <a class="th" href="/image.jpg" style="background-image: url(/image.jpg);">
          <img src="/image.jpg" />
      </a>
    </li>
...
</ul>
```

I know that in general it is a high sin to put `style` attributes in your html, but I think it makes sense in this instance. If you are using a template system you can just iterate through your images and set the background of each.

##Resize All the Things
Now we just add one more class to the anchor tag that lets us customize the size of our thumbnails. Something like:

```html
<ul class="large-block-grid-4 clearing-thumbs" data-clearing>
    <li>
      <a class="th th-item" href="/image.jpg" style="background-image: url(/image.jpg);">
          <img src="/image.jpg" />
      </a>
    </li>
...
</ul>
```

```css
.th-item{
    height: 11em;
    width: 100%;
    overflow: hidden;
    background-position: center;
}
```

The height is arbitrary and you may need to play around with the width or height settings depending on what kind of images you are dealing with.

##The Finished Product
With this little trick you should now have something that looks like this:
![Images are the same size.](/images/post-content/clearing-finished.png)

Which looks pretty good, plus the Zurb Foundation responsive lightbox still works.
