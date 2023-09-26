// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var timerenabled=true;
function StayOnTop() {
	this.focus();
	if (timerenabled) {
		window.setTimeout(StayOnTop,500);
	}
}
function LoadHandler() {
	StayOnTop();
}
function DisableOnTop() {
	timerenabled=false;
}

//refocusing doesn't seem to work correctly to allow input into field
//focus on first time load only
this.focus();

function GroupLookUpSelect(str) {
	var str=str.split("^");
	var GrpDObj=document.getElementById('GroupDesc');
	var GrpidObj=document.getElementById('GroupID');
	if (GrpDObj) GrpDObj.value=str[1];
	if (GrpidObj) GrpidObj.value=str[0];
}

function UpdateClickHandler(e) {
	var GrpDObj=document.getElementById('GroupDesc');
	var GrpidObj=document.getElementById('GroupID');
	var win = window.opener;
	if (win) {
		var SSGrpDObj = win.document.getElementById('SSUSERGROUPDESC');
		var SSGrpidObj = win.document.getElementById('SSUSERGROUPID');	
	}
	if (SSGrpDObj && GrpDObj) SSGrpDObj.value=GrpDObj.value;
	if (SSGrpidObj && GrpidObj) SSGrpidObj.value=GrpidObj.value;
	window.close();
	return Update1_click();
}

var obj=document.getElementById('Update1');
if (obj) obj.onclick = UpdateClickHandler;
