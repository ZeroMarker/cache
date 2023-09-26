// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function SNAPEditBodyLoadHandler() {
	
	var obj = document.getElementById("update1");
	//var obj = document.forms['fPAAdmSNAP_Edit'].elements['update1'];
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
}

function UpdateClickHandler() {
	
	if (window.opener) {
		if (window.opener.document.forms['fPAAdm_Edit']) {
			var doc=window.opener.document;
			var obj=doc.getElementById("SNAPScreen");
			if (obj) {
			obj.style.fontWeight="bold";
			       	}
			}
		if (window.opener.document.forms['fPAADMDischarge_Edit']) {
			var doc=window.opener.document;
			var obj=doc.getElementById("SNAPScreen");
			if (obj) {
			obj.style.fontWeight="bold";
			       	}
			}
		}
   var obj=document.forms['fPAAdmSNAP_Edit'].elements['TWKFLI'];
   if (obj) obj.value-=1;		
   return update1_click();
}

document.body.onload=SNAPEditBodyLoadHandler;
