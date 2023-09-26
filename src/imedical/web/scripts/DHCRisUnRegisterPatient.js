//DHCRisUnRegisterPatient.JS
//
var HL7Obj;
function BodyLoadHandler()
{
	
	var GetPatientInfoFunction=document.getElementById("GetPatientInfo").value;
   	var GetOrdateFunction=document.getElementById("GetOrdDate").value;
    var paadmrowid=document.getElementById("paadmrowid").value;
    //alert(paadmrowid);
    var orditemrowid=document.getElementById("oeorditemrowid").value;
   // alert(orditemrowid);
    //var GetItemNameFunction=document.getElementById("OrditemName").value;
    var ItemNameInfo=tkMakeServerCall("web.DHCRisCommFunctionEx","getOrderItemDesc",orditemrowid);
    //var ListInfo=ItemNameInfo.split("^");
    document.getElementById("OrditemName").value=ItemNameInfo;
    //document.getElementById("TotalFee").value=ListInfo[1];
	var StudyNoInfo=document.getElementById("PatineStudyNo").value;

   // var GetStudyNoFunction=document.getElementById("StudyNo").value;
    //var StudyNoInfo=cspRunServerMethod(GetStudyNoFunction,orditemrowid);
    document.getElementById("StudyNo").value=StudyNoInfo;
    
    ExecuteDoc=document.getElementById("ExecuteDoc");
    ExecuteDoc.value=session['LOGON.USERCODE'];
    
	var value=cspRunServerMethod(GetPatientInfoFunction,paadmrowid);
	if (value!="")
	{
		var item=value.split("^");
		document.getElementById("name").value=item[0];
		document.getElementById("Sex").value=item[1];
		document.getElementById("RegNo").value=item[2];
	}
	var value=cspRunServerMethod(GetOrdateFunction,orditemrowid);
	document.getElementById("Ordate").value=value;


	var UndoObj=document.getElementById("Undo");
	if (UndoObj)
	{
		UndoObj.onclick=Unregister_click;
	}    
	QueryReason();
	
	var closeObj = document.getElementById("Close");
	if (closeObj)
	{
		closeObj.onclick=closeWindow;
	}
	//ConnectHL7Server();

}
function Unregister_click()
{
  //check password 	
  var usercode=document.getElementById('ExecuteDoc');
  var userpass=document.getElementById('PWD');
  
  var getmethod=document.getElementById('CheckPwd');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  
  var retval=cspRunServerMethod(encmeth,usercode.value,userpass.value)
  
  if (retval=="-1"){alert(t['05']);return;}	
  if (retval=="-2"){alert(t['02']);userpass.value="";websys_setfocus('PWD');return;}	
  if (retval=="-5"){alert(t['05']);return;}		
  //


   
   	var StudyNo=document.getElementById("StudyNo").value;
   	var LocDr=session['LOGON.CTLOCID'];
    var Reason=document.getElementById("CancelReanson").value;
    var totalprice="";    //document.getElementById("TotalFee").value; 
    var Stopobj=document.getElementById("StopOrder");
    var ckStopOrder=0;
    /*if (Stopobj)
    {
	    ckStopOrder=document.getElementById("StopOrder").checked;
    }
    */
    var orditemrowid=document.getElementById("oeorditemrowid").value;
    var str=StudyNo+"^"+Reason+"^"+LocDr+"^"+usercode.value+"^"+totalprice+"^"+ckStopOrder+"^"+orditemrowid;
    //alert(str);
	var value=tkMakeServerCall("web.DHCRisUnRegisterPatient","UnRegisterNow",str);
	//alert(value);
	if (value=="0")
	{
	  
	  alert(t['UnregisterSuccess']);
	  opener.document.getElementById("btnFind").click();
	  closeWindow();
	 
	}
	else if(value=="-10003")
	{
		alert("已做出院结算，不能取消登记!");	
	}
	else
	{
	  alert(t['UnregisterFailure']+" 返回值="+value);
	}
   	var Obj=document.getElementById("Close");
	if (Obj)
	{
		Obj.click();
	}    
	
	  

	
}

function ConnectHL7Server()
{
	if (!HL7Obj)
		HL7Obj = new ActiveXObject("HL7Com.CHL7");	
	HL7Obj.ConnectHL7Server1();
}

function SendMessageToHL7Server(Action)
{
	var PatientName=document.getElementById("name").value;
	var PatientID=document.getElementById("RegNo").value;
	var Sex=document.getElementById("Sex").value;
	var StudyNo=document.getElementById("StudyNo");

	if (HL7Obj)
	  HL7Obj.SendModalityInfo(PatientID,PatientName,"",Sex,StudyNo,"","","","","","","", Action);
	//else 
	//  alert(t['HL7OBJNULL']);
	
}
function GetReanson(Info)
{
	Item=Info.split("^");
   var CancelReasonObj=document.getElementById("CancelReanson");
   CancelReasonObj.value =Item[0];
	
	
}
//查询拒绝原因
function QueryReason()
{
	 var RejectAppBillObj=document.getElementById("Treson");
  
   
    if (RejectAppBillObj)
    {
	   
 		combo("Treson");
		
		//var Info=tkMakeServerCall("web.DHCRisRejectApplication","GetRejectTypeInfo");
        var GetInfoFunction=document.getElementById("GetReson").value;
		var Info=cspRunServerMethod(GetInfoFunction);
    	AddItem("Treson",Info);
    }
}



function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
	} 
}
function closeWindow() 
{ 
     window.opener=null; 
     window.open('', '_self', ''); 
     window.close(); 
} 
document.body.onload = BodyLoadHandler;