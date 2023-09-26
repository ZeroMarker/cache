// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm=document.forms["fPAAdm_ListMultiReferral"];
var tbl=document.getElementById("tPAAdm_ListMultiReferral");

function DocumentLoadHandler() {
	assignChkHandler();
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick = SelectAll;
	var obj=document.getElementById("ApptBook");
	if (obj) obj.onclick = BookApptClickHandler;
}

function BookApptClickHandler(e) {
	var obj=document.getElementById("BulkApptList");
	if (obj) BulkApptList=obj.value;
	if ((BulkApptList=="") || (BulkApptList=="^")) {
			alert("You haven't selected any referrals");
			return false;
	}
	var lnkobj=document.getElementById('ApptBook');
	//var lnk = "RBAppointmentFrame.PopUp3.CSP?BulkApptList="+BulkApptList;
	lnk = lnkobj.href + "&BulkApptList="+BulkApptList
    //Log: 59598, 03-07-2006 BC: add "status=yes"
	window.open(lnk,"frmAppointmentFrame","top=0,left=0,width=799,height=590,resizable,status=yes");
	if (obj) obj.value="";
	return false;
}

function assignChkHandler() {
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Selectz"+i)
		var refno=document.getElementById("refNoz"+i)
		if ((frm)&&(tbl)) {
			for (var j=1;j<tbl.rows.length;j++) {
				if (obj) obj.onclick = chkClickHandler;
				if (refno) refno.onclick = SelectRefNo;
			}
		}
	}
	return;
}

function chkClickHandler(e) {
	var BulkApptList=document.getElementById("BulkApptList");
	if (BulkApptList.value=="") BulkApptList.value="^";
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var obj=document.getElementById("Selectz"+rowAry[1])
	var NewList="",temp=""
	if (obj.checked) {
		var EpID=document.getElementById('EpisodeIDz'+rowAry[1]);
		var PatID=document.getElementById('PatientIDz'+rowAry[1]);
		temp=EpID.value+"||"+PatID.value;
		BulkApptList.value=BulkApptList.value+temp+"^"
	} else {
		var EpID=document.getElementById('EpisodeIDz'+rowAry[1]);
		var PatID=document.getElementById('PatientIDz'+rowAry[1]);
		temp=EpID.value+"||"+PatID.value;
		// Use replace to find rowId in string and replace with blank (love this function)
		NewList=BulkApptList.value.replace(temp+"^","")
		BulkApptList.value=NewList;
	}
}

function SelectAll(e) {
	var BulkApptList=document.getElementById("BulkApptList");
	if (BulkApptList.value=="") BulkApptList.value="^";
	if ((frm)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)) {
				var EpID=document.getElementById('EpisodeIDz'+j);
				var PatID=document.getElementById('PatientIDz'+j);
				obj.checked=true;
				temp=EpID.value+"||"+PatID.value;
				BulkApptList.value=BulkApptList.value+temp+"^";
			}
		}
	}
	return false;
}

function SelectRefNo(e) {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tagName);
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	if (eSrcAry.length>0) {
		//alert(eSrcAry[0])
		//JW: opens in new window - should not go through workflow
		if (eSrcAry[0]=="refNo") {
			var currentlink=eSrc.href.split("?");
			//alert(currentlink);
			var temp1=currentlink[1].split("&TWKFL")
			var temp2=currentlink[1].split("&ID")
			var url = "paadm.edit.csp" + "?" + temp1[0] + "&ID" + temp2[1];
			//var url = "paadm.edit.csp" + "?" + currentlink[1];
			websys_lu(url,false,"width=700,height=700,left=10,top=10")
			return false;
		}
	}
}
// LOG 31221 readded these two functions so the link to PAAdm.Edit works
function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}

function setRowClass(rowObj) {
	if (rowObj.rowIndex!=selectedRowObj.rowIndex) {
		rowObj.className='clsRowSelected';
		if (selectedRowObj.rowIndex%2==0 && selectedRowObj.rowIndex>0) {cName="RowEven";} else {cName="RowOdd";}
		selectedRowObj.className=cName;
		selectedRowObj=rowObj;
	}
}

// LOG 27263 BC 26-8-2002 Stolen from PACWard.ListPatientsInWard so a list of Episode IDs are produced
function EpisodeIDGetSelected(frm,rowlastclicked) {
	var arrEpisodeIDs=new Array(); arrEpisodeIDs["firstSelected"]="";
	var eSrc=websys_getSrcElement();
	var tbl=getTable(eSrc);
	var frm=getFrmFromTbl(tbl);
	var selected=0;
	for (var row=1; row<tbl.rows.length; row++) {
		var cbx=frm.elements["Selectz"+row];
		if ((cbx.checked) && (!cbx.disabled)) {
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
//LOG 30131 BC 11-11-2002 Bring it up to the new printing standard
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	//var eSrc=websys_getSrcElement();
	//var tbl=getTableName(eSrc);
	//var tbl=document.getElementById(tblname);
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,EpisodeID,OEOrdItemID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
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
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["PatientIDz"+row]) continue;
				if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value);
				}
			}
		}
		/*
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["EpisodeIDz"+row]) continue;
			if (!f.elements["PatientIDz"+row]) continue;
			if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
				//var arrParam=lnk.split("&prompt0=");
				//lnk=arrParam[0];
				//alert(lnk+","+newwin);
				//PassReportParameters(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value,HitCount);
				//alert(row);
				//KK Replaced PassReportParameters with the following
				//KK 9/Jan/2002 Log 31568
				//      ***************************
				if (newwin=="TRAK_hidden") {
					var newlnk=lnk;
					// concatenate specific row parameter values to lnk. this is necessary because the %request
					// variables are lost when the menu is selected. These parameter values will be resolved in
					// the Report Manager definition.
					newlnk=newlnk+"&EpisodeID="+f.elements["EpisodeIDz"+row].value;
					newlnk=newlnk+"&PatientID="+f.elements["PatientIDz"+row].value;
					websys_createWindow(newlnk,"TRAK_hidden");
					// time delaying function to allow proper loading of the TRAK_hidden frame
					CompleteReportLoading();
				} else { 	// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value);
				}
				//     *******************************
			}
		}
		*/
	}
}


document.body.onload = DocumentLoadHandler;