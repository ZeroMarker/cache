//not used any more, field order may change!!!!
var newOrder=1;  // new order
var Gparam5="";
var Gsdcheckval="Y";
//var ordwin=window.open("","oeorder_entry");		// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen

//this is to refresh the parent window after modifying, but only if parent screen is not order entry
//if ((document.forms['fOEOrder_Normal'].elements['ID'].value!="")&&(window.opener)&&(!window.opener.document.forms['fOEOrder_Custom'])) {
//	document.forms['fOEOrder_Normal'].elements['refresh'].value=1;
//}

/*
function LookUpPatOrderSelect(str) {
	//alert("str: "+str);
 	var lu = str.split("^");
	var obj=document.getElementById("PatientOrders")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("LinkedItmID")
	if (obj) obj.value = lu[3];

}
*/

function UserNameSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("UserName")
	if (obj) obj.innerText = lu[1];

}

function UserCode_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('UserCode');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UserCode');
	if (cspRunServerMethod(encmeth,'','UserNameSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields.
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function UpdateFromOrderEntry() { //new order
	//alert("updatefromOrderEntry");
	var par_win = window.opener;
	if ((par_win.name=="TRAK_hidden")&&(window.opener)) par_win=window.opener.parent.frames['TRAK_main'].websys_windows['frmOSList'];

	var f = document.forms['fOEOrder_Normal'];
	if (par_win) {
		//var strData1 = par_win.TransferDataMain(f);
		//var strData2 = par_win.TransferDataSub(f);
		var strData1 = TransferDataMain(f);
		var strData2 = TransferDataSub(f);
		//strData2="%01"+strData2;
		var strData=strData1 + strData2;
		//par_win.CollectedFields(escape(strData));
		//log59415 tedt dont need to escape strData again here, was already escaped in TransferData fn
		par_win.CollectedFields(strData);
	}

	window.close();
	return Update_click();
}

function InvalidFields() {
	var invalid=false;
	//common fields
	if(!isInvalid("PatientLoc")&&(!invalid)) {
		alert(t['PatientLoc']+":  "+t['XINVALID']);
		invalid=true;
	}


	if(!isInvalid("OECPRDesc")&&(!invalid)) {
		alert(t['OECPRDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OSTATDesc")&&(!invalid)) {
		alert(t['OSTATDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("CTLOCDesc")&&(!invalid)) {
		alert(t['CTLOCDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("Doctor")&&(!invalid)) {
		alert(t['Doctor']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORIRefDocDR")&&(!invalid)) {
		alert(t['OEORIRefDocDR']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORIVarianceReasonDR")&&(!invalid)) {
		alert(t['OEORIVarianceReasonDR']+":  "+t['XINVALID']);
		invalid=true;
	}
	//end of common fields


	if(!isInvalid("CTPCPDesc")&&(!invalid)) {
		alert(t['CTPCPDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("TempLoc")&&(!invalid)) {
		alert(t['TempLoc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORILabEpisodeNo")&&(!invalid)) {
		alert(t['OEORILabEpisodeNo']+":  "+t['XINVALID']);
		invalid=true;
	}

	var Nobj=document.getElementById("NotifyClinician");
	var Pobj=document.getElementById("PrefConMethod");

	if((Nobj)&&(Nobj.checked)&&(Pobj)&&(Pobj.value=="")) {
		alert(t['SELECT_CONMETHD']);
		invalid=true;
	}

	return invalid;
}
function PriorityCheck(){  // log 37530 RC Add functionality from 33403
}
/*
// no longer called 56496
function PriorityFill(str) {
	var lu=str.split("^");
	//alert("Desc"+lu[0]);
	//alert("HIDDEN"+lu[1]);
	//alert("Code = "+lu[2]);
	 var PriorityObj=document.getElementById("OECPRCode");
	if (PriorityObj) { PriorityObj.value=lu[2]; }
}
*/
function UpdateSaveDefaultsClickHandler() {
	//alert("savedef");
	var SaveDefObj=document.getElementById("SaveDefaults");
	if (SaveDefObj) SaveDefObj.value="Y";
	//if (SaveDefObj) alert(SaveDefObj.value);
	UpdateClickHandler();
	//return Update_click();

}

function UpdateClickHandler() {

	if (InvalidFields()==true) {
		return false;
	}

	//Eliotc log 63784
	var PreparationTimeobj=document.getElementById("OEORIPreparationTime")
	if ((PreparationTimeobj) && (PreparationTimeobj.className=="clsInvalid")) {
				alert("INVALID");
				return false;
    }

	var WarnMsg="";
	WarnMsg=CheckForAllMendatoryFields();
	if (WarnMsg!="") {
		alert(WarnMsg);
		return false;
	}

	//Log 58325 BoC, check pregnant and breastfeeding, required functions are in OEOrder.Common.js
	PregnBrFdCheck();

	var Qobj=document.getElementById("OEORIQty");
	if((Qobj)&&(Qobj.value!="")) {
		var DQobj=document.getElementById("defQtyRange");
		if (!CheckQtyRange(Qobj)) {
			return false;
		}
	}

/*	//JPD Log 48728
	var MaxDayQty=document.getElementById("MaxDayQty");
	MaxDayQty=MaxDayQty.value;
	var MaxQty=document.getElementById("MaxQty");
	MaxQty=MaxQty.value;
	var Qobj=document.getElementById("OEORIQty");

	if((Qobj)&&(Qobj.value!="")) {
		if ((MaxDayQty!="")&&(Qobj.value>MaxDayQty)) {
				var checkqty=confirm(t['MAXDAYEXCEED']+"\n"+t['CONTINUE']);
				if (!checkqty) {
					websys_setfocus(Qobj.name);
					return false; }
		}
			
		if ((MaxQty!="")&&(Qobj.value>MaxQty)) {
				var checkqty=confirm(t['MAXQTYEXCEED']+"\n"+t['CONTINUE']);
				if (!checkqty) {
					websys_setfocus(Qobj.name);
					return false; }	
		}
	}
*/

	if(!UpdateStatusCheck()) return false;
	PriorityCheck(); //LOG 37530 RC Add functionality from 33403
	var par_win = window.opener;
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(0);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}	
	if (newOrder) {
		var sobj=document.getElementById("OEORISttDat");
 		if (sobj && (sobj.value!="")) {
			var dobj=document.getElementById("DischDate");
			var aobj=document.getElementById("AdmDate");
			if (dobj && (dobj.value!="") && aobj && (aobj.value!="")){
                var enteredDate = new Date();
				var enteredDate1 = new Date();
				var enteredDate2 = new Date();
				var enteredDate = VerifyDateformat(dobj);
				var enteredDate1 = VerifyDateformat(sobj);
				var enteredDate2 = VerifyDateformat(aobj);

				if (enteredDate1>enteredDate){
					alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
					sobj.value=""
					return false;
				}

				else if(enteredDate1<enteredDate2) {
					alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
					sobj.value=""
					return false;
				}
				Updated=1; //log 30710
				if (OrderWindow!="ORDERFAVPANEL") UpdateFromEPR(); //UpdateFromOrderEntry();
			}
			else{
				var enteredDate1 = new Date();
				var enteredDate2 = new Date();
				var enteredDate1 = VerifyDateformat(sobj);
				var enteredDate2 = VerifyDateformat(aobj);
				if(enteredDate1<enteredDate2) {
					alert(t['STARTDATE_EXCEED']+" "+aobj.value);
					sobj.value=""
					return false;
				}
				Updated=1; //log 30710
				if (OrderWindow!="ORDERFAVPANEL") UpdateFromEPR(); //UpdateFromOrderEntry();
			}
		}else {
			var dobj=document.getElementById("DischDate");
			if (dobj && (dobj.value!="")) alert(t['STARTDATE_MAN']);
			else{
				Updated=1; //log 30710
				if (OrderWindow!="ORDERFAVPANEL") UpdateFromEPR(); //UpdateFromOrderEntry();
			}
		}

	} else {
		Updated=1;	//log 30710
		//UpdateFromEPR();  //In OEOrder.Common.js
		checkDateForEPR();
		refreshParent();
	}
	//Log 46424 Add Order Group Number 
	var ID="";
	var objID=document.getElementById("ID");
	if (objID) ID=objID.value;
	var OrderGroupNumber="";
	var objOrderGroupNumber=document.getElementById("OEORIItemGroup");
	if (objOrderGroupNumber) {
		OrderGroupNumber=ID+"^"+objOrderGroupNumber.value;
		try {
			if (par_win) par_win.ChangeOrderGroupNumber(OrderGroupNumber);
		}catch(e){}
	}
	
	Updated=1; //log 30710

	if (OrderWindow=="ORDERFAVPANEL") {
		//alert("orderfav");
		UpdateFromEPR();

	}

	var win=window.opener.parent.frames[1];
	if (win) {
		var formICP=win.document.forms['fMRClinicalPathways_ItemList'];
		var formICP2=win.document.forms['fMRClinicalPathways_CarePlanItemList'];
		if (formICP||formICP2) {
			UpdateFromOrderEntry();
		}
	}
//UpdateFromOrderEntry();
}

function refreshParent() {

	var win=window.opener.parent.frames[1];
	if (win) {
		var formRad=win.document.forms['fOEOrdItem_RadiologyWorkBench'];
		if (formRad) {
			// ANA Using the URl looses workflow.
			//win.treload('websys.csp'); //log 63299 refresh done in websys.close
		}
	} else if (window.opener) {
		//should be from epr chart csp page
		var formCust=window.opener.document.forms['fOEOrder_Custom'];
		var formOSL=window.opener.document.forms['fOEOrder_OSItemList'];
		//if(!formCust && !formOSL) window.opener.history.go(0); //log 63299 refresh done in websys.close
		if (formOSL) {
			var FormArray=formOSL.RebuiltString.value.split("^");
			for (var i=0; i<FormArray.length; i++) {
				var FormStr=FormArray[i];
				var SetOrdIDArr=FormStr.split("*");
				var SetOrdID=SetOrdIDArr[1];
				var OrdID=document.getElementById("ID").value;
				if (OrdID==SetOrdID) {
					var Qty1=document.getElementById("OEORIQty");
					if (Qty1) {
						if (Qty1.value=="") Qty1.value="1";
						if (formOSL.document.getElementById("Quantityz"+(i+1))) formOSL.document.getElementById("Quantityz"+(i+1)).value=Qty1.value;
					}
				}
			}
		}
	}
//	} else if (window.opener) {
//		//should be from epr chart csp page
//		window.opener.history.go(0);
//	}
}


function DisabeInputs(eForm){
 //; *****  Log# 29236; AmiN ; 14/10/2002  To allow an Executed Order not to be modified. *****
 //runs through Executed Order to disable all except Preferred Radiologist  and Urgent Report
 // ANA temporary fix.. needs to be changed so that links & buttons other than Update and Audit trail are disabed or hidden.
 //log 30570: 1-Oct-2003 enable care provider to notify (flds 'CareProvider' and 'CareProvList') as well
	var itObj=document.getElementById("ItemDetails");
	if (itObj) itObj.style.visibility="hidden";

	var enabledfldnames = ",OEORIRemarks,OEORIDepProcNotes,OECPRDesc,UserCode,PIN,CTPCPDesc,CoveredByMainInsur,CareProvider,CareProvList,";
	var readonlyfldnames = ",OSTATDesc,";
	var iNumElems = eForm.elements.length;
	for (var i=0; i<iNumElems; i++)  {
		var eElem = eForm.elements[i];

		/******
		 //alert("tagname "+eElem.tagName+" type "+eElem.type)
          	if ("text" == eElem.type || "TEXTAREA" == eElem.tagName)    { //Preferred Radiologist
	           if (eElem.name != 'CTPCPDesc') {
	  	            eElem.disabled = true;
                  }
           	} else if ("checkbox" == eElem.type || "radio" == eElem.type)    {
                    if (eElem.name != "CoveredByMainInsur") { // Urgent Report is editable for type executed.
				        eElem.disabled = true;
			         }
          	} else if ("SELECT" == eElem.tagName)    {
            	  var cOpts = eElem.options;
            	  var iNumOpts = cOpts.length;
            	  for (var j=0; j<iNumOpts; j++)      {
            	      var eOpt = cOpts[j];
		        eOpt.disabled = true;
             	  }
          	}
		*****/
		if ((enabledfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.type!="hidden")&&(readonlyfldnames.indexOf(","+eElem.name+",")==-1)) {
			if (("hidden" != eElem.type)&&("INPUT" == eElem.tagName) || ("TEXTAREA" == eElem.tagName)) {
				eElem.disabled = true;
				var img=document.getElementById("ld252i"+eElem.id); //to hid the images for the brokers.
				//if (img) img.onclick="";
				if (img) { img.style.visibility="hidden"; }
			} else if ("SELECT" == eElem.tagName) {
				var cOpts = eElem.options;
				var iNumOpts = cOpts.length;
				for (var j=0; j<iNumOpts; j++) {
					var eOpt = cOpts[j];
					eOpt.disabled = true;
				}
			}
		}
	}
}

function HideStatusFields() {
/*
	var statcode="";
	var statOBJ=document.getElementById("OSTATDesc");
	var pendstatOBJ=document.getElementById("OEORIPENDINGSTATUS");
	var statCodeOBJ=document.getElementById("OrdStatCode");
	if (statCodeOBJ) statcode=statCodeOBJ.value;
	if (statcode=="I") {
		if ((pendstatOBJ)&&(statOBJ)) {
			if (pendstatOBJ.value!="") statOBJ.value=pendstatOBJ.value;
		}
	}

*/	
/*
	if ((statCodeOBJ.value=="I")&&(statOBJ)) {
		statOBJ.style.visibility="hidden";
		var statImgObj=document.getElementById("ld252iOSTATDesc");
		if (statImgObj) statImgObj.style.visibility="hidden";
		var statLblObj=document.getElementById("cOSTATDesc");
		if (statLblObj) statLblObj.style.visibility="hidden";
	}

	if ((statCodeOBJ.value!="I")&&(pendstatOBJ)) {
		pendstatOBJ.style.visibility="hidden";
		var pendstatImgObj=document.getElementById("ld252iOEORIPENDINGSTATUS");
		if (pendstatImgObj) pendstatImgObj.style.visibility="hidden";
		var pendstatLblObj=document.getElementById("cOEORIPENDINGSTATUS");
		if (pendstatLblObj) pendstatLblObj.style.visibility="hidden";
	}
*/

}

function BodyLoadHandler() {

	//sets global variable to determine whether adding new order or modifying current one
	var obj=document.forms['fOEOrder_Normal'].elements['ID'];
	if ((obj)&&(obj.value!="")) newOrder=0;  //not new order

	//Log 41598 PeterC 22/12/05
	var hidauthobj=document.getElementById("HidHasAuthoriseOrder");
	var hidstathobj=document.getElementById("OrdStatCode");
	if ((hidauthobj)&&(hidauthobj.value=="")&&(hidstathobj)&&(hidstathobj.value!="I")) {
		var aobj=document.getElementById("AuthoriseOrder");
		if(aobj) aobj.checked=false;
	}
	
	// ANA LOG 27959 If there is a default Status against the Layout,then do not use the default coming from Mainloop.
	// This change is made to all details screens.
	var tempstOBJ=document.getElementById("tempOSTATDesc");
	var tempstCodeOBJ=document.getElementById("tempOSTATCode")
	var statOBJ=document.getElementById("OSTATDesc");
	var statCodeOBJ=document.getElementById("OrdStatCode");
	if (statCodeOBJ&&statOBJ&&statOBJ.value==""&&tempstOBJ&&tempstCodeOBJ) {
		statCodeOBJ.value=tempstCodeOBJ.value;
		statOBJ.value=tempstOBJ.value;
	}

	//HideStatusFields();
	var par_win = window.opener;
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(1);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}	

	if (statCodeOBJ){
		if ((statCodeOBJ.value=="E")||(statCodeOBJ.value=="D")) {		// ANA 18NOV02 Changed this to compare with Code rather than Desc of Status.
		   //; *****  Log# 29236; AmiN ; 14/10/2002  For Oeorder.Normal  to allow Executed Order to be modified. *****
		    var frm=document.fOEOrder_Normal;
		    var IsReadOnly=document.getElementById("ReadOnly");	 //Is type executed. information from Class(web.OEOrdItem).SetOrderDetailsFields()
	 	    if (IsReadOnly.value=="Y") {
		      DisabeInputs(frm);
	       }
	    }
	    // LOG 34938 RC 18/11/03 Need to put this in to disable the Status field after all the other fields have been
	    // disabled. Need to make sure all the other fields on the page get disabled too.
	    if (statCodeOBJ.value=="D") {
			if (statOBJ) statOBJ.disabled=true;
			var statOBJlu=document.getElementById("ld252iOSTATDesc");
			if (statOBJlu) statOBJlu.style.visibility="hidden";
			var obj=document.getElementById("OECPRDesc");
			if (obj) obj.disabled=true;
			var objlu=document.getElementById("ld252iOECPRDesc");
			if (objlu) objlu.style.visibility="hidden";
			var obj=document.getElementById("CoveredByMainInsur");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("CTPCPDesc");
			if (obj) obj.disabled=true;
			var objlu=document.getElementById("ld252iCTPCPDesc");
			if (objlu) objlu.style.visibility="hidden";
			var obj=document.getElementById("OEORIRemarks");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("OEORIDepProcNotes");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("CareProvider");
			if (obj) obj.disabled=true;
			var objlu=document.getElementById("ld252iCareProvider");
			if (objlu) objlu.style.visibility="hidden";
		}
	}
	var sobj=document.getElementById("OSTATDesc");
	var bfobj=document.getElementById("BilledFlag");
	if (bfobj) {
		if (bfobj.value=="TR"||bfobj.value=="R") {
			if (sobj) sobj.disabled=true;
		}
	}

	//LOG 35170 RC 13/06/03 Require 3 htm links on order details screens
	var patOrdFile1=document.getElementById("patOrdFile1");
	var patOrdFile2=document.getElementById("patOrdFile2");
	var patOrdFile3=document.getElementById("patOrdFile3");
	var PatientOrderFile1=document.getElementById("PatientOrderFile1");
	var PatientOrderFile2=document.getElementById("PatientOrderFile2");
	var PatientOrderFile3=document.getElementById("PatientOrderFile3");

	if ((patOrdFile1)&&(PatientOrderFile1)) {
		if (patOrdFile1.value=="") {
			PatientOrderFile1.disabled=true;
			PatientOrderFile1.onclick=NoLink;
		} else {
			PatientOrderFile1.onclick=OpenWindow1;
		}
	}
	if ((patOrdFile2)&&(PatientOrderFile2)) {
		if (patOrdFile2.value=="") {
			PatientOrderFile2.disabled=true;
			PatientOrderFile2.onclick=NoLink;
		} else {
			PatientOrderFile2.onclick=OpenWindow2;
		}
	}
	if ((patOrdFile3)&&(PatientOrderFile3)) {
		if (patOrdFile3.value=="") {
			PatientOrderFile3.disabled=true;
			PatientOrderFile3.onclick=NoLink;
		} else {
			PatientOrderFile3.onclick=OpenWindow3;
		}
	}

	var itObj=document.getElementById("ItemDetails");
   	var qaObj=document.getElementById("qa");
	if (newOrder) {
		if (itObj) itObj.style.visibility="hidden"
		if (qaObj) qaObj.style.visibility="hidden"
	}

	var UpdateSaveObj=document.getElementById("UpdateSaveDefaults");
	if (UpdateSaveObj) UpdateSaveObj.onclick = UpdateSaveDefaultsDelayOnUpdate;	//update link
	if (tsc['UpdateSaveDefaults']) {
		websys_sckeys[tsc['UpdateSaveDefaults']]=UpdateSaveDefaultsDelayOnUpdate;
	}

	var UpdateObj=document.getElementById("Update");
	if (UpdateObj) UpdateObj.onclick = DelayOnUpdate;	//update link
	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=DelayOnUpdate;
	}

	var PatProObj=document.getElementById("PatOrderProfile");
	if (PatProObj) PatProObj.onclick=PatientOrderProfile;

	var obj=document.getElementById("OEORIRefDocDR");
	//if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById("ld252iOEORIRefDocDR");
	//if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;

	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;

	var obj=document.getElementById("DeleteRef");
	if (obj) obj.onclick=DeleteRefClickHandler;

	var qobj=document.getElementById("Questionnaire");
	if (qobj) qobj.onclick=QuestionnaireClickHandler;

	LoadCareProviders();
	LoadRefDoctor();

	HideField();

	//Log 46700
	var SummaryFlag="";
	var objSF=document.getElementById("SummaryFlag");
	if ((objSF)&&(objSF.value!="")) SummaryFlag=objSF.value;
	if (OrderWindow=="oeorder_entry") {
		var hosobj=document.getElementById("hiddenOrderStatus");
		var hpsobj=document.getElementById("hiddenPendingStatus");
		var sobj=document.getElementById("OSTATDesc");
		if (sobj) {
			if ((hpsobj)&&(hpsobj.value!="")) {
				sobj.value=hpsobj.value;
				sobj.innerText=hpsobj.value;
			}
			else if ((sobj.value=="")&&(hosobj)&&(hosobj.value!="")) {
				sobj.value=hosobj.value;
				sobj.innerText=hosobj.value;
			}
		}
	}else if (SummaryFlag!="") {
		var hosobj=document.getElementById("hiddenOrderStatus");
		var hpsobj=document.getElementById("hiddenPendingStatus");
		var sobj=document.getElementById("OSTATDesc");
		if (sobj) {
			if ((hpsobj)&&(hpsobj.value!="")) {
				sobj.value=hpsobj.value;
				sobj.innerText=hpsobj.value;
			}
			else if ((hosobj)&&(hosobj.value!="")) {
				sobj.value=hosobj.value;
				sobj.innerText=hosobj.value;
			}
		}
	}else {
		var hosobj=document.getElementById("hiddenOrderStatus");
		var sobj=document.getElementById("OSTATDesc");
		if (sobj) {
			 if ((hosobj)&&(hosobj.value!="")) {
			 	sobj.value=hosobj.value;
				sobj.innerText=hosobj.value;
			}
		}
	}
	
	InitStatusCheck("ld252iOSTATDesc");
	
	var frm=document.fOEOrder_Normal;
	var modeobj=document.getElementById("Mode");
	if ((modeobj)&&(modeobj.value=="READONLY"||modeobj.value=="PARTIALREAD")) 
		DisableAllButTwo(frm,modeobj.value); //log61154 TedT

	var NCobj=document.getElementById("NotifyClinician");
	if (NCobj) NCobj.onclick=NotifyClinicianChangeHandler;

	//Log 50948 PeterC 10/03/05
	if (document.getElementById("CareProvList")) {document.getElementById("CareProvList").tkItemPopulate=1;}
	if (document.getElementById("RefDoctorList")) {document.getElementById("RefDoctorList").tkItemPopulate=1;}

	//Log 49134 JPD: BMI and BSA, add BSA formula type.
	var BSAForm=document.getElementById("BSAFormula");
	if ((BSAForm)&&(BSAForm.value!="")) SetBSAForm();

	var objboldlnk=document.getElementById("BoldLinks");
	var objalertmess=document.getElementById("OEOrdAlertMessage");
	if (objboldlnk && objalertmess && objboldlnk.value=="1") objalertmess.style.fontWeight="bold"

	window.focus();  // 65197
}

function UpdateSaveDefaultsDelayOnUpdate(){
	setTimeout("UpdateSaveDefaultsClickHandler()",1000);
	return false;
}

function DelayOnUpdate(){
	setTimeout("UpdateClickHandler()",1000);
	return false;
}

//Log 49134 JPD: BMI and BSA, add BSA formula type.
function SetBSAForm() {
	var BSAForm=document.getElementById("BSAFormula");
	if (BSAForm.value!="") {
		if (BSAForm.value=="B") BSAForm.value="Boyd";
		if (BSAForm.value=="G") BSAForm.value="Gehan and George";
		if (BSAForm.value=="M") BSAForm.value="Mosteller";
		if (BSAForm.value=="H") BSAForm.value="Haycock";
		if (BSAForm.value=="D") BSAForm.value="DuBois and DuBois";
	}
	return false;
}
//Log 49134 JPD
function BSAFormReturn(Str){
	var lu = Str.split("^");
	var BSA=document.getElementById("BSA");
	if (BSA) BSA.innerText=lu[2];
	return false;
}

function NoLink() {
	return false;
}

function OpenWindow1() {
	var patOrdFile1=document.getElementById("patOrdFile1");
	var PatientOrderFile1=document.getElementById("PatientOrderFile1");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((patOrdFile1)&&(patOrdFile1.value!="")) {
		var url=patOrdFile1.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile1', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OpenWindow2() {
	var patOrdFile2=document.getElementById("patOrdFile2");
	var PatientOrderFile2=document.getElementById("PatientOrderFile2");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((patOrdFile2)&&(patOrdFile2.value!="")) {
		var url=patOrdFile2.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile2', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OpenWindow3() {
	var patOrdFile3=document.getElementById("patOrdFile3");
	var PatientOrderFile3=document.getElementById("PatientOrderFile3");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((patOrdFile3)&&(patOrdFile3.value!="")) {
		var url=patOrdFile3.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile3', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OEORIRemarks_onkeydown() {
//required to call this function to override the generic script
//DL : LOG 29062 : 02/Oct/02
}

function OEORIDepProcNotes_onkeydown() {
//required to call this function to override the generic script
//DL : LOG 29062 : 02/Oct/02
}

function ClearField() {
	var obj=document.getElementById("CareProvider")
	if (obj) obj.value="";
	var obj=document.getElementById("OEORIRefDocDR")
	if (obj) obj.value="";
	var obj=document.getElementById("CopyToClinician")
	if (obj) obj.value="";
}

function DeleteClickHandler() {
	//Delete items from lstOrders listbox when a "Delete" button is clicked.
	var obj=document.getElementById("CareProvList")
	if (obj) RemoveFromList(document.fOEOrder_Normal,obj)
}

function DeleteRefClickHandler() {
	//Delete items from lstOrders listbox when a "Delete" button is clicked.
	var obj=document.getElementById("RefDoctorList")
	if (obj) RemoveFromList(document.fOEOrder_Normal,obj)
}

function BodyUnLoadHandler() { //log 30710 AmiN Start Date must be within Episode Admin Date and Discharge date.
	//If there is any mandatory field left unfilled, alert the user and delete the order item from the list.
	var par_win = window.opener;
	if (OrderWindow=="order_entry") par_win=window.open('',OrderWindow); //par_win=par_win.top.frames[1];
	var WarnMsg="";
	WarnMsg=CheckForAllMendatoryFields();
	//alert("WarnMsg="+WarnMsg);
	//if (WarnMsg!="") {
	if ((WarnMsg!="")&&(OrderWindow!="")&&(par_win)&&(par_win.document.fOEOrder_Custom)) {
		alert(WarnMsg+"\n"+t['WillDeleteOrder']);
		try{
			var delID="";
			var idobj=document.getElementById("ID");
			if (idobj) {
				delID=idobj.value;
				if ((delID!="")&&(par_win)) {
					par_win.DeleteOrderByID(delID);
				}
			}
		}catch(e){}
	}
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(0);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
		// log 63386 BoC: close Questionnaire Window when closing order details window
		if (par_win.QuestionnaireWin) {
			try{
				par_win.QuestionnaireWin.close();
			}catch(e){}
		}
	}	

	//alert("Enabled the update button");
	//Go to the details page of the next order item
	if ((OrderWindow!="")&&(par_win)&&(par_win.document.fOEOrder_Custom)) par_win.OrderDetailsShowing(par_win.document.fOEOrder_Custom);
	//alert("OrderDetailsShowing called");

	// JD refresh order list with new values 54852
	if (OrderWindow=="oeorder_entry") {
		try {
			var detailFrame=window.open("","oeorder_entry");
			//log 60877 timeout to allow username and PIN validation
			if (detailFrame) detailFrame.DelayedRefreshSessionList();
		} catch(e) {
			//log58506 TedT kill blank window
			detailFrame.close();
		}
	}
	if (document.getElementById('ID')) {var ID=document.getElementById('ID').value;} else {var ID="";}
	var serverupdate=tkMakeServerCall("web.OEOrdItem","LockClear",ID);
}
function CheckForAllMendatoryFields() {
	var AllGetValue="";
	for (var i=0;i<document.fOEOrder_Normal.elements.length;i++) {
		if (document.fOEOrder_Normal.elements[i].id!="") {
			var elemid="c"+document.fOEOrder_Normal.elements[i].id;
			var elemc=document.getElementById(elemid);
			var elem=document.getElementById(document.fOEOrder_Normal.elements[i].id);
			if ((elemc) && (elemc.className=="clsRequired")) {
				if ((elem)&&(elem.value=="")) AllGetValue=AllGetValue+elemc.innerText+":  "+t['XMISSING']+"\n";
			}
		}
	}
	return AllGetValue;
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;

/*
function OEORISttDat_onBlur(e) {
	var obj=document.getElementById("OEORISttDat");
	Gparam5=obj.value;
	var objDate = DateStringToDateObj(Gparam5);
	var objToday = new Date();
	if (objDate < objToday) {
		var hsdcobj=document.getElementById("HiddenStartDateCheck");
		if (hsdcobj) hsdcobj.onchange();
		//alert("Gsdcheckval="+Gsdcheckval);
		if (Gsdcheckval=="Y") {
			alert(t['InClosedAccPeriod']);
		}
	}
}


function HiddenStartDateCheck_changehandler(encmeth) {
	//alert(" "+encmeth+" "+Gparam5);
	Gsdcheckval=cspRunServerMethod(encmeth,Gparam5);
}
*/

//Log 61186 PeterC 29/11/06
var Gparam6="";
var Gparam7="";
var Gparam8="";
var currDate="";
function OEORISttDat_onBlur(e) {
	var obj=document.getElementById("OEORISttDat");
	Gparam5=obj.value;
	var obj=document.getElementById("OEORIItmMastDR");
	if((obj)&&(obj.value!="")) Gparam6=obj.value;
	var obj=document.getElementById("EpisodeID");
	if((obj)&&(obj.value!="")) Gparam7=obj.value;
	var obj=document.getElementById("OECPRDesc");
	if((obj)&&(obj.value!="")) Gparam8=obj.value;
	var hsdcobj=document.getElementById("HiddenStartDateCheck");
	if (hsdcobj) hsdcobj.onchange();
	//alert("Gsdcheckval="+Gsdcheckval);
	var ICAPAlert=mPiece(Gsdcheckval,"^",0);
	var RecLoc=mPiece(Gsdcheckval,"^",1);
	if ((ICAPAlert!="")&&(ICAPAlert=="Y")) {
		alert(t['InClosedAccPeriod']);
	}
	var obj=document.getElementById("CTLOCDesc");
	if((obj)&&(Gparam5!="")&&(Gparam5!=currDate)) obj.value=RecLoc;
	if(currDate!=Gparam5) currDate=Gparam5;
}

function HiddenStartDateCheck_changehandler(encmeth) {
	Gsdcheckval=cspRunServerMethod(encmeth,Gparam5,Gparam6,Gparam7,Gparam8);
}

var obj=document.getElementById("OEORISttDat");
if (obj) {
	obj.onblur=OEORISttDat_onBlur;
	currDate=obj.value;
}

function DisableElementsWhenInvoiced() {
	var COPHobj=document.getElementById("ChgOrderPerHour");
	var obj=document.getElementById("OEORISttDat");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORISttTim");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIEndDate");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIEndTime");
	if (obj) obj.disabled=true;
	if ((COPHobj)&&(COPHobj.value=="Y")) {
		var obj=document.getElementById("OEORIEndDate");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("OEORIEndTime");
		if (obj) obj.disabled=false;
	}
	var obj=document.getElementById("OEORIQty");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("DrugForm");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIDoseQty");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("PHCFRDesc1");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("PHCDUDesc1");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OSTATDesc");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("PHCINDesc1");
	if (obj) obj.disabled=true;
}

 function DisableAllButTwo(eForm,mode){
    var iNumElems = eForm.elements.length;     //for only form elements.
    //log 61154 TedT
	var enabledfldnames="";
	var readonlyfldnames="";
	if(mode=="PARTIALREAD"){
		enabledfldnames = ",OEORIRemarks,OEORIDepProcNotes,OECPRDesc,UserCode,PIN,CareProvider,CareProvList,";
		readonlyfldnames = ",OSTATDesc,";
		//Log 62313 PeterC 22/01/07
		var obj=document.getElementById("ChgOrderPerHour");
		var bobj=document.getElementById("BilledFlag");
		if((obj)&&(obj.value=="Y")&&(bobj)&&(bobj.value!="")) {
			if((bobj.value=="P")||(bobj.value=="TR")||(bobj.value=="R")) enabledfldnames=enabledfldnames+"OEORIEndDate,OEORIEndTime,";
			var obj=document.getElementById("OEORIEndDate");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("OEORIEndTime");
			if (obj) obj.disabled=false;
		}
	}
    for (var i=0; i<iNumElems; i++)  {
        var eElem = eForm.elements[i];
        //if ( (eElem.name != 'OEORIRemarks') && (eElem.name != 'OEORIDepProcNotes') && (eElem.name != 'OECPRDesc') && (eElem.name != 'UserCode') && (eElem.name != 'PIN')) {
        //Log 60455 Bo 07-08-2006: if the field is "readOnly=true" already, don't set it to be "disabled=true" again.
		if ((enabledfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.type!="hidden")&&(readonlyfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.readOnly==false)) {
            if (("hidden" != eElem.type)&&("INPUT" == eElem.tagName) || ("TEXTAREA" == eElem.tagName)) {
                eElem.disabled = true;
                var img=document.getElementById("ld252i"+eElem.id); //to hid the images for the brokers.
                //if (img) img.onclick="";
                if (img) { img.style.visibility="hidden"; }
            } else if ("SELECT" == eElem.tagName) {
                var cOpts = eElem.options;
                var iNumOpts = cOpts.length;
                for (var j=0; j<iNumOpts; j++) {
                    var eOpt = cOpts[j];
                    eOpt.disabled = true;
                }
            }
		}
    }
}