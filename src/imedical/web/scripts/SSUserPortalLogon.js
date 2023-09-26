// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objUser=document.getElementById('USERNAME');
var objPswd=document.getElementById('PASSWORD');
var objDept=document.getElementById('DEPARTMENT');
var objRound=document.getElementById('ROUND');
var btnLogon=document.getElementById('Logon');

function BodyLoadHandler(){
	//need to call websys_setfocus to wait for elapse time to override setfocus called from scripts_gen
	if ((objUser)&&(objUser.value=='')) {
		websys_setfocus('USERNAME');
	} else if ((objPswd)&&(objPswd.value=='')) {
		websys_setfocus('PASSWORD');
	} else if ((objDept)&&(objDept.value=='')&&(!objDept.readOnly)&&(!objDept.disabled)) {
		websys_setfocus('DEPARTMENT');
	} else if ((objRound)&&(objRound.value=='')&&(!objRound.readOnly)&&(!objRound.disabled)) {
		websys_setfocus('ROUND');
	} else if (btnLogon) {
		websys_setfocus('Logon');
	}
}


function DepartmentLookUp(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('SSUSERGROUPDESC');
	if (obj) obj.value = lu[1];
	var obj=document.getElementById('Hospital');
	if (obj) obj.value = lu[2];

}

document.body.onload=BodyLoadHandler;


function Validate() {
	if ((objUser.value=='')||(objPswd.value=='') ) {
		alert('Please enter both:\nUsername\nPassword');
		if (f.USERNAME.value=='') {
			f.USERNAME.focus();
		} else {
			f.PASSWORD.focus();
		}
		event.cancelBubble;
		event.returnValue=false;
	}
}