var html = '<div id="TRAK_tabs" class="tabs-gray-btm"></div>'
var init = function(){
	$('body').css({"padding":0});
	$(html).appendTo('body');
	$("#TRAK_tabs").tabs({fit:true,tabHeight:30});
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
};
$(init);
function addTab(opt){
	var myTabsJObj = $("#TRAK_tabs");
	//code,url,title,forceRefresh
	var code = opt.code||opt.title;
	var url = opt.url;
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
		$("#"+title).css({overflow:"hidden"});
	}
}