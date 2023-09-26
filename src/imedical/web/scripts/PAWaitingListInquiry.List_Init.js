//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var PAWTransFindWin="";

if (top.frames["TRAK_main"]) {
	PAWTransFindWin=top.frames["TRAK_main"].frames["PAWLTransFind"];
}
var bTableSelectIncDecFlag=true;

function BodyOnloadHandler() {
	EPR_ClearSelectedEpisode();
	SetPatientSelected();
	ChkDaysOnList();
//	assignChkHandler()
}

function BodyOnUnloadHandler() {
	EPR_SaveSelectedEpisode();
}

//patient,episode,waitinglistids gets resetted ??? don't know by why
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
		
			
	}
	//do not return false as need to still display edit list
}
function KeypressHandler(e) {
	var eSrc = websys_getSrcElement(e);
	return EPR_GotoShortcutMenu(eSrc);
}
/*
function assignChkHandler() {
	if (PAWTransFindWin) {
		var rollcnt=PAWTransFindWin.document.getElementById("OldRollCount");
		if (rollcnt) rollcnt.value=0
		var tbl=document.getElementById("tPAWaitingListInquiry_List");
		for (var i=1;i<tbl.rows.length;i++) {
			if (rollcnt) rollcnt.value++
			var obj=document.getElementById("chkz"+i);
			//if (document.getElementById("PatientIDz"+i).value=="") {
			//	obj.checked=false
			//	obj.disabled=true
			//} else {
				obj.onclick = chkClickHandler;
			//}
		}
	}
	return;
}

function chkClickHandler(e) {
	
	var rollcnt=PAWTransFindWin.document.getElementById("OldRollCount");
	var obj=websys_getSrcElement(e);
	var rowid=obj.id;
	var rowAry=rowid.split("z");
	if (obj.checked) {
		rollcnt.value++;
	} else {
		rollcnt.value--;
	}
	//alert(rowAry[1]);
}
*/
// please see comments below relating to this.
function WaitingListIDBuilder(id) {
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		//var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=0;i<tbl.rows.length;i++) {
			if (f.elements["Selectz"+i]) {
				if (f.elements["Selectz"+i].checked) {
					aryID[n]=f.elements['WaitingListIDz'+i].value;
					n++;
				} else if (tbl.rows[i].className=="clsRowSelected") {
					aryID[n]=f.elements['WaitingListIDz'+i].value;
					n++;
				}
			}	
		}
		return aryID.join("^");
	}
	return "";
}

/*GR 19/3/02 changed to WaitingListIDBuilder as this code was not working for the roll count when PAWaitingListTransfer 
was on a side menu.
function WaitingListIDBuilder2(id) {
	var tbl=document.getElementById("tPAWaitingListInquiry_List");
	var f=document.getElementById("fPAWaitingListInquiry_List");
	if ((f)&&(tbl)) {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if (aryfound.length>0) { 
			var aryID=new Array();var aryStat=new Array();var n=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					if (aryfound[j]==i) {
						if (id!=f.elements['WaitingListIDz'+i].value){
							aryID[n]=f.elements['WaitingListIDz'+i].value;
							n++;
						}
					}
				}
			}
		return aryID.join("^");
		}
	}
	return "";
}
*/
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
			var WID=WaitingListIDBuilder("WaitingListID") ;
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
		   for (var curr_cell =1; curr_cell<tbl.rows[curr_row].cells.length; curr_cell++)
        	   {
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