// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var obj=document.getElementById("OEORIDepProcNotes")
if (obj) {
	ReadOnly(obj);
}


function ReadOnly(obj) {
	obj.readOnly=true;
	obj.style.color="gray";
}

