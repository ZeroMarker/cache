// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var qqForm=document.forms["fOEOrder_Questions"];
//var QUESForm=document.forms["fOEORDER_Questions"];
var QUESForm=document.forms["fOEOrder_Question"];
var AGEForm=document.forms["fOEOrder_AgeSex"];
var ALGForm=document.forms["fOEOrder_Allergy"];
var DRGForm=document.forms["fOEOrder_DrugInteractions"];
var u1obj=document.getElementById("Update1");
if (u1obj) u1obj.onclick=Update1ClickHandler;
document.body.onload=QuestionsOnLoadHandler
function QuestionsOnLoadHandler(){
	var qsaObj=document.getElementById("QCSPFlag")
	var u1obj=document.getElementById("Update1");
	if ((qsaObj)&&(qsaObj.value=="1")) {
		if (u1obj) u1obj.style.visibility = "hidden";
	}
}

//use the AllQuestionsValidate function instead
function ValidateQuestions() {
	var msg="";
	var arrQues=document.getElementById('tOEORDER_Questions').getElementsByTagName('INPUT');
	for (i=0; i<arrQues.length; i++) {
		if (arrQues[i].id.indexOf("QAz")==0) {
			if (arrQues[i].className=="clsInvalid") {
				msg+="\'" + document.getElementById("lb"+arrQues[i].id).innerText + "\' " + t['XINVALID'] + "\n";
  			}
		}
	}
	return msg;
}

//use the AllQuestionsValidate function instead
function ValidateQuestionsLength() {
	var msg="";
	var arrQues=document.getElementById('tOEORDER_Questions').getElementsByTagName('INPUT');
	for (i=0; i<arrQues.length; i++) {
		if (arrQues[i].id.indexOf("QAz")==0) {
			var temp=arrQues[i].value;
			var lengthCurr=temp.length;
			if(lengthCurr>10) {
				msg+="\'" + document.getElementById("lb"+arrQues[i].id).innerText + "\' ";
			}
		}
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

function AllQuestionsValidate() {
	var msg=""; var lenmsg="";
	var tbl=document.getElementById('tOEOrder_Question');
	if (tbl) {
	  var arrTextAreaQues=tbl.getElementsByTagName('TEXTAREA');
	  for (i=0; i<arrTextAreaQues.length; i++) {
	  	if (arrTextAreaQues[i].id.indexOf("QAz")==0) {
			var queObj = document.getElementById("lb"+arrTextAreaQues[i].id);
			var quedesc = queObj.innerText;
			if ((queObj.className=="clsRequired")&&(arrTextAreaQues[i].value=="")) {
				msg += "\'" + quedesc + "\' " + t['XMISSING'] + "\n";
			}
		}
	  }
	  var arrQues=tbl.getElementsByTagName('INPUT');
	  for (i=0; i<arrQues.length; i++) {
		if (arrQues[i].id.indexOf("QAz")==0) {
			var queObj = document.getElementById("lb"+arrQues[i].id);
			var quedesc = queObj.innerText;
			if (arrQues[i].className=="clsInvalid") {
				if (arrQues[i].QUETYPE) {
					switch (arrQues[i].QUETYPE) {
						case "INTPOS": msg += "\'" + quedesc + "\' " + t['INTPOSInvalid'] + "\n";
							break;
						case "FLOATPOS": msg+="\'" + quedesc + "\' " + t['FLOATPOSInvalid'] + "\n";
							break;
						case "FLOAT": msg+="\'" + quedesc + "\' " + t['FLOATInvalid'] + "\n";
							break;
						case "INT": msg += "\'" + quedesc + "\' " + t['INTInvalid'] + "\n";
							break;
						case "DATE": msg += "\'" + quedesc + "\' " + t['XDATE'] + "\n";
							break;
						case "TIME": msg += "\'" + quedesc + "\' " + t['XTIME'] + "\n";
							break;
						default : msg += "\'" + quedesc + "\' " + t['XINVALID'] + "\n";
							break;
					}
				} else {
					msg+="\'" + quedesc + "\' " + t['XINVALID'] + "\n";
				}
  			} else if ((queObj.className=="clsRequired")&&(arrQues[i].value=="")) {
				msg += "\'" + quedesc + "\' " + t['XMISSING'] + "\n";
			} else if (arrQues[i].value.length > 220) {
				lenmsg += "\'" + quedesc + "\'\n ";
			}
		}
	  }
	}
	if (lenmsg!="") {
		lenmsg = t['QA'] +"\n"+ lenmsg + t['LEN_EXCEED'];
		if (!confirm(lenmsg + t['CONTINUE'])) {
			msg += lenmsg;
		}
	}
	return msg;
}

function Update1ClickHandler() {
	//check that required fields have content.
	alert("hello ")
	var reqFields=""; var msg="";
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
	var cont=ValidateQuestionsLength();
	if(!cont) return false;
	msg += ValidateQuestions();
  	if (msg!="") {
		alert(msg);
		msg="";
	} else {
		if (AGEForm) SetAGEParams();
		if (ALGForm) SetALGParams();
		if (DRGForm) SetDRGParams();
		if (QUESForm) QuesSetHiddenFields();		
		//frm.submit();
		return Update1_click();
	}
}	
function QuesSetHiddenFields(){
	//alert("sethidden fields ");
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
			if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")&&(!AQAObj)) QuesAddInputS(RQAObj.value,QAObj.value,"")
			if ((QAObj)&&(RQAObj)&&(RQAObj.value!="")&&(AQAObj)) QuesAddInputS(RQAObj.value,QAObj.value,AQAObj.value)			
		}
	}
	//document.fOEOrder_Summary.kCounter.value = hidItemCnt;	
}
//ANA LOG XXX. Adding new elements to pass in the answers into the update method.
function QuesAddInputS(hidItemCnt,value,mlvalue) {
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
	document.fOEOrder_Question.dummy.insertAdjacentElement("afterEnd",NewElement);	
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
		document.fOEOrder_Question.dummy.insertAdjacentElement("afterEnd",NewElement);	
		//alert("2 "+NewElement.id+" value "+NewElement.value);		
	}
}
function QuesDeleteAllHiddenItems() {
	for (i=1; i<=hidItemCnt; i++) {
		//var id="'"+"hiddenitem"+hidItemCnt+"'";
		var id="hiddenitem"+hidItemCnt;
		var objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';		
	}
	hidItemCnt=0;
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
function DeleteAllHiddenItems() {
	for (i=1; i<=hidItemCnt; i++) {
		//var id="'"+"hiddenitem"+hidItemCnt+"'";
		var id="hiddenitem"+hidItemCnt;
		var objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';		
	}
	hidItemCnt=0;
}


function DummyLookUpHandler(qid,evt){
	if (!evt) evt=window.event;
	var arrQID=qid.split("z");
	var row=arrQID[1];
	var obj=document.getElementById("selvals"+row);
	if (obj) document.getElementById("LookUpItemList").value=obj.value;
	obj=document.getElementById("QAz"+row);
	if (obj) document.getElementById("LookUpItemIDAndVal").value=qid+"^"+obj.value;
	DummyLookUp_lookuphandler(evt);
}
function DummyLookUpSelectHandler(txt) {
	var adata=txt.split("^");
	document.getElementById("LookUpItemList").value="";
	document.getElementById("LookUpItemIDAndVal").value="";
	var obj=""; var obj1="";
	var desc = adata[0];
	var qid = adata[1];
	if (qid!="") obj=document.getElementById(qid);
	if (obj) obj.value=desc;
	obj1=document.getElementById("A"+qid);
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.disabled)) obj1.disabled=false;
	if (qid){
		var Eobj=document.getElementById(qid);
		if((Eobj)&&(Eobj.value!="")) {
			var returntext=DummyBrokerChangeHandler(qid);
			if (returntext!="") {
				Eobj.value=returntext;
				Eobj.className="clsValid";
				//alert("Eobj.tabIndex="+Eobj.tabIndex);
				var nextTabIndex=0;
				if (Eobj) nextTabIndex=Eobj.tabIndex+1;
				if (nextTabIndex>0) var nextEobj=document.getElementById("QAz"+nextTabIndex);
				if (nextEobj) nextEobj.focus();
				else Eobj.focus();
			}
			if (returntext=="") {
				Eobj.className="clsInvalid";
				Eobj.focus();
			}
		} else{
			if(Eobj) Eobj.className="clsValid";
		}
	}
}
function DummyLookUpChangeHandler(e) {
	var obj1="";
	var Fld=websys_getSrcElement(e);
	if ((Fld)&&(Fld.value=="")&&(Fld.id!="")) obj1=document.getElementById("A"+Fld.id);
	if (obj1) {
		obj1.innerText="";
		obj1.disabled=true;
	}
	var ElemID=Fld.id;
	
	if(ElemID){
		var Eobj=document.getElementById(ElemID);
		if((Eobj)&&(Eobj.value!="")){
			var returntext=DummyBrokerChangeHandler(ElemID);
			if (returntext!="") {
				Eobj.value=returntext;
				Eobj.className="clsValid";
			}
			if (returntext=="") Eobj.className="clsInvalid";
		}
		else{
			if(Eobj) Eobj.className="clsValid";
		}
	}
}

//Log 64900 PeterC 19/09/07
function DummyInteger_changehandler(e) {
	var obj1="";
	var Fld=websys_getSrcElement(e);
	if ((Fld)&&(Fld.value!="")&&(Fld.id!="")) obj1=document.getElementById(Fld.id);
	if (obj1) {
		if (isNaN(obj1.value)) obj1.className="clsInvalid";
		else {obj1.className="clsValid";}
	}	
}


function DummyBrokerChangeHandler(ElemID){
	
	var returntext,desc,items="";
	QueObj=document.getElementById(ElemID);
	QueObj1=document.getElementById("A"+ElemID);
	var Eobj=document.getElementById(ElemID);
	if(Eobj) desc=Eobj.value;
	var iid=ElemID.split("z");
	var obj=document.getElementById("selvals"+iid[1])
	if(obj) items=obj.value;
	var CommaArr=items.split(",");
	var count=0;
	for (i=0;i<CommaArr.length;i++)
	{
		var tempstr=CommaArr[i];
		tempstr=tempstr.toLowerCase();
		tempstr=Trim(tempstr);
		desc=desc.toLowerCase();
		desc=Trim(desc);

		if(tempstr==desc)
		{
			returntext=CommaArr[i];
			//Log 49604 PeterC 21/02/05
			if ((QueObj)&&(QueObj.value!="")&&(QueObj1)&&(QueObj1.disabled)) QueObj1.disabled=false;
			return returntext;
		}
		if(tempstr.indexOf(desc)==0){
			count++;
			returntext=CommaArr[i];
		}
	}
	//Log 49604 PeterC 21/02/05
	if(count==1) {
		if ((QueObj)&&(QueObj.value!="")&&(QueObj1)&&(QueObj1.disabled)) QueObj1.disabled=false;
 		return returntext;

	}
	else	return "";
}

function Trim(str)
{
	reTrim=/\s+$|^\s+/g;
   	return str.replace(reTrim,"");
}