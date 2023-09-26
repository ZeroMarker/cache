// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var tbl=document.getElementById("tRBAppointment_BulkTransfer_List");
var f=document.getElementById("fRBAppointment_BulkTransfer_List");

function DocumentLoadHandler() {
	assignChkHandler();
	DisableVIP()
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick = SelectAll;
}

function assignChkHandler() {
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Transferz"+i)
		var stat=document.getElementById("statcodez"+i)
		var trans=document.getElementById("Transferablez"+i)
		//log 60308 13/10/2006 ElenaZ added || (stat.value=="D") to disable 'departed'
		if ((stat.value=="T") || (stat.value=="X")|| (stat.value=="C") || (stat.value=="A") || (trans.value!=1) || (stat.value=="D")|| (stat.value=="N")) obj.disabled=true;
		//if ((stat.value=="T") || (stat.value=="X")|| (stat.value=="C") || (stat.value=="A") || (trans.value!=1) || (stat.value=="N")) obj.disabled=true;
		obj.onclick = chkClickHandler;
	}
	return;
}

function chkClickHandler(e,obj) {
	var doc=top.frames["TRAK_main"].frames["RBBulkTransEdit"].document;
	var BulkApptList=doc.getElementById("BulkApptList");
	if (!obj) var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var ApptId=document.getElementById("ApptIDz"+rowAry[1])
	var NewList=""
	if (obj.checked) {
		BulkApptList.value=BulkApptList.value+ApptId.value+"^"
	} else {
		// Use replace to find rowId in string and replace with blank (love this function)
		NewList=BulkApptList.value.replace(ApptId.value+"^","")
		BulkApptList.value=NewList
	}
}

function SelectAll(e) {
	var doc=top.frames["TRAK_main"].frames["RBBulkTransEdit"].document;
	var BulkApptList=doc.getElementById("BulkApptList");
	BulkApptList.value="";
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Transferz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=true;
				chkClickHandler("",obj)
			}
		}
	}
	return false;
}

//KK 14/10/03 Log:38900
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Transferz");
	// HitCount is only required for reports when data is not being refresh automatically due to problems with
	// the Crystal Web Server. See Crystal KnowledgeBase Article c2002771.
	var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,EpisodeID,ApptID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if (!f.elements["ApptIDz"+row]) continue;
					if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["ApptIDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
						document.writeln('<INPUT NAME="ApptID" VALUE="' + f.elements["ApptIDz"+row].value + '">');
						//alert(f.elements["OEOrdItemIDz"+row].value);
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
				if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["ApptIDz"+row]) continue;
				if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["ApptIDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value,f.elements["ApptIDz"+row].value);
				}
			}
		}
	}
}

// cjb 24/01/2006 55848
function DisableVIP() {
	for (var i=1;i<tbl.rows.length;i++) {
		if ((f.elements['PatientIDz'+i].value=="")&&(f.elements['EpisodeIDz'+i].value!="")) {
			tbl.rows[i].className="clsRowDisabled";
			var Select=f.elements["Transferz"+i];
			if (Select) Select.disabled=true;
			var obj=document.getElementById('Servicez'+i);
			if (obj) var deletenode=obj.removeNode(false);
		}
	}
	return;
}


document.body.onload = DocumentLoadHandler;