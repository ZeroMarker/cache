var tabItemTpl ='<li id="li_${menuId}">'
         			+'<a data-toggle="tab" href="#content_${menuId}">'
         				+'<i {{if iconUrl}} class="ace-icon fa ${iconUrl} {{/if}} >'
         				+'</i>${menuName}'
						+'<i class="glyphicon glyphicon-remove" style="cursor:pointer"></i>'
       				+'</a>'
        		+'</li>';
        		
var contentItemTpl = '<div id="content_${menuId}" class="tab-pane">'
        			+ '<iframe id="iframe_${menuId}" src=""  width="100%"  min-height="500px"  height="100%" frameborder="0" >'
        			+ '系统使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。'
        			+ '</iframe>'
        			+ '</div>';
var keepopen=false;
function unlockonunload() {
	if (window.event) {
		if (window.event.clientX < 0)
		{
		   if (!keepopen){
		   		window.location.href="websys.closesession.csp";
		   		return false;
		   }
		}
	}
	return true;
}
function SetKeepOpen(url,newwin) {
	parent.keepopen=true;
	parent.location.href=url;
}
//点击首页
function websysChangeMenu(){
	top.IsSideMenu = false;
	top.initHeadMenu();
	self.window.location='epr.default.csp?IsSideMenu=false';
}
function OpenMenuItem(menuId,href,target,blankOpt){
	var menuName = $('#'+menuId).text();
	if (href.indexOf("javascript:")>-1){
		window.eval(href);
	}else{
		if(target=="TRAK_main"){
			showNavTab({menuId:menuId,menuName:$('#'+menuId).text(),menuHref:href, parentId:0, iconUrl:""})
		}else{
			websys_createWindow(href,target,blankOpt);
		}
	}
	return false;
}
///iframe自适应屏幕高度--如果太高影响左边列表  
//每次点tab页签计算吧，在onload计算，当tab签变为两行时就不准了；
//而且不考虑这个的话，直接打开页面计算一次就可以的，因为每个iframe的高度都应一致
function iFrameHeight(id) {
	// wanghc setTimeout解决IE下第二次显示frameset时空白问题
	var ifm = document.getElementById(id);
	ifm.height="99%";
	setTimeout(function (){ifm.height="100%"},100);
	return true;
	var ifm = document.getElementById(id);
	var outheight=calHeight()+"px";
	if (ifm != null && ifm.height!=outheight) {
		ifm.height=outheight;
	}
}
///iframe自适应屏幕高度--如果太高影响左边列表
/*
function iFrameHeight(id) {
    var ifm = document.getElementById(id);
    if (ifm != null) {
        try{
            var outerHeight = $(window).height() ;
            ifm.height = outerHeight;
        }catch(e){
            ifm.height = 600;
        }
    }
}*/
function calHeight(){
	try{
		var h = $(window).height()-$('.tabbable').height() ;
	}catch(e){
		var h = 600;
	}
	return h;
}
///在新增tab,关闭tab,调整窗口大小是调用，
///根据窗口高度和tab占的高度，计算出div#myTabContent的高度，其下面的每个iframe高度宽度都为100%，改变此div高度，即可改变iframe高度
function fitMyTabContentHeight(){
	var h=calHeight();
	if ($('#myTabContent').height()!=h){
			$('#myTabContent').height(h);
	}
}
/*
///iframe自适应屏幕高度
function iFrameHeight(id) {
    var ifm = document.getElementById(id);
    if (ifm != null) {
        //ifm.height = window.innerHeight - 90;
        ////父窗口也随着改变 myTabContent
        //$("#myTabContent").height(window.innerHeight - 90);
        try {
            var bHeight = ifm.contentWindow.document.body.scrollHeight;
            var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
            var innerHeight = Math.min(bHeight, dHeight);
            var outerHeight = $(window).height() - 110;
            // var height = Math.max(innerHeight, outerHeight);
            ifm.height = outerHeight;
        }
        catch (e) {
            ifm.height = 600;
        }

    }
}*/
///点击左侧菜单出现此菜单对应的tab界面
function showNavTab(menuItemObj) {
	var rowid = menuItemObj.menuId;
    var nav = $("#content_" + rowid).get(0);
    if ($.isEmptyObject(nav)) {//检查是否已经存在打开的菜单
        $("#myTab").append($.tmpl("tabItemTpl",menuItemObj));
        $("#myTabContent").append($.tmpl("contentItemTpl",menuItemObj));
		$('#iframe_'+menuItemObj.menuId).attr('src',menuItemObj.menuHref);
        navTabStyle(rowid);
    }
    displayNavTab(rowid);
    $("#navmenu").find("li").removeClass("active");
    //$("#li_parent_" + parentRowID).addClass("active");
    $("#" + rowid).parent("li").addClass("active");
}

///横向导航的样式控制
function navTabStyle(RowID) {
    /*$("#li_" + RowID).find(".icon-remove").hover(
        function () {
            $(this).addClass("badge badge-danger");
        },
        function () {
            $(this).removeClass("badge badge-danger");
        }
    );*/
    $("#li_" + RowID).find(".glyphicon-remove").hover(
        function () {
            $(this).addClass("red2");
        },
        function () {
            $(this).removeClass("red2");
        }
    );

    $("#li_" + RowID).find(".glyphicon").click(
        function () {
            closeNavTab(RowID);
        }
    );

    $("#li_" + RowID).click(
        function () {
            
            setSubMenusActiveStyle(RowID);
            //通过rowID找到左侧对应的子菜单，并给子菜单设定样式
			iFrameHeight('iframe_'+RowID);
        }
    );
	try{
    $("#li_" + RowID).contextMenu('mm', {
        bindings: {
            'tabClose': function (t) {
                if (RowID == 'home') {
                } else {
                    closeNavTab(RowID);
                }
            },
            'tabCloseOther': function (t) {
                $("#myTab").children("li").each(function (i, e) {
                    if (e.id != "li_home" && e.id != "li_" + RowID) {
                        $(e).remove();
                    }
                });
                $("#myTabContent").children("div").each(function (i, e) {
                    if (e.id != "content_home" && e.id != "content_" + RowID) {
                        $(e).remove();
                    }
                });
                displayNavTab(RowID);
            },
            'tabCloseAll': function (t) {
                $("#myTab").children("li").each(function (i, e) {
                    if (e.id != "li_home") {
                        $(e).remove();
                    }
                });
                $("#myTabContent").children("div").each(function (i, e) {
                    if (e.id != "content_home") {
                        $(e).remove();
                    }
                });
                displayNavTab("home");
            }
        }
    });
	}catch(e){}
}

//通过rowID找到左侧对应的子菜单，并给子菜单设定选中样式
function setSubMenusActiveStyle(RowID) {
    //$("#nav").find("a[RowID]").removeClass("submenus_active");
   // $("#nav").find("a[RowID=" + RowID + "]").addClass("submenus_active");
   $("#navmenu").find("li").removeClass("active");
   $('#'+RowID).parents('li').addClass('active');
}

///关闭Tab
function closeNavTab(RowID) {
    ///如果关闭的是当前正打开的tab页，则需要先打开一个前面紧挨着的页面，然后再关闭
    if ($("#li_" + RowID).hasClass("active")) {
        var li = $('a[href=#content_' + RowID + ']').parent("li").prev();
        var preRowID = li.attr("id").split("_")[1];
        displayNavTab(preRowID);
    }
    if (RowID != "home") {
        $("#li_" + RowID).remove();
        $("#content_" + RowID).remove();
    }
	fitMyTabContentHeight();
}

///打开指定的页面
function displayNavTab(RowID) {
	fitMyTabContentHeight();
    $("#myTab").find("li").removeClass("active");
    $("#myTabContent").find(".tab-pane").removeClass("active");

    $('a[href=#content_' + RowID + ']').parent("li").addClass("active");
    $("#content_" + RowID).addClass("active");
    $("#li_" + RowID).addClass("active");
    //通过rowID找到左侧对应的子菜单，并给子菜单设定样式
    setSubMenusActiveStyle(RowID);
    iFrameHeight('iframe_'+RowID);
}

$(function(){
	$.template('tabItemTpl',tabItemTpl);
	$.template('contentItemTpl',contentItemTpl);
	fitMyTabContentHeight();
	$(window).on('resize',fitMyTabContentHeight);
	navTabStyle("home");
	window.onunload = unlockonunload;
})








