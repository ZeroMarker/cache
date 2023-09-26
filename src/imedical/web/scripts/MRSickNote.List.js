// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 13.09.06 60406
var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));

// ab 21.12.06 62048 - uncommented this so select all checkbox works
function MRSickNoteList_BodyLoadHandler() {
	var obj=document.getElementById("MRS_SelectAll");
	if (obj) obj.onclick=SelectAllClickHandler;

	var epId=document.getElementById("EpisodeID");
	var conEpId=document.getElementById("ConsultEpisodeID");
	if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
		var objNew=document.getElementById("compnew1");
		if(objNew){
			objNew.disabled=true;
			objNew.onclick=LinkDisable;
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

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	//alert("tablename=" + tblname + " && lnk=" + lnk + " && newwin=" + newwin);
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
	var PresNoList="";
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	var HitCount=Math.round(Math.random() * 1000);
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PresNo">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["IDz"+row]) continue;
					if (f.elements["IDz"+row].value!="") {
						document.writeln('<INPUT NAME="SickNoteID" VALUE="' + f.elements["IDz"+row].value + '">');
					}
				}

				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				//document.close();
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
				// End Log 63924
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["IDz"+row]) continue;
				if (f.elements["IDz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					// PassReportParametersForPreview(lnk,newwin,f.elements["IDz"+row].value);
				}
			}
		}
	}
}

document.body.onload=MRSickNoteList_BodyLoadHandler;
