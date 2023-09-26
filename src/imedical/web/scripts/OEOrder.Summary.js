// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var AGEForm=document.forms["fOEOrder_AgeSex"];
var ALGForm=document.forms["fOEOrder_Allergy"];
var MSGForm=document.forms["fOEOrder_OEMessages"];
var DRGForm=document.forms["fOEOrder_DrugInteractions"];
var QUESForm=document.forms["fOEORDER_Questions"];	
var DSSForm=document.forms["fOEOrder_DSSMessage"];	
var SUMMForm=document.forms["fOEOrder_Summary"];	

var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=submitFormNew;
//if (uobj) uobj.onclick=UpdateClickHandler;
//document.body.onunload=BodyUnloadHandler;
function submitFormNew() {
	//alert("here we are");
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

	while(true)
	{
		var obj=document.getElementById("QAz"+count);
		if((obj)&&(obj.className=="clsInvalid")){
			msg+="\n"+t['ENT_INVALID'];
			break;
		}
		else if(!obj) break;
		count++;

	}
	
  	if (msg!="") {
		alert(msg);
		msg="";
	} else {
		if (DSSForm) SetDSSParams();
		if (AGEForm) SetAGEParams();
		if (ALGForm) SetALGParams();
		if (DRGForm) SetDRGParams();
		//alert("QUESForm "+QUESForm);
		if (QUESForm) SetHiddenFields();		
		return Update_click();
	}
}
function SetHiddenFields(){
	//alert("sethidden fields Summary");
	var QUESTABLE=document.getElementById("tOEORDER_Questions");
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
	alert(hidItemCnt+"#"+value+"#"+mlvalue);
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
	document.fOEOrder_Summary.dummy.insertAdjacentElement("afterEnd",NewElement);	
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
		document.fOEOrder_Summary.dummy.insertAdjacentElement("afterEnd",NewElement);	
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
function UpdateClickHandler(){
	//alert("hello");
	if (DSSForm) SetDSSParams();
	if (ALGForm) SetALGParams();
	if (DRGForm) SetDRGParams();
	return Update_click();
}

function SetDSSParams(){
	var DSSTABLE=document.getElementById("tOEOrder_DSSMessage");
	var DSSparams="";
	if (DSSTABLE) {
		for (var i=1; i<DSSTABLE.rows.length; i++) {
			var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			var arcimObj=DSSForm.document.getElementById("DSSARCIMRowIdz"+i);
			var oriObj=DSSForm.document.getElementById("DSSORIRowIdz"+i);
			var ReasObj=DSSForm.document.getElementById("DSSReasonz"+i);
			var ReasIDObj=DSSForm.document.getElementById("DSSReasonIDz"+i);
			var ErrObj=DSSForm.document.getElementById("ErrorTypeCodez"+i);
			if ((ReasIDObj)&&(oriObj)&&(oriObj.value!="")&&(ErrObj)&&(ErrObj.value!="I")) {
				DSSparams=DSSparams+oriObj.value+"*"+ReasIDObj.value+"^";
			}	
		}
		//if (DSSparams=="") alert(t['Warning']);
		//alert("params "+DSSparams);
		if (SUMMForm) {
			var DSSpobj=SUMMForm.document.getElementById("DSSParams")
			if (DSSpobj) DSSpobj.value=DSSparams;
			//alert("DSS params "+DSSpobj.value);
		}
	}
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
		if (SUMMForm) {
			var ALGpobj=SUMMForm.document.getElementById("ALGParams");
			if (ALGpobj) ALGpobj.value=ALGparams;
			//alert("ALG params "+ALGpobj.value);
		}
	}
}
function SetAGEParams(){
	var AGETABLE=document.getElementById("tOEOrder_AgeSex");
	var AGEparams="";
	if (AGETABLE) {
		for (var i=1; i<AGETABLE.rows.length; i++) {
			var SelObj=AGEForm.document.getElementById("AGESelectz"+i);
			var arcimObj=AGEForm.document.getElementById("ARCIMRowIdz"+i);
			var oriObj=AGEForm.document.getElementById("ORIRowIDz"+i);
			var ReasObj=AGEForm.document.getElementById("Reasonz"+i);
			var ReasIDObj=AGEForm.document.getElementById("ReasonIDz"+i);
			if ((ReasIDObj)&&(oriObj)&&(oriObj.value!="")) {
				AGEparams=AGEparams+oriObj.value+"*"+ReasIDObj.value+"^";
			}	
		}
		if (SUMMForm) {
			var AGEpobj=SUMMForm.document.getElementById("AGEParams");
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
		if (SUMMForm) {
			var DRGpobj=SUMMForm.document.getElementById("DRGParams");
			if (DRGpobj) DRGpobj.value=DRGparams;
			//alert("DRG params "+DRGpobj.value);
		}
	}
}
//function BodyUnloadHandler(){
	//	UpdateClickHandler();
//}

function EnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)) {
		try {	
			var key=String.fromCharCode(keycode);
				if (key=="U"){
					submitFormNew();
				}
		}
		catch(e) {}
	}
	
}

document.body.onkeydown=EnterKey;
