// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// 21/8/02 Log#26116 HP

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/
var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));

function DocumentLoadHandler() {

	if ((parent.frames["discharge_top"])&&(window.name=="diagnos_list")) {
		if (parent.refreshTopRequired==1) {
			//parent.frames['discharge_top'].location.reload();
			parent.frames['discharge_top'].treload();
		}
		// ab 6.11.02 - NOTE: this is needed for the correct tab sequence on the editemergency component
		//parent.frames["discharge_top"].websys_firstfocus();
		parent.frames["discharge_top"].InitMe();
	}
	setLinks();
}

function setLinks() {
	var obj=document.getElementById("new");
	var objPatID=document.getElementById("PatientID");
	var objID=document.getElementById("EpisodeID");

	if (obj) {
		if (((objPatID)&&(objPatID.value==""))||((objID)&&(objID.value==""))) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
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

// Log 55973 - PC - 30-11-2005 : New functions to Select All rows for use by the 'Reports' menu.
function MRDIADSReportFlagLinkDisable(evt) {
	return false;
}

function DisableLink(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=MRDIADSReportFlagLinkDisable
		fld.className = "disabledLink";
	}
}

//
//This function is no longer in use
//Log 65388
//
function DisableReportFlagLinks() {

	var ary=ltbl.getElementsByTagName("A")
	for (var curr_fld=0; curr_fld<ary.length; curr_fld++) {
		var obj=ary[curr_fld];
		if (obj) {
			if (obj.id.substring(0,18) == "MRDIADSReportFlagz") {
				DisableLink(obj);
			}
		}
	}

	return false;
}

//DisableReportFlagLinks();


var objSelectAll = frm.elements["SelectAll"];
if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;


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

// Function called from the Component Menus.
function MRDiagnosListEMR_PassSelected(lnk,newwin) {
	var f,aryfound;
	var tbl=getTableName(window.event.srcElement);

	if (tbl) f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f) aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");

	if (aryfound.length==0) {
		alert(t['NONE_SELECTED']);
		return;
	} else {
		var AryItems=new Array();
		var RowIDs="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var RowID=f.elements["MRDIA_RowIdz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}

		lnk+= "&RowIDs=" + RowIDs;
	}

	//alert(lnk);
	window.location = lnk;
}

// ab 30.11.06 61356 - open order entry and pass through diagnosis id's
function MRDiagnosListEMR_Order() {
	var f,aryfound;
	var work=document.getElementById("OrderWorkflow");
	if (work) work=work.value;
	var lnk="websys.csp?TWKFL="+work;
	
	var obj=document.getElementById("PatientID");
	if (obj) lnk+="&PatientID="+obj.value;
	var obj=document.getElementById("EpisodeID");
	if (obj) lnk+="&EpisodeID="+obj.value;
	var obj=document.getElementById("mradm");
	if (obj) lnk+="&mradm="+obj.value;
	
	var tbl=getTableName(window.event.srcElement);

	if (tbl) f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f) {
		if (f.elements["CONTEXT"]) lnk+="&CONTEXT="+f.elements["CONTEXT"].value;
		aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
	}

	if (aryfound.length==0) {
		alert(t['NONE_SELECTED']);
		return;
	} else {
		var AryItems=new Array();
		var RowIDs="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var RowID=f.elements["MRDIA_RowIdz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}

		lnk+= "&MRDiagnos=" + RowIDs;
	}
	lnk+="&PatientBanner=1"
	//alert(lnk);
	websys_createWindow(lnk,"OrderEntry","width=700,height=550,top=50,left=50,status=yes,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

// end Log 55973

document.body.onload = DocumentLoadHandler;

