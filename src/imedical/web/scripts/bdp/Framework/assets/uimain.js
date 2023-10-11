
//获取菜单高度
function getiFrameHeight() {
	var outerHeight="";
	//煎药室-系统配置-打开煎药室系统配置菜单，界面下方留有空白 gxp2020-12-25
	if ((parent.$("#TRAK_tabs")!=null)&&(parent.$("#TRAK_tabs")!=undefined)&&(parent.$("#TRAK_tabs >.tabs-panels").height()!=null)&&(parent.$("#TRAK_tabs >.tabs-panels").height()>0))
	{
	    outerHeight=parent.$("#TRAK_tabs >.tabs-panels").height()-$("#myTab").height();
		//outerHeight=outerHeight-10 ///2020-02-13解决下面出现10px遮住了的问题
		return outerHeight;
	}
	else if((parent.$("#centerPanel")!=null)&&(parent.$("#centerPanel")!=undefined)&&(parent.$("#centerPanel").height()!=null)&&(parent.$("#centerPanel").height()>0))
	{
		outerHeight=parent.$("#centerPanel").height()-$("#myTab").height();
		return outerHeight;
	}
	else
	{
		outerHeight=$(window).height()-$("#myTab").height();
		/*
		//outerHeight=Math.max(parent.$(".panel-body").height(),parent.$("#centerPanel").height())-$("#myTab").height();
		
		//老系统的获取高度方法
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		var s;
		(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
		if(Sys.chrome){
			//outerHeight = $(window).height() - 122;
			outerHeight = $(window).height() -68;
		}
		else{
		  //outerHeight = $(window).height() - 80; 
			outerHeight = $(window).height() - 36; 
		}
		*/
	    return outerHeight;
	}
}
///iframe自适应屏幕高度
var resizeHeight = function (){
	var outerHeight=getiFrameHeight();
	$("iframe[id^='iframe_']").height(outerHeight);	
}
///拖拽或者缩放时调整iframe高度
$(window).resize(function(){
	setTimeout(function(){
		resizeHeight();
	},100);
});

	
var navNow="";
///点击左侧菜单出现此菜单对应的tab界面
function showNavTab(RowID, MenuName, URL, parentRowID, iconurl) {
    var nav = $("#content_" + RowID).get(0);
    if ($.isEmptyObject(nav)) {//检查是否已经存在打开的菜单
        var htm = '';
        htm += '<li id="li_' + RowID + '">';
        htm += '<a onclick="tabChange('+RowID+')" data-toggle="tab"  href="#content_' + RowID + '">';
        /*if (iconurl)
            htm += '<i class="ace-icon fa ' + iconurl + '"></i>';
        else
            htm += '<i></i>';*/
        if (iconurl==""){
        	//htm += '<i class="ace-icon fa fa-book"></i> ';
        	htm += "<img style='height:16px;' src='../scripts/bdp/Framework/BdpIconsLib/null.png' /> ";
        }else{
        	htm += "<img style='height:16px;' src="+iconurl+" /> ";
        }
        htm += MenuName;
        htm += '<i class="glyphicon glyphicon-remove bigger-110 red2" style="cursor:pointer"></i>';
        htm += '</a>';
        htm += '</li>';
        $("#myTab").append(htm);
        var Heighteee=getiFrameHeight()
        htm = '';
        htm += '<div id="content_' + RowID + '" class="tab-pane">';
        if ('undefined'!==typeof websys_getMWToken)
        {
			URL += "&MWToken="+websys_getMWToken() //20230209 增加token
		}
        //htm += "<iframe id='iframe_" + RowID + "' src='" + URL + "'  width='100%'  min-height='500px'  onLoad='iFrameHeight(\"iframe_" + RowID + "\")' frameborder='0' >";
        htm += '<iframe id="iframe_' + RowID + '" src="' + URL + '"  width="100%" height="'+Heighteee+'" frameborder="0" >';
        htm += '系统使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。';
        htm += '</iframe>';
        htm += '</div>';
        $("#myTabContent").append(htm);       
        navTabStyle(RowID);
    }
    displayNavTab(RowID);
    $("#navmenu").find("li").removeClass("active");
    //$("#nav").addClass("active");
    //$("#nav").find(".active").removeClass("active");
    //alert($("#nav>li").find(".active"));
    $("#li_parent_" + parentRowID).addClass("active");
    $("#" + RowID).parent("li").addClass("active");
    tabChange(RowID);  //解决在菜单相继点开两个有组件的菜单，再点回第一个出现界面空白的问题。
    // alert(RowID);
    //   $("#ul_parent_" + parentRowID).show();
}

///点击tab的触发事件，用来解决有组件的界面，打开两个tab出现界面空白的问题
function tabChange(id){
	///清除当前用户 基础平台下系统配置-锁表记录。20221102
    tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
  if (id!=""){
	var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","IFComp",id);
	if (Flag=="Y"){
		if((id!=navNow)&(id!="home")){		
			var url=document.getElementById("iframe_"+ id).src;
			var urlArr=url.split("/");
			var src=urlArr[urlArr.length-1];
			$("#iframe_" + id).attr("src",src);
		}
	}	
	navNow=id
	setTimeout(function(){
		resizeHeight();
	},100);
 }
}
///横向导航的样式控制
function navTabStyle(RowID) {
    $("#li_" + RowID).find(".icon-remove").hover(
        function () {
            $(this).addClass("badge badge-danger");
        },
        function () {
            $(this).removeClass("badge badge-danger");
        }
    );

    $("#li_" + RowID).find(".glyphicon").click(
        function () {
            closeNavTab(RowID);
        }
    );

    $("#li_" + RowID).click(
        function () {
            //通过rowID找到左侧对应的子菜单，并给子菜单设定样式
            setSubMenusActiveStyle(RowID);
        }
    );
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
}

//通过rowID找到左侧对应的子菜单，并给子菜单设定选中样式
function setSubMenusActiveStyle(RowID) {
    $("#nav").find("a[RowID]").removeClass("submenus_active");
    $("#nav").find("a[RowID=" + RowID + "]").addClass("submenus_active");
}

///关闭Tab
function closeNavTab(RowID) {
    ///如果关闭的是当前正打开的tab页，则需要先打开一个前面紧挨着的页面，然后再关闭
    if ($("#li_" + RowID).hasClass("active")) {
        var li = $('a[href=#content_' + RowID + ']').parent("li").prev();
        var preRowID = li.attr("id").split("_")[1];
        displayNavTab(preRowID);
        if(preRowID!="home"){	//解决关闭其他标签，home页报错
	        var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","IFComp",preRowID);
			if (Flag=="Y"){
				var url=document.getElementById("iframe_"+ preRowID).src;
				var urlArr=url.split("/");
				var src=urlArr[urlArr.length-1];
				$("#iframe_" + preRowID).attr("src",src);	
			}
        }
    }
    if (RowID != "home") {
        $("#li_" + RowID).remove();
        $("#content_" + RowID).remove();
    }
    ///清除当前用户 基础平台下系统配置-锁表记录。20221102
    tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
}

///打开指定的页面
function displayNavTab(RowID) {
    $("#myTab").find("li").removeClass("active");
    $("#myTabContent").find(".tab-pane").removeClass("active");

    $('a[href=#content_' + RowID + ']').parent("li").addClass("active");
    $("#content_" + RowID).addClass("active");
    $("#li_" + RowID).addClass("active");
    //通过rowID找到左侧对应的子菜单，并给子菜单设定样式
    setSubMenusActiveStyle(RowID);
}