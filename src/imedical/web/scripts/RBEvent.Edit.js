// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function Init() {
}

function EventVenueLookUp(str) {
 	//alert (str)
 	var lu = str.split("^");
	var bobj;
	bobj=document.getElementById("RESDesc")
	if (bobj) bobj.value = lu[0]
	bobj=document.getElementById("RESRowId")
	if (bobj) bobj.value = lu[2]
}
document.body.onload=Init;
