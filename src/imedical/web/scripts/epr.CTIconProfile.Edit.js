// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 7.03.07 61960

var CTICON_LINK="";
var obj=document.getElementById("CTIconPref");
if (obj) CTICON_LINK=obj.onclick;

function BodyLoadHandler() {
	var obj=document.getElementById("ProfileCTIcons");
	if (obj) obj.onclick=CheckExcludeIcons;
	CheckExcludeIcons();
	
	var obj=document.getElementById("BoldLink");
	var objlink=document.getElementById("CTIconPref");
	if ((obj)&&(objlink)&&(obj.value!=0)&&(obj.value!="")) {
		objlink.style.fontWeight="bold";
	}
	
	
}

function CheckExcludeIcons() {
	var obj=document.getElementById("ProfileCTIcons");
	var objlink=document.getElementById("CTIconPref");
	var objid=document.getElementById("ExcludeID");
	
	if ((objid)&&(objid.value=="")&&(objlink)) {
		objlink.disabled=true;
		objlink.onclick=LinkDisable;
		return;
	}
	
	if ((obj)&&(objlink)) {
		if (obj.checked==true) {
			objlink.disabled=true;
			objlink.onclick=LinkDisable;
		} else {
			objlink.disabled=false;
			objlink.onclick=CTICON_LINK;
		}
	}
}

document.body.onload=BodyLoadHandler;
