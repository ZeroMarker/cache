// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var ALGForm=document.forms["fOEOrder_Allergy"];
var MSGForm=document.forms["fOEOrder_OEMessages"];
var QUESForm=document.forms["fOEORDER_Questions"];	
var DSSForm=document.forms["fOEOrder_DSSMessage"];	
function UpdateClickHandler() {
	return Update_click();
}
function BodyLoadHandler() {
	if (ALGForm) {
		var upobj=ALGForm.document.getElementById("Update");
		if (upobj) upobj.onclick=UpdateClickHandler;
	}
}
