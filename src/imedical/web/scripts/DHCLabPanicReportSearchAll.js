  //DHCLabPanicReportSearchAll.js
  
var LocId=document.getElementById('LocId');  
var userId=session['LOGON.USERID'];
var loc=session['LOGON.CTLOCID'];
function BodyLoadHandler() {
	var DateFrom=document.getElementById("DateFrom");
	var DateTo=document.getElementById("DateTo");
	LocId.value=loc;
	var obj=document.getElementById('ReqLoc');
	obj.onkeyup=ClearReqLoc;
	//≤È—Ø¿‡–Õ
	var obj=document.getElementById("ReadFlag")
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option("","");
	   obj.options[1]=new Option(t['C'],"C");
	   obj.options[2]=new Option(t['F'],"F");   
	}	
}

  	
function Find()
{   
  Find_click();
}

function ClearReqLoc()
{
	var obj=document.getElementById('getreclocid');
	obj.value="";
}
function getreclocid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getreclocid');
	obj.value=val[1];

}

function BodyUnLoadHandler(){

}
document.body.onload = BodyLoadHandler;
document.body.onunl