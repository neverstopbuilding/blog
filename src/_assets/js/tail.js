$(document).foundation();

$('.end-of-article').waypoint(function(direction) {
    if (direction == 'down') {
        mixpanel.track("End of Article Reached", {
            "title": $('.page').attr('name')
        });
    }
}, { offset: '25%' });

$('.recent-posts').waypoint(function(direction) {
    if (direction == 'down') {
        mixpanel.track("Recent Posts Reached", {
            "title": $('.page').attr('name')
        });
    }
}, { offset: '25%' });

mixpanel.track_links("a.twitter", "Twitter Link Clicked", {'title': $('.page').attr('name') });

mixpanel.track_links(".recent-posts a", "Recent Post Clicked", {'title': $('.page').attr('name') });

mixpanel.track_links(".nav a", "Nav Item Clicked", function(link) {
    return { nav_item: $(link).attr('name') }
});
