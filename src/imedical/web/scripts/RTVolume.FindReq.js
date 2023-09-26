// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var tbl=document.getElementById("tRTVolume_FindReq");

function SelectAll(evt) {
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if (sobj) sobj.checked=true;
		}
	}
	return false;
}

//if (parent.frames["FindMRRequestList"])	document.forms['fRTVolume_List'].target="_parent";
function Update_ClickHandler(evt) {
	var tbl=document.getElementById("tRTVolume_FindReq");
	var ids="";
	var mvid="";
	var id="";

	if ( (!obj) || ((obj)&&(obj.value=="")) ) {		
		if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				var iobj=document.getElementById("idz"+i);
				if (iobj) id=iobj.value;
				var mvobj=document.getElementById("MasVolIdz"+i);
				if (mvobj) mvid=mvobj.value
				if (obj) {
					if (obj.checked) ids=ids+id+String.fromCharCode(2)+mvid+"^";
				}
			}
		}
	}
	if (ids!="") {
		var robj=document.getElementById("rtmav");
		if (robj) robj.value=ids;
	}
	//alert(robj.value);
	updated=1;
	return Update_click();

}
var updated=0;
function BodyUnloadHandler(e) {
	if ((self == top)&&(updated)) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}

document.body.onunload=BodyUnloadHandler;
function docLoaded() {
	websys_reSizeT();
	SelectAll();
}

var obj=document.getElementById("SelectAll");
if (obj) obj.onclick=SelectAll;
var obj=document.getElementById("Update");
if (obj) obj.onclick=Update_ClickHandler;
document.body.onload=docLoaded;