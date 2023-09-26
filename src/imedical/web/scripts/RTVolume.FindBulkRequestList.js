// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var tbl=document.getElementById("tRTVolume_FindBulkRequestList");

function SelectAll(evt) {
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if ((sobj) && (sobj.disabled==false)) sobj.checked=true;
		}
	}
	return false;
}

function RefreshAfterNewVolume(){
	alert("Testing");
	window.treload("websys.reload.csp");
}

function UpdateClick_Handler(evt) {
	var tbl=document.getElementById("tRTVolume_FindBulkRequestList");

	var fr=parent.frames[0];
	if (fr) {
		if (fr.name=="FindBulkRequest") {
			var check=CheckRequest(obj,tbl,"N","epr.default.csp");
		}
	}
}

function CheckRequest(obj,tbl,CreateTrans,DirectTo) {
	var pidvolids="";
	var check=false;

	for (i=1; i<tbl.rows.length; i++) {
		var obj=document.getElementById("Selectz"+i);
		if ((obj)&&(obj.checked)) {
			if (document.getElementById("RTMAVRowIdz"+i).value!="") { 
				pidvolids=pidvolids+document.getElementById("RTMASPatNoDRz"+i).value+String.fromCharCode(2)+document.getElementById("RTMAVRowIdz"+i).value+"^";
			}									
		}
	}

	//alert(pidvolids);
	var patid="";
	var reqid="";
	var ReqLoc="";
	var recvby="";
	var pobj=document.getElementById("PatientIDs");
	if (pobj) patid=pobj.value;
	var url="rtvolume.createbulkrequestsonly.csp?PidMasVolid="+pidvolids+"&PatientIDs="+patid+"&CreateTrans="+CreateTrans+"&Page="+DirectTo;
	top.frames["TRAK_hidden"].location.href=url;
	return true;

}

function docLoaded() {
	if (document.getElementById("Bookedz1")) {
		var valToBecome="<IMG SRC='../images/websys/update.gif' id='Booked' title='' border=0>";
		//changeColContent(tbl,'Booked','BookedHidden','Y',valToBecome);
	}
	//SelectAll();
	var obj=parent.frames[0].document.getElementById("UR");
	if (obj) obj.select();

}

function SetFocus() {
	var obj=parent.frames[0].document.getElementById("UR");
	if (obj) obj.select();

}
function SetFocusToUR(str) {
	//var lu=str.split("^");
	var obj=parent.frames[0].document.getElementById("UR");
	if (obj) obj.select();
	//var mrobj=document.getElementById("MRLocationID");
	//if (mrobj) mrobj.value=lu[2];
}
//tblname passed as a parameter log 31568
function PrintBarcodeLabelHandler(tblname,lnk,newwin) {
	//alert("PrintSelectedRows");
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
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//var HitCount=Math.round(Math.random() * 1000)
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
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="rtmav">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					//alert(row);
					// check for specific values - these values must be hidden in the component
					if (!f.elements["RTMAVRowIdz"+row]) continue;
					if (f.elements["RTMAVRowIdz"+row].value!="") {
						document.writeln('<INPUT NAME="rtmav" VALUE="' + f.elements["RTMAVRowIdz"+row].value + '">');
					}
				}
				/*
				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.close();
				*/
				//Log 63760 PeterC 28/05/07
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["RTMAVRowIdz"+row]) continue;
				if (f.elements["RTMAVRowIdz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["RTMAVRowIdz"+row].value);
				}
			}
		}

		/*
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {
				MasVolIDs=MasVolIDs+f.elements["RTMAVRowIdz"+row].value+",";
				//lnk=arrParam[0] + "&EpisodeID="+EpisodeID + "&PatientID="+PatientID +"&prompt0=";
				
			}
		}
		lnk=lnk+"&rtmav="+MasVolIDs;
		if (newwin=="TRAK_hidden") {
			//alert(lnk);
			websys_createWindow(lnk,"TRAK_hidden");
		} else {
			websys_lu(lnk,false,"width="+screen.availWidth+",height="+screen.availHeight);
		}
		*/
	}

}

function EnterKey(e) {
	//Log 31868
	var key = websys_getKey(e);
	var locobj=document.getElementById("MRLocation");
	if ((locobj)&&(key==13)) {
		locobj.blur();
		var upobj=document.getElementById("Update1");
		if (upobj) upobj.focus();

		//return false;
	}
}

document.body.onkeydown=EnterKey;

var sobj=document.getElementById("SelectAll");

if (sobj) sobj.onclick=SelectAll;


var obj=document.getElementById("Update1");
if (obj) obj.onclick=UpdateClick_Handler;
document.body.onload=docLoaded;



