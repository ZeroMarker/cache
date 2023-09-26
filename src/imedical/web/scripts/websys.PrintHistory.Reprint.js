// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function LookupSelectPrinter(str){
	var lu = str.split("^");
	var obj=document.getElementById('Printer');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('device');
	//if (obj) obj.value=lu[1];
	if (obj) obj.value=str;
	var objRecipient=document.getElementById('Recipient');
	if (objRecipient) {
		objRecipient.value= "";
	}
}


