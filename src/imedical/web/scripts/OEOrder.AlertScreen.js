// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//log  64353
if (window.opener) window.opener.winAlertScreen=window;
//var AGEForm=document.forms["fOEOrder_AgeSex"];
//var ALGForm=document.forms["fOEOrder_Allergy"];
//var DRGForm=document.forms["fOEOrder_DrugInteractions"];
var MSGForm=document.forms["fOEOrder_OEMessages"];
var QUESForm=document.forms["fOEOrder_Question"];
var DSSForm=document.forms["fOEOrder_DSSMessage"];
var AAForm=document.forms["fOEOrder_AllAlerts"];
//var ordwin=window.open("","oeorder_entry");

//var AlertForm=document.forms["fOEOrder_AlertScreen"];
/*
if (AlertForm) {
	var AFORObj=AlertForm.document.getElementById("OverReason");
	var AFORIDObj=AlertForm.document.getElementById("OverReasonID");
	if (!(AGEForm||ALGForm||DRGForm)) {
		if (AFORObj) AFORObj.style.visibility="hidden";
		var cobj=AlertForm.document.getElementById("cOverReason");
		if (cobj) cobj.style.visibility="hidden";
		var imageobj=AlertForm.document.getElementById("ld491iOverReason");
		if (imageobj) imageobj.style.visibility="hidden";
	}
}
*/
//var uobj=document.getElementById("Update");
//if (uobj) uobj.onclick=submitFormNew;
//if (uobj) uobj.onclick=UpdateClickHandler;
//document.body.onunload=BodyUnloadHandler;

function ValidateQueLenAlert() {
	var msg="";
	var count=1;
	while(true)
	{
		var obj=document.getElementById("QAz"+count);
		var lobj=document.getElementById("lbQAz"+count);
		if((obj)&&(lobj)){
			var temp=obj.value;
			var lengthCurr=temp.length;
			if(lengthCurr>10) {
				msg+="\'" + lobj.innerText + "\' ";
			}

		}
		else if(!obj) break;
		count++;
	}

	if(msg!="") {
		var bConfirm="";
		var MsgToContinue=t['QA']+ msg+t['LEN_EXCEED']+"\n"+t['CONTINUE'];
		bConfirm=confirm(MsgToContinue);
		if (!bConfirm) return false;
		else{return true};
	}
	return true;
}

function submitFormNew() {
	//check that required fields have content.
	var reqFields="";
	var count=1;
	var ReqFLDObj=document.getElementById("ReqFields");
	if (ReqFLDObj) reqFields=ReqFLDObj.value
	//var reqFields="#(ReqFields)#"  //variable taken from cache.
	reqAry=reqFields.split(",");
	for (var i=0;i<reqAry.length;i++) {
		if (document.getElementById(reqAry[i])) {
			if (document.getElementById(reqAry[i]).value=="") {
				msg+="\'" + document.getElementById("lb"+reqAry[i]).innerText + "\' " + t['XMISSING'] + "\r";
  			}
  		}
	}
	var bUnvalidField=false;
	/****
	while(true)
	{
		var obj=document.getElementById("QAz"+count);
		var lobj=document.getElementById("lbQAz"+count);
		if((obj)&&(obj.className=="clsInvalid")){
			bUnvalidField=true;
			if (obj.QUETYPE=="INTPOS") msg+="\n"+lobj.innerText+": "+t['INTPOS'];
			if (obj.QUETYPE=="FLOATPOS") msg+="\n"+lobj.innerText+": "+t['FLOATPOS'];
			if (obj.QUETYPE=="FLOAT") msg+="\n"+lobj.innerText+": "+t['FLOAT'];
			if (obj.QUETYPE=="INT") msg+="\n"+lobj.innerText+": "+t['INT'];
		}
		else if(!obj) break;
		count++;
	}
	******/
	if (QUESForm) msg += AllQuestionsValidate();

	//if (bUnvalidField==true) msg+="\n"+t['ENT_INVALID'];

	/* BM : need not check the reason for allergy, drug interaction and warning type DSS
	var ReasonMsg="";
	if (AAForm) {
		ReasonMsg=CheckAllAlertsReason();
		if (ReasonMsg!="") msg+="\n"+ReasonMsg;
	}
	*/
	
	//Log 44590 Check Reason to override for MaxCumDose Alert 
	var ReasonMsg="";
	if (AAForm) {
		ReasonMsg=CheckMaxCumDoseAlertReason();
		if (ReasonMsg!="") msg+="\n"+ReasonMsg;
	}
	/*
	if (AGEForm) {
		ReasonMsg=CheckAGEReason();
		if (ReasonMsg!="") msg+="\n"+ReasonMsg;
	}
	if (ALGForm) {
		ReasonMsg=CheckALGReason();
		if (ReasonMsg!="") msg+="\n"+ReasonMsg;
	}
	if (DRGForm) {
		ReasonMsg=CheckDRGReason();
		if (ReasonMsg!="") msg+="\n"+ReasonMsg;
	}
	if (DSSForm) {
		ReasonMsg=CheckDSSReason();
		if (ReasonMsg!="") msg+="\n"+ReasonMsg;
	}
	*/

	if (msg!="") {
		alert(msg);
		msg="";
		return false;
	} else {
		//var contAlert=ValidateQueLenAlert();
		//if(!contAlert) return false;

		if (AAForm) SetAAParams();
		//if (DSSForm) SetDSSParams();
		//if (AGEForm) SetAGEParams();
		//if (ALGForm) SetALGParams();
		//if (DRGForm) SetDRGParams();
		if (QUESForm) SetHiddenFields();
		try {
			win.DisableUpdateButton(0);
			//win.DisableOrderDetailsButton(0);
		} catch (e) {
		}
	}
	return true;
}
function SetHiddenFields(){
	//alert("sethidden fields AlertScreen");
	var QUESTABLE=document.getElementById("tOEOrder_Question");
	if (QUESTABLE) {
		for (var i=1; i<QUESTABLE.rows.length; i++) {
			var QAObj=QUESForm.document.getElementById("QAz"+i);
			var RQAObj=QUESForm.document.getElementById("RQAz"+i);
			var AQAObj=QUESForm.document.getElementById("AQAz"+i);
			if ((QAObj)&&(QAObj.type=="checkbox")) {
				if (QAObj.checked==false) QAObj.value="";
			}
			//if (QAObj) alert(QAObj+" RQA "+RQAObj.value)
			if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")&&(!AQAObj)) AddInputS(RQAObj.value,QAObj.value,"")
			if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")&&(AQAObj)) AddInputS(RQAObj.value,QAObj.value,AQAObj.value)
		}
	}
	//document.fOEOrder_Summary.kCounter.value = hidItemCnt;
}
//ANA LOG 25687. Adding new elements to pass in the answers into the update method.
function AddInputS(hidItemCnt,value,mlvalue) {
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	var valARR=value.split(String.fromCharCode(13,10));
	if ((valARR)&&(valARR.length>1)) value=valARR.join("|");
	NewElement.id = 'OEQ' + hidItemCnt;
	NewElement.name = 'OEQ' + hidItemCnt;
	NewElement.value = value;
	//alert(NewElement.value);
	NewElement.type = "HIDDEN";
	document.fOEOrder_AlertScreen.dummy.insertAdjacentElement("afterEnd",NewElement);
	//alert("1 "+NewElement.id+" value "+NewElement.value);
	if (mlvalue!="") {
		//alert(mlvalue);
		var mlArr=mlvalue.split(String.fromCharCode(13,10));
		mlvalue=mlArr.join("|");
		//+" "+mlvalue.split(String.fromCharCode(13,10))
		var NewElement=document.createElement("INPUT");
		NewElement.id = 'AOEQ' + hidItemCnt;
		NewElement.name = 'AOEQ' + hidItemCnt;
		NewElement.value = mlvalue;
		//alert(NewElement.value);
		NewElement.type = "HIDDEN";
		document.fOEOrder_AlertScreen.dummy.insertAdjacentElement("afterEnd",NewElement);
		//alert("2 "+NewElement.id+" value "+NewElement.value);
	}
}
function DeleteAllHiddenItems() {
	for (i=1; i<=hidItemCnt; i++) {
		//var id="'"+"hiddenitem"+hidItemCnt+"'";
		var id="hiddenitem"+hidItemCnt;
		var objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';
	}
	hidItemCnt=0;
}
/*
function UpdateClickHandler(){
	//alert("hello");
	if (AAForm) SetAAParams();
	//if (DSSForm) SetDSSParams();
	//if (ALGForm) SetALGParams();
	//if (DRGForm) SetDRGParams();
	return Update_click();
}
*/
function SelectReasonLookUp(str){
	//alert(str);
	var strArry=str.split("^");
	if (AlertForm&&AFORObj&&AFORIDObj) {
		AFORObj.value=strArry[0];
		AFORIDObj.value=strArry[1];
	}
	if (AAForm) SetSelectedAllAlertsString();
	//if (ALGForm) SetSelectedALGString();
	//if (AGEForm) SetSelectedAGEString();
	//if (DRGForm) SetSelectedDRGString();
	//if (DSSForm) SetSelectedDSSString();
	if (AFORObj&&(AFORIDObj)) {
		AFORObj.value="";
		AFORIDObj.value="";
	}
}
function SelectDSSReasonLookUp(str){
	//alert(str);
	var strArry=str.split("^");
	if (DSSForm) {
		var DSSORObj=DSSForm.document.getElementById("DSSOverReason");
		var DSSORIDObj=DSSForm.document.getElementById("DSSOverReasonID");
		DSSORObj.value=strArry[1];
		DSSORIDObj.value=strArry[2];
	}
	if (DSSForm) SetSelectedDSSString();
}
function SetSelectedALGString() {
	var ALGTable=ALGForm.document.getElementById("tOEOrder_Allergy");
	var flag;
	if (ALGTable) {
		for (var i=1; i<ALGTable.rows.length; i++) {
			var SelObj=ALGForm.document.getElementById("ALGSelectz"+i);
			var arcimObj=ALGForm.document.getElementById("ARCIMRowIdz"+i);
			var oriObj=ALGForm.document.getElementById("ORIRowIDz"+i);
			var ReasObj=ALGForm.document.getElementById("Reasonz"+i);
			var ReasIDObj=ALGForm.document.getElementById("ReasonIDz"+i);
			//if ((SelObj)&&(SelObj.checked)&&(ReasObj)&&(ReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
			if ((ReasObj)&&(ReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
				ReasObj.innerText=AFORObj.value;
				ReasIDObj.value=AFORIDObj.value;
				flag=true;
			}
		}
		if (flag=="") alert("Select an allergy before entering the reason.");
		UnselectALGItems();
	}
}
function CheckALGReason() {
	var ReasonMsg="";
	var ALGTable=ALGForm.document.getElementById("tOEOrder_Allergy");
	if (ALGTable) {
		for (var i=1; i<ALGTable.rows.length; i++) {
			var ReasIDObj=ALGForm.document.getElementById("ReasonIDz"+i);
			if (ReasIDObj.value=="") {
				ReasonMsg=t['AllergyWithoutReason'];
				break;
			}
		}
	}
	return ReasonMsg;
}

function CheckAllAlertsReason() {
	var ReasonMsg="";
	var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
	if (AATable) {
		for (var i=1; i<AATable.rows.length; i++) {
			var ATDRObj=AATable.document.getElementById("AlertTypeDRz"+i);
			var ETObj=AATable.document.getElementById("ErrorTypeDRz"+i);
			var SelObj=AATable.document.getElementById("AlertSelectz"+i);
			var ReaObj=AATable.document.getElementById("Reasonz"+i);
			var ReaDRObj=AATable.document.getElementById("ReasonIDz"+i);
			if ((ATDRObj)&&(ATDRObj.value=="Allergy")&&(SelObj.disabled==false)) {
				if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+="\n"+t['AllergyWithoutReason'];
			} else if ((ATDRObj)&&(ATDRObj.value=="MaxCumDose")&&(SelObj.disabled==false)) {
				if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+="\n"+t['MaxCumDoseWithoutReason'];
			} else if ((ATDRObj)&&(ATDRObj.value=="DSSMessage")&&(ETObj)&&(ETObj.value=="W")&&(SelObj.disabled==false)) {
				if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+="\n"+t['DSSWithoutReason'];
			} else if ((ATDRObj)&&(ATDRObj.value=="DrugInteraction")&&(SelObj.disabled==false)) {
				if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+="\n"+t['DrugInteractionWithoutReason'];
			}
		}
	}
	//alert("in CheckAllAlertsReason :"+ReasonMsg);
	return ReasonMsg;
}
//Log 44590 Check reason to override for MaxCumDose  (Log 47580:) and mendatory alerts
function CheckMaxCumDoseAlertReason() {
	var ReasonMsg="";
	var OrderItemDesc="";
	var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
	if (AATable) {
		for (var i=1; i<AATable.rows.length; i++) {
			var ARCIMDescObj=AATable.document.getElementById("ARCIMDescz"+i);
			var ATDRObj=AATable.document.getElementById("AlertTypeDRz"+i);
			var ETObj=AATable.document.getElementById("ErrorTypeDRz"+i);
			var SelObj=AATable.document.getElementById("AlertSelectz"+i);
			var ReaObj=AATable.document.getElementById("Reasonz"+i);
			var ReaDRObj=AATable.document.getElementById("ReasonIDz"+i);
			var MendatoryObj=AATable.document.getElementById("Mendatoryz"+i);
			var MessageObj=AATable.document.getElementById("Messagez"+i);
			var hiddenMessageObj=AATable.document.getElementById("hiddenMessagez"+i);
			if ((ARCIMDescObj)&&(ARCIMDescObj.innerText!=" ")) {
				OrderItemDesc=ARCIMDescObj.innerText;
			}
			//Log 47621 
			//if ((ATDRObj)&&(ATDRObj.value=="MaxCumDose")&&(SelObj.disabled==false)) { 
			if ((ATDRObj)&&(ATDRObj.value=="MaxCumDose")) { 
				if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+=t['ReasonMandatory']+OrderItemDesc+t['MaxCumDoseWithoutReason']+"\n";
			}
			else if ((MendatoryObj)&&(MendatoryObj.value=="Y")) {
				if ((ATDRObj)&&(ATDRObj.value=="Allergy")&&(hiddenMessageObj)&&(hiddenMessageObj.value!="")) { 
					if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+=t['ReasonMandatory']+OrderItemDesc+t['AllergyWithoutReason']+hiddenMessageObj.value+".\n";
				} else if ((ATDRObj)&&(ATDRObj.value=="DrugInteraction")) { 
					if (ReaDRObj&&(ReaDRObj.value=="")) ReasonMsg+=t['ReasonMandatory']+OrderItemDesc+t['DrugInteractionWithoutReason']+MessageObj.innerText+"\n";
				}
			}
		}
	}
	return ReasonMsg;
}

function UnselectALGItems(){
	var ALGTable=ALGForm.document.getElementById("tOEOrder_Allergy");
	if (ALGTable) {
		for (var i=1; i<ALGTable.rows.length; i++) {
			var SelObj=ALGForm.document.getElementById("ALGSelectz"+i);
			if (SelObj) SelObj.checked=false;
		}
	}
}
function SetSelectedDSSString() {
	var DSSTable=DSSForm.document.getElementById("tOEOrder_DSSMessage");
	var flag;
	if ((DSSForm)&&(DSSTable)) {
		var DSSORObj=DSSForm.document.getElementById("DSSOverReason");
		var DSSORIDObj=DSSForm.document.getElementById("DSSOverReasonID");
		for (var i=1; i<DSSTable.rows.length; i++) {
			//var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			var arcimObj=DSSForm.document.getElementById("DSSARCIMRowIdz"+i);
			var oriObj=DSSForm.document.getElementById("DSSORIRowIdz"+i);
			//var ReasObj=DSSForm.document.getElementById("DSSReasonz"+i);
			var ReasIDObj=DSSForm.document.getElementById("DSSReasonIDz"+i);
			//if ((SelObj)&&(SelObj.checked)&&(ReasObj)&&(ReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
			if ((ReasIDObj)&&(DSSORObj)&&(DSSORObj.value!="")&&(DSSORIDObj)&&(DSSORIDObj.value!="")) {
				//ReasObj.innerText=DSSORObj.value;
				ReasIDObj.value=DSSORIDObj.value;
				flag=true;
			}
		}
		if (flag=="") alert("Select an DSS reason before entering the reason.");
		UnselectDSSItems();
	}
}
function UnselectDSSItems(){
	var DSSTable=DSSForm.document.getElementById("tOEOrder_DSSMessage");
	if (DSSTable) {
		for (var i=1; i<DSSTable.rows.length; i++) {
			var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			if (SelObj) SelObj.checked=false;
		}
	}
}
function SetSelectedAGEString() {
	var AGETable=AGEForm.document.getElementById("tOEOrder_AgeSex");
	var flag=false;
	if (AGETable) {
		for (var i=1; i<AGETable.rows.length; i++) {
			var SelObj=AGEForm.document.getElementById("AGESelectz"+i);
			var arcimObj=AGEForm.document.getElementById("ARCIMRowIdz"+i);
			var oriObj=AGEForm.document.getElementById("ORIRowIDz"+i);
			var AGEReasObj=AGEForm.document.getElementById("Reason1z"+i);
			var AGEReasIDObj=AGEForm.document.getElementById("ReasonID1z"+i);
			//if ((SelObj)&&(SelObj.checked)&&(AGEReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
			if ((AGEReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
				AGEReasObj.innerText=AFORObj.value;
				AGEReasIDObj.value=AFORIDObj.value;
				flag=true;
			}
		}
		if (!flag) alert("Select an Age Sex Restriction before entering the reason.");
		UnselectAGEItems();
	}
}

function SetSelectedAllAlertsString() {
	var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
	var LastOrderRowID="";
	if (AATable) {
		for (var i=1; i<AATable.rows.length; i++) {
			//var SelObj=AAForm.document.getElementById("AlertSelectz"+i);
			var AAReasObj=AAForm.document.getElementById("Reasonz"+i);
			var AAReasIDObj=AAForm.document.getElementById("ReasonIDz"+i);
			var ATDRObj=AAForm.document.getElementById("AlertTypeDRz"+i);
			var ETObj=AAForm.document.getElementById("ErrorTypeDRz"+i);
			var SelObj=AATable.document.getElementById("AlertSelectz"+i);
			var ORIobj=AAForm.document.getElementById("ORIRowIDz"+i);
			if ((SelObj)&&(SelObj.checked)) {
				if (ORIobj) LastOrderRowID=ORIobj.value;
				if ((ATDRObj)&&((ATDRObj.value=="Allergy")||(ATDRObj.value=="MaxCumDose")||((ETObj)&&(ATDRObj.value=="DSSMessage")&&(ETObj.value=="W"))||(ATDRObj.value=="DrugInteraction"))) {
					AAReasObj.innerText=AFORObj.value;
					AAReasIDObj.value=AFORIDObj.value;
					SelObj.checked=false;
				}
				
			} else if ((ORIobj)&&((ORIobj.value=="")||(ORIobj.value==LastOrderRowID))) {
				if ((ATDRObj)&&((ATDRObj.value=="Allergy")||(ATDRObj.value=="MaxCumDose")||((ETObj)&&(ATDRObj.value=="DSSMessage")&&(ETObj.value=="W"))||(ATDRObj.value=="DrugInteraction"))) {
					AAReasObj.innerText=AFORObj.value;
					AAReasIDObj.value=AFORIDObj.value;
					//SelObj.checked=false;
				}
			}
			/*
			if ((ATDRObj)&&(ATDRObj.value=="Allergy")&&(SelObj.checked)) {
				AAReasObj.innerText=AFORObj.value;
				AAReasIDObj.value=AFORIDObj.value;
				SelObj.checked=false;
			} else if ((ATDRObj)&&(ATDRObj.value=="MaxCumDose")&&(SelObj.checked)) {
				AAReasObj.innerText=AFORObj.value;
				AAReasIDObj.value=AFORIDObj.value;
				SelObj.checked=false;
			} else if ((ATDRObj)&&(ETObj)&&(ATDRObj.value=="DSSMessage")&&(ETObj.value=="W")&&(SelObj.checked)) {
				AAReasObj.innerText=AFORObj.value;
				AAReasIDObj.value=AFORIDObj.value;
				SelObj.checked=false;
			} else if ((ATDRObj)&&(ATDRObj.value=="DrugInteraction")&&(SelObj.checked)) {
				AAReasObj.innerText=AFORObj.value;
				AAReasIDObj.value=AFORIDObj.value;
				SelObj.checked=false;
			}
			*/
		}
	}
}

function CheckAGEReason() {
	var ReasonMsg="";
	var AGETable=AGEForm.document.getElementById("tOEOrder_AgeSex");
	if (AGETable) {
		for (var i=1; i<AGETable.rows.length; i++) {
			var AGEReasIDObj=AGEForm.document.getElementById("ReasonID1z"+i);
			if (AGEReasIDObj.value=="") {
				ReasonMsg=t['AgeSexWithoutReason'];
				break;
			}
		}
	}
	return ReasonMsg;
}
function UnselectAGEItems(){
	var AGETable=AGEForm.document.getElementById("tOEOrder_AgeSex");
	if (AGETable) {
		for (var i=1; i<AGETable.rows.length; i++) {
			var SelObj=AGEForm.document.getElementById("AGESelectz"+i);
			if (SelObj) SelObj.checked=false;
		}
	}
}
function SetSelectedDRGString() {
	var DRGTable=DRGForm.document.getElementById("tOEOrder_DrugInteractions");
	var Dflag;
	if (DRGTable) {
		for (var i=1; i<DRGTable.rows.length; i++) {
			var DSelObj=DRGForm.document.getElementById("DRGSelectz"+i);
			var DarcimObj=DRGForm.document.getElementById("DARCIMRowIdz"+i);
			var DoriObj=DRGForm.document.getElementById("DORIRowIDz"+i);
			var DReasObj=DRGForm.document.getElementById("DReasonz"+i);
			var DReasIDObj=DRGForm.document.getElementById("DReasonIDz"+i);
			//if ((DSelObj)&&(DSelObj.checked)&&(DReasObj)&&(DReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
			if ((DReasObj)&&(DReasIDObj)&&(AFORObj)&&(AFORObj.value!="")&&(AFORIDObj)&&(AFORIDObj.value!="")) {
				DReasObj.innerText=AFORObj.value;
				DReasIDObj.value=AFORIDObj.value;
				Dflag=true;
			}
		}
		if (Dflag=="") alert("Select an Drug before entering the reason.");
		UnselectDRGItems();
	}
}
function CheckDRGReason() {
	var ReasonMsg="";
	var DRGTable=DRGForm.document.getElementById("tOEOrder_DrugInteractions");
	if (DRGTable) {
		for (var i=1; i<DRGTable.rows.length; i++) {
			var DReasIDObj=DRGForm.document.getElementById("DReasonIDz"+i);
			if (DReasIDObj.value=="") {
				ReasonMsg=t['DrugInteractionWithoutReason'];
				break;
			}
		}
	}
	return ReasonMsg;
}
function UnselectDRGItems(){
	var DRGTable=DRGForm.document.getElementById("tOEOrder_DrugInteractions");
	if (DRGTable) {
		for (var i=1; i<DRGTable.rows.length; i++) {
			var DSelObj=DRGForm.document.getElementById("DRGSelectz"+i);
			if (DSelObj) DSelObj.checked=false;
		}
	}
}
function SetDSSParams(){
	var DSSTABLE=document.getElementById("tOEOrder_DSSMessage");
	var DSSparams="";
	if (DSSTABLE) {
		for (var i=1; i<DSSTABLE.rows.length; i++) {
			//var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			var arcimObj=DSSForm.document.getElementById("DSSARCIMRowIdz"+i);
			var oriObj=DSSForm.document.getElementById("DSSORIRowIdz"+i);
			//var ReasObj=DSSForm.document.getElementById("DSSReasonz"+i);
			var ReasIDObj=DSSForm.document.getElementById("DSSReasonIDz"+i);
			var ErrObj=DSSForm.document.getElementById("ErrorTypeCodez"+i);
			if ((ReasIDObj)&&(oriObj)&&(oriObj.value!="")&&(ErrObj)&&(ErrObj.value="W")) {
				DSSparams=DSSparams+oriObj.value+"*"+ReasIDObj.value+"^";
			}
		}
		if (AlertForm) {
			var DSSpobj=AlertForm.document.getElementById("DSSParams")
			if (DSSpobj) DSSpobj.value=DSSparams;
		}
	}
}
function SetAAParams(){
	var AATABLE=AAForm.document.getElementById("tOEOrder_AllAlerts");
	var AAparams="";
	var AlertType=""
	var Message="";
	if (AATABLE) {
		for (var i=1; i<AATABLE.rows.length; i++) {
			var oriObj=AAForm.document.getElementById("ORIRowIDz"+i);
			var ReasIDObj=AAForm.document.getElementById("ReasonIDz"+i);
			var AlertTypeObj=AAForm.document.getElementById("AlertTypeDRz"+i);
			var DrugIntCatObj=AAForm.document.getElementById("DrugIntCategoryz"+i);
			if (AlertTypeObj) {
				AlertType=AlertTypeObj.value
				if (AlertType=="DrugInteraction") AlertType=DrugIntCatObj.value;
				if (AlertType!="OEMessage") {
					var MessageObj=AAForm.document.getElementById("Messagez"+i);
					if (MessageObj) Message=MessageObj.innerText
				}
			}
			if ((ReasIDObj)&&(oriObj)&&(oriObj.value!="")) {
				AAparams=AAparams+oriObj.value+"*"+ReasIDObj.value+"*"+AlertType+"*"+Message+"^";
			}
		}
		//alert("params "+AAparams);
		if (AlertForm) {
			var AApobj=AlertForm.document.getElementById("AAParams")
			if (AApobj) AApobj.value=AAparams;
		}
	}
}
function CheckDSSReason() {
	var ReasonMsg="";
	var DSSTable=DSSForm.document.getElementById("tOEOrder_DSSMessage");
	if (DSSTable) {
		for (var i=1; i<DSSTable.rows.length; i++) {
			var DReasIDObj=DSSForm.document.getElementById("DSSReasonIDz"+i);
			var ErrorTypeObj=DSSForm.document.getElementById("ErrorTypeCodez"+i);
			if ((ErrorTypeObj)&&(ErrorTypeObj.value=="W")&&(DReasIDObj.value=="")) {
				ReasonMsg=t['DSSWithoutReason'];
				break;
			}
		}
	}
	return ReasonMsg;
}

function SetALGParams(){
	var ALGTABLE=document.getElementById("tOEOrder_Allergy");
	var ALGparams="";
	if (ALGTABLE) {
		for (var i=1; i<ALGTABLE.rows.length; i++) {
			var SelObj=ALGForm.document.getElementById("ALGSelectz"+i);
			var arcimObj=ALGForm.document.getElementById("ARCIMRowIdz"+i);
			var oriObj=ALGForm.document.getElementById("ORIRowIDz"+i);
			var ReasObj=ALGForm.document.getElementById("Reasonz"+i);
			var ReasIDObj=ALGForm.document.getElementById("ReasonIDz"+i);
			if ((ReasIDObj)&&(oriObj)&&(oriObj.value!="")) {
				ALGparams=ALGparams+oriObj.value+"*"+ReasIDObj.value+"^";
			}
		}
		//if (ALGparams=="") alert(t['Allergy']);
		//alert("params "+params);
		if (AlertForm) {
			var ALGpobj=AlertForm.document.getElementById("ALGParams");
			if (ALGpobj) ALGpobj.value=ALGparams;
			//alert("ALG params "+ALGpobj.value);
		}
	}
}
function SetAGEParams(){
	var AGETABLE=document.getElementById("tOEOrder_AgeSex");
	var AGEparams="";
	//alert(AGETABLE);
	if (AGETABLE) {
		//alert(AGETABLE.rows.length);
		for (var i=1; i<AGETABLE.rows.length; i++) {
			var SelObj=AGEForm.document.getElementById("AGESelectz"+i);
			var arcimObj=AGEForm.document.getElementById("ARCIMRowIdz"+i);
			var oriObj=AGEForm.document.getElementById("ORIRowIDz"+i);
			var ReasObj=AGEForm.document.getElementById("Reason1z"+i);
			var ReasIDObj=AGEForm.document.getElementById("ReasonID1z"+i);
			if ((ReasIDObj)&&(oriObj)&&(oriObj.value!="")) {
				AGEparams=AGEparams+oriObj.value+"*"+ReasIDObj.value+"^";
			}
		}
		if (AlertForm) {
			var AGEpobj=AlertForm.document.getElementById("AGEParams");
			if (AGEpobj) AGEpobj.value=AGEparams;
		}
	}
}
function SetDRGParams(){
	var DRGTABLE=document.getElementById("tOEOrder_DrugInteractions");
	var DRGparams="";
	if (DRGTABLE) {
		for (var i=1; i<DRGTABLE.rows.length; i++) {
			var DSelObj=DRGForm.document.getElementById("DRGSelectz"+i);
			var DarcimObj=DRGForm.document.getElementById("DARCIMRowIdz"+i);
			var DoriObj=DRGForm.document.getElementById("DORIRowIDz"+i);
			var DReasObj=DRGForm.document.getElementById("DReasonz"+i);
			var DReasIDObj=DRGForm.document.getElementById("DReasonIDz"+i);
			if ((DReasIDObj)&&(DoriObj)&&(DoriObj.value!="")) {
				DRGparams=DRGparams+DoriObj.value+"*"+DReasIDObj.value+"^";
			}
		}
		//if (ALGparams=="") alert(t['Allergy']);
		//alert("params "+params);
		if (AlertForm) {
			var DRGpobj=AlertForm.document.getElementById("DRGParams");
			if (DRGpobj) DRGpobj.value=DRGparams;
			//alert("DRG params "+DRGpobj.value);
		}
	}
}
function EnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)) {
		try {
			var key=String.fromCharCode(keycode);
				if (key=="U"){
					PopUpExecAndOrderDetailScreen();
				}
		}
		catch(e) {}
	}

}

function BodyLoadHandler() {
	var bHasWarning=false;
	var bShowReasonLookUp=false;
	//alert("AAForm");
	if (AAForm){
		var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
		cHasErrorORIRowId="";
		
		//log61971 TedT
		var newAry=new Array();
		var newOrders=AAForm.document.getElementById("NewOrders");
		if(newOrders) newAry=newOrders.value.split("^");
		var alertOrders="";
		
		if (AATable) {
			for (var i=1; i<AATable.rows.length; i++) {
				var ATDRObj=AAForm.document.getElementById("AlertTypeDRz"+i);
				var ErrorTypeObj=AAForm.document.getElementById("ErrorTypeDRz"+i);
				var ARCIMobj=AAForm.document.getElementById("ARCIMRowIdz"+i);
				var ORIobj=AAForm.document.getElementById("ORIRowIDz"+i);
				
				//log61971 TedT build alert order string
				if (ORIobj) {
					for(var j=0; j<newAry.length; j++){
						if(newAry[j] && newAry[j].indexOf(ORIobj.value)>=0) {
							alertOrders+=newAry[j]+"^";
							newAry[j]=null;
							break;
						}
					}
				}
				
				//Log 58325 BoC
				var PregnBrFdAlertTypeObj=AAForm.document.getElementById("PregnBrFdAlertTypez"+i);
				if ((ErrorTypeObj)&&(ErrorTypeObj.value=="W")) {
					var bHasError=false;
					for (var j=1; j<AATable.rows.length; j++) {
						var tempORIobj=AAForm.document.getElementById("ORIRowIDz"+j);
						var tempErrorTypeObj=AAForm.document.getElementById("ErrorTypeDRz"+j);
						if ((tempORIobj)&&(tempErrorTypeObj)&&(ORIobj)&&(tempORIobj.value==ORIobj.value)&&(tempErrorTypeObj.value=="E")) {
							bHasError=true;
							break;
						}
					}
					if (!bHasError) bHasWarning=true;
				}
				if ((ErrorTypeObj)&&(ErrorTypeObj.value=="E")) {
					if ((ORIobj)&&(ARCIMobj)) cHasErrorORIRowId=cHasErrorORIRowId+ORIobj.value+"^";
					cHasErrorLabOrder=true;
				} else if ((ATDRObj)&&(ATDRObj.value=="AgeSex")) {
					cHasErrorORIRowId=cHasErrorORIRowId+ORIobj.value+"^";
					cHasErrorLabOrder=true;
				} else if (((ATDRObj)&&(ATDRObj.value=="Pregn")||(ATDRObj.value=="BrFd"))&&((PregnBrFdAlertTypeObj)&&(PregnBrFdAlertTypeObj.value=="F"))) {
					cHasErrorORIRowId=cHasErrorORIRowId+ORIobj.value+"^";
					cHasErrorLabOrder=true;
				}
			}
		}
		//log61971
		var alertObj=AAForm.document.getElementById("alertOrders");
		if (alertObj) alertObj.value=alertOrders;
	}
	//alert("Order that can't be ordered:"+cHasErrorORIRowId);
	if (AAForm) {
		var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
		var SelectCheckBoxShow="";
		var LastORIRowID="";
		var LastRow="";
		if (AATable) {
			for (var i=1; i<AATable.rows.length; i++) {
				SelectCheckBoxShow="";
				var ATDRObj=AAForm.document.getElementById("AlertTypeDRz"+i);
				var ETObj=AAForm.document.getElementById("ErrorTypeDRz"+i);
				var SelObj=AAForm.document.getElementById("AlertSelectz"+i);
				var ORIobj=AAForm.document.getElementById("ORIRowIDz"+i);
				var tempCannotOrder=cHasErrorORIRowId.split(ORIobj.value+"^");
				var SeverityColorObj=AAForm.document.getElementById("SeverityColorz"+i);
				if(SelObj) SelObj.onclick=SelectAllAllertByORIRowIDHandler;
				if ((ATDRObj)&&(ATDRObj.value=="Allergy")&&(tempCannotOrder.length>0)) {
					//if (SelObj) SelObj.disabled=false;
					SelectCheckBoxShow="Y";
					if (SelObj) bShowReasonLookUp=true;
				} else if ((ATDRObj)&&(ATDRObj.value=="MaxCumDose")&&(tempCannotOrder.length>0)) {
					//if (SelObj) SelObj.disabled=false;
					SelectCheckBoxShow="Y";
					if (SelObj) bShowReasonLookUp=true;
				} else if ((ATDRObj)&&(ETObj)&&(ATDRObj.value=="DSSMessage")&&(ETObj.value=="W")&&(tempCannotOrder.length>0)) {
					//if (SelObj) SelObj.disabled=false;
					SelectCheckBoxShow="Y";
					if (SelObj) bShowReasonLookUp=true;
				} else if ((ATDRObj)&&(ATDRObj.value=="DrugInteraction")&&(tempCannotOrder.length>0)) {
					//if (SelObj) SelObj.disabled=false;
					SelectCheckBoxShow="Y";
					if (SelObj) bShowReasonLookUp=true;
				}
				if ((ORIobj)&&(ORIobj.value!="")&&(LastORIRowID!=ORIobj.value)) {
					LastORIRowID=ORIobj.value;
					LastRow=i;
				}
				if (SelectCheckBoxShow=="Y") {
					var LastSelObj=AAForm.document.getElementById("AlertSelectz"+LastRow);
					//PeterC Waiting
					//if (LastSelObj) {LastSelObj.disabled=false;}
				}
				//log 47580
				if (SeverityColorObj) {
					var ColorValue=AAForm.document.getElementById("SeverityColorz"+i).value;
					if  (ColorValue!="") {
						ColorValue=mPiece(ColorValue,"&",1);
						ColorValue="#"+ColorValue;
					}
					//if  (ColorValue!="") alert(i+","+ColorValue);
					for (var CurrentCell=0; CurrentCell<AATable.rows[i].cells.length; CurrentCell++) {
						if (SeverityColorObj.value=="") {
							AATable.rows[i].cells[CurrentCell].style.color="Black";
            			}
            			else {
                			AATable.rows[i].cells[CurrentCell].style.color="Black";
							AATable.rows[i].cells[CurrentCell].bgColor=ColorValue;
                			//AATable.rows[i].cells[CurrentCell].bgColor=SeverityColorObj.value;
            			}
					}
				}
				//PeterC Waiting
				if ((ATDRObj)&&((ATDRObj.value=="Allergy")||(ATDRObj.value=="MaxCumDose")||((ETObj)&&(ATDRObj.value=="DSSMessage")&&(ETObj.value=="W"))||(ATDRObj.value=="DrugInteraction"))) {
					if ((SelectCheckBoxShow=="Y")&&(SelObj)) SelObj.disabled=false;
				}
			}
			
			if (bShowReasonLookUp) {
				var ORObj=AAForm.document.getElementById('OverReason');
				if (ORObj) ORObj.style.visibility='visible';
				var cobj=AAForm.document.getElementById('cOverReason');
				if (cobj) cobj.style.visibility='visible';
				var imageobj=AAForm.document.getElementById('ld1884iOverReason');
				if (imageobj) imageobj.style.visibility='visible';
			}
		}
	}
	//Log 48792 PeterC 17/01/05: Added a monograph link to the alert type column 
	if(AAForm){
		for (var curr_row=1; curr_row<AATable.rows.length; curr_row++) {
			var MonoGraObj=AAForm.document.getElementById("MonoGraphIDz"+curr_row);
			for (var CurrentCell=0; CurrentCell<AATable.rows[curr_row].cells.length; CurrentCell++) {
				var cellID = "";
				if (AATable.rows[curr_row].cells[CurrentCell].children.length) {
					cellID = AATable.rows[curr_row].cells[CurrentCell].children[0].id.split("z");
				}
				if (cellID.length>0) {
					cellID=cellID[0];
					// if NO monograph- remove the link from 'category' field
					if (",AlertType,".indexOf(","+cellID+",")!=-1) {
						var objCategory = AATable.rows[curr_row].cells[CurrentCell].children[0];
                              	if (objCategory) {
                                    	if ((MonoGraObj)&&(MonoGraObj.value=="" )) {
								var objParent = websys_getParentElement(objCategory);
								objParent.innerHTML = objCategory.innerHTML;      
                                    	} else {
                                          	objCategory.onclick = InteractionClick;
                                    	}
						}
                              }     
                        }
			}
		}
	}
	
	try {
		win.DisableUpdateButton(1);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}
	catch (e) {
	}
	var clearreasonobj=document.getElementById("ClearReason");
	if (clearreasonobj) clearreasonobj.onClick=clearreasonobj
	
	var AnswersEnteredObj=document.getElementById("AnswersEntered");
	if ((AnswersEnteredObj)&&(AnswersEnteredObj.value!="")) ShowAnsweredEntered(AnswersEnteredObj.value);
	//ordwin.DisableUpdateButton(1);
	//64353 BoC 18/07/2007
	window.focus();
}

function SelectAllAllertByORIRowIDHandler(evt) {
	
	var RowNum="";
	var OEORIRowID="";
	var Action="";
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	RowNum=eSrcAry[1];
	
	var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
	if (AATable) {
		var SelObj=AAForm.document.getElementById("AlertSelectz"+RowNum);
		var OEORIObj=AAForm.document.getElementById("ORIRowIDz"+RowNum);
		if(OEORIObj) OEORIRowID=OEORIObj.value;
		if(SelObj) {
			if(SelObj.checked) Action="Y";
			else {Action="N"};
		}
		if((RowNum!="")&&(OEORIRowID!="")) {
			for (var i=1; i<AATable.rows.length; i++) {
				var ORIobj=AAForm.document.getElementById("ORIRowIDz"+i);
				var SObj=AAForm.document.getElementById("AlertSelectz"+i);
				if((ORIobj)&&(ORIobj.value==OEORIRowID)&&(SObj)&&(!SObj.disabled)) {
					if (Action=="Y") SObj.checked=true;
					if (Action=="N") SObj.checked=false;
				}
			}
		}
	}
}

function InteractionClick(evt) {
	var tbl = document.getElementById("tOEOrder_AllAlerts");  
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>1) {
		var objIntMonograph=AAForm.elements["MonoGraphIDz"+eSrcAry[1]].value;
		var feature='top=50,left=50,width=750,height=570,scrollbars=yes,resizable=yes';
		var url = "websys.default.csp?WEBSYS.TCOMPONENT=Pharmacy.Interaction&MonoGraphID="+objIntMonograph;
		websys_createWindow(url, 'InteractionMonograph', feature );
	}
	return false;
}

function ShowAnsweredEntered(AnswersEntered) {
	var OATable=document.getElementById("tOEOrder_Question");
	if (OATable) {
		var QAObj="";
		for (var i=1; i<OATable.rows.length; i++) {
			QAObj=document.getElementById("QAz"+i);
			AQAObj=document.getElementById("AQAz"+i);
			if (QAObj) {
				if (QAObj.type=="text") QAObj.value=mPiece(mPiece(AnswersEntered,"^",i-1),"|",0);
				else if (QAObj.type=="checkbox") {
					if (mPiece(mPiece(AnswersEntered,"^",i-1),"|",0)=="on") QAObj.checked=true;
				}
				else if (QAObj.type=="textarea") QAObj.innerText=mPiece(mPiece(AnswersEntered,"^",i-1),"|",0);
				if (AQAObj) {
					if (AQAObj.type=="text") AQAObj.value=mPiece(mPiece(AnswersEntered,"^",i-1),"|",1);
					else if (AQAObj.type=="checkbox") {
					 	if (mPiece(mPiece(AnswersEntered,"^",i-1),"|",1)=="on") AQAObj.checked=true;
					}
					else if (AQAObj.type=="textarea") AQAObj.innerText=mPiece(mPiece(AnswersEntered,"^",i-1),"|",1);
				}
			}
		}
	}
}
function ClearReasonHandler() {
	var LastOrderRowID="";
	var LastOrderSelectRowID="";
	var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
	if (AATable) {
		for (var i=1; i<AATable.rows.length; i++) {
			var AAReasObj=AAForm.document.getElementById("Reasonz"+i);
			var AAReasIDObj=AAForm.document.getElementById("ReasonIDz"+i);
			var ATDRObj=AAForm.document.getElementById("AlertTypeDRz"+i);
			var ETObj=AAForm.document.getElementById("ErrorTypeDRz"+i);
			var SelObj=AATable.document.getElementById("AlertSelectz"+i);
			var ORIobj=AATable.document.getElementById("ORIRowIDz"+i);
			if ((ORIobj)&&(ORIobj.value!="")) LastOrderRowID=ORIobj.value;
			if ((ATDRObj)&&(SelObj.checked)) {
				AAReasObj.innerText="";
				AAReasIDObj.value="";
				SelObj.checked=false;
				if ((ORIobj)&&(ORIobj.value!="")) LastOrderSelectRowID=ORIobj.value
			} else if (LastOrderRowID==LastOrderSelectRowID) {
				AAReasObj.innerText="";
				AAReasIDObj.value="";
			}
		}
	}
}

function CancelClickHandlerDiet() {
	var TWKFLI="";
	var TWKFL="";
	var PatientID="";
	var EpisodeID="";
	var EObj=document.getElementById("EpisodeID");
	if((EObj)&&(EObj.value!="")) EpisodeID=EObj.value;
	var PObj=document.getElementById("PatientID");
	if((PObj)&&(PObj.value!="")) PatientID=PObj.value;
	var objTWKFLI=document.getElementById("TWKFLI");
	if (objTWKFLI) TWKFLI=objTWKFLI.value;
	var objTWKFL=document.getElementById("TWKFL");
	if (objTWKFL) TWKFL=objTWKFL.value;
	
	window.location="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.DietMealOrders&TWKFLI=1"+"&TWKFL="+TWKFL+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1";
	return false;

}

document.body.onload = BodyLoadHandler;
document.body.onkeydown=EnterKey;
var obj=document.getElementById("ClearReason");
if (obj) obj.onclick=ClearReasonHandler;