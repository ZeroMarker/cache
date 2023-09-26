////UDHCCardGroupCharge.js


////UDHCCardPatInfoReg.js
////

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
var m_CardINVPrtXMLName="RegPrint";
/// First Page Print
var m_PatPageXMLName="";

var m_PatMasFlag="N";
var m_CardRefFlag="Y";
var m_AccManagerFlag="N";
var m_SetFocusElement="";
var m_SetRCardFocusElement ="";
var m_SetCardRefFocusElement = "";

var myCombAry=new Array();

function DocumentLoadHandler() {
	
	InitPatRegConfig();
	
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
	
	var myobj=document.getElementById('Birth');
	if (myobj){
		myobj.onblur=Birth_OnBlur;
	}
	
	var myobj=document.getElementById('PayMode');
	if (myobj){
		myobj.onchange=PayModeObj_OnChange;
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
	
 	var myobj=document.getElementById("CredNo");
 	if (myobj){
		myobj.onchange=CredNo_OnChange;
 	}
	
	var Obj=document.getElementById('Clear');
	if (Obj) {Obj.onclick = Clear_click;}
	
	var Obj=document.getElementById('Bill');
	if (Obj) {Obj.onclick = Bill_OnClick;}
	
	var myobj=document.getElementById('CardFareCost');
	if (myobj){
		myobj.onkeypress=CardFareCost_OnKeyPress;
		myobj.onkeyup=CardFareCost_OnKeyUp
	}
	
	DHCWeb_DisBtnA("Bill");
	
	document.onkeydown=Doc_OnKeyDown;	
	
	IntDoc();
	
	var myCompData=DHCWebD_GetObjValue("GroupCInfo");
	///alert(myCompData)
	
	myCombAry["PayCompany"]=new dhtmlXComboArray("PayCompany",myCompData);
	myCombAry["PayCompany"].enableFilteringMode(true);
	
	myCombAry["PayCompany"].selectlistchange=PayCompany_OnListChange;
	
	var myobj=document.getElementById('CardNo');
	if (myobj){
		myobj.onkeydown = CardNo_keydown;
	}
	
	PayModeObj_OnChange();
	GetReceiptNo();
	textimemode();
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_SetObjValueA("ComputerIP",computername);
}

function PayCompany_OnListChange()
{
	///alert();
	var myVal=myCombAry["PayCompany"].getActualValue();
	if (myVal==""){
		return;
	}
	var myary=myVal.split("^");
	
	///myGRIRowID_"^"_mySCCount_"^"_myCardSum_"^"_myUnRegSCCount
	DHCWebD_SetObjValueA("CardFareCost",myary[2]);
	DHCWebD_SetObjValueA("CardNum", myary[1]);
	DHCWebD_SetObjValueA("UnRegCardNum", myary[3]);
	DHCWebD_SetObjValueA("GRIRowID",myary[0]);
	var myCardSum = myary[2];
	if (isNaN(myCardSum)){myCardSum=0;}
	if (parseInt(myCardSum)>0){
		EnableBill();
	}else{
		DHCWeb_DisBtnA("Bill");
	}
	
}

function CardFareCost_OnKeyPress()
{
	///Control 
	var mykey=event.keyCode;
	if (((mykey>57)||(mykey<42)||(mykey==44))&&(mykey!=13)){
		event.keyCode=0;
		return;
	}
}

function CardFareCost_OnKeyUp()
{
	///Control 
	var myCost=DHCWebD_GetObjValue("CardFareCost");
	///if (myCost!=""){
	//	EnableBill();
	//}else{
	//	DHCWeb_DisBtnA("Bill");
	///}
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
	}
	
}

function Doc_OnKeyDown(){
	if (((event.altKey)&&((event.keyCode==67)||(event.keyCode==99)))||(event.keyCode==120))
	{
		////Alt+C
		document.onkeydown=function(){return false;}
		var obj=document.getElementById("Bill");
		
		if (!obj.disabled){
			Bill_click();
		}
		document.onkeydown=Doc_OnKeyDown;
	}
	
	if (event.keyCode==118)
	{
		Clear_click();
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
	///alert();
}


function EnableBill()
{
	var Obj=document.getElementById('Bill');
	if (Obj) {
		Obj.onclick = Bill_click;
		Obj.disabled=false;
	}
}

function Bill_OnClick()
{
	SaveDataToServer();
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
	DHCWeb_DisBtnA("Bill");
	
	///配置需要传递到 Cache端的数据串
	//var myPatInfo=GetPatMasInfo();
	
	//var myCardInfo=GetCardRefInfo();
	
	var myCardInvInfo=GetCardINVInfo();
	
	//var myAccInfo=GetAccManagerInfo();
	
	//var myAccDepInfo=GetPreDepositeInfo();
	
	var myConfigInfo="";
	var mySpecInfo="";
	var myGRIRowID=DHCWebD_GetObjValue("GRIRowID");
	///alert(myConfigInfo+","+ myCardInvInfo+","+ mySpecInfo);
	//return;
	
	var myExpStr="";
	//alert(mySecrityNo);
	var encmeth=DHCWebD_GetObjValue("ReadBillEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth, myConfigInfo, myCardInvInfo, mySpecInfo,myGRIRowID, myExpStr);
		//alert(rtn);
		var myary=rtn.split(String.fromCharCode(1));
		if (myary[0]=='0')
		{
			////根据配置设置打印
			////发卡时收费票据打印的RowID
			if (myary[1]!=""){
				PatRegPatInfoPrint(myary[1],m_CardINVPrtXMLName,"ReadCardINVEncrypt");
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
			EnableBill();
		}
	}
}

function CheckData(){
	var myrtn=true;
	
	var myobj=document.getElementById('CardFareCost');
	if (myobj){
		myval=myobj.value;
		myrtn=IsNumber(myval);
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

function Bill_click()
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

function IsNumber(string,sign) 
{
	var number; 
	if (string==null) return false; 
	if ((sign!=null)&&(sign!='-')&&(sign!='+')) 
	{
		return false; 
	}
	//alert(string+"^"+sign);
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
		var myobj=document.getElementById(m_TextItemName[myIdx]);
		if (myobj){
			myobj.onkeydown = nextfocus;
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
	DHCWebD_ClearAllListA("CredType");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CredType");
		
	}
	
	var myobj=document.getElementById("ReceiptNO");
	if (myobj)
	{
		myobj.disabled=true;
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


function SetPayInfoStatus(SFlag)
{
	var myobj=document.getElementById("PayCompany");
	if (myobj){
		//myobj.disabled=SFlag;
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
	//GetPatMasInfo();
	var ref="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardGroupCharge";
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



function PatInfoFind_click()
{
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPPatInfoFind";
	win=open(lnk,"PatInfoFind","status=1,scrollbars=1,top=100,left=100,width=760,height=420");
}

function Quit_click()
{
 	window.close()
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
	var m_SelectCardTypeRowID="15";
	
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

document.body.onload = DocumentLoadHandler;

