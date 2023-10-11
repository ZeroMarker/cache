var tabHeight = 30;
var style = "";
if (window.HISUIStyleCode && window.HISUIStyleCode=='lite'){
	style = '<style >.tabs li{height:'+(tabHeight-1)+'px;}</style>'
}
var html = '<div id="TRAK_tabs" '+(window.HISUIStyleCode!=='lite'?'class="tabs-gray-btm"':'')+'></div>\
	<div id="mm" class="cs-tab-menu">\
        <div class="menu-sep" ></div>\
        <div id="mm-tabclose" onclick="tabCloseEven.tabclose();">关闭</div>\
        <div id="mm-tabcloseother" onclick="tabCloseEven.tabcloseother();">关闭其他</div>\
        <div id="mm-tabcloseall" onclick="tabCloseEven.tabcloseall();">关闭全部</div>\
    </div>';
function tabClose() {
    $('.tabs-header').on('contextmenu','.tabs-inner',function(e){
        e.preventDefault();
        var subtitle =$(this).children(".tabs-title").text();    //不嫩用.tabs-closable
        //做一些右键菜单的禁用启用
        if (subtitle=="首页"){
            $('#mm').menu('disableItem',$('#mm-tabupdate')[0]);
            $('#mm').menu('disableItem',$('#mm-tabclose')[0]);
        }else{
            $('#mm').menu('enableItem',$('#mm-tabupdate')[0]);
            $('#mm').menu('enableItem',$('#mm-tabclose')[0]);
        }
        var leftnum=$('.tabs-selected').prevAll().length;
        if(leftnum>1){  //有个首页 要大于1
            $('#mm').menu('enableItem',$('#mm-tabcloseleft')[0]);
        }else{
            $('#mm').menu('disableItem',$('#mm-tabcloseleft')[0]);
        }
        var rightnum=$('.tabs-selected').nextAll().length;
        if(rightnum>0){
            $('#mm').menu('enableItem',$('#mm-tabcloseright')[0]);
        }else{
            $('#mm').menu('disableItem',$('#mm-tabcloseright')[0]);
        }

        if (leftnum>1 || rightnum>0 ){
            $('#mm').menu('enableItem',$('#mm-tabcloseother')[0]);
        }else{
            $('#mm').menu('disableItem',$('#mm-tabcloseother')[0]);
        }
        $('#mm').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
        $('#mm').data("currtab",subtitle);
        $('#TRAK_tabs').tabs('select',subtitle);
        return false;
    });
}
function isClosableTab(tabtitle){
	var t = $('#TRAK_tabs').tabs('getTab',tabtitle);
	if (t && 'function'==typeof t.panel) return t.panel('options').closable;
	return false;
}
var closeTabInClosable = function(title){
	if (isClosableTab(title)){
		 $('#TRAK_tabs').tabs('close',title);
		 return true;
	}
	return false;
}
//绑定右键菜单事件   
var tabCloseEven= {
    //关闭当前
    tabclose:function(){
        var currtab_title = $('#mm').data("currtab");
        closeTabInClosable(currtab_title);
    },
    //全部关闭
    tabcloseall:function(){
        $('#TRAK_tabs>.tabs-header>.tabs-wrap>ul>li span.tabs-title').each(function(i,n){
            var t = $(n).text();
            if(i != 0) {
                closeTabInClosable(t);
            }
        });
    },
    //关闭除当前之外的TAB
    tabcloseother:function(){
        var prevall = $('.tabs-selected').prevAll();
        var nextall = $('.tabs-selected').nextAll();		
        if(prevall.length>0){
            prevall.each(function(i,n){
                var t=$('a:eq(0) span',$(n)).text();
                closeTabInClosable(t);
            });
        }
        if(nextall.length>0) {
            nextall.each(function(i,n){
                var t=$('a:eq(0) span',$(n)).text();
                closeTabInClosable(t);
            });
        }
         //需要重新选中当前
         $('#TRAK_tabs').tabs('select',$('#mm').data('currtab'));
        return false;
    },
    //关闭当前右侧的TAB
    tabcloseright:function(){
        var nextall = $('.tabs-selected').nextAll();
        if(nextall.length==0){
            return false;
        }
        nextall.each(function(i,n){
            var t=$('a:eq(0) span',$(n)).text();
            closeTabInClosable(t);
        });
        //需要重新选中当前
        $('#TRAK_tabs').tabs('select',$('#mm').data('currtab'));

        return false;
    },
    //关闭当前左侧的TAB
    tabcloseleft:function(){
        var prevall = $('.tabs-selected').prevAll();
        if(prevall.length==0){
            return false;
        }
        prevall.each(function(i,n){
            var t=$('a:eq(0) span',$(n)).text();
            closeTabInClosable(t);
        });
        //需要重新选中当前
        $('#TRAK_tabs').tabs('select',$('#mm').data('currtab'));
        return false;
    },
    //退出
    exit:function(){
        $('#mm').menu('hide');
    }
}
function clearRAM(frmId,frm) {
	try{
		var frame = null ;
		if (frm){
			frame = frm;
		}else{
			frame = document.getElementById(frmId);
		}
		if (frame.contentWindow.onbeforeunload){
			var oldOnbeforeunload = frame.contentWindow.onbeforeunload;
			var rtn = frame.contentWindow.onbeforeunload.call(window);
			if (rtn) {
				var sure = window.confirm(rtn);
				if (!sure){
					frame.contentWindow.onbeforeunload = oldOnbeforeunload;
					return false;
				}
			}
			frame.contentWindow.onbeforeunload = null;
		}
		frame.src = 'about:blank';
		frame.contentWindow.document.write('');//清空frame的内容
		frame.contentWindow.document.clear();
		frame.contentWindow.close(); //避免frame内存泄漏
		if (navigator.userAgent.indexOf('MSIE') >= 0) {
			if (CollectGarbage) {
				CollectGarbage(); //IE 特有 释放内存
				//删除原有标记
				frame.parentElement.removeChild(frame);
				//添加frameset框架
				/*var _frame = document.createElement('frame');
				_frame.src = '';
				_frame.name = 'content';
				_frame.id = 'ifr_content';
				tags.appendChild(_frame);*/
			}
		}
		return true;
	}catch(ex){return true;}
}
/**
* @param {iframe} win        iframe|window
* @param {String} funName    function name
*/
function getFrameFun(ifrm,funName){
	var fun = "";
	if ("function" === typeof ifrm[funName]){
		fun = ifrm[funName]; 
	}else if (ifrm.contentWindow && "function" === typeof ifrm.contentWindow[funName]){
		fun = ifrm.contentWindow[funName];
	}
	if(fun) {return fun;}
	return null;
}
var init = function(){
	$('body').css({"padding":0});
	if (style) $(style).appendTo('body');
	$(html).appendTo('body');
	$("#mm").menu();
	$("#TRAK_tabs").tabs({
		fit:true,
		border:false, /*2930922*/
		tabHeight:tabHeight,
		onBeforeClose:function(title,index){
			var target = this;
			var tab = $(target).tabs("getTab",title);
			var iframe = tab.find("iframe").get(0);
			if ( iframe ){
				var onBeforeCloseTab = getFrameFun(iframe,"onBeforeCloseTab");
				if(onBeforeCloseTab) {
					//如果返回false,不切换Chart
					if (!onBeforeCloseTab()){return false;};	
			    }
			}
			var iframe = tab.find("iframe").get(0);
			if ( iframe ){
			    return clearRAM("",iframe);		
			}
			return true;
		}
	});
	var mwin = websys_getMenuWin();
	if (req['homeTab']) { mwin.homeTab = req['homeTab'];}
	if (mwin.homeTab){
		var arr = mwin.homeTab.split("$");
		var homeTabUrl = arr[0]||"websys.home.csp";
		var homeTabTitle = arr[1]||"home";
	}else{
		var homeTabUrl = "websys.home.csp";
		var homeTabTitle = "home";
	}
	addTab({
		code:"home",
		url:homeTabUrl,
		title:homeTabTitle,
		valueExp:"",
		closable:false
	});
	$("#home").css({overflow:"hidden"});
	tabClose();
};
$(init);
function addTab(opt){
	var myTabsJObj = $("#TRAK_tabs");
	//code,url,title,forceRefresh
	var code = opt.code||opt.title;
	var url = opt.url;
	if ('function'==typeof websys_writeMWToken) url = websys_writeMWToken(url);
	var title = opt.title;
	if ("undefined"==typeof opt.closable) opt.closable=true;
	if (myTabsJObj.tabs("exists",title)){
		var curSelTab = myTabsJObj.tabs("getSelected");
		if (curSelTab.panel('options').title!==title){
			myTabsJObj.tabs('select',title);
		}else{
			websys_cancel(); return false;
		}
	}else{
		var tabOpt = {
			id:code, 
			title:opt.title,
			closable:opt.closable,
			ilink:url,
			isxhr:true,
			valueExp:opt.valueExp,
			content:'<iframe id="i'+code+'" name="i'+code+'" src="'+url+'" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		};
		myTabsJObj.tabs("add",tabOpt);
		var titleSelector = document.getElementById(title); 
		$(titleSelector).css({overflow:"hidden"});
	}
}