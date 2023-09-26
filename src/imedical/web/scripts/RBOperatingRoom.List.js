// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//var debug="N"  //"Y" = alerts and stuff, "N" = alert free

function DocumentLoadHandler() {
		//alert("doc load");
		var table =document.getElementById("tRBOperatingRoom_List");
		if (table) {
			assignChkHandler();
			 //alert("table found");
			var nRows=0;
			nRows = table.rows.length;
			//alert(nRows);
			// Log 36919 Need to have the checkboxes for all operating room  a warning will be made when trying to rebook
			/*if (nRows>0) {
				for(var i=1; i<nRows; i++) {
					var apptObj=document.getElementById("apptIDz"+i);
					var selectObj=document.getElementById("selectz"+i);
					if ((apptObj)&&(apptObj.value!="")) {
						//alert("Appt found");
						if (selectObj) {
							var killed=selectObj.removeNode(false);
						}
					}
				}
			}*/

			//Log 44213 - Set a click handler to detect when a row is clicked
			//Following not required, event RBOperatingRoom_List_SelectRowHandler is automatically
			//called instead (because of websys.List.js).
			//table.onclick=TableClickHandler;
		DisableVIP();
		}
		//Chandana - not required anymore (44133 & 44132) as icons are used instead
		//SetLinksStatus();
}

//Logs 44133 & 44132 - If Additional Staff exist, make the additional staff link bold.
//If Secondary Operations or Secondary Procedures exist, make the corresponding links bold.
function SetLinksStatus(){
	var tbl=document.getElementById("tRBOperatingRoom_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var lnkst=document.getElementById("BoldLinksz"+i);
		if (lnkst){
			var arrLnkst = lnkst.value.split("^");
			var objas=document.getElementById("AdditionalStaffz"+i);
			if ((arrLnkst[0]=="1")&&(objas)) {
				objas.style.fontWeight="bold";
			}
			var objso=document.getElementById("SecondaryOperationsz"+i);
			if ((arrLnkst[1]=="1")&&(objso)) {
				objso.style.fontWeight="bold";
			}
			var objsp=document.getElementById("SecondaryProceduresz"+i);
			if ((arrLnkst[2]=="1")&&(objsp)) {
				objsp.style.fontWeight="bold";
			}
		}
	}
}

//Logs 44133 & 44132 - set a link to bold or unbold for a particular row
function SetLinkStatusByRow(linkName,status,operId){
	//alert("in SetLinkStatusByRow");
	var tbl=document.getElementById("tRBOperatingRoom_List");
	var selRow="";
	for (var i=1;i<tbl.rows.length;i++) {
		var objId = document.getElementById("OperRoomIDz" + i);
		if(objId && objId.value == operId) selRow = i;
	}
	//alert("selRow " + selRow);

	if(selRow != ""){
		var objLnk = document.getElementById(linkName + "z" + selRow);
		if (objLnk){
			//alert("status " + status);
			if(status == "0") {
				objLnk.style.fontWeight="normal";
			}
			else if (status == "1"){
				objLnk.style.fontWeight="bold";
			}
		}
	}
}

//Log 44213 Chandana - If ArrivedLink is clicked, set the target of the link to _parent
//(so that the parent window refreshes and not just the frame containing the List component).
//Also give error message if trying to Arrive a not 'Booked' booking or a future booking.
//Log 51815 Chandana - Don't set targe to _parent for Arrived link as it doesn't work in the OT workbench setup.  ArrivedLink
//item's url in component manager has been changed.
function RBOperatingRoom_List_SelectRowHandler() {
	//alert("row handler");
   	var eSrc = websys_getSrcElement();
	var rowObj = getRow(eSrc);
	var selRowNo = rowObj.rowIndex;
	//alert("sel row " + selRowNo);

	//if (parent.frames["RBOperatingRoomList"]) {
		if (eSrc.tagName=="IMG") { //tagnames like TD, TH etc...
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.id.indexOf("ArrivedLinkz")==0) {
			eSrc.href+="&CONTEXT="+session["CONTEXT"];

			//Check status and give err msg if status not 'Booked'.
			//If Arrival Date is present, then don't do anything.
			var stsObj = document.getElementById("statz" + selRowNo);
			if(stsObj && stsObj.value != "B"){
				alert(t['RBOPArriveStsChk']);
				return false;
			}

			//Check booking date and if in future give err msg
			var arrfld=rowObj.getElementsByTagName('LABEL');
			for (var j=0; j<arrfld.length; j++) {
				var fld = "Datez" + selRowNo;
				if (arrfld[j].id == fld) {
					var bdObj = arrfld[j];
					if (bdObj && DateStringCompareToday(bdObj.outerText) == 1){
						alert(t['RBOPArrivalNotFuture']);
						return false;
					}
				}
			}
			//eSrc.target="_parent"; //frame target
			return true;
		}
	//}
}


function assignChkHandler() {
	var tbl=document.getElementById("tRBOperatingRoom_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("selectz"+i)
		if (obj) obj.onclick = chkClickHandler;
		var sobj=document.getElementById("MainSurgeonz"+i);
		if (sobj) sobj.onclick = SurgClickHandler;
		var aobj=document.getElementById("MainAnesthiestz"+i);
		if (aobj) aobj.onclick = AnaClickHandler;
		var robj=document.getElementById("RecLinkz"+i);
		if (robj) robj.onclick = RecClickHandler;
	}
	return;
}

function chkClickHandler(e,obj) {
	var BulkApptList=document.getElementById("BulkApptList");
	var BulkOpList=document.getElementById("BulkOpList");
	if (!obj) var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var OperRoomID=document.getElementById("OperRoomIDz"+rowAry[1])
	var NewList=""
	if (obj.checked) {
		BulkOpList.value=BulkOpList.value+OperRoomID.value+"^";
	} else {
		// Use replace to find rowId in string and replace with blank (love this function)
		NewList=BulkOpList.value.replace(OperRoomID.value+"^","")
		BulkOpList.value=NewList
	}
}

function SurgClickHandler(e) {
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var SPStr=document.getElementById("SurgPrefStringz"+rowAry[1]).value
	var Surg=document.getElementById("MainSurgeonIDz"+rowAry[1]).value
	if (SPStr=="") {alert(t["noPref"]); return false;}
	var OPPrefID=SPStr.split("^")
	for (var j=0; j<OPPrefID.length-1; j++) {
		//Calculate 'offset' so it tiers the window openings
		var pos='top='+((j+1)*15)+',left='+((j+1)*15)+',width=600,height=600 scrollbars resizable'
		var lnk='ssuser.surgicalpreferences.edit.csp?ReadOnly=1&Component=Surg&PARREF='+Surg+'&OpPrefID='+OPPrefID[j]
		websys_createWindow(lnk,"",pos);
	}
}

function AnaClickHandler(e) {
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var AnStr=document.getElementById("AnaPrefStringz"+rowAry[1]).value
	var Ana=document.getElementById("MainAnesthiestIDz"+rowAry[1]).value
	if (AnStr=="") {alert(t["noPref"]); return false;}
	var OPPrefID=AnStr.split("^")
	for (var j=0; j<OPPrefID.length-1; j++) {
		//Calculate 'offset' so it tiers the window openings
		var pos='top='+((j+1)*15)+',left='+((j+1)*15)+',width=600,height=600 scrollbars resizable'
		var lnk='ssuser.surgicalpreferences.edit.csp?ReadOnly=1&Component=Ana&PARREF='+Ana+'&OpPrefID='+OPPrefID[j]
		websys_createWindow(lnk,"",pos);
	}
}

function RecClickHandler(e) {
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");
	var RECStr=document.getElementById("RecPrefStringz"+rowAry[1]).value
	var Surg=document.getElementById("MainSurgeonIDz"+rowAry[1]).value
	if (RECStr=="") {alert(t["noPref"]); return false;}
	var OPPrefID=RECStr.split("^")
	for (var j=0; j<OPPrefID.length-1; j++) {
		//Calculate 'offset' so it tiers the window openings
		var pos='top='+((j+1)*15)+',left='+((j+1)*15)+',width=600,height=600 scrollbars resizable'
		var lnk='ssuser.surgicalpreferences.edit.csp?ReadOnly=1&Component=Recov&PARREF='+Surg+'&OpPrefID='+OPPrefID[j]
		websys_createWindow(lnk,"",pos);
	}
}


// cjb 24/01/2006 55848
function DisableVIP() {
	var frm=document.forms["fRBOperatingRoom_List"];

	var tbl=document.getElementById("tRBOperatingRoom_List");
	if (tbl) tbl.tCompName="RBOperatingRoom_List";
	for (var i=1;i<tbl.rows.length;i++) {
      	var rowitems=websys_getChildElements(tbl.rows[i].cells[0]);
		//if ((frm.elements['PatientIDz'+i].value=="")&&(frm.elements['EpisodeIDz'+i].value!="")) {
		if ((rowitems['PatientIDz'+i].value=="")&&(rowitems['EpisodeIDz'+i].value!="")) {
			tbl.rows[i].className="clsRowDisabled";
			//var Select=frm.elements["selectz"+i];
			var Select=document.getElementById("selectz"+i);
			if (Select) Select.disabled=true;
			var obj=document.getElementById('Operationz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('Procedurez'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('ArrivedLinkz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('PatientContactedz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			
			var obj=document.getElementById('EquipListz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('AdditionalStaffz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('SecondaryOperationsz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('MainSurgeonz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('MainAnesthiestz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('RecLinkz'+i);
			if (obj) var deletenode=obj.removeNode(false);
		}
	}
	return;
}


var frm=document.forms["fRBOperatingRoom_List"];
var tbl=document.getElementById("tRBOperatingRoom_List");
if (tbl && frm) tbl.tCompName=frm.id.substring(1,frm.id.length);


document.body.onload = DocumentLoadHandler;