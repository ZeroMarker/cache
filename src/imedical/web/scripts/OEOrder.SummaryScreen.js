// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var SUMMForm=document.forms["fOEOrder_SummaryScreen"];
var QUESForm=document.forms["fOEOrder_Question"];
var LISTEMRForm=document.forms["fOEOrdItem_ListEMR"];
//var ListEMRtbl=LISTEMRForm.document.getElementById("tOEOrdItem_ListEMR");

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}
//disable update buttons from other components ... do not hide
/*var ListEMRForm=document.forms["fOEOrdItem_ListEMR"];
if (ListEMRForm) {
	var UObj=ListEMRForm.document.getElementById("update1");
	if (UObj) UObj.style.visibility="hidden";
}*/
function DisableUpdateButton(frmObj,btnName) {
	if (frmObj) {
		var arrFormLinks=frmObj.getElementsByTagName("A");
		var UObj=0; var found=0;
		for (var i=0;(i<arrFormLinks.length)&&!found;i++) {
			if (arrFormLinks[i].id == btnName) {UObj=arrFormLinks[i];found=1;}
		}
		if (UObj) {UObj.disabled=true; UObj.onclick=LinkDisable;}
	}
}
DisableUpdateButton(LISTEMRForm,"update1");
DisableUpdateButton(QUESForm,"Update1");

function SaveAnswerEntered() {
	var AnswerEntered="";
	var OATable=document.getElementById("tOEOrder_Question");
	if (OATable) {
		var QAObj="";
		for (var i=1; i<OATable.rows.length; i++) {
			QAObj=document.getElementById("QAz"+i);
			AQAObj=document.getElementById("AQAz"+i);
			if (QAObj) {
				if (QAObj.type=="text") AnswerEntered=AnswerEntered+QAObj.value;
				else if (QAObj.type=="checkbox") AnswerEntered=AnswerEntered+QAObj.value;
				else if (QAObj.type=="textarea") AnswerEntered=AnswerEntered+QAObj.innerText;
				if (AQAObj) {
					if (AQAObj.type=="text") AnswerEntered=AnswerEntered+"|"+AQAObj.value;
					else if (AQAObj.type=="checkbox") AnswerEntered=AnswerEntered+"|"+AQAObj.value;
					else if (AQAObj.type=="textarea") AnswerEntered=AnswerEntered+"|"+AQAObj.innerText;
				}
				AnswerEntered=AnswerEntered+"^";
			}
			else AnswerEntered=AnswerEntered+"^";
		}
	}
	var AnswerEnteredObj=document.getElementById("AnswersEntered");
	if (AnswerEnteredObj) AnswerEnteredObj.value=AnswerEntered;
	//alert(AnswerEntered);
}
function SummUpdateClickHandler() {
	var msg="";
	if (QUESForm) msg += AllQuestionsValidate();
  	if (msg!="") {
		alert(msg);
		return false;
	}
	if (QUESForm) SetQAHiddenFields();
	SaveAnswerEntered();
	return Update_click();
}

function SummDeleteClickHandler() {
	var OEOrdItemIDObj=document.getElementById("OEOrdItemIDs");
	var OrdItems="";
	var NewOrdItems="";
	if (OEOrdItemIDObj) OrdItems=OEOrdItemIDObj.value;
	var OrdLen=OrdItems.split("^").length;
	//alert("original order rowids :"+OrdItems);
	if (LISTEMRForm) {
		//alert("ListEMR form exists: "+LISTEMRForm);
		/*
		//var EMRTable=LISTEMRForm.document.getElementById("tOEOrdItem_ListEMR");
		var EMRTable=LISTEMRForm.document.getElementById("tOEOrdItem_ListEMR");
		alert(EMRTable);
		if (EMRTable) {
			alert("ListEMR table exists");
			for (var i=1; i<EMRTable.rows.length; i++) {
				var SelObj=LISTEMRForm.document.getElementById("SelectItemz"+i);
				alert(i+" : "+SelObj.checked);
				if (SelObj && !(SelObj.checked)) NewOrdItems=NewOrdItems+mPiece(OrdItems,"^",i-1)+"^";
			}
		}
		*/
		var loopCounter=1;
		var SelObj=LISTEMRForm.document.getElementById("SelectItemz"+loopCounter);
		var IDObj=LISTEMRForm.document.getElementById("IDz"+loopCounter);
		while (SelObj) {
			//alert(loopCounter+" : "+SelObj.checked+","+mPiece(OrdItems,"^",OrdLen-loopCounter));
			if (SelObj && !(SelObj.checked)) {
				for (var bm78=0;bm78<OrdLen;bm78++) {
					if (mPiece(mPiece(OrdItems,"^",bm78),"*",1)==IDObj.value) {
						if (mPiece(NewOrdItems,IDObj.value,1)=="") NewOrdItems=NewOrdItems+mPiece(OrdItems,"^",bm78)+"^";
					}
				}
			}
			loopCounter++;
			var SelObj=LISTEMRForm.document.getElementById("SelectItemz"+loopCounter);
			var IDObj=LISTEMRForm.document.getElementById("IDz"+loopCounter);
		}
		
	}
    
	//alert("NewOrdItems="+NewOrdItems);
	if (OEOrdItemIDObj) OEOrdItemIDObj.value=NewOrdItems; 
	var EpisodeID="";
	var eobj=document.getElementById("EpisodeID");
	if (eobj) EpisodeID=eobj.value;
	var mradm="";
	var mobj=document.getElementById("mradm");
	if (mobj) mradm=mobj.value;
	var PatientID="";
	var pobj=document.getElementById("PatientID");
	if (pobj) PatientID=pobj.value;
	//alert("NewOrderItems="+NewOrdItems);
	var TWKFL="";
	var objTWKFL=document.getElementById("TWKFL");
	if (objTWKFL) TWKFL=objTWKFL.value;
	var TWKFLI="";
	var objTWKFLI=document.getElementById("TWKFLI");
	if (objTWKFLI) TWKFLI=objTWKFLI.value;
	var TRELOADID="";
	var objTRELOADID=document.getElementById("TRELOADID");
	if (objTRELOADID) TRELOADID=objTRELOADID.value;
	if (NewOrdItems=="") NewOrdItems="^";
	var url="oeorder.summaryscreen.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&TRELOADID="+TRELOADID+"&EpisodeID="+EpisodeID+"&OEOrdItemIDs="+NewOrdItems+"&mradm="+mradm+"&PatientID="+PatientID;
	//alert("url="+url);
	//alert(url);
	websys_createWindow(url,window.name,"");
}

var obj=document.getElementById("Update");
if (obj) obj.onclick=SummUpdateClickHandler;
var obj=document.getElementById("Delete");
if (obj) obj.onclick=SummDeleteClickHandler;
	
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

function OEOrderSummaryScreen_LoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=SummUpdateClickHandler;
	var AnswersEnteredObj=document.getElementById("AnswersEntered");
	if ((AnswersEnteredObj)&&(AnswersEnteredObj.value!="")) ShowAnsweredEntered(AnswersEnteredObj.value);
}
document.body.onload=OEOrderSummaryScreen_LoadHandler;

function SetQAHiddenFields(){
	var QUESTABLE=document.getElementById("tOEOrder_Question");
	if (QUESTABLE) {
		for (var i=1; i<QUESTABLE.rows.length; i++) {
			var QAObj=document.getElementById("QAz"+i);
			var RQAObj=document.getElementById("RQAz"+i);
			var AQAObj=document.getElementById("AQAz"+i);
			if ((QAObj)&&(QAObj.type=="checkbox")) {
				if (QAObj.checked==false) QAObj.value="";
			}
			//if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")&&(!AQAObj)) AddInputS("OEQ",RQAObj.value,QAObj.value,"");
			//if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")&&(AQAObj)) AddInputS("OEQ",RQAObj.value,QAObj.value,AQAObj.value);
			if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")) {
				SummFormAddInput("OEQ"+RQAObj.value,QAObj.value);
				if ((AQAObj)&&(AQAObj.value!="")) SummFormAddInput("AOEQ"+RQAObj.value,AQAObj.value);
			}
		}
	}
}
function SummFormAddInput(id,value) {
	//alert(id+":"+value);
	var valARR=value.split(String.fromCharCode(13,10));
	if ((valARR)&&(valARR.length>1)) value=valARR.join("|");
	var NewElement=document.createElement("INPUT");
	NewElement.id = id;
	NewElement.name = id;
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	SUMMForm.elements["OEOrdItemIDs"].insertAdjacentElement("afterEnd",NewElement);
}

//ANA LOG 25687. Adding new elements to pass in the answers into the update method.
function AddInputS(id,hidItemCnt,value,mlvalue) {
	//alert(hidItemCnt+"#"+value+"#"+mlvalue);
	var valARR=value.split(String.fromCharCode(13,10));
	if ((valARR)&&(valARR.length>1)) value=valARR.join("|");
	var NewElement=document.createElement("INPUT");
	NewElement.id = id + hidItemCnt;
	NewElement.name = id + hidItemCnt;
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	SUMMForm.elements["OEOrdItemIDs"].insertAdjacentElement("afterEnd",NewElement);
	if (mlvalue!="") {
		var mlArr=mlvalue.split(String.fromCharCode(13,10));
		mlvalue=mlArr.join("|");
		var NewElement=document.createElement("INPUT");
		NewElement.id = 'A'+id + hidItemCnt;
		NewElement.name = 'A'+id + hidItemCnt;
		NewElement.value = mlvalue;
		NewElement.type = "HIDDEN";
		SUMMForm.elements["OEOrdItemIDs"].insertAdjacentElement("afterEnd",NewElement);
	}
}