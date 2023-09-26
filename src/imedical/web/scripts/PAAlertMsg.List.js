// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//var tbl=document.getElementById('tPAAlertMsg_List')

var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));

function PAAlertMsg_List_BodyLoadHandler() {
	//md 30/12/2002
	var numRows=ltbl.rows.length;
	var admalert,editfield,alertcateg
	admalert=frm.elements["AlertSt"];

	var arrLinks=ltbl.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if (arrLinks[i].id.indexOf("edit1z")==0) {
			var arrlnkid=arrLinks[i].id.split("z");
			var row=arrlnkid[1];
	   		var alertcateg=frm.elements["AlertcatCodez"+row];
			var editfield=arrLinks[i];
			var t=0;
			if ((admalert)&&(admalert.value!="")&&(alertcateg)&&(alertcateg.value!="")) {
				var arrR=admalert.value.split("^");
				for (var j=0; j<arrR.length; j++) {
					if ((arrR[j]!="")&&(arrR[j]==alertcateg.value)) t=1;
				}
				if (t!=1) {
					if (editfield) {
						editfield.disabled=true;
						editfield.onclick=LinkDisable;
					}
				}
	 		}
		}
	}
	for (i=1;i<numRows;i++) {
		// Log 37734 - AI - 18-08-2003 : Set the row colour to grey if Closed Flag is checked.
		// Log 40615 - AI - 10-11-2003 : Use a hidden field as normal fields are not always on the layout (Users choice).
		var ClosedFlag=frm.elements["ALM_ClosedFlagHiddenz"+i];
		// Log 40615 - AI - 10-11-2003 : No longer a checkbox - value is N or Y.
		if ((ClosedFlag)&&(ClosedFlag.value=="Y")) {
			for (var CurrentCell=0; CurrentCell<ltbl.rows[i].cells.length; CurrentCell++) {
				ltbl.rows[i].cells[CurrentCell].className="EMRAlertClosed";
			}
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	alert(t['GroupRestrictAlert']);
	if (el.disabled) {
		return false;
	}
	return true;
}

PAAlertMsg_List_BodyLoadHandler();

// Log 55973 - PC - 02-12-2005 : New functions to Select All rows for use by the 'Reports' menu.
function ALMDSReportFlagLinkDisable(evt) {
	return false;
}

function DisableLink(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=ALMDSReportFlagLinkDisable
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
			if (obj.id.substring(0,16) == "ALMDSReportFlagz") {
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
function PAAlertMsgList_PassSelected(lnk,newwin) {
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
			var RowID=f.elements["IDz"+count].value;
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

// end Log 55973


