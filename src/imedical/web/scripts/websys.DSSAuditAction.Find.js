// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// ab 16.10.06

function DocumentLoadHandler() {
	var obj=document.getElementById("UserName");
	if (obj) obj.onblur=UserNameBlurHandler;
}

function UserNameBlurHandler() {
	var obj=document.getElementById("UserName");
	var obj2=document.getElementById("User");
	if ((obj)&&(obj2)&&(obj.value=="")) obj2.value="";
}

function UserNameLookup(str) {
	var lu=str.split("^");
	var obj=document.getElementById("User");
	if (obj) obj.value=lu[1];
}

document.body.onload=DocumentLoadHandler;
