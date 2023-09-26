// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var selectedRowObj=new Object();
selectedRowObj.rowIndex="";

function BodyLoadHandler() {

	var tbl = document.getElementById("tPARecallSched_Edit");
	var objID=document.getElementById("ID");
	if (objID) {
		if (objID.value != "") {
			// ID - therefore already generated 
			var obj=document.getElementById("Generate");
			if (obj) { 
				obj.disabled = true;
				obj.onclick = LinkDisable;
			}
			var obj=document.getElementById("StartDate");
			if (obj) { 
				obj.readOnly=true;
				obj.className = "disabledField";
				obj.onclick = LinkDisable;
			}
			var obj=document.getElementById("ld2365iStartDate");
			if (obj) { 
				obj.onclick = LinkDisable;
			}

		} else {
			var obj=document.getElementById("Generate");
			if (obj) { 
				obj.onclick = GenerateClick;
			}

		}
	}
	/*
	var Seltbl = document.getElementById("tPARecallSched_Edit");
	var SelForm = document.getElementById("fPARecallSched_Edit");
	if (Seltbl&&SelForm) {
		for (var curr_row=1; curr_row<Seltbl.rows.length; curr_row++) {
			var StatusColour=SelForm.elements["StatusColourz" + curr_row].value;
			if (StatusColour!="") {
			 for (var CurrentCell=0; CurrentCell<Seltbl.rows[curr_row].cells.length; CurrentCell++) {
				var cellID = "";
				if (Seltbl.rows[curr_row].cells[CurrentCell].children.length) {
					cellID = Seltbl.rows[curr_row].cells[CurrentCell].children[0].id.split("z");
				}
				if (cellID.length>0) {
					cellID=cellID[0];
					// if already booked appointment - remove link
					if ( (",ApptStatus,".indexOf(","+cellID+",")!=-1) ) {
						Seltbl.rows[curr_row].cells[CurrentCell].style.color=StatusColour;
					}
				}
			 }
		 }
		}
	}
	*/

}

function TableDisable(evt) {
	return false;
}

function GenerateClick(evt) {
	var obj=document.getElementById("StartDate");
	if (obj && obj.value=="") {
		alert(t["NOSTARTDATE"]);
		return false;
	}
	return Generate_click(evt);
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}



function DisableLinks(DisableALLTable) {
	/*
	var obj=document.getElementById('');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	*/

}

function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != "TABLE") {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}

document.body.onload = BodyLoadHandler;

