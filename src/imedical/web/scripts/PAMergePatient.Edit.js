// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function DocumentLoadHandler() {
	
	
	var upd="",DoContinue=true;
	// function in pamergepatient.edit.csp
	DefaultingCheckboxes();
	var objUp=document.getElementById("updated");
	if (objUp) upd=objUp.value;
	disableAllFields()
	initialsetbold();
	//setbold(e);
	
	
	// CJB 06/06/2003 - 32273: Record Merging - changes required by QH
	// if each checkbox is ticked, bold the TO data, if not, bold the FROM data
	obj=document.getElementById('XDOBIRTH');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XSEX');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XNAME4');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XNAME3');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XNAME2');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XNAME');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMEDICARE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMEDICALRECORD');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XADDRESS');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XGPNAME');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XHOMEPHONE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMOBILEPHONE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERNokAddress1');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERNokAddress2');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERNokCityDR');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERNokCTRLTDR');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERNokName');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERNokPhone');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XRELIGION');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XSECONDPHONE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XTITLE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XWORKPHONE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XDENTIST');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XEMAIL');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XDVANUM');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XDVACARD');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMARITAL');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XBIRTH');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XOCC');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMEDSUF');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XINDIGE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMEDCODE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XISLAND');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XESTDOB');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XDOD');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XLANG');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XVIP');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPENNUM');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPENTYPE');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAYOR');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPLAN');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XFUND');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XMRN');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XSAFETY');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XINTERPRETER');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XCONCESSION');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XFEEDBACK');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XREMARK');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XFTOCC');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XPAPERID');
	if (obj) obj.onclick=setbold;
	obj=document.getElementById('XODONTOGRAM');
	if (obj) obj.onclick=setbold;
	
	
	obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	
	// LOG 26946 BC 25-7-2002 Indicate the same patient has been chosen as both the "TO" and "FROM" patient
	var objpat1 = document.getElementById("TOPatientID");
	var patid1=objpat1.value;
	var objpat2 = document.getElementById("FROMPatientID");
	var patid2=objpat2.value;
	if ((patid1!="")&&(patid2!="")&&(patid1==patid2)) { 
		alert(t['SamePatient']);
		return;
	} 

	// End LOG 26946

	// LOG 23871 BC 13-5-2002 Patient Merging alerts for overlapping address or GPs (and later Dentists)	
	obj1 = document.getElementById("AddrOverlap")
	obj2 = document.getElementById("GPOverlap")
	obj3 = document.getElementById("DentOverlap")
	obj4 = document.getElementById("IPAdmOverlap")
	obj5 = document.getElementById("NOKOverlap")
	if ((upd!=1)&&((obj3.value==1)||(obj1.value==1)||(obj2.value==1)||(obj4.value==1)||(obj5.value==1))) {
		var msg = t['OverlapWarning']+"\n\n";
		if (obj1.value==1) {msg=msg + t['TempAddrOverlap']+"\n"}
		if (obj2.value==1) {msg=msg + t['GPOverlap']+"\n"}
		if (obj3.value==1) {msg=msg + t['DentOverlap']+"\n"}
		if (obj4.value==1) {msg=msg + t['IPAdmOverlap']+"\n"}
		if (obj5.value==1) {msg=msg + t['NextOfKinOverlap']+"\n"}
		msg = msg + "\n" + t['PleaseCorrect'];
		// LOG 26038 BC 1-7-2002 Give the option to cancel the merge and hence clear the form
		DoContinue=confirm(msg);
	}
	// LOG 26038 BC 1-7-2002 Give the option to cancel the merge and hence clear the form
	if (DoContinue==false){
		var TWKFL=document.getElementById("TWKFL").value;
		var TWKFLI=document.getElementById("TWKFLI").value;
		var lnk = "pamergepatient.data.csp?FROMPatientID=&TOPatientID=&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI;
		top.frames["TRAK_hidden"].location=lnk;	
	}
	
	
	// End LOG 23871
	
	// SB 08/07/02 (26385): Only default checkboxes on the initial form load, once update has been clicked
	//			we want to restore the users selection using 'Run Class Method Only If Dirty' on Update.
	//if (document.getElementById("TDIRTY").value=="1") DefaultCheckboxs();
}
/*
function DefaultCheckboxs() {
	// SB 08/07/02 (26385): All checkboxes on form will be defaulted to checked.
	var f=document.getElementById("fPAMergePatient_Edit");
	for (var i=0;i<f.elements.length;i++) {
		if (f.elements[i].type=="checkbox") f.elements[i].checked=true
	}
}*/

// cjb 11/04/2006 58847
function CheckTOPatient(TOPatientID) {
	var FROMPatientID=document.getElementById("FROMPatientID").value;
	if ((FROMPatientID!="") && (FROMPatientID==TOPatientID)) {
		alert(t['SamePatient']);
		return false;
	}
	return true;
}
function CheckFROMPatient(FROMPatientID) {
	var TOPatientID=document.getElementById("TOPatientID").value;
	if ((TOPatientID!="") && (TOPatientID==FROMPatientID)) {
		alert(t['SamePatient']);
		return false;
	}
	return true;
}


function TOPAPMIRegNoLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var frommrn="",tomrn="";
	var frommrnobj=document.getElementById("FROMMRN");
	if (frommrnobj) frommrn=frommrnobj.value;
	var tomrnobj=document.getElementById("TOMRN")
	if (tomrnobj) tomrn=tomrnobj.value;
	var lu = str.split("^");
	if (CheckTOPatient(lu[1])) {
		var lnk = "pamergepatient.data.csp?TOPatientID="+ lu[1] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&TOMRN="+ tomrn+"&FROMMRN="+frommrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}

function FROMPAPMIRegNoLookUp(str) {
	var lu = str.split("^");
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var frommrn="",tomrn="";
	var frommrnobj=document.getElementById("FROMMRN");
	if (frommrnobj) frommrn=frommrnobj.value;
	var tomrnobj=document.getElementById("TOMRN")
	if (tomrnobj) tomrn=tomrnobj.value;
	if (CheckFROMPatient(lu[1])) {
		var lnk = "pamergepatient.data.csp?FROMPatientID="+ lu[1] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&TOMRN="+ tomrn+"&FROMMRN="+frommrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}


function TOMRNLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var frompat=document.getElementById("FROMPatientID").value;
	var frommrn="";
	var frommrnobj=document.getElementById("FROMMRN");
	if (frommrnobj) frommrn=frommrnobj.value;
	var lu = str.split("^");
	if (CheckTOPatient(lu[2])) {
		var lnk = "pamergepatient.data.csp?TOPatientID="+ lu[2] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&FROMPatientID="+frompat+"&TOMRN="+ lu[0]+"&FROMMRN="+frommrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}


function FROMMRNLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var topat=document.getElementById("TOPatientID").value;
	var tomrn="";
	var tomrnobj=document.getElementById("TOMRN")
	if (tomrnobj) tomrn=tomrnobj.value;
	var lu = str.split("^");
	if (CheckFROMPatient(lu[2])) {
		var lnk = "pamergepatient.data.csp?FROMPatientID="+ lu[2] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&TOPatientID="+topat+"&FROMMRN="+ lu[0]+"&TOMRN="+tomrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}



function UpdateClickHandler(e) {
	enableAllFields();
	var fromID=document.getElementById("FROMPatientID")
	var toID=document.getElementById("TOPatientID")
	var xsex = document.getElementById("XSEX");
	var xname4 = document.getElementById("XNAME4");
	var xname3 = document.getElementById("XNAME3");
	var xname2 = document.getElementById("XNAME2");
	var xname = document.getElementById("XNAME");
	var xmedicare = document.getElementById("XMEDICARE");
	var xdob = document.getElementById("XDOBIRTH");
	var xmrn = document.getElementById("XMEDICALRECORD");
	var xaddress = document.getElementById("XADDRESS");
	//var xaddress2 = document.getElementById("XADDRESS2");
	//var xgpcity = document.getElementById("XGPCITY");
	var xgpname = document.getElementById("XGPNAME");
	var xhomephone = document.getElementById("XHOMEPHONE");
	var xmobilephone = document.getElementById("XMOBILEPHONE");
	var xpapernokaddress1 = document.getElementById("XPAPERNokAddress1");
	var xpapernokaddress2 = document.getElementById("XPAPERNokAddress2");
	var xpapernokcitydr = document.getElementById("XPAPERNokCityDR");
	var xpapernokctrltdr = document.getElementById("XPAPERNokCTRLTDR");
	var xpapernokname = document.getElementById("XPAPERNokName");
	var xpapernokphone = document.getElementById("XPAPERNokPhone");
	//var xpapernokzipdr = document.getElementById("XPAPERNokZipDR");
	//var xpostcode = document.getElementById("XPOSTCODE");
	var xreligion = document.getElementById("XRELIGION");
	var xsecondphone = document.getElementById("XSECONDPHONE");
	//var xstate = document.getElementById("XSTATE");
	//var xsuburb = document.getElementById("XSUBURB");
	var xtitle = document.getElementById("XTITLE");
	var xworkphone = document.getElementById("XWORKPHONE");
	var xdentist = document.getElementById("XDENTIST");
	
	var xemail = document.getElementById("XEMAIL");
	var xdvanum = document.getElementById("XDVANUM");
	var xdvacard = document.getElementById("XDVACARD");
	var xmarital = document.getElementById("XMARITAL");
	var xbirth = document.getElementById("XBIRTH");
	var xocc = document.getElementById("XOCC");
	var xmedsuf = document.getElementById("XMEDSUF");
	var xindige = document.getElementById("XINDIGE");
	var xmedcode = document.getElementById("XMEDCODE");
	var xisland = document.getElementById("XISLAND");
	var xestdob = document.getElementById("XESTDOB");
	var xdod = document.getElementById("XDOD");
	var xlang = document.getElementById("XLANG");
	var xvip = document.getElementById("XVIP");
	var xpennum = document.getElementById("XPENNUM");
	var xpentype = document.getElementById("XPENTYPE");
	var xpayor = document.getElementById("XPAYOR");
	var xplan = document.getElementById("XPLAN");
	var xfund = document.getElementById("XFUND");
	var xmrn = document.getElementById("XMRN");
	var xsafety = document.getElementById("XSAFETY");
	var xinterpreter = document.getElementById("XINTERPRETER");
	var xconcession = document.getElementById("XCONCESSION");
	var xfeedback = document.getElementById("XFEEDBACK");
	var xremark = document.getElementById("XREMARK");
	var xftocc = document.getElementById("XFTOCC");		// cjb 27/01/2005 49285
	var xpaperid = document.getElementById("XPAPERID");		// cjb 28/10/2005 54220
	var xodontogram = document.getElementById("XODONTOGRAM");		// cjb 30/03/2006 58189
	
	
	
	/*
	var fsex = document.getElementById("FROMCTSEXDesc");
	var fname3 = document.getElementById("FROMPAPMIName3");
	var fname2 = document.getElementById("FROMPAPMIName2");
	var fname = document.getElementById("FROMPAPMIName");
	var fmedicare = document.getElementById("FROMPAPMIMedicare");
	var fdob = document.getElementById("FROMPAPMIDOB");
	var fmrn = document.getElementById("FROMMRNNo");
	var fsuburb = document.getElementById("FROMCTCITDesc");
	var freligion = document.getElementById("FROMCTRLGDesc");
	var fpostcode = document.getElementById("FROMCTZIPCode");
	var fchino = document.getElementById("FROMPAPERID");
	var fmobilephone = document.getElementById("FROMPAPERMobPhone");
	var fpapernokaddress1 = document.getElementById("FROMPAPERNokAddress1");
	var fpapernokaddress2 = document.getElementById("FROMPAPERNokAddress2");
	var fpapernokcitydr = document.getElementById("FROMPAPERNokCityDR");
	var fpapernokctrltdr = document.getElementById("FROMPAPERNokCTRLTDR");
	var fpapernokname = document.getElementById("FROMPAPERNokName");
	var fpapernokphone = document.getElementById("FROMPAPERNokPhone");
	var fpapernokzipdr = document.getElementById("FROMPAPERNokZipDR");
	var fsecondphone = document.getElementById("FROMPAPERSecondPhone");
	var faddress = document.getElementById("FROMPAPERStNameLine1");
	var faddress2 = document.getElementById("FROMPAPERForeignAddress");
	var fhomephone = document.getElementById("FROMPAPERTelH");
	var fworkphone = document.getElementById("FROMPAPERTelO");
	var fstate = document.getElementById("FROMPROVDesc");
	var fgpclinic = document.getElementById("FROMCLNAddress1");
	var fgpcity = document.getElementById("FROMREFDCITYDR");
	var fgpname = document.getElementById("FROMREFDDesc");
	var ftitle = document.getElementById("FROMTTLDesc");
	var fmedicarecode = document.getElementById("FROMPAPMIMedicareCode");
	var fmedicaresuffix = document.getElementById("FROMPAPMIMedicareSuffixDR");
	//LOG 25133 Dentist
	var fdentclinic = document.getElementById("FROMDentCLNAddress1");
	var fdentcity = document.getElementById("FROMDentREFDCITYDR");
	var fdentname = document.getElementById("FROMDentREFDDesc");
	
	var femail = document.getElementById("FROMPAPEREmail");
	var fdvanum = document.getElementById("FROMDVANum");
	var fdvacard = document.getElementById("FROMDVACard");
	
	
	var tsex = document.getElementById("TOCTSEXDesc");
	var tname3 = document.getElementById("TOPAPMIName3");
	var tname2 = document.getElementById("TOPAPMIName2");
	var tname = document.getElementById("TOPAPMIName");
	var tmedicare = document.getElementById("TOPAPMIMedicare");
	var tdob = document.getElementById("TOPAPMIDOB");
	var tmrn = document.getElementById("TOMRNNo");
	var treg = document.getElementById("TOPAPMIRegNo");
	var tsuburb = document.getElementById("TOCTCITDesc");
	var treligion = document.getElementById("TOCTRLGDesc");
	var tpostcode = document.getElementById("TOCTZIPCode");
	var tchino = document.getElementById("TOPAPERID");
	var tmobilephone = document.getElementById("TOPAPERMobPhone");
	var tpapernokaddress1 = document.getElementById("TOPAPERNokAddress1");
	var tpapernokaddress2 = document.getElementById("TOPAPERNokAddress2");
	var tpapernokcitydr = document.getElementById("TOPAPERNokCityDR");
	var tpapernokctrltdr = document.getElementById("TOPAPERNokCTRLTDR");
	var tpapernokname = document.getElementById("TOPAPERNokName");
	var tpapernokphone = document.getElementById("TOPAPERNokPhone");
	var tpapernokzipdr = document.getElementById("TOPAPERNokZipDR");
	var tsecondphone = document.getElementById("TOPAPERSecondPhone");
	var taddress = document.getElementById("TOPAPERStNameLine1");
	var taddress2 = document.getElementById("TOPAPERForeignAddress");
	var thomephone = document.getElementById("TOPAPERTelH");
	var tworkphone = document.getElementById("TOPAPERTelO");
	var tstate = document.getElementById("TOPROVDesc");
	var tgpcity = document.getElementById("TOREFDCITYDR");
	var tgpclinic = document.getElementById("TOCLNAddress1");
	var tgpname = document.getElementById("TOREFDDesc");
	var ttitle = document.getElementById("TOTTLDesc");
	var tmedicarecode = document.getElementById("TOPAPMIMedicareCode");
	var tmedicaresuffix = document.getElementById("TOPAPMIMedicareSuffixDR");
	//LOG 25133 Dentist
	var tdentcity = document.getElementById("TODentREFDCITYDR");
	var tdentclinic = document.getElementById("TODentCLNAddress1");
	var tdentname = document.getElementById("TODentREFDDesc");
	
	var temail = document.getElementById("TOPAPEREmail");
	var tdvanum = document.getElementById("TODVANum");
	var tdvacard = document.getElementById("TODVACard");
	*/

	var mergeStr = document.getElementById("mergedStr");
	var aliasStr = document.getElementById("aliasStr");
	
	var str=""
	var strAlias=""
	// Name
	if (xname) {
		if (xname.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {	
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
		str=str+"T^"
		strAlias=strAlias+"F^"
	}

	// Name 2
	if (xname2) {
		if (xname2.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
		if (xname) {
			if (xname.checked) {
				str=str+"T^"
				strAlias=strAlias+"F^"
			} else {	
				str=str+"F^"
				strAlias=strAlias+"T^"
			}
		} else {
			str=str+"T^"
			strAlias=strAlias+"F^"
		}
	}

	// Name 3
	if (xname3) {
		if (xname3.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
		if (xname) {
			if (xname.checked) {
				str=str+"T^"
				strAlias=strAlias+"F^"
			} else {	
				str=str+"F^"
				strAlias=strAlias+"T^"
			}
		} else {
			str=str+"T^"
			strAlias=strAlias+"F^"
		}
	}

	// Patient Medicare No
	str=checkboxToString(xmedicare,str);
	// Patient DOB
	str=checkboxToString(xdob,str);
	// Patient Sex	
	str=checkboxToString(xsex,str);
	// Title
	str=checkboxToString(xtitle,str);
	// Patient Religion
	str=checkboxToString(xreligion,str);
	// Patient Address
	if (xaddress) {
		if (xaddress.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
			str=str+"T^"
			strAlias=strAlias+"F^"
	}

	// Patient Address2
	if (xaddress) {
		if (xaddress.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
			str=str+"T^"
			strAlias=strAlias+"F^"
	}

	// Patient Suburb
	if (xaddress) {
		if (xaddress.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
			str=str+"T^"
			strAlias=strAlias+"F^"
	}
	// Patient State
	str=checkboxToString(xaddress,str);
	// Patient Post Code
	str=checkboxToString(xaddress,str);
	// Patient Home Phone
	str=checkboxToString(xhomephone,str);
	// Second Phone Number
	str=checkboxToString(xsecondphone,str);
	// Work Phone Number
	str=checkboxToString(xworkphone,str);
	// Patient Mobile Phone
	str=checkboxToString(xmobilephone,str);
	// NOK Name
	str=checkboxToString(xpapernokname,str);
	// NOK Relationship to Patient
	str=checkboxToString(xpapernokctrltdr,str);
	// NOK Address line 1
	str=checkboxToString(xpapernokaddress1,str);
	// NOK Address line 2
	str=checkboxToString(xpapernokaddress2,str);
	// NOK City
	str=checkboxToString(xpapernokcitydr,str);
	// NOK Post Code
	str=checkboxToString(xpapernokcitydr,str);
	// NOK Phone Number
	str=checkboxToString(xpapernokphone,str);
	// Patient GP Name
	str=checkboxToString(xgpname,str);
	// Patient GP CLinic
	//SB 23/03/02: Should GP Clinic be passed??? SQL query used in WebsysSave to grab clinic code.
	str=checkboxToString(xgpname,str);
	// Patient GP City
	str=checkboxToString(xgpname,str);
	
	// cjb 28/10/200554220 - added xpaperid checkbox
	// Patient CHINo
	//if (tchino) {str = str+"T^"} else {str=str+"T^"}
	str=checkboxToString(xpaperid,str);		// National ID
	
	
	// Patient Medicare Code
	str=checkboxToString(xmedicare,str);
	// Patient Medicare Suffix
	str=checkboxToString(xmedicare,str);
	// Patient Dentist LOG 25133
	str=checkboxToString(xdentist,str);
	
	// CJB 06/06/2003 - 32273: Record Merging - changes required by QH
	// email
	str=checkboxToString(xemail,str);
	// DVA Number
	str=checkboxToString(xdvanum,str);
	// DVA Card Type
	str=checkboxToString(xdvacard,str);
	// Marital status 
	str=checkboxToString(xmarital,str);
	// Country of birth 
	str=checkboxToString(xbirth,str);
	// Occupation 
	str=checkboxToString(xocc,str);
	// Medicare suffix 
	str=checkboxToString(xmedsuf,str);
	// Indigenous status 
	str=checkboxToString(xindige,str);
	// Medicare code  
	str=checkboxToString(xmedcode,str);
	// Australian South Sea Islander
	str=checkboxToString(xisland,str);
	// Estimated date of birth
	str=checkboxToString(xestdob,str);
	// Deceased date 
	str=checkboxToString(xdod,str);
	// Preferred Language
	str=checkboxToString(xlang,str);
	// VIP 
	str=checkboxToString(xvip,str);
	// Pension number  
	str=checkboxToString(xpennum,str);
	// Pension type 
	str=checkboxToString(xpentype,str);
	// Payor
	str=checkboxToString(xpayor,str);
	// Plan
	str=checkboxToString(xplan,str);
	// Health Fund Number
	str=checkboxToString(xfund,str);
	// MRN
	str=checkboxToString(xmrn,str);
	// CJB end 32273
	
	// Safety Card Number
	str=checkboxToString(xsafety,str);
	// Interpreter Required
	str=checkboxToString(xinterpreter,str);
	// Concession card
	str=checkboxToString(xconcession,str);
	
	// cjb 14/08/2004 44284
	// Concession card
	str=checkboxToString(xfeedback,str);
	// Concession card
	str=checkboxToString(xremark,str);
	// FreeText Occupation
	str=checkboxToString(xftocc,str);
	// Odontogram
	str=checkboxToString(xodontogram,str);
	//name4
	
	if (xname4) {
		if (xname4.checked) {
			str=str+"T^"
			strAlias=strAlias+"F^"
		} else {
			str=str+"F^"
			strAlias=strAlias+"T^"
		}
	} else {
		if (xname) {
			if (xname.checked) {
				str=str+"T^"
				strAlias=strAlias+"F^"
			} else {	
				str=str+"F^"
				strAlias=strAlias+"T^"
			}
		} else {
			str=str+"T^"
			strAlias=strAlias+"F^"
		}
	}
	
	mergeStr.value=str
	//alert(mergeStr.value);
	aliasStr.value=strAlias
	//alert(str);
	//alert(strAlias);
	//return false;
	return update1_click()
}

function checkboxToString(obj,str) {
	if (obj) {
		if (obj.checked) {
			str=str+"T^"
		} else {
			str=str+"F^"
		}
	} else {
		str=str+"T^"
	}
	return str;
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	//if ((fld)&&(fld.tagName=="INPUT")) {
	if (fld) {
		fld.disabled = true;
		fld.className = "";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.enabled = true;
		fld.className = "";
	}
}

function enableAllFields() {

	var fields= new Array("FROMCLNAddress1","FROMPAPMIName","FROMPAPMIName2","FROMPAPMIName3",
	"FROMPAPMIDOB","FROMCTSEXDesc","FROMMRNNo","FROMPAPMIMedicare","TOCLNAddress1","TOPAPMIName","TOPAPMIName2","TOPAPMIName3",
	"TOPAPMIMedicare","TOMRNNo","TOCTSEXDesc","TOPAPMIDOB","TOPAPMIRegNo","TOCTCITDesc","TOCTRLGDesc","FROMCTRLGDesc","FROMCTZIPCode",
	"FROMPAPERID","FROMPAPERMobPhone","FROMPAPERNokAddress1","FROMPAPERNokAddress2","FROMPAPERNokCityDR","FROMPAPERNokCTRLTDR",
	"FROMPAPERNokName","FROMPAPERNokPhone","FROMPAPERNokZipDR","FROMPAPERSecondPhone","FROMPAPERStNameLine1",
	"FROMPAPERForeignAddress","TOPAPERForeignAddress","FROMPAPERTelH","FROMPAPERTelO","FROMPROVDesc","FROMREFDCITYDR","FROMREFDDesc",
	"FROMTTLDesc","TOCTCITDesc","TOCTRLGDesc","TOCTZIPCode","TOPAPERID","TOPAPERMobPhone","TOPAPERNokAddress1",
	"TOPAPERNokAddress2","TOPAPERNokCityDR","TOPAPERNokCTRLTDR","TOPAPERNokName","TOPAPERNokPhone","TOPAPERNokZipDR","TOPAPERSecondPhone",
	"TOPAPERStNameLine1","TOPAPERTelH","TOPAPERTelO","TOPROVDesc","TOREFDCITYDR","TOREFDDesc","TOTTLDesc",
	"FROMDentCLNAddress1","TODentCLNAddress1","TODentREFDDesc","FROMDentREFDDesc","FROMDentREFDCITYDR","TODentREFDCITYDR","FROMCTCITDesc",
	"TOPAPEREmail","FROMPAPEREmail","TODVANum","FROMDVANum","TODVACard","FROMDVACard",
	"TOCTMARDesc","FROMCTMARDesc","TOBirth","FROMBirth","TOCTOCCDesc","FROMCTOCCDesc",
	"TOMEDSUFDesc","FROMMEDSUFDesc","TOINDSTDesc","FROMINDSTDesc",
	"TOMedicareCode","FROMMedicareCode","TOASSISDesc","FROMASSISDesc",
	"TOEstDOB","FROMEstDOB","TODOD","FROMDOD","TOTOD","FROMTOD","TOEstDOD","FROMEstDOD",
	"TOLocationOfDeath","FROMLocationOfDeath","TOWhoNotified","FROMWhoNotified",
	"TOUpdateDate","FROMUpdateDate","TOUpdateTime","FROMUpdateTime","TOUserUpdate","FROMUserUpdate","TOUpdateHosp","FROMUpdateHosp",
	"TOPrefLang","FROMPrefLang","TOVIP","FROMVIP","TOPensionNumber","FROMPensionNumber","TOPensionType","FROMPensionType",
	"TOPayor","FROMPayor","TOPlan","FROMPlan","TOHealthCardNo","FROMHealthCardNo",
	"TOMedicareExpDate","FROMMedicareExpDate","TOPensionCardExpiryDate","FROMPensionCardExpiryDate","TOHealthCardExpiryDate","FROMHealthCardExpiryDate",
	"TOSafetyCardNo","FROMSafetyCardNo","TOSafetyCardExpDate","FROMSafetyCardExpDate","TOREFDForename","FROMREFDForename",
	"TOInterpreterRequired","FROMInterpreterRequired","TODVAExpDate","FROMDVAExpDate",
	"TOConcessionCardNo","FROMConcessionCardNo","TOConcessionExpDate","FROMConcessionExpDate",
	"TOFeedBackConsent","FROMFeedBackConsent","TORemark","FROMRemark","TOPAPEROccupation","FROMPAPEROccupation",
	"TOOdontogram","FROMOdontogram","TOPAPMIName4","FROMPAPMIName4");
	
	for (var i=0;i<fields.length;i++) {
		obj=document.getElementById(fields[i]);
		if (obj) EnableField(fields[i]);
	}
}

function disableAllFields() {

	var fields= new Array("FROMCLNAddress1","FROMPAPMIName","FROMPAPMIName2","FROMPAPMIName3",
	"FROMPAPMIDOB","FROMCTSEXDesc","FROMMRNNo","FROMPAPMIMedicare","TOCLNAddress1","TOPAPMIName","TOPAPMIName2","TOPAPMIName3",
	"TOPAPMIMedicare","TOMRNNo","TOCTSEXDesc","TOPAPMIDOB","TOCTCITDesc","TOCTRLGDesc","FROMCTRLGDesc","FROMCTZIPCode",
	"FROMPAPERID","FROMPAPERMobPhone","FROMPAPERNokAddress1","FROMPAPERNokAddress2","FROMPAPERNokCityDR","FROMPAPERNokCTRLTDR",
	"FROMPAPERNokName","FROMPAPERNokPhone","FROMPAPERNokZipDR","FROMPAPERSecondPhone","FROMPAPERStNameLine1",
	"FROMPAPERForeignAddress","TOPAPERForeignAddress","FROMPAPERTelH","FROMPAPERTelO","FROMPROVDesc","FROMREFDCITYDR","FROMREFDDesc",
	"FROMTTLDesc","TOCTCITDesc","TOCTRLGDesc","TOCTZIPCode","TOPAPERID","TOPAPERMobPhone","TOPAPERNokAddress1",
	"TOPAPERNokAddress2","TOPAPERNokCityDR","TOPAPERNokCTRLTDR","TOPAPERNokName","TOPAPERNokPhone","TOPAPERNokZipDR","TOPAPERSecondPhone",
	"TOPAPERStNameLine1","TOPAPERTelH","TOPAPERTelO","TOPROVDesc","TOREFDCITYDR","TOREFDDesc","TOTTLDesc",
	"FROMDentCLNAddress1","TODentCLNAddress1","TODentREFDDesc","FROMDentREFDDesc","FROMDentREFDCITYDR","TODentREFDCITYDR","FROMCTCITDesc",
	"TOPAPEREmail","FROMPAPEREmail","TODVANum","FROMDVANum","TODVACard","FROMDVACard",
	"TOCTMARDesc","FROMCTMARDesc","TOBirth","FROMBirth","TOCTOCCDesc","FROMCTOCCDesc",
	"TOMEDSUFDesc","FROMMEDSUFDesc","TOINDSTDesc","FROMINDSTDesc",
	"TOMedicareCode","FROMMedicareCode","TOASSISDesc","FROMASSISDesc",
	"TOEstDOB","FROMEstDOB","TODOD","FROMDOD","TOTOD","FROMTOD","TOEstDOD","FROMEstDOD",
	"TOLocationOfDeath","FROMLocationOfDeath","TOWhoNotified","FROMWhoNotified",
	"TOUpdateDate","FROMUpdateDate","TOUpdateTime","FROMUpdateTime","TOUserUpdate","FROMUserUpdate","TOUpdateHosp","FROMUpdateHosp",
	"TOPrefLang","FROMPrefLang","TOVIP","FROMVIP","TOPensionNumber","FROMPensionNumber","TOPensionType","FROMPensionType",
	"TOPayor","FROMPayor","TOPlan","FROMPlan","TOHealthCardNo","FROMHealthCardNo",
	"TOMedicareExpDate","FROMMedicareExpDate","TOPensionCardExpiryDate","FROMPensionCardExpiryDate","TOHealthCardExpiryDate","FROMHealthCardExpiryDate",
	"TOSafetyCardNo","FROMSafetyCardNo","TOSafetyCardExpDate","FROMSafetyCardExpDate","TOREFDForename","FROMREFDForename",
	"TOInterpreterRequired","FROMInterpreterRequired","TODVAExpDate","FROMDVAExpDate",
	"TOConcessionCardNo","FROMConcessionCardNo","TOConcessionExpDate","FROMConcessionExpDate",
	"TOFeedBackConsent","FROMFeedBackConsent","TORemark","FROMRemark","TOPAPEROccupation","FROMPAPEROccupation",
	"TOOdontogram","FROMOdontogram","TOPAPMIName4","FROMPAPMIName4");
	
	for (var i=0;i<fields.length;i++) {
		obj=document.getElementById(fields[i]);
		
		if ((obj)&&(((obj.tagName=="INPUT")||(obj.tagName=="TEXTAREA")))) DisableField(fields[i]);
	}
	
}

// CJB 06/06/2003 - 32273: Record Merging - changes required by QH
// called from the onclicks of the checkboxes.  if it is ticked, bold the TO data, if not, bold the FROM data
function setbold(e) {
	var obj=""
	var eSrc=websys_getSrcElement(e);
	
	var check= new Array("XSEX","XNAME4","XNAME3","XNAME2","XNAME",													"XDOBIRTH",		"XMEDICALRECORD",	"XMOBILEPHONE",			"XPAPERNokAddress1","XPAPERNokAddress2","XPAPERNokCityDR",				"XPAPERNokCTRLTDR","XPAPERNokName","XPAPERNokPhone",				"XSECONDPHONE",			"XRELIGION","XTITLE",				"XHOMEPHONE","XWORKPHONE","XEMAIL",					"XMARITAL","XBIRTH","XOCC",						"XINDIGE","XISLAND",					"XESTDOB","XLANG","XVIP",					"XPAYOR","XPLAN",			"XMRN","XINTERPRETER",					"XFEEDBACK","XREMARK",				"XFTOCC","XPAPERID",						"XODONTOGRAM");
	var fromfield= new Array("FROMCTSEXDesc","FROMPAPMIName4","FROMPAPMIName3","FROMPAPMIName2","FROMPAPMIName",		"FROMPAPMIDOB",	"FROMMRNNo",			"FROMPAPERMobPhone",		"FROMPAPERNokAddress1","FROMPAPERNokAddress2","FROMPAPERNokCityDR",	"FROMPAPERNokCTRLTDR","FROMPAPERNokName","FROMPAPERNokPhone",	"FROMPAPERSecondPhone",	"FROMCTRLGDesc","FROMTTLDesc",	"FROMPAPERTelH","FROMPAPERTelO","FROMPAPEREmail",		"FROMCTMARDesc","FROMBirth","FROMCTOCCDesc",	"FROMINDSTDesc","FROMASSISDesc",	"FROMEstDOB","FROMPrefLang","FROMVIP",	"FROMPayor","FROMPlan",	"FROMMRNNo","FROMInterpreterRequired",	"FROMFeedBackConsent","FROMRemark",	"FROMPAPEROccupation","FROMPAPERID",	"FROMOdontogram");
	var tofield= new Array("TOCTSEXDesc","TOPAPMIName4","TOPAPMIName3","TOPAPMIName2","TOPAPMIName",					"TOPAPMIDOB",		"TOMRNNo",				"TOPAPERMobPhone",		"TOPAPERNokAddress1","TOPAPERNokAddress2","TOPAPERNokCityDR",			"TOPAPERNokCTRLTDR","TOPAPERNokName","TOPAPERNokPhone",			"TOPAPERSecondPhone",	"TOCTRLGDesc","TOTTLDesc",		"TOPAPERTelH","TOPAPERTelO","TOPAPEREmail",				"TOCTMARDesc","TOBirth","TOCTOCCDesc",			"TOINDSTDesc","TOASSISDesc",			"TOEstDOB","TOPrefLang","TOVIP",			"TOPayor","TOPlan",			"TOMRNNo","TOInterpreterRequired",			"TOFeedBackConsent","TORemark",		"TOPAPEROccupation","TOPAPERID",			"TOOdontogram");
	
	for (var i=0;i<check.length;i++) {
		obj=document.getElementById(check[i]);
		if ((obj) && (check[i]==eSrc.id)) {
			if (obj.checked) {
				obj=document.getElementById(tofield[i]);
				if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
				obj=document.getElementById(fromfield[i]);
				if (obj) obj.style.fontWeight="normal";
			} else {	
				obj=document.getElementById(fromfield[i]);
				if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
				obj=document.getElementById(tofield[i]);
				if (obj) obj.style.fontWeight="normal";
			}
		}
	}
	otherfields()
}

// CJB 06/06/2003 - 32273: Record Merging - changes required by QH
// called from the onload.  if each checkbox is ticked, bold the TO data, if not, bold the FROM data
function initialsetbold() {
	var obj=""
	
	var check= new Array("XSEX","XNAME4","XNAME3","XNAME2","XNAME",													"XDOBIRTH",		"XMEDICALRECORD",	"XMOBILEPHONE",			"XPAPERNokAddress1","XPAPERNokAddress2","XPAPERNokCityDR",				"XPAPERNokCTRLTDR","XPAPERNokName","XPAPERNokPhone",				"XSECONDPHONE",			"XRELIGION","XTITLE",				"XHOMEPHONE","XWORKPHONE","XEMAIL",					"XMARITAL","XBIRTH","XOCC",						"XINDIGE","XISLAND",					"XESTDOB","XLANG","XVIP",					"XPAYOR","XPLAN",			"XMRN","XINTERPRETER",					"XFEEDBACK","XREMARK",				"XFTOCC","XPAPERID",						"XODONTOGRAM");
	var fromfield= new Array("FROMCTSEXDesc","FROMPAPMIName4","FROMPAPMIName3","FROMPAPMIName2","FROMPAPMIName",		"FROMPAPMIDOB",	"FROMMRNNo",			"FROMPAPERMobPhone",		"FROMPAPERNokAddress1","FROMPAPERNokAddress2","FROMPAPERNokCityDR",	"FROMPAPERNokCTRLTDR","FROMPAPERNokName","FROMPAPERNokPhone",	"FROMPAPERSecondPhone",	"FROMCTRLGDesc","FROMTTLDesc",	"FROMPAPERTelH","FROMPAPERTelO","FROMPAPEREmail",		"FROMCTMARDesc","FROMBirth","FROMCTOCCDesc",	"FROMINDSTDesc","FROMASSISDesc",	"FROMEstDOB","FROMPrefLang","FROMVIP",	"FROMPayor","FROMPlan",	"FROMMRNNo","FROMInterpreterRequired",	"FROMFeedBackConsent","FROMRemark",	"FROMPAPEROccupation","FROMPAPERID",	"FROMOdontogram");
	var tofield= new Array("TOCTSEXDesc","TOPAPMIName4","TOPAPMIName3","TOPAPMIName2","TOPAPMIName",					"TOPAPMIDOB",		"TOMRNNo",				"TOPAPERMobPhone",		"TOPAPERNokAddress1","TOPAPERNokAddress2","TOPAPERNokCityDR",			"TOPAPERNokCTRLTDR","TOPAPERNokName","TOPAPERNokPhone",			"TOPAPERSecondPhone",	"TOCTRLGDesc","TOTTLDesc",		"TOPAPERTelH","TOPAPERTelO","TOPAPEREmail",				"TOCTMARDesc","TOBirth","TOCTOCCDesc",			"TOINDSTDesc","TOASSISDesc",			"TOEstDOB","TOPrefLang","TOVIP",			"TOPayor","TOPlan",			"TOMRNNo","TOInterpreterRequired",			"TOFeedBackConsent","TORemark",		"TOPAPEROccupation","TOPAPERID",			"TOOdontogram");
	
	for (var i=0;i<check.length;i++) {
		obj=document.getElementById(check[i]);
		if (obj) {
			if (obj.checked) {
				obj=document.getElementById(tofield[i]);
				
				if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
				obj=document.getElementById(fromfield[i]);
				if (obj) obj.style.fontWeight="normal";
			} else {	
				obj=document.getElementById(fromfield[i]);
				if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
				obj=document.getElementById(tofield[i]);
				if (obj) obj.style.fontWeight="normal";
			}
		}
	}
	otherfields()
}

// checkboxes that include more than one field...
function otherfields() {
	
	// address fields
	var addobj=document.getElementById('XADDRESS');
	if (addobj) {
		if (addobj.checked) {
			obj=document.getElementById('TOPAPERStNameLine1');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOPAPERForeignAddress');
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			obj=document.getElementById('TOPROVDesc');
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			obj=document.getElementById('TOCTCITDesc');
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			obj=document.getElementById('TOCTZIPCode');
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMPAPERStNameLine1');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMPAPERForeignAddress');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMPROVDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMCTCITDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMCTZIPCode');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMPAPERStNameLine1');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMPAPERForeignAddress');
			if  ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMPROVDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMCTCITDesc');
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			obj=document.getElementById('FROMCTZIPCode');
			if ((obj)&&(obj.value!=""))  obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOPAPERStNameLine1');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOPAPERForeignAddress');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOPROVDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOCTCITDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOCTZIPCode');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	

	// GP fields
	var gpobj=document.getElementById('XGPNAME');
	if (gpobj) {
		if (gpobj.checked) {
			obj=document.getElementById('TOREFDDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOCLNAddress1');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOREFDCITYDR');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOREFDForename');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMREFDDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMCLNAddress1');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMREFDCITYDR');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMREFDForename');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMREFDDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMCLNAddress1');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMREFDCITYDR');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMREFDForename');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOREFDDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOCLNAddress1');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOREFDCITYDR');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOREFDForename');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// Dentist fields
	var dentobj=document.getElementById('XDENTIST');
	if (dentobj) {
		if (dentobj.checked) {
			obj=document.getElementById('TODentREFDDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TODentREFDCITYDR');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TODentCLNAddress1');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMDentREFDDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMDentREFDCITYDR');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMDentCLNAddress1');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMDentREFDDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMDentREFDCITYDR');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMDentCLNAddress1');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TODentREFDDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TODentREFDCITYDR');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TODentCLNAddress1');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// Date of Death fields
	var deathobj=document.getElementById('XDOD');
	if (deathobj) {
		if (deathobj.checked) {
			obj=document.getElementById('TODOD');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOTOD');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOEstDOD');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOLocationOfDeath');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOWhoNotified');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMDOD');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMTOD');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMEstDOD');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMLocationOfDeath');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMWhoNotified');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMDOD');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMTOD');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMEstDOD');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMLocationOfDeath');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMWhoNotified');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TODOD');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOTOD');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOEstDOD');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOLocationOfDeath');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOWhoNotified');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// Medicare fields
	var medicareobj=document.getElementById('XMEDICARE');
	if (medicareobj) {
		if (medicareobj.checked) {
			obj=document.getElementById('TOPAPMIMedicare');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOMedicareExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOMEDSUFDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOMedicareCode');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMPAPMIMedicare');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMMedicareExpDate');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMMEDSUFDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMMedicareCode');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMPAPMIMedicare');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMMedicareExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMMEDSUFDesc');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMMedicareCode');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOPAPMIMedicare');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOMedicareExpDate');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOMEDSUFDesc');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOMedicareCode');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// PensionCard fields
	var pensionobj=document.getElementById('XPENNUM');
	if (pensionobj) {
		if (pensionobj.checked) {
			obj=document.getElementById('TOPensionNumber');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOPensionCardExpiryDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOPensionType');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMPensionNumber');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMPensionCardExpiryDate');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMPensionType');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMPensionNumber');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMPensionCardExpiryDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMPensionType');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOPensionNumber');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOPensionCardExpiryDate');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOPensionType');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// Health Card / Fund / Concession Card fields
	var healthcardobj=document.getElementById('XFUND');
	if (healthcardobj) {
		if (healthcardobj.checked) {
			obj=document.getElementById('TOHealthCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOHealthCardExpiryDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMHealthCardNo');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMHealthCardExpiryDate');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMHealthCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMHealthCardExpiryDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOHealthCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="normal";
			obj=document.getElementById('TOHealthCardExpiryDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="normal";
		}
	}
	
	// Safety Card fields
	var safetycardobj=document.getElementById('XSAFETY');
	if (safetycardobj) {
		if (safetycardobj.checked) {
			obj=document.getElementById('TOSafetyCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOSafetyCardExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMSafetyCardNo');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMSafetyCardExpDate');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMSafetyCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMSafetyCardExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOSafetyCardNo');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOSafetyCardExpDate');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// DCA Card fields
	var dvaobj=document.getElementById('XDVANUM');
	if (dvaobj) {
		if (dvaobj.checked) {
			obj=document.getElementById('TODVANum');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TODVACard');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TODVAExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMDVANum');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMDVACard');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMDVAExpDate');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMDVANum');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMDVACard');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMDVAExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TODVANum');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TODVACard');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TODVAExpDate');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
	// Concession Card fields
	var conscardobj=document.getElementById('XCONCESSION');
	if (conscardobj) {
		if (conscardobj.checked) {
			obj=document.getElementById('TOConcessionCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('TOConcessionExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('FROMConcessionCardNo');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('FROMConcessionExpDate');
			if (obj) obj.style.fontWeight="normal";
		} else {	
			obj=document.getElementById('FROMConcessionCardNo');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			obj=document.getElementById('FROMConcessionExpDate');
			if ((obj)&&(obj.value!="")) obj.style.fontWeight="bold";
			
			obj=document.getElementById('TOConcessionCardNo');
			if (obj) obj.style.fontWeight="normal";
			obj=document.getElementById('TOConcessionExpDate');
			if (obj) obj.style.fontWeight="normal";
		}
	}
	
}


document.body.onload = DocumentLoadHandler;