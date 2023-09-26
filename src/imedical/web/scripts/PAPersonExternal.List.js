//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler() {
	var tbl=document.getElementById("tPAPersonExternal_List");
    
	// ab 28.06.05 - 54053 - disable next button if matches exhausted
	var objCurr=document.getElementById("CurrRows");
	var objMax=document.getElementById("recrtn");
	var objNext=document.getElementById("NextMatch");
	if ((objCurr)&&(objMax)) {
		
		if (eval(objCurr.value)>=eval(objMax.value)) {
			objNext.disabled=true;
			objNext.onclick=LinkDisable;
		}
		if (objMax.value=="") {		// cjb 04/08/2006 60139 - disable this link if recrtn is null
			objNext.disabled=true;
			objNext.onclick=LinkDisable;
		}
	}
	
	// ab 10.04.06 58685 - if clicked through the 'external number' link on PAPerson.List, disable all reg/mr numbers except the current one
	var objOrigPatID=document.getElementById("OrigPatID");
	var objOrigRegNo=document.getElementById("OrigRegNo");
	for (var i=1;i<tbl.rows.length;i++) {
		if ((objOrigPatID)&&(objOrigRegNo)&&(objOrigPatID.value!="")&&(objOrigRegNo.value!="")) {
			var objReg=document.getElementById("RegistrationNoz"+i);
			if (objReg) {
				if (objReg.innerText!=objOrigRegNo.value) {
					objReg.onclick=LinkDisable;
					objReg.disabled=true;
					var obj=document.getElementById("RTMAS_MRNoz"+i);
					if (obj) {
						obj.onclick=LinkDisable;
						obj.disabled=true;
					}
					var obj=document.getElementById("CDNz"+i);	// cjb 04/08/2006 60139 - disable this link too as it's pointless opening RTMaster.MRTypeList without a PatientID...
					if (obj) {
						obj.onclick=LinkDisable;
						obj.disabled=true;
					}
				}
			}
		}
		var objID=document.getElementById("IDz"+i);		// cjb 04/08/2006 60139 - disable this link too as it's pointless opening RTMaster.MRTypeList without a PatientID...
		if ((objID)&&(objID.value=="")) {
			var obj=document.getElementById("CDNz"+i);
			if (obj) {
				obj.onclick=LinkDisable;
				obj.disabled=true;
			}
			
		}
		
	}
}

function LinkDisable() {
	return false;
}

document.body.onload=DocumentLoadHandler