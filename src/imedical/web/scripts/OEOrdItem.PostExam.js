// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var delimListDesc = " : ";

var postobj=document.getElementById('fOEOrdItem_PostExam');
var postLMP=postobj.elements('OEORILMPDate');
if (postLMP) postLMP.onblur=DateBlurHandler;

function BodyLoadHandler() {
	LoadHandler();
	// Log 43788 - RC - 06-08-2004 : Update the ResultAvailableDate on component load.
	DateExecutedBlurHandler();
	var obj=document.getElementById("FilmsUsed");
	if ((obj)&&(obj.value!="")) PopulateUsedList(obj.value);
	var obj=document.getElementById("FilmsRejected");
	if ((obj)&&(obj.value!="")) PopulateRejectedList(obj.value);
	var obj=document.getElementById("FilmIsotope");
	if ((obj)&&(obj.value!="")) PopulateIsotopeList(obj.value);
	
	var obj=document.getElementById("updatePost");
	if (obj) obj.onclick=UpdatePostDelay;
}

function PostUserNameSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PostExamUserName")
	if (obj) obj.innerText = lu[1];

}

function OEORIPostExamUser_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('OEORIPostExamUser');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('OEORIPostExamUser');
	if (cspRunServerMethod(encmeth,'','PostUserNameSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields.
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function DateBlurHandler() {
	var preobj=document.getElementById('fOEOrdItem_PreExam');
	var postobj=document.getElementById('fOEOrdItem_PostExam');
	var preLMP=preobj.elements('OEORILMPDate');
	var postLMP=postobj.elements('OEORILMPDate');
	var postLMPval=postLMP.value
	if ((preLMP) && (postLMP)) {
		preLMP.value=postLMPval;
		preLMP.disabled=true;
		if (postLMPval=="") preLMP.disabled=false;
	}
}

function SelectAllListItems() {
	var lst=document.getElementById("FilmsUsedList");
	if (lst) {
		for (var i=0; i<=(lst.length-1); i++) {
			lst.options[i].selected=true;
		}
	}
	var lst=document.getElementById("FilmsRejectedList");
	if (lst) {
		for (var j=0; j<=(lst.length-1); j++) {
			lst.options[j].selected=true;
		}
	}
	var lst=document.getElementById("FilmIsotopeList");
	if (lst) {
		for (var k=0; k<=(lst.length-1); k++) {
			lst.options[k].selected=true;
		}
	}
}

function JoinListItems() {
	var lst=document.getElementById("FilmsUsedList");
	var obj=document.getElementById("FilmsUsed");
	if ((lst)&&(obj)) UpdateStoredList(lst,obj);
	var lst=document.getElementById("FilmsRejectedList");
	var obj=document.getElementById("FilmsRejected");
	if ((lst)&&(obj)) UpdateStoredList(lst,obj);
	var lst=document.getElementById("FilmIsotopeList");
	var obj=document.getElementById("FilmIsotope");
	if ((lst)&&(obj)) UpdateStoredList(lst,obj);
}

function UpdatePostClickHandlerDelay() {
	window.setTimeout("UpdatePostClickHandler();",1500);
}

//log60450 TedT
function UpdatePostDelay() {
	window.setTimeout("UpdatePostClickHandler()",200)
}

function UpdatePostClickHandler() {
	// Log 43788 - RC - 06-08-2004 : Check the ResultAvailableDate is valid before updating.
	if (!ResultAvailableDateBlurHandler()) return false;
	//log 60450 TedT check invalid fileds
	msg=CheckAllFieldValue();
	if(msg!="") {
		alert(msg); 
		return false;
	}
	
	SelectAllListItems();
	JoinListItems();
	/*
	LOG 31420 RC 12/02/03 This tmpLMPDate field is needed because sometimes the LMPDate on
	the postExam component is displayed	and if the user enters the LMPDate in the preExam
	component then when the update is selected on the postExam component, it is blank.
	This tmpLMPDate is used to combat this if the user does not enter a date in the
	LMPDate of postExam.
	*/
	var preobj=document.getElementById('fOEOrdItem_PreExam');
	var postobj=document.getElementById('fOEOrdItem_PostExam');
	var preLMP=preobj.elements('OEORILMPDate');
	var postLMP=postobj.elements('OEORILMPDate');
	var tmpLMP=postobj.elements('tmpLMPDate');
	if (preLMP) {
		var preLMPval=preLMP.value;
		tmpLMP.value=preLMPval;
	} else if (postLMP) {
		var postLMPval=postLMP.value;
		tmpLMP.value=postLMPval
	}
	
	//LOG 63954 ELIOTC 18/06/07 Start
    var prePregCheck=preobj.elements('OEORIPregnancyCheck');
	var tmpPregCheck=postobj.elements('tmpPregCheck');
	if (prePregCheck) {
		var prePregCheckVal=prePregCheck.value;
		tmpPregCheck.value=prePregCheckVal;
		//alert("Eliot"+prePregCheckVal);
	} 
  //LOG 63954 ELIOTC 18/06/07 End

	// LOG 35518 RC 14/05/03 Make sure the exam start time is saved as the right time, even if the pre exam doesn't get
	// executed separately.
	var pretime=preobj.elements('OEORIExamStartTime');
	var posttime=postobj.elements('OEORIExamStartTime');
	if (pretime) {		//Log 63907 - 13.06.2007 - Copy the Exam Start Time frm PreExam to the Post Exam ONLY if Exam Start time is configured in the PreExam component. Otherwise leave the Post Exam value as it is.
		var timeval=pretime.value;
		posttime.value=timeval;
	}	

	var RFobj=document.getElementById("RestrictFemale");
	if (RFobj && RFobj.value=="Y"){
		//alert("Female");
		var preobj=document.getElementById("OEORIPregnancyCheck");
		var lmpobj=document.getElementById("OEORILMPDate");
		if (preobj && preobj.value==""){
			alert(t['PRECHECK_MAN']);
			return false;
		}

		else if (lmpobj && lmpobj.value==""){
			alert(t['LMPDATE_MAN']);
			return false;
		}

	}
	return updatePost_click();
}

function RemoveListItems(lst) {
	for (var i=(lst.length-1); i>=0; i--) {
		if (lst.options[i].selected) lst.options[i]=null;
	}
	//return false;
}
function UpdateStoredList(lst,fld) {
	var arrItems=new Array();
	var arrDesc=new Array();
	for (var i=0; i<lst.options.length; i++) {
		arrDesc = lst.options[i].text.split(delimListDesc);
		arrItems[i] = arrDesc.join("^");
	}
	if (fld) fld.value = arrItems.join(String.fromCharCode(1));
}
function ClearField(fldname) {
	var obj=document.getElementById(fldname);
	if (obj) obj.value="";
}

var msg="";
function CheckFieldValue(fldname) {
	var val=""
	var obj=document.getElementById(fldname);
	if (obj) {
		if (obj.value=="") {
			msg+=t[fldname]+" "+t['XMISSING']+"\n";
			obj.focus();
		} else if (obj.className=="clsInvalid") {
			msg+=t[fldname]+" "+t['XINVALID']+"\n";
			obj.focus();
		} else {
			val=obj.value;
		}
	}
	return val;
}

//log 60450 TedT check invalid classname
function CheckAllFieldValue() {
	var AllGetValue="";
	var arr=document.getElementsByTagName("input");
	var elemc="";
	var text="";
	
	for (var i=0; i<arr.length; i++) {
		if(arr[i].id!="" && arr[i].className=="clsInvalid") {
			if (arr[i].name!="PINPost") {		//Log 65443 - 15.11.2007 - ignore if its the password field. This will be validated the usual way.
				elemc=document.getElementById("c"+arr[i].id);
				//log 62474 TedT if elemc does not exist, do not show field caption
				if (elemc) text=elemc.innerText;
				else text="";
				if (arr[i].value!="") AllGetValue=AllGetValue+text+":  "+t['XINVALID']+"\n";
			}
		}	
	}
	
	return AllGetValue;
}

function FilmsUsedAdd(e) {
	var lst=document.getElementById("FilmsUsedList");
	if (lst) {
		var desc="";
		msg=""; //global variable set in CheckFiledValue function
		var NumUsed=CheckFieldValue('FilmsUsedNumber');
		if (NumUsed!="") desc=NumUsed;
		var TypeUsed=CheckFieldValue("FilmsUsedType");
		if (TypeUsed!="") desc+=" : "+TypeUsed;
		if (msg!="") {alert(msg);msg="";return false;}
		if (desc!="") {
			lst.options[lst.options.length] = new Option(desc);
			ClearField('FilmsUsedNumber');
			ClearField('FilmsUsedType');
		}
	}
	return false;
}

function FilmsUsedDelete(e) {
	var lst=document.getElementById("FilmsUsedList");
	if (lst) RemoveListItems(lst);
	return false;
}

function PopulateUsedList(fld) {
	var lst=document.getElementById("FilmsUsedList");
	var arrItems=new Array();
	var i=0;
	var re=/\^/gi;
	while (mPiece(fld,String.fromCharCode(1),i)!="") {
		var str=mPiece(fld,String.fromCharCode(1),i)
		if (str==undefined) return;
		str=str.replace(re,delimListDesc);
		lst.options[lst.options.length] = new Option(str);
		i=i+1;
	}
}

function FilmsRejectedAdd(e) {
	var lst=document.getElementById("FilmsRejectedList");
	if (lst) {
		var desc="";
		msg=""; //global variable set in CheckFiledValue function
		var NumRej=CheckFieldValue("FilmsRejectedNumber");
		if (NumRej!="") desc=NumRej;
		var TypeRej=CheckFieldValue("FilmsRejectedType");
		if (TypeRej!="") desc+=" : "+TypeRej;
		var ReasonRej=CheckFieldValue("FilmsRejectedReason");
		if (ReasonRej!="") desc+=" : "+ReasonRej;
		if (msg!="") {alert(msg);msg="";return false;}
		if (desc!="") {
			lst.options[lst.options.length] = new Option(desc);
			ClearField('FilmsRejectedNumber');
			ClearField('FilmsRejectedType');
			ClearField('FilmsRejectedReason');
		}
	}
	return false;
}

function FilmsRejectedDelete(e) {
	var lst=document.getElementById("FilmsRejectedList");
	if (lst) RemoveListItems(lst);
	return false;
}

function PopulateRejectedList(fld) {
	var lst=document.getElementById("FilmsRejectedList");
	var arrItems=new Array();
	var i=0;
	var re=/\^/gi;
	while (mPiece(fld,String.fromCharCode(1),i)!="") {
		var str=mPiece(fld,String.fromCharCode(1),i)
		if (str==undefined) return;
		str=str.replace(re,delimListDesc);
		lst.options[lst.options.length] = new Option(str);
		i=i+1;
	}
}

function FilmIsotopeAdd(e) {
	var lst=document.getElementById("FilmIsotopeList");
	if (lst) {
		var desc="";
		msg=""; //global variable set in CheckFiledValue function
		var IsoDose=CheckFieldValue("FilmIsotopeDose");
		if (IsoDose!="") desc=IsoDose;
		var IsoPharm=CheckFieldValue("FilmIsotopePharmac");
		if (IsoPharm!="") desc+=" : "+IsoPharm;
		if (msg!="") {alert(msg);msg="";return false;}
		if (desc!="") {
			lst.options[lst.options.length] = new Option(desc);
			ClearField('FilmIsotopeDose');
			ClearField('FilmIsotopePharmac');
		}
	}
	return false;
}

function FilmIsotopeDelete(e) {
	var lst=document.getElementById("FilmIsotopeList");
	if (lst) RemoveListItems(lst);
	return false;
}

function PopulateIsotopeList(fld) {
	var lst=document.getElementById("FilmIsotopeList");
	var arrItems=new Array();
	var i=0;
	var re=/\^/gi;
	while (mPiece(fld,String.fromCharCode(1),i)!="") {
		var str=mPiece(fld,String.fromCharCode(1),i)
		str=str.replace(re,delimListDesc);
		lst.options[lst.options.length] = new Option(str);
		i=i+1;
	}
}

function FilmsUsedAddRedirect(){

	//var ReadOnly=document.getElementById("ReadOnly");
	//if (ReadOnly && (ReadOnly.value=="1")) return false;
	//else FilmsUsedAdd();
	//return false;

	FilmsUsedAdd();
	return false;
}

function FilmsUsedDeleteRedirect(){

	//var ReadOnly=document.getElementById("ReadOnly");
	//if (ReadOnly && (ReadOnly.value=="1")) return false;
	//else FilmsUsedDelete();
	//return false;

	FilmsUsedDelete();
	return false;
}

function FilmsRejectedAddRedirect(){

	//var ReadOnly=document.getElementById("ReadOnly");
	//if (ReadOnly && (ReadOnly.value=="1")) return false;
	//else FilmsRejectedAdd();
	//return false;

	FilmsRejectedAdd();
	return false;
}

function FilmsRejectedDeleteRedirect(){

	//var ReadOnly=document.getElementById("ReadOnly");
	//if (ReadOnly && (ReadOnly.value=="1")) return false;
	//else FilmsRejectedDelete();
	//return false;

	FilmsRejectedDelete();
	return false;
}

function FilmIsotopeAddRedirect(){

	//var ReadOnly=document.getElementById("ReadOnly");
	//if (ReadOnly && (ReadOnly.value=="1")) return false;
	//else FilmIsotopeAdd();
	//return false;

	FilmIsotopeAdd();
	return false;
}

function FilmIsotopeDeleteRedirect(){

	//var ReadOnly=document.getElementById("ReadOnly");
	//if (ReadOnly && (ReadOnly.value=="1")) return false;
	//else FilmIsotopeDelete();
	//return false;

	FilmIsotopeDelete();
	return false;
}

function NonStandardReportReason(str) {   //AmiN log 31884
	//Description ** HIDDEN **  Code ** AltReport
	var lu=str.split("^");
	//alert ("147 desc ^id ^code^report= "+lu[0]+"&&"+lu[1]+"&&"+lu[2]+"&&"+lu[3]);

	obj=document.getElementById("NonStDRepIssReason")
	if (obj) obj.value = lu[0] ;

	AltReportobj=document.getElementById("NSRIRAlternateReport")
	if ((lu[3]!="")&&(AltReportobj)) AltReportobj.value = lu[3] ;

	// itmobj=document.getElementById("OEORIItemStatus") //???
	// if (itmobj) itmobj.value = "RESV" ;

}

function DateHandler(eSrc) {
	var msg="";
	var obj = document.getElementById("OEORIContrastExpiryDate");
	if (obj)
	{
		OEORIContrastExpiryDate_changehandler(e); // call default

		var arrDate = SplitDateStr(obj.value)
		var dtEntered = new Date(arrDate["y"], arrDate["m"]-1, arrDate["d"]);
 		var dtNow = new Date();
		dtNow.setHours(0);
		dtNow.setMinutes(0);
		dtNow.setSeconds(0);
		dtNow.setMilliseconds(0);

 		if (dtEntered < dtNow) {
	    		alert(t['ContExpiryDate']);
    			obj.value = "";
	    		websys_setfocus("OEORIContrastExpiryDate");
    			return false;
		}
	}
}

function SplitDateStr(strDate) {
 	var arrDateComponents = new Array(3);
 	var arrDate = strDate.split(dtseparator);
 	switch (dtformat) {
  	case "YMD":
	   	arrDateComponents["y"] = arrDate[0];
   		arrDateComponents["m"] = arrDate[1];
	   	arrDateComponents["d"] = arrDate[2];
	   	break;
  	case "MDY":
		arrDateComponents["y"] = arrDate[2];
	   	arrDateComponents["m"] = arrDate[0];
	   	arrDateComponents["d"] = arrDate[1];
   		break;
	default:
	   	arrDateComponents["y"] = arrDate[2];
	   	arrDateComponents["m"] = arrDate[1];
	   	arrDateComponents["d"] = arrDate[0];
	   	break;
 	}
	return arrDateComponents;
}

// Log 43788 - RC - 06-08-2004 : Set up OnBlur event for the ResultAvailableDate.
function ResultAvailableDateBlurHandler() {
	// invalidflg : 0 if not invalid; 1 if invalid

	var objResAvailDate=document.getElementById("ResultAvailableDate");
	if (!objResAvailDate) return true;

	var invalidflg="";
	invalidflg=IsValidResAvailDate();

	if (invalidflg==1) {
		alert(t['InvalidResAvailDate']);
	}

	if (invalidflg!=0) {
		objResAvailDate.className="clsInvalid";
		websys_setfocus('ResultAvailableDate');
		return false;
	}

	objResAvailDate.className="";
	return true;
}

function IsValidResAvailDate() {
	// invalidflg : 0 if not invalid; 1 if invalid
	var objResAvailDate=document.getElementById("ResultAvailableDate");
	var objdateexe="";
	var ResAvailDateHval="";
	var dateExe="";
	var invalidflg=0;
	var yeardate="";
	if ((objResAvailDate)&&(objResAvailDate.value!="")) {
		// convert value to a date
		objdateexe=document.getElementById("OEORIDateExecuted");
		if ((objdateexe)&&(objdateexe.value!="")) {
			ResAvailDateHval=DateStringTo$H(objResAvailDate.value);
			dateExe=DateStringTo$H(objdateexe.value);
			// check that it is greater than or equal to the date executed
			if (ResAvailDateHval<dateExe) {
				invalidflg=1;
			}
			// check that it is less than or equal to (date executed + 365)
			yeardate=dateExe+365;
			if (ResAvailDateHval>yeardate) {
				invalidflg=1;
			}
		}
	}
	return invalidflg;
}

// Log 43788 - RC - 06-08-2004 : Each time the DateExecuted or TimeExecuted is changed, update the ResultAvailableDate via csp.
function DateExecutedBlurHandler() {
	var dateval="";
	var timeval="";
	var objtoday=document.getElementById("today");
	var objnow=document.getElementById("now");

	var dateExeobj=document.getElementById("OEORIDateExecuted");
	if (dateExeobj) dateval=dateExeobj.value;
	if (!dateExeobj) dateval=objtoday.value;
	var timeExeobj=document.getElementById("OEORITimeExecuted");
	if (timeExeobj) timeval=timeExeobj.value;
	if (!timeExeobj) dateval=objnow.value;

	var ordItemobj=document.getElementById("OEOrdItemID");

	var lnk="oeorditem.postexamdateready.csp?date="+dateval+"&time="+timeval+"&OrdItemID="+ordItemobj.value;
	websys_createWindow(lnk,"TRAK_hidden");
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

var obj=document.getElementById("OEORIContrastExpiryDate")
if (obj) obj.onchange = DateHandler;

var obj=document.getElementById("ResultAvailableDate");
if (obj) obj.onblur = ResultAvailableDateBlurHandler;

// Log 43788 - RC - 06-08-2004 : Each time the DateExecuted or TimeExecuted is changed, update the ResultAvailableDate.
var obj=document.getElementById("OEORIDateExecuted");
if (obj) obj.onblur = DateExecutedBlurHandler;

// Log 43788 - RC - 06-08-2004 : Each time the DateExecuted or TimeExecuted is changed, update the ResultAvailableDate.
var obj=document.getElementById("OEORITimeExecuted");
if (obj) obj.onblur = DateExecutedBlurHandler;

var obj=document.getElementById("FilmsUsedAdd");
if (obj) obj.onclick=FilmsUsedAddRedirect;

var obj=document.getElementById("FilmsUsedDelete");
if (obj) obj.onclick=FilmsUsedDeleteRedirect;

var obj=document.getElementById("FilmsRejectedAdd");
if (obj) obj.onclick=FilmsRejectedAddRedirect;

var obj=document.getElementById("FilmsRejectedDelete");
if (obj) obj.onclick=FilmsRejectedDeleteRedirect;

var obj=document.getElementById("FilmIsotopeAdd");
if (obj) obj.onclick=FilmIsotopeAddRedirect;

var obj=document.getElementById("FilmIsotopeDelete");
if (obj) obj.onclick=FilmIsotopeDeleteRedirect;

document.body.onload=BodyLoadHandler;