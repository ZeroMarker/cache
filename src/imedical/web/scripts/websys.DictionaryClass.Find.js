// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function clsnameSelect(str) {
 	var lu = str.split("^");
 	//set one and clear the others
	var obj=document.getElementById("clsname");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("tblname");
	if (obj) obj.value='';
	var obj=document.getElementById("displayname");
	if (obj) obj.value='';
}
function tblnameSelect(str) {
 	var lu = str.split("^");
 	//set one and clear the others
	var obj=document.getElementById("clsname");
	if (obj) obj.value='';
	var obj=document.getElementById("tblname");
	if (obj) obj.value=lu[2];
	var obj=document.getElementById("displayname");
	if (obj) obj.value='';
}
function displaynameSelect(str) {
 	var lu = str.split("^");
 	//set one and clear the others
	var obj=document.getElementById("clsname");
	if (obj) obj.value='';
	var obj=document.getElementById("tblname");
	if (obj) obj.value='';
	var obj=document.getElementById("displayname");
	if (obj) obj.value=lu[3];
}









