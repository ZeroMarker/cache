// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tINIsTrf_Edit");
var updated=false;

function BodyLoadHandler(){
	var ackAll=document.getElementById("ackAll");
	var update=document.getElementById("update");
	var complete=document.getElementById("INITAcknowCompleted");
	
	if (ackAll) ackAll.onclick=AckAllClickHandler;
	if (update) update.onclick=UpdateClickHandler;
	if (complete) disableAll();
}

function BodyUnloadHandler(){
	var par_win=window.opener;
	if (updated && par_win) par_win.refresh();
}

function AckAllClickHandler() {
	var hid="";
	var ackQty="";
	
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			hid=document.getElementById("hidTrfQtyz"+i);
			ackQty=document.getElementById("ackQtyz"+i);
			if (hid && ackQty) ackQty.value=hid.value;
		}
	}

	return false;
}

function UpdateClickHandler() {
	var ids="";
	var qtys="";
	var rowid="";
	var ack="";
	var trf="";
	
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			trf=document.getElementById("hidTrfQtyz"+i);
			ack=document.getElementById("ackQtyz"+i);
	
			if (trf && ack && (ack.value-trf.value)>0) {
				alert(t['EXCEED_QTY']);
				ack.focus();
				return false;
			}
			
			rowid=document.getElementById("rowidz"+i);
			if (rowid && ack && rowid.value!="") {
				ids=ids+rowid.value+"^";
				qtys=qtys+ack.value+"^";
			}
		}
	}
	
	var itemIDs=document.getElementById("itemIDs");
	var ackqtys=document.getElementById("qtys");
	if (itemIDs) itemIDs.value=ids;
	if (ackqtys) ackqtys.value=qtys
	
	updated=true;
	update_click();
}

function disableAll() {
	var complete=document.getElementById("INITAcknowCompleted");

	if(complete && complete.checked) {
		var arrFields=document.getElementsByTagName("INPUT");
		var arrLookUps=document.getElementsByTagName("IMG");
		var ackall=document.getElementById("ackAll");
		
		for (var i=0; i<arrFields.length; i++) {
			if (arrFields[i].type!="hidden" && arrFields[i].id!=("INITAcknowCompleted"))
				arrFields[i].disabled=true;
		}
	
		for (var i=0; i<arrLookUps.length; i++) {
			if ((arrLookUps[i].id)&&(arrLookUps[i].id.indexOf("ld")==0))
				arrLookUps[i].disabled=true;
		}
		
		if (ackall) ackall.disabled=true;
	}
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnloadHandler;