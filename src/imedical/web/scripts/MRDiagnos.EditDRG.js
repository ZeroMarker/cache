// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lu_obj=null;
var locid="";
var objLoc=document.getElementById("CTLOCID");
if (objLoc) locid=objLoc.value;

var dischdate="";		//rqg,Log 27545,need to set the dischargedate in the lookup handler
//rqg,Log 27337 - 12.11.02: New variables for ICD Coding Edits
var ageflag=""; var fatalflag=""; var warningflag="";
var msgstr=""; var sex=""; var evtKey="";
var doneInit=0;
var LookUpObject=""; var evtName=""; var evtTimer="";		// cjb 22/09/2005 55579 - copied in scripts_gen functionality
var objEpisodeID=document.getElementById("EpisodeID");

function MRDiagnosEditDRGBodyOnLoadHandler() {
	
	SetDiagnosTotal();
	
	// Because the DRG coding page uses 3 separate components with their own standard and custom js files, each standard js file load handler must call the corresponding custom load handler.
	try {MRDiagnosEditDRGCustomDocumentLoadHandler(); } catch(e) {}
	
	// Set cursor to first prefix field if prefix column present.  If no prefix column, set to 1st diagnosis code field.
	var obj1stPrefix=document.getElementById("MRDIAPrefixz1");
	if (obj1stPrefix) {
		websys_setfocus(obj1stPrefix.name);
	} else {
		var objCode=document.getElementById("MRDIAICDCodeDRDescz1");
		websys_setfocus(objCode.name);
	}

	var objNew=document.getElementById("MRDIAnew");
	if (objNew) objNew.onkeydown=SetCursorToProc;

	DisableContractFlag();		// RQG 07.04.04 32771: Disable ContractFlag fields on startup
	
	DisableDiagFlds();			// MD 29.06.2005 53228/9 Disable new fileds on load
	var objDischargeDate=document.getElementById("MRDischargeDate");
	if (objDischargeDate) dischdate=objDischargeDate.value;
	
	doneInit=1;
}


function MRDIADocClickHandler(e) {
	MRDiagnos_EditDRG_clickhandler(e);
	var eSrc=websys_getSrcElement(e);
	
	if (eSrc.tagName=="IMG") {
		/*
		// cjb 24/08/2006 59020 - commented out all these functions as the list now uses the generated script functions.  These can be deleted after a while
		// 
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1240iMRDIAICDCodeDR")==0)) {
			// the lookup icons for diagnosis fields
			MRDIAICDCodeDR_lookuphandler(e);
			var key=websys_getKey(e);
			var type=websys_getType(e);
			evtKey=type+"^"+key+"^"+eSrc.tagName;

			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1240iMRDIAPrefix")==0)) {
			//rqg,log 24573: the lookup icons for prefix fields
			MRDIAPrefix_lookuphandler(e);
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1240iMRContractFlag")==0)) {
			// RQG 04.04.03 L32771
			MRContractFlagCode_lookuphandler(e);
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("lt1240iMRDIAAliasDiagText")==0)) {
			MRDIAAliasDiagText_lookuphandler(e);
			return;
		} else {
			//eSrc=websys_getParentElement(eSrc);
		}
		*/
		
		eSrc=websys_getParentElement(eSrc);
	
		if ((eSrc.tagName=="A")&&(eSrc.id)) {
			// up,down,delete,add buttons
			if (eSrc.id.indexOf("MRDIAmoveupz")==0) {
				eSrc.blur();
				MoveRow(eSrc,"U");
				SetDiagnosTotal();
				return false;
			} else if (eSrc.id.indexOf("MRDIAmovedownz")==0) {
				eSrc.blur();
				MoveRow(eSrc,"D");
				SetDiagnosTotal();
				return false;
			} else if (eSrc.id.indexOf("MRDIAdeletez")==0) {
				eSrc.blur();
				MRDIAICDCodeDRENTER(eSrc);
				DeleteRow(eSrc,1);
				ChangePrefix(eSrc,1);
				SetDiagnosTotal();
				return false;
			} else if (eSrc.id.indexOf("MRDIAAddAbove")==0) { // cjb 08/02/2005 50600 - user clicked the list button to insert a row above
				eSrc.blur();
				MRDIAAddAbove();	// add blank row to the end of the table
				var objrow=tk_getRow(eSrc);
				var objtbody=tk_getTBody(objrow);
				//alert("objrow="+objrow.rowIndex+"   objtbody="+objtbody.rows.length);
				// move all the rows from the last (original) row to the one clicked, down one
				for (var i=objtbody.rows.length-2; i>=(objrow.rowIndex-1); i--) {
					var firstcol=objtbody.rows[i].cells[0];
					var rowitems=firstcol.all; //IE only
					if (!rowitems) rowitems=firstcol.getElementsByTagName("*"); //N6
					if (rowitems.length>0) MoveRow(rowitems[0],"D");
				}
				SetDiagnosTotal();
				
				// cjb 08/08/2005 52674 - set focus to the row that was 'inserted'
				var tbl=document.getElementById("tMRDiagnos_EditDRG");
				if (tbl) {
					var i=objrow.rowIndex-1;
					var diag=""; var prefix="";
					var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
					for (var j=0; j<arrfld.length; j++) {
						if (arrfld[j].id.indexOf("MRDIAPrefixz")==0) prefix=arrfld[j];
						if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) diag=arrfld[j];
					}
					if (prefix) {
						prefix.focus();
					} else {
						diag.focus();
						}
				}
				return false;
			}
		}
	}
}

function MRDIADocKeydownHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	var key=websys_getKey(evt);
	var type=websys_getType(evt);
	
	if (eSrc.tagName=="INPUT") {
		//md 53229
		if ((eSrc.id)&&(eSrc.id.indexOf("MRDIAAccidentDate")==0)) {
			if ((key==9)||(key==13)) {
				MRDIAAccidentDate_changehandler(eSrc);
			}
		}
		/*
		// cjb 24/08/2006 59020 - commented out all these functions as the list now uses the generated script functions.  These can be deleted after a while
		// 
		if ((eSrc.id)&&(eSrc.id.indexOf("MRDIAICDCodeDR")==0)) {
			var key=websys_getKey(evt);
			var type=websys_getType(evt);
			alert(key);
			if ((eSrc)&&(eSrc.name!="")&&(type=='keydown')&&(key==13)) {
				MRDIAICDCodeDRENTER(evt);
				if (key!=117) return false;
			}
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("MRDIAICDCodeDR")==0)) {
			// the diagnosis fields
			//md log 55893
			var key=websys_getKey(evt);
			var type=websys_getType(evt);
			if ((eSrc)&&(eSrc.name!="")&&(type=='keydown')&&((key==13)||(key==117))) {
			MRDIAICDCodeDRENTER(evt);
			if (key!=117) return false;
			}
			//md log 55893
			MRDIAICDCodeDR_lookuphandler(evt);
			return;
		}
		// rqg,log 24573
		if ((eSrc.id)&&(eSrc.id.indexOf("MRDIAPrefix")==0)) {
			// the prefix fields
			MRDIAPrefix_lookuphandler(evt);
			return;
		}
		// rqg,log 32771
		if ((eSrc.id)&&(eSrc.id.indexOf("MRContractFlag")==0)) {
			// the contract flag field
			MRContractFlagCode_lookuphandler(evt);
			return;
		}
		if ((eSrc.id)&&(eSrc.id.indexOf("MRDIAAliasDiagText")==0)) {
			// the diagnosis fields
			MRDIAAliasDiagText_lookuphandler(evt);
		}
		*/
	}
	
	// rqg,Log 27883: This relates to St Andrews where if "Enter" key is pressed then auto-tab to the next row
	evtKey=type+"^"+key;
	//if ((eSrc)&&(eSrc.name!="")&&(type=='keydown')&&((key==13)||(key==117))) {
	if ((eSrc)&&(eSrc.name!="")&&(eSrc.id)&&(eSrc.id.indexOf("MRDIAICDCodeDRDescz")==0)&&(type=='keydown')&&(key==13)) {
		MRDIAICDCodeDRENTER(evt);
		return false; // to remove beeping sound when keying <ENTER> in textfield
	} else {
		if (type=='click') websys_nextfocus(lu_obj.sourceIndex);
	}
	MRDiagnos_EditDRG_keydownhandler(evt);
}

function MRDIAICDCodeDRLookUpSelect(str) {
	var prefix="";  //KK 21/jun/04 L:43897
	var lu=str.split("^");
	if (lu_obj) {
		var eSrc=lu_obj;
		var arrDiag=lu[0].split(" | ");
		lu_obj.value=arrDiag[0];
		if (lu_obj.id.indexOf("Ext")==-1) {
			var objrow=lu_obj;
			while (objrow.tagName!="TR") {objrow=objrow.parentElement}
			var arrfld=objrow.getElementsByTagName('INPUT');
			for (var i=1; i<arrfld.length; i++) {
				if (arrfld[i]==lu_obj) {
				} else if (arrfld[i].id.indexOf("MRDIAICDCodeDRCodez")!=-1) {
					arrfld[i].value = lu[2];
				// RQG Log 27337: Prefix is being set to blank, so we need to check if the fld is "Prefix"
				} else if (arrfld[i].id.indexOf("MRDIAPrefixz")!=-1) {
					// do nothing
					//KK 21/jun/04 L:43897
					prefix="";
					prefix=arrfld[i].value;
				} else if (arrfld[i].id.indexOf("MRContractFlagz")!=-1) {
				} else {
					arrfld[i].value = "";
				}
			}
		// rqg,Log 25417: Display the extension codes as well.
		} else {
			var objrow=lu_obj;
			while (objrow.tagName!="TR") {objrow=objrow.parentElement}
			var arrfld=objrow.getElementsByTagName('INPUT');
			for (var i=1; i<arrfld.length; i++) {
				if (arrfld[i]==lu_obj) {
					var pos=lu_obj.id.indexOf("Ext");
					var objname=lu_obj.id
					objname=objname.substring(pos);
    					for (var j=i+1; j<arrfld.length; j++) {
						tagname="Code"+objname;
						if (arrfld[j].id==tagname) {
							arrfld[j].value = lu[2];
							i = arrfld.length+1;
							j = i;
						}
					}
				}
			}
		}
	}
	//rqg,Log 27337: New function for ICD codes editing
	//KK 21/jun/04 43897
	str=str+prefix;
	CheckLookUpDetails(str);
	// Set value for Additional Code Requirement

	var coderqmt=lu[11];
	var codeprac=lu[12];
	var cancer=lu[14];
	var sexrestrx=lu[15];
	var unacceptpdx=lu[16];
	var morphology=lu[17];
	var extcause=lu[18];
	var injury=lu[19];
      var validMCodeExt=lu[20];
      var codeinpair=lu[21];
	var ctcodepair=lu[22];
	var allowdup=lu[24];
	
	var ttbl=document.getElementById("tMRDiagnos_EditDRG");
	if (ttbl) {
		var cjb=""; vari="";
		// cjb 28/04/2005 50592 - taken this for loop out as there is no need to go down every row as we know the row number from lu_obj.id.  We may be able to get rid of the diag stuff now as we know we've got the correct row...
		if (lu_obj.id.indexOf("MRDIAICDCodeDRDescz")==0) cjb=lu_obj.id.split("MRDIAICDCodeDRDescz");  i=cjb[1];
		if (lu_obj.id.indexOf("MRDIAICDCodeDRExt1z")==0) cjb=lu_obj.id.split("MRDIAICDCodeDRExt1z");  i=cjb[1];
		if (lu_obj.id.indexOf("MRDIAICDCodeDRExt2z")==0) cjb=lu_obj.id.split("MRDIAICDCodeDRExt2z");  i=cjb[1];
		if (lu_obj.id.indexOf("MRDIAICDCodeDRExt3z")==0) cjb=lu_obj.id.split("MRDIAICDCodeDRExt3z");  i=cjb[1];
		
		//var cjb=lu_obj.id.split("MRDIAICDCodeDRDescz");
		//var i=cjb[1];
		//for (var i=1; i<ttbl.rows.length; i++) {
		var addrqmt=""; diag=""; var objcancer=""; var objmorph=""; var objext=""; var objunacceptpdx="";
		var objcodeprac=""; var objvalidMCodeExt=""; var objCodePair=""; var objCTCodePr=""; var objAllowDup="";
		var arrfld=ttbl.rows[i].getElementsByTagName('INPUT');
		for (var j=0; j<arrfld.length; j++) {
			if (arrfld[j].id.indexOf("AddCodeRqmtz")==0) addrqmt=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDCodingPracticesz")==0) objcodeprac=arrfld[j];
			if (arrfld[j].id.indexOf("MRCancerz")==0) objcancer=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDSexz")==0) objsex=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDUnacceptablePDxz")==0) objunacceptpdx=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDMorphologyCodez")==0) objmorph=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDExternalCausez")==0) objext=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDInjuryPoisoningCodez")==0) objinjury=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDValidMCodeExtz")==0) objvalidMCodeExt=arrfld[j];
			if (arrfld[j].id.indexOf("codeinpairz")==0) objCodePair=arrfld[j];
			if (arrfld[j].id.indexOf("MRCID2ndCodeInPairz")==0) objCTCodePr=arrfld[j];
			if (arrfld[j].id.indexOf("MRCIDAllowToDuplicatez")==0) objAllowDup=arrfld[j];
			if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) {
				if (arrfld[j].id==lu_obj.id)  diag=arrfld[j].value;
			}
		}
		
		// cjb 28/04/2005 50592 - rewritten this so diag is only checked once
		if (diag!="") {
			if (addrqmt) addrqmt.value=coderqmt;
			if (objcodeprac) objcodeprac.value=codeprac;
			if (objcancer) objcancer.value=cancer;
			if (objsex) objsex.value=sexrestrx;
			if (objunacceptpdx) objunacceptpdx.value=unacceptpdx;
			if (objmorph) objmorph.value=morphology;
			if (objext) objext.value=extcause;
			if (objinjury) objinjury.value=injury;
			if (objvalidMCodeExt) objvalidMCodeExt.value=validMCodeExt;
			if (objCodePair) objCodePair.value=codeinpair;
			if (objCTCodePr) objCTCodePr.value=ctcodepair;
			if (objAllowDup) objAllowDup.value=allowdup;
		}
		
		//}
	}
	
	SetDiagnosTotal();
	
	//KK 02/09/04 45797 - Display error message and clear message.
	if ((eSrc)&&(msgstr!="")){
		DisplayMessage(eSrc,msgstr);
		msgstr="";
	}
}


function MRDIAPrefixLookUpSelect(str) {
	var lu=str.split("^");
	if (lu_obj) {
		//var arrDiag=lu[0].split(" | ");
		//lu_obj.value=arrDiag[0];
		if (lu[1]!="") lu_obj.value=lu[1];
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
			} else if (arrfld[i].id.indexOf("MRDIAPrefixz")!=-1) {
				arrfld[i].value = lu[2];
			}
		}
	      //if (lu_obj.className!='clsInvalid') websys_nextfocus(lu_obj.sourceIndex);
		//if ((lu_obj.value!="A")&&(lu_obj.value!="C")&&(lu_obj.value!="P")) websys_setfocus(lu_obj.id);		// cjb 20/09/2005 55579 - use the internal code, not what sites can translate
		if ((lu[2]!="A")&&(lu[2]!="C")&&(lu[2]!="P")) websys_setfocus(lu_obj.id);
	}
}

// md 53229
function MRDIAAccidentDate_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	var lu_obj=websys_getSrcElement(e);
	if (!IsValidCustomDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('MRDIAAccidentDate');
		return websys_cancel();
	} else {
		eSrc.className='';
	}
}

// rqg/SA,16.10.02 - Log 27883: This automatically moves the cursor to the next diagnosis field. If at the last diagnosis row in the table, move to "New Diagnosis" link.
function MRDIAICDCodeDRENTER(e) {
	var obj = websys_getSrcElement(e);
	var objrow=obj;

	while(objrow.tagName != "TR") {
		objrow=websys_getParentElement(objrow);
	}
	var row=objrow.sectionRowIndex+1;

	tbl=websys_getParentElement(objrow);
	for (var j=row;j<tbl.rows.length;j++) {
		var objnextrow=tbl.rows[j];
		if (objnextrow) {
			var arrfld=objnextrow.getElementsByTagName("INPUT");
			var nxtobj=arrfld[i];
			for (var i=0; i<arrfld.length; i++) {
				if (arrfld[i].id.indexOf("MRDIAPrefixz")!=-1) {
					nxtobj=arrfld[i];
				} else if (arrfld[i].id.indexOf("MRDIAICDCodeDRDescz")!=-1) {
					nxtobj=arrfld[i];
				}
				if (nxtobj) {
					if (nxtobj!=obj) {
						nxtobj.focus();
						nxtobj.select();
						return false;
					}
				}
			}
		}
	}

	var objNew=document.getElementById("MRDIAnew");
	if (objNew) websys_setfocus(objNew.name);
}


function MRDIAAdd() {
	var tbl=document.getElementById("tMRDiagnos_EditDRG");
	if (tbl) {
		AddRow(tbl);
		// rqg 05.11.02, Log 27883: Set focus to last row's diagnosis field when a new row is added
		// rqg 17.06.03 36440: Modified to set focus on prefix field on the last blank row
		for (var i=1; i<=tbl.rows.length; i++) {
			var diag=""; var prefix="";
			var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
			for (var j=0; j<arrfld.length; j++) {
				if (arrfld[j].id.indexOf("MRDIAPrefixz")==0) prefix=arrfld[j];
				if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) diag=arrfld[j];
			}
			// RQG 20.08.03 L 38406
			if (diag.value=="") {
				if (prefix) {
					prefix.focus();
				} else {
					diag.focus();
				}
				break;
			}
		}
		
		// cjb 07/02/2007 62540 - this was custom functionality added for QH and should not be in the standard script
		/*
		// cjb 07/07/2004 44289 - when adding a new row, disable the Contract Flag field
		var rowid=tbl.rows.length-1
		var objCF=document.getElementById("MRContractFlagz"+rowid);
		var objCFImage=document.getElementById("lt1240iMRContractFlagz"+rowid);
		if (objCF) {
			objCF.disabled=true;
			objCF.className = "disabledField";
			if (objCFImage) objCFImage.style.visibility="hidden";
		}
		*/
	}
	return false;
}

function MRDIAAddAbove() {
	var tbl=document.getElementById("tMRDiagnos_EditDRG");
	if (tbl) {
		AddRow(tbl);
	}
}

//KK log 24590 to count and set the entred diagnosis
//KK 25/Jun/2002 Log 24570 set sequence numbers
function SetDiagnosTotal() {
	var diagtotal=0;
	var objDT=document.getElementById('DiagnosTotal');
	var tbl=document.getElementById("tMRDiagnos_EditDRG");
	if ((tbl)&&(objDT)) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if ((arrId[0]=="MRDIAICDCodeDRDesc") || (arrId[0]=="MRDIAICDCodeDRExt1") || (arrId[0]=="MRDIAICDCodeDRExt2") || (arrId[0]=="MRDIAICDCodeDRExt3")) {
				if (arrInput[i].value!="") {
					diagtotal++;
				}
			}
		}
		objDT.innerText=diagtotal;
		EnableVerifiedFlag();
	}
	SetSeqNum(diagtotal);		// cjb 28/04/2005 50592 - moved this out of the for loop...
	return false;
}
//KK Log 35895
function SetSeqNum(seqnum){
	if (seqnum==0) return;
	var sno=0;	
	var quit=0;	
	var temp;
	var objSeqNo;
	var ttbl=document.getElementById("tMRDiagnos_EditDRG");
	if (ttbl) {
		// cjb 28/04/2005 50592 - changed the condition of the loop to check the value of quit.  quit is set when the LineNo column isn't on the form, or the last row is checked
		for (var i=1; quit==0; i++) {
			var fldSequ=0; var diag="";
			var arrfld=ttbl.rows[i].getElementsByTagName('INPUT');
			for (var j=0; j<arrfld.length; j++) {
				if (arrfld[j].id.indexOf("LineNoz")==0) fldSequ=arrfld[j];
				if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) diag=arrfld[j].value;
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

//SA 24.6.02 - log 24577: This function will clear all diagnoses codes from the screen.
function ClearDiagnoses() {
	var tbl=document.getElementById("tMRDiagnos_EditDRG");
	if (tbl) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if (arrId[0]!="SeqNo") {
				arrInput[i].value="";
			}
		}
	}
	DisableContractFlag();
	//md 53228/9
	DisableDiagFlds()
	
	SetDiagnosTotal();
	return false;
}

//rqg/SA,16.10.02 - Log 27883: This will set focus to first row on Procedure table after tabbing off from "New diagnosis" link
// RQG 21.08.03 38406 
function SetCursorToProc() {
	// keycode 9 is "TAB"
	if (window.event.keyCode==9) {
		// RQG 20.08.03 L38406
		var fra=top.frames["TRAK_main"].frames["MRProceduresEditDRG"];
		if (fra) {
			fra.focus();
			var tbl=fra.document.getElementById("tMRProcedures_EditDRG");
			if (tbl) {
				for (var i=1; i<=tbl.rows.length; i++) {
					var proc="";
					var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
					for (var j=0; j<arrfld.length; j++) {
						if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) proc=arrfld[j];
					}
					if (proc && proc.value=="") {
						Procsetfocus(proc.name);
						break;
					}
				}
			}
		}
	}
}
function Procsetfocus(objName) {
	setTimeout('Procsetfocus2(\''+objName+'\')',10);
}
function Procsetfocus2(objName) {
	var obj=top.frames["TRAK_main"].frames["MRProceduresEditDRG"].document.getElementById(objName);
	if (obj) {
		try {
			obj.focus();
			obj.select();
		} catch(e) {}
	}
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);
      
	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""					
      }
}

//rqg Log 27337
function DisplayMessage() {
	//dummy     	; This function is defined in ARMC custom script
}
function CheckLookUpDetails(str) {
	//dummy     	; This function is defined in ARMC custom script and QH custom script
}
function ChangePrefix(obj,checkonlyrow) {
	//dummy
}
// RQG 09.04.03 L32771
function DisableContractFlag() {
	//dummy     	; This function is defined in QH custom script
}
//md 29.06.2005 53228/9
function DisableDiagFlds() {
	//dummy     	; This function is defined in St George NZ custom script
}
function EnableVerifiedFlag() {
	//dummy     	; This function is defined in ARMC custom script
}
function IsValidCustomDate(fld) {
	return 1;
}









///// cjb 24/08/2006 59020 - commented out all these functions as the list now uses the generated script functions.  These can be deleted after a while

//////
//override the functions from scripts_gen folder
//////
/*
function MRDIAICDCodeDR_lookuphandler(evt) {
	if (evtName=='MRDIAICDCodeDR') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(evt);
	var key=websys_getKey(evt);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		// rqg,Log 27545: To display error message if discharge date is blank
		if ((objEpisodeID)&&(objEpisodeID.value=="INQUIRY")) {
			if (dischdate=="") {
			   	alert(t['DISCHDATE_REQD']);
				lu_obj=websys_getSrcElement(evt);
				lu_obj.focus();
				return websys_cancel();
			}
		}

		var url='websys.lookup.csp?ID=d1240iMRDIAICDCodeDR&CONTEXT=Kweb.MRCICDDx:LookUpWithEdition&TLUJSF=MRDIAICDCodeDRLookUpSelect';
		lu_obj=websys_getSrcElement(evt);
		if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
		if (lu_obj) url += "&P1=" + lu_obj.value;
		url += "&P2=" + locid;
		url += "&P3=" + dischdate;
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function MRDIAICDCodeDR_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
		}
	} catch(e) {};
}
function MRDIAICDCodeDR_changehandler(encmeth) {
	evtName='MRDIAICDCodeDR';
	if (doneInit) { evtTimer=window.setTimeout("MRDIAICDCodeDR_changehandlerX('"+encmeth+"');",200); }
	else { MRDIAICDCodeDR_changehandlerX(encmeth); evtTimer=""; }
}


function MRDIAICDCodeDR_changehandlerX(encmeth) {
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
	p2=locid;
	p3=dischdate;
	if (cspRunServerMethod(encmeth,'MRDIAICDCodeDR_lookupsel','MRDIAICDCodeDRLookUpSelect',p1,p2,p3)=='0') {
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		
	}
}

// rqg,log 24573
function MRDIAPrefix_changehandler(encmeth,e) {
	LookUpObject=websys_getSrcElement(e);
	evtName='MRDIAPrefix';
	if (doneInit) { evtTimer=window.setTimeout("MRDIAPrefix_changehandlerX('"+encmeth+"');",200); }
	else { MRDIAPrefix_changehandlerX(encmeth); evtTimer=""; }
}

function MRDIAPrefix_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=LookUpObject;
	var p1='DiagnosisPrefix';
	var p2='';
	if (obj) {
		lu_obj=obj;
		p2=obj.value;
	}
	if ((p2!='')&&(cspRunServerMethod(encmeth,'MRDIAPrefix_lookupsel','MRDIAPrefixLookUpSelect',p1,p2)=='0')) {
		if (obj) {
			obj.className='clsInvalid';
			obj.focus();
			return websys_cancel();
		}
	} else {
		if (obj) obj.className='';
	}
}


function MRDIAPrefix_lookuphandler(evt) {
	if (evtName=='MRDIAPrefix') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(evt);
	var key=websys_getKey(evt);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		
		// cjb 21/05/2004 43902 - MRDIAPrefixCode isn't on the screen, when selectig a code in the lookup, get an error cos it's trying to find par_win.MRDIAPrefixCode_lookupsel...  Changed to MRDIAPrefix
		//var url='websys.lookup.csp?ID=d1240iMRDIAPrefixCode&CONTEXT=Kwebsys.StandardTypeItem:LookUpByType';
		var url='websys.lookup.csp?ID=lt1240iMRDIAPrefix&CONTEXT=Kwebsys.StandardTypeItem:LookUpByType';

		lu_obj=websys_getSrcElement(evt);
		if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
		if (lu_obj) url += "&P2=" + lu_obj.value;

		url += "&P1=DiagnosisPrefix";
		// cjb 10/03/2004 42822 - added the lookup js function
		url += "&TLUJSF=MRDIAPrefixLookUpSelect";
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'');
		return; //websys_cancel();
	}
}


function MRDIAPrefix_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			//websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}


// RQG 04.04.03 32771
function MRContractFlag_changehandler(encmeth,e) {
	LookUpObject=websys_getSrcElement(e);
	evtName='MRContractFlag';
	if (doneInit) { evtTimer=window.setTimeout("MRContractFlag_changehandlerX('"+encmeth+"');",200); }
	else { MRContractFlag_changehandlerX(encmeth); evtTimer=""; }
}

function MRContractFlag_changehandlerX(encmeth) {
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
	if ((p1!='')&&(cspRunServerMethod(encmeth,'MRContractFlagCode_lookupsel','MRContractFlagCodeLookUpSelect',p1,p2)=='0')) {
		if (obj) {
			obj.className='clsInvalid';
			obj.focus();
			return websys_cancel();
		}
	} else {
		if (obj) obj.className='';
	}
}

function MRContractFlagCode_lookuphandler(evt) {
	if (evtName=='MRContractFlag') {
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
		// RQG 04.09.03 38837 New lookup syntax
		var url='websys.lookup.csp?ID=d1240iMRContractFlagCode&CONTEXT=Kweb.MRCContractFlag:LookUpCF';
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

function MRContractFlagCodeLookUpSelect(str) {
	var lu=str.split("^");
	if (lu_obj) {
		lu_obj.value=lu[1];
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
			} else if (arrfld[i].id.indexOf("MRContractFlagz")!=-1) {
				arrfld[i].value = lu[1];
			}
		}
	}
}

function MRContractFlagCode_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}


//md 53228
function MRDIAAliasDiagText_changehandler(encmeth,e) {
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
	if (arrfld[i].id.indexOf("MRDIAICDCodeDRCodez")!=-1) {
	p1=arrfld[i].value;
	}
	}
	
	if ((p1!='')&&(cspRunServerMethod(encmeth,'MRDIAAliasDiagText_lookupsel','MRDIAAliasDiagTextLookUpSelect',p1,p2)=='0')) {
		if (obj) {
			obj.className='clsInvalid';
			obj.focus();
			return websys_cancel();
		}
	} else {
		if (obj) obj.className='';
	}
}

function MRDIAAliasDiagText_lookuphandler(evt) {
	var type=websys_getType(evt);
	var key=websys_getKey(evt);
	var EsId="";
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp?ID=d1240iMRDIAAliasDiagText&CONTEXT=Kweb.MRCICDDx:LookUpFreeAlias';
		lu_obj=websys_getSrcElement(evt);
		if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i].id.indexOf("MRDIAICDCodeDRCodez")!=-1) {
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

function MRDIAAliasDiagTextLookUpSelect(str) {
	var lu=str.split("^");
	if (lu_obj) {
		lu_obj.value=lu[1];
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
			} else if (arrfld[i].id.indexOf("MRDIAAliasDiagTextz")!=-1) {
				arrfld[i].value = lu[0];
			}
		}
	}
}

function MRDIAAliasDiagText_lookupsel(value) {
	try {
		if (lu_obj) {
  			lu_obj.value=unescape(value);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}

//md


function MRDIAICDCodeDRDesc_changehandler(encmeth,e) {
	var eSrc=websys_getSrcElement(e);
	LookUpObject=eSrc
	MRDIAICDCodeDR_changehandler(encmeth);
	//rqg Log27337
	if (msgstr!="") DisplayMessage(eSrc,msgstr);
}
function MRDIAICDCodeDRExt1_changehandler(encmeth,e) {
	var eSrc=websys_getSrcElement(e);
	LookUpObject=eSrc
	MRDIAICDCodeDR_changehandler(encmeth);
	//rqg Log27337
	if (msgstr!="") DisplayMessage(eSrc,msgstr);
}
function MRDIAICDCodeDRExt2_changehandler(encmeth,e) {
	var eSrc=websys_getSrcElement(e);
	LookUpObject=eSrc
	MRDIAICDCodeDR_changehandler(encmeth);
	//rqg Log27337
	if (msgstr!="") DisplayMessage(eSrc,msgstr);
}
function MRDIAICDCodeDRExt3_changehandler(encmeth,e) {
	var eSrc=websys_getSrcElement(e);
	LookUpObject=eSrc
	MRDIAICDCodeDR_changehandler(encmeth);
	//rqg Log27337
	if (msgstr!="") DisplayMessage(eSrc,msgstr);
}
*/



var obj=document.getElementById("MRDIAnew");
if (obj) obj.onclick=MRDIAAdd;

//SA log 24114: Note the onclick event has been overwritten for ARMC via their custom javascript.
var objClearAll=document.getElementById("ClearAllDiag");
if (objClearAll) objClearAll.onclick=ClearDiagnoses;

var tblMRDIA=document.getElementById("tMRDiagnos_EditDRG")
if (tblMRDIA) {
	tblMRDIA.onkeydown=MRDIADocKeydownHandler;
	tblMRDIA.onclick=MRDIADocClickHandler;
}

document.body.onload=MRDiagnosEditDRGBodyOnLoadHandler;