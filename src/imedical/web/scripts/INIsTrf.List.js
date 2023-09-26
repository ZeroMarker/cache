// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tINIsTrf_List");

function BodyLoadHandler(){
	var sobj="";
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			sobj=document.getElementById("INITAcknowCompletedz"+i);
			if(sobj) {
				sobj.disabled=true;
				sobj.onclick=returnFalse
			}
		}
	}
	var changeLoc=document.getElementById("changeLoc");
	if (changeLoc && changeLoc.value!="Y") {
		var reqLoc=document.getElementById("reqLoc");
		if (reqLoc) reqLoc.readOnly=true;
		var arrLookUps=document.getElementsByTagName("IMG");
		for (var i=0; i<arrLookUps.length; i++) {
			if ((arrLookUps[i].id)&&(arrLookUps[i].id.indexOf("reqLoc")>=0))
				arrLookUps[i].disabled=true;
		}
	}
}

function returnFalse(){
	return false;
}

function refresh() {
	/*var reqDateFrom=document.getElementById("reqDateFrom");
	var reqDateTo=document.getElementById("reqDateTo");
	var trDateFrom=document.getElementById("trDateFrom");
	var trDateTo=document.getElementById("trDateTo");
	var supLoc=document.getElementById("supLoc");
	var reqloc=document.getElementById("reqLoc");
	var undelivered=document.getElementById("undelivered");
	var transferID=document.getElementById("transferID");
	var requestID=document.getElementById("requestID");
	var partDelivered=document.getElementById("partDelivered");
	var complete=document.getElementById("complete");
	var url= "websys.default.csp?WEBSYS.TCOMPONENT=INIsTrf.List";
	if (reqDateFrom && reqDateFrom.value!="") url=url+"&reqDateFrom="+reqDateFrom.value;
	if (reqDateTo && reqDateTo.value!="") url=url+"&reqDateTo="+reqDateTo.value;
	if (trDateFrom && trDateFrom.value!="") url=url+"&trDateFrom="+trDateFrom.value;
	if (trDateTo && trDateTo.value!="") url=url+"&trDateTo="+trDateTo.value;
	if (supLoc && supLoc.value!="") url=url+"&supLoc="+supLoc.value;
	if (reqloc && reqloc.value!="") url=url+"&reqloc="+reqloc.value;
	if (undelivered && undelivered.value!="") url=url+"&undelivered="+undelivered.value;
	if (transferID && transferID.value!="") url=url+"&transferID="+transferID.value;
	if (requestID && requestID.value!="") url=url+"&requestID="+requestID.value;
	if (partDelivered && partDelivered.value!="") url=url+"&partDelivered="+partDelivered.value;
	if (complete && complete.value!="") url=url+"&complete="+complete.value;
	alert("url: "+url);
	window.open(url,'TRAK_main');*/
	var find=document.getElementById("find");
	if (find) find.click();
}

document.body.onload = BodyLoadHandler;