// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var twkfl=document.getElementById("TWKFL")
var twkfli=document.getElementById("TWKFLI")

function Init() {
	websys_firstfocus();

	var obj;
	var objFind=document.getElementById('find1');
	if (objFind) objFind.onclick= FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	
	var objRun=document.getElementById('Run');
	if (objRun) objRun.onclick= RunClickHandler;
	if (tsc['Run']) websys_sckeys[tsc['Run']]=RunClickHandler;
	
	// AJI 
	var objRunEx=document.getElementById('RunExtract');
	if (objRunEx) objRunEx.onclick= RunExtractClickHandler;
	if (tsc['RunExtract']) websys_sckeys[tsc['RunExtract']]=RunExtractClickHandler;

	// AJI 
	var objHosp = document.getElementById('Hospital');
	if (objHosp && objHosp.value!="") {
		var defhosp=objHosp.value
		HospitalLookUpSelect(objHosp.value);
		var objDefHosp = document.getElementById('DefaultHosp');
		if (objDefHosp) objDefHosp.value=defhosp; // preserve in a hidden field
	}
	var objDelHosp = document.getElementById('DeleteHospital');
	if (objDelHosp) objDelHosp.onclick = DeleteHospitalClickHandler;	

	var objSelHosp = document.getElementById("SelHospital");
	if (objSelHosp && objSelHosp.value!="") ReloadSelectedHospital(objSelHosp.value);

	var objErrorMsg = document.getElementById("ErrorMsg");
	if (objErrorMsg && objErrorMsg.value!="") alert(objErrorMsg.value);
}

//AJI 2/9/03 log 34918/34930
function FindClickHandler(e) {
	var SMR00=""; var SMR01=""; var UKExtract1=""; var StartDate=""; var EndDate=""; var RunDate=""; var UserName="";
	
	var objSMR00=document.getElementById("SMR00")
	var objSMR01=document.getElementById("SMR01")
	var objUKExtract1=document.getElementById("UKExtract1")

	if ((objSMR00)&&(objSMR00.checked==true)) SMR00=objSMR00.value
	if ((objSMR01)&&(objSMR01.checked==true)) SMR01=objSMR01.value
	if ((objUKExtract1)&&(objUKExtract1.checked==true)) UKExtract1=objUKExtract1.value

	var objFindParam=document.getElementById("HiddenFindParam")
	if (objFindParam) objFindParam.value=SMR00+"^"+SMR01+"^"+UKExtract1;
	
	//Cause in the backend it will default the search to Default Hospital if none is selected therefore need to do it accordingly here - AJI 34918
	var hosplist = document.getElementById('HospitalList');
	if ((hosplist)&&(hosplist.options.length==0)) {
		var objDefHosp = document.getElementById('DefaultHosp');
		if (objDefHosp&&objDefHosp.value!="") HospitalLookUpSelect(objDefHosp.value);
	}

	var objStart=document.getElementById("StartDate");
	if (objStart) {
		if (objStart.className=="clsInvalid") return false
		StartDate=objStart.value;		
	}
	var objEnd=document.getElementById("EndDate");
	if (objEnd) {
		if (objEnd.className=="clsInvalid") return false
		EndDate=objEnd.value;		
	}
	var objRun=document.getElementById("RunDate");
	if (objRun) {
		if (objRun.className=="clsInvalid") return false
		RunDate=objRun.value;		
	}
	var obj=document.getElementById("UserName");
	if (obj) UserName=obj.value;
	
	var urlParam="&StartDate=" + StartDate + "&EndDate=" + EndDate + "&RunDate=" + RunDate + "&UserName=" + UserName
	var url = LoadURL("websys.default.csp?WEBSYS.TCOMPONENT=PASMRExtractBuild.List", urlParam);
	var win2=top.frames["TRAK_main"].frames['PASMRExtractBuildList'];
	if (win2) win2.location=url;
	
	return find1_click(); //Log 64695 - 04.10.2007
}

//Aji 4/9/03 log 34918 - QHME Run Extract
function RunExtractClickHandler(e) {

	var startdate = document.getElementById('StartDate');  
	if (startdate && startdate.value == "") {
		alert(t['StartDate']+" "+t['mustbeentered']);
		return false;
	}

	var enddate=document.getElementById('EndDate');
	if ((enddate)&&(enddate.value=="")) {
		alert(t['EndDate']+" "+t['mustbeentered']);
		return false;
	}

	var lstHosp = document.getElementById('HospitalList');  //Listbox
	if (lstHosp && lstHosp.options.length == 0) {
		alert(t['hosprequired']);
		return false;
	}
	
	var url = LoadURL("websys.default.csp?WEBSYS.TCOMPONENT=PASMRExtractBuild.List","");
	var win2=top.frames["TRAK_main"].frames['PASMRExtractBuildList'];

	if (win2) win2.location=url;

	return RunExtract_click();
}

//AJI
function LoadURL(csp,urlParam) {
	var objList=document.getElementById('HospitalList');
	if (objList) SetSelectedHospital();
	
	var RecordType = "";
	var HiddenFindParam="";
	var obj=document.getElementById("HiddenFindParam")
	if (obj) HiddenFindParam=obj.value;

	var site="";
	obj = document.getElementById("Site");
	if (obj) site = obj.value;

	var SelHosp="";
	obj = document.getElementById("SelHospital");
	if (obj) SelHosp=obj.value;

	var wkfl="";
	var conx=session['CONTEXT'];
	var wkfli="";

	if (twkfl)  wkfl = twkfl.value;
	if (twkfli) wkfli = twkfli.value;	 
	
	var url = csp;
	url=url + "&SelHospital=" + SelHosp + "&Site=" + site + "&TWKFL=" + wkfl + "&TWKFLI=" + wkfli + "&CONTEXT=" + conx;
	url=url + "&RecordType=" + RecordType + "&HiddenFindParam=" + HiddenFindParam;
	url=url + urlParam;
		
	return url;
}

/*
   This method exists to reload the selected hospital 
   into the list when the page reloads.
   SelHosp is always sent in the format:  |hospid^hospdesc|hospid2^hospdesc2|
*/
function ReloadSelectedHospital(str) {
	var lu = str.split("|");
	if (lu) {
		for (var i=1; i<lu.length; i++) {
			if (lu[i]!="") HospitalLookUpSelect(lu[i],false);
		}
	}
}

//AJI 4/9/03 log 34918 - called from Lookup List, specified in LookupJSFunction
function HospitalLookUpSelect(str,needalert) {
	if (needalert==null) needalert=true;
	var lu = str.split("^");
	var obj=document.getElementById('Hospital');
	if (obj) obj.value=lu[1];
	var objList=document.getElementById('HospitalList');
	if (objList) {
		var tfield='Hospital';
		var lfield='HospitalList';
		LookupSelectforList(tfield,lfield,str,needalert);
	}
}

//AJI 4/9/03 log 34918
function LookupSelectforList(tfield,lfield,txt,needalert) {
	//Add an item to List when an item is selected from the Lookup, then clears the text field.
	var adata = txt.split("^");
	var obj = document.getElementById(lfield);  //Listbox
	if (obj) {
		//Need to check if text already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2) + adata[1]) {
				if (needalert) alert( adata[1] + " has already been selected");
				var obj=document.getElementById(tfield);  //Textbox with lookup 
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[1])) {
				if (needalert) alert( adata[1] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[0],adata[1]);
	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
}

//AJI 4/9/03 log 34918
function AddItemToList(list,rowid,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,rowid);
}

//AJI 4/9/03 log 34918
function DeleteHospitalClickHandler() {
	//Delete items from Entered listbox when "Delete" button is clicked.
	var obj=document.getElementById("HospitalList");
	if (obj) RemoveFromList(obj);
	return false;
}

//AJI 4/9/03 log 34918
function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected) obj.options[i]=null;
	}
}

/**
 * AJI 4/9/03 log 34918 - 
 * Get all items from HospitalList and construct a series of hospID delimited by a pipe
 * SelHosp is always sent in the format |hospid^hospdesc|hospid2^hospdesc2|
 */
function SetSelectedHospital() {
	var hospitals="";
	var lstHosp = document.getElementById("HospitalList");
	var numberchosen=0
	if (lstHosp) {
		for (var j=0; j<lstHosp.options.length; j++) {
			//SelHosp is always sent in the format |hospid^hospdesc|hospid2^hospdesc2|
			hospitals = hospitals + lstHosp.options[j].value + "^" + lstHosp.options[j].text + "|"
		}
		if (lstHosp.options.length > 0) hospitals = "|" + hospitals; //need the pipe at the beginning!!

		var objSelHosp = document.getElementById("SelHospital");
		if (objSelHosp) objSelHosp.value=hospitals;
	}
}


// limit of 16 parameters can be passed to find query.
// create hidden field "objFindParam" to pass 16 + parameters
// It passes two flags and the Medical Record Type
/*
function FindClickHandler(e) {
	
	//alert("FindClickHandler");

	var SMR00=""
	var SMR01=""
	var UKExtract1=""
	var UKExtract2=""
	var UKExtract3=""
	var UKExtract4=""
	var UKExtract5=""
	var UKExtract6=""
	var UKExtract7=""
	var UKExtract8=""
	var UKExtract9=""
	var UKExtract10=""
	
	var objSMR00=document.getElementById("SMR00")
	var objSMR01=document.getElementById("SMR01")
	var objUKExtract1=document.getElementById("UKExtract1")
	var objUKExtract2=document.getElementById("UKExtract2")
	var objUKExtract3=document.getElementById("UKExtract3")
	var objUKExtract4=document.getElementById("UKExtract4")
	var objUKExtract5=document.getElementById("UKExtract5")
	var objUKExtract6=document.getElementById("UKExtract6")
	var objUKExtract7=document.getElementById("UKExtract7")
	var objUKExtract8=document.getElementById("UKExtract8")
	var objUKExtract9=document.getElementById("UKExtract9")
	var objUKExtract10=document.getElementById("UKExtract10")

	if ((objSMR00)&&(objSMR00.checked==true)) SMR00=objSMR00.value
	if ((objSMR01)&&(objSMR01.checked==true)) SMR01=objSMR01.value
	if ((objUKExtract1)&&(objUKExtract1.checked==true)) UKExtract1=objUKExtract1.value
	if ((objUKExtract2)&&(objUKExtract2.checked==true)) UKExtract2=objUKExtract2.value
	if ((objUKExtract3)&&(objUKExtract3.checked==true)) UKExtract3=objUKExtract3.value
	if ((objUKExtract4)&&(objUKExtract4.checked==true)) UKExtract4=objUKExtract4.value
	if ((objUKExtract5)&&(objUKExtract5.checked==true)) UKExtract5=objUKExtract5.value
	if ((objUKExtract6)&&(objUKExtract6.checked==true)) UKExtract6=objUKExtract6.value
	if ((objUKExtract7)&&(objUKExtract7.checked==true)) UKExtract7=objUKExtract7.value
	if ((objUKExtract8)&&(objUKExtract8.checked==true)) UKExtract8=objUKExtract8.value
	if ((objUKExtract9)&&(objUKExtract9.checked==true)) UKExtract9=objUKExtract9.value
	if ((objUKExtract10)&&(objUKExtract10.checked==true)) UKExtract10=objUKExtract10.value

	//NB: objFlag should always be there as it is a hidden field...
	var objFindParam=document.getElementById("HiddenFindParam")
	if (objFindParam) objFindParam.value=SMR00+"^"+SMR01+"^"+UKExtract1+"^"+UKExtract2+"^"+UKExtract3+"^"+UKExtract4+"^"+UKExtract5+"^"+UKExtract6+"^"+UKExtract7+"^"+UKExtract8+"^"+UKExtract9+"^"+UKExtract10+"^"

	//alert(objFindParam.value);
	//return false

	return find1_click();
}
*/

function RunClickHandler(e) {
	
	var SMR00=""; var SMR01=""; var UKExtract1=""; var StartDate=""; var EndDate=""; var RunDate=""; var UserName="";
	
	var objSMR00=document.getElementById("SMR00")
	var objSMR01=document.getElementById("SMR01")
	var objUKExtract1=document.getElementById("UKExtract1")

	if ((objSMR00)&&(objSMR00.checked==true)) SMR00=objSMR00.value
	if ((objSMR01)&&(objSMR01.checked==true)) SMR01=objSMR01.value
	if ((objUKExtract1)&&(objUKExtract1.checked==true)) UKExtract1=objUKExtract1.value

	var objFindParam=document.getElementById("HiddenFindParam")
	if (objFindParam) objFindParam.value=SMR00+"^"+SMR01+"^"+UKExtract1;
	
	var objStart=document.getElementById("StartDate");
	if (objStart) {
		if (objStart.className=="clsInvalid") return false
		StartDate=objStart.value;		
	}
	var objEnd=document.getElementById("EndDate");
	if (objEnd) {
		if (objEnd.className=="clsInvalid") return false
		EndDate=objEnd.value;		
	}
	var objRun=document.getElementById("RunDate");
	if (objRun) {
		if (objRun.className=="clsInvalid") return false
		RunDate=objRun.value;		
	}
	var obj=document.getElementById("UserName");
	if (obj) UserName=obj.value;
	
	var urlParam="&StartDate=" + StartDate + "&EndDate=" + EndDate + "&RunDate=" + RunDate + "&UserName=" + UserName + "&UserName=" + UserName
	var url = LoadURL("websys.default.csp?WEBSYS.TCOMPONENT=PASMRExtractBuild.List",urlParam);
	var win2=top.frames["TRAK_main"].frames['PASMRExtractBuildList'];
	
	if (win2) win2.location=url;
	
	return Run_click();
}


document.body.onload=Init;