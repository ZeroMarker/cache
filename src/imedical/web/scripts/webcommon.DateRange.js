// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//KM 13-Sept-2001: Corrisponding component is called form RBDeptFuncPrefrences.Custom.js
function updateHandler() {
	var id=document.getElementById("ID").value;
	var dfrom=document.getElementById("dfrom").value;
	var dto=document.getElementById("dto").value;
	try {window.opener.DatesHandler(id,dfrom,dto);} catch(e) {}
}
var obj=document.getElementById("update1");
if (obj) obj.onclick=updateHandler;