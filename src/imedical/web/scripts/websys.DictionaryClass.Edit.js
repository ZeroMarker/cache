// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var obj=document.getElementById("SQLTableName");
//if (obj) {obj.setAttribute("readonly",true);}
if (obj) {obj.readOnly=true;}

function ClassNameSelect(str) {
 	var lu = str.split("^");
 	//set one and clear the others
	var obj=document.getElementById("ClassName");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("SQLTableName");
	if (obj) obj.value=lu[1];
}








