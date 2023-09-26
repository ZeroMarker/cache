// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function UpdateClickHandler() {
	var PObj=document.getElementById("Params");
	var IPObj=document.getElementById("InsertParams");
	if((PObj)&&(PObj.value!="")&&(IPObj)) IPObj.value=PObj.value
	return Update_click();
}

