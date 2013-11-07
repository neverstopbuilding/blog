$(document).foundation('orbit', {
    animation: 'fade',
    timer_speed: 6000,
    bullets: false,
    resume_on_mouseout: true,

});

var disqus_shortname = 'neverstopbuilding';

(function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();

$('.end-of-article').waypoint(function(direction) {
    if (direction == 'down') {
        mixpanel.track("End of Article Reached", {
            "title": $('.page').attr('title')
        });
    }
}, { offset: '25%' });

$('.recent-posts').waypoint(function(direction) {
    if (direction == 'down') {
        mixpanel.track("Recent Posts Reached", {
            "title": $('.page').attr('title')
        });
    }
}, { offset: '25%' });

mixpanel.track_links("a.twitter", "Twitter Link Clicked", {'title': $('.page').attr('title') });

mixpanel.track_links(".recent-posts a", "Recent Post Clicked", {'title': $('.page').attr('title') });

mixpanel.track_links(".nav a", "Nav Item Clicked", function(link) {
    return { nav_item: $(link).attr('title') }
});
