// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 9.1.03

var linkvar;

function BodyOnloadHandler()
{
	var id=document.getElementById("ID");
	var tree=document.getElementById("FromTree");
	
	if ((id)&&(id.value=="")&&(tree)&&(tree.value==1)) {
		var obj=document.getElementById("new1");
		if (obj) {
			linkvar=obj.href;
			obj.onclick=OpenNewWindow;
		}	}
	
	return;
}

document.body.onload = BodyOnloadHandler;

function OpenNewWindow() {
	websys_createWindow(linkvar);
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}