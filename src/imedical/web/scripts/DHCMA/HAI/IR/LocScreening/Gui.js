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
	
	var ICUType = $m({
		ClassName: "DHCHAI.BTS.LocationSrv",
		MethodName: "GetLocICUType",
		aHospID:$.LOGON.HOSPID,
        aLocID:$.LOGON.LOCID,
	}, false);
    //ICU
	if(ICUType==1) {
		$('#divTabs').tabs('getTab',"ICU日志").panel('options').tab.show();//显示tab表头
		$('#divTabs').tabs('getTab',"三管感染防控督查表").panel('options').tab.show();//显示tab表头
		$('#divTabs').tabs('getTab',"ICU患者危险等级登记表").panel('options').tab.show();//显示tab表头
		$('#divTabs').tabs('getTab',"NICU日志").panel('options').tab.hide();//隐藏tab表头
		//$('#divTabs').tabs('getTab',"NICU插拔管评估").panel('options').tab.hide();//隐藏tab表头
	} else if(ICUType==2) { //NICU
		$('#divTabs').tabs('getTab',"ICU日志").panel('options').tab.hide();//隐藏tab表头
		$('#divTabs').tabs('getTab',"三管感染防控督查表").panel('options').tab.hide();//隐藏tab表头
		$('#divTabs').tabs('getTab',"ICU患者危险等级登记表").panel('options').tab.hide();//隐藏tab表头
		$('#divTabs').tabs('getTab',"NICU日志").panel('options').tab.show();//显示tab表头
		//$('#divTabs').tabs('getTab',"NICU插拔管评估").panel('options').tab.hide();//隐藏tab表头
	} else if(ICUType==3) { //ICU、NICU
		$('#divTabs').tabs('getTab',"ICU日志").panel('options').tab.show();//显示tab表头
		$('#divTabs').tabs('getTab',"三管感染防控督查表").panel('options').tab.show();//显示tab表头
		$('#divTabs').tabs('getTab',"ICU患者危险等级登记表").panel('options').tab.show();//显示tab表头
		$('#divTabs').tabs('getTab',"NICU日志").panel('options').tab.show();//显示tab表头
		//$('#divTabs').tabs('getTab',"NICU插拔管评估").panel('options').tab.hide();//隐藏tab表头
	} else {  //非ICU
		$('#divTabs').tabs('getTab',"ICU日志").panel('options').tab.hide();//隐藏tab表头
		$('#divTabs').tabs('getTab',"ICU患者危险等级登记表").panel('options').tab.hide();//隐藏tab表头
		$('#divTabs').tabs('getTab',"三管感染防控督查表").panel('options').tab.hide();//隐藏tab表头
		$('#divTabs').tabs('getTab',"NICU日志").panel('options').tab.hide();//隐藏tab表头
		//$('#divTabs').tabs('getTab',"NICU插拔管评估").panel('options').tab.hide();//隐藏tab表头
	}

	InitLocScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


