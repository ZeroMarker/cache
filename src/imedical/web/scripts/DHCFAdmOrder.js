// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// Code generated automatically on 23/07/2007,17:14:01 - manual changes will be overwritten
var evtTimer;
var evtName;
var doneInit=0;
var focusat=null;
document.body.onload=BodyLoadHandler;
function BodyLoadHandler(){	
	var ArcimDescObj=document.getElementById("ArcimDesc");
	if (ArcimDescObj) ArcimDescObj.onkeydown=ArcimDescObj_keyDown;
	var objadm=document.getElementById('EpisodeID');
	if (objadm){
		EpisodeID=objadm.value;
	}
	var obj1=document.getElementById("TotalAmount");
	var obj2=document.getElementById("PayedAmount");
	var obj3=document.getElementById("NotPayedAmount");
    var getpatFeeInfo=tkMakeServerCall("web.DHCBillInterface","IGetpatFeeInfo",EpisodeID,session['LOGON.USERID']);
    if(getpatFeeInfo!=""){
	    if(obj1) obj1.value=getpatFeeInfo.split("^")[0];
	    if(obj2) obj2.value=getpatFeeInfo.split("^")[1];
	    if(obj3) obj3.value=getpatFeeInfo.split("^")[2];
	}else{
		if(obj1) obj1.value="0.00";
	    if(obj2) obj2.value="0.00";
	    if(obj3) obj3.value="0.00";
	}
	

}
function SearchClick(){
	var EpisodeID='';
	var LongOrd='';
	var ShortOrd='';
	var StartDate='';
	var EndDate='';
	var objadm=document.getElementById('EpisodeID');
	if (objadm){
		EpisodeID=objadm.value;
	}
	var objLFlag=document.getElementById('LongOrd');
	if (objLFlag.checked){
		LongOrd='on';
	}
	var objSFlag=document.getElementById('ShortOrd');
	if (objSFlag.checked){
		ShortOrd='on';
	}
	var objSD=document.getElementById('SearchStartDate');
	if (objSD){
		StartDate=objSD.value;
		//StartDate=TransDate(StartDate,'')
	}
	var objED=document.getElementById('SearchEndDate');
	if (objED){
		EndDate=objED.value;
		//EndDate=TransDate(EndDate,'')
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCFAdmOrder&EpisodeID="+EpisodeID+"&LongOrd="+LongOrd+"&ShortOrd="+ShortOrd+"&SearchStartDate="+StartDate+"&SearchEndDate="+EndDate;
	window.location=lnk;

}
 
function TransDate(Datetem,Format){
	var tkClass='web.DHCDocOrdRecDepPatientList';
  var tkMethod='TransDate';
  var ret=tkMakeServerCall(tkClass,tkMethod,Datetem,Format);
  return ret;
}
function ArcimDescObj_keyDown(e)
{	
	if (event.keyCode==13) {event.keyCode="117"; return false;}
	
	
}
function fDHCFAdmOrder_submit() {
  var msg='';
  if (msg!='') {
    alert(msg);
    websys_setfocus(focusat.name);
    return false;
  } else {
    return true;
  }
}
function InitMe() {
	websys_firstfocus();
	doneInit=1;
	var obj=document.getElementById('Search');
	if (obj){
		
		obj.onclick=SearchClick;
	}

}
function RequiredMsg(itemname,islist) {
 var msg='';
 var req=false;
 try {
  if (!document.getElementById(itemname).disabled) {
    if (islist) req=document.getElementById(itemname).selectedIndex==-1;
    else req=document.getElementById(itemname).value=='';
    if (req) {
      msg+="\'" + t[itemname] + "\' " + t['XMISSING'] + "\n";
      if (focusat==null) focusat=document.getElementById(itemname);
    }
  }
  return msg;
 } catch(e) {return msg;};
}
function RequiredMsgObj(obj,islist) {
 var msg='';
 var req=false;
 try {
  if (!obj.disabled) {
    if (islist) {
      if (typeof obj.tkItemPopulate!='undefined') req=obj.options.length<1;
      else req=obj.selectedIndex==-1;
    } else {
      req=obj.value=='';
    }
    if (req) {
      msg+="\'" + t[obj.id] + "\' " + t['XMISSING'] + "\n";
      if (focusat==null) focusat=obj;
    }
  }
  return msg;
 } catch(e) {return msg;};
}
function ForceChange(itemname) {
 var elem=document.getElementById(itemname);
 if (elem) elem.value=elem.value;
}
//var dtseparator='/';var dtformat='DMY';
var tmseparator=':';
var lu_obj=null;
