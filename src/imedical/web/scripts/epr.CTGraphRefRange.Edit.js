// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function BodyLoadHandler()
{
	var obj=document.getElementById("ID");
	if (obj && obj.value==""){
		var objLnk=document.getElementById("defGraph");
		objLnk.disabled=true;
		objLnk.onclick = LinkDisable;
	}
}  // BodyLoadHandler


document.body.onload = BodyLoadHandler;
