// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var obj=document.getElementById("OEORIRemarks")
if (obj) {
	ReadOnly(obj);
}


function ReadOnly(obj) {
	obj.readOnly=true;
	obj.style.color="gray";
}

