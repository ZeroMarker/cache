/////UDHCCardPatInfoRegExp.js
var LocalSysParamsObj={
	//已婚
	MarriedIDStr:"22^23^24^25^26^27",
	//已婚最低年龄限制(女)
	MarriedLimitFemaleFAge:18,
	//已婚最低年龄限制(男)
	MarriedLimitMaleAge:18
}
var m_CurSearchValue=""
//建病历标识
var MedicalFlag=0
//修改信息标识
var ModifiedFlag=0
var m_ReceiptsType="";
var m_CardCost=0;
var GPatType;
var Guser;
var GuserCode;
var GroupID;
var PatientID;
var CardID;
var CardNo;
var CardVerify;
var computername;
var m_CardSecrityNo="";
var m_NextFocusFlag=true;
var m_ListItemName
	
var m_CardValidateCode="";
var m_CCMRowID="";
var m_SelectCardTypeRowID="";
var m_CardNoLength=0;
var m_CardTypePrefixNo="";
var m_PAPMINOLength=10;
var PrtXMLName="UDHCAccDeposit";
/// Invoice Prt
var m_CardINVPrtXMLName="";
/// First Page Print
var m_PatPageXMLName="";
var m_OverWriteFlag="N";

var m_PatMasFlag="N";
var m_CardRefFlag="N";
var m_AccManagerFlag="N";
var m_SetFocusElement="";
var m_SetRCardFocusElement ="";
var m_SetCardRefFocusElement = "";
///身份证代码字段
var m_IDCredTypePlate = "01";

var m_RegCardConfigXmlData = "";

///此类卡是建立对照?还是发的主卡?需要定义
var m_SetCardReferFlag="N";
var IsNotStructAddress="N"
var UsePANoToCardNO="N" //使用登记号作为卡号
//需要增加的功能?
//1. 身份证验证功能
//
//

var myCombNameAry=new Array();
myCombNameAry[1]="Sex";
myCombNameAry[2]="PatType";
myCombNameAry[3]="Vocation";
myCombNameAry[4]="CredType";
myCombNameAry[5]="AccountType";
myCombNameAry[6]="PayMode";
myCombNameAry[7]="Bank";
myCombNameAry[8]="BankCardType";
myCombNameAry[9]="CardTypeDefine";
myCombNameAry[10]="ProvinceInfo";
myCombNameAry[11]="CountryDesc";
myCombNameAry[12]="NationDesc";
myCombNameAry[13]="Zip";
myCombNameAry[14]="CityDesc";
myCombNameAry[15] = "CTRelationDR";
myCombNameAry[16] = "CTArea";
myCombNameAry[17] = "CountryHome";
myCombNameAry[18] = "CountryBirth";
myCombNameAry[19] = "CountryHouse";
myCombNameAry[20] = "ProvinceHome";
myCombNameAry[21] = "ProvinceBirth";
myCombNameAry[22] = "ProvinceHouse";
myCombNameAry[23] = "CityHome";
myCombNameAry[24] = "CityBirth";
myCombNameAry[25] = "Cityhouse";
myCombNameAry[26] = "AreaBirth";
myCombNameAry[27] = "AreaHouse";
myCombNameAry[28] = "HCPDR";
var m_CombXmlTagAray=new Array();
m_CombXmlTagAray[1]="Sex";
m_CombXmlTagAray[2]="PatType";
m_CombXmlTagAray[3]="Vocation";
m_CombXmlTagAray[4]="CredType";
m_CombXmlTagAray[5]="AccountType";
m_CombXmlTagAray[6]="PayMode";
m_CombXmlTagAray[7]="Bank";
m_CombXmlTagAray[8]="BankCardType";
m_CombXmlTagAray[9]="CardTypeDefine";
m_CombXmlTagAray[10]="ProvinceInfoLookUpRowID";
m_CombXmlTagAray[11]="CountryDescLookUpRowID";
m_CombXmlTagAray[12]="NationDescLookUpRowID";
m_CombXmlTagAray[13]="ZipLookUpRowID";
m_CombXmlTagAray[14]="CityDescLookUpRowID";
m_CombXmlTagAray[15] = "CTRelationDR";
m_CombXmlTagAray[16] = "CityAreaLookUpRowID";
m_CombXmlTagAray[17] = "CountryHome";
m_CombXmlTagAray[18] = "CountryBirth";
m_CombXmlTagAray[19] = "CountryHouse";
m_CombXmlTagAray[20] = "ProvinceHome";
m_CombXmlTagAray[21] = "ProvinceBirth";
m_CombXmlTagAray[22] = "ProvinceHouse";
m_CombXmlTagAray[23] = "CityHome";
m_CombXmlTagAray[24] = "CityBirth";
m_CombXmlTagAray[25] = "Cityhouse";
m_CombXmlTagAray[26] = "AreaBirth";
m_CombXmlTagAray[27] = "AreaHouse";
m_CombXmlTagAray[28] = "HCPDR";

///解决华西问题
var m_CombDataIdxPre = new Array();
m_CombDataIdxPre[1] = "CardTypeDefine";
m_CombDataIdxPre[2] = "CredType";
m_CombDataIdxPre[3] = "Sex";
m_CombDataIdxPre[4] = "Zip";
m_CombDataIdxPre[5] = "PatType";
m_CombDataIdxPre[6] = "PayMode";


var myCombAry=new Array();
///myCombAry[myCombNameAry[9]]

///卡快捷键使用
var CardTypeKeydownOld=""
var e=event;
function DocumentLoadHandler() {
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
    var myobj = document.getElementById('PAPMINo');
	if (myobj) {
		myobj.onkeydown = PAPMINo_OnKeyDown;
		//myobj.onblur=SearchSamePatient;
		myobj.onblur=PAPMINo_onblur;
	}
	var myobj = document.getElementById('InMedicare');
	if (myobj) {
		myobj.onblur = InMedicare_OnBlur;
	}
	var myobj=document.getElementById('Birth');
	if (myobj){
		myobj.onblur=Birth_OnBlur;
	}
	var myobj=document.getElementById('BirthTime');
	if (myobj){
		myobj.onblur=BirthTime_OnBlur;
	}
	var myobj = document.getElementById('Name');
	if (myobj) {
		myobj.onblur = SearchSamePatient;
	}
	/*
	var myobj = document.getElementById('Sex');
	if (myobj) {
		myobj.onblur = SearchSamePatient;
	}
	*/
	var myobj = document.getElementById('PatYBCode');
	if (myobj) {
		myobj.onblur = SearchSamePatient;
	}
	var myobj=document.getElementById('Age');
	if (myobj){
		myobj.onblur=Age_OnBlur;
		myobj.onkeypress=Age_OnKeypress;
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
	if (IDCardNo1Obj) {
		///IDCardNo1Obj.onchange = IDCardNo1Obj_onchange;
		///IDCardNo1Obj.onkeypress = IDCardNo1_OnKeyPress;
	}
 	
 	var myobj=document.getElementById("CredNo");
 	if (myobj){
		myobj.onchange=CredNo_OnChange;
		myobj.onkeypress=CredNo_OnKeyPress;
		myobj.onblur=SearchSamePatient;
 	}
	
	var Obj=document.getElementById('Clear');
	if (Obj) {Obj.onclick = Clear_click;}
	
	var Obj=document.getElementById('ReadCard');
	if (Obj) {Obj.onclick = ReadMagCard_Click;}
	var myobj=document.getElementById("ReadRegInfo");
	if (myobj){
		myobj.onclick=ReadRegInfo_OnClick;
	}

	var myobj=document.getElementById("ReadFirstID");
	if (myobj){
		myobj.onclick=ReadFirstID_Onclick;
	}
	///
	var Obj=document.getElementById('NewCard');
	if (Obj) {Obj.onclick = NewCard_click;}
	DHCWeb_DisBtnA("NewCard");
	var Obj = document.getElementById('BModifyInfo');
	if (Obj) Obj.onclick=BModifyInfo_click;
	
	var myobj=document.getElementById("ProvinceInfo");
	if (myobj){
		myobj.onfocus=ProvinceInfo_OnFocus;
	}
	var myobj = document.getElementById("ProvinceHome");
	if (myobj) {
		myobj.onfocus = ProvinceHome_OnFocus;
	}
	var myobj = document.getElementById("ProvinceBirth");
	if (myobj) {
		myobj.onfocus = ProvinceBirth_OnFocus;
	}
	var myobj = document.getElementById("ProvinceHouse");
	if (myobj) {
		myobj.onfocus = ProvinceHouse_OnFocus;
	}
	//
	var myobj=document.getElementById("CityDesc");
	if (myobj){
		myobj.onfocus=CityDescInfo_OnFocus;
	}
	
	var myobj=document.getElementById('CardNo');
	if (myobj){
		myobj.onkeydown = CardNo_keydown;
	}
	
	var myobj = document.getElementById("EMail");
	if (myobj){
		myobj.onblur = EMail_OnBlur;
	}

	var myobj = document.getElementById("GetPatPaySum");
	if (myobj){
		myobj.onkeypress = GetPatPaySum_KeyPress;
	}

	IntDoc();
	IntHelpControl();
	InitPatRegConfig();

	textimemode();
	CardTypeDefine_OnChange();
	PayModeObj_OnChange();

	DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit");
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_SetObjValueA("ComputerIP",computername);
	
	var myobj=document.getElementById("CardSearch")
	if (myobj) myobj.onclick=CardSearch_Click;
	
	var myobj=document.getElementById('PatType');
	if (myobj){
		
		myobj.onchange=PatTypeObj_OnChange;
	}
	var myobj=document.getElementById('OtherCredType');
	if (myobj){
		myobj.onclick=OtherCredTypeInput;
	}
	//打印条码
	var myobj = document.getElementById('prt');
	if (myobj) {
		myobj.onclick = function () {
			if (websys_$V("PAPMINo") == "") {
				alert("病人ID不能为空");
				return;
			}
			PatInfoPrint("PAPMINo");
		}
	}
	//医联码
	var myobj = document.getElementById('MedUnionCard');
	if (myobj) {
		myobj.onkeydown = GetPatInfoMedUnionCardHandler;
	}
	if (myCombAry["Sex"]){
		myCombAry["Sex"].enableFilteringMode(true);
		myCombAry["Sex"].selectHandle=SearchSamePatient;
	}
	
	var CardReportLoss=document.getElementById('CardReportLoss')
	if (CardReportLoss){
		CardReportLoss.onclick=CardReportLossClick;
	}
	
	//var IsNotStructAddress=document.getElementById("IsNotStructAddress")
	//if (IsNotStructAddress){
		//if (IsNotStructAddress.value!="Y"){
		  if (IsNotStructAddress!="Y"){
			var myobj=document.getElementById("Address");
			if (myobj){
				var ComponentID=tkMakeServerCall("websys.Component","GetIdFromCodeOrDescription","UDHCCardPatInfoRegExp")
				//myobj.style.display="none"
				document.getElementById("ld"+ComponentID+"iAddress").style.display="none"
				myobj.onkeydown=nextfocus;
			}
			var myobj=document.getElementById("RegisterPlace");
			if (myobj){
				var ComponentID=tkMakeServerCall("websys.Component","GetIdFromCodeOrDescription","UDHCCardPatInfoRegExp")
				//myobj.style.display="none"
				document.getElementById("ld"+ComponentID+"iRegisterPlace").style.display="none"
				myobj.onkeydown=nextfocus;
			}
		}
	//}
	//document.onkeydown=documentkeydown;
	document.onkeydown=Doc_OnKeyDown;
}
function documentkeydown(e) {
	var keycode;
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if(keycode==118) {
		Clear_click();
	}else if(keycode==120) {
		CardSearch_Click();
	}
}
function PAPMINo_onblur(e)
{
	if (evtName=='PAPMINo')
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	SetPAPMINoLenth();
	GetPatDetailByPAPMINo();

}

//快捷键选择卡类型
function keyDownSearchCard(e)
{
	
    if (document.activeElement.id=='CardTypeDefine')
		{
		CardTypeKeydownOld=""
		var KeySub=(window.event.keyCode-49)
		if ((KeySub>=0)&&(KeySub<=8))
		for(var i=0; i<myCombAry["CardTypeDefine"].optionsArr.length;i++){
	      if(myCombAry["CardTypeDefine"].optionsArr[i].data()[0].length==0) continue;
      		if (i==KeySub)
        	 {
        	  myCombAry["CardTypeDefine"].selectOption(i);
       		  myCombAry["CardTypeDefine"]._displayText();
			  CardTypeDefine_OnChange();
			  CardTypeKeydownOld=myCombAry["CardTypeDefine"].getSelectedValue();
        	  break;
        	 }
        	}
	}
}
function CardTypeDefine_Key()
{

	if (myCombAry["CardTypeDefine"].getSelectedValue()==""){
	if (CardTypeKeydownOld!=""){
		myCombAry["CardTypeDefine"].setComboValue(CardTypeKeydownOld)
	}
	}
}
//--------------------------------------
function CardSearch_Click()
{
	var lnk = "reg.cardsearchquery.hui.csp" //"websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch";
	win=websys_createWindow(lnk,"UDHCCardPatInfoRegExpFind","status=1,scrollbars=1,top=100,left=100,width=1180,height=520");
	
	}

function GetPatPaySum_KeyPress(){
	var key=event.keyCode;
	if (key==13){
		var obj=document.getElementById("GetPatPaySum");
		var objb=document.getElementById("CardFareCost");
		var Resobj=document.getElementById("amt");
		DHCWeb_Calobj(obj,objb,Resobj,"-");
		var myChange=DHCWebD_GetObjValue("amt");
		if((isNaN(myChange))||(myChange=="")){
			myChange=0;
		}
		myChange=parseFloat(myChange);
		if (myChange<0){
			websys_setfocus("GetPatPaySum");
			alert("输入费用金额错误!");
		}else{
			
		}
	}

}
function PatYBCodekeydownClick()
{
	return true;
	/*
	//以下为北京规则,标准版不启用
	var myobj=document.getElementById('PatYBCode');
	if (myobj.value=="99999999999S") {
		return true;
	}else{
		var i=0;
		var tmp=myobj.value;
		var length=tmp.length;
		if(length!=12) {
			alert("医保号位数不对?");
			return false;
		}
		var numtmp=tmp.substring(0,length-1);
		var numflag=isNumber(numtmp);
		if ((numflag!=true)||(tmp.substring(length-1,length)!="S")) {
			alert("医保字符不对?");
			return false;
		}
	}
	*/
}

function BirthCheck(){
	var mybirth=DHCWebD_GetObjValue("Birth");
	
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("Birth");
		alert("请输入正确的出生日期");
		websys_setfocus("Birth");
		//return websys_cancel();
		return false;
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		if (dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
		DHCWebD_SetObjValueA("Birth",mybirth);
	}
	////alert(mybirth);
	if (dtformat=="YMD"){
		var myrtn=DHCWeb_IsDate(mybirth,"-")
	}
	if (dtformat=="DMY"){
		var myrtn=DHCWeb_IsDate(mybirth,"/")
	}
	if (!myrtn){
		var obj=document.getElementById("Birth");
		////obj.className='clsInvalid';
		alert("请输入正确的出生日期");
		websys_setfocus("Birth");
		//return websys_cancel();
		return false;
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	/*if (myrtn){
		var myAge=DHCWeb_GetAgeFromBirthDay("Birth");
		DHCWebD_SetObjValueA("Age",myAge);
	}*/
	
	websys_setfocus('PatType');
    return true;
}

function CountryDesc_OnChange(){ //国籍  控制户口
	myCombAry["ProvinceHouse"].setComboText("");
	myCombAry["Cityhouse"].setComboText("");
	//DHCWebD_SetObjValueA("PostCodeHouse", "");
	//myCombAry["PostCodeHouse"].setComboText("");
	myCombAry["AreaHouse"].setComboText("");
}
function CountryHome_OnChange(){  //籍贯
	myCombAry["ProvinceHome"].setComboText("");
	myCombAry["CityHome"].setComboText("");
	
}
function CountryBirth_OnChange(){ //出生地
	myCombAry["ProvinceBirth"].setComboText("");
	myCombAry["CityBirth"].setComboText("");
	myCombAry["AreaBirth"].setComboText("");
}
function CountryHouse_OnChange(){  //现住地
	myCombAry["ProvinceInfo"].setComboText("");
	myCombAry["CityDesc"].setComboText("");
	//DHCWebD_SetObjValueA("PostCode", "");
	//myCombAry["Zip"].setComboText("");
	myCombAry["CTArea"].setComboText("");
}
function ProvinceInfo_OnFocus() {
	
	var myItemName = "ProvinceInfo";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryHouse"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
	myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
	}
}

function ProvinceInfo_OnChange()
{
	var myItemName = "ProvinceInfo";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryHouse"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
	//myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	myCombAry["CityDesc"].setComboText("");
	//DHCWebD_SetObjValueA("PostCode", "");
	//myCombAry["Zip"].setComboText("");
	myCombAry["CTArea"].setComboText("");
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
		
	}
}
function ProvinceHome_OnFocus() {
	var myItemName = "ProvinceHome";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryHome"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
	myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
	}
}

function ProvinceHome_OnChange()
{
	var myItemName = "ProvinceHome";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryHome"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
	//myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	myCombAry["CityHome"].setComboText("");
	//myCombAry["Zip"].setComboText("");
	//myCombAry["CTArea"].setComboText("");
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
		
	}
}
function ProvinceBirth_OnFocus() {
	
	var myItemName = "ProvinceBirth";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryBirth"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
		myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
	}
}

function ProvinceBirth_OnChange()
{
	var myItemName = "ProvinceBirth";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
		var myval = myCombAry["CountryBirth"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
	//myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	myCombAry["CityBirth"].setComboText("");
	//myCombAry["Zip"].setComboText("");
	myCombAry["AreaBirth"].setComboText("");
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
		
	}
}
function ProvinceHouse_OnFocus() {
	
	var myItemName = "ProvinceHouse";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryDesc"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
		myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
	}
}

function ProvinceHouse_OnChange()
{
	var myItemName = "ProvinceHouse";
	var mytabName = "CTProvince";
	var OldProvince = myCombAry[myItemName].getSelectedValue();
	var TempProvince = "$c(1)" + OldProvince + "$c(2)"
	var myval = myCombAry["CountryDesc"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
	//myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	myCombAry["Cityhouse"].setComboText("");
	//DHCWebD_SetObjValueA("PostCodeHouse", "");
	//myCombAry["PostCodeHouse"].setComboText("");
	myCombAry["AreaHouse"].setComboText("");
	if (TempInfo.split(TempProvince).length > 1) {
		myCombAry[myItemName].setComboValue(OldProvince);
	}
}
function CityDescInfo_OnFocus() {
	var myItemName = "CityDesc";
	var mytabName = "CTCITY";
	var OldCity = myCombAry[myItemName].getSelectedValue();
	var TempCity = "$c(1)" + OldCity + "$c(2)"
		var myval = myCombAry["ProvinceInfo"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
		///alert(myBaseData);
		myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempCity).length > 1) {
		myCombAry[myItemName].setComboValue(OldCity);
	}
	var myval = myCombAry[myItemName].getSelectedValue();
	var myary = myval.split("^");
	var myCityDR = myary[0];
	
	//GetCityZipInfo("", myCityDR, "","PostCode");
}
function CityDescInfo_OnChange() {
	
	var myItemName = "CityDesc";
	var myval = myCombAry[myItemName].getSelectedValue();
	var myary = myval.split("^");
	var myCityDR = myary[0];
	//myCombAry["Zip"].setComboText("");
	//DHCWebD_SetObjValueA("PostCode", "");
	myCombAry["CTArea"].setComboText("");
	//GetCityZipInfo("", myCityDR, "","PostCode");
	GetCityAreaInfo(myCityDR,"CTArea");
}
function CityBirth_OnFocus() {
	var myItemName = "CityBirth";
	var mytabName = "CTCITY";
	var OldCity = myCombAry[myItemName].getSelectedValue();
	var TempCity = "$c(1)" + OldCity + "$c(2)"
		var myval = myCombAry["ProvinceBirth"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
		///alert(myBaseData);
		myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempCity).length > 1) {
		myCombAry[myItemName].setComboValue(OldCity);
	}
	//var myval = myCombAry[myItemName].getSelectedValue();
	//var myary = myval.split("^");
	//var myCityDR = myary[0];
	
	//GetCityZipInfo("", myCityDR, "");
}
function CityBirth_OnChange() {
	
	var myItemName = "CityBirth";
	var myval = myCombAry[myItemName].getSelectedValue();
	var myary = myval.split("^");
	var myCityDR = myary[0];
	myCombAry["AreaBirth"].setComboText("");
	//GetCityZipInfo("", myCityDR, "");
	GetCityAreaInfo(myCityDR,"AreaBirth");
}
function CityHouse_OnFocus() {
	var myItemName = "Cityhouse";
	var mytabName = "CTCITY";
	var OldCity = myCombAry[myItemName].getSelectedValue();
	var TempCity = "$c(1)" + OldCity + "$c(2)"
		var myval = myCombAry["ProvinceHouse"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
		///alert(myBaseData);
		myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempCity).length > 1) {
		myCombAry[myItemName].setComboValue(OldCity);
	}
	var myval = myCombAry[myItemName].getSelectedValue();
	var myary = myval.split("^");
	var myCityDR = myary[0];
	
	//GetCityZipInfo("", myCityDR, "","PostCodeHouse");
}
function CityHouse_OnChange() {
	
	var myItemName = "Cityhouse";
	var myval = myCombAry[myItemName].getSelectedValue();
	var myary = myval.split("^");
	var myCityDR = myary[0];
	myCombAry["AreaHouse"].setComboText("");
	//DHCWebD_SetObjValueA("PostCodeHouse", "");
	//myCombAry["PostCodeHouse"].setComboText("");
	//GetCityZipInfo("", myCityDR, "","PostCodeHouse");
	GetCityAreaInfo(myCityDR,"AreaHouse");
}
function CityHome_OnFocus() {
	var myItemName = "CityHome";
	var mytabName = "CTCITY";
	var OldCity = myCombAry[myItemName].getSelectedValue();
	var TempCity = "$c(1)" + OldCity + "$c(2)"
		var myval = myCombAry["ProvinceHome"].getSelectedValue();
	var myary = myval.split("^");
	var myQueryInfo = myary[0];
	var myBaseData = GetListData(mytabName, myQueryInfo);
	var TempInfo = "$c(1)" + myBaseData
		///alert(myBaseData);
		myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	if (TempInfo.split(TempCity).length > 1) {
		myCombAry[myItemName].setComboValue(OldCity);
	}
	
}
function GetCityZipInfo(ProvinceDR, CityDR, CityAreaDR,myItemName) {
	///ProvinceDR , CityDR , CityAreaDR
	//var myItemName = "Zip";
	var mytabName = "CTZIP";
	var myQueryInfo = ProvinceDR + "^" + CityDR + "^" + CityAreaDR;
	var myBaseData = GetListData(mytabName, myQueryInfo);
	if (myBaseData.split("$c(2)").length>1){
		var Code=myBaseData.split("$c(2)")[1];
		DHCWebD_SetObjValueA(myItemName, Code);
	}
	//myCombAry[myItemName]._putattr(myBaseData);
	//myCombAry[myItemName].enableFilteringMode(true);
	
}
function GetCityAreaInfo(CityDR,myItemName) {
	///ProvinceDR , CityDR , CityAreaDR
	//var myItemName = "CTArea";
	var mytabName = "CTCITYAREA";
	var myQueryInfo = CityDR;
	var myBaseData = GetListData(mytabName, myQueryInfo);
	myCombAry[myItemName]._putattr(myBaseData);
	myCombAry[myItemName].enableFilteringMode(true);
	
}
function IntHelpControlNew()
{
	var myPreStr= m_CombDataIdxPre.join("^");
	myPreStr = "^"+myPreStr+"^"
	var myTpye="";
	for(var myIdx=1;myIdx<myCombNameAry.length;myIdx++){
		var myobj=document.getElementById(myCombNameAry[myIdx]);
		if ((myobj)&&(myCombNameAry[myIdx]!="CardTypeDefine")){
			myCombAry[myCombNameAry[myIdx]].setComboValue("");
			myCombAry[myCombNameAry[myIdx]].setComboText("");
		}
	}
	myCombAry["SecretLevel"].setComboValue("");
	myCombAry["SecretLevel"].setComboText("");
	myCombAry["PoliticalLevel"].setComboValue("");
	myCombAry["PoliticalLevel"].setComboText("");
}
function IntHelpControl()
{
	var myPreStr= m_CombDataIdxPre.join("^");
	myPreStr = "^"+myPreStr+"^"
	var myTpye="";
	for(var myIdx=1;myIdx<myCombNameAry.length;myIdx++){
		
		
		var myobj=document.getElementById(myCombNameAry[myIdx]);
		
		if (myobj){
			///alert(myobj.type);
			///myTpye=
			myobj.setAttribute("isDefualt","true");		///
			var myStrIdx = m_CombDataIdxPre.indexOf(myCombNameAry[myIdx]);
			if (isNaN(myStrIdx)){myStrIdx=-1;}
			
			if (parseInt(myStrIdx)>=0){
			}else{
				myobj.setAttribute("isPre","true");
			}
			
			switch (myobj.type){
				case "select-one":
					//myCombAry[myCombNameAry[myIdx]]=dhtmlXComboFromSelect(myCombNameAry[myIdx]);
					
					myCombAry[myCombNameAry[myIdx]]=new dhtmlXComboFromSelect(myCombNameAry[myIdx]);
					myCombAry[myCombNameAry[myIdx]].setXmlTag(m_CombXmlTagAray[myIdx]);
					
					myCombAry[myCombNameAry[myIdx]].enableFilteringMode(true);
					//var myrtn=(myCombAry[myCombNameAry[myIdx]].getSelectedValue());
					//alert(myrtn);
					break;
				case "select-multiple":
					myCombAry[myCombNameAry[myIdx]]=new dhtmlXComboFromSelect(myCombNameAry[myIdx]);
					
					myCombAry[myCombNameAry[myIdx]].setXmlTag(m_CombXmlTagAray[myIdx]);
					myCombAry[myCombNameAry[myIdx]].enableFilteringMode(true);
					///alert(myCombAry[myCombNameAry[myIdx]].getXmlTag);
					//var myrtn=(myCombAry[myCombNameAry[myIdx]].getSelectedValue());
					break;
				case "text":
					
					break;
				default:
					break;
			}
			
		}
	}
	var myobj=document.getElementById("ProvinceInfo");
	if (myobj){
		myCombAry["ProvinceInfo"]=new dhtmlXComboFromSelect("ProvinceInfo","");
		myCombAry["ProvinceInfo"].DOMelem_input.onfocus=ProvinceInfo_OnFocus;	
			myCombAry["ProvinceInfo"].selectlistchange = ProvinceInfo_OnChange;
	}
	var myobj = document.getElementById("ProvinceHome");
	if (myobj) {
		myCombAry["ProvinceHome"] = new dhtmlXComboFromSelect("ProvinceHome", "");
		myCombAry["ProvinceHome"].DOMelem_input.onfocus = ProvinceHome_OnFocus;
		myCombAry["ProvinceHome"].selectlistchange = ProvinceHome_OnChange;
	}
	var myobj = document.getElementById("ProvinceBirth");
	if (myobj) {
		myCombAry["ProvinceBirth"] = new dhtmlXComboFromSelect("ProvinceBirth", "");
		myCombAry["ProvinceBirth"].DOMelem_input.onfocus = ProvinceBirth_OnFocus;
		myCombAry["ProvinceBirth"].selectlistchange = ProvinceBirth_OnChange;
	}
	var myobj = document.getElementById("ProvinceHouse");
	if (myobj) {
		myCombAry["ProvinceHouse"] = new dhtmlXComboFromSelect("ProvinceHouse", "");
		myCombAry["ProvinceHouse"].DOMelem_input.onfocus = ProvinceHouse_OnFocus;
		myCombAry["ProvinceHouse"].selectlistchange = ProvinceHouse_OnChange;
	}
	
	var myobj = document.getElementById("CityDesc");
	if (myobj) {
		myCombAry["CityDesc"] = new dhtmlXComboFromSelect("CityDesc", "");
		myCombAry["CityDesc"].DOMelem_input.onfocus = CityDescInfo_OnFocus;
		myCombAry["CityDesc"].selectlistchange = CityDescInfo_OnChange;
	}
	var myobj = document.getElementById("CityHome");
	if (myobj) {
		myCombAry["CityHome"] = new dhtmlXComboFromSelect("CityHome", "");
		myCombAry["CityHome"].DOMelem_input.onfocus = CityHome_OnFocus;
	}
	var myobj = document.getElementById("CityBirth");
	if (myobj) {
		myCombAry["CityBirth"] = new dhtmlXComboFromSelect("CityBirth", "");
		myCombAry["CityBirth"].DOMelem_input.onfocus = CityBirth_OnFocus;
		myCombAry["CityBirth"].selectlistchange = CityBirth_OnChange;
	}
	var myobj = document.getElementById("Cityhouse");
	if (myobj) {
		myCombAry["Cityhouse"] = new dhtmlXComboFromSelect("Cityhouse", "");
		myCombAry["Cityhouse"].DOMelem_input.onfocus = CityHouse_OnFocus;
		myCombAry["Cityhouse"].selectlistchange = CityHouse_OnChange;
	}
	var myobj = document.getElementById("CTArea");
	if (myobj) {
		myCombAry["CTArea"] = new dhtmlXComboFromSelect("CTArea", "");
		myCombAry["CTArea"].enableFilteringMode(true);
		//myCombAry["CTArea"].DOMelem_input.onfocus = CTArea_OnFocus;
		//myCombAry["CTArea"].selectlistchange = CTArea_OnChange;
	}
	var myobj = document.getElementById("AreaBirth");
	if (myobj) {
		myCombAry["AreaBirth"] = new dhtmlXComboFromSelect("AreaBirth", "");
		myCombAry["AreaBirth"].enableFilteringMode(true);
		//myCombAry["CTArea"].DOMelem_input.onfocus = CTArea_OnFocus;
		//myCombAry["CTArea"].selectlistchange = CTArea_OnChange;
	}
	var myobj = document.getElementById("AreaHouse");
	if (myobj) {
		myCombAry["AreaHouse"] = new dhtmlXComboFromSelect("AreaHouse", "");
		myCombAry["AreaHouse"].enableFilteringMode(true);
		//myCombAry["CTArea"].DOMelem_input.onfocus = CTArea_OnFocus;
		//myCombAry["CTArea"].selectlistchange = CTArea_OnChange;
	}
	var myobj = document.getElementById("Zip");
	if (myobj) {
		myCombAry["Zip"] = new dhtmlXComboFromSelect("Zip", "");
		myCombAry["Zip"].enableFilteringMode(true);
	}
	/*
	var myobj = document.getElementById("PostCodeHouse");
	if (myobj) {
		myCombAry["PostCodeHouse"] = new dhtmlXComboFromSelect("PostCodeHouse", "");
		myCombAry["PostCodeHouse"].enableFilteringMode(true);
	}
	*/
	var mydata = DHCWebD_GetObjValue("CTCountryData");
	var myobj = document.getElementById("CountryDesc");
	if (myobj) {
		myCombAry["CountryDesc"] = new dhtmlXComboFromSelect("CountryDesc", mydata);
		myCombAry["CountryDesc"].enableFilteringMode(true);
		myCombAry["CountryDesc"].selectlistchange = CountryDesc_OnChange;
	}
	var myobj = document.getElementById("CountryHome");
	if (myobj) {
		myCombAry["CountryHome"] = new dhtmlXComboFromSelect("CountryHome", mydata);
		myCombAry["CountryHome"].enableFilteringMode(true);
		myCombAry["CountryHome"].selectlistchange = CountryHome_OnChange;
	}
	var myobj = document.getElementById("CountryBirth");
	if (myobj) {
		myCombAry["CountryBirth"] = new dhtmlXComboFromSelect("CountryBirth", mydata);
		myCombAry["CountryBirth"].enableFilteringMode(true);
		myCombAry["CountryBirth"].selectlistchange = CountryBirth_OnChange;
	}
	var myobj = document.getElementById("CountryHouse");
	if (myobj) {
		myCombAry["CountryHouse"] = new dhtmlXComboFromSelect("CountryHouse", mydata);
		myCombAry["CountryHouse"].enableFilteringMode(true);
		myCombAry["CountryHouse"].selectlistchange = CountryHouse_OnChange;
	}
	var mydata = DHCWebD_GetObjValue("CTNationData");
	var myobj = document.getElementById("NationDesc");
	if (myobj) {
		myCombAry["NationDesc"] = new dhtmlXComboFromSelect("NationDesc", mydata);
		myCombAry["NationDesc"].enableFilteringMode(true);
	}
	//CTCTRelationData
	var mydata = DHCWebD_GetObjValue("CTCTRelationData");
	var myobj = document.getElementById("CTRelationDR");
	if (myobj) {
		myCombAry["CTRelationDR"] = new dhtmlXComboFromSelect("CTRelationDR", mydata);
		myCombAry["CTRelationDR"].enableFilteringMode(true);
	}
	var mydata = DHCWebD_GetObjValue("CTOccuptionData");
	var myobj = document.getElementById("Vocation");
	if (myobj) {
		myCombAry["Vocation"] = new dhtmlXComboFromSelect("Vocation", mydata);
		myCombAry["Vocation"].enableFilteringMode(true);
	}
	
	var myobj=myCombAry["CardTypeDefine"];
	if (myobj){
		
		myobj.selectlistchange=CardTypeDefine_OnChange;
	}

	var myobj=myCombAry["PayMode"];
	if (myobj){
		myobj.selectlistchange=PayModeObj_OnChange;
	}
	var myobj=myCombAry["PatType"];
	if (myobj){
		myobj.selectlistchange=PatTypeObj_OnChange;
	}
	///alert(myCombAry["Sex"].getXmlString());
	
	//婚姻状况
  	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","CTMarital","");
	var myobj=document.getElementById("PAPERMarital");
	if (myobj){
		myCombAry["PAPERMarital"]=new dhtmlXComboFromSelect("PAPERMarital",mydata);
		myCombAry["PAPERMarital"].enableFilteringMode(true);
	}
	//病人级别
  	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","PoliticalLevel","");
	var myobj=document.getElementById("PoliticalLevel");
	if (myobj){
		myCombAry["PoliticalLevel"]=new dhtmlXComboFromSelect("PoliticalLevel",mydata);
		myCombAry["PoliticalLevel"].enableFilteringMode(true);
	}
	//病人密级
  	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","SecretLevel","");
	var myobj=document.getElementById("SecretLevel");
	if (myobj){
		myCombAry["SecretLevel"]=new dhtmlXComboFromSelect("SecretLevel",mydata);
		myCombAry["SecretLevel"].enableFilteringMode(true);
	}
	//合同单位
	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","HCPDR","");
	var myobj=document.getElementById("HCPDR");
	if (myobj){
		myCombAry["HCPDR"]=new dhtmlXComboFromSelect("HCPDR",mydata);
		myCombAry["HCPDR"].enableFilteringMode(true);
	}
}

function GetListData(tabName, QueryInfo)
{
	var myBData="";
	var myEncrpt=DHCWebD_GetObjValue("ReadCTBaseEncrypt");
	if (myEncrpt!=""){
		myBData=cspRunServerMethod(myEncrpt, tabName, QueryInfo);
	}
	return myBData;
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
		var mycredobj=document.getElementById("CredNo");
		var myidobj=document.getElementById('IDCardNo1');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
		}
		SetIDCredType();
		IDReadControlDisable(true);
		Birth_OnBlur();
	}
	//使用读取得照片数据文件
	var photoobj=document.getElementById("PhotoInfo");
	if ((photoobj)&&(photoobj.value!="")){var src="data:image/png;base64,"+photoobj.value}
	else{var src='c://'+mycredobj.value+".bmp"}
	ShowPicBySrcNew(src,"imgPic");
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


function Doc_OnKeyDown(e){
	///alert(event.keyCode);
	///var eSrc=window.event.srcElement;
	var eSrc=websys_getSrcElement(event);
	var key=websys_getKey(eSrc);
	if (key==13) {
		var myComName=eSrc.id;
		var myComIdx=myCombNameAry.indexOf(myComName);
		if (myComIdx>=0){
			websys_nexttab(eSrc.tabIndex);
		}else{
			m_NextFocusFlag=true;
		}
	}
	
	if (((event.altKey)&&((event.keyCode==82)||(event.keyCode==114))))
	{
		////Alt+R
		///document.onkeydown=function(){return false;}
		
		//add by zhouzq 2010.11.12 如果读卡按钮置为false就不应该响应快捷键
		var obj=document.getElementById("ReadCard");
		if (obj.disabled==true)	return;
		
		DHCWeb_DisBtnA("ReadCard");
		ReadMagCard_Click();
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadMagCard_Click;
		}
		///document.onkeydown=Doc_OnKeyDown;
	}
	
	if ((event.keyCode==119)){
		ReadRegInfo_OnClick();
	}
	///F10
	if ((event.keyCode==121)){
		ReadFirstID_Onclick();
	}
	if (event.keyCode==118){
		Clear_click();
	}else if(event.keyCode==120) {
		CardSearch_Click();
	}
	if (((event.altKey)&&((event.keyCode==67)||(event.keyCode==99))))
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
	keyDownSearchCard(e)
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
	var LimitAge=DHCWebD_GetObjValue("LimitAge");
	var myage = DHCWebD_GetObjValue("Age");
	if (((myage.indexOf("岁")!=-1)||(!isNaN(myage)))&&(myage!="")){
		//if (isNaN(myage)){myage=0;}
		if (parseInt(myage)>=parseInt(LimitAge)){
			alert("年龄不能超过"+LimitAge+"岁");
			DHCWebD_SetObjValueA("Birth","");
			return;
		}
	}
	var rtn=tkMakeServerCall("web.DHCDocCommon","GetBirthDateByAge",myage)
	DHCWebD_SetObjValueA("Birth", rtn)
	var obj=document.getElementById("Birth");
	obj.className='';
	/*var mybirth=DHCWebD_GetObjValue("Birth");
	var myBirth=DHCWeb_GetBirthDayFromAge("Age");
	if (mybirth==""){
		DHCWebD_SetObjValueA("Birth", myBirth);
	}else{
		var myage = DHCWebD_GetObjValue("Age");
		if (myage!=""){
			if (isNaN(myage)){myage=0;}
			var mynow = new Date();
	    var yy = mynow.getFullYear();
			var myYear=yy-myage;
			var myMDInfo = mybirth.substring(4, mybirth.length);
			DHCWebD_SetObjValueA("Birth", myYear+""+myMDInfo);
		}
	}*/
}
function Age_OnKeypress(){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	//过滤"." 年龄计算会错误
	if (keycode==46){window.event.keyCode=0;return websys_cancel();}
	if (((keycode>47)&&(keycode<58))||(keycode==46)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}	
}


function TelHome_OnKeypress(){
	this.value=this.value.replace(/[^\x00-\xff]/g,'');

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


function BirthkeydownHander(){
	var mybirth=DHCWebD_GetObjValue("Birth");
	
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("Birth");
		alert("请输入正确的日期");
		///websys_setfocus("Birth");
		return websys_cancel();
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		if (dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
		
		DHCWebD_SetObjValueA("Birth",mybirth);
	}
	////alert(mybirth);
	if (dtformat=="YMD"){
		var myrtn=DHCWeb_IsDate(mybirth,"-")
	}
	if (dtformat=="DMY"){
		var myrtn=DHCWeb_IsDate(mybirth,"/")
	}
	if (!myrtn){
		var obj=document.getElementById("Birth");
		////obj.className='clsInvalid';
		alert("请输入正确的日期");
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

}
function BirthTime_OnBlur()
{
	var mybirth=DHCWebD_GetObjValue("Birth");
	if(mybirth=="") return false;
	var mybirthTime=DHCWebD_GetObjValue("BirthTime");
	if(mybirthTime=="") return false;
	var eSrc=document.getElementById('BirthTime')
	if (!IsValidTime(eSrc)) {
		alert("请输入正确的出生日期!");
		eSrc.focus();
		return false;
	}
	//var regTime = /^([0-2][0-9]):([0-5][0-9]):([0-5][0-9])$/;
	//if (!regTime.test(myBirthTime)) {
	
	var myage = DHCWebD_GetObjValue("Age");
	//if ((myage=="0分")||(myage=="1天")){
		var ageStr=tkMakeServerCall("web.UDHCJFCOMMON","DispPatAge",mybirth,"",mybirthTime,"","N");
		var ageStr=ageStr.split("||")[0]
		DHCWebD_SetObjValueA("Age",ageStr);
	//}
}

function Birth_OnBlur()
{ 
	///清屏的时候不在处理
	var Obj=GetEventElementObj()
	if (Obj.name=="Clear"){return websys_cancel();}
	var mybirth=DHCWebD_GetObjValue("Birth");
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("Birth");
		obj.className='clsInvalid';
		alert("请输入正确的日期");
		//websys_setfocus("Birth");
		return websys_cancel();
	}
	var obj=document.getElementById("Birth");
	obj.className='';
	if ((mybirth.length==8)){
		if (dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
		DHCWebD_SetObjValueA("Birth",mybirth);
	}

	if (mybirth!="") {
		if (dtformat=="YMD"){
			var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		}
		if (dtformat=="DMY"){
			var reg=/^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		}
		var ret=mybirth.match(reg);
	  if(ret==null)
	  {alert("请输入正确的日期");websys_setfocus("Birth");return websys_cancel();}
	  if (dtformat=="YMD"){
		  var myrtn=DHCWeb_IsDate(mybirth,"-")
	  }
	  if (dtformat=="DMY"){
		  var myrtn=DHCWeb_IsDate(mybirth,"/")
	  }
		if (!myrtn){
			var obj=document.getElementById("Birth");
			obj.className='clsInvalid';
			alert("请输入正确的日期");
			websys_setfocus("Birth");
			return websys_cancel();
		}else{
			var mybirth1=DHCWebD_GetObjValue("Birth");
			var Checkrtn=CheckBirth(mybirth1);
			if(Checkrtn==false){
				alert('出生日期不能大于今天或者小于、等于1840年!');
				websys_setfocus("Birth");
				return websys_cancel();
			}
			/*var mybirthTime=DHCWebD_GetObjValue("BirthTime")
			var ageStr=tkMakeServerCall("web.UDHCJFCOMMON","DispPatAge",mybirth,"",mybirthTime,"","N");
			var ageStr=ageStr.split("||")[0]
			DHCWebD_SetObjValueA("Age",ageStr);	*/	
			var myAge=DHCWeb_GetAgeFromBirthDay("Birth");
			DHCWebD_SetObjValueA("Age",myAge);
		}
	}else{
		var obj=document.getElementById("Birth");
		obj.className='clsvalid';
	}
	var objname=document.getElementById('Name');
	var name=objname.value;
	var objsex=document.getElementById('Sex');
	var sex=objsex.value;
	var objBirth=document.getElementById('Birth');
	var birth=objBirth.value;
	SearchSamePatient();
	/*
	*使用SearchSamePatient()方法,显示在本页面另外一个组件中
	
	var encmeth=DHCWebD_GetObjValue("CheckRegister");
	if (encmeth!=""){
		var find=cspRunServerMethod(encmeth,name,sex,birth);
		if (find>=2)
		{
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch&Name="+name+"&BirthDay="+birth;
			win=websys_createWindow(lnk,"UDHCCardPatInfoRegExpFind","scrollbars=1,top=150,left=1,width=1000,height=400");
		}
	}
	**/
}
function CheckBirth(Birth)
{
	var Year,Mon,Day,Str;
	if (dtformat=="YMD"){
		Str=Birth.split("-")
		Year=Str[0];
		Mon=Str[1];
		Day=Str[2];
	}
	if (dtformat=="DMY"){
		Str=Birth.split("/")
		Year=Str[2];
		Mon=Str[1];
		Day=Str[0];
	}
	
	var Today,ToYear,ToMon,ToDay;
	Today=new Date();
	ToYear=Today.getFullYear();
	ToMon=(Today.getMonth()+1);
	ToDay=Today.getDate();
	if((Year > ToYear)||(Year<=1840)){
		return false;
	}
	else if((Year==ToYear)&&(Mon>ToMon)){
		return false;
	}
	else if((Year==ToYear)&&(Mon==ToMon)&&(Day>ToDay)){
		return false;
	}
	else {
		return true;
		}
}
function InMedicare_OnBlur(e) {
	var myInMedicare = DHCWebD_GetObjValue("InMedicare");
	if (myInMedicare.split('M').length > 1) {
		DHCWebD_SetObjValueA("InMedicare",myInMedicare.split('M')[0]);
	}
	SearchSamePatient();
}

function ReadMagCard_Click()
{
	//m_CCMRowID  == HardType
	//var rtn=DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	
	var myVersion=DHCWebD_GetObjValue("DHCVersion");
	if (myVersion=="12"){
		M1Card_InitPassWord();
   }
	var rtn=DHCACC_ReadMagCard(m_CCMRowID,"R", "2");
	
	var myary=rtn.split("^");
	if (myary[0]=='0'){
		DHCWebD_SetObjValueB("CardNo",myary[1]);
		CardVerify=myary[2];
		m_CardValidateCode=myary[2];
		m_CardSecrityNo=myary[2];
		GetValidatePatbyCard();
	}
}

function GetValidatePatbyCard()
{
	var myCardNo=DHCWebD_GetObjValue("CardNo");
	if (myCardNo=="") {alert(t["BlankTip"]);return;}
	
	var encmeth=DHCWebD_GetObjValue("getpatbyCardNoClass");
	if (encmeth!=""){
		var myExpStr="";
		var rtn=cspRunServerMethod(encmeth, myCardNo, CardVerify, m_SelectCardTypeRowID, myExpStr);
		///Flag^XMLStr
		var myary=rtn.split("^");
		if (rtn=="") return;
		if (myary[0]=='0')
		{
			var myXMLStr=myary[1];
			//InitPatRegConfig();
			DHCWebD_SetObjValueB("CardNo",myCardNo)
			SetPatInfoByXML(myXMLStr);
			var Obj=document.getElementById('NewCard');
			if (Obj) {
				DHCC_AvailabilityBtn(Obj)
				Obj.onclick = NewCard_click;
			}
			//alert(m_SetFocusElement);
			//websys_setfocus(m_SetFocusElement);
			if (m_SetRCardFocusElement!=""){
				websys_setfocus(m_SetRCardFocusElement);
			}
		}else{
			switch(myary[0]){
			case "-341": //已经建卡
				//经过讨论如果已经建卡的不带出已有信息。lxz
				var obj=document.getElementById('CardNo');
				var CardNo=obj.value
			    IntListItemNew();
			    InitTextItem();
			    IntHelpControlNew();
			    var obj=document.getElementById('CardNo');
			    obj.value=CardNo
				var myPAPMIStr=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetPAPMIInfoByCardNo",myCardNo,m_SelectCardTypeRowID);
				if (myPAPMIStr!="") {
					DHCWebD_SetObjValueB("PAPMINo",myPAPMIStr.split("^")[1]);
					DHCWebD_SetObjValueB("PAPMIRowID",myPAPMIStr.split("^")[0]);
					DHCWebD_SetObjValueB("CardNo", "");
					GetPatDetailByPAPMINo();
					SearchSamePatient();
				}
				CardTypeDefine_OnChange();
				if (MedicalFlag != 1) {
					/*
					if (!confirm("此卡已经发出,是否使用卡内信息覆盖当前界面信息?")){
						DHCWebD_SetObjValueB("CardNo", "");
						return false;
					}
					*/
				} else {
					var flag = ValidateRegInfoByCQU(myary[2]);
					if (flag) {
						var Obj = document.getElementById('NewCard');
						if (Obj) {
							DHCC_AvailabilityBtn(Obj);
							Obj.onclick = NewCard_click;
							return true;
						}
					}
					
				}
				alert(t[2024]);
				break;
			case "-340":
				alert(t[2003]);
				break;
			case "-350":
				alert(t["-350"]);
				break;
			case "-351":
				//alert(t["-351"]);
				var CancelInfo=tkMakeServerCall("web.UDHCAccManageCLS7","GetCancenlInfo",myCardNo,m_SelectCardTypeRowID)
				alert(t["-351"]+",挂失人:"+CancelInfo.split("^")[0]+",挂失原因:"+CancelInfo.split("^")[1]);
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
		DHCC_AvailabilityBtn(Obj);
		Obj.onclick = NewCard_click;
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
	//alert(m_CardRefFlag+"^"+m_OverWriteFlag)
	//如果是修改病人基本信息不再设置写卡。
	if (MedicalFlag!="1")
	{
	if (m_CardRefFlag=="Y")
	{
		if (m_OverWriteFlag=="Y"){
			///设置写卡
			var myrtn=WrtCard();
			var myary=myrtn.split("^");
			if (myary[0]!="0"){
				EnableNewCard();
				return;
			}
			var mySecrityNo=myary[1];
		}else{
			var mySecrityNo = m_CardSecrityNo;
		}
	}
	}
	
	//mySecrityNo="123456789"    //   没有读卡器,暂时写死 2008.7.3
	var Password="000000";
	if (m_AccManagerFlag=="Y")
	{
		var myDefaultPWDFlag=DHCWebD_GetObjValue("SetDefaultPassword");
		if (myDefaultPWDFlag)
		{	
		  //	var ren=DHCACC_GetValidatePWDOld(mySecrityNo);
			var ren=DHCACC_GetValidatePWD(Password);
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
	var myConfigInfo = m_RegCardConfigXmlData;
	
	var mySpecInfo=mySecrityNo;
	mySpecInfo += "^"+Password;
	var myExpStr="";
	var myExpStr = MedicalFlag+"^"+UsePANoToCardNO+"^"+session['LOGON.HOSPID'];
	var encmeth=DHCWebD_GetObjValue("NewCardClass");
	if (encmeth!=""){
		//alert(myPatInfo);多余 mypatInfo xml字符流
		var rtn=cspRunServerMethod(encmeth, myConfigInfo, myPatInfo, myCardInfo, myAccInfo, myAccDepInfo, myCardInvInfo, mySpecInfo, myExpStr);
		//alert(rtn);多余
		var myary=rtn.split(String.fromCharCode(1));
		if (myary[0]=='0')
		{
			////根据配置设置打印
			////发卡时收费票据打印的RowID
			if (myary[1]!=""){
			  var myCardCost=DHCWebD_GetObjValue("CardFareCost");
			  var myCardCost=parseFloat(myCardCost)             //转化正数字类型
			  if ((myCardCost>0)&&(myCardCost!="")){
				PatRegPatInfoPrint(myary[1],m_CardINVPrtXMLName,"ReadCardINVEncrypt");
				}
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
						///alert(myary[2]+"^"+PrtXMLName)
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
			// 上传身份证照片到服务器 Start
			/*
			var mycredobj=document.getElementById("CredNo");
			if (mycredobj) {
				ChangeStrToPhotoNew(myary[4],mycredobj.value);
			}
			*/
			// 上传身份证照片到服务器 End
			if (ModifiedFlag==1){alert("信息修改成功.");return}else if (MedicalFlag==1){alert("建病历成功.");return}
			
			alert(t[2013]);
			
			//使用后台返回的卡号和登记号处理界面值，如果是登记号作为卡号的打印登记号
			var CardNo=DHCWebD_GetObjValue("CardNo");
			if (CardNo==""){
				DHCWebD_SetObjValueB("CardNo",myary[7]);
			}
			var PAPMINo=DHCWebD_GetObjValue("PAPMINo");
			if (PAPMINo==""){
				DHCWebD_SetObjValueB("PAPMINo",myary[6]);
			}
			if (UsePANoToCardNO=="Y"){
				PatInfoPrint("PAPMINo");
			}
			var par_win = parent.window.opener;
			if (par_win){
				var CardNo=DHCWebD_GetObjValue("CardNo");
		    try{
					if ((par_win)&&(CardNo!='')){
						par_win.SetPassCardNo(CardNo,m_SelectCardTypeRowID);
					}
		    }catch(e){
            //  alert(e.message)
        }
		 		window.setTimeout("parent.window.close();",500);
		 		return		
			}
			Clear_click();
		}
		else if (myary[0]=='-302')
			{alert(t[2025]);}
		else if (myary[0]=='-303')
			{alert(t[2002]);}
		else if (myary[0]=='-304')
			{alert(t[2024]);}
		else if(myary[0]=='-365'){
			alert(t["-365"]);
		}
		else if(myary[0]=='-366'){
			alert(t["-366"]);
		}
		else if(myary[0]=='-367'){
			alert(t["-367"]);
		}
		else if(myary[0]=='-369'){
			alert(t["-369"]);
		}else if(myary[0]=='-364'){
			alert(t["-364"]);
		}else if(myary[0]=='-341'){
			alert(t["-341"]);
		}else{
			alert("Error Code: "+myary[0]+"  "+t[2015]);
		}
		if (myary[0]!='0'){
			EnableNewCard();
		}
	}
}

function IsCredTypeID()
{
	var myval=myCombAry["CredType"].getSelectedValue();
	var myary = myval.split("^");
	if (myary[1]==m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
}

//// Set ID type
function SetIDCredType()
{
	if (!myCombAry["CredType"]){
		return;
	}
	
	for(var i=0;i<myCombAry["CredType"].optionsArr.length;i++)
	{
		var myOpt=myCombAry["CredType"].getOptionByIndex(i);
		
		var myVal=myOpt.data()[0];
		var myary = myVal.split("^");
		if (myary[1]==m_IDCredTypePlate){
			myCombAry["CredType"].setComboValue(myVal);
			return true;
		}
	}
}


function CheckData(){
	var myrtn=true;
	var myExpstr="";
	//患者证件类型为身份证时，验证身份证号是否已经存在患者信息，如果存在则更新患者信息
	var myIDrtn=IsCredTypeID();
	if (myIDrtn){
		var CredNo=DHCWebD_GetObjValue("CredNo");
		if (CredNo!=""){
			myExpstr=CredNo;
		}
	}
	var myPAPMINo=DHCWebD_GetObjValue('PAPMINo');
	if ((myPAPMINo!="")||(myExpstr!="")){
		var myencmeth=DHCWebD_GetObjValue("GetPatDetailByNo");
		if (myencmeth!=""){
			var myPatInfo=cspRunServerMethod(myencmeth,myPAPMINo,myExpstr);
			var myary=myPatInfo.split("^");
			if (myary[0]=="2001"){
				alert(t["2001"]+",不能建卡!")
				websys_setfocus('PAPMINo');
				return false;
			}else if (myary[0]=="0"){
				var myXMLStr=myary[1];
				var obj=document.getElementById("PAPMIRowID");
				var PatientID=myXMLStr.split("<PAPMIRowID>")[1].split("</PAPMIRowID>")[0];
				if (PatientID!=""){
				    if (obj) obj.value=PatientID
				}else{
					if (obj) obj.value="";
				}
			}/*else if (myary[0]=="-353"){
				alert(t["-353"]+",不能建卡!");
				websys_setfocus('PAPMINo');
				return false;
			}else{
				alert("Error Code: " + myary[0]+",不能建卡!");
				websys_setfocus('PAPMINo');
				return false;
			}*/
		}
	}
	var obj=document.getElementById("PAPMIRowID");
	var InsuNo=document.getElementById('PatYBCode').value;
	//医保手册号
	if ((InsuNo!="")&&(InsuNo!="99999999999S")) {
		var Rtn=tkMakeServerCall("web.DHCBL.Patient.DHCPatient","PatUniInfoQuery",obj.value,"InsuNo",InsuNo);
		if(Rtn>0){	
			alert(InsuNo+"医保号已被使用!");
			websys_setfocus('PatYBCode');	
			return false
		}
	}
	var OpMedicareObj=document.getElementById('OpMedicare');
	
	if (m_PatMasFlag=="Y")
	{
		var myBirthTime=DHCWebD_GetObjValue("BirthTime");
		if (myBirthTime!=""){
			 var regTime = /^([0-2][0-9]):([0-5][0-9]):([0-5][0-9])$/;
			 if (!regTime.test(myBirthTime)) {
				 alert("请输入正确的出生时间!")
				 websys_setfocus('BirthTime');
				 return false;
			 }
		}
		var myTelHome=DHCWebD_GetObjValue("TelHome");
		if (myTelHome=="")
		{
			alert(t["TeleHomeNull"]);
			websys_setfocus('TelHome');
			return false;
		}else{
			/*if (myTelHome.indexOf('-')>=0){
				if(myTelHome.length<12){
					alert("固定电话长度错误!")
					websys_setfocus('TelHome');
			        return false;
				}
			}else{
				if(myTelHome.length<11){
					alert("联系电话电话长度错误!")
					websys_setfocus('TelHome');
			        return false;
				}
			}*/
			if (!CheckTelOrMobile(myTelHome,"TelHome","")) return false;
		}
		var myMobPhone=DHCWebD_GetObjValue("MobPhone");
		if (myMobPhone!=""){
			if(myMobPhone.length!="11"){
				alert("手机号码长度错误,应为【11】位,请核实!")
				websys_setfocus('MobPhone');
			    return false;
			}
		}
		var myName=DHCWebD_GetObjValue("Name");
		if (myName=="")
		{
			alert(t["noname"]);
			websys_setfocus('Name');
			return false;
		}
		
		var myBirth=DHCWebD_GetObjValue("Birth");
		if (myBirth==""){
			alert(t["BirthTip"]);
	   		websys_setfocus('Birth');
	   		return false;
		}else{
		 if (dtformat=="YMD"){
			var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		}
		if (dtformat=="DMY"){
			var reg=/^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		}
		 var ret=myBirth.match(reg);
	     if(ret==null)
	     {
		    alert("请输入正确的日期");
	        websys_setfocus("Birth");
	        return websys_cancel();
	      }
	      if (dtformat=="YMD"){
		      var myrtn=DHCWeb_IsDate(myBirth,"-")
		  }
		  if (dtformat=="DMY"){
		      var myrtn=DHCWeb_IsDate(myBirth,"/")
		  }
		  if (!myrtn){
			var obj=document.getElementById("Birth");
			obj.className='clsInvalid';
			alert("请输入正确的日期");
			websys_setfocus("Birth");
			return websys_cancel();
		   }else{
			var mybirth1=DHCWebD_GetObjValue("Birth");
			var Checkrtn=CheckBirth(mybirth1);
			if(Checkrtn==false){
				alert('出生日期不能大于今天或者小于、等于1840年!');
				websys_setfocus("Birth");
				return websys_cancel();
			}		
		   }
		}
		var mySex=DHCWebD_GetObjValue("Sex");
		if (myCombAry["Sex"].getSelectedValue()=="") mySex="";

		if (mySex=="")
		{
			alert(t["noSex"]);
			websys_setfocus('Sex');
			return false;
		}
		
		
		var myPatType= DHCWebD_GetObjValue("PatType");
		var myobj=document.getElementById("PatType");
	    if(myobj) var myPatType=myCombAry["PatType"].getSelectedValue();
		
		if (myPatType=="")
		{
			alert(t["noPatType"]);
			websys_setfocus('PatType');
			return false;
		}
		//仅建病历下列提示信息为必填
	  if ((MedicalFlag==1)&&(ModifiedFlag==0)) {
			var myAddress = DHCWebD_GetObjValue("Address");
			if (myAddress == "") {
				alert("没有地址,请填写地址");
				websys_setfocus('Address');
				return false;
			}
			var myCountryDesc = DHCWebD_GetObjValue("CountryDesc");
			if (myCountryDesc == "") {
				alert(t["noMedCountryDesc"]);
				websys_setfocus('CountryDesc');
				return false;
			}
			var myPAPERMarital = DHCWebD_GetObjValue("PAPERMarital");
			if (myPAPERMarital == "") {
				alert(t["noMedPAPERMarital"]);
				websys_setfocus('PAPERMarital');
				return false;
			}
			var myProvinceBirth = DHCWebD_GetObjValue("ProvinceBirth");
			if (myProvinceBirth == "") {
				alert(t["noMedProvinceBirth"]);
				websys_setfocus('ProvinceBirth');
				return false;
			}
			
			var myNationDesc = DHCWebD_GetObjValue("NationDesc");
			if (myNationDesc == "") {
				alert(t["noMedNationDesc"]);
				websys_setfocus('NationDesc');
				return false;
			}
			var myCityBirth = DHCWebD_GetObjValue("CityBirth");
			if (myCityBirth == "") {
				alert(t["noMedCityBirth"]);
				websys_setfocus('CityBirth');
				return false;
			}
			var myAreaBirth = DHCWebD_GetObjValue("AreaBirth");
			if (myAreaBirth == "") {
				alert(t["noMedAreaBirth"]);
				websys_setfocus('AreaBirth');
				return false;
			}
			var myProvinceInfo = DHCWebD_GetObjValue("ProvinceInfo");
			if (myProvinceInfo == "") {
				alert(t["noMedProvinceInfo"]);
				websys_setfocus('ProvinceInfo');
				return false;
			}
			var myCityDesc = DHCWebD_GetObjValue("CityDesc");
			if (myCityDesc == "") {
				alert(t["noMedCityDesc"]);
				websys_setfocus('CityDesc');
				return false;
			}
			var myCTArea = DHCWebD_GetObjValue("CTArea");
			if (myCTArea == "") {
				alert(t["noMedCTArea"]);
				websys_setfocus('CTArea');
				return false;
			}
			
			var myCompany = DHCWebD_GetObjValue("Company");
			if (myCompany == "") {
				alert(t["noMedCompany"]);
				websys_setfocus('Company');
				return false;
			}
			var myProvinceHouse = DHCWebD_GetObjValue("ProvinceHouse");
			if (myProvinceHouse == "") {
				alert(t["noMedProvinceHouse"]);
				websys_setfocus('ProvinceHouse');
				return false;
			}
			var myCityhouse = DHCWebD_GetObjValue("Cityhouse");
			if (myCityhouse == "") {
				alert(t["noMedCityhouse"]);
				websys_setfocus('Cityhouse');
				return false;
			}
			var myAreaHouse = DHCWebD_GetObjValue("AreaHouse");
			if (myAreaHouse == "") {
				alert(t["noMedAreaHouse"]);
				websys_setfocus('AreaHouse');
				return false;
			}
			var myRegisterPlace = DHCWebD_GetObjValue("RegisterPlace");
			if (myRegisterPlace == "") {
				alert(t["noMedRegisterPlace"]);
				websys_setfocus('RegisterPlace');
				return false;
			}
			var myCTRelationDR = DHCWebD_GetObjValue("CTRelationDR");
			if (myCTRelationDR == "") {
				alert(t["noCTRelationDR"]);
				websys_setfocus('CTRelationDR');
				return false;
			}
			var myForeignPhone = DHCWebD_GetObjValue("ForeignPhone");
			if (myForeignPhone == "") {
				alert(t["noMedForeignPhone"]);
				websys_setfocus('ForeignPhone');
				return false;
			}else{
				/*if (myForeignPhone.indexOf('-')>=0){
					if(myForeignPhone.length!="12"){
						alert("联系人固定电话长度错误!")
						websys_setfocus('ForeignPhone');
						return false;
					}
				}else{
					if(myForeignPhone.length!="11"){
						alert("联系人联系电话电话长度错误!")
						websys_setfocus('ForeignPhone');
						return false;
					}
				}*/
				if (!CheckTelOrMobile(myForeignPhone,"ForeignPhone","联系人")) return false;
		    }
		}
	}
	var CredNo=DHCWebD_GetObjValue("CredNo");
	/*
	if (CredNo==""){
			alert("身份证号不能为空，是否要授权")
			websys_setfocus('CredNo');
			return false;
	}*/
	/*var rtn = GetSamePatient();
	if (rtn == 2) {
	   //系统中已经存在的证件号码不允许新建主索引
		alert('证件号码已经存在,不能再建卡');
		return false;
	}
	*/
	var OpMedicareObj = document.getElementById('OpMedicare');
	
	if (m_PatMasFlag == "Y") {
		var myForeignName = DHCWebD_GetObjValue("ForeignName");
		if (myForeignName == "") {
		    if(MedicalFlag==1){
				var BModifyInfo=websys_$("BModifyInfo");
				if(BModifyInfo){
				
				}else{
				alert(t["noMedForeignName"]);
				websys_setfocus('ForeignName');
				return false;
				}
			}
		}
		var myTelHome = DHCWebD_GetObjValue("TelHome");
		if (myTelHome == "") {
			alert(t["TeleHomeNull"]);//联系电话
			websys_setfocus('TelHome');
			return false;
		}else{
			/*if (myTelHome.indexOf('-')>=0){
				if(myTelHome.length!="12"){
					alert("固定电话长度错误!")
					websys_setfocus('TelHome');
			        return false;
				}
			}else{
				if(myTelHome.length!="11"){
					alert("联系电话电话长度错误!")
					websys_setfocus('TelHome');
			        return false;
				}
			}*/
			if (!CheckTelOrMobile(myTelHome,"TelHome","")) return false;
		}
		
		var myBirth = DHCWebD_GetObjValue("Birth");
		if (myBirth == "") {
			alert(t["BirthTip"]);//出生日期
			websys_setfocus('Birth');
			return false;
		}
		if(CheckBirthAndBirthTime()){
			alert("出生日期是当天的,出生时间不能大于当前时间,请核实!")
			return false;
		}
		var mySex = DHCWebD_GetObjValue("Sex");
		if (myCombAry["Sex"].getSelectedValue() == "")
			mySex = "";
		
		if (mySex == "") {
			alert(t["noSex"]);//性别
			websys_setfocus('Sex');
			return false;
		}
		//var Age = DHCWebD_GetObjValue("Age");
		//var Age = GetAgeForYear(myBirth);
		var Age = AgeForYear(myBirth)
		if (Age < 15) {
			var ForeignName = DHCWebD_GetObjValue("ForeignName");
			var ForeignPhone = DHCWebD_GetObjValue("ForeignPhone");
			var ForeignIDCard= DHCWebD_GetObjValue("ForeignIDCard");
			if (ForeignName == "") {
				alert("年龄小于15岁,联系人不能为空");
				websys_setfocus('ForeignName');
				return false;
			}
			if (ForeignPhone==""){
				alert("年龄小于15岁,联系人电话不能为空");
				websys_setfocus('ForeignPhone');
				return false;
			}
			if (ForeignPhone!=""){
				/*if (ForeignPhone.indexOf('-')>=0){
					if(ForeignPhone.length!="12"){
						alert("联系人固定电话长度错误!")
						websys_setfocus('ForeignPhone');
						return false;
					}
				}else{
					if(ForeignPhone.length!="11"){
						alert("联系人联系电话电话长度错误!")
						websys_setfocus('ForeignPhone');
						return false;
					}
				}*/
				if (!CheckTelOrMobile(ForeignPhone,"ForeignPhone","联系人")) return false;
		    }
			if (ForeignIDCard==""){
			    alert("年龄小于15岁,联系人证件信息不能为空");
				websys_setfocus('ForeignIDCard');
				return false;
			}
		}else{
			var myForeignPhone = DHCWebD_GetObjValue("ForeignPhone");
			if (myForeignPhone!=""){
				if (!CheckTelOrMobile(myForeignPhone,"ForeignPhone","联系人")) return false;
			}
			
		}
		/*婚姻状态控制 start*/
		var mySex = myCombAry["Sex"].getSelectedText();
		var myPAPERMarital = myCombAry["PAPERMarital"].getSelectedValue(); 
		var AgeToMaritalFlag=0
        if(mySex=="女"){
	        if ((Age < LocalSysParamsObj.MarriedLimitFemaleFAge)&&(("^"+LocalSysParamsObj.MarriedIDStr+"^").indexOf("^"+myPAPERMarital+"^")!=-1)) {
		        AgeToMaritalFlag=1;
		    }
	    }else if(mySex=="男"){
		    if ((Age < LocalSysParamsObj.MarriedLimitMaleAge)&&(("^"+LocalSysParamsObj.MarriedIDStr+"^").indexOf("^"+myPAPERMarital+"^")!=-1)) {
			    AgeToMaritalFlag=1;
		    }
		}	
		if(AgeToMaritalFlag==1){
			alert("该患者未到法定年龄!")
		}
		/*婚姻状态控制 end*/
		var myPatType = DHCWebD_GetObjValue("PatType");
		if (myPatType == "") {
			alert(t["noPatType"]);
			websys_setfocus('PatType');
			return false;
		}
		
		var myAddress = DHCWebD_GetObjValue("Address");
		if (myAddress == "") {
			//alert(t["noAddress"]);
			//websys_setfocus('Address');
			//return false;
		}
		//对于病人类型为职工的对工号的判断 20110719
		if (myPatType.indexOf('本院')>=0){
			var EmployeeNo=DHCWebD_GetObjValue("EmployeeNo");
			if (EmployeeNo==""){
				alert(t["noEmployeeNo"]);
				websys_setfocus('EmployeeNo');
				return false;
			}
			var curPAPMIRowID=tkMakeServerCall("web.DHCBL.CARDIF.ICardPaPatMasInfo","GetPAPMIRowIDByEmployeeNo",EmployeeNo);
			var name=curPAPMIRowID.split("^")[1];
			var UserName=curPAPMIRowID.split("^")[2];
			curPAPMIRowID=curPAPMIRowID.split("^")[0];
			if (curPAPMIRowID=="0"){
				alert("工号不正确,请核实工号");
				websys_setfocus('EmployeeNo');
				return false;
			}
			var PAPMIRowID=DHCWebD_GetObjValue("PAPMIRowID");
			if ((PAPMIRowID!=curPAPMIRowID)&&(curPAPMIRowID!="")){
				alert("此工号已经被'"+name+"'所用,请首先核实工号");
				websys_setfocus('EmployeeNo');
				return false;
			}
			var Name=DHCWebD_GetObjValue("Name");
			if (UserName!=Name){
				alert("此工号对应姓名为'"+UserName+"'和所录入姓名不一致");
				websys_setfocus('Name');
				return false;
			}
		}else{
			var EmployeeNo=DHCWebD_GetObjValue("EmployeeNo");
			if (EmployeeNo!=""){
				alert("非本院职工工号不可填写！");
				websys_setfocus('EmployeeNo');
				return false;
			}
		} //End
		
		var myIDNo = DHCWebD_GetObjValue("CredNo");
		if (myIDNo!=""){
			var myIDrtn=IsCredTypeID();
			if (myIDrtn){
				
				var myIsID=DHCWeb_IsIdCardNo(myIDNo);
				if (!myIsID){
					//alert(t["ErrIDNo"]);
					websys_setfocus("CredNo");
					return false;
				}
				var IDNoInfoStr=DHCWeb_GetInfoFromId(myIDNo)
				//add by zhouzq 2010.09.10 校验身份证中的信息和出生日期
				var IDBirthday=IDNoInfoStr[2]  //DHCWeb_GetInfoFromId(myIDNo)[2];
				if (myBirth!=IDBirthday){
					alert(t['BirthNotMatchId']);
		   		    websys_setfocus('Birth');
		   		    return false;
				}
				//验证身份证中的性别
				//var IDNoInfoStr=DHCWeb_GetInfoFromId(myIDNo)
				var IDSex=IDNoInfoStr[3]
				if(mySex!=IDSex){
					alert("身份证号:"+myIDNo+"对应的性别是【"+IDSex+"】,请选择正确的性别")
					websys_setfocus('Sex');
					return false;
				}
			}else{
				//如果证件类型不是身份证,清空IDCardNo1值，防止IDCardNo1更新到papmi_id
				DHCWebD_SetObjValueC("IDCardNo1","");
			}
		}else{
			var AgeAllow=tkMakeServerCall("web.DHCDocConfig","GetDHCDocCardConfig","AllowAgeNoCreadCard");
			var FlagNoCread=tkMakeServerCall("web.DHCDocConfig","GetDHCDocCardConfig","NOCREAD");
			if (FlagNoCread!=1){
				if ((AgeAllow!="")&&(parseFloat(Age)<=parseFloat(AgeAllow))){}
				else{
					alert("请填写证件号码");
					websys_setfocus("CredNo");
					return false;
				}
			}
		}

		///Check PayMode
		var myval=myCombAry["CardTypeDefine"].getSelectedValue();
		var myary = myval.split("^");
		if (myary[3]=="C"){
			var mypmval=myCombAry["PayMode"].getSelectedValue();
			
			if (mypmval==""){
				alert("请选择支付模式");
				websys_setfocus("PayMode");
				return false;
			}
			
			var mytmpary= mypmval.split("^");
			if (mytmpary[2]=="Y"){
			
				///Require Pay Info
				var myCheckNO=DHCWebD_GetObjValue("CardChequeNo");
				if (myCheckNO==""){
					alert(t['InCheckNo']);     ////
					websys_setfocus("CardChequeNo");
					return false;
				}
				
		   }
			
		}
		var myOtheRtn=OtherSpecialCheckData();
		if (!myOtheRtn){
			return myOtheRtn;
		}
		if (ModifiedFlag==1) return true;
		
	}
	
	//如果是用登记号号作为卡号则不取校验界面卡号
	if ((m_CardRefFlag=="Y")&&(UsePANoToCardNO!="Y"))
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
		//卡号有可能是非数字的
		/*var myisnumrtn=isNumber(myCardNo);
		if (!myisnumrtn){
			alert("请输入正确的卡号");
			websys_setfocus("CardNo");
			return false;
		}*/
		////Card NO Length ?= Card Type Define Length
		var myCTDefLength=0;
		if (isNaN(m_CardNoLength)){
			myCTDefLength=0;
		}else{
			myCTDefLength = m_CardNoLength;
		}
		if ((myCTDefLength!=0)&&(myCardNo.length!=myCTDefLength)){
			
			alert(t["CardLError"]+" " +myCTDefLength +" ");
			websys_setfocus("CardNo");
			return false;
		}
		
		////Card No Pre ?= Card Type Define Pre
		if (m_CardTypePrefixNo!=""){
			var myPreNoLength=m_CardTypePrefixNo.length;
			var myCardNo=DHCWebD_GetObjValue("CardNo");
			var myPreNo=myCardNo.substring(0,myPreNoLength);
			if(myPreNo!=m_CardTypePrefixNo){
				alert(t["CardPreNoError"]);
				websys_setfocus("CardNo");
				return false;
			}
		}
	}

	var myobj = document.getElementById("GetPatPaySum");
	if (myobj){
		var myPatPaySum=DHCWebD_GetObjValue("GetPatPaySum");
		if ((myPatPaySum=="")&&(m_CardCost>0)){
			alert("请输入收款金额");
		   	websys_setfocus('GetPatPaySum');
		   	return false;
			
		}else{
			var obj=document.getElementById("GetPatPaySum");
			var objb=document.getElementById("CardFareCost");
			var Resobj=document.getElementById("amt");
			DHCWeb_Calobj(obj,objb,Resobj,"-");
			var myChange=DHCWebD_GetObjValue("amt");
			if((isNaN(myChange))||(myChange=="")){
				myChange=0;
			}
			myChange=parseFloat(myChange);
			if (myChange<0){
				alert("输入费用金额错误!");
				websys_setfocus("GetPatPaySum");
				return false;
			}else{
				
			}
			var ReceiptsNo="";
			var ReceiptsNoobj=document.getElementById("ReceiptsNo");
			if (ReceiptsNoobj) ReceiptsNo=ReceiptsNoobj.value;
			if ((Resobj.value!="")&&(Resobj.value!="0")&&(ReceiptsNo=="")&&(m_ReceiptsType!=""))
				{
					alert(t[2072])
					return false;
				}
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
			/*if (myobj.value<0){
			    alert(t[2041]);
		   		websys_setfocus('amt');
		   		return false;
			}*/
		}
	}
	var OtherCardInfo=document.getElementById("OtherCardInfo").value;
	if (OtherCardInfo!=""){
		var CredNo=DHCWebD_GetObjValue("CredNo");
		var myval=myCombAry["CredType"].getSelectedValue();
		var myCredTypeDR = myval.split("^")[0];
		for (var i=0;i<OtherCardInfo.split("!").length;i++){
			var oneCredTypeId=OtherCardInfo.split("!")[i].split("^")[0];
			if (oneCredTypeId!=myCredTypeDR) continue;
			var oneCredNo=OtherCardInfo.split("!")[i].split("^")[1];
			if ((oneCredNo!=CredNo)&&(oneCredNo!="")){
				alert("证件号码: "+CredNo+" 和其他证件里面相同证件类型维护的号码: "+oneCredNo+" 不一致!请核实");
				websys_setfocus('CredNo');
				return false;
			}
		}
	}
	return myrtn;
}

function isNumber(objStr){
 strRef = "-1234567890.";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}
function isNumberOrLetters(objStr){
 strRef = "-1234567890.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}

function OtherSpecialCheckData()
{
	var myVer=DHCWebD_GetObjValue("DHCVersion");
	switch (myVer){
		case "7":
			////Age<14  Link Name, Address,
			var myAge=DHCWebD_GetObjValue("Age");
			if (isNaN(myAge)){myAge=0};
			if (myAge<14){
				var myForeignName=DHCWebD_GetObjValue("ForeignName");
				if (myForeignName==""){
					alert(t["ForeignNameTip"]);
					websys_setfocus("ForeignName");
					return false;
				}

				var myAddress=DHCWebD_GetObjValue("Address");
				if (myAddress==""){
					alert(t["AddressTip"]);
					websys_setfocus("Address");
					return false;
				}
				///
				var myTelHome=DHCWebD_GetObjValue("TelHome");
				if (myTelHome==""){
					alert(t["TelHomeTip"]);
					websys_setfocus("TelHome");
					return false;
				}
				
			}
			break;
		default:
			break;
	}
	return true;
}

function GetPatMasInfo()
{
	var myxml="";
	
	if (m_PatMasFlag=="Y"){
		var myparseinfo = DHCWebD_GetObjValue("InitPatMasEntity");
		
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;
}

function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try
	{
		var myary=ParseInfo.split("^");
		
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			
			xmlobj.BeginNode(myary[myIdx]);
			
			var myTagIdx=m_CombXmlTagAray.indexOf(myary[myIdx]);
			
			var myCombName=myary[myIdx];
			if(myTagIdx>-1){
				var myCombName=myCombNameAry[myTagIdx];
			}
			///xmlobj.Attrib("EName", m_CPMPrintAry[myIdx]);
			//var myval=DHCWebD_GetObjValue(myary[myIdx]);
			//if (myCombAry[myary[myIdx]]){
			if (myCombAry[myCombName]){
				var myval =myCombAry[myCombName].getSelectedValue();
				myval=myval.split("^")[0];
			}else{
				
				var myval = DHCWebD_GetObjValueXMLTransA(myary[myIdx]);
			}
			xmlobj.WriteString(myval);
			
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
	
}



function GetCardRefInfo()
{
	//InitCardRefEntity
	var myxml="";
	
	if (m_CardRefFlag=="Y"){
		var myparseinfo = DHCWebD_GetObjValue("InitCardRefEntity");
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;
	
}

function GetCardINVInfo()
{
	var myxml="";
	if (m_CardRefFlag=="Y"){
		var myparseinfo = DHCWebD_GetObjValue("InitCardINVPRTEntity");
		var myxml=GetEntityClassInfoToXML(myparseinfo)	
		}
	
	return myxml;
}


function GetAccManagerInfo()
{
	var myxml="";
	
	if (m_AccManagerFlag=="Y")
	{
		var myparseinfo = DHCWebD_GetObjValue("InitAccManagerEntity");
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;	
}

function GetPreDepositeInfo()
{
	var myxml="";
	
	if (m_AccManagerFlag=="Y")
	{
		var myparseinfo = DHCWebD_GetObjValue("InitAccPreDepositEncrypt");
		var myxml=GetEntityClassInfoToXML(myparseinfo)
	}
	
	return myxml;
}

function NewCard_click()
{
	CardTypeDefine_Key();
	//非医保类型不能填写医保号
	YBflag=checkPatYBCode();
	if(YBflag==false)return;
	if(!BirthCheck()) return;
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
	var HospName=""
	var obj=document.getElementById("HospName");
	if(obj) HospName=obj.value;
	var PDlime=String.fromCharCode(2);
	var TxtInfo=TxtInfo+"^"+"HospName3"+PDlime+HospName;
	var myPAName=DHCWebD_GetObjValue("Name");
	TxtInfo=TxtInfo+"^"+"PatName"+PDlime+myPAName;
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
		alert(t["ReadCardErr"]);
		return "-1^";
	}
	//alert(mySecrityNo)
	///Write Card First
	if (mySecrityNo!=""){
		var myCardNo=DHCWebD_GetObjValue("CardNo");
		var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
		//alert(rtn);
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
	     
			var p1=Guser;
			var p2="D";
			var getregno=document.getElementById('GetCurrentRecNoClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,p1,p2)
			 var myary=ren.split("^");
				
				if (myary.length>5) m_ReceiptsType=myary[5];
				if (myary[0]=='0'){
					
					var ReceiptsNoObj=document.getElementById("ReceiptsNo");
					if (ReceiptsNoObj) ReceiptsNoObj.value=myary[3];
					
					}
					else
					{
						//alert(t[2072])
						
						}
	
	}
function textimemode()
{
	if (document.all.TelHome){
		document.all.TelHome.style.imeMode = "disabled";
	}
	if (document.all.PAPMINo){
		document.all.PAPMINo.style.imeMode = "disabled";
	}
	if (document.all.CardNo){
		document.all.CardNo.style.imeMode = "disabled";
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
		IsNotStructAddress=myary[17];
		m_SetFocusElement = mySetFocusElement;
		
		m_PatMasFlag=myary[3];
		m_CardRefFlag=myary[4];
		m_AccManagerFlag=myary[5];
		
		///Get Config Default Value
		///By XML String
		SetPatInfoByXML(myRtnAry[1]);
		
	}
	
	var myXmlData = DHCWebD_GetObjValue("ReadUIDefaultValue");
	SetPatInfoByXML(myXmlData);
	//SetPatInfoModeByXML(myXmlData);
	
	if (mySetFocusElement!=""){
		websys_setfocus(mySetFocusElement);
	}
	m_CardSecrityNo="";
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
	
	InitPicture();
	
	var mySessionStr=DHCWeb_GetSessionPara();
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine", mySessionStr);
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
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PatType",mySessionStr);
		
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
	var myobj=document.getElementById("OpMedicare");
	if (myobj)
	{
		myobj.readOnly=true;
	}
	var myobj=document.getElementById("InMedicare");
	if (myobj)
	{
		myobj.readOnly=true;
	}
	GetCurrentRecNo();
	//websys_setfocus("PAPMINo");
	
}

function PayModeObj_OnChange()
{
	///
	var myobj=myCombAry["PayMode"];
	
	if(myobj){
		////if (myobj.options.length==0){
		////	SetPayInfoStatus(true);
		////	return;
		////}
		////var myIdx=myobj.options.selectedIndex;
		///if (myIdx==-1){
			///SetPayInfoStatus(true);
			///return;
		////}
		var myoptval=myCombAry["PayMode"].getSelectedValue();
		var myary=myoptval.split("^");
		if (myary[2]=="Y"){
			SetPayInfoStatus(false);
		}else{
			SetPayInfoStatus(true);
		}
	}
}

function PayModeObj_OnChangeOld()
{
	///var myoptval=myCombAry["CardTypeDefine"].getSelectedValue();
	var myobj=myCombAry["PayMode"];
	
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
	////alert(myCombAry["CardTypeDefine"].type);
	var myoptval=myCombAry["CardTypeDefine"].getSelectedValue();
	//var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	
	if (myCardTypeDR=="")
	{
		return;
	}
	
	m_OverWriteFlag=myary[23];
	var encmeth=DHCWebD_GetObjValue("ReadDefCCEncrypt");
	if (encmeth!=""){
		m_RegCardConfigXmlData=cspRunServerMethod(encmeth,m_SelectCardTypeRowID);
	}
	///alert(m_RegCardConfigXmlData);
	
	//alert(myary);
	
	///
	DHCWebD_SetObjValueA("CardFareCost","");
	m_CardCost=0;
	DHCWebD_SetObjValueA("ReceiptNO","");
	if (myary[3]=="C"){
		DHCWebD_SetObjValueA("CardFareCost",myary[6]);
		m_CardCost=myary[6];
		GetReceiptNo();
	}
	
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
		var obj=document.getElementById("ReadCard");
		if (obj) obj.onclick="";
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
			DHCC_AvailabilityBtn(obj)
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
	
	m_CardTypePrefixNo=myary[29];
	////alert(m_CardTypePrefixNo);
	var myobj=document.getElementById("CardNo");
	if (myobj){
		myobj.value="";
	}
	//设置使用登记号作为卡号
	if (myary.length>=37){
		UsePANoToCardNO=myary[36];
	}
	if (UsePANoToCardNO=="Y"){
		DHCWeb_DisBtnA("ReadCard");
		var obj=document.getElementById("ReadCard");
		if (obj) obj.onclick="";
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		m_CardNoLength=0
		var Obj=document.getElementById('NewCard');
		if (Obj) {
				DHCC_AvailabilityBtn(Obj)
				Obj.onclick = NewCard_click;
		}
		websys_setfocus('Name');
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
		///myobj.disabled=SFlag;
	}
	
	var myobj=document.getElementById("BankCardType");
	if (myobj){
		///myobj.disabled=SFlag;
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
	SetUIDefaultValue();
	DHCWebD_SetObjValueA("PatYBCode","");
	DHCWebD_SetObjValueA("ChequeDate","");
	InitPicture();
	DHCWeb_DisBtnA("NewCard");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch.List";
	if (parent.frames["DHCCardSearch"]) parent.frames["DHCCardSearch"].location.href = lnk;
	//return;
	var ref="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardPatInfoRegExp";
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
	var winEvent=window.event || arguments[0];
	if (evtName=='PatType') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(winEvent);
	if (key==13) {
		websys_setfocus('TelHome');
		
		return;
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
	///var myrtn=IsCredTypeID();
	var myCreddNo= DHCWebD_GetObjValue("CredNo");
	var myrtn=IsCredTypeID();
	
	if (((myCreddNo=="")||((myCreddNo!="")&&myrtn))&&(myCombAry[myCombNameAry[4]])){
		
		if (!myrtn){
			SetIDCredType();
		}
		
		var mycredobj=document.getElementById("CredNo");
		var myidobj=document.getElementById('IDCardNo1');
		if ((mycredobj)&&(myidobj)){
			mycredobj.value=myidobj.value;
		}
		
	}
}

function IDCardNo1_OnKeyPress()
{
	var e=window.event;
	var mykey=e.keyCode;
	if (mykey==13){
		///var myrtn=IsCredTypeID();
		///if (!myrtn){return;}
		var mypId = DHCWebD_GetObjValue("IDCardNo1");
		mypId=mypId.toUpperCase();
		DHCWebD_SetObjValueC("IDCardNo1",mypId);
		if (mypId!=""){
			var myary=DHCWeb_GetInfoFromId(mypId);
			if (myary[0]=="1"){
				var myBirth=DHCWebD_GetObjValue("Birth");
				if (myBirth==""){
					DHCWebD_SetObjValueC("Birth",myary[2]);		////Birthday
				}
				var myAge=DHCWebD_GetObjValue("Age");
				if (myAge==""){
					DHCWebD_SetObjValueC("Age",myary[4]);		////Age
				}
				var mySexDR="";
				switch(myary[3]){
					case "男":
						mySexDR="1";
						break;
					case "女":
						mySexDR="2";
						break;
					default:
						mySexDR="4";
						break;
				}
				if (myCombAry["Sex"]){
					myCombAry["Sex"].setComboValue(mySexDR);
				}
			}else{
				websys_setfocus("IDCardNo1");
				return websys_cancel();
			}
		}
	}
}

function CredNo_OnChange()
{
	var myrtn=IsCredTypeID();
	var mycredobj=document.getElementById("CredNo");
	var myidobj=document.getElementById('IDCardNo1');
	if (myrtn&&(mycredobj)&&(myidobj)){
		myidobj.value=mycredobj.value;
	}
	if ((!myrtn)&&(mycredobj)&&(myidobj)){
		myidobj.value="";
	}
}

function CredNo_OnKeyPress()
{
	var winEvent=window.event;
	var mykey=winEvent.keyCode;
	if (mykey==13){
		var myrtn=IsCredTypeID();
		
		if (myrtn){
			
			var mypId = DHCWebD_GetObjValue("CredNo");
			mypId=mypId.toUpperCase();
			DHCWebD_SetObjValueC("CredNo",mypId);
			var RtnStr=tkMakeServerCall("web.DHCRBAppointment","GetAppedCommomInfo",mypId);
		    var FindAppFlag=RtnStr.split("^")[0];
		    if (FindAppFlag=="1"){
			    var LastAppedInfo=RtnStr.split("^")[1];
			    var LastAppendName=LastAppedInfo.split("$")[0];
			    var LastAppenTelH=LastAppedInfo.split("$")[1];
			    var DifferenceAppInfo=RtnStr.split("^")[2];
			    if (DifferenceAppInfo!=""){
				    if (confirm("此身份证号存在以下有效的公共卡预约预留信息:\n姓名:"+LastAppendName+"  电话:"+LastAppenTelH+"(最后一次预留信息)\n"+DifferenceAppInfo+"\n是否取最后一次的预留信息?")){
						DHCWebD_SetObjValueC("Name",LastAppendName);
					    DHCWebD_SetObjValueC("TelHome",LastAppenTelH);
					}
				}else{
					if (confirm("此身份证号存在有效的公共卡预约预留信息:\n姓名:"+LastAppendName+"  电话:"+LastAppenTelH+"\n是否带入预约预留信息?")){
						DHCWebD_SetObjValueC("Name",LastAppendName);
					    DHCWebD_SetObjValueC("TelHome",LastAppenTelH);
					}
					
				}
			}
			if (mypId!=""){
				var myary=DHCWeb_GetInfoFromId(mypId);
				if (myary[0]=="1"){
					var myBirth=DHCWebD_GetObjValue("Birth");
					///if (myBirth==""){
						DHCWebD_SetObjValueC("Birth",myary[2]);		////Birthday
					///}
					var myAge=DHCWebD_GetObjValue("Age");
					///if (myAge==""){
						DHCWebD_SetObjValueC("Age",myary[4]);		////Age
					///}
					////Sex
					var mySexDR="";
					switch(myary[3]){
						case "男":
							mySexDR="1";
							break;
						case "女":
							mySexDR="2";
							break;
						default:
							mySexDR="4";
							break;
					}
					if (myCombAry["Sex"]){
						myCombAry["Sex"].setComboValue(mySexDR);
					}
				}else{
					websys_setfocus("CredNo");
					return;
				}
			}
			
		}
		CredNo_OnChange();
		////(IDNo, CredTypeDR, CardTypeDR, CredNo, ExpStr)
		////IDNo As %String = "", CredTypeDR As %String, CredNo As %String = "", CardTypeDR As %String = ""
		
		var myIDNo=DHCWebD_GetObjValue("IDCardNo1");
		var myval=myCombAry["CredType"].getSelectedValue();
		var myCredTypeDR = myval.split("^")[0];
		var myCredNo=DHCWebD_GetObjValue("CredNo");
		var myval=myCombAry["CardTypeDefine"].getSelectedValue();
		var myCardTypeDR = myval.split("^")[0];
		var myValidateMode=myval.split("^")[30];
		if (myValidateMode=="IDU"){
			var encmeth=DHCWebD_GetObjValue("ReadConfigByIDUEncrypt");
			if ((encmeth!="")&&((myIDNo!="")||(myCredNo!=""))){
				var myInfo=cspRunServerMethod(encmeth,myIDNo, myCredTypeDR, myCredNo, myCardTypeDR);
				var myary=myInfo.split(String.fromCharCode(1));
				switch (myary[0]){
					case "0":
						break;
					case "-368":
						m_RegCardConfigXmlData=myary[1];
						var myPatInfoXmlData=myary[2];
						var myRepairFlag=myary[3];
						// myRepairFlag 为卡类型配置的"数据类型转换验证",用于控制被赋值的元素是否可再编辑
						if (myRepairFlag=="Y"){
							SetPatInfoModeByXML(myPatInfoXmlData, false);
						}else{
							SetPatInfoModeByXML(myPatInfoXmlData, false);
						}
						GetPatDetailByPAPMINo();
						SetPatRegCardDefaultConfigValue(myary[4]);
						break;
					case "-365":
						alert(t["-365"]);
						break;
					default:
						alert("" + " Err Code="+myary[0]);
						break;
				}
				
			}
		}else{
			/////........
		}
		
	}
}

function ValidateRegInfoByCQU(PAPMIDR)
{
	var myval=myCombAry["CardTypeDefine"].getSelectedValue();
	var myCardTypeDR = myval.split("^")[0];
	var myValidateMode=myval.split("^")[30];
	if (myValidateMode=="CQU"){
		var encmeth=DHCWebD_GetObjValue("ReadConfigByCQUEncrypt");
		if ((encmeth!="")){
			var mySessionStr="";
			var myInfo=cspRunServerMethod(encmeth,PAPMIDR, myCardTypeDR, mySessionStr);
			
			var myary=myInfo.split(String.fromCharCode(1));
			switch (myary[0]){
				case "0":
					
					break;
				case "-368":
					
					m_RegCardConfigXmlData=myary[1];
					var myPatInfoXmlData=myary[2];
					var myRepairFlag=myary[3];
					/*
					if (myRepairFlag=="Y"){
						SetPatInfoModeByXML(myPatInfoXmlData, false);
					}else{
						SetPatInfoModeByXML(myPatInfoXmlData, true);
					}
					*/
					SetPatInfoByXML(myPatInfoXmlData);
					GetPatDetailByPAPMINo();
					SetPatRegCardDefaultConfigValue(myary[4]);
					break;
				case "-365":
					alert(t["-365"]);
					
					break;
				default:
					alert("" + " Err Code="+myary[0]);
					break;
			}
			
		}
	}else{
		GetPatDetailByPAPMINo();
			/////........
	}
}

function SetPatRegCardDefaultConfigValue(Value){
	var myary=Value.split("^");
	m_PatMasFlag= myary[1];
	m_CardRefFlag=myary[2];
	m_AccManagerFlag=myary[3];
	
	m_SetCardReferFlag=myary[4];
	
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
		if(!SetCardNOLength()) return false;
		CardVerify="";
		GetValidatePatbyCard();
	}
	///m_CardNoLength
	if (key==13) {
		//FindPatDetail()
	}
	
	/// Must lie Last
	var e=window.event;
	///DHCWeb_SetLimitNumABC(e);
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
	
	var obj=document.getElementById("PAPMINo");
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
				//先清除页面信息,对应用于清除匹配的XML获取:##class(web.DHCBL.UDHCUIDefConfig).ReadCardPatUDIef
				InitPatRegConfig();
				var myXMLStr=myary[1];
				var PAPMIXMLStr=GetRegMedicalEPMI("",myPAPMINo);
				//alert("PAPMIXMLStr="+PAPMIXMLStr)
				if (PAPMIXMLStr!="") myXMLStr=PAPMIXMLStr;
				debugger;
				SetPatInfoByXML(myXMLStr);
				if (m_SetCardRefFocusElement!="")
				{
					websys_setfocus(m_SetCardRefFocusElement);
				}
				//加入图片base64应用
				var photoobj=document.getElementById("PhotoInfo");
				if ((photoobj)&&(photoobj.value!="")){var src="data:image/png;base64,"+photoobj.value}
				else{var src=""}
				ShowPicBySrcNew(src,"imgPic")
				
				var PAPMIDR=DHCWebD_GetObjValue('PAPMIRowID');
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
	CardTypeDefine_Key()
	var obj=document.getElementById('CardNo');
	if (obj.value!='') {
		if ((m_CardNoLength!=0)&&(obj.value.length>m_CardNoLength)){
			if (!confirm("卡号位数大于卡类型配置位数,是否截取?")){
				return false;
			}
		}
		if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
			for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
				obj.value="0"+obj.value
			}
		}
		
		if ((obj.value.length>m_CardNoLength)&&(m_CardNoLength!=0)){
			m_CardSecrityNo=obj.value.substring(m_CardNoLength, obj.value.length);
			obj.value=obj.value.substring(0,m_CardNoLength);
		}
		///alert(m_CardSecrityNo);
	}
	return true;	
	
}


function SetPatInfoByXML(XMLStr,CheckFlag,getMessageByIdCard) {
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	
	var AddressObj={
		AdrDesc:{
			Country:'',
			Province:'',
			City:'',
			Area:''
		},
		AdrHouse:{
			Country:'',
			Province:'',
			City:'',
			Area:''
		},
		AdrBirth:{
			Country:'',
			Province:'',
			City:'',
			Area:''
		},
		AdrHome:{
			Country:'',
			Province:''
		}
	};
	var xmlDoc = DHCDOM_CreateXMLDOM();
    oldPersonMessage=[];
	if(typeof getMessageByIdCard!="undefined"){
		oldPersonMessageFromIDCard={};
	}
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if (xmlDoc.parseError.errorCode != 0) {
		alert(xmlDoc.parseError.reason);
		return;
	}
	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length<=0){return;}
	for (var i = 0; i < nodes.length; i++) {
		
		var myItemName = nodes(i).nodeName;
		var myItemValue = nodes(i).text;
		if ((myItemName=="OtherCardInfo")&&(myItemValue!="")) {
			myItemValue=myItemValue.replace(/@/g,"^");
		}
		//if ((myItemName=="PostCode")||(myItemName=="MobPhone")) debugger;
		if (myCombAry[myItemName]) {
			
			if(typeof getMessageByIdCard!="undefined"){			
			  if(myItemName=="PatType"){
				oldPersonMessageFromIDCard.PatType=myItemValue
			  }		 
			}else{
				//地址信息有加载顺序问题,所以先记录,后处理
				if (myItemName == "CountryHouse") {
					AddressObj.AdrDesc.Country=myItemValue;
				}
				else if (myItemName == "ProvinceInfo") {
					AddressObj.AdrDesc.Province=myItemValue;
				}
				else if (myItemName == "CityDesc") {
					AddressObj.AdrDesc.City=myItemValue;
				}
				else if (myItemName == "CTArea") {
					AddressObj.AdrDesc.Area=myItemValue;
				}
				else if (myItemName == "CountryDesc") {
					AddressObj.AdrHouse.Country=myItemValue;
				}
				if (myItemName == "ProvinceHouse") {
					AddressObj.AdrHouse.Province=myItemValue;
				}
				else if (myItemName == "Cityhouse") {
					AddressObj.AdrHouse.City=myItemValue;
				}
				else if (myItemName == "AreaHouse") {
					AddressObj.AdrHouse.Area=myItemValue;
				}
				else if (myItemName == "CountryBirth") {
					AddressObj.AdrBirth.Country=myItemValue;
				}
				else if (myItemName == "ProvinceBirth") {
					AddressObj.AdrBirth.Province=myItemValue;
				}
				else if (myItemName == "CityBirth") {
					AddressObj.AdrBirth.City=myItemValue;
				}
				else if (myItemName == "AreaBirth") {
					AddressObj.AdrBirth.Area=myItemValue;
				}
				else if (myItemName == "CountryHome") {
					AddressObj.AdrHome.Country=myItemValue;
				}
				else if (myItemName == "ProvinceHome") {
					AddressObj.AdrHome.Province=myItemValue;
				}
				else{
					myCombAry[myItemName].setComboValue(myItemValue);
				}
			}
			
		} else {
		     if(typeof getMessageByIdCard!="undefined"){
			  if(myItemName=="InMedicare"){
				oldPersonMessageFromIDCard.InMedicare=myItemValue
			  }
			  if(myItemName=="Name"){
				oldPersonMessageFromIDCard.Name=myItemValue
			  }
			  if(myItemName=="CredNo"){
				oldPersonMessageFromIDCard.CredNo=myItemValue
			  }	  
			 
			}else{
				DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
			}
			//病案号不能撤销和更改
			if ((myItemName=="InMedicare")&&(myItemValue!="")){
			  websys_$("InMedicare").disabled=true;
			}else if((myItemName=="InMedicare")&&(myItemValue=="")&&(MedicalFlag == 1)){
			  websys_$("InMedicare").disabled=false;
			}
		}
	}
	delete(xmlDoc);
	//地址字段联动(国家,省份,城市)
	for (var Item in AddressObj) {
		if (Item==="AdrDesc") {
			myCombAry["CountryHouse"].setComboValue(AddressObj[Item].Country);
			ProvinceInfo_OnFocus();
			CityDescInfo_OnFocus();
			myCombAry["ProvinceInfo"].setComboValue(AddressObj[Item].Province);
			CityDescInfo_OnFocus();
			CityDescInfo_OnChange();
			myCombAry["CityDesc"].setComboValue(AddressObj[Item].City);
			CityDescInfo_OnChange();
			myCombAry["CTArea"].setComboValue(AddressObj[Item].Area);
		}else if (Item==="AdrHouse") {
			myCombAry["CountryDesc"].setComboValue(AddressObj[Item].Country);
			ProvinceHouse_OnFocus();
			CityHouse_OnFocus();
			CityHouse_OnChange();
			myCombAry["ProvinceHouse"].setComboValue(AddressObj[Item].Province);
			CityHouse_OnFocus();
			CityHouse_OnChange();
			myCombAry["Cityhouse"].setComboValue(AddressObj[Item].City);
			CityHouse_OnChange();
			myCombAry["AreaHouse"].setComboValue(AddressObj[Item].Area);
		}else if (Item==="AdrBirth") {
			myCombAry["CountryBirth"].setComboValue(AddressObj[Item].Country);
			ProvinceBirth_OnFocus();
			CityBirth_OnFocus();
			myCombAry["ProvinceBirth"].setComboValue(AddressObj[Item].Province);
			CityBirth_OnFocus();
			CityBirth_OnChange();
			myCombAry["CityBirth"].setComboValue(AddressObj[Item].City);
			CityBirth_OnChange();
			myCombAry["AreaBirth"].setComboValue(AddressObj[Item].Area);
		}else if (Item==="AdrHome") {
			myCombAry["CountryHome"].setComboValue(AddressObj[Item].Country);
			ProvinceHome_OnFocus();
			myCombAry["ProvinceHome"].setComboValue(AddressObj[Item].Province);
			CityHome_OnFocus();
		}
	}
	
	if(typeof getMessageByIdCard!="undefined"){
		return;
	}
    if(myCombAry["PatType"]){
		oldPersonMessage.push(websys_$V("Name"),websys_$V("CredNo"),websys_$V("InMedicare"),myCombAry["PatType"].getSelectedText());
	}
	if(typeof CheckFlag!="undefined"){
		//读证件建卡时，姓名、出生日期、证件号、民族、性别信息不能修改，以读出信息为准。  
		var name=websys_$("Name");
		if(name)
		name.disabled=true;
		var dob=websys_$("Birth");
		if(dob){
		   dob.disabled=true;
		}
		var Nation=websys_$("NationDesc");
		if(Nation){
		  Nation.readOnly=true;
		}
		var CredNo=websys_$("CredNo");
		if(CredNo){
		   CredNo.disabled=true;
		}
		var Sex=websys_$("Sex");
		if(Sex){
		 Sex.readOnly=true;
		}
	}else{
		var name=websys_$("Name");
		if(name)
		name.disabled=false;
		var dob=websys_$("Birth");
		if(dob){
		   dob.disabled=false;
		}
		var Nation=websys_$("NationDesc");
		if(Nation){
		  Nation.readOnly=false;
		}
		var CredNo=websys_$("CredNo");
		if(CredNo){
		   CredNo.disabled=false;
		}
		var Sex=websys_$("Sex");
		if(Sex){
		 Sex.readOnly=false;
		}
	
	}
}

function SetPatInfoModeByXML(XMLStr, Mode)
{
	///alert(XMLStr);
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
		
		if (myCombAry[myItemName]){
			myCombAry[myItemName].readonly = Mode ;
			if (myItemValue==""){
				///alert(myItemValue +"  " +myItemName)
				myCombAry[myItemName].setComboText("");
				///break;
			}
			if (myItemValue!=""){
				myCombAry[myItemName].setComboValue(myItemValue);
			}
		}else{
			var myobj=document.getElementById(myItemName);
			if (myobj){
				myobj.readOnly = Mode;
			}
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
		
	}
	delete(xmlDoc);
	//关联建卡使用登记号作为卡号，验证卡号的有效性
	CheckForUsePANoToCardNO()
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


function SetUIDefaultValue()
{
	InitPatRegConfig();
	
	var myobj=document.getElementById("OpMedicare");
	if (myobj)
	{
		myobj.readOnly=true;
	}
	var myobj=document.getElementById("InMedicare");
	if (myobj)
	{
		myobj.readOnly=true;
	}
	
	IDReadControlDisable(false);
	CardTypeDefine_OnChange();
}


document.body.onload = DocumentLoadHandler;

////
function ReadFirstID_Onclick()
{
	///ReadFirstID("41");
	GetA600RecogNewIDOnly();
}

function ReadFirstID(myHCTypeDR)
{
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
	
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		SetPatInfoByXML(myary[1]);
		
		var mycredobj=document.getElementById("CredNo");
		var myidobj=document.getElementById('IDCardNo1');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
		}
		SetIDCredType();
		///IDReadControlDisable(true);
	}
}

function GetA600RecogNewIDOnly()
{
	var objIDCard=document.getElementById("objIDCard");
    if( objIDCard.LibIsLoaded() ){
	    setTimeout('A600RecogNewIDOnly()',1500);
    }
}

function A600RecogNewIDOnly()
{
	IDReadControlDisable(false);
	var objIDCard=document.getElementById("objIDCard");
    
    if( objIDCard.LibIsLoaded() )
    {
		objIDCard.ImageFileName = "C:\\ID.jpg"; // 一代身份证
		objIDCard.HeadImageFileName = "C:\\IDhead.jpg"; // 一代身份证
		objIDCard.SaveResultFile = true;
		objIDCard.Content = 63;
	    objIDCard.ButtonType=3;
		objIDCard.HandPrint=0;
		if( objIDCard.RecogIDCardExALL() )
		{
			if (document.all.Name){
		    	document.all.Name.value = objIDCard.GetName();
			}
			
		    var mySex=objIDCard.GetSex();
		    var mySexDR="";
		    switch(mySex){
			    case "男":
			    	mySexDR="1";
			    	break;
			    case "女":
			    	mySexDR="2";
			    	break;
			    default:
			    	mySexDR="4";
			    	break;
		    }
		    if (myCombAry["Sex"]){
		    	myCombAry["Sex"].setComboValue(mySexDR);
		    }
		    var myIDNo=objIDCard.GetNumber();
		    var myPeopleBirthday = objIDCard.GetBirthday;
	        var myIDInfoAry=DHCWeb_GetInfoFromId(myIDNo);
	        if (myIDInfoAry[0]="1"){
		        ///["1",prov,birthday,sex, myAge];
				DHCWebD_SetObjValueC("Birth",myIDInfoAry[2]);		////Birthday
				DHCWebD_SetObjValueC("Age",myIDInfoAry[4]);		////Age
	        }
	        var myAddress = objIDCard.GetAddress();
	        DHCWebD_SetObjValueC("Address",myAddress);
		    var myCredNo = objIDCard.GetNumber();
		    DHCWebD_SetObjValueC("CredNo",myCredNo);
		}
	        else
		{
	            alert( objIDCard.GetLastErrorInfo() );
		}
    }
    else
    {
        alert( objIDCard.GetLastErrorInfo() );
    }
}
function M1Card_InitPassWord()
{
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
  }catch(e)
  {
  	}
	}
	function PatTypeObj_OnChange()
{
	///
	
	var myobj=document.getElementById("PatType");
	if(myobj){
		
		var myoptval=myCombAry["PatType"].getSelectedText();
		
	
		
		if (myoptval=="本院职工"){
			DHCWebD_SetObjValueA("CardFareCost","0");
		}else{
			DHCWebD_SetObjValueA("CardFareCost",m_CardCost);
		}
	}
}

function OtherCredTypeInput()
{
 var url="dhcothercredtype.csp";
 var windesc="其他证件管理"
 var features="top=30,left=200,width=650,height=600,scrollbars=yes,toolbar=no,resizable=yes";
 open(url,windesc,features); 	
}

function CardTypeSave(val)
{
  document.getElementById("OtherCardInfo").value=val;
}

function PatInfoPrint(ElementName) {
	var PatInfoXMLPrint = "PatInfoPrint";
	var Char_2 = "\2";
	var InMedicare = DHCWebD_GetObjValue("InMedicare");
	var Name = DHCWebD_GetObjValue("Name");
	var RegNo = DHCWebD_GetObjValue(ElementName);
	//如果登记号存在去后台取患者姓名
	if (RegNo!=""){
		var PatStr=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByNo",RegNo);
		if (PatStr!=""){Name=PatStr.split("^")[2]}
	}
	var TxtInfo = "TPatName" + Char_2 + "姓  名:" + "^Name" + Char_2 + Name + "^TRegNo" + Char_2 + "病人ID:" + "^RegNo" + Char_2 + RegNo+"^RegNoTM"+ Char_2 + "*"+RegNo+"*"
	if (InMedicare != "")TxtInfo = TxtInfo + "^TMedicareNo" + Char_2 + "病案号:" + "^MedicareNo" + Char_2 + InMedicare;
	var ListInfo = "";
	DHCP_GetXMLConfig("DepositPrintEncrypt", PatInfoXMLPrint);
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}
function SearchSamePatient() {
	var name = "",
	sex = "",
	birth = "",
	CredNo = "";
	PatYBCode="";
	var objname = document.getElementById('Name');
	if (objname)
		name = objname.value;
	//var objsex=document.getElementById('Sex');
	//if (objsex)sex=objsex.value;
	if (myCombAry["Sex"])
		sex = myCombAry["Sex"].getSelectedValue().split("^")[0];
	var objBirth = document.getElementById('Birth');
	if (objBirth)
		birth = objBirth.value
			var objCred = document.getElementById('CredNo');
	if (objCred)
		CredNo = objCred.value;
	PatYBCode=DHCWebD_GetObjValue("PatYBCode");
	var InMedicare=DHCWebD_GetObjValue("InMedicare");
	if (name == "" && ((CredNo == "")&&(PatYBCode=="")&&(InMedicare=="")))
		return false;
	var Age = document.getElementById("Age").value;
	var ArgValue=name+"^"+birth+"^"+CredNo+"^"+sex+"^"+Age+"^"+PatYBCode+"^"+InMedicare;
	if (m_CurSearchValue==ArgValue) return false;
	m_CurSearchValue=ArgValue;
	var myval=myCombAry["CredType"].getSelectedValue();
	var myary = myval.split("^");
	var CredTypeID=myary[0];
	if (CredNo=="") CredTypeID="";
	/*var rtn = GetSamePatient();
	if (rtn == 2) {
		alert('已经存在相同的证件号,不能再建卡')
	} else if (rtn == 1) {
		alert('姓名,性别,出生年月都相同的人已经存在\n请查看下面列表中是否已经存在')
	}
	*/
	name=DHCC_CharTransAsc(name);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch.List&Name=" + name + "&BirthDay=" + birth + "&CredNo=" + CredNo + "&Sex=" + sex + "&Age=" + Age+"&PatYBCode="+PatYBCode+"&InMedicare="+InMedicare+"&CredTypeID="+CredTypeID;
	if (parent.frames["DHCCardSearch"])
		parent.frames["DHCCardSearch"].location.href = lnk;
}
function InitPicture()
{	
	return;
	
	var PAPMIRowID="";
	var obj=document.getElementById("PAPMIRowID");
	if (obj) PAPMIRowID=obj.value;

	ShowPicByPatientID(PAPMIRowID,"imgPic"); //DHCWeb.OPCommon.js	
}

function ChangeStrToPhotoNew(PAPMIDR,CredNo)
{
	try{
		var Photo= new ActiveXObject("PhotoProject.Photo");
		var FileName="c:\\"+PAPMIDR+".bmp"
		Photo.FileName=FileName; //保存图片的名称包括后缀
		Photo.PatientID=PAPMIDR //PA_PatMas表的ID
		Photo.ChangePicture()
		if (PicFileIsExist(FileName)){
			Photo.AppName="picture/" //ftp目录
			Photo.DBFlag="1"  //是否保存到数据库  0  1
			Photo.FTPFlag="1" //是否上传到ftp服务器  0  1 
			Photo.SaveFile() //对于已经存在图片保存到数据库同时上传FTP的标志有效
		}
	}catch(e){}
}
function SetRequiredFlag()
{
	//obj.className = 'clsRequired';
	var obj=document.getElementById("cName");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cBirth");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cSex");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCredNo");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cTelHome");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cPatType");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cProvinceInfo");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCityDesc");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCTArea");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cAddress");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cForeignName");
	if (obj) obj.className = 'clsRequired';
	//医保卡号需要根据是否医保判断
	//家庭地址、联系人是根据是否有证件判断是否必填
	if (MedicalFlag==0) return false;
	var obj=document.getElementById("cCountryDesc");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cPAPERMarital");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cProvinceHouse");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCityhouse");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cAreaHouse");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cVocation");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCTRelationDR");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cForeignPhone");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cProvinceBirth");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCityBirth");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cAreaBirth");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cRegisterPlace");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cNationDesc");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cInMedicare");
	if (obj) obj.className = 'clsRequired';
	var obj=document.getElementById("cCompany");
	if (obj) obj.className = 'clsRequired';
}
function GetPatInfoMedUnionCardHandler(e) {
	if (evtName == 'MedUnionCard') {
		window.clearTimeout(evtTimer);
		evtTimer = '';
		evtName = '';
	}
	var key = websys_getKey(e);
	if (key == 13) {
		GetPatInfoMedUnionCard();
	}
}
function BModifyInfo_click()
{
	var obj=document.getElementById("PAPMIRowID");
	if(!obj||(obj.value=="")){
		alert("请先选择病人记录,再更新.");
		return;
	}  
	CardTypeDefine_Key();
	YBflag=checkPatYBCode();
	if(YBflag==false)return;
	MedicalFlag=1;
	ModifiedFlag=1;
	
	//患者证件类型为身份证时，验证身份证号是否已经存在患者信息，如果存在则不能更新
	var myExpstr="";
	var myIDrtn=IsCredTypeID();
	if (myIDrtn){
		var CredNo=DHCWebD_GetObjValue("CredNo");
		if (CredNo!=""){
			myExpstr=CredNo;
		}
	}
	var myPAPMINo=DHCWebD_GetObjValue('PAPMINo');
	if (myExpstr!=""){
		var myencmeth=DHCWebD_GetObjValue("GetPatDetailByNo");
		if (myencmeth!=""){
			var myPatInfo=cspRunServerMethod(myencmeth,"",myExpstr);
			var myary=myPatInfo.split("^");
            if (myary[0]=="0"){
				var myXMLStr=myary[1];
				var obj=document.getElementById("PAPMIRowID");
				var PatientID=myXMLStr.split("<PAPMIRowID>")[1].split("</PAPMIRowID>")[0];
				if ((PatientID!="")&&(PatientID!=obj.value)){
				    alert("此身份证已经被使用!")
				    websys_setfocus('CredNo');
		            return false;
				}
			}
		}
	}
	
	
	SaveDataToServer();
	ModifiedFlag=0;
	MedicalFlag=0;
}
///lxz 获取响应时间的元素对象兼容火狐和IE
function GetEventElementObj()
{
	var isIE=document.all ? true : false;  
	var obj = null;  
	if(isIE==true){  
		obj = document.elementFromPoint(event.clientX,event.clientY);  
	}else{  
		e = arguments.callee.caller.arguments[0] || window.event;   
		obj = document.elementFromPoint(e.clientX,e.clientY);  
	}  
	return obj
}
//获取年龄--年用来比较
function AgeForYear(strBirthday)
{
	if (dtformat=="YMD"){
		var strBirthdayArr=strBirthday.split("-");
	    var birthYear = strBirthdayArr[0];
	    var birthMonth = strBirthdayArr[1];
	    var birthDay = strBirthdayArr[2];
	}
	if (dtformat=="DMY"){
		var strBirthdayArr=strBirthday.split("/");
	    var birthYear = strBirthdayArr[2];
	    var birthMonth = strBirthdayArr[1];
	    var birthDay = strBirthdayArr[0];
	}
		
	    var d = new Date();
	    var nowYear = d.getFullYear();
	    var nowMonth = d.getMonth() + 1;
	    var nowDay = d.getDate();
		var ageDiff = nowYear - birthYear ; //年之差
		return ageDiff

}
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    if (dtformat=="YMD"){
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
	}
    if (dtformat=="DMY"){
	    var seperator1 = "/";
	    var currentdate = strDate + seperator1 + month + seperator1 + date.getFullYear()
	}
    return currentdate;
}  
function CheckBirthAndBirthTime()
{
	var Today=new Date();
	var mytime=Today.getHours() //+":"+Today.getMinutes()+":"+Today.getSeconds(); 
	var CurMinutes= Today.getMinutes();
	if (CurMinutes<=9){
		CurMinutes="0"+CurMinutes;
	}
	mytime=mytime+":"+CurMinutes;
	var CurSeconds= Today.getSeconds();
	if (CurSeconds<=9){
		CurSeconds="0"+CurSeconds;
	}
	mytime=mytime+":"+CurSeconds;
	var Today=getNowFormatDate() ;//Today.getFullYear()+"-"+(Today.getMonth()+1)+"-"+Today.getDate() 
	var myBirth=DHCWebD_GetObjValue("Birth");
	if(myBirth==Today){
		var BirthTime=DHCWebD_GetObjValue("BirthTime");
		if(BirthTime!=""){
			if(BirthTime.split(":").length==2){
				BirthTime=BirthTime+":00"
			}
		}
		//alert(BirthTime+","+mytime)
		BirthTime=BirthTime.replace(/:/g,"")
		mytime=mytime.replace(/:/g,"")
		if(parseInt(BirthTime)>parseInt(mytime)){
			return true
		}else{
			return false
		}
	}
	return false;
}
function checkPatYBCode()
{
	var myobj=document.getElementById("PatType");
	var PatYBCode=document.getElementById('PatYBCode').value;
    if(myobj) var myPatType=myCombAry["PatType"].getSelectedValue();
	if (myobj.value=="") {
		alert("请选择病人类型！");
		websys_setfocus('PatType');
		return false;
	}
	var PatypeDrArray=myPatType.split("^")
	var PatypeDr=PatypeDrArray[0]
	var rtn=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetInsurFlag",PatypeDr);
	if ((rtn==0)&&(PatYBCode!="")) {
		alert("非医保病人，医保卡号不可填")
		websys_setfocus('PatYBCode');
		return false;
	}
	if((rtn!=0)&&(PatYBCode=="")) {
		alert("医保病人，请填写正确的医保卡号")
		websys_setfocus('PatYBCode');
		return false;
	}
	return true;
}
function IntListItemNew()
{  
	var myCount=m_ListItemName.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		var myobj=document.getElementById(m_ListItemName[myIdx]);
		if ((myobj)&&(m_ListItemName[myIdx]!="CardTypeDefine")){
			myobj.onkeydown = nextfocus;
			myobj.size=1;
			myobj.multiple=false;
			if ((myobj.length>0)&&(myobj.selectedIndex=-1)){
				myobj.selectedIndex=0;
			}
		}
	}
}
function CardReportLossClick()
{
	
	var lnk = "udhccardreportloss.csp";
	win=open(lnk,"QueryReg","top=50,left=150,width=800,height=700,status=no,resizable=yes,scrollbars=yes")
	}
	
	function getHouseAddressNew(){
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		HouseAddressNew_lookuphandler();
	}
}
function getHouseAddressNewstr(str){
	
	var tmp1 = str.split("^");
	document.getElementById('RegisterPlace').value=tmp1[0];
	//document.getElementById('HouseAddress').value=tmp1[0];
	document.getElementById('RegisterPlaceID').value=tmp1[1];
	
	var rs=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","GetOlddress",tmp1[1]);
	
	
	var rs = rs.split("^");
	document.getElementById('CountryDescLookUpRowID').value=rs[9];
	document.getElementById('CountryDesc').value=rs[10];
	var obj=document.getElementById("ProvinceHouse")
	if(obj)
	{
		document.getElementById("ProvinceHouse").value=rs[0] //省(户口)
	}
	var obj=document.getElementById("ProvinceHouseLookUpRowID")
	if(obj)
	{
		document.getElementById("ProvinceHouseLookUpRowID").value=rs[1] //省(户口)ID
	}
	var obj=document.getElementById("Cityhouse")
	if(obj)
	{
		document.getElementById("Cityhouse").value=rs[2] //市(户口)
	}
	var obj=document.getElementById("CityhouseLookUpRowID")
	if(obj)
	{
		document.getElementById("CityhouseLookUpRowID").value=rs[3] //市(户口)ID
	}
	var obj=document.getElementById("AreaHouse")
	if(obj)
	{
		document.getElementById("AreaHouse").value=rs[4] //区县(户口)
	}
	var obj=document.getElementById("AreaHouseLookUpRowID")
	if(obj)
	{
		document.getElementById("AreaHouseLookUpRowID").value=rs[5] //区县(户口)ID
	}
	var obj=document.getElementById("HouseStreet")
	if(obj)
	{
		document.getElementById("HouseStreet").value=rs[6] //街道
	}
	var obj=document.getElementById("HouseStreetDR")
	if(obj)
	{
		document.getElementById("HouseStreetDR").value=rs[7] //街道ID
	}
	var obj=document.getElementById("PostCodeHouse")
	if(obj)
	{
		document.getElementById("PostCodeHouse").value=rs[8] //户口邮编
	}
 	websys_setfocus("RegisterPlace")
}



function getBirthAddressNew(){
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		BirthAddressNew_lookuphandler(); 
	}
}
function getBirthAddressNewstr(str){
	
	var tmp1 = str.split("^");
	document.getElementById('BirthAddressNew').value=tmp1[0];
	//document.getElementById('BirthAddress').value=tmp1[0];
	document.getElementById('BirthAddressNewID').value=tmp1[1];
	var rs=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","GetOlddress",tmp1[1]);
	var rs = rs.split("^");
	var obj= document.getElementById("ProvinceBirth")
	if(obj)
	{
		obj.value=rs[0] //省(户口)
	}
	var obj= document.getElementById("ProvinceBirthLookUpRowID")
	if(obj)
	{
		obj.value=rs[1] //省(户口)ID
	}
	var obj= document.getElementById("CityBirth")
	if(obj)
	{
		obj.value=rs[2] //市(户口)
	}
	var obj= document.getElementById("CityBirthLookUpRowID")
	if(obj)
	{
		obj.value=rs[3] //市(户口)ID
	}
	var obj= document.getElementById("AreaBirth")
	if(obj)
	{
		obj.value=rs[4] //区县(户口)
	}
	var obj= document.getElementById("CityAreaLookUpRowID")
	if(obj)
	{
		obj.value=rs[5] //区县(户口)ID
	}
	var obj= document.getElementById("Street")
	if(obj)
	{
		obj.value=rs[6] //街道(户口)
	}
	var obj= document.getElementById("StreetDR")
	if(obj)
	{
		obj.value=rs[7] //街道(户口)ID
	}
	/*
	document.getElementById("ProvinceBirthLookUpRowID").value=rs[1] //省(户口)ID
	document.getElementById("CityBirth").value=rs[2] //市(户口)
	document.getElementById("CityBirthLookUpRowID").value=rs[3] //市(户口)ID
	document.getElementById("AreaBirth").value=rs[4] //区县(户口)
	document.getElementById("AreaBirthLookUpRowID").value=rs[5] //区县(户口)ID
	document.getElementById("BirthStreet").value=rs[6] //街道(户口)
	document.getElementById("BirthStreetDR").value=rs[7] //街道(户口)ID
	//document.getElementById("Cpostalcode").value=rs[8] //Cpostalcode
	*/
	
 	websys_setfocus("BirthAddressNew")
} 

function getaddressNewNewstr(str){
	var tmp1 = str.split("^");
	document.getElementById('Address').value=tmp1[0];
	//document.getElementById('address').value=tmp1[0];
	document.getElementById('AddressID').value=tmp1[1];
	var rs=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","GetOlddress",tmp1[1]);
	var rs = rs.split("^");
	
	myCombAry["CountryHouse"].setComboValue(rs[9]);
	var obj= document.getElementById("ProvinceInfo")
	if(obj)
	{
		document.getElementById("ProvinceInfo").value=rs[0] //省
	}
	var obj= document.getElementById("ProvinceInfoLookUpRowID")
	if(obj)
	{
		document.getElementById("ProvinceInfoLookUpRowID").value=rs[1] //省
	}
	var obj= document.getElementById("CityDesc")
	if(obj)
	{
		document.getElementById("CityDesc").value=rs[2] //
	}
	var obj= document.getElementById("CityDescLookUpRowID")
	if(obj)
	{
		document.getElementById("CityDescLookUpRowID").value=rs[3] //市ID
	}
	var obj= document.getElementById("CTArea")
	if(obj)
	{
		document.getElementById("CTArea").value=rs[4] //区县
	}
	var obj= document.getElementById("CityAreaLookUpRowID")
	if(obj)
	{
		document.getElementById("CityAreaLookUpRowID").value=rs[5] //区ID
	}
	var obj= document.getElementById("Street")
	if(obj)
	{
		document.getElementById("Street").value=rs[6] //街道
	}
	var obj= document.getElementById("StreetDR")
	if(obj)
	{
		document.getElementById("StreetDR").value=rs[7] //街道ID
	}
	var obj= document.getElementById("PostCode")
	if(obj)
	{
		document.getElementById("PostCode").value=rs[8] //住址邮政编码
	}
	var obj= document.getElementById("Zip")
	if(obj)
	{
		document.getElementById("Zip").value=rs[8] //住址邮政编码
	}
 	websys_setfocus("Address")
} 
function getAddressNew(){
	
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		AddressNew_lookuphandler(); 
	}
}
function CheckTelOrMobile(telephone,Name,Type){
	if (DHCC_IsTelOrMobile(telephone)) return true;
	//if (telephone.indexOf('-')>=0){
	if (telephone.substring(0,1)==0){
		//if(telephone.length<12){
		if (telephone.indexOf('-')>=0){
			alert(Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!")
			websys_setfocus(Name);
	        return false;
		}else{
			alert(Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!")
			websys_setfocus(Name);
	        return false;
		}
		//}
	}else{
		if(telephone.length!=11){
			alert(Type+"联系电话电话长度应为【11】位,请核实!")
			websys_setfocus(Name);
	        return false;
		}else{
			alert(Type+"不存在该号段的手机号,请核实!")
			websys_setfocus(Name);
	        return false;
		}
	}
	return true;
}


//验证使用登记号作有没有为卡号时候登记号作为卡号有没有被使用
function CheckForUsePANoToCardNO()
{
	
	var PAPMINO=DHCWebD_GetObjValue("PAPMINo");
	if (UsePANoToCardNO=="Y"){
		 if (PAPMINO!=""){
			 DHCWebD_SetObjValueC("CardNo",PAPMINO);
			 var myPAPMIStr=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetPAPMIInfoByCardNo",PAPMINO,m_SelectCardTypeRowID);
			 if (myPAPMIStr!=""){
				 	alert("该登记号已经作为卡号存在,不能再次使用建卡!")
				 	DHCWebD_SetObjValueC("CardNo","");
				 	var Obj=document.getElementById('NewCard');
					if (Obj) {
						DHCWeb_DisBtnA("NewCard");
						Obj.onclick = "";
					}
			 }else{
				 	var Obj=document.getElementById('NewCard');
					if (Obj) {
						DHCC_AvailabilityBtn(Obj)
						Obj.onclick = NewCard_click;
					}
			 }
		 }else{
			 	var Obj=document.getElementById('NewCard');
				if (Obj) {
					DHCC_AvailabilityBtn(Obj)
					Obj.onclick = NewCard_click;
				}
		 }
				
	}
}

///判断是否要使用APP患者录入的建大病历的暂存信息,如果使用则输出XML，调用SetPatInfoByXML方法完成页面赋值
///支持传入病人Rowid 或 病人登记号，传一个即可
function GetRegMedicalEPMI(PAPMIRowID,PAPMINo) {
	if ((PAPMIRowID=="")&&(PAPMINo=="")) return "";

	var ret=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","IsNeedRegMedicalEPMI",PAPMIRowID,PAPMINo);
	if (ret.split('^')[0]=="1") {
		var PAPMINo=ret.split('^')[1];
		var conFlag=confirm("患者没有病案号且已经在手机APP上注册了大病历信息，是否载入？");
		if (conFlag) {
			var ExpStr="^1"
			var PAPMIXMLStr=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatInfoByPANo",PAPMINo,ExpStr);
			if (PAPMIXMLStr.split('^')[0]=="0") return PAPMIXMLStr.split('^')[1];
		}
	}
	return "";
}