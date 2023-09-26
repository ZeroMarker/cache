// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//KK 14/Nov/2002 Log 28206
function FindHandler(){
	var component = "PAPMIUpdate.ListRejectToHomer";
	var str ="&PMIRego="+document.getElementById("PMIRego").value+"&PAPMIName="+document.getElementById("PAPMIName").value+"&PAADMADMNo="+document.getElementById("PAADMADMNo").value
	window.open("websys.default.csp?WEBSYS.TCOMPONENT="+component+str,"ListRejectToHomer","");
	return false;
}

function docLoadHandler() {
	var obj = document.getElementById("find1");
	if (obj) obj.onclick=FindHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindHandler;
}

document.body.onload=docLoadHandler;

