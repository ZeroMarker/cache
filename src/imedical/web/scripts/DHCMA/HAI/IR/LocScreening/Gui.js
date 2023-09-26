//页面Gui
function InitLocScreeningWin(){
	var obj = new Object();
	
	//初始tab页签
	var tab = $('#divTabs').tabs('getSelected');
	var index = $('#divTabs').tabs('getTabIndex',tab);
	if (index==0) {
		LinkUrl = "dhcma.hai.ir.ccscreening.csp?&LocFlag=1";
		$("#TabMain").attr("src", LinkUrl);
	}
	
	InitLocScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


