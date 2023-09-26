// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tPACWard_FindWardBedStatus");
var f=document.getElementById("fPACWard_FindWardBedStatus");

function docLoaded() {
	for (var i=1;i<tbl.rows.length;i++) {
		//alert(i+","+document.getElementById('restrictedz'+i).value);
		if (document.getElementById('restrictedz'+i)&&(document.getElementById('restrictedz'+i).value=='Y')) {
			//alert("found "+i);
			tbl.rows[i].className="SlotOverride";
		}
	}	



}


window.document.body.onload=docLoaded;