// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//alert("OEOrder.Common")

// 56496
//Log 61052 3-10-2006 BoC: check if the page is loading or lookup is being used
var pageLoad=true;
function PriorityChangeHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("CTLOCDesc");
	//BoC: don't set value when loading the page; set value when clicking the lookup
	if (obj && !obj.disabled && lu[4] && lu[4]!="" && !(obj.disabled) && !pageLoad) obj.value = lu[4];
	pageLoad=false;
	// for pages where code needs to be inserted
	var CodeObj=document.getElementById("OECPRCode");
	if (CodeObj) CodeObj.value=lu[1];
	var HPObj=document.getElementById("HidOECPRCode");
	if (HPObj) HPObj.value=lu[1];
	return;
}

// ab 6.03.07 62712 - so both the "Word Result Code" and generic canned text work together
// ab 12.03.07 - removed this
//Log 66227 PeterC 31/01/08
function OEORIRemarks_keydownhandler(encmeth) {
	//var keychar=websys_getKey(window.event);
	//if (keychar==117) {
	//	HandleLookupCode('OEORIRemarks','d128iOEORIRemarks',encmeth,keychar);
	//} else {
		var obj=document.getElementById("OEORIRemarks");
		//LocateCode(obj,encmeth);
		LocateCode(obj,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
	//} 
}

/*
function OEORIRemarks_lookupsel(str) {
 var lu=str.split('^');
 if (lu.length==1) return;
 ReplaceLookupCode(lu[1],'OEORIRemarks');
}
*/
// ab 6.03.07 62712 - so both the "Word Result Code" and generic canned text work together
//Log 66227 PeterC 31/01/08
function OEORIDepProcNotes_keydownhandler(encmeth) {
	//var keychar=websys_getKey(window.event);
	//if (keychar==117) {
	//	HandleLookupCode('OEORIDepProcNotes','d128iOEORIDepProcNotes',encmeth,keychar);
	//} else {
		var obj=document.getElementById("OEORIDepProcNotes");
		//LocateCode(obj,encmeth);
		LocateCode(obj,encmeth,0,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
	//}
}

function OETLookupCode_replace(newval,isrtf) {
	if (isrtf==1) {
		enteredField.Replace(newval);
	} else {
 	// NOTE : Existing W650 logic kept here.
		if (enteredField) {
			//alert('back with: ' + newval + '\nentered: ' + enteredField
			//+ '\nenteredtextrange: ' + enteredField.createTextRange
			//+ '\nenteredcursor: ' + enteredField.cursorPos);

			var origtxt = enteredField.value;
			if (enteredField.createTextRange && enteredField.cursorPos) {enteredField.cursorPos.text=newval;}
			enteredField.focus();
			enteredField = null;
		}
	}
}

/*
function OEORIDepProcNotes_lookupsel(str) {
 var lu=str.split('^');
 if (lu.length==1) return;
 ReplaceLookupCode(lu[1],'OEORIDepProcNotes');
}

// copied from generated code
function ReplaceLookupCode(str,fldName) {
 var arrtxt=str.split(' | ');
 var fulltxt=arrtxt.join('\n');
 var fld=document.getElementById(fldName);
 if (fld) {
  if (fld.tagName=='OBJECT') {fld.Replace(fulltxt);}
  if (fld.tagName=='TEXTAREA') {
   if (fld.createTextRange && fld.cursorPt) {
    fld.cursorPt.text=fulltxt;
    fld.cursorPt=fld.createTextRange();
    fld.cursorPt.move('textedit'); fld.cursorPt.select();
   }
  }
  fld.focus();
 }
}
*/
function submitForm() {
	var frm = document.forms[0];
	if (frm.name=="fPAPerson_Banner") frm=document.forms[1];
	if (frm.kCounter) frm.kCounter.value = 1;
	return Update_click();
}

function LoadCareProviders() {
	//alert(CPList);
	var obj=document.getElementById("CareProvList");
	var i=1;

	if (obj) {

		while((mPiece(CPList,"^",i)!=null && mPiece(CPList,"^",i)!="")) {
				obj.options[obj.length] = new Option(mPiece(CPList,"^",i),mPiece(CPList,"^",i));
				i++;
		}
	}
}

function LoadRefDoctor() {
	var obj=document.getElementById("RefDoctorList");
	var i=1;

	if (obj) {

		while((mPiece(RefDOcList,"^",i)!=null && mPiece(RefDOcList,"^",i)!="")) {
				obj.options[obj.length] = new Option(mPiece(RefDOcList,"^",i),mPiece(RefDOcList,"^",i));
				i++;
		}
	}
}

function CareProvLookupSelect(txt) {
	//var idesc="";
	//var icode="";
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[2];

	AddCareProvToList(idesc,icode);
	//log57017 TedT
	var obj=document.getElementById("CareProvider");
	if(obj) obj.value="";
}

function AddCareProvToList(desc,code) {
	var obj=document.getElementById("CareProvList");
	if (obj) {
		obj.selectedIndex = -1;

		obj.options[obj.length] = new Option(desc,code);
	}
}

function NewCareProvLookupSelect(txt) {
	//var idesc="";
	//var icode="";
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];

	AddCareProvToList(idesc,icode);
	ClearField();
}

//Log 51206 13/04/05 PeterC
function RefDocLookupSelect(txt) {
	var adata=txt.split("^");
	//var idesc=adata[0];
	//var icode=adata[1];

	var obj=document.getElementById("OEORIRefDocDR");
	if(obj) obj.value=adata[1];

	//AddRefDocToList(idesc,icode);
	//try {
	//	ClearField();
	//} catch(e) { }
}

function AddRefDocToList(desc,code) {
	//debugger;
	var obj=document.getElementById("RefDoctorList");
	if (obj) {
		obj.selectedIndex = -1;

		obj.options[obj.length] = new Option(desc,code);
	}
}

function PatientOrderProfile() {
		var obj=document.getElementById("FileNotes");

		if (obj) {
			var orderfile=obj.value;

			if (orderfile!="&nbsp;") {
				var url = "../Help/"+orderfile;
                                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
			}
		}
}

function RemoveFromList(f,obj) {
	if (obj) {
		for (var i=(obj.length-1); i>=0; i--) {
			if (obj.options[i].selected){
				obj.options[i]=null;
			}
		}
	}
}

function RemoveOrderSetFromList(f,obj,setid) {
	//alert(obj+" setid: "+setid);
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected){
			var selItmid=obj.options[i].value;
			if(setid==selItmid) obj.options[i]=null;
		}
	}
}

function QuestionnaireClickHandler() {
	var QnaireId="";
	var EpObj=document.getElementById("EpisodeId");
	if (EpObj) EpisID=EpObj.value;
	var PatObj=document.getElementById("PatientID");
	if (PatObj) PatientID=PatObj.value;
	var obj=document.getElementById("QuestionnaireID");
	if (obj) QnaireId=obj.value;
	var obj=document.getElementById("ID");
	if (obj) OEId=obj.value;
	var obj=document.getElementById("QuestRowID");
	if (obj) QuestRowId=obj.value;

	if (QnaireId!="") {
		//Log 64787 PeterC 07/01/08: Shouldn't pass multiple PatientID and EpisodeID
		PatientID=mPiece(PatientID,"^",0);
		EpisID=mPiece(EpisID,"^",0);
		OEId=mPiece(OEId,"^",0);

		var url = "ssuserdefwindowcontrols.questionnaire.csp?QuestionnaireID="+QnaireId+"&PatientID="+PatientID+"&EpisodeID="+EpisID+"&OEORIRowId="+OEId+"&ID="+QuestRowId+"&norefresh=1";
		//alert("url: "+url);
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url, "","top=0,width=500,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
}
//ANA 21-Nov-2002: Code over-writes one from SCRIPTS_GEN so that it can pass in the WEBSYS.TCOMPONENT value: REF: PAAdm.Edit.Js.
//USed  by all Order Details Screens.

function REFDDesc_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=";
		var obj=document.getElementById("OEORIRefDocDR");
		if (obj) {namevaluepairs="&P1="+obj.value+"&P2=&P3=";}
		//alert("boo ")
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
		//alert("boo 1 ")
	}
}
/*
function REFDDesc_lookuphandlerCustom2(namevaluepairs) {
	var url='websys.lookup.csp';
	//url += "?ID=d251iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	url += "?ID=d251iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs+"&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=ViewDoctorLookUp";
	var tmp=url.split('%');
	url=tmp.join('%25');
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}

function REFDDesc_lookupsel(value) {
	try {
		var obj=document.getElementById("OEORIRefDocDR");
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		websys_nextfocus(obj.sourceIndex);
		}
	} catch(e) {};
}
*/
function ViewDoctorLookUp(str) {
	var lu = str.split("^");
	//alert(str)
	/*
	var obj;
	// Set Referal Doctor Code to hidden field
	//obj=document.getElementById("REFDCode")
	//if (obj) obj.value = lu[8]
	obj=document.getElementById("OEORIRefDocDR")
	if (obj) obj.value = lu[1]
	*/
	//var idesc=lu[1];
	//var icode=lu[5];
	//SB 23/05/05 (51474): We now show doctor details in idesc and store doctor surname in icode.
	// This has been modified in function TransferDataSub where we now grab value rather than description.
	var idesc=lu[30];
	var icode=lu[1];

	if (icode=="") return false;
	AddRefDocToList(idesc,icode);
	try {
		ClearField();;
	} catch(e) { }
}

function OECRouteLookUpHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("OEORIRoute");
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("HiddenRoute");
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("RouteAdmin");
	if (obj) obj.value="";
}
function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
	//alert(s1+","+sep+","+n);
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}
function HideField() {
	var qidobj=document.getElementById("QuestionnaireID");
	if (qidobj) {
		if (qidobj.value=="") {
			var qobj=document.getElementById("Questionnaire");
			if (qobj) qobj.style.visibility = "hidden";
		}
	}
	//for new items, disable the audit trail links
	//TN: 28 Aug 2003: disable link ... do not hide!
	var objlnk=document.getElementById("AuditTrail");
	if (objlnk) {
		var obj=document.getElementById("ID");
		if ((obj)&&(obj.value=="")) {
			objlnk.disabled = true;
			objlnk.onclick = LinkDisable;
		}
	}
}

function UpdateFromEPR() { //updating an existing order.
	//alert("in COnmmon.js UpdateFromEPR ");
   //SB 14/6/05 (53071): Use timer to allow brokers to validate before update is triggered.
   if (evtTimer) {
	window.setTimeout("UpdateFromEPR()",websys_brokerTime+20);
   } else {
	var frm = document.forms[0];
	if (frm.name=="fPAPerson_Banner") frm=document.forms[1];

	var OSCobj=document.getElementById("OriginalOrdStatCode");

	 var sobj=document.getElementById("OrdStatCode");	 //take out later
	 //if (sobj) alert ("132 sobj = "+sobj.innerText);
	//alert(OSCobj+"  "+sobj);
	//SB 14/6/05 (53071): Check AuthDoctor has a valid entry (needs to be placed in function)
	if(!isInvalid("AuthDoctor")) {
		alert(t['AuthDoctor']+":  "+t['XINVALID']);
		return false;
	}
	if(!isInvalid("AuthClinician")) {
		alert(t['AuthClinician']+":  "+t['XINVALID']);
		return false;
	}
	if (OSCobj) {
		 //alert("Common 133 OriginalOrdStatCode ="+OSCobj.value);
		if (OSCobj.value=="E") {
			if ((frm.name=="fOEOrder_Normal") || (frm.name=="fOEOrder_Lab")){			//// *****  Log# 29236 & 29699; AmiN ; 16/10/2002   To allow Normal order to be changed after Execute.*****
				var data1=TransferDataMain(frm);
				var data2=TransferDataSub(frm);
				//data2="%01"+data2;
				var data=data1+data2;
				data=String.fromCharCode(1)+data;
				//alert("PETERC1: " + data);
				if (data!="") AddInput(frm,data);
				submitForm();
				//return Update_click();
			} else {
			   alert(t['EXECUTED_ORDER']);
			}
		}
		if (OSCobj.value=="IP") {
			alert(t['OE_INPROG']);
		}

		if((OSCobj.value !="E")&&(OSCobj.value !="IP")) {
			var data1=TransferDataMain(frm);
			var data2=TransferDataSub(frm);
			//data2="%01"+data2;
			var data=data1+data2
			data=String.fromCharCode(1)+data;
			//alert("data: " + unescape(data));
			if (data!="") AddInput(frm,data);
			submitForm();
		}
	}

	if (!OSCobj) {
			//alert("Common 153 !OSCobj");
	     var sobj=document.getElementById("OrdStatCode");	  // new value entered by the user on the web page.
	     if (sobj) {
	     	if(sobj.value=="Executed") {
				if ((frm.name=="fOEOrder_Normal") || (frm.name=="fOEOrder_Lab")){
				    var data1=TransferDataMain(frm);
				    var data2=TransferDataSub(frm);
				    //data2="%01"+data2;
				    var data=data1+data2
				    data=String.fromCharCode(1)+data;
				    //alert("PETERC3: " + data);
			        if (data!="") AddInput(frm,data);
			        submitForm();
			   } else {
			   alert(t['EXECUTED_ORDER']);
			   }
			}
		    if(sobj.value !="Executed") {
			   var data1=TransferDataMain(frm);
			   var data2=TransferDataSub(frm);
			   //data2="%01"+data2;
		         var data=data1+data2
			   data=String.fromCharCode(1)+data;
			   //alert("PETERC4: " + data + " frm: " + frm.name);
			    if (data!="") AddInput(frm,data);
			    submitForm();
		    }
	    }
	}
	//window.close();
   }
}

function TransferDataMain(frm) {
	//alert ("in TransferDataMain line 178"+frm.id);
	var strData = "";
	var arrElem = new Array("ID","EpisodeID","OEORIItmMastDR","ORDERSETID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","PatientOrders","OEORIVarianceReasonDR","Modifiers","teeth","ColDate","ColTime","SpecCollected","OEORIReasOrdCMVNegBlood","OEORICompXMatchReq","OEORIAutologousBloodReq","OEORIPatConsentObtained","OEORIBBTAG1","OEORIBBTAG2","OEORIBBTAG3","OEORIBBTAG4","OEORIBBTAG5","ORNCDesc","OEORINoOrderedBags","OEORIBagsAvailFrLastOrder","SpecSites","OEORIEndDat","OEORIRefDocDR");
	//populates items in web.OEOrdItme method SetInsertVars
	var arrData = new Array(arrElem.length);
	var arrDefaultData = new Array(arrElem.length);

	//initialise
	for (var i=0; i<arrData.length; i++) {
		arrData[i] = "";
	}

	//var el = frm.elements["OEORIDepProcNotes"];
	//alert(el.value);

	//collect Data
	for (i=0; i<arrElem.length; i++) {
		var el = frm.elements[arrElem[i]];
		//if (el) alert("id="+el.id+" value= "+el.value)
		if (el) {
			if (el.type=="select-multiple") {
				for (var j=0; j<el.options.length; j++) {
					if (el.name=="CareProvList") {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="MealType") && (el.options[j].selected)) {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="Modifiers") && (el.options[j].selected)) {

						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.options[j].selected) && (el.name!="Modifiers")) {

						arrData[i] += "^" + el.options[j].value ;
					}
				}
					//Log 58256 PeterC 10/02/06
					if (((el.name=="CareProvList"))&&(arrData[i]=="")) {
 						arrData[i]="DELETED_BLANK";
					}

			} else {
				//if (arrElem[i]=="OEORIDepProcNotes") alert("el.id="+el.id+"  el.type="+el.type+"  el.value="+el.value);
				if (el.type=="checkbox") {
					//Log 52910 PeterC 16/06/05: If the tickbox is on the page, and it is not checked, set its value to "N" (to differentiate not on page and not checked).
					if (el.checked==false) arrData[i]="N";
					else if (el.checked) arrData[i]="Y";
					else {arrData[i]=el.value;}
				} else {
					if ((arrElem[i]=="OEORIDepProcNotes")||(arrElem[i]=="OEORIRemarks")) {
						while(el.value.indexOf("+")!=-1) {
							el.value=el.value.replace("+",String.fromCharCode(8));
						}
						arrData[i] = el.value;
					}else {
						arrData[i] = el.value;
					}
				}
			}
		}
	}
	//return Data in string
	strData = arrData.join(String.fromCharCode(1));
	//alert("Peterc a: " + strData);
	strData = websys_escape(strData);
	//alert("Peterc a: " + strData);
	return strData;
}

function TransferDataSub(frm) {
	//alert("in TransferDataSub  line 229"+frm);
	var strData = "";
	var arrElem = new Array("AccessionNumber","DBList","LabVolume","ReceivedDate","ReceivedTime","PatientLoc","TheatBookDate","ReqForTheat","UnitsColl","IncompReas","FreqFactor","hidTimeUnit","IndicateTransfusion","ARCIMPHCDFDR","OEORIEndDate","OEORIEndTime","LinkedItmID","OEORIContOrderAfterDischarge","OEORIRoute","AuthDoctor","CopyOrderRowId","PendingStatus","PrefConMethod","RefDoctorList","NotifyClinician","HidenDBSpecSites","EligibilityStatus","ContactDetails","CareProv","AuthClinician","OEORIFreqDelay","DoctorID","AuthDoctorID","ConsDocID","RouteAdmin","OEORISpecialty","DayCycle","ClinCond","ClinCondDR","RBAViews","RBAActivity","LabelText1","LabelText","LabelTextOnMed","OEORIQtyPackUOM","PRNIndication","PRNTotNumberDosesAll","PRNMaxDose24hrs","OEORISupplierContactedDate","OEORISupplierContactedTime","OEORIProsReceivedDate","OEORIProsReceivedTime","OEORIProsBatchNo","OEORIProsSerialNo","OEORIProsSupplier","OEORIExpiryDate","OEORISize","specSel","OEORIAnnotateDR","urgent");
	//,"ColDate","ColTime","SpecCollected");
	var arrData = new Array(arrElem.length);
	var arrDefaultData = new Array(arrElem.length);

	//initialise
	for (var i=0; i<arrData.length; i++) {
		arrData[i] = "";
	}
	
	//collect Data
	for (i=0; i<arrElem.length; i++) {
		var el = frm.elements[arrElem[i]];
		//if (el) alert("id="+el.id+" "+i+" value= "+el.value)
		if (el) {
			if (el.type=="select-multiple") {
				for (var j=0; j<el.options.length; j++) {
					if (el.name=="CareProvList") {
						arrData[i] += "^" + el.options[j].text;
					}
					if (el.name=="RefDoctorList") {
						//arrData[i] += "^" + el.options[j].text;
						arrData[i] += "^" + el.options[j].value;
					}
					if ((el.name=="MealType") && (el.options[j].selected)) {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="Modifiers") && (el.options[j].selected)) {

						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.options[j].selected) && (el.name!="Modifiers")) {
						arrData[i] += "^" + el.options[j].value ;
					}
				}
					//Log 58256 PeterC 10/02/06
					if (((el.name=="RefDoctorList"))&&(arrData[i]=="")) {
 						arrData[i]="DELETED_BLANK";
					}


			} else {
				if (el.type=="checkbox") {
					//Log 52910 PeterC 16/06/05: If the tickbox is on the page, and it is not checked, set its value to "N" (to differentiate not on page and not checked).
					if (el.checked==false) arrData[i]="N";
					else if (el.checked) arrData[i]="Y";
					else {arrData[i]="";}
				} else {
					arrData[i] = el.value;
					//if(el.name=="OEORIAnnotateDR")
						//alert("ted: "+el.value);
					//if (el.name=="ReceivedDate") {
					//	alert(el.value);
					//}
				}
			}
		}
	}
	//return Data in string
	strData = String.fromCharCode(1) + arrData.join(String.fromCharCode(1));
	//alert("ted: strData: "+strData);
	//strData = arrData.join(String.fromCharCode(1));
	strData = websys_escape(strData);
	//alert("debugging13: "+mPiece(strData,String.fromCharCode(1),13));
	return strData;
}

function AddInput(f,value) {
	//alert("AddInput:"+f.name);
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem1';
	NewElement.name = 'hiddenitem1';
	//alert("value: "+value);
	//NewElement.value = escape(value);
	NewElement.value = value;
	NewElement.type = "HIDDEN";

	f.dummy.insertAdjacentElement("afterEnd",NewElement);
	//alert(document.getElementById('hiddenitem1').value);
}

function VerifyDateformat(obj) {
	var date="";
	date=obj.value;

	var dateRtn = new Date();
	//dateRtn =DateTimeStringToDateObj(date,time);
	dateRtn =DateStringToDateObj(date);

	/*
	var hh="0";
	var mm="0"
	var ss="0";
	if(time) {
		hh=mPiece(time,":",0)
		mm=mPiece(time,":",1)
	}

	var dateArr = date.split(dtseparator);

	if(dtformat=="YMD")
	{
		dateArr[1]=dateArr[1]-1;
		date = new Date(dateArr[0],dateArr[1],dateArr[2],hh,mm,ss);
	}

	else if(dtformat=="MDY")
	{
		dateArr[0]=dateArr[0]-1;
		date = new Date(dateArr[2],dateArr[0],dateArr[1],hh,mm,ss);
	}

	else
	{
		dateArr[1]=dateArr[1]-1;
		date = new Date(dateArr[2],dateArr[1],dateArr[0],hh,mm,ss);
	}
	*/
	return dateRtn;
}


function MandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function UnMandatoryField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		if (lbl) lbl = lbl.className = "";
	}


}

function StatusSelectHandler(str) {
	if (str) {
		var lu=str.split("^");
		if (lu[1]=="U") {
			var DObj=document.getElementById("Doctor");
			var SSObj=document.getElementById("SSGrpUnverified");
			if((DObj)&&(SSObj)&&(SSObj.value=="Y")){
				alert(t['SSGRP_UNVERIFIED'])
				//alert("Status Change")
				MandatoryField("Doctor");
			}
		}

		else {
			UnMandatoryField("Doctor");
		}
	}
}

function InitStatusCheck(icon) {
	var Oobj=document.getElementById("OSTATDesc");
	var hidObj=document.getElementById("hidStatus");
	var SSObj=document.getElementById("SSGrpUnverified");
	var idObj=document.getElementById("ID");

	if ((SSObj)&&(SSObj.value=="Y")&&(idObj)&&(idObj.value==""))	//if ((SSObj)&&(SSObj.value=="Y"))
	{
		if ((hidObj)&&(hidObj.value!="")) {
			//(Oobj)&&(Oobj.value!="")&&
			if((Oobj)&&(Oobj.value!="")) Oobj.value=hidObj.value;
			//don't disable, as status needs to be submitted for ssgroup status check, make readonly instead
			//DisablePatLocField("OSTATDesc",icon);
			MakeFieldReadonly("OSTATDesc",icon);
			alert(t['SSGRP_UNVERIFIED']);
			MandatoryField("Doctor");
		}
	}
	var scodeobj=document.getElementById("OrdStatCode");
	if ((Oobj)&&(scodeobj)&&(scodeobj.value=="E")) {
		//Oobj.disabled = true;
		//Log 60455 Bo 07-08-2006: commented out "MakeFieldReadonly" to check/set the status of readOnly and disabled instead.
		//MakeFieldReadonly("OSTATDesc",icon);
		if (Oobj.readOnly==false) Oobj.disabled=true;
	}
	//if(Oobj) Oobj.onchange();
}
//some fields require data to be submitted (such as status)
//so make readonly with look of disabled
function MakeFieldReadonly(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.readOnly = true;
		fld.disabled = false;
		//fld.style.color = "#909090";
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}
}

function DisablePatLocField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

function AuthDoctorLookUpHandler(txt) {
	var lu = txt.split("^");
    var obj=document.getElementById("AuthDoctorID");
    if (obj) obj.value=lu[1];
}

function isInvalid(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		if (fld.className == "clsInvalid")
		{
			//alert("Invalid Input");
			return false;
		}
	}
	return true;
}

function UpdateStatusCheck(){
	//Log 42231 PeterC 05/02/04 Update Status Check now also checks that end date/time is after start start date/time
	var Oobj=document.getElementById("OSTATDesc");
	var hidObj=document.getElementById("hidStatus");
	var SSObj=document.getElementById("SSGrpUnverified");
	var DObj=document.getElementById("Doctor");

	var SDobj=document.getElementById("OEORISttDat");
	var STobj=document.getElementById("OEORISttTim");
	var EDobj=document.getElementById("OEORIEndDate");
	var ETobj=document.getElementById("OEORIEndTime");

	//if ((Oobj)&&(Oobj.value!="")&&(hidObj)&&(hidObj.value!="")&&(SSObj)&&(SSObj.value=="Y")&&(DObj)&&(DObj.value==""))
	if ((SSObj)&&(SSObj.value=="Y")&&(DObj)&&(DObj.value==""))
	{
		alert(t['SSGRP_UNVERIFIED']);
		return false;
	}

	if((SDobj)&&(SDobj.value!="")&&(EDobj)&&(EDobj.value!="")) {
		if(DateStringCompare(SDobj.value,EDobj.value)==1)
		{
			alert(t['INV_ENDDT']);
			return false;
		}

		else if(DateStringCompare(SDobj.value,EDobj.value)==0) {
			if((STobj)&&(STobj.value!="")&&(ETobj)&&(ETobj.value!="")) {
				if(DateTimeStringCompare(SDobj.value,STobj.value,EDobj.value,ETobj.value)==1)
				{
					alert(t['INV_ENDDT']);
					return false;
				}

				else {return true;}
			}
		}

		else {return true;}
	}
	
	else {
		return true;
	}
	return true;
}

function TempLocChangeHandler(str) {
	//alert(str);
	var lu = str.split("^");
	if ((lu[1]!="")) {
		var obj1=document.getElementById("TempLocID");
		if (obj1) obj1.value = lu[1];
	}
}

function CheckQtyRange(Qobj) {

	var qty=Qobj.value;
	var QtyFrom="";
	var QtyTo="";
	var proceed="";
	if ((typeof curydecimalsym != "undefined") && (curydecimalsym!=".")) {  
		var arrTemp = qty.split(curydecimalsym); 
		qty=arrTemp.join('.');
	}
	if(isNaN(qty)) {
		alert("'"+t['OEORIQty']+ "'"+t['NUMERIC'])
		return false;
	}
	if (qty!="") qty=parseInt(qty);

	var DQobj=document.getElementById("defQtyRange");
	QtyFrom=mPiece(DQobj.value,"^",0);
	QtyTo=mPiece(DQobj.value,"^",1);
	if(QtyFrom!="") parseInt(QtyFrom);
	if(QtyTo!="") parseInt(QtyTo);
	var alertStr1=t['QTYRANGE_1']+QtyFrom+t['QTY_TO']+QtyTo;
	var alertStr2=t['QTYRANGE_2']+QtyFrom;
	var alertStr3=t['QTYRANGE_3']+QtyTo;

	if((QtyFrom!="")&&(QtyTo!="")) {
		if ((QtyFrom>qty)||(qty>QtyTo)) {
			alert(alertStr1);
			return false;
			//proceed=confirm(alertStr1+"\n"+t['CONTINUE']);
			//if (!proceed) return false;
		}
	}

	else if(QtyFrom!="") {
			if (QtyFrom>qty) {
			alert(alertStr2);
			return false;
			//proceed=confirm(alertStr2+"\n"+t['CONTINUE']);
			//if (!proceed) return false;
		}
	}

	else if (QtyTo!="") {
		if (qty>QtyTo) {
			alert(alertStr3);
			return false;
			//proceed=confirm(alertStr3+"\n"+t['CONTINUE']);
			//if (!proceed) return false;
		}
	}
	else { return true; }
	return true;
}

function GetContactDetails(str) {
	var lu=str.split("^");
	//alert("GetContactDetails:"+str);
	var CProv,ContMethod,HospID=""
	if (lu[1]!="") ContMethod=escape(lu[1]);
	var CPObj=document.getElementById("Doctor");
	if((CPObj)&&(CPObj.value!="")) CProv=escape(CPObj.value);
	var CPObj=document.getElementById("CareProv");
	if((CPObj)&&(CPObj.value!="")) CProv=escape(CPObj.value);
	var HObj=document.getElementById("HospID");
	if((HObj)&&(HObj.value!="")) HospID=escape(HObj.value);
	
	var path="oeorder.getcontactdetails.csp?CProv="+CProv+"&ContMethod="+ContMethod+"&HospID="+HospID+"&WINNAME="+window.name;
	websys_createWindow(path,"TRAK_hidden");
	
}

function NotifyClinicianChangeHandler() {
	var CProv,ContMethod,HospID=""
	var NCobj=document.getElementById("NotifyClinician");
	if ((NCobj)&&(NCobj.checked)) {
		ContMethod="NotifyClinician";
		var CPObj=document.getElementById("Doctor");
		if((CPObj)&&(CPObj.value!="")) CProv=escape(CPObj.value);
		var CPObj=document.getElementById("CareProv");
		if((CPObj)&&(CPObj.value!="")) CProv=escape(CPObj.value);
		var HObj=document.getElementById("HospID");
		if((HObj)&&(HObj.value!="")) HospID=escape(HObj.value);
	
		var path="oeorder.getcontactdetails.csp?CProv="+CProv+"&ContMethod="+ContMethod+"&HospID="+HospID+"&WINNAME="+window.name;
		websys_createWindow(path,"TRAK_hidden");
	}
}

//log 59415 TedT 06/2006 if user select inactive status, popup warning
function StatusLookUpHandler(str) {
	var lu = str.split("^");
	var desc=document.getElementById("OSTATDesc");
	var code=document.getElementById("OrdStatCode");
	
	if(lu[1]=="I") {
		alert(t['InvalidStatus']);
		if(desc) desc.value="";
		if(code) code.value="";
	}
	else{
		if(desc) desc.value=lu[0];
		if(code) code.value=lu[1];
	}
}

function DoctorLookUpHandler(txt) {
    var lu = txt.split("^");
    // ab 22.12.04 - 48494
    var obj=document.getElementById("DoctorID");
    if (obj) obj.value=lu[1];
    
	var PCMobj=document.getElementById("PrefConMethod");
	if((PCMobj)&&(PCMobj.value!="")) PCMobj.value="";

	var CDobj=document.getElementById("ContactDetails");
	if((CDobj)&&(CDobj.value!="")) CDobj.value="";
	
}

function AuthCareProvLookUpHandler(txt) {
    var lu = txt.split("^");
    var obj=document.getElementById("AuthDoctorID");
    if (obj) obj.value=lu[8];
}

// ab 22.12.04 - 48494 - lookup and blur handlers added
function CareProvLookUpHandler(txt) {
    var lu = txt.split("^");
    var obj=document.getElementById("DoctorID");
    if (obj) obj.value=lu[8];
	/*log 61419 BoC
	var win=self.parent.frames["orderlist"]
	if (win) {
		var CareProv=win.document.getElementById("CareProv");
		if (CareProv) CareProv.value=lu[0];
	}*/
}

var obj=document.getElementById("Doctor");
if (obj) obj.onblur=DoctorBlurHandler;
var obj=document.getElementById("CareProv");
if (obj) obj.onblur=CareProvBlurHandler;

//Log 56339 PeterC 25/10/05
var obj=document.getElementById("AuthClinician");
if (obj) obj.onblur=AuthClinicianBlurHandler;
var obj=document.getElementById("AuthDoctor");
if (obj) obj.onblur=AuthDoctorBlurHandler;

function AuthClinicianBlurHandler() {
    var obj=document.getElementById("AuthClinician");
    var objID=document.getElementById("AuthDoctorID");
    if ((obj)&&(objID)&&(obj.value=="")) objID.value="";
}

function AuthDoctorBlurHandler() {
    var obj=document.getElementById("AuthDoctor");
    var objID=document.getElementById("AuthDoctorID");
    if ((obj)&&(objID)&&(obj.value=="")) objID.value="";
}

function DoctorBlurHandler() {
    var obj=document.getElementById("Doctor");
    var objID=document.getElementById("DoctorID");
    if ((obj)&&(objID)&&(obj.value=="")) objID.value="";
}
function CareProvBlurHandler() {
    var obj=document.getElementById("CareProv");
    var objID=document.getElementById("DoctorID");
    if ((obj)&&(objID)&&(obj.value=="")) objID.value="";
}

function checkDateForEPR(){
	//alert("PeterC:checkDateForEPR");
	var sobj=document.getElementById("OEORISttDat");
	var AOOERobj=document.getElementById("AllowOrderOutEpisRange");

	if (sobj && (sobj.value!="")) {
		var dobj=document.getElementById("DischDate");
		var aobj=document.getElementById("AdmDate");
		var atime,dtime,stime=""
		var atobj=document.getElementById("AdmTime");
		if ((atobj)&&(atobj.value!="")) atime=atobj.value;
		var dtobj=document.getElementById("DischTime");
		if ((dtobj)&&(dtobj.value!="")) dtime=dtobj.value;
		var stobj=document.getElementById("OEORISttTim");
		if ((stobj)&&(stobj.value!="")) stime=stobj.value;
		if ((!stobj)||((stobj)&&(stobj.value==""))) {
			var htobj=document.getElementById("hidCurrTime");
			if ((htobj)&&(htobj.value!="")) stime=htobj.value;
		}
		if (dobj && (dobj.value!="") && aobj && (aobj.value!="")){
                	var enteredDate = new Date();
			var enteredDate1 = new Date();
			var enteredDate2 = new Date();
			var enteredDate = VerifyDateformat(dobj,dtime);
			var enteredDate1 = VerifyDateformat(sobj,stime);
			var enteredDate2 = VerifyDateformat(aobj,atime);

			if ((enteredDate1>enteredDate) && (AOOERobj) && (AOOERobj.value!="Y")) {
				alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
				sobj.value=""
				if(stobj) stobj.value="";
				return false;
			}

			else if((enteredDate1<enteredDate2) && (AOOERobj) && (AOOERobj.value!="Y")) {
				alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
				sobj.value=""
				if(stobj) stobj.value="";
				return false;
			}

			UpdateFromEPR();
		}else{
			var enteredDate1 = new Date();
			var enteredDate2 = new Date();
			var enteredDate1 = VerifyDateformat(sobj,stime);
			var enteredDate2 = VerifyDateformat(aobj,atime);
			if((enteredDate1<enteredDate2) && (AOOERobj) && (AOOERobj.value!="Y")) {
				var bContinue=1;
				bContinue=confirm(t['STARTDATE_EXCEED']+" "+aobj.value + "\n" + t['CONTINUE']);
				if (!bContinue) {
					sobj.value=""
					if(stobj) stobj.value="";
					return false;
				}
			}
			UpdateFromEPR();
		}
	}
}
var formCust="";
var vodobj=document.getElementById("VarOrdDays");
if(window.opener) var formCust=window.opener.name;
if ((vodobj)&&((formCust=="oeorder_entry")||(formCust=="orderlist"))) vodobj.onclick=VariableOrderDays;
if(!((formCust=="oeorder_entry")||(formCust=="orderlist"))) {
	 if (vodobj) {
		vodobj.disabled=true;
		vodobj.onclick=BlankClickHandler;
	}
}

function BlankClickHandler() {
	return false;
}
function VariableOrderDays() {
		var Frequency="";
		var Duration="";
		var ID="";
		var OEORISttDat="";
		var Quantity="";
		var CTUOMDesc="";
		var OEORISttTim="";

		var VFObj=document.getElementById("Frequency");
		if ((VFObj)&&(VFObj.value!="")) Frequency=VFObj.value;
		var VDObj=document.getElementById("Duration");
		if ((VDObj)&&(VDObj.value!="")) Duration=VDObj.value;
		var IDObj=document.getElementById("ID");
		if ((IDObj)&&(IDObj.value!="")) ID=IDObj.value;
		var STDObj=document.getElementById("OEORISttDat");
		if ((STDObj)&&(STDObj.value!="")) OEORISttDat=STDObj.value;
		var QObj=document.getElementById("OEORIQty");
		if ((QObj)&&(QObj.value!="")) Quantity=QObj.value;
		var CUObj=document.getElementById("CTUOMDesc");
		if ((CUObj)&&(CUObj.value!="")) CTUOMDesc=CUObj.value;
		var DQObj=document.getElementById("OEORIDoseQty");
		if ((DQObj)&&(DQObj.value!="")) Quantity=DQObj.value;

		var FObj=document.getElementById("PHCFRDesc1");
		if ((FObj)&&(FObj.value!="")) Frequency=FObj.value;

		var DObj=document.getElementById("PHCDUDesc1");
		if ((DObj)&&(DObj.value!="")) Duration=DObj.value;

		var RFObj=document.getElementById("RMFrequency");
		if ((RFObj)&&(RFObj.value!="")) Frequency=RFObj.value;

		var RDObj=document.getElementById("RMDuration");
		if ((RDObj)&&(RDObj.value!="")) Duration=RDObj.value;

		var ETDObj=document.getElementById("OEORISttTim");
		if ((ETDObj)&&(ETDObj.value!="")) OEORISttTim=ETDObj.value;

		if((Frequency=="")||(Duration=="")) {
			alert(t['Frequency']+","+t['Duration']+" "+t['XMISSING']);
			return false;
		}

		var url = "oeorder.variableorderdays.csp?Frequency="+Frequency+"&Duration="+Duration+"&ID="+ID+"&OEORISttDat="+OEORISttDat+"&Quantity="+Quantity+"&CTUOMDesc="+CTUOMDesc+"&OEORISttTim="+OEORISttTim;
		//url=escape(url);
		//alert(url);
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
}

var cdtdobj=document.getElementById("ChangeDT");
if (cdtdobj) cdtdobj.onclick=ChangeDTClickHandler;

function ChangeDTClickHandler() {
	var Frequency="";
	var Duration="";
	var RMFrequency="";
	var RMDuration="";
	var DoseQty="";
	var ID="";
	
	var FObj=document.getElementById("PHCFRDesc1");
	if ((FObj)&&(FObj.value!="")) Frequency=FObj.value;

	var DObj=document.getElementById("PHCDUDesc1");
	if ((DObj)&&(DObj.value!="")) Duration=DObj.value;

	var RFObj=document.getElementById("RMFrequency");
	if ((RFObj)&&(RFObj.value!="")) RMFrequency=RFObj.value;

	var RDObj=document.getElementById("RMDuration");
	if ((RDObj)&&(RDObj.value!="")) RMDuration=RDObj.value;

	var IDObj=document.getElementById("ID");
	if ((IDObj)&&(IDObj.value!="")) ID=IDObj.value;

	var DQObj=document.getElementById("OEORIDoseQty");
	if ((DQObj)&&(DQObj.value!="")) DoseQty=DQObj.value;

	var url = "oeorder.dispensetime.csp?Frequency="+Frequency+"&Duration="+Duration+"&ID="+ID+"&RMFrequency="+RMFrequency+"&RMDuration="+RMDuration+"&PatientBanner=1"+"&DoseQty="+DoseQty;
	//alert(url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"DispenseTime","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")

}

var doobj=document.getElementById("Dosing");
if (doobj) doobj.onclick=CalcDoseClickHandler;

function CalcDoseClickHandler() {

	var OEORIItmMastDR="";
	var PatientID="";
	var EpisodeID="";
	var mradm="";
	var CTUOMDesc="";
	var OEORIDoseQty="";
	var PHCFRDesc1="";
	var ID="";
	var HidBSAFormula="";

	var Obj=document.getElementById("OEORIItmMastDR");
	if ((Obj)&&(Obj.value!="")) OEORIItmMastDR=Obj.value;

	var Obj=document.getElementById("PatientID");
	if ((Obj)&&(Obj.value!="")) PatientID=Obj.value;

	var Obj=document.getElementById("EpisodeID");
	if ((Obj)&&(Obj.value!="")) EpisodeID=Obj.value;

	var Obj=document.getElementById("mradm");
	if ((Obj)&&(Obj.value!="")) mradm=Obj.value;

	var Obj=document.getElementById("CTUOMDesc");
	if ((Obj)&&(Obj.value!="")) CTUOMDesc=Obj.value;

	var Obj=document.getElementById("OEORIDoseQty");
	if ((Obj)&&(Obj.value!="")) OEORIDoseQty=Obj.value;

	var Obj=document.getElementById("PHCFRDesc1");
	if ((Obj)&&(Obj.value!="")) PHCFRDesc1=Obj.value;

	var Obj=document.getElementById("FlowQuantity");
	if ((Obj)&&(Obj.value!="")) OEORIDoseQty=Obj.value;

	var Obj=document.getElementById("QuantityUnit");
	if ((Obj)&&(Obj.value!="")) CTUOMDesc=Obj.value;

	var Obj=document.getElementById("HidBSAFormula");
	if ((Obj)&&(Obj.value!="")) HidBSAFormula=Obj.value;

	var url="oeorder.calcdose.csp?OEORIItmMastDR="+OEORIItmMastDR+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&CTUOMDesc="+CTUOMDesc+"&Dose="+OEORIDoseQty+"&PatientBanner=1"+"&Frequency="+PHCFRDesc1+"&HidBSAFormula="+HidBSAFormula;
	//alert(url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"DispenseTime","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")

}

//log60222 TedT
var OEORIItemGroup=document.getElementById("OEORIItemGroup");
if (OEORIItemGroup) OEORIItemGroup.onblur=GroupOnBlur;

//log60222 TedT
function GroupNumberLookupHandler(str) {
	var strArr=str.split("^");
	var grpid=document.getElementById("GRPRowID");
	//log60873 TedT
	var grp=document.getElementById("OEORIItemGroup");
	if (grp) grp.value=strArr[0];
	if(strArr[1]=="EXIST") {
		alert(t['GROUP_EXIST']);
		if (grp) grp.value="";
	}
	else {
		if (grpid) grpid.value=strArr[1];
	}
}
//log60222 TedT
function GroupOnBlur() {
	if(this.value=="") {
		var grpid=document.getElementById("GRPRowID");
		if (grpid) grpid.value="";
	}
}

//log50748 TedT
function populateImage() {
	var imageObj=document.getElementById("images");
	var annotData=document.getElementById("annotData");
	if(!annotData || annotData.value=="") return;
	var annotArr=annotData.value.split("^");
	if(imageObj) {
		imageObj.multiple=false; 
		for(var i=0; i<annotArr.length-1; i++) {
			var val=mPiece(annotArr[i],String.fromCharCode(1),1)+"^"+mPiece(annotArr[i],String.fromCharCode(1),2);
			imageObj.options[imageObj.length] = new Option(mPiece(annotArr[i],String.fromCharCode(1),0),val);
		}
		imageObj.ondblclick=ImageOnclickHandler;
	}
}

function ImageOnclickHandler() {
	var imageObj=document.getElementById("images");
	if (imageObj && imageObj.selectedIndex>=0) {
		var data=imageObj.options[imageObj.selectedIndex].value;
		var filename=mPiece(data,"^",0);
		var picID=mPiece(data,"^",1);
		var patientId=document.getElementById("PatientID");
		var mradm=document.getElementById("mradm");
		var episode=document.getElementById("EpisodeID");
		var ordId=document.getElementById("ID");
		var url="webtrak.annotate.csp?PatientID="+patientId.value+"&mradm="+mradm.value+"&EpisodeID="+episode.value+"&FileName="+filename+"&Temp=.DOC&OrderItemId="+ordId.value+"&MRPicRowId="+picID;
		websys_createWindow(url,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
}

//log60736 TedT
function DisableStatus() {
	var sobj=document.getElementById("OSTATDesc");
	var exe=document.getElementById("exe");
	if (sobj && exe && exe.value==1) {
		sobj.disabled=true;
	}
}

//Log 58325 BoC, delete order if it's fatal message, or clicking cancel if it's warning
function DeleteFatalOrder() {
	var par_win = window.opener;
	if (OrderWindow!="") par_win=window.open('',OrderWindow); 
	if ((OrderWindow!="")&&(par_win)&&(par_win.document.fOEOrder_Custom)) {
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
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(0);
	}
	self.close();
}

//Log 58325 BoC, check pregnant and breastfeeding
function PregnBrFdCheck() {
	var sttDate=document.getElementById("OEORISttDat");
	if (sttDate) sttDate=sttDate.value;
	var endDate=document.getElementById("OEORIEndDate");
	if (endDate) endDate=endDate.value;
	var SttEndDate=sttDate+"*"+endDate
	var epiID=document.getElementById("EpisodeID");
	if (epiID) epiID=epiID.value;
	var arcim=document.getElementById("OEORIItmMastDR");
	if (arcim) arcim=arcim.value;
	var ORIRowID=document.getElementById("ID");
	if (ORIRowID) ORIRowID=ORIRowID.value;
	var duration=document.getElementById("DurFactor");
	if (duration) duration=duration.value;
	//var RMDuration=document.getElementById("DurFactor");
	//if (RMDuration) RMDuration=RMDuration.value;
	var PregnBrFdStr="";
	//alert (arcim+", "+ORIRowID+", "+SttEndDate+", "+epiID+", "+duration);
	PregnBrFdStr=tkMakeServerCall("web.OEOrdItem","PregnBrFd","",arcim,ORIRowID,SttEndDate,epiID,duration);
	if (PregnBrFdStr!="") {
		PregnBrFdStr=unescape(PregnBrFdStr);
		//alert (PregnBrFdStr);
		PregnBrFdStr=PregnBrFdStr.split(String.fromCharCode(1));
		for (i=0;i<PregnBrFdStr.length;i++) {
			var str=PregnBrFdStr[i];
			if (str!="") {
				var PregnBrFdAlert=mPiece(str,"|",0);
				var PregnBrFdAlertType=mPiece(str,"|",1);
				//alert (PregnBrFdAlert+", "+PregnBrFdAlertType);
				if ((PregnBrFdAlert=="B")&&(PregnBrFdAlertType=="W")) {
					if (!confirm(t['BrFdWarn'])) {
						alert(t['WillDeleteOrder']);
						DeleteFatalOrder();
						return false;
					}
				}
				if ((PregnBrFdAlert=="B")&&(PregnBrFdAlertType=="F")) {
					alert (t['BrFdFatal']+"\n"+t['WillDeleteOrder']);
					DeleteFatalOrder();
					return false;
				}
				if ((PregnBrFdAlert=="P")&&(PregnBrFdAlertType=="W")) {
					if (!confirm(t['PregnWarn'])) {
						alert(t['WillDeleteOrder']);
						DeleteFatalOrder();
						return false;
					}
				}
				if ((PregnBrFdAlert=="P")&&(PregnBrFdAlertType=="F")) {
					alert (t['PregnFatal']+"\n"+t['WillDeleteOrder']);
					DeleteFatalOrder();
					return false;
				}
			}
		}
	}
}

//log50748 TedT
populateImage();
DisableStatus();

// LOG 36411 RC 14/11/03 The Receiving Location needs to be mandatory to force people to put data in it otherwise the
// order isn't able to be retrieved properly. Forcing the field to be mandatory in this javascript will make sure users
// can't take off the mandatory attribute of the field and stuff up the order.
var reclocobj=document.getElementById("cCTLOCDesc");
if (reclocobj) reclocobj.className = "clsRequired";

//log 62013 because defalut handler doesn't allow to remove focus
function Float_changehandler() {
	var eSrc=window.event.srcElement;
	if (eSrc) {
		if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
		var isValid=0;
		if (IsValidNumber(eSrc)) {
			isValid=1;
			if (!IsPositiveNumber(eSrc)) isValid=0;
		}
		if (!isValid) {
			eSrc.className='clsInvalid';
		} else {
			eSrc.className=""
		}
	}
}

function IntegerPositive_changehandler() {
	var eSrc=window.event.srcElement;
	if (eSrc) {
		if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
		var isValid=0;
		if (IsValidNumber(eSrc)) {
			isValid=1;
			if (!IsValidInteger(eSrc)) isValid=0;
			if (!IsPositiveNumber(eSrc)) isValid=0;
		}
		if (!isValid) {
			eSrc.className='clsInvalid';
		} else {
			eSrc.className=""
		}
	}
}

//Log 62560 PeterC 09/02/07
function LookUpPatOrderSelect(str) {
	var ID="";
	var LinkID="";
 	var lu = str.split("^");
	LinkID=lu[3];
	var obj=document.getElementById("ID")
	if (obj) ID=obj.value;
	if((ID!="")&&(LinkID!="")&&(ID==LinkID)) {
		alert(t["LINK_ERROR"]);
		var obj=document.getElementById("PatientOrders")
		if (obj) obj.value = ""; 
		return false;
	}
	var obj=document.getElementById("PatientOrders")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("LinkedItmID")
	if (obj) obj.value = lu[3];

}