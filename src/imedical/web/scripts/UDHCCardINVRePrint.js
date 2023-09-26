////UDHCCardINVRePrint.js


var GUser
var AllExecute
var ExeFlag				///
var RebillFlag
var PartRefFlag;
var m_AbortPop=0;
var m_RefundPop=0;
var PrtXMLName;

var m_SelectCardTypeRowID="";
var m_CCMRowID="";
var m_CardINVPrtXMLName="";


function BodyLoadHandler()
{
	var obj=document.getElementById("PayMode");
   	if (obj){
	   obj.size=1;
	   obj.multiple=false;
	}
	DHCWebD_ClearAllListA("PayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var myGroupID=session['LOGON.GROUPID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode", myGroupID);
	}
	
	var obj=document.getElementById("CardTypeDefine");
   	if (obj){
	   obj.size=1;
	   obj.multiple=false;
	   obj.disabled=true;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
	var obj=document.getElementById("CardTypeDefine");
	if (obj){
		obj.onchange=CardTypeDefine_OnChange;
	}
   	var obj=document.getElementById("OldReceipNO");
   	if (obj) obj.onkeydown=OldReceipNO_KeyDown;
   	
   	DHCWeb_DisBtnA("RePrint");
   	DHCWeb_DisBtnA("ParkRePrint");
   	obj=document.getElementById("Refresh");
   	if (obj) obj.onclick=RefundClear_Click;
   	
   	CardTypeDefine_OnChange();
   	
	///ReadINVInfo();
	DHCWeb_setfocus("OldReceipNO");
	document.onkeydown = DHCWeb_EStopSpaceKey;
}

function CardTypeDefine_OnChange()
{
	m_SelectCardTypeRowID="";
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	
	if (myCardTypeDR=="")
	{
		return;
	}
	
	///
	if (myary[3]=="C"){
		GetReceiptNo();
	}
	
	m_CCMRowID=myary[14];
	
	m_SetCardReferFlag=myary[21];
	
	m_CardINVPrtXMLName=myary[25];
	/// First Page Print
	m_PatPageXMLName=myary[26];
	
}

function INVQuery_Click(){
	///   DHCOPINV.Query
	QueryInv();
	
}

function ReadCardQuery_OnClick(){
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			///var obj=document.getElementById("PatientID");
			///obj.value=myary[5];
			ReadCardQueryINV(myary[5]);
			///ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			alert(t["-201"]);
			///var obj=document.getElementById("PatientID");
			///obj.value=myary[5];
			///ReadPatInfo();
			break;
		default:
			///alert("");
	}
}

function RefundClear_Click()
{
	//
	var ref="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardINVRePrint";
	location.href=ref;
	
}

function OldReceipNO_KeyDown(e)
{  
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) 
	{
	   	var No=obj.value;
	   	var encmeth=DHCWebD_GetObjValue("ReadINVInfoEncrypt");
	   	if (encmeth!=""){
		   	var myrtninfo=cspRunServerMethod(encmeth,No,"")
		   	var myary=myrtninfo.split(String.fromCharCode(1));
		   	if (myary[0]=="0"){
		   		DHCDOM_SetDOCItemValueByXML(myary[1]);
		   		
		   		CardTypeDefine_OnChange();
		   		var mySpecAry=myary[2].split("^");
		   		
		   		var myobj=document.getElementById("RePrint");
		   		if (myobj){
			   		myobj.disabled=false;
			   		myobj.onclick=RePrint_Click;
		   		}
		   		
			   	DHCWeb_DisBtnA("RePrint");
			   	DHCWeb_DisBtnA("ParkRePrint");
		   		////myHandRepDR_"^"_myPRTUser
		   		if ((mySpecAry[0]=="")&&(mySpecAry[1]==session['LOGON.USERID'])){
			   		var myobj=document.getElementById("ParkRePrint");
			   		if (myobj){
				   		myobj.disabled=false;
				   		myobj.onclick=ParkRePrint_Click;
				   		websys_setfocus("ParkRePrint");
			   		}
		   		}else{
			   		
		   		}
		   		
		   		
		   	}else{
			   	DHCWeb_DisBtnA("RePrint");
			   	DHCWeb_DisBtnA("ParkRePrint");
				alert(t['06']);   ////
				websys_setfocus('ReceipNO');
				return websys_cancel();
		   	}
	   	}
	}
}


function ParkRePrint_Click()
{
   	var aobj=document.getElementById("ParkRePrint");
   	if (aobj){
   		DHCWeb_DisBtn(aobj);
   	}
   	
	var rtn=RefundSaveInfo("A");
   	
   	var aobj=document.getElementById("ParkRePrint");
	if ((rtn==false)&&(aobj)){
   		//DHCWeb_DisBtn(aobj);
		aobj.disabled=false;
		aobj.onclick=Abort_Click;
	}
}

function RePrint_Click()
{
	////RePrint
	DHCWeb_DisBtnA("RePrint");
	var myOldRowID=DHCWebD_GetObjValue("CardINVRowID");
	
	PatRegPatInfoPrint(myOldRowID,m_CardINVPrtXMLName,"ReadCardINVEncrypt");
	var myobj=document.getElementById("RePrint");
	if (myobj){
		myobj.disabled=false;
		myobj.onclick=RePrint_Click;
	}
	
}


function RefundSaveInfo(RefundFlag){
	////
	var rtn=CheckRefund(RefundFlag);
	if (rtn==false){
		return rtn;
	}
	
	////Connection YB for Park Fair
	var recobj=document.getElementById("CardINVRowID");
	if (recobj){
		var ReceipRowid=recobj.value;
	}
	var myUser=session['LOGON.USERID'];
	var gloc=session['LOGON.GROUPID'];

	var myCardINVInfo=GetCardINVInfo();
	
	////INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	var encmeth=DHCWebD_GetObjValue("ParkRePrtEncrypt");
	
	var myUserLocID=session['LOGON.CTLOCID'];
	var myPAMPRID=DHCWebD_GetObjValue("PAPMIRowID");
	if (myPAMPRID==""){
		
	}else
	{
	}
	var myCardRowID=DHCWebD_GetObjValue("CardRowID");
	
	//alert(ReceipRowid +",  " +myUser+",   " +myCardINVInfo);
	///return;
	var myExpStr="";
	
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,myCardINVInfo,m_SelectCardTypeRowID, RefundFlag, myCardRowID, myExpStr);
	var myary=rtnvalue.split(String.fromCharCode(1))
	
	if (myary[0]=='0')
	{
		////Add YB InterFace   &&(myPRTRowID!="")
		var myPRTRowID="";
		///
		///if (myary[1]=="0"){
		PatRegPatInfoPrint(myary[1],m_CardINVPrtXMLName,"ReadCardINVEncrypt");
		
		alert(t['07']);		/////
		return true;
	}else{
		switch(rtn[0]){
			case 101:
				alert(t['08']);   ////
			default:
				alert(t['09']+rtn[0]);	  /////
		}
		return false;	
	}
}

function GetCardINVInfo()
{
	var myxml="";
	var myparseinfo = DHCWebD_GetObjValue("InitCardINVPRTEntity");
	var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo);
	
	return myxml;
}


function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName)
{
	///1, RowID String
	///2. CurPrtXMLName
	///3. Encrypt Item
	if (CurXMLName==""){
		return;
	}
	var INVtmp=RowIDStr.split("^");
	///
	///INVstr
	if (INVtmp.length>0)
	{
		DHCP_GetXMLConfig("InvPrintEncrypt",CurXMLName);
	}
	
	for (var invi=0;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var encmeth=DHCWebD_GetObjValue(EncryptItemName);
			
			///var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			///alert(CurXMLName+"   " +INVtmp[invi]+", "+ Guser+ ",  "+  myExpStr);
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",CurXMLName,INVtmp[invi], Guser, myExpStr);
		}
	}
	
}

function InvPrintNew(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}


function CheckRefund(RefundFlag){
	var myReceipNO=DHCWebD_GetObjValue("ReceipNO");
	if (myReceipNO!=""){
		alert(t["BackINVTip"]);
		return false;
	}
	
	return true;
}

function GetReceiptNo(){
	//
	var receipNOobj=document.getElementById('GetreceipNO');
	if (receipNOobj) {var encmeth=receipNOobj.value} else {var encmeth=''};
	var Guser=session['LOGON.USERID'];
	var myPINVFlag="Y";
	var myExpStr=session['LOGON.USERID'] +"^"+myPINVFlag;
	///
	
	if (cspRunServerMethod(encmeth,"SetReceipNO","", Guser, m_SelectCardTypeRowID, myExpStr)!='0')
	{
		alert(t['05'])
		//
		return
	}	
}

function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	var obj=document.getElementById("ReceiptNO");
	if (obj){
		obj.value=ls_ReceipNo;
	}
	DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
	///change the Txt Color
	if (myary[1]!="0"){
		obj.className='clsInvalid';
	}
	
}


document.body.onload = BodyLoadHandler;
