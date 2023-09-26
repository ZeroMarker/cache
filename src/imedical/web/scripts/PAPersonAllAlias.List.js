// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	websys_firstfocus();
	assignClickHandler();

	var obj;



}


function assignClickHandler() {

	var obj=document.getElementById("update1");
	obj.onclick = UpdateHandler;
	return;
}




function UpdateHandler() {
	//websys_isInUpdate=true;

	;
	//alert("chris");
	return update1_click();
}




document.body.onload=Init;