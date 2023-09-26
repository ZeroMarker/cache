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


// Log 55973 - PC - 06-12-2005 : New functions to Select All rows for use by the 'Reports' menu.
function ANADSReportFlagDisable(evt) {
	return false;
}

function DisableLink(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=ANADSReportFlagDisable
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
			if (obj.id.substring(0,16) == "ANADSReportFlagz") {
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
function ORAnaesthesiaTree_PassSelected(lnk,newwin) {
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
		for (var i=0;i<aryfound.length;i++)
		{
			var RowID;
			var count=aryfound[i];
			/*
			// Because ORAnaesthesia.Tree is a table of tables, check to see if the same IDz... field occurs more than once within the whole table.
			//   If more are found, we want the FIRST one, because that is from the top table (ORAnaesthesia.Tree).
			var len=f.elements["IDz"+count].length;
			if (len>1) {
				for (var a=0;a<len;a++) {
					var str=f.elements["IDz"+count][a].value;
					if (str.indexOf("||")==str.lastIndexOf("||")) RowID=str;
				}
			} else {
				RowID=f.elements["IDz"+count].value;
			}  */
			var row = getRow(f.elements["SelectItemz"+count]);
			var arrfld = row.getElementsByTagName('INPUT');
			for (var j=0; j<arrfld.length; j++) {
				if (arrfld[j].id.indexOf("IDz")==0) {
					RowID=arrfld[j].value;
					break;
				}
			}
			if (RowID) {
				if (RowIDs==""){
					RowIDs=RowID;
				} else{
					RowIDs=RowIDs+"^"+RowID;
				}
			}
		}

		lnk+= "&RowIDs=" + RowIDs;
	}
	//alert(lnk);
	window.location = lnk;
}

// end Log 55973
