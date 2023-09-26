
////UDHCCardPatInfoReg.js
////

	var GPatType;
	var Guser;
	var GuserCode;
	var GroupID;
	var PatientID;
	var CardID;
	var CardNo;
	var CardVerify;
	var computername;

var m_CardValidateCode="";
var m_CCMRowID="";
var m_SelectCardTypeRowID="";
var m_CardNoLength=0;
var m_PAPMINOLength=8;
var PrtXMLName="UDHCAccDeposit";
/// Invoice Prt
var m_CardINVPrtXMLName="";
/// First Page Print
var m_PatPageXMLName="";

var m_PatMasFlag="N";
var m_CardRefFlag="N";
var m_AccManagerFlag="N";
var m_SetFocusElement="";
var m_SetRCardFocusElement ="";
var m_SetCardRefFocusElement = "";

///此类卡是建立对照?还是发的主卡?需要定义
var m_SetCardReferFlag="N";

//需要增加的功能?
//1. 身份证验证功能
//
//

function DocumentLoadHandler() {
	
	InitPatRegConfig();
	
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
	
	var myobj=document.getElementById('Birth');
	if (myobj){
		myobj.onblur=Birth_OnBlur;
	}
	
	var myobj=document.getElementById('Age');
	if (myobj){
		myobj.onblur=Age_OnBlur;
	}
	
	var myobj=document.getElementById('PayMode');
	if (myobj){
		myobj.onchange=PayModeObj_OnChange;
	}
	
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
	}
	
	///配置说明是否
	var myobj=document.getElementById('CardNo');
	if (myobj){
		myobj.readOnly=true;
	}
	
	var myobj=document.getElementById('ReceiptsNo');
	if (myobj){
		myobj.readOnly=true;
	}
	
	var IDCardNo1Obj=document.getElementById('IDCardNo1');
	if (IDCardNo1Obj) {IDCardNo1Obj.onchange = IDCardNo1Obj_onchange;}
 	
 	var myobj=document.getElementById("CredNo");
 	if (myobj){
		myobj.onchange=CredNo_OnChange;
 	}
	
	var Obj=document.getElementById('Clear');
	if (Obj) {Obj.onclick = Clear_click;}
	
	var Obj=document.getElementById('ReadCard');
	if (Obj) {Obj.onclick = ReadMagCard_Click;}
	var myobj=document.getElementById("ReadRegInfo");
	if (myobj){
		myobj.onclick=ReadRegInfo_OnClick;
	}
	///var Obj=document.getElementById('NewCard');
	///if (Obj) {Obj.onclick = NewCard_click;}
	
	DHCWeb_DisBtnA("NewCard");
	
	document.onkeydown=Doc_OnKeyDown;	
	
	IntDoc();
	
	var myobj=document.getElementById('CardNo');
	if (myobj){
		myobj.onkeydown = CardNo_keydown;
		myobj.onkeypress = CardNo_OnKeyPress;
	}
	var myobj = document.getElementById("EMail");
	if (myobj){
		myobj.onblur = EMail_OnBlur;
	}

	PayModeObj_OnChange();
	CardTypeDefine_OnChange();
	textimemode();
	DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit");
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_SetObjValueA("ComputerIP",computername);
}

function ProvinceInfo_OnKeyPress(e)
{
	DHCWeb_LookUpItemTransKeyPress();
}

function CountryDesc_OnKeyPress(e)
{
	DHCWeb_LookUpItemTransKeyPress();
	return;
	
	//alert(window.event.type);
	var type=websys_getType(e);
	var key=websys_getKey(e);
	//alert(type)
	var myobj=document.getElementById("CountryDesc");
	if ((myobj)&&((type=='keypress')&&(key==13))&&(myobj.onkeydown)) {
		
		window.event.keyCode = 117;
		//alert("which"+window.event.which);
		myobj.onclick = myobj.onkeydown;
		//myobj.addEventListener("click",myobj.onkeydown,true);
		var myNewEvent=document.createEventObject();
		myNewEvent.button=3;
		myNewEvent.keyCode = 117;
		//myobj.fireEvent("onclick",myNewEvent);
		//keydown
		myobj.fireEvent("onkeydown",myNewEvent);
		//myobj.onclick =function (){return false;};
		//myobj.onkeydown();
		event.cancleBubble=true;
		
		window.event.keyCode = 0;
		//alert();
	}
}

function CountryDesc_OnClick()
{
	alert("which"+window.event.which);
}

function ReadRegInfo_OnClick()
{
	///var mystr=GetPatMasInfo();
	
	//SetPatInfoByXML("<PatInfo><Sex>1</Sex><CheckTest>true</CheckTest><CredType>2</CredType></PatInfo>");
	var myHCTypeDR=DHCWeb_GetListBoxValue("IEType");
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		SetPatInfoByXML(myary[1]);
		IDReadControlDisable(true);
	}
}

function IDReadControlDisable(bFlag)
{
	
	var myobj=document.getElementById("CredNo");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Sex");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("NationDesc");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Birth");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Address");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Age");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	
}


function Doc_OnKeyDown(){
	if ((event.altKey)&&((event.keyCode==82)||(event.keyCode==114)))
	{
		////Alt+R
		document.onkeydown=function(){return false;}
		DHCWeb_DisBtnA("ReadCard");
		///alert("");
		ReadMagCard_Click();
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadMagCard_Click;
		}
		document.onkeydown=Doc_OnKeyDown;
	}
	if ((event.altKey)&&((event.keyCode==67)||(event.keyCode==99)))
	{
		////Alt+C
		document.onkeydown=function(){return false;}
		var obj=document.getElementById("NewCard");
		
		if (!obj.disabled){
			NewCard_click();
		}
		document.onkeydown=Doc_OnKeyDown;
	}
	
	DHCWeb_EStopSpaceKey();
}

function Birth_OnKeydown(){
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		var mybirth=DHCWebD_GetObjValue("Birth");
		
		websys_nexttab(eSrc.tabIndex);
	}

}

function Age_OnBlur()
{
	var mybirth=DHCWebD_GetObjValue("Birth");
	if (mybirth==""){
		var myBirth=DHCWeb_GetBirthDayFromAge("Age");
		DHCWebD_SetObjValueA("Birth", myBirth);
	}
}

function EMail_OnBlur()
{
	var myemail=DHCWebD_GetObjValue("EMail");
	if (myemail!=""){
		var myrtn=DHCWeb_ValidateEmail(myemail)
		if (!myrtn)
		{
			var obj=document.getElementById("EMail");
			obj.className='clsInvalid';
			websys_setfocus("EMail");
			return websys_cancel();
		}else{
			var obj=document.getElementById("EMail");
			obj.className='clsvalid';
		}
	}else{
		var obj=document.getElementById("EMail");
		obj.className='clsvalid';
	}
}


function Birth_OnBlur(){
	var mybirth=DHCWebD_GetObjValue("Birth");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("Birth");
		obj.className='clsInvalid';
		websys_setfocus("Birth");
		return websys_cancel();
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("Birth",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("Birth");
		obj.className='clsInvalid';
		websys_setfocus("Birth");
		return websys_cancel();
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	if (myrtn){
		var myAge=DHCWeb_GetAgeFromBirthDay("Birth");
		DHCWebD_SetObjValueA("Age",myAge);
	}
	///alert();
}

function ReadMagCard_Click()
{
	//m_CCMRowID  == HardType
	//var rtn=DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	var rtn=DHCACC_ReadMagCard(m_CCMRowID);
	
	var myary=rtn.split("^");
	if (myary[0]=='0'){
		DHCWebD_SetObjValueB("CardNo",myary[1]);
		CardVerify=myary[2];
		m_CardValidateCode=myary[2];
		
		GetValidatePatbyCard();
	}
}

function GetValidatePatbyCard()
{
	var myCardNo=DHCWebD_GetObjValue("CardNo");
	if (myCardNo=="") {alert("no card no");return;}
	
	var encmeth=DHCWebD_GetObjValue("getpatbyCardNoClass");
	if (encmeth!=""){
		var myExpStr="";
		var rtn=cspRunServerMethod(encmeth, myCardNo, CardVerify, m_SelectCardTypeRowID, myExpStr);
		///Flag^XMLStr
		var myary=rtn.split("^");
		//alert(rtn)
		if (myary[0]=='0')
		{
			var myXMLStr=myary[1];
			
			SetPatInfoByXML(myXMLStr);
			var Obj=document.getElementById('NewCard');
			if (Obj) {
				Obj.onclick = NewCard_click;
				Obj.disabled=false;
			}
			//alert(m_SetFocusElement);
			//websys_setfocus(m_SetFocusElement);
			if (m_SetRCardFocusElement!=""){
				websys_setfocus(m_SetRCardFocusElement);
			}
		}
		else{
			switch(myary[0]){
			case "-341":
				alert(t[2024]);
				break;
			case "-340":
				alert(t[2003]);
				break;
			case "-350":
				alert(t["-350"]);
				break;
			case "-351":
				alert(t["-351"]);
				break;
			case "-352":
				alert(t["-352"]);
				break;
			case "-356":
				alert(t[myary[0]]);
				break;
			case "-357":
				alert(t[myary[0]]);
				break;
			case "-358":
				alert(t[myary[0]]);
				break;
			default:
				alert("Error Code:" +myary[0]);
				break;
			}
			DHCWeb_DisBtnA("NewCard");
		}
	}
}

function EnableNewCard()
{
	var Obj=document.getElementById('NewCard');
	if (Obj) {
		Obj.onclick = NewCard_click;
		Obj.disabled=false;
	}
}

function SaveDataToServer()
{
	//根据配置来验证 界面数据是否完整 ,这个需要单独来写
	//配置需要传递到 Cache端的数据串
	//调用Cache函数
	//分别调用打印程序
	//1.如果卡需要收费, 是否打印发票,或者打印小条(热敏条)
	//2.如果有预交金是否需要打印小条;
	//3.根据卡类型是否打印条形码
	
	var myrtn=CheckData();
	
	if (!myrtn){
		return;
	}
	DHCWeb_DisBtnA("NewCard");
	
	///配置需要传递到 Cache端的数据串
	var myPatInfo=GetPatMasInfo();
	
	var myCardInfo=GetCardRefInfo();
	
	var myCardInvInfo=GetCardINVInfo();
	
	var myAccInfo=GetAccManagerInfo();
	
	var myAccDepInfo=GetPreDepositeInfo();
	
	var mySecrityNo="";
	if (m_CardRefFlag=="Y")
	{
		///设置写卡
		var myrtn=WrtCard();
		var myary=myrtn.split("^");
		if (myary[0]!="0"){
			EnableNewCard();
			return;
		}
		var mySecrityNo=myary[1];
	}
	
	var Password="";
	if (m_AccManagerFlag=="Y")
	{
		
		var myDefaultPWDFlag=DHCWebD_GetObjValue("SetDefaultPassword");
		if (myDefaultPWDFlag)
		{
		  	var ren=DHCACC_GetValidatePWD(mySecrityNo);
			
			var myary=ren.split("^");
			
			if (myary[0]=='0'){ 
				 Password=myary[1];
			}
			else
			{
				alert(t[2034]);
				EnableNewCard();
				return;
			}
		}
	  	else{
			var ren=DHCACC_SetAccPWD();
			var myary=ren.split("^");
			if (myary[0]=='0'){ 
				 Password=myary[1];
			}
			else
			{
				alert(t[2034]);
				EnableNewCard();
				return;
			}
		}
	}
	
	var myConfigInfo=mySecrityNo
	myConfigInfo += "^"+Password;
	var mySpecInfo=mySecrityNo;
	mySpecInfo += "^"+Password;
	var myExpStr="";
	//alert(mySecrityNo);
	var encmeth=DHCWebD_GetObjValue("NewCardClass");
	if (encmeth!=""){
		
		var rtn=cspRunServerMethod(encmeth, myConfigInfo, myPatInfo, myCardInfo, myAccInfo, myAccDepInfo, myCardInvInfo, mySpecInfo, myExpStr);
		//alert(rtn);
		var myary=rtn.split(String.fromCharCode(1));
		if (myary[0]=='0')
		{
			////根据配置设置打印
			////发卡时收费票据打印的RowID
			if (myary[1]!=""){
				PatRegPatInfoPrint(myary[1],m_CardINVPrtXMLName,"ReadCardINVEncrypt");
			}
			////预交金RowID
			var myAmtValue=DHCWebD_GetObjValue("amt");
			if ((myAmtValue>0)&&(myary[2]!="")){
				   ////Add Version Contral
				var myVersion=DHCWebD_GetObjValue("DHCVersion");
				switch(myVersion){
					case "1":
						var mystr=rtn+"^";
						Print_Click(mystr);
						break;
					default:
						///(RowIDStr, CurXMLName, EncryptItemName)
						PatRegPatInfoPrint(myary[2],PrtXMLName,"ReadAccDPEncrypt");
					}
			}
			////打印条形码等
			if (myary[3]!=""){
				
			}
			///打印首页
			if (myary[4]!=""){
				PatRegPatInfoPrint(myary[4],m_PatPageXMLName,"ReadFirstPageEncrypt");
			}
			alert(t[2013]);
			Clear_click();
		}
		else if (myary[0]=='-302')
			{alert(t[2025]);}
		else if (myary[0]=='-303')
			{alert(t[2002]);}
		else if (myary[0]=='-304')
			{alert(t[2024]);}
		else
			{alert("Error Code: "+myary[0]+"  "+t[2015]);
		}
		if (myary[0]!='0'){
			EnableNewCard();
		}
	}
}

function CheckData(){
	var myrtn=true;
	
	var OpMedicareObj=document.getElementById('OpMedicare');
	
	if (m_PatMasFlag=="Y")
	{
		var myName=DHCWebD_GetObjValue("Name");
		if (myName=="")
		{
			alert(t["noname"]);
			websys_setfocus('Name');
			return false;
		}
		
		var myobj=document.getElementById("Birth");
		if (myobj){
			var myBirth=obj.value;
			if (myBirth==""){
				alert(t["BirthTip"]);
	   			websys_setfocus('Birth');
	   			return false;
			}
		}
		
		var mySex=DHCWebD_GetObjValue("Sex");
		if (mySex=="")
		{
			alert(t["noSex"]);
			websys_setfocus('Sex');
			return false;
		}
		
		var myPatType= DHCWebD_GetObjValue("PatType");
		
		if (myPatType=="")
		{
			alert(t["noPatType"]);
			websys_setfocus('PatType');
			return false;
		}
		
	}
	
	if (m_CardRefFlag=="Y")
	{
		var myCardNo=DHCWebD_GetObjValue("CardNo");
		if (myCardNo=="")
		{
			alert(t[2002]);
			if (m_SetFocusElement!=""){
				websys_setfocus(m_SetFocusElement);
			}
			return false;
		}
	}
	
	if (m_AccManagerFlag=="Y")
	{
		var myobj=document.getElementById("amt");
		if (myobj){
			if (!IsNumber(myobj.value)){alert(t[2041]);
		   		websys_setfocus('amt');
		   		return false;
			}
			if (myobj.value<0){
			    alert(t[2041]);
		   		websys_setfocus('amt');
		   		return false;
			}
		}
	}
	
	return myrtn;
}

function GetPatMasInfo()
{
	var myxml="";
	
	if (m_PatMasFlag=="Y"){
		var myparseinfo = DHCWebD_GetObjValue("InitPatMasEntity");
		var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;
}

function GetCardRefInfo()
{
	//InitCardRefEntity
	var myxml="";
	
	if (m_CardRefFlag=="Y"){
		var myparseinfo = DHCWebD_GetObjValue("InitCardRefEntity");
		var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;
	
}

function GetCardINVInfo()
{
	var myxml="";
	if (m_CardRefFlag=="Y"){
		var myparseinfo = DHCWebD_GetObjValue("InitCardINVPRTEntity");
		var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo)		
	}
	
	return myxml;
}


function GetAccManagerInfo()
{
	var myxml="";
	
	if (m_AccManagerFlag=="Y")
	{
		var myparseinfo = DHCWebD_GetObjValue("InitAccManagerEntity");
		var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;	
}

function GetPreDepositeInfo()
{
	var myxml="";
	
	if (m_AccManagerFlag=="Y")
	{
		var myparseinfo = DHCWebD_GetObjValue("InitAccPreDepositEncrypt");
		var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;
}

function NewCard_click()
{
	SaveDataToServer();
	
	return;
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
		DHCP_GetXMLConfig("DepositPrintEncrypt",CurXMLName);
	}
	
	for (var invi=0;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var encmeth=DHCWebD_GetObjValue(EncryptItemName);
			
			///var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",CurXMLName,INVtmp[invi], Guser, myExpStr);
		}
	}
	
}

function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}


function WrtCard(){
	////Read Secrity
	///ReadSecEnvrypt
	var mySecrityNo="";
	var myencmeth=DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth!=""){
		var myPAPMINo=DHCWebD_GetObjValue("PAPMINo");
		mySecrityNo=cspRunServerMethod(myencmeth,myPAPMINo);
	}else
	{
		alert("Read Err!");
		return "-1^";
	}
	
	///Write Card First
	if (mySecrityNo!=""){
		var myCardNo=DHCWebD_GetObjValue("CardNo");
		var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
		///alert(rtn);
		////not Wrt Card
		if (rtn!="0"){
			return "-1^"
		}
	}else{
		return "-1^";
	}
	
	return "0^"+mySecrityNo
}

function IsNumber(string,sign) 
{
	var number; 
	if (string==null) return false; 
	if ((sign!=null)&&(sign!='-')&&(sign!='+')) 
	{
		return false; 
	}
	number = new Number(string);
	if (isNaN(number)) 
	{ 
		return false; 
	} 
	else if ((sign==null)||(sign=='-'&&number<0)||(sign=='+'&&number>0)) 
	{ 
		return true; 
	} 
	else 
		return false; 
}

function GetCurrentRecNo()
{
	        
			p1=Guser
			p2="D"
			var getregno=document.getElementById('GetCurrentRecNoClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,p1,p2)
			 var myary=ren.split("^");
				
				
				if (myary[0]=='0'){
					
					ReceiptsNoObj.value=myary[3]
					}
					else
					{
						alert(t[2072])
						
						}
	
	}
function textimemode()
{
	if (document.all.PAPMINo){
		document.all.PAPMINo.style.imeMode = "disabled";
	}
	if (document.all.Name){
		document.all.Name.style.imeMode = "active";
	}
	if (document.all.Sex){
		document.all.Sex.style.imeMode = "disabled";
	}
	if (document.all.OpMedicare){
		document.all.OpMedicare.style.imeMode = "disabled";
	}
	if (document.all.InMedicare){
		document.all.InMedicare.style.imeMode = "disabled";
	}
	if (document.all.IDCardNo1){
		document.all.IDCardNo1.style.imeMode = "disabled";
	}
	if (document.all.TelNo){
		document.all.TelNo.style.imeMode = "disabled";
	}
	if (document.all.CredNo){
		document.all.CredNo.style.imeMode = "disabled";
	}
	if (document.all.amt){
		document.all.amt.style.imeMode = "disabled";
	}
	if (document.all.Birth){
		document.all.Birth.style.imeMode = "disabled";
	}
	if (document.all.CardChequeNo){
		document.all.CardChequeNo.style.imeMode = "disabled";
	}
	if (document.all.ChequeDate){
		document.all.ChequeDate.style.imeMode = "disabled";
	}
	if (document.all.PayAccNo){
		document.all.PayAccNo.style.imeMode = "disabled";
	}
}

function InitPatRegConfig()
{
	var encmeth=DHCWebD_GetObjValue("ReadCardRegConfigEncrypt");
	if (encmeth!="")
	{
		var myvalue=cspRunServerMethod(encmeth);
		if (myvalue=="")
		{
			return;
		}
		var myRtnAry=myvalue.split(String.fromCharCode(2))
		var myary=myRtnAry[0].split("^");
		var mySetFocusElement=myary[2];
		m_SetFocusElement = mySetFocusElement;
		
		m_PatMasFlag=myary[3];
		m_CardRefFlag=myary[4];
		m_AccManagerFlag=myary[5];
		
		///Get Config Default Value
		///By XML String
		SetPatInfoByXML(myRtnAry[1]);
		
	}
	
	if (mySetFocusElement!=""){
		websys_setfocus(mySetFocusElement);
	}
	
}

///Init Operate Document
function IntListItem()
{
	var myCount=m_ListItemName.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		var myobj=document.getElementById(m_ListItemName[myIdx]);
		if (myobj){
			myobj.onkeydown = nextfocus;
			myobj.size=1;
			myobj.multiple=false;
			if ((myobj.length>0)&&(myobj.selectedIndex=-1)){
				myobj.selectedIndex=0;
			}
		}
	}
}

///Init Text Type Operate
function InitTextItem()
{
	var myCount=m_TextItemName.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		if ((m_TextItemName[myIdx]!="PAPMINo")&&(m_TextItemName[myIdx]!="CardNo")){
			var myobj=document.getElementById(m_TextItemName[myIdx]);
			if (myobj){
				myobj.onkeydown = nextfocus;
			}
		}
	}	
}

function InitLookUpTextItem()
{
	var myCount=m_LookUpTextItemName.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		if ((m_LookUpTextItemName[myIdx]!="PAPMINo")&&(m_LookUpTextItemName[myIdx]!="CardNo")){
			var myobj=document.getElementById(m_LookUpTextItemName[myIdx]);
			if (myobj){
				myobj.onkeypress = DHCWeb_LookUpItemTransKeyPress;
				myobj.onblur=LookUpItemBlurEvent;
			}
		}
	}	
}

///Check for Desc ?="" 
///RowID must ==""
function LookUpItemBlurEvent()
{
	var eSrc=window.event.srcElement;
	var myobj=document.getElementById(eSrc.name);
	var myIdx = m_LookUpTextItemName.indexOf(eSrc.name);
	var myRowIDobj=document.getElementById(m_LookUpTextItemRowID[myIdx]);
	if ((myobj)&&(myRowIDobj)){
		if ((myobj.value=="")&&(myRowIDobj.value!="")){
			//alert("RowID " + myRowIDobj.value);
			myRowIDobj.value="";
			//alert("RowID " + myRowIDobj.value);
		}
	}
	//alert(myIdx);
	//	alert(event.srcElement.tagName);
}



function IntDoc(){
	
	//初始化窗体
	//需要窗体的参数
	//等待继续.....
	
	IntListItem();
	InitTextItem();
	InitLookUpTextItem();
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}

	DHCWebD_ClearAllListA("Bank");
	var encmeth=DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Bank");
		
	}
	DHCWebD_ClearAllListA("AccountType");
	var encmeth=DHCWebD_GetObjValue("ReadAccountType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","AccountType");
		
	}
	DHCWebD_ClearAllListA("BankCardType");
	var encmeth=DHCWebD_GetObjValue("ReadBankCardType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","BankCardType");
		
	}
	
	DHCWebD_ClearAllListA("PayMode");
	var encmeth=DHCWebD_GetObjValue("ReadPayMode");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode",GroupID);
		
	}
	DHCWebD_ClearAllListA("Sex");
	var encmeth=DHCWebD_GetObjValue("ReadSex");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Sex");
		
	}
	DHCWebD_ClearAllListA("PatType");
	var encmeth=DHCWebD_GetObjValue("ReadPatType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PatType");
		
	}
	DHCWebD_ClearAllListA("CredType");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CredType");
		
	}
	var encmeth=DHCWebD_GetObjValue("ReadAccParaEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth);
		var myary=rtn.split("^");
		if (isNaN(myary[0])){
			var myVal=0;
		}else{
			var myVal=parseInt(myary[0]);
		}
		DHCWebD_SetObjValueA("SetDefaultPassword",myVal);
		
		if (isNaN(myary[14])){
			var myVal=0;
		}else{
			var myVal=parseInt(myary[14]);
		}
		DHCWebD_SetObjValueA("DepPrice",myVal);
	}
	var myDefaultPWDFlag=DHCWebD_GetObjValue("SetDefaultPassword");
	var myobj=document.getElementById('SetDefaultPassword');
	if (myobj)
	{
		myobj.disabled = myDefaultPWDFlag;
	}
	
	var myobj=document.getElementById("ReceiptNO");
	if (myobj)
	{
		myobj.disabled=true;
	}

	var myobj=document.getElementById("CardFareCost");
	if (myobj)
	{
		myobj.disabled=true;
	}
	
	var myobj=document.getElementById("PAPMINo");
	if (myobj)
	{
		myobj.readOnly=true;
	}
	
	
	//websys_setfocus("PAPMINo");
}

function PayModeObj_OnChange()
{
	var myobj=document.getElementById("PayMode");
	if(myobj){
		if (myobj.options.length==0){
			SetPayInfoStatus(true);
			return;
		}
		var myIdx=myobj.options.selectedIndex;
		if (myIdx==-1){
			SetPayInfoStatus(true);
			return;
		}
		var myary=myobj.options[myIdx].value.split("^");
		if (myary[2]=="Y"){
			SetPayInfoStatus(false);
		}else{
			SetPayInfoStatus(true);
		}
	}
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
	
	
	//alert(myary);

	///CTD_Code		1
	///CTD_Desc		2
	///CTD_FareType	3
	///CTD_PrtINVFlag	4
	///CTD_UseINVType	5
	///CTD_CardFareCost	6
	///CTD_ReclaimFlag	7
	///CTD_DefaultFlag	8
	///xx CTD_DateFrom	9
	///xx CTD_DateTo	10
	///xx CTD_ActiveFlag	11
	///xx CTD_SearchMasFlag	12
	///xx CTD_SetFocusElement	13
	///xx CTD_HardCom_DR	14
	///CTD_BarCodeCom_DR	15
	///CTD_ReadCardMode		16  读卡方式 Handle/Read
	///CTD_CardNoLength		17		卡号长度
	///CTD_SecrityNoFlag	18					校验码设置
	///CTD_PreCardFlag		19		预生成卡标志
	///CTD_ReadCardFocusElement		20   下一个聚焦元素
	///CTD_PANoCardRefFlag			21
	///CTD_CardRefFocusElement		22
	///CTD_OverWriteFlag			23			此类型卡是否重新写
	///CTD_CardAccountRelation		24
	///CTD_INVPRTXMLName			25			发票打印模版名称
	///CTD_PatPageXMLName			26		首页打印
	///CTD_StChangeValidateFlag			27		验证标志
	///
	DHCWebD_SetObjValueA("CardFareCost","");
	DHCWebD_SetObjValueA("ReceiptNO","");
	if (myary[3]=="C"){
		DHCWebD_SetObjValueA("CardFareCost",myary[6]);
		
		GetReceiptNo();
	}
	
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadMagCard_Click;
		}
	}
	
	m_CCMRowID=myary[14];
	
	m_SetFocusElement = myary[13];
	if (m_SetFocusElement!=""){
		websys_setfocus(myary[13]);
	}
	
	m_CardNoLength=myary[17];
	
	///Set Focus Name
	m_SetRCardFocusElement=myary[20]		//"Name";
	
	m_SetCardRefFocusElement=myary[22];
	
	m_SetCardReferFlag=myary[21];
	
	var myobj=document.getElementById("PAPMINo");
	if (myobj)
	{
		if (m_SetCardReferFlag=="Y"){
			myobj.onkeydown = PAPMINo_OnKeyDown;
			myobj.readOnly=false;
		}else{
			myobj.onclick = function(){return false;}
			myobj.readOnly=true;
		}
	}
	m_CardINVPrtXMLName=myary[25];
	/// First Page Print
	m_PatPageXMLName=myary[26];
	
	var myobj=document.getElementById("CardNo");
	if (myobj){
		myobj.value="";
	}
	
}

function SetPayInfoStatus(SFlag)
{
	var myobj=document.getElementById("PayCompany");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("Bank");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("BankCardType");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("CardChequeNo");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("ChequeDate");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("PayAccNo");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("Remark");
	if (myobj){
		myobj.disabled=SFlag;
	}
	
}
function Clear_click()
{
	////GetPatMasInfo();
	var ref="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardPatInfoReg";
	location.href=ref;
	return;
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function PatType_onkeydown() {
	if (evtName=='PatType') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key!=13) {
		return
	}
	var Obj=document.getElementById('PatType');
	if (Obj) {
		if (Obj.value!='') {	
			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''}
			var GetDetail=document.getElementById('PaadmCount');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};

			var rel=cspRunServerMethod(encmeth,'Paadm_count','',p1)
		
			if ((rel>=1) && (GPatType!=Obj.value) ){
				alert(t["04"])
				return
			}
			websys_setfocus('InMedicare');
		}
	}
}


function Paadm_count(value) {
	try {
	} catch(e) {};
}


function PatInfoFind_click()
{
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPPatInfoFind";
	win=open(lnk,"PatInfoFind","status=1,scrollbars=1,top=100,left=100,width=760,height=420");
}

function Quit_click()
{
 	window.close()
}


//Duplicate name
function NameObj_onchange(e) {
	if (evtName=='Name') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
		var obj=document.getElementById('Name');
		
		if (obj.value!='') {
			var tmp=document.getElementById('Name');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetName');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'GetDupName_count','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Name');	
			return websys_cancel();
		}
		obj.className='';
	}
}


function GetDupName_count(value) {
	try {
		Name_obj=document.getElementById('Name');
		PatName=Name_obj.value
		if (value>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind&FID="+""+"&NAME="+PatName+"&IDCardNo="+""+"&TelNo="+""+"&InMedicare="+"";
			win=open(lnk,"FindPatBase","width=760,height=400");
		}
		
	} catch(e) {};
}

//Duplicate IDCardNo
function IDCardNo1Obj_onchange() {
	var obj=document.getElementById('IDCardNo1');
	//
	/*
	*/
	
}

function CredNo_OnChange()
{
	var mycredobj=document.getElementById("CredNo");
	var myidobj=document.getElementById('IDCardNo1');
	if ((mycredobj)&&(myidobj)){
		myidobj.value=mycredobj.value;
	}
}


function GetDupIDCardNo1_count(value) {
	try {
		IDCardNo1_obj=document.getElementById('IDCardNo1');
		IDCardNo1Name=IDCardNo1_obj.value
		if (value>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind&FID="+""+"&NAME="+""+"&IDCardNo="+IDCardNo1Name+"&TelNo="+""+"&InMedicare="+"";
			win=open(lnk,"NewWin","width=760,height=400");
		}
	} catch(e) {};
}

//Input Patient RegNo Or Other CardNo
function CardNo_keydown(e) {
	if (evtName=='CardNo')
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	
	var key=websys_getKey(e);
	
	if (key==13)
	{
		SetCardNOLength();
		CardVerify="";
		GetValidatePatbyCard();
	}
	///m_CardNoLength
	if (key==13) {
		//FindPatDetail()
	}
	
	var e=window.event;
	//DHCWeb_SetLimitNumABC(e);
	
}

function CardNo_OnKeyPress()
{
	var e=window.event;
	DHCWeb_SetLimitNumABC(e);	
}

function PAPMINo_OnKeyDown(e)
{
	if (evtName=='PAPMINo')
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	
	var key=websys_getKey(e);
	
	if (key==13)
	{
		SetPAPMINoLenth();
		
		GetPatDetailByPAPMINo();
	}
}

function GetPatDetailByPAPMINo(){
	
	
	var myPAPMINo=DHCWebD_GetObjValue('PAPMINo');
	if (myPAPMINo!="")
	{
		var myencmeth=DHCWebD_GetObjValue("GetPatDetailByNo");
		if (myencmeth!="")
		{
			var myExpstr="";
			var myPatInfo=cspRunServerMethod(myencmeth,myPAPMINo,myExpstr);
			var myary=myPatInfo.split("^");
			if (myary[0]=="0"){
				
				var myXMLStr=myary[1];
				
				SetPatInfoByXML(myXMLStr);
				if (m_SetCardRefFocusElement!="")
				{
					websys_setfocus(m_SetCardRefFocusElement);
				}
				var obj=document.getElementById("PAPMINo");
				obj.className='clsInvalid';
				obj.className='clsValid';
				return websys_cancel();
			}else if (myary[0]=="2001"){
				obj.className='clsInvalid';
				alert(t["2001"]);
			}else if (myary[0]=="-353"){
				obj.className='clsInvalid';
				alert(t["-353"]);
			}else{
				obj.className='clsInvalid';
				alert("Error Code: " + myary[0]);
			}
		}
	}
}


function SetPAPMINoLenth()
{
	// Set PAPMINo and CardNO Refer
	var obj=document.getElementById('PAPMINo');
	if (obj.value!='') {
		if ((obj.value.length<m_PAPMINOLength)&&(m_PAPMINOLength!=0)) {
			for (var i=(m_PAPMINOLength-obj.value.length-1); i>=0; i--) {
				obj.value="0"+obj.value
			}
		}	
	}
}

function SetCardNOLength(){
	var obj=document.getElementById('CardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
		}
}


function SetPatInfoByXML(XMLStr)
{
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		
		DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		
	}
	delete(xmlDoc);
}


function GetReceiptNo(){
	//
	var receipNOobj=document.getElementById('GetreceipNO');
	if (receipNOobj) {var encmeth=receipNOobj.value} else {var encmeth=''};
	var Guser=session['LOGON.USERID'];
	var myPINVFlag="Y";
	var myExpStr=session['LOGON.USERID'] +"^"+myPINVFlag;
	
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

////Set Look Up Info
////Country
function SetCountryInfo(Value)
{
	var myary=Value.split("^");
	DHCWebD_SetObjValueC("CountryDescLookUpRowID",myary[0]);
	DHCWebD_SetObjValueC("CountryDesc",myary[1]);
}

function SetProvinceInfo(Value)
{
	var myary=Value.split("^");
	DHCWebD_SetObjValueC("ProvinceInfoLookUpRowID",myary[0]);
	DHCWebD_SetObjValueC("ProvinceInfo",myary[1]);
}

function SetCityInfo(Value)
{
	var myary=Value.split("^");
	DHCWebD_SetObjValueC("CityDescLookUpRowID",myary[0]);
	DHCWebD_SetObjValueC("CityDesc",myary[1]);
}

function SetNationInfo(Value)
{
	var myary=Value.split("^");
	DHCWebD_SetObjValueC("NationDescLookUpRowID",myary[0]);
	DHCWebD_SetObjValueC("NationDesc",myary[1]);
}

function SetZipInfo(Value)
{
	var myary=Value.split("^");
	DHCWebD_SetObjValueC("ZipLookUpRowID",myary[0]);
	DHCWebD_SetObjValueC("Zip",myary[1]);
}

function SetEmployeeCompanyInfo(Value)
{
	var myary=Value.split("^");
	DHCWebD_SetObjValueC("EmployeeCompanyLookUpRowID",myary[0]);
	DHCWebD_SetObjValueC("EmployeeCompany",myary[1]);
	
}

document.body.onload = DocumentLoadHandler;

