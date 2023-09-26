  //DHCLabPanicReportSearch.js
  
var LocId=document.getElementById('LocId');  
var userId=session['LOGON.USERID'];
var loc=session['LOGON.CTLOCID'];
function BodyLoadHandler() {
	var DateFrom=document.getElementById("DateFrom");
	var DateTo=document.getElementById("DateTo");
	LocId.value=loc;
}

  	
function Find()
{   
  Find_click();
}

function BodyUnLoadHandler(){

}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;