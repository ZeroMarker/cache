// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 30.1.03

function BodyLoadHandler()
{
	var obj=document.getElementById('update')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update']) websys_sckeys[tsc['update']]=UpdateHandler;
}

function UpdateHandler() {
	var obj=document.getElementById("BedIDs");
	var statcode=document.getElementById("StatusCode").value;
	// ab 21.05.03 - removed due to 35607
	/*if ((obj)&&(statcode=="A")) {
		if (obj.value=="") {
			alert(t["NoAcceptWard"]);
			return false;
		}
		var beds=obj.value.split("^");
		for (i=0; i<beds.length; i++) { 
			if (beds[i]=="") {
				alert(t["NoAcceptWard"]);
				return false;
			}
		}
	}*/
	return update_click();
}

function StatusLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("StatusCode");
	if (obj) obj.value=lu[1];
}

document.body.onload=BodyLoadHandler;

