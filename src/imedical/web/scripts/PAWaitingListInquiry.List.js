//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. w650
var PAWTransFindWin="";

if (top.frames["TRAK_main"]) {
	PAWTransFindWin=top.frames["TRAK_main"].frames["PAWLTransFind"];
}
var bTableSelectIncDecFlag=true;

function BodyOnloadHandler() {
	EPR_ClearSelectedEpisode();
	SetPatientSelected();
	ChkDaysOnList();
	//assignChkHandler()
	//GR 5/6/02 24885
	updobj=document.getElementById('update1');
	if (updobj) updobj.onclick=UpdateClickHandler;
	//GR 6/8/03 log 33829
	lnkobj=document.getElementById('linkwl');
	if (lnkobj) lnkobj.onclick=LinkWLClickHandler;
	unlnkobj=document.getElementById('UnlinkEpisode');
	if (unlnkobj) unlnkobj.onclick=UnLinkWLClickHandler;

	// RQG 10.03.03 L30658
	copyobj=document.getElementById('Copy');
	if (copyobj) copyobj.onclick=CopyClickHandler;
}
function LinkWLClickHandler(e) {
	//log 33829
	var WaitingListID=""
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if (obj) {
				if (obj.checked==true) {
					var WLIDobj=document.getElementById('WaitingListIDz'+i);
					if (WLIDobj) WaitingListID=WaitingListID+WLIDobj.value+"^";
				}
			}
		}
	}
	var LinkPassIdsobj=document.getElementById('LinkPassIds');
	if (LinkPassIdsobj) LinkPassIdsobj.value=WaitingListID
	linkwl_click();
	return false;

}
function UnLinkWLClickHandler(e) {
	//log 33829
	var WaitingListID=""
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if (obj) {
				if (obj.checked==true) {
					var WLIDobj=document.getElementById('WaitingListIDz'+i);
					if (WLIDobj) WaitingListID=WaitingListID+WLIDobj.value+"^";
				}
			}
		}
	}
	var LinkPassIdsobj=document.getElementById('LinkPassIds');
	if (LinkPassIdsobj) LinkPassIdsobj.value=WaitingListID
	UnlinkEpisode_click();
	return false;

}
function UpdateClickHandler(e) {
	//GR 5/6/02 24885
	var WIDStr=""
	var locType=""
	var admType=""
	var PatientID=""
	if (top.frames["eprmenu"]){
		var WID=top.frames["eprmenu"].document.getElementById("WaitingListID");
		WIDStr=WID.value;
	}
	//GR log 28187 24.09.02************
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	var status=""
	var wldate=""
	var stateppp=""
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if (obj) {
				if (obj.checked==true) {
					var statobj=document.getElementById('WLWaitListStatusDRz'+i);
					if (statobj) status=statobj.value;
					var dateobj=document.getElementById('Datez'+i);
					if (dateobj) wldate=dateobj.innerText;
					var statepppobj=document.getElementById('StateProcedz'+i);
					if (statepppobj) stateppp=statepppobj.innerText;
				}
			}
		}
	}
	/*var ValidDate=AdmDateHandler(admdate)
	if ValidDate==false {
		alert(t['InvalidAdmDate']);
		return false;
	}*/
	if (status=="S")	{
		alert(t['SuspendedWL']);
		return false;
	}
	//GR log 28187 24.09.02************
	/*******
	var PatIDObj=document.getElementById("PatientID");
	if (PatIDObj) PatientID=PatIDObj.value
	var LocTypeObj=document.getElementById("locType");
	if (LocTypeObj) locType=LocTypeObj.value
	var AdmTypeObj=document.getElementById("admType");
	if (AdmTypeObj) admType=AdmTypeObj.value
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingListInquiry.List&PatientID="+PatientID+"&locType="+locType+"&admType="+admType+"&WIDStr="+WIDStr;
	top.frames["TRAK_main"].location.href=lnk;
	********/

	var updobj=websys_getSrcElement(e);
	//updobj.href += "&WIDStr="+WIDStr;
	//updobj.target="PAWaitingListInquiry_List";
	var lnk=updobj.href + "&WIDStr="+WIDStr+"&WLDate="+wldate+"&StatePPP="+stateppp ;
	//updobj.href = lnk;
	websys_createWindow(lnk,"PAWaitingListInquiry_List","resizable=yes,scrollbars=yes,status=yes");
	return false;
}

function BodyOnUnloadHandler() {
	EPR_SaveSelectedEpisode();
}

//patient,episode,waitinglistids gets resetted ??? don't know by why
//	...TN:24-Apr-2002: because you call EPR_ClearSelectedEpisode()!!!
//set for the first time coming from patient list so
//workflow doesn't need to search for patient again
function SetPatientSelected() {
	var obj=document.getElementById("PatientID");

	if (obj) {
		//alert("PatId-"+obj.value);
		//var objEpi=document.getElementById("EpisodeID");
		//if (objEpi) alert("EpiID-"+objEpi.Value);
		var winf = null;
		if (window.top != window.self) winf = window.top;
		if (winf) {
			try {winf.SetEpisodeDetails(obj.value,"","","","","","","")} catch(e) {}
		}
	}
}

function selectAll(e) {
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if (obj) {
				obj.checked=true;
			}
		}
	}
	return false;
}

function ClickHandler(e) {
	var eSrc = websys_getSrcElement(e);
	// SA 4.11.01: Added "New" button. Call is not relevant
	// when "New" is clicked.
	if (eSrc.id=="selectall") {
		selectAll(e);
		// BC 25.1.02: This then selects the first line and hence populates
		// the PatientID, EpisodeID, WaitingListID in the menu
		var lineobj=document.getElementById('ListTypez1');
		if (lineobj) {
			//alert("selecting a line");
			lineobj.click();
		}
		return false;
	} else {
		if (eSrc.id!="New") EPR_SelectEpisode(eSrc);
		//alert(eSrc.id);
	}
	//do not return false as need to still display edit list
}

function KeypressHandler(e) {
	var eSrc = websys_getSrcElement(e);
	return EPR_GotoShortcutMenu(eSrc);
}

// please see comments below relating to this.
function WaitingListIDBuilder(id) {
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		//var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if ((f.elements["Selectz"+i])&&(f.elements["Selectz"+i].checked)) {
				aryID[n]=f.elements['WaitingListIDz'+i].value;
				n++;
			} else if (tbl.rows[i].className=="clsRowSelected") {
				aryID[n]=f.elements['WaitingListIDz'+i].value;
				n++;
			}
		}
		return aryID.join("^");
	}
	return "";
}

//GR 19/3/02 changed to WaitingListIDBuilder as this code was not working for the roll count when PAWaitingListTransfer
//was on a side menu.

function PatientIDBuilder(id) {

	// SA 4.2.01: Implemented while testing log 22468. Function created to hold
	// the PatientID of the FIRST checked row in the table.
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if (aryfound.length>0) {
			var PatID="";
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					if (aryfound[j]==i) {
						if (id!=f.elements['PatientIDz'+i].value){
							PatID=f.elements['PatientIDz'+i].value;
							return PatID;
						}
					}
				}
			}
		}
	}
	return "";
}

//KK 12/04/2002 for log 24103
function EpisodeIDBuilder(id) {

	// SA 4.2.01: Implemented while testing log 22468. Function created to hold
	// the PatientID of the FIRST checked row in the table.

	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if (aryfound.length>0) {
			var EpiID="";
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					if (aryfound[j]==i) {
						if (id!=f.elements['EpisodeIDz'+i].value){
							EpiID=f.elements['EpisodeIDz'+i].value;
							return EpiID;
						}
					}
				}
			}
		}
	}
	return "";
}

function RollCount() {
	var WIDStr="";
	if (PAWTransFindWin) {
		if (top.frames["eprmenu"]){
			var WID=top.frames["eprmenu"].document.getElementById("WaitingListID");
			if (WID.value) WIDStr=WID.value;
		} else {
			var WID=WaitingListIDBuilder("WaitingListID");
			WIDStr=WID;
		}
		//var PID=top.frames["eprmenu"].document.getElementById("PatientID");
		var RollCnt=PAWTransFindWin.document.getElementById("OldRollCount");
		//alert("PRE: RollCnt|WID=" + RollCnt.value + "|" + WIDStr);
		if ((WID) && (RollCnt)) {
			if (WIDStr=="") {
				//alert ("decrementing");
				//RollCnt.value=RollCnt.value - 1;
				RollCnt.value=0;
			} else {
				//alert("manipulating");
				WIDAry=WIDStr.split("^");
				//alert(WIDStr);
				RollCnt.value=WIDAry.length;
			}
			//alert(RollCnt.value);
		}
		//alert("POST: RollCnt|WID=" + RollCnt.value + "|" + WIDStr);
		if (WIDStr=="") {
			//alert ("decrementing");
			//RollCnt.value=RollCnt.value - 1;
			RollCnt.value=0;
		}
		//GR 19/3/02 have to clear WIDStr for rollcount to reset to 0
		WIDStr="";
	}
}

//	RQG/Log#22663/04.02.02
//	New function to display the rows in 'RED' if number of days on list exceeds the
//	priority number of days.
//
function ChkDaysOnList() {
	var tbl=document.getElementById("tPAWaitingListInquiry_List");

	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var bPriorityExceeded = document.getElementById("PriorityExceededz" + curr_row);
		if (bPriorityExceeded.value == 'Y') {
			for (var curr_cell =1; curr_cell<tbl.rows[curr_row].cells.length; curr_cell++) {
	     			tbl.rows[curr_row].cells[curr_cell].style.color="Red";
        	   		}
		}
	}
}

document.body.onload=BodyOnloadHandler;
document.body.onclick=RollCount;
//document.body.onunload=BodyOnUnloadHandler;
document.onclick = ClickHandler;
var obj=document.getElementById("selectall");
if (obj) obj.onclick = selectAll;
document.onkeypress = KeypressHandler;


// SA 4.2.01: log 22468 Function created to remove a SINGLE WaitingListID when a row is
// deselected, rather than then entire list of IDs.
//'objRow' is the the object of the row last clicked
//'winf' is the topmost parental window from this frame

function ClearOnMultipleSelection(objRow,winf) {
	var row=objRow.rowIndex;
	var objTbl=getTable(objRow);
	var frm=getFrmFromTbl(objTbl);
	if ((frm)&&(frm.elements["WaitingListIDz"+row])) {
		var WaitingListID="";
		WaitingListID=frm.elements["WaitingListIDz"+row].value;
		//alert("WaitingListID="+WaitingListID);
		var WLID="";
		var PatID="";
		var EpiID="";

		// SA: pass NO ID to WaitingListIDBuilder when a row is deselected
		// to only retrieve checked rows. These "Builder" functions reside in
		// PAWaitingListInquiry.List.js
		try {WLID=WaitingListIDBuilder("");} catch(e) {}
		try {PatID=PatientIDBuilder();} catch(e) {}
		try {EpiID=EpisodeIDBuilder();} catch(e) {}

		//alert("WLID="+WLID+"\nPatID="+PatID+"\nEpiID="+EpiID);

		if (winf) {
			try {winf.SetEpisodeDetails(PatID,EpiID,"","","",WLID,"","","");} catch(e) {}
		}
	}
}

function AdmDateHandler(admdate) {
	return true;
	//dummy function for custom function in austin
}

// RQG 10.03.03 L30658: New function to copy selected WL entry
function CopyClickHandler() {
	//alert("Inside CopyClickHandler");

	if (!CheckCopyWLStatus()) return false;

	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if ((obj)&&((obj.checked==true)||(tbl.rows[i].className=="clsRowSelected"))) {
				var wlobj=document.getElementById('WaitingListIDz'+i);
				var idobj=document.getElementById('IDz'+i);
				var patientid=document.getElementById('PatientIDz'+i);
				var copy="Copy";
				//var url="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingList.Edit&ID="+idobj.value+"&PatientID="+patientid.value+"&WaitingListID="+wlobj.value+"&PatientBanner=1"+"&Mode="+copy;
				var url="pawaitinglistrb.edit.csp?&ID="+idobj.value+"&PatientID="+patientid.value+"&WaitingListID="+wlobj.value+"&PatientBanner=1"+"&Mode="+copy;
				//alert(url);
				// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow(url,'','top=30,left=20,width=750,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
				//websys_lu(url,false,"");
			}
		}
	}
}
function CheckCopyWLStatus() {
	//This is a dummy function here. Check for QH done via custom js
	return true;
}
function ManualORMIS(lnk,newwin) {
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if ((obj)&&((obj.checked==true)||(tbl.rows[i].className=="clsRowSelected"))) {
				var wlobj=document.getElementById('WaitingListIDz'+i);
				if (wlobj) {
					var ORMISWLID=wlobj.value
					lnk+="&WLId="+ORMISWLID
				}
			}
		}
	}
	if (newwin == "TRAK_hidden")
		top.frames["TRAK_hidden"].location = lnk;
	else if (newwin != "")
		websys_lu(lnk,0,newwin);
	else
		window.location = lnk;
}

//log 61684
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
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
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
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="WaitingListID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["IDz"+row]) continue;
					if (f.elements["IDz"+row].value!="") {
						document.writeln('<INPUT NAME="WaitingListID" VALUE="' + f.elements["IDz"+row].value + '">');
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
					PassReportParametersForPreview(lnk,newwin,f.elements["IDz"+row].value);
				}
			}
		}
	}
}