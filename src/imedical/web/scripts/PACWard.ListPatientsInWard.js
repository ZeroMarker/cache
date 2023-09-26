// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//KM 21-Jan-2002: Note: The BodyOnloadHandler() on pacward.listpatients.csp overrides this one.

function DoColours() {
	if (typeof SetWardColourForm != "function") window.setTimeout("DoColours();",200)
	else SetWardColourForm(document.forms['fPACWard_ListPatientsInWard']);
}
DoColours();


function BedBodyOnloadHandler() {
	//SetWardColours();

	var obj=document.getElementById("EnableDischargeAll");
	var objlink=document.getElementById("DischargeAll");
	if ((obj)&&(objlink)&&(obj.value!="Y")) {
		objlink.disabled=true;
		objlink.onclick=DisableClickHandler;
	}
	//md 02/10/003
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAllClickHandler;
}


function DisableClickHandler() {
	return false;
}

//TN 22-Apr-2002:
//gets episode id from all rows where "Select" checkbox is checked.
//only include single highlighted row if no checkboxes are selected.
function EpisodeIDGetSelected(frm,rowlastclicked) {
	var arrEpisodeIDs=new Array(); arrEpisodeIDs["firstSelected"]="";
	var eSrc=websys_getSrcElement();
	var tbl=getTable(eSrc);
	var frm=getFrmFromTbl(tbl);
	var selected=0;
	for (var row=1; row<tbl.rows.length; row++) {
		var cbx=frm.elements["Selectz"+row];
		if ((cbx)&&(cbx.checked) && (!cbx.disabled)) {
			arrEpisodeIDs[selected]=frm.elements["EpisodeIDz"+row].value;
			selected++;
			if (arrEpisodeIDs["firstSelected"]=="") arrEpisodeIDs["firstSelected"]=row;
		}
	}
	if (arrEpisodeIDs.length==0) {
		if (tbl.rows[rowlastclicked].className=='clsRowSelected') {
			arrEpisodeIDs[selected]=frm.elements["EpisodeIDz"+rowlastclicked].value;
			selected++;
			if (arrEpisodeIDs["firstSelected"]=="") arrEpisodeIDs["firstSelected"]=rowlastclicked;
		}
	}
	return arrEpisodeIDs;
}

function ClearOnMultipleSelection(objRow,winf) {
	var tbl=getTable(objRow);
	var frm=getFrmFromTbl(tbl);
	var arrIDs=EpisodeIDGetSelected(frm,1);
	if ((frm)&&(arrIDs.length)) {
		var row=arrIDs["firstSelected"];
		EPR_SelectEpisodeDetails(frm,row,winf);
	}
}

//md 02/10/003 checks all the 'select' checkboxes in the list
function SelectAllClickHandler(evt) {
	var ifrm,itbl;

	var el=window.event.srcElement
	// Get the form that contains the element that initiated the event.
	if (el) ifrm=getFormName(el);
	// Get the table of the same name as the form.
	if (ifrm) itbl=document.getElementById("t"+ifrm.id.substring(1,ifrm.id.length));
	// Set each "SelectItem" checkboxes to the same value as the "SelectAll" checkbox.
	if (itbl) {
		for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var objSelectItem=ifrm.elements["SelectItemz" + curr_row];
			if (!objSelectItem) objSelectItem=ifrm.elements["Selectz" + curr_row];
			if (objSelectItem) objSelectItem.checked=el.checked;
		}
	}

	return true;
}

document.body.onload=BedBodyOnloadHandler;
