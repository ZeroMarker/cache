// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lu_obj=null;
var ageflag=""; var fatalflag=""; var warningflag=""; var dtot="";
var msgstr=""; var evtSrc=""; var evtKey="";
var dischdate=""; var sex="";
var doneInit=0;
var LookUpObject=""; var evtName=""; var evtTimer="";		// cjb 22/09/2005 55579 - copied in scripts_gen functionality
var objDischDate=document.getElementById("DischDate");
if ((objDischDate)&&(objDischDate.value!="")) dischdate=objDischDate.value;

function MRProceduresEditDRGBodyOnLoadHandler() {
	
	SetProceduresTotal();	//KK log 24590 to count the total number of procedure entries

	DisableProcFlds();		// MD 29.06.2005 L 53228 Disable new fileds on load

	var objPROCnew=document.getElementById("PROCnew");
	if (objPROCnew) objPROCnew.onkeydown=SetCursorToUpdate;
	
	doneInit=1;
}

function PROCDocClickHandler(e) {
	MRProcedures_EditDRG_clickhandler(e);
	var eSrc=websys_getSrcElement(e);
	evtSrc=eSrc;
	
	if (eSrc.tagName=="IMG") {
		
		/*
		// cjb 24/08/2006 59020 - commented out all these functions as the list now uses the generated script functions.  These can be deleted after a while
		//
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1241iPROCOperationDRDescz")==0)) {
			if (!(CheckDiagnosesEntered())) return false;
			//the lookup icons for procedure fields
			PROCOperationDR_lookuphandler(e);

			var key=websys_getKey(e);
			var type=websys_getType(e);
			evtKey=type+"^"+key+"^"+eSrc.tagName;
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1241iPROCContractFlag")==0)) {
			// RQG 04.04.03 L32771
			PROCContractFlagCode_lookuphandler(e);
			var key=websys_getKey(e);
			var type=websys_getType(e);
			evtKey=type+"^"+key+"^"+eSrc.tagName;
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1241iPROCProcDate")==0)) {
			PROCDate_lookuphandler(e);
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1241iPROCAliasText")==0)) {
			//md. Log 53228
			PROCAliasText_lookuphandler(e);
			return;
		}
		*/
		
		eSrc=websys_getParentElement(eSrc);
		
		
		if ((eSrc.tagName=="A")&&(eSrc.id)) {
			
			if (eSrc.id.indexOf("PROCmoveupz")==0) {
				eSrc.blur();
				MoveRow(eSrc,"U");
				SetProceduresTotal();
				return false;
			}
			if (eSrc.id.indexOf("PROCmovedownz")==0) {
				eSrc.blur();
				MoveRow(eSrc,"D");
				SetProceduresTotal();
				return false;
			}
			if (eSrc.id.indexOf("PROCdeletez")==0) {
				eSrc.blur();
				DeleteRow(eSrc,1);
				SetProceduresTotal();
				return false;
			}
			
			if (eSrc.id.indexOf("PROCAddAbove")==0) { // cjb 08/02/2005 50600 - user clicked the list button to insert a row above
				eSrc.blur();
				PROCAddAbove();	// add blank row to the end of the table
				var objrow=tk_getRow(eSrc);
				var objtbody=tk_getTBody(objrow);
				// move all the rows from the last (original) row to the one clicked, down one
				for (var i=objtbody.rows.length-2; i>=(objrow.rowIndex-1); i--) {
				var firstcol=objtbody.rows[i].cells[0];
					var rowitems=firstcol.all; //IE only
					if (!rowitems) rowitems=firstcol.getElementsByTagName("*"); //N6
						if (rowitems.length>0) MoveRow(rowitems[0],"D");
				}
				SetProceduresTotal();
				
				// cjb 08/08/2005 52674 - set focus to the row that was 'inserted'
				var tbl=document.getElementById("tMRProcedures_EditDRG");
				if (tbl) {
					var i=objrow.rowIndex-1;
					var proc="";
					var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
					for (var j=0; j<arrfld.length; j++) {
					if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) proc=arrfld[j];
					}
				if (proc) {
					proc.focus();
					}
				}
				return false;
			}
		}
	}
}

function PROCDocKeydownHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	var key=websys_getKey(evt);
	var type=websys_getType(evt);
	
	if ((eSrc.id)&&(eSrc.id.indexOf('PROCProcDatez')==0)) {
		if (!eSrc.onchange) eSrc.onchange=PROCProcDatechangehandler;
		if (key==117) {PROCProcDate_lookuphandler(eSrc);return websys_cancel();}
	}
	
	
	evtSrc=eSrc;
		/*
	if (eSrc.tagName=="INPUT") {
		// cjb 24/08/2006 59020 - commented out all these functions as the list now uses the generated script functions.  These can be deleted after a while
		// 
		if ((eSrc.id)&&(eSrc.id.indexOf("PROCOperationDRDescz")==0)) {
			if (!(CheckDiagnosesEntered())) return false;
			//the procedure fields
			PROCOperationDR_lookuphandler(evt);

		}
		//md. Log 53228
		if ((eSrc.id)&&(eSrc.id.indexOf("PROCAliasTextz")==0)) {
			PROCAliasText_lookuphandler(evt);

		}
		// RQG LOG32517
		if ((eSrc.id)&&(eSrc.id.indexOf("PROCProcDatez")==0)) {
			if ((key==9)||(key==13)) {
				PROCProcDate_changehandler(eSrc);
				//KK 30/07/04 L:44087
				if (!parent.frames["PAAdmDRGCoding"].ValidateProcDate()) {
					websys_setfocus(eSrc.id);
					eSrc.className='clsInvalid';
					return false;
				}else{
					var srcstr=eSrc.id;
					var thisrow=srcstr.substring(srcstr.length,srcstr.length-1);
					thisrow=eval(thisrow)+1;
					var objprocdesc=document.getElementById("PROCOperationDRDescz"+thisrow);
					if (objprocdesc){
						objprocdesc.focus();
						objprocdesc.select();	
						return false;
					}
				}
			}
		}
		
		//rqg,log32771
		if ((eSrc.id)&&(eSrc.id.indexOf("PROCContractFlagz")==0)) {
			//the contract flag field
			PROCContractFlagCode_lookuphandler(evt);
			return;
		}
		
		// cjb 26/08/2004 45775
		if ((eSrc.id)&&(eSrc.id.indexOf("PROCTimeEndz")==0)) {
			if ((key==9)||(key==13)) {
				PROCTimeEnd_changehandler(eSrc);
			}
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("PROCTimeStartz")==0)) {
			if ((key==9)||(key==13)) {
				PROCTimeStart_changehandler(eSrc);
			}
		}
	}
		*/

	//rqg,Log27883: This relates to STAndrews where if "Enter" key is pressed then auto-tab to the next row
	evtKey=type+"^"+key;
	//if ((eSrc.id)&&(eSrc.id.indexOf("PROCOperationDRDescz")==0)) {
	if ((eSrc)&&(eSrc.name!="")&&(eSrc.id)&&(eSrc.id.indexOf("PROCOperationDRDescz")==0)&&(type=='keydown')&&(key==13)) {
		PROCOperationDRDescENTER(evt);
		return false; //to remove beeping sound when keying <ENTER> in textfield
	} else {
		if (type=='click') websys_nextfocus(lu_obj.sourceIndex);
	}
	MRProcedures_EditDRG_keydownhandler(evt);
}

function PROCOperationDRLookUpSelect(str) {
	if (!(CheckDiagnosesEntered())) {
		lu_obj.value="";
		return false;
	}
	
	var lu=str.split("^");
	var coderqmt=lu[13];
	var datemandatory=lu[15];
	
	if (lu_obj) {
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
				arrfld[i].value = lu[0];
			} else if (arrfld[i].id.indexOf("PROCOperationDRCodez")!=-1) {
				arrfld[i].value = lu[2];
			} else if (arrfld[i].id.indexOf("OPERMechVentilCodez")!=-1) {
				//arrfld[i].value = lu[3];
				arrfld[i].value = lu[17];		// cjb 21/08/2006 58987 - changed from 3 to 17 at the query has also been changed
			} else if (arrfld[i].id.indexOf("OPERBlockNumberz")!=-1) {
				arrfld[i].value = lu[4];
			} else if (arrfld[i].id.indexOf("ProcDateMandatoryz")!=-1) {  // AJI 10.11.03 - log40322
				arrfld[i].value = lu[15];
			} else if (arrfld[i].id.indexOf("PROCProcDatez")!=-1) {
				if (datemandatory=="Y") IsSameDayEpisode(arrfld[i].id); // AJI 10.11.03 - log40322
			} else {
				arrfld[i].value = "";
			}
		}
	}
	
	//rqg,Log27337: New function for ICD codes editing
	CheckProcLookUpDetails(str);
	
	var ttbl=document.getElementById("tMRProcedures_EditDRG");
	if (ttbl) {
		// cjb 28/04/2005 50592 - taken this for loop out as there is no need to go down every row as we know the row number from lu_obj.id.  We may be able to get rid of the proc stuff now as we know we've got the correct row...
		var cjb=lu_obj.id.split("PROCOperationDRDescz");
		var i=cjb[1];
		var addrqmt=""; var proc=""; var objdtmandatory=""; var objprocdate="";
		var arrfld=ttbl.rows[i].getElementsByTagName('INPUT');
		for (var j=0; j<arrfld.length; j++) {
			if (arrfld[j].id.indexOf("AddProcCodeRqmtz")==0) addrqmt=arrfld[j];
			if (arrfld[j].id.indexOf("ProcDateMandatoryz")==0) objdtmandatory=arrfld[j];
			if (arrfld[j].id.indexOf("PROCProcDatez")==0) {
				if (objdtmandatory.value=="Y") var currow=i;		//KK 30/07/04 L:44087
			}
			if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) {
				if (arrfld[j].id==lu_obj.id) proc=arrfld[j].value;
			}
		}
		
		// cjb 28/04/2005 50592 - rewritten this so proc is only checked once
		if (proc!="") {
			if (addrqmt) addrqmt.value=coderqmt;
			if (objdtmandatory) objdtmandatory.value=datemandatory;
		}
	}
	
	//KK Log 24590 to count the total number of procedure entries
	SetProceduresTotal();
	
	var type=mPiece(evtKey,"^",0);
	var key=mPiece(evtKey,"^",1);
	var img=mPiece(evtKey,"^",2);
	if ((type=="keydown")&&(key=="117")) {
		if ((msgstr!="")&&(evtSrc!="")) DisplayProcMessage(evtSrc,msgstr);
		//websys_nextfocus(lu_obj.sourceIndex);
	}
	
	if (img=="IMG") {
		if ((evtSrc.id!="")&&(evtSrc.id.indexOf("lt1241iPROCOperationDRDescz")==0)) {
			if ((msgstr!="")&&(evtSrc!="")) DisplayProcMessage(evtSrc,msgstr);
		}
		//websys_nextfocus(lu_obj.sourceIndex);
	}
	if ((currow)&&(objdtmandatory.value=="Y")){
		var objprocdate=document.getElementById("PROCProcDatez"+currow);
		if (objprocdate) {
			try {
				objprocdate.focus();
				objprocdate.select();
			}catch(e){}
		}
	}
}

// cjb 25/08/2006 59020 - overwrite the lookupSelect generated function to validate the date
function PROCProcDate_lookupSelect(dateval) {
	if (lu_obj) {
		lu_obj.value=dateval;
		websys_nextfocusElement(lu_obj);
		if (!parent.frames["PAAdmDRGCoding"].ValidateProcDate()) {
			websys_setfocus(eSrc.id);
			lu_obj.className='clsInvalid';
			return false;
		} else {
			var srcstr=lu_obj.id;
			var thisrow=srcstr.substring(srcstr.length,srcstr.length-1);
			thisrow=eval(thisrow)+1;
			var objprocdesc=document.getElementById("PROCOperationDRDescz"+thisrow);
			if (objprocdesc){
				objprocdesc.focus();
				objprocdesc.select();	
				return false;
			}
		}
	}
}

function PROCProcDatechangehandler(e) {
	PROCProcDate_changehandler(e);
	var eSrc=websys_getSrcElement(e);
	if (!parent.frames["PAAdmDRGCoding"].ValidateProcDate()) {
		websys_setfocus(eSrc.id);
		eSrc.className='clsInvalid';
		return false;
	} else {
		var srcstr=eSrc.id;
		var thisrow=srcstr.substring(srcstr.length,srcstr.length-1);
		thisrow=eval(thisrow)+1;
		var objprocdesc=document.getElementById("PROCOperationDRDescz"+thisrow);
		if (objprocdesc){
			objprocdesc.focus();
			objprocdesc.select();	
			return false;
		}
	}
}


// rqg/SA,16.10.02 - Log27883: This automatically moves the cursor to the next diagnosis field. If at the last diagnosis row in the table, move to "New Diagnosis" link.
function PROCOperationDRDescENTER(e) {
	var obj = websys_getSrcElement(e);
	var objrow=obj;
	var focusset="";

	while(objrow.tagName != "TR") {
		objrow=websys_getParentElement(objrow);
	}
	var row=objrow.sectionRowIndex+1;

	tbl=websys_getParentElement(objrow);
	for (var j=row;j<tbl.rows.length;j++) {
		var objnextrow=tbl.rows[j];
		if (objnextrow) {
			var arrfld=objnextrow.getElementsByTagName("INPUT");
			for (var i=0; i<arrfld.length; i++) {
				if (arrfld[i].id.indexOf("PROCOperationDRDescz")!=-1) {
					var nxtobj=arrfld[i];
					if (nxtobj) {
						if (nxtobj!=obj) {
							nxtobj.focus();
							nxtobj.select();
							focusset=1;
							//return false;
						}
					}
				}
				//KK 30/07/04 L:44087
				var objdtmandatory=document.getElementById("ProcDateMandatoryz"+j);
				if ((objdtmandatory)&&(objdtmandatory.value=="Y")){
					var objprocdate=document.getElementById("PROCProcDatez"+j);
					if (objprocdate) {
						try {
							objprocdate.focus();
							objprocdate.select();
						}catch(e){}
						focusset=1;
						//return false;
					}
				}
				if (focusset) return false;
			}
		}
	}
	var objNew=document.getElementById("PROCnew");
	if (objNew) websys_setfocus(objNew.name);
}


// rqg/SA,16.10.02 - Log27883: This will set focus to "Update" button or "Run DRGInquiry" link after tabbing off from "New procedure" link
// keycode 9 is "TAB"
function SetCursorToUpdate() {
	if (window.event.keyCode==9)	{
		if (top.frames["TRAK_main"].frames["PAAdmDRGCoding"]) {
			var fra=top.frames["TRAK_main"].frames["PAAdmDRGCoding"];
			var frm=fra.document.getElementById("fPAAdm_DRGCoding");
			if (frm) {
				var obj3MGrouper=frm.document.getElementById("B3MGrouper")
				var objUpdate=frm.document.getElementById("DRGupdate");
				var objDRGInquiry=frm.document.getElementById("DRGInquiry");
				if (obj3MGrouper) {
					Updsetfocus(obj3MGrouper.name);
				} else if (objUpdate) {
					Updsetfocus(objUpdate.name);
				} else if (objDRGInquiry) {
					Updsetfocus(objDRGInquiry.name);
				}
			}
		}
	}
}

function Updsetfocus(objName) {
	setTimeout('Updsetfocus2(\''+objName+'\')',10);
}

function Updsetfocus2(objName) {
	var obj=top.frames["TRAK_main"].frames["PAAdmDRGCoding"].document.getElementById(objName);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
}

//KK 25/Jun/2002 Log 24570 count and set total number of procedures
function SetProceduresTotal() {
	var proctotal=0;
	var objTP=document.getElementById('TotalProcedures');
	var tbl=document.getElementById("tMRProcedures_EditDRG");
	if ((tbl)&&(objTP)) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if (arrId[0]=="PROCOperationDRDesc")  {
				if (arrInput[i].value!="") {
					proctotal++;
				}
			}
		}
		objTP.innerText=proctotal;
	}
	SetProcSeqNum(proctotal);		// cjb 28/04/2005 50592 - moved this out of the for loop...
	return false;
}

function SetProcSeqNum(seqnum){
	if (seqnum==0) return;
	var sno=0;	
	var quit=0;	
	var temp;
	var objSeqNo;
	var ttbl=document.getElementById("tMRProcedures_EditDRG");
	if (ttbl) {
		for (var i=1; quit==0; i++) {  // cjb 28/04/2005 50592 - changed the condition of the loop to check the value of quit.  quit is set when the LineNo column isn't on the form, or the last row is checked
			var fldSequ=0; var diag="";
			var arrfld=ttbl.rows[i].getElementsByTagName('INPUT');
			for (var j=0; j<arrfld.length; j++) {
				if (arrfld[j].id.indexOf("ProcLinez")==0) fldSequ=arrfld[j];
				if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) diag=arrfld[j].value;
			}
			
			if (!fldSequ.id) quit=1;				// LineNo column isn't on the form
			if (i==ttbl.rows.length-1) quit=1;		// last row is checked
			
			if ((diag!="")&&(fldSequ)) {
				sno++;
				fldSequ.value=sno;
			}
		}
	}
}

//SA 24.6.02 - log 24577: This function will clear all procedure codes from the screen.
function ClearProcedures() {
	var tbl=document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if (arrId[0]!="PSeqNo") {
				arrInput[i].value="";
			}
		}
	}
	SetProceduresTotal();
	//md 53228
	DisableProcFlds()
	return false;
}

// SA 26.6.02 - log 24582: Require a warning message to be returned when a procedure has been selected before any diagnoses have been entered.
function CheckDiagnosesEntered() {
	if (parent.frames["MRDiagnosEditDRG"]) dtot = parent.frames["MRDiagnosEditDRG"].document.getElementById('DiagnosTotal');
	if (dtot) {
		if (dtot.innerText=="0") {
			alert(t['ENTER_DIAG_FIRST']);
			return false;
		}
	}
	return true;
}

function PROCAdd() {
	var tbl=document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		AddRow(tbl);
		// rqg 05.11.02, Log27883: Set focus to last row's procedure's field when a new row is added
		for (var i=1; i<=tbl.rows.length; i++) {
			var proc="";
			var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
			for (var j=0; j<arrfld.length; j++) {
				if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) proc=arrfld[j];
			}
			if (proc && proc.value=="") {
				proc.focus();
				break;
			}
		}
	}
	return false;
}
function PROCAddAbove() {
	var tbl=document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		AddRow(tbl);
	}
	return false;
}


//Split the array with the passed delimeter
function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);
	
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) {
		return delimArray[n];
	} else {
		return ""					
	}
}

function CheckProcLookUpDetails(str) {
	//dummy     	; This function is defined in ARMC and QH custom scripts
}
//rqg Log27337
function DisplayProcMessage() {
	//dummy     	; This function is defined in ARMC custom script
}
function IsSameDayEpisode(str) {
	//dummy     	; This function is defined in QH custom script
}
//md 29.06.2005 53228
function DisableProcFlds() {
	//dummy     	; This function is defined in St George NZ custom script
}






///// cjb 24/08/2006 59020 - commented out all these functions as the list now uses the generated script functions.  These can be deleted after a while

//////
//override the functions from scripts_gen folder
//////
/*
function PROCOperationDR_lookuphandler(evt) {
	if (evtName=='PROCOperationDR') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(evt);
	var key=websys_getKey(evt);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp';
		// RQG 04.09.03 L38837: New lookup syntax
		url += "?ID=d1241iPROCOperationDR&CONTEXT=Kweb.ORCOperation:LookUpOperationKeyWord&TLUJSF=PROCOperationDRLookUpSelect";
		//url += "?ID=d1241iPROCOperationDR&CONTEXT=Kweb.ORCOperation:LookUpOnDischDate&TLUJSF=PROCOperationDRLookUpSelect";
		lu_obj=websys_getSrcElement(evt);
		if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
		if (lu_obj) url += "&P1=" + lu_obj.value;
		url += "&P2=&P3=" + dischdate;
		//url += "&P2=" + dischdate;
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function PROCOperationDR_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			//rqg,Log27883:Focus is now set in the keydownhandler function.
			//websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}
function PROCOperationDR_changehandler(encmeth) {
	evtName='PROCOperationDR';
	if (doneInit) { evtTimer=window.setTimeout("PROCOperationDR_changehandlerX('"+encmeth+"');",200); }
	else { PROCOperationDR_changehandlerX(encmeth); evtTimer=""; }
}

function PROCOperationDR_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var p1='';
	
	var obj=LookUpObject
	
	if (obj) {
		lu_obj=obj;
		p1=obj.value;
	}
	var p2=dischdate;
	if (cspRunServerMethod(encmeth,'PROCOperationDR_lookupsel','PROCOperationDRLookUpSelect',p1,p2)=='0') {
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		//rqg Log27337
		if ((fatalflag=="true")||(warningflag=="true")) {
			obj.className='clsInvalid';
		} else {
			obj.className='';
		}
	}
}

function PROCDate_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var eSrc=websys_getSrcElement(e);
		eSrc.className='';
		if ((eSrc)&&(eSrc.tagName=="IMG")) eSrc=eSrc.previousSibling;
		lu_obj=eSrc;
		if (!IsValidDate(eSrc)) {
			eSrc.className='clsInvalid';
			websys_setfocus(eSrc.name);
			return  websys_cancel();
		}
		var url='websys.lookupdate.csp?ID=PROCDate&STARTVAL=';
		url += '&DATEVAL=' + escape(eSrc.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
//overrides generated function
function PROCDate_lookupSelect(str) {
	try {
		if (lu_obj) {
			//alert(lu_obj.name+":"+str);
  			lu_obj.value=unescape(str);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}

function PROCDate_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}
function PROCProcDate_changehandler(encmeth,e) {
	var p1="";
	eSrc=websys_getSrcElement(e);
	eSrc.className='';
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.name);
		return  websys_cancel();
	}

}

// RQG 04.04.03 L32771
function PROCContractFlag_changehandler(encmeth,e) {
	LookUpObject=websys_getSrcElement(e);
	evtName='PROCContractFlag';
	if (doneInit) { evtTimer=window.setTimeout("PROCContractFlag_changehandlerX('"+encmeth+"');",200); }
	else { PROCContractFlag_changehandlerX(encmeth); evtTimer=""; }
}

function PROCContractFlag_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=LookUpObject;
	var p1='';
	var p2='';
	if (obj) {
		lu_obj=obj;
		p1=obj.value;
	}
	var objesid=document.getElementById("EpisodeID");
	if (objesid) p2=objesid.value;
	if ((p1!='')&&(cspRunServerMethod(encmeth,'PROCContractFlagCode_lookupsel','PROCContractFlagCodeLookUpSelect',p1,p2)=='0')) {
		if (obj) {
			obj.className='clsInvalid';
			obj.focus();
			return websys_cancel();
		}
	} else {
		if (obj) obj.className='';
	}
}



function PROCContractFlagCode_lookuphandler(evt) {
	if (evtName=='PROCContractFlag') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(evt);
	var key=websys_getKey(evt);
	var EsId="";
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var objesid=document.getElementById("EpisodeID");
 		if (objesid) EsId=objesid.value;
		// RQG 04.09.03 L38837: New lookup Syntax
		var url="websys.lookup.csp?ID=d1241iPROCContractFlagCode&CONTEXT=Kweb.MRCContractFlag:LookUpCF";
		lu_obj=websys_getSrcElement(evt);
		if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
		if (lu_obj) url += "&P1=" + lu_obj.value;
		url += "&P2=" + EsId;
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'');
		return websys_cancel();
		//return; //websys_cancel();
	}
}

function PROCContractFlagCodeLookUpSelect(str) {
	var lu=str.split("^");
	if (lu_obj) {
		lu_obj.value=lu[1];
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
			} else if (arrfld[i].id.indexOf("PROCContractFlagz")!=-1) {
				arrfld[i].value = lu[1];
			}
		}
	}
}

function PROCContractFlagCode_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}



//md. Log 53228
function PROCAliasText_changehandler(encmeth,e) {
	var obj=websys_getSrcElement(e);
	var p1='';
	var p2='';
	if (obj) {
		lu_obj=obj;
		p2=obj.value;
	}
	var objrow=lu_obj;
	while (objrow.tagName!="TR") {objrow=objrow.parentElement}
	var arrfld=objrow.getElementsByTagName('INPUT');
	for (var i=0; i<arrfld.length; i++) {
		if (arrfld[i].id.indexOf("PROCOperationDRCodez")!=-1) {
			p1=arrfld[i].value;
		}
	}
	
	if ((p1!='')&&(cspRunServerMethod(encmeth,'PROCAliasText_lookupsel','PROCAliasTextLookUpSelect',p1,p2)=='0')) {
		if (obj) {
			obj.className='clsInvalid';
			obj.focus();
			return websys_cancel();
		}
	} else {
		if (obj) obj.className='';
	}
}
function PROCAliasText_lookuphandler(evt) {
	var type=websys_getType(evt);
	var key=websys_getKey(evt);
	var EsId="";
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp?ID=d1241iPROCAliasText&CONTEXT=Kweb.ORCOperation:LookUpFreeAlias';
		lu_obj=websys_getSrcElement(evt);
		if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
		if (arrfld[i].id.indexOf("PROCOperationDRCodez")!=-1) {
		p1=arrfld[i].value;
		}
		}
		if (lu_obj) url += "&P1=" + p1;
		url += "&P2=" + lu_obj.value;
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'');
		return; //websys_cancel();
	}
}

function PROCAliasTextLookUpSelect(str) {
	var lu=str.split("^");
	if (lu_obj) {
		lu_obj.value=lu[1];
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
			} else if (arrfld[i].id.indexOf("PROCAliasTextz")!=-1) {
				arrfld[i].value = lu[0];
			}
		}
	}
}

function PROCAliasText_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}

//md. Log 53228

// cjb 26/08/2004 45775
function PROCTimeStart_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('PROCTimeStart');
		return websys_cancel();
	} else {
		eSrc.className='';
	}
}

function PROCTimeEnd_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('PROCTimeEnd');
		return websys_cancel();
	} else {
		eSrc.className='';
	}
}

// cjb 26/08/2004 45775
function IsValidTime(fld) {
 var TIMER=0;
 var tm=fld.value;
 var re = /^(\s)+/ ; tm=tm.replace(re,'');
 var re = /(\s)+$/ ; tm=tm.replace(re,'');
 var re = /(\s){2,}/g ; tm=tm.replace(re,' ');
 tm=tm.toUpperCase();
 var x=tm.indexOf(' AM');
 if (x==-1) x=tm.indexOf(' PM');
 if (x!=-1) tm=tm.substring(0,x)+tm.substr(x+1);
 if (tm=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 tm=tm.replace(re,':');
 if (isNaN(tm.charAt(0))) return ConvNTime(fld);
 if ((tm.indexOf(':')==-1)&&(tm.length>2)) tm=ConvertNoDelimTime(tm);
 symIdx=tm.indexOf('PM');
 if (symIdx==-1) {
  symIdx=tm.indexOf('AM');
  if (symIdx!=-1) {
   if (tm.slice(symIdx)!='AM') return 0;
   else {
    tm=tm.slice(0,symIdx);
    TIMER=1;
  }}
 } else {
  if (tm.slice(symIdx)!='PM') return 0;
  else {
   tm=tm.slice(0,symIdx);
   TIMER=2;
  }
 }
 if (tm=='') return 0;
 var tmArr=tm.split(':');
 var len=tmArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (tmArr[i]=='') return 0;
 }
 var hr=tmArr[0];
 var mn=tmArr[1];
 var sc=tmArr[2];
 if (len==1) {
  mn=0;
  sc=0;
 } else if (len==2) {
  if (mn.length!=2) return 0;
  sc=0;
 } else if (len==3) {
  if (mn.length!=2) return 0;
  if (sc.length!=2) return 0;
 }
 if ((hr>12)&&(TIMER==1)) return 0;
 if ((hr==12)&&(TIMER==1)) hr=00;
 if ( isNaN(hr)||isNaN(mn)||isNaN(sc) ) return 0;
 hr=parseInt(hr,10);
 mn=parseInt(mn,10);
 sc=parseInt(sc,10);
 if ((hr>23)||(hr<0)||(mn>59)||(mn<0)||(sc>59)||(sc<0)) return 0;
 if ((hr<12)&&(TIMER==2)) hr+=12;
 fld.value=ReWriteTime(hr,mn,sc);
 websys_returnEvent();
 return 1;
}
function ConvNTime(fld) {
 var now=new Date();
 var tm=fld.value;
 var re = /(\s)+/g ;
 tm=tm.replace(re,'');
 if (tm.charAt(0).toUpperCase()=='N') {
  xmin = tm.slice(2);
  if (xmin=='') xmin=0;
  if (isNaN(xmin)) return 0;
  xmin_ms = xmin * 60 * 1000;
  if (tm.charAt(1) == '+') now.setTime(now.getTime() + xmin_ms);
  else if (tm.charAt(1) == '-') now.setTime(now.getTime() - xmin_ms);
  else if (tm.length>1) return 0;
  fld.value=ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertNoDelimTime(tm)  {
 if (isNaN(tm)) return tm;
 var hr=tm.slice(0,2);
 var mn=tm.slice(2);
 var tmconv=hr+':'+mn;
 return tmconv
}

function PROCOperation_changehandler(encmeth,e) {
	if (!(CheckDiagnosesEntered())) return false;
	var eSrc=websys_getSrcElement(e);
	
	// cjb 30/01/2004 42030 - check the defaultValue (set below, when the broker has previously run from this field)
	// if defaultValue is the same as the current value, return false - don't run the broker
	if (eSrc.defaultValue==eSrc.value) return false;
	LookUpObject=eSrc
	//PROCOperationDR_changehandler(encmeth);
	PROCOperationDRDesc_changehandler(encmeth,e);
	
	eSrc.defaultValue=eSrc.value	// cjb 30/01/2004 42030 set defaultValue to the description returned
	
	if (msgstr!="") DisplayProcMessage(eSrc,msgstr);		//rqg Log27337
	
	IsSameDayEpisode(eSrc.id);		// RQG 14.04.03 L32770 - Set Procedure Date to Discharge Date if it is a sameday episode.
}

function PROCProcDatelookuphandler(e) {
	PROCProcDate_lookuphandler(e);
	var eSrc=websys_getSrcElement(e);
	//alert(eSrc.value);
	//PROCProcDatechangehandler(e);
	var eSrc=websys_getSrcElement(e);
	if (!parent.frames["PAAdmDRGCoding"].ValidateProcDate()) {
		websys_setfocus(eSrc.id);
		eSrc.className='clsInvalid';
		return false;
	} else {
		var srcstr=eSrc.id;
		var thisrow=srcstr.substring(srcstr.length,srcstr.length-1);
		thisrow=eval(thisrow)+1;
		var objprocdesc=document.getElementById("PROCOperationDRDescz"+thisrow);
		if (objprocdesc){
			objprocdesc.focus();
			objprocdesc.select();	
			return false;
		}
	}
}


*/







var obj=document.getElementById("PROCnew");
if (obj) obj.onclick=PROCAdd;

var objClearAll=document.getElementById("ClearAllProc");
if (objClearAll) objClearAll.onclick=ClearProcedures;

var tblPROC=document.getElementById("tMRProcedures_EditDRG")
if (tblPROC) {
	tblPROC.onkeydown=PROCDocKeydownHandler;
	tblPROC.onclick=PROCDocClickHandler;
}

document.body.onload=MRProceduresEditDRGBodyOnLoadHandler;