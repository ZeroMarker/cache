// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 12.10.04
var dtfrom=document.getElementById('RESDateActiveFrom')
var dtto=document.getElementById('RESDateTo')

function DocumentLoadHandler(e) {

	var obj=document.getElementById('RESDateActiveFrom')
	if (obj) obj.onchange = ActiveChangeHandler;
	
	var obj=document.getElementById('RESDateTo')
	if (obj) obj.onchange = ActiveChangeHandler;
	
	var obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
}

function LocationLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HOSPDesc");
    if (obj) obj.value=lu[4];
}

function ActiveChangeHandler() {
    var eSrc=websys_getSrcElement(e);
	
	if (eSrc.id=="RESDateActiveFrom") { RESDateActiveFrom_changehandler(e) }
	if (eSrc.id=="RESDateTo") { RESDateTo_changehandler(e)  }
	if ((dtfrom)&&(dtfrom.value!="")&&(dtto)&&(dtto.value!="")) {
	
	if (DateStringCompare(dtfrom.value,dtto.value)=="1") { 
		alert("\'" + t['RESDateTo']+ "\' " + t['XINVALID'] + "\n");
		}
	}
}

function UpdateHandler() {
	if (!ValidateUpdate()) return false;
	return update1_click();
}

function ValidateUpdate() {
	var isvalid=true;
	if ((dtfrom)&&(dtfrom.value!="")&&(dtto)&&(dtto.value!="")) {
	
	if (DateStringCompare(dtfrom.value,dtto.value)=="1") { 
		alert("\'" + t['RESDateTo']+ "\' " + t['XINVALID'] + "\n");
		isvalid=false
		}
		return isvalid
	}
    return isvalid;
}
document.body.onload=DocumentLoadHandler;