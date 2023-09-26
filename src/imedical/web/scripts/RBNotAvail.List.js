// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var TDIRTY=0;

function BodyLoadHandler() {
		
	var objP = document.getElementById("ProgressWithAction")
	if (objP) objP.onclick = PRUpdateClickHandler;
	if (tsc['ProgressWithAction']) websys_sckeys[tsc['ProgressWithAction']]=PRUpdateClickHandler;
	window.focus();
}

function PRUpdateClickHandler() {
		var frm=document.forms['fRBNotAvail_List']
		if (window.opener) {
			var doc=window.opener.document;
			if (window.opener.document.forms['fRBNotAvail_Edit']) {
		        	window.opener.document.forms['fRBNotAvail_Edit'].elements['reviewprogress'].value=0;
				var objMasterU=window.opener.document.getElementById("update1");
				var evt = window.opener.document.createEventObject();
				if (objMasterU) {
				objMasterU.fireEvent('onclick',evt);
				}
			}	
			
		}
   return true;
}

document.body.onload=BodyLoadHandler;
