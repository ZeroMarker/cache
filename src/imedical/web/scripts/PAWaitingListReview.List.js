// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	//alert("List");
	
	try {BodyLoadHandler();} catch(e) {} //From PAWaitingListReview.Edit.js 
	var df=document.forms;
	var tbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
	var f=document.getElementById("f"+df[df.length-1].id.substring(1,df[df.length-1].id.length))
	/*
	for (var i=1;i<tbl.rows.length;i++) {
		var temp=f.elements['WLRST_Codez'+i].value;
		if ((temp=="P")||(temp=="R")||(temp=="G")||(temp=="B")){
			DisableLink('WLRSTDescz'+i);
		}
	}
	*/
	
	// SA 20.8.03 - log 38085: Fixed disabling, was previously disabling incorrectly
	//KK 19/Mar/2003 Log 32884 - Disable Links based on ResponseRequired field in the ReviewStatus CT.
	var Resval="";
	var objRes=document.getElementById("WLRSTResponseRequired")
	if (objRes) Resval=objRes.value;
	//alert("Resval="+Resval);
	for (var i=1;i<tbl.rows.length;i++) {
		var temp=f.elements['WLRST_Codez'+i].value;
		var count=0;
		var Respond="";

		if (Resval.indexOf("^"+temp+"^")==-1) DisableLink('WLRSTDescz'+i);

		/*
		var bDisable=true;
		while ((mPiece(Resval,"^",count)!="")&&(bDisable)) {
			Respond=mPiece(Resval,"^",count);
			if (temp==Respond) bDisable=false;
			count=count+1;
		}
		if (bDisable) DisableLink('WLRSTDescz'+i);
		*/
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function DisableLink(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=LinkDisable
		fld.className = "disabledLink";
	}
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    } else {
	  return "";
    }
}


document.body.onload=DocumentLoadHandler;
