///DHCLabPanicReport.js

//取血单基本信息
/*
var AppNo=document.getElementById('AppNo');
var Location=document.getElementById('Location');
var LocId=document.getElementById('LocId');
var Debtor=document.getElementById('Debtor');
var PatName=document.getElementById('Name');
var ABO=document.getElementById('ABO');
var RH=document.getElementById('RH');
var TakePackNo=document.getElementById('TakePackNo');
var Remark=document.getElementById('Remark');
*/
//var TakePackList=document.getElementById('TakePackList');

var gUser=session['LOGON.USERID']
var gUsername=session['LOGON.USERNAME']
var gUsercode=session['LOGON.USERCODE']

function BodyLoadHandler() {
	/*
   var obj=document.getElementById('Print');
   if (obj) obj.onclick=Print;
   var obj=document.getElementById('btnTakeList');
   if (obj) obj.onclick=ShowTakeList;
   */
  
}

function BodyUnLoadHandler(){
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;