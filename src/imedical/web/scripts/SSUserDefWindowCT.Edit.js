// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 9.05.06 52166

function BodyLoadHandler(e) {
	// disable code change if questionnare answered at least once
	var obj=document.getElementById("QuestAnswered");
	
	if ((obj)&&(obj.value==1)) {
		var objcode=document.getElementById("WINCode");
		if (objcode) objcode.disabled=true;
		var obj=document.getElementById("delete1");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		
	}
	
	// this is only used when creating a questionnaire
	var obj=document.getElementById("ID");
	var obj2=document.getElementById("EnableAudit");
	if ((obj)&&(obj2)&&(obj.value!="")) {
		obj2.checked=false;
		obj2.disabled=true;
	}
	
	var obj=document.getElementById("WINCode");
	if (obj) obj.maxLength=10;
	
	//var obj=document.getElementById("Generate");
	//if (obj) {
	//	obj.onclick=GenerateClickHandler;
	//}
	
}

/* ab 26.10.06 - generate button removed

function GenerateClickHandler() {
	// ab 18.09.06 60924 - dont disable buttons when 'required' message displays
	var capfields=new Array("cWINCode","cWINDesc","cWINGRPDesc","cWINScore");
	var fields=new Array("WINCode","WINDesc","WINGRPDesc","WINScore");
	var required=false;

	for (var i=0;i<fields.length;i++) {
		fld=document.getElementById(fields[i]);
		capfld=document.getElementById(capfields[i]);
		if ((fld)&&(capfld)&&(capfld.className=="clsRequired")&&(fld.value=="")) required=true;
	}

	if (!required) {
		var obj=document.getElementById("delete1");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById("update1");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}	
	
	return Generate_click();
}
*/

document.body.onload = BodyLoadHandler;
