$(document).ready(function() {
    var linkUrl = dhccl.getQueryString("linkUrl");
    var queryString = window.location.search;
    linkUrl = linkUrl + queryString;
    //alert(linkUrl);
    document.getElementById("module").src = linkUrl;
    //document.frames[0].location.href = linkUrl;
});