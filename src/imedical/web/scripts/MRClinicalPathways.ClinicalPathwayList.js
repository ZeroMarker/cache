// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//Log 56894 BoC 7/12/2006

function LookUpPathwaySelect(str) {
	var strArr=str.split("^");
	var probdescObj=document.getElementById("PathwayDesc");
	if (probdescObj&&strArr[1]) probdescObj.value=strArr[1];
}

function BodyOnloadHandler() {
	var obj=document.getElementById("CPWRowId");
	if (obj) obj.value="";
}

document.body.onload = BodyOnloadHandler;