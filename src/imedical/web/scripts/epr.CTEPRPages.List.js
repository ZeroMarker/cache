// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.fepr_CTEPRPages_List;
function ListProfileLinkHander(e) {
	var eSrc=window.event.srcElement;
	if (eSrc.id!="") {
		eSrcAry=eSrc.id.split("z");
		if (eSrcAry[0]=="Description") {
			var url="websys.default.csp"
			var comp="epr.CTEPRPages.Edit"
			url=url+"?WEBSYS.TCOMPONENT="+comp+"&ID="+f.elements["IDz"+eSrcAry[1]].value;
			if (url) websys_createWindow(url, 'Profile', 'top=30,left=30,width=400,height=350,scrollbars=yes');
			return false
		}
	}
}

if (document.getElementById('tepr_CTEPRPages_List')) document.getElementById('tepr_CTEPRPages_List').onclick=ListProfileLinkHander;
//window.onload=websys_reSize;
window.onunload=websys_closeWindows;
