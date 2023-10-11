$(function () {
    LoadMenu(ServerObj.GROUPID);
});

//加载菜单 暂支持3级菜单展示
function LoadMenu(GroupId) {
    //同步调用
    var objJson = $cm({
        ClassName:"CT.IPMR.BTS.MenusSrv",
        MethodName:"BuildMenuJson",
        aGroupId:GroupId
    },false);
    var html = '';
    for (var i = 0; i < objJson.length; i++) {
        var menuId = objJson[i]['id'];
        var menuIcon = objJson[i]['iconCls'];
        var menuDesc = objJson[i]['text'];
        var menuUrl = objJson[i]['url'];
        var subMenu = objJson[i]['leaf'];
        if (!subMenu) {
            var htm = '';
            html += '<li class="" id="li_parent_' + menuId;
            html += '"><a href="#" class="dropdown-toggle">';
            html += '<i class="menu-icon fa '+menuIcon+'"/><span class="menu-text">';
            //html += '<img class="'+menuIcon+'"/><span class="menu-text">';
            html += menuDesc
            html += '</span><b class="arrow fa fa-angle-down"></b></a><ul class="submenu" id="ul_parent_'+menuId 
            html += '">';
            for (var j = 0; j < objJson[i].children.length; j++) {
                var jmenuId = objJson[i].children[j]['id'];
                var jmenuIcon = objJson[i].children[j]['iconCls'];
                var jmenuDesc = objJson[i].children[j]['text'];
                var jmenuUrl = objJson[i].children[j]['url'];
                var jsubMenu = objJson[i].children[j]['leaf'];
                if (!jsubMenu) {
                    html += '<li class="dropdown-submenu" id="li_parent_' + jmenuId + '">' +
                    '<a class="dropdown-toggle" href="#" role="button" aria-haspopup="true" aria-expanded="false">' +
                    jmenuDesc +
                    '</a>' +
                    '<ul class="submenu" id="li_parent_' + jmenuId + '">';
                    for (var jj = 0; jj < objJson[i].children[j].children.length; jj++) {
                        var jjmenuId = objJson[i].children[j].children[jj]['id'];
                        var jjmenuIcon = objJson[i].children[j].children[jj]['iconCls'];
                        var jjmenuDesc = objJson[i].children[j].children[jj]['text'];
                        var jjmenuUrl = objJson[i].children[j].children[jj]['url'];
                        var jjsubMenu = objJson[i].children[j].children[jj]['leaf'];
                        if(jjsubMenu){
                            if (jjmenuUrl!="") jjmenuUrl = jjmenuUrl+"&menuId="+jjmenuId;
                            html += '<li id="li_parent_' + jmenuId + '"" class="">' +
                            '<a id="' + jjmenuId + '"  id="' + jjmenuId + '" href="#" onclick="openurl(\'' + jjmenuId + '\',\'' + jjmenuDesc + '\',\'' + jjmenuUrl + '\',\'' + jjmenuId + '\',\'' + jjmenuIcon + '\')">' +
                            '<img class="'+menuIcon+'"/><span>' + jjmenuDesc + '</span>' +
                            '</a><b class="arrow"></b>' +
                            '</li>';
                        }
                    }
                    html += '</ul>'
                    html += '</li>'
                }else {
                    if (jmenuUrl!="") jmenuUrl = jmenuUrl+"&menuId="+jmenuId;
                    html += '<li id="li_parent_' + jmenuId + '"" class="">' +
                    '<a id="' + jmenuId + '"  id="' + jmenuId + '" href="#" onclick="openurl(\'' + jmenuId + '\',\'' + jmenuDesc + '\',\'' + jmenuUrl + '\',\'' + jmenuId + '\',\'' + jmenuIcon + '\')">' +
                    '<img class="'+menuIcon+'"/><span>' + jmenuDesc + '</span>' +
                    '</a><b class="arrow"></b>' +
                    '</li>';
                }
            }
            html += '</ul>'
            html += '</li>'
        }else {
            if (menuUrl!="") menuUrl = menuUrl+"&menuId="+menuId;
            html += '<li id="li_parent_' + menuId + '"" class="dropdown">' +
            '<a id="' + menuId + '"  id="' + menuId + '" href="#" onclick="openurl(\'' + menuId + '\',\'' + menuDesc + '\',\'' + menuUrl + '\',\'' + menuId + '\',\'' + menuIcon + '\')">' +
            //'<img class="'+menuIcon+'"/><span>' + menuDesc + '</span>' +
            '<i class="menu-icon fa '+menuIcon+'"/><span class="menu-text">' + menuDesc + '</span>' +
            '</a><b class="arrow"></b>' +
            '</li>';
        }
    }
    $('#navmenu').html(html);
}

window.onresize = function () {
    var target = $(".tab-content .active iframe");
    changeFrameHeight(target);
}

var changeFrameHeight = function (that) {
    var outerHeight = getiFrameHeight()
    $(that).height(outerHeight);
    $(that).parent(".tab-pane").height(outerHeight);
}

///iframe自适应屏幕高度
function getiFrameHeight() {
    var outerHeight=""
    if(parent.$("#centerPanel")!=null&&parent.$("#centerPanel")!=undefined) {   
        outerHeight=parent.$("#centerPanel").height()-$("#myTab").height()-1;
    }else
    {
        var outerHeight=$(window).height()  
        var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        var s;
        (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
        (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
        (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
        (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
        (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
        if(Sys.chrome){
            outerHeight = $(window).height() -68;
        }else{
            outerHeight = $(window).height() - 36; 
        }
    }
    return outerHeight
}
    

var navNow="";

///点击左侧菜单出现此菜单对应的tab界面
function openurl(id, desc, rul, parid, icon) {
    var nav = $("#content_" + id).get(0);
    if ($.isEmptyObject(nav)) { // 未打开菜单
        var htm = '';
        htm += '<li id="li_' + id + '">';
        htm += '<a data-toggle="tab"  href="#content_' + id + '">';
        htm += desc;
        htm += '<i class="glyphicon glyphicon-remove"></i>';
        htm += '</a></li>';
        $("#myTab").append(htm);
        var htmli = htm;
        htm = '';
        htm += '<div id="content_' + id + '" class="tab-pane">';
        htm += '<iframe id="iframe_' + id + '" src="' + rul + '"  width="100%" height="'+'" frameborder="0" onload="changeFrameHeight(this)">';
        htm += '系统使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。';
        htm += '</iframe>';
        htm += '</div>';
        $("#myTabContent").append(htm);    
        var liwidth = 0;
        $("#myTab>li").each(function(i){
           liwidth += $(this).width();
        });
        var tabwidth = $('#myTab').width();
        if (liwidth>=tabwidth) {
            $("#li_" + id).remove();
            $("#dropdownmenu").append(htmli);
        }
        menuStyle(id);
    }
    displayMenu(id);

    $("#navmenu").find("li").removeClass("active");
    $("#li_parent_" + parid).addClass("active");
    $("#" + id).parent("li").addClass("active");
}

///横向导航的样式控制
function menuStyle(id) {
    $(".nav-tabs li a .glyphicon-remove").hover(
        function () {
            $(this).css("color",'red');
            $(this).css("cursor",'pointer');
        },
        function () {
            $(this).css("color",'#576373');
        }
    );
    $("#li_" + id).find(".glyphicon").click(
        function () {
            closeMenu(id);
        }
    );
    $("#li_" + id).click(
        function () {
            //通过id找到左侧对应的子菜单，并给子菜单设定样式
            setSubMenusActiveStyle(id);
        }
    );
    $("#li_" + id).contextMenu('mm', {

        bindings: {
            'tabClose': function(t) {
                if (id == 'home') {} else {
                    closeMenu(id);
                }
            },
            'tabCloseOther': function(t) {
                //先清空下拉菜单 dropdown-menu_zyq
                $("#dropdown-menu_zyq").children("li").each(function(i, e) {
                    $(e).remove();
                });
                $("#myTab").children("li").each(function(i, e) {
                    
                    if (e.id != "li_home" && e.id != "li_tabdrop" && e.id != "li_" + id) {
                        $(e).remove();
                    }
                });
                $("#myTabContent").children("div").each(function(i, e) {
                    if (e.id != "content_home" && e.id != "content_" + id) {
                        $(e).remove();
                        
                    }
                });
                displayMenu(id);
            },
            'tabCloseAll': function(t) {
                //先清空下拉菜单 dropdown-menu_zyq
                $("#dropdown-menu_zyq").children("li").each(function(i, e) {
                    $(e).remove();
                });
                $("#myTab").children("li").each(function(i, e) {
                    //debugger
                    if (e.id != "li_home" && e.id != "li_tabdrop") {
                        $(e).remove();
                    }
                });
                $("#myTabContent").children("div").each(function(i, e) {
                    if (e.id != "content_home") {
                        $(e).remove();
                    }
                });
                displayMenu("home");
            }
        }
    });
}
///打开指定的页面
function displayMenu(id) {
    $("#myTab").find("li").removeClass("active");
    $("#myTabContent").find(".tab-pane").removeClass("active");
    $('a[href=#content_' + id + ']').parent("li").addClass("active");
    $("#content_" + id).addClass("active");
    $("#li_" + id).addClass("active");
    
    //通过id找到左侧对应的子菜单，并给子菜单设定样式
    setSubMenusActiveStyle(id);
}



//通过id找到左侧对应的子菜单，并给子菜单设定选中样式
function setSubMenusActiveStyle(id) {
    $("#navmenu").find("a[id]").removeClass("submenus_active");
    $("#navmenu").find("a[id=" + id + "]").addClass("submenus_active");
}

///关闭Tab
function closeMenu(id) {
    ///如果关闭的是当前正打开的tab页，则需要先打开一个前面紧挨着的页面，然后再关闭
    if ($("#li_" + id).hasClass("active")) {
        if ($('a[href=#content_' + id + ']').parent("li").parent('ul')[0].id=='myTab') {
            var li = $('a[href=#content_' + id + ']').parent("li").prev();
            var preid = li.attr("id").split("_")[1];
            displayMenu(preid);
        }else{
            displayMenu('home');
        }
    }
    if (id != "home") {
        $("#li_" + id).remove();
        $("#content_" + id).remove();
    }
}