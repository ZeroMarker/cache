
///clickOnce打印方式
///20170724 songchao
function showOtherSingleSheet(orderItemIdStr, seqNoStr, webIp,  xmlName){
	var webIp = tkMakeServerCall("Nur.DHCMGNurseSet", "getSet").split("^")[1];
	var ServerIP =webIp
	if(ServerNameSpace){
		var httpHead=webIp.split("://")[0];
		var ServerIP = httpHead+"://"+ServerNameSpace.split(":")[1].split("[")[0];
		//ServerIP = "http://"+ServerNameSpace.split(":")[1].split("[")[0];
	}
	var link = ""
		link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showOtherSingleSheet&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr  + "&webIp=" + ServerIP + "&xmlName=" + xmlName;
	if(parent.parent.frames["TRAK_main"]){
		parent.parent.frames["TRAK_main"].location = link;
	}else{
		window.open(link,"", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	}
}

///封装clickonce调用方法
///20170727 Songchao
function showNurseExcuteSheetPreview(orderItemIdStr, seqNoStr, type, queryCode, webIp, savePrintHistory, printNum, xmlName) {
	var webIp = tkMakeServerCall("Nur.DHCMGNurseSet", "getSet").split("^")[1];
	var ServerIP =webIp
	if(ServerNameSpace){
		var httpHead=webIp.split("://")[0];
		var ServerIP = httpHead+"://"+ServerNameSpace.split(":")[1].split("[")[0];
	}
	var link = ""
		link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showNurseExcuteSheetPreview&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr + "&type=" + type + "&queryCode=" + queryCode + "&webIp=" + ServerIP
		 + "&savePrintHistory=" + savePrintHistory + "&printNum=" + printNum + "&xmlName=" + xmlName;

    window.open(link,'', 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
/*
	if(parent.parent.parent.frames["TRAK_main"]){
		parent.parent.parent.frames["TRAK_main"].location =link;
	}else{
		window.open(link,"", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	}*/
}


///clickOnce打印方式
///20170724 songchao
function showSJD(orderItemIdStr, seqNoStr, webIp,  xmlName){
	var webIp = tkMakeServerCall("Nur.DHCMGNurseSet", "getSet").split("^")[1];
	var ServerIP =webIp
	if(ServerNameSpace){
		var httpHead=webIp.split("://")[0];
		var ServerIP = httpHead+"://"+ServerNameSpace.split(":")[1].split("[")[0];
		//ServerIP = "http://"+ServerNameSpace.split(":")[1].split("[")[0];
	}
	var link = ""
		link = webIp + "/DHCMG/NurseExcute/DHCCNursePrintComm.application?method=showSJD&orderItemIdStr=" + orderItemIdStr
		 + "&seqNoStr=" + seqNoStr  + "&webIp=" + ServerIP + "&xmlName=" + xmlName;
	if(parent.parent.frames["TRAK_main"]){
		parent.parent.frames["TRAK_main"].location = link;
	}else{
		window.open(link,"", 'height=20, width=30, top=20, left=30, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	}
}

