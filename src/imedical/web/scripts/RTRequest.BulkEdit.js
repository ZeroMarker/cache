// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


var obj=document.getElementById('hiddenTelNo');
if (obj){
		var obj1=document.getElementById('RTREQReqTelNo');
		if (obj1 && obj1.value=="") obj1.value=obj.value;
}
var extobj=document.getElementById('hiddenTelExt');
if (extobj){
		var obj2=document.getElementById('RTREQReqTelExt');
		if (obj2 && obj2.value=="") obj2.value=extobj.value;
}

function ReasLookUpHandler(txt) {
	var adata=txt.split("^");
	var ReasonDesc=adata[0];
	var robj=document.getElementById("READesc");
	if (robj) robj.value=ReasonDesc;
}
function UpdateClickHandler() {
	try{
		CustomUpdate();
	}catch(e){}

	var WarnMsg="";

	WarnMsg=CheckForAllMendatoryFields();
	if (WarnMsg!="") {
		alert(WarnMsg);
		return false;
	}

	var Rtnobj=document.getElementById("ReturnDate");
	if ((Rtnobj)&&(Rtnobj.value!="")) {
		if (DateStringCompareToday(Rtnobj.value)<0) {
			alert(t['INVALID_RTNDATE']);
			return false;
		}
	}

	var AllowToUpdate=true; var dm="";  var tm=""; var rm=""; var rsm=""; var requestm="";
	var frm=document.forms["fRTRequest_BulkEdit"];
	var fr=parent.frames[0];	
	if ((fr)&&(fr.name=="FindBulkRequest")) frm.target="_parent";
	//alert("Reg environment parent.frames[0] = "+fr.name);  // currently FindBulkTrack.

	//AmiN 20 May 2002 Added Date and Time as Mandatory fields.
	var Dateobj=document.getElementById("RTREQDate");
	if ((Dateobj) && (Dateobj.value=="")) {		
		dm=t['DateMandatory'] + "\n";
		AllowToUpdate=false; 
	}
				
	var Timeobj=document.getElementById("RTREQTime");
	if ((Timeobj) && (Timeobj.value=="")) {	
		tm=t['TimeMandatory'] +  "\n";
		AllowToUpdate=false; 
	}
	
	var Requestobj=document.getElementById("CTLOCDesc");
	if ((Requestobj) && (Requestobj.value=="")) {	
		requestm=t['RequestMandatory'] +  "\n";
		AllowToUpdate=false; 
	}

	/* PeterC Log 28688 25/09/2002 make the field reason unmandatory
	var reaObj=document.getElementById("READesc");	
	if ((reaObj) && (reaObj.value=="")) {
		rm=t['ReasonMandatory']+ "\n";
		AllowToUpdate=false; 
	}
	*/

	if (AllowToUpdate) { 
		Update_click();
		return;
	}
	
	if ((dm !="") || (tm !="") || (rm !="") || (requestm !="")){
			alert(dm + tm + rm + rsm + requestm ); 
		}	
}

function ReqLocLookUpHandler(str) {
	var lu = str.split("^");
	var hobj=document.getElementById("HiddenCTLOCDesc");
	if ((objRTREQReqLocDR)&&(objRTREQReqTelNo)) {	
		if (objRTREQReqTelNo) objRTREQReqTelNo.value = lu[8];
	}
	if(hobj) hobj.value=lu[0];
}

function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=DelayUpdateClickHandler;
	if(parent.window) parent.window.document.body.rows="0,*";
	var obj=document.getElementById("CTLOCDesc");
	var hobj=document.getElementById("HiddenCTLOCDesc");
	/* Log 46713 PeterC 06/10/04: No longer need to run the broker
	try{
		if(obj) obj.onchange();
	}catch(e){}
	*/
	try{
		if((obj)&&(obj.innerText!="")) hobj.value=obj.innerText;
	}catch(e){}
}

function BodyUnLoadHandler() {
	if(parent.window) parent.window.document.body.rows="48, *";
}

function CheckForAllMendatoryFields() {
	var AllGetValue="";
	for (var i=0;i<document.fRTRequest_BulkEdit.elements.length;i++) {
		if (document.fRTRequest_BulkEdit.elements[i].id!="") {
			var elemid="c"+document.fRTRequest_BulkEdit.elements[i].id;
			var elemc=document.getElementById(elemid);
			var elem=document.getElementById(document.fRTRequest_BulkEdit.elements[i].id);
			if ((elemc) && (elemc.className=="clsRequired")) {
				if ((elem)&&(elem.value=="")) AllGetValue=AllGetValue+elemc.innerText+":  "+t['XMISSING']+"\n";
			}
			if ((elemc) && (elem) && (elem.className=="clsInvalid")) {
				AllGetValue=AllGetValue+elemc.innerText+":  "+t['XINVALID']+"\n";
			}
		}
	}
	return AllGetValue;
}

function DelayUpdateClickHandler() {
	window.setTimeout("UpdateClickHandler()",200)
}

var objRTREQReqLocDR=document.getElementById('RTREQReqLocDR');
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=DelayUpdateClickHandler;
document.body.onload=BodyLoadHandler;

document.body.onunload=BodyUnLoadHandler;
