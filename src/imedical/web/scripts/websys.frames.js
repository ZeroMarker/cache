var tabItemTpl ='<li id="li_${menuId}">'
         			+'<a data-toggle="tab" href="#content_${menuId}">'
         				+'<i {{if iconUrl}} class="ace-icon fa ${iconUrl} {{/if}} >'
         				+'</i>${menuName}'
						+'<i class="glyphicon glyphicon-remove" style="cursor:pointer"></i>'
       				+'</a>'
        		+'</li>';
        		
var contentItemTpl = '<div id="content_${menuId}" class="tab-pane">'
        			+ '<iframe id="iframe_${menuId}" src=""  width="100%"  min-height="500px"  height="100%" frameborder="0" >'
        			+ 'ϵͳʹ���˿�ܼ��������������������֧�ֿ�ܣ�����������������Ա��������ʡ�'
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
//�����ҳ
function websysChangeMenu(){
	top.IsSideMenu = false;
	top.initHeadMenu();
	self.window.location = websys_writeMWToken('epr.default.csp?IsSideMenu=false');
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
///iframe����Ӧ��Ļ�߶�--���̫��Ӱ������б�  
//ÿ�ε�tabҳǩ����ɣ���onload���㣬��tabǩ��Ϊ����ʱ�Ͳ�׼�ˣ�
//���Ҳ���������Ļ���ֱ�Ӵ�ҳ�����һ�ξͿ��Եģ���Ϊÿ��iframe�ĸ߶ȶ�Ӧһ��
function iFrameHeight(id) {
	// wanghc setTimeout���IE�µڶ�����ʾframesetʱ�հ�����
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
///iframe����Ӧ��Ļ�߶�--���̫��Ӱ������б�
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
///������tab,�ر�tab,�������ڴ�С�ǵ��ã�
///���ݴ��ڸ߶Ⱥ�tabռ�ĸ߶ȣ������div#myTabContent�ĸ߶ȣ��������ÿ��iframe�߶ȿ�ȶ�Ϊ100%���ı��div�߶ȣ����ɸı�iframe�߶�
function fitMyTabContentHeight(){
	var h=calHeight();
	if ($('#myTabContent').height()!=h){
			$('#myTabContent').height(h);
			if (typeof window.cefbound != "undefined" || websys_isIE) $(".tab-pane.active").height(h);
	}
}
/*
///iframe����Ӧ��Ļ�߶�
function iFrameHeight(id) {
    var ifm = document.getElementById(id);
    if (ifm != null) {
        //ifm.height = window.innerHeight - 90;
        ////������Ҳ���Ÿı� myTabContent
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
///������˵����ִ˲˵���Ӧ��tab����
function showNavTab(menuItemObj) {
	var rowid = menuItemObj.menuId;
    var nav = $("#content_" + rowid).get(0);
    if ($.isEmptyObject(nav)) {//����Ƿ��Ѿ����ڴ򿪵Ĳ˵�
        $("#myTab").append($.tmpl("tabItemTpl",menuItemObj));
        $("#myTabContent").append($.tmpl("contentItemTpl",menuItemObj));
		$('#iframe_'+menuItemObj.menuId).attr('src',websys_writeMWToken(menuItemObj.menuHref));
        navTabStyle(rowid);
    }
    displayNavTab(rowid);
    $("#navmenu").find("li").removeClass("active");
    //$("#li_parent_" + parentRowID).addClass("active");
    $("#" + rowid).parent("li").addClass("active");
}

///���򵼺�����ʽ����
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
            //ͨ��rowID�ҵ�����Ӧ���Ӳ˵��������Ӳ˵��趨��ʽ
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

//ͨ��rowID�ҵ�����Ӧ���Ӳ˵��������Ӳ˵��趨ѡ����ʽ
function setSubMenusActiveStyle(RowID) {
    //$("#nav").find("a[RowID]").removeClass("submenus_active");
   // $("#nav").find("a[RowID=" + RowID + "]").addClass("submenus_active");
   $("#navmenu").find("li").removeClass("active");
   $('#'+RowID).parents('li').addClass('active');
}

///�ر�Tab
function closeNavTab(RowID) {
    ///����رյ��ǵ�ǰ���򿪵�tabҳ������Ҫ�ȴ�һ��ǰ������ŵ�ҳ�棬Ȼ���ٹر�
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

///��ָ����ҳ��
function displayNavTab(RowID) {
	fitMyTabContentHeight();
    $("#myTab").find("li").removeClass("active");
    $("#myTabContent").find(".tab-pane").removeClass("active");

    $('a[href=#content_' + RowID + ']').parent("li").addClass("active");
    $("#content_" + RowID).addClass("active");
    $("#li_" + RowID).addClass("active");
    //ͨ��rowID�ҵ�����Ӧ���Ӳ˵��������Ӳ˵��趨��ʽ
    setSubMenusActiveStyle(RowID);
    iFrameHeight('iframe_'+RowID);
}

$(function(){
	$.template('tabItemTpl',tabItemTpl);
	$.template('contentItemTpl',contentItemTpl);
	fitMyTabContentHeight();
	$(window).on('resize',fitMyTabContentHeight);
	navTabStyle("home");
	$("#searchBox").on('keypress',function(ev){
		if(ev.keyCode==13){
          ev.stopPropagation();
          ev.preventDefault()
          searchHandle();
     	}
	})
	$("#searchBtn").on('click', function(){
          searchHandle();
	});
	window.onunload = unlockonunload;
})
function searchHandle(){
	var searchVal = document.getElementById("searchBox").value;
	var html = $("#navmenu").html();
	$("#navmenu i.menu-icon").each(function(ind,itm){
		var _t = $(this);
		var _li = _t.closest('li');
		var _tx = "";
		if (_t[0].nextSibling.nodeType==3){
			_tx = _t[0].nextSibling.nodeValue || _t[0].nextSibling.innerText;
		}else if(_t[0].nextSibling.nodeType==1){
			_tx = _t[0].nextSibling.innerText; 
		}
		if (typeof _t.data('originText')=="undefined"){
			_t.data('originText', _tx);
		}else{
			_tx = _t.data('originText');
		}
		_t[0].nextSibling.innerHTML = _tx;
		if (_tx.indexOf(searchVal)==-1){
			_li.hide();
			return ;
		}else{
			// show parent menu
			_li.show();
			if (searchVal!=""){
				var _parentLi = _li.parent().closest('li');
				while(_parentLi.length>0 && _parentLi.closest('#navmenu').length>0 ){
					_parentLi.show();
					_parentLi = _parentLi.parent().closest('li');
				}
				_yellowtx = _tx.replace(searchVal, function(word){
					return "<b style='background-color:yellow;'>"+word+"</b>"
				});
				$(_t[0].nextSibling).remove();
				$("<span>"+_yellowtx+"</span>").insertAfter(_t);
				//$("<span>"+_yellowtx+"</span>").replaceWith(_t[0].nextSibling);
			}
		}
	});
	return ;
}
