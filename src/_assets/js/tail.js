$(document).foundation({
  'orbit': {
    animation: 'fade',
    timer_speed: 6000,
    bullets: false,
    resume_on_mouseout: true
  }
});

var disqus_shortname = 'neverstopbuilding';

(function () {
  var dsq = document.createElement('script');
  dsq.type = 'text/javascript';
  dsq.async = true;
  dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();

function trackArticleProgress(progress) {
  mixpanel.track("Reading Progress", {
    amount: progress,
    title: $('.page').attr('title'),
    category: $('.mp-category').attr('title'),
    pubDate: $('.mp-pub-date').attr('datetime')
  });
}

$('.mp-article').waypoint(function (direction) {
  if (direction == 'down') {
    trackArticleProgress('started article');
  }
});

$('.mp-article').waypoint(function (direction) {
  if (direction == 'down') {
    trackArticleProgress('read 1/3');
  }
}, {
  offset: function () {
    return -$(this).height() * 0.33;
  }
});

$('.mp-article').waypoint(function (direction) {
  if (direction == 'down') {
    trackArticleProgress('read 2/3');
  }
}, {
  offset: function () {
    return -$(this).height() * 0.66;
  }
});

$('.mp-article').waypoint(function (direction) {
  if (direction == 'down') {
    trackArticleProgress('finished');
  }
}, {
  offset: function () {
    return -$(this).height() + screen.availHeight;
  }
});


mixpanel.track_links("a.mp-footer-link", "Footer Link Clicked", function (link) {
  return {
    title: $('.page').attr('title'),
    footer_link: $(link).attr('title')
  };
});

mixpanel.track_links("a.mp-nav-link", "Nav Link Clicked", function (link) {
  return {
    title: $('.page').attr('title'),
    nav_link: $(link).attr('title')
  };
});

pageTitleResize = function () {
  if ($("#page-title").length > 0) {
    var fontSize = 300;
    var maxHeight = $("#page-title-container").height() - 20;
    var maxWidth = $("#page-title-container").width() - 25;
    do {
      $("#page-title h1").css('font-size', fontSize + "px");
      fontSize -= 3;
      titleHeight = $("#page-title h1").height();
      titleWidth = $("#page-title h1 span").width();
      bottom = (maxHeight - titleHeight) / 2;
      $("#page-title").css('bottom', bottom + "px");
    } while (titleHeight > maxHeight || titleWidth > maxWidth);
  }
};
siteTitleResize = function () {
  if ($("#site-title").length > 0) {
    var maxWidth = $(document).width();
    fontSize = 0.13 * maxWidth;
    padding = 0.5 * fontSize;
    $("#site-title h1").css('font-size', fontSize + "px");
    $("#site-title").css('padding-top', padding + "px");
    $("#site-title").css('padding-bottom', padding + "px");
  }
};

$(window).resize(pageTitleResize);
$(document).ready(pageTitleResize);
$(window).resize(siteTitleResize);
$(document).ready(siteTitleResize);
