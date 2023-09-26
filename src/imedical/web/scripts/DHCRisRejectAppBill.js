//DHCRisRejectAppBill.JS
//
var HL7Obj;
function BodyLoadHandler()
{
	var EpisodeID=document.getElementById("EpisodeID").value;
    var OEOrdItemID=document.getElementById("OEOrdItemID").value;
    var GetPatientInfoFunction=document.getElementById("GetPatientInfo").value;
    var value=cspRunServerMethod(GetPatientInfoFunction,EpisodeID);
	if (value!="")
	{
		var item=value.split("^");
		document.getElementById("PatientName").value=item[0];
		document.getElementById("Sex").value=item[1];
		document.getElementById("RegNo").value=item[2];
	}
	
    
    var GetOrdItemInfoFun=document.getElementById("GetOrdItemInfo").value;
    var value=cspRunServerMethod(GetOrdItemInfoFun,OEOrdItemID);
    if(value!="")
    {
	    var item1=value.split("^");
	    document.getElementById("OrditemName").value=item1[0];
		document.getElementById("AppDate").value=item1[1];
		document.getElementById("AppTime").value=item1[2];
		document.getElementById("ReqDocdr").value=item1[3];
    }
    
    RejectAppDoc=document.getElementById("RejectAppDoc");
    RejectAppDoc.value=session['LOGON.USERCODE'];
    
    var RejectAppBillObj=document.getElementById("RejectAppBill");
	if (RejectAppBillObj)
	{
		RejectAppBillObj.onclick=RejectAppBill_click;
	}    
    
    
}
function RejectAppBill_click()
{
  //check password 	
  var usercode=document.getElementById('RejectAppDoc');
  var userpass=document.getElementById('PWD');
  
  var getmethod=document.getElementById('CheckPwd');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  
  var retval=cspRunServerMethod(encmeth,usercode.value,userpass.value)
  
  if (retval=="-1"){alert(t['05']);return;}	
  if (retval=="-2"){alert(t['02']);userpass.value="";websys_setfocus('PWD');return;}	
  if (retval=="-5"){alert(t['05']);return;}		
  
    var OEOrdItemID=document.getElementById("OEOrdItemID").value;
    var LocDr=session['LOGON.CTLOCID'];
    var usercode=usercode.value;
    var Reason=document.getElementById("Reason").value;
    var EpisodeID=document.getElementById("EpisodeID").value;
    var ReqDocdr=document.getElementById("ReqDocdr").value;
    var Info=OEOrdItemID+"^"+LocDr+"^"+usercode+"^"+Reason+"^"+EpisodeID;
    var SendInfo=Reason+"^"+ReqDocdr;
    
    /*var SendRejAppfun=document.getElementById("SendRejApp").value;
    var value=cspRunServerMethod(SendRejAppfun,SendInfo);
    if (value!="0")
	{
	   alert(t['SendRejFailue']);
	}*/
	
    
    var RejectAppFun=document.getElementById("RejectAppFun").value;
	var value=cspRunServerMethod(RejectAppFun,Info);
	
	if (value=="0")
	{
	   alert(t['RejectAppBillSuccess']);
	}
	else
	{
	   alert(t['RejectAppBillFailure']);
	}
	
}



document.body.onload = BodyLoadHandler;