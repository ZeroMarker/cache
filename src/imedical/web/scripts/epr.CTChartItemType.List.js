// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DescriptionLinkHander(e) {
	var eSrc=window.event.srcElement;
	if (eSrc.id!="") {
		eSrcAry=eSrc.id.split("z");
		if (eSrcAry[0]=="ListProfiles") {
			var url=document.getElementById("CITURLz"+eSrcAry[1]).value;
			var comp=document.getElementById("CITListProfileComponentz"+eSrcAry[1]).value;
			url=url+"?WEBSYS.TCOMPONENT="+comp+"&PPType="+document.getElementById("PPTypez"+eSrcAry[1]).value;
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			if (url) websys_createWindow(url, 'Profiles', 'top=20,left=20,width=600,height=400,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
			return false
		}
	}
}
if (document.getElementById('tepr_CTChartItemType_List')) document.getElementById('tepr_CTChartItemType_List').onclick=DescriptionLinkHander;

