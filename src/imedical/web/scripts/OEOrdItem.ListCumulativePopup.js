// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function GrabReadResults() {
	var objtbl=document.getElementById("tOEOrdItem_ListLabCummEMR");
	var allread = "";
	var allreadCummID = "";  // Log 51467 YC - keep checkbox values
	var actionbuffer = "";
	if (objtbl) {
		var arrInput=objtbl.getElementsByTagName("INPUT");
		var actcomment=document.getElementById("OEORIResultComments");
		var actdesc=document.getElementById("ACTDesc");
		for (var i=0;i<arrInput.length; i++) {
			var nametmp = arrInput[i].name.split("z")
			if ((nametmp[0]=="CummID")&&(arrInput[i].checked)) {
					allread = allread + arrInput[i].id + "^";
					allreadCummID = allreadCummID + arrInput[i].name + "^"; // Log 51467 YC - keep checkbox values
					actionbuffer = actionbuffer + actdesc.value + "*" + actcomment.value + "^";
			}
		}
		var reslist = document.getElementById("ResultList");
		if (reslist) { reslist.value = allread;}
		 // Log 51467 YC - keep checkbox values
		var CummIDList = document.getElementById("CummIDList");
		if (CummIDList) CummIDList.value=allreadCummID;
		var actlist = document.getElementById("ResultActionsList");
		if (actlist) { actlist.value = actionbuffer;}
	}
	return true;
}

function UpdateClickHandler(e) {
	var obj=document.getElementById("Read");
	if ((obj)&&(obj.disabled)) {
		return false
	}

	if (GrabReadResults()) {
		// Log 48039 YC - Makes epr chart the opener of the cumulative popup window so that it will refresh the
		// epr chart (when websys.reload.csp is called) and close all other windows.
		if(window.opener.window.opener) {
			if(window.opener.opener.name=="dataframe")
				window.opener=window.opener.opener;
			else if(window.opener.opener.opener)
				if(window.opener.opener.opener.name=="dataframe")
					window.opener=window.opener.opener.opener;
		}
		
		return Read_click();
	}	
}

var obj=document.getElementById("Read");
if (obj) {
	obj.onclick = UpdateClickHandler;
}

// Log 51467 YC - populates checkbox values if wrong password is entered
var reslist = document.getElementById("CummIDList");
if (reslist) { 
	var arrRes = reslist.value.split("^");
	for(i=0;i<(arrRes.length-1);i++) { 
		var cummObj = document.getElementById(arrRes[i]);		
		if(cummObj) cummObj.checked=true;
	}
}