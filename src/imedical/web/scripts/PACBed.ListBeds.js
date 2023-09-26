// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 22.11.06 61582

var tbl=document.getElementById("tPACBed_ListBeds");

function BodyLoadHandler() {
	// if the row is occupied by a VIP and no security accesss, make the row unselectable and disable surname link
	for (var row=1; row<tbl.rows.length; row++) {
		var obj=document.getElementById("HiddenVIPz"+row);
		if ((obj)&&(obj.value==1)) {
			//tbl.rows[row].className="clsRowDisabled";
			tbl.rows[row].selectenabled=0;
			var obj2=document.getElementById("PATLastNamez"+row);
			if (obj2) {
				obj2.onclick=LinkDisable;
			}
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) { 
		return false;
	}
	return true;
}

document.body.onload=BodyLoadHandler;
