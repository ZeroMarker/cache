/////UDHCCardCancel.js


    var Guser;//操作用户
	var GuserCode;//操作用户代码
	var RegNo;//登记号
	var PatientID;//病人唯一主索引
	var PatName;//病人姓名
	var CardNo;//卡号
	var CardVerify;//卡的安全号
	var ExchCardVerify;//新卡的安全号
	var IDCardNo;//身份证号
	var RLAccBalance;
	var RLCredNo;//挂失人证件号码
	var RLCredType;//挂失人证件类型
	var RLCredTypeID;//挂失人证件类型代码
	
	var bcheckpwd;
	var bcheckcred;
	var computername;
	var m_CardNoLength=0;
	var m_SelectCardTypeDR="";	
	var m_CardTypeRowID="";
	var m_PatCardStChangeValidate="";
	
	var today;	
	var RLCredTypeListObj;
	var RegNoobj;
	var CardNoobj;
	var CardIDobj;
	var PatNameobj;
	var PatientIDobj;
	var IDCardNoobj;
	var ActiveFlagobj;
	var Flagobj;
	var CredTypeobj;
	var getpatclassobj;
	var Grantobj;
	///var ReportTheLossobj;
	var Cancelobj;
	var Clearobj;
	var RLNameobj;
	var RLCredTypeobj;
	var RLCredTypeIDobj;
	var RLCredNoobj;
	var RLAddressobj;
	var RLPhoneNoobj;
	var RLRemarkobj;
	var e=event;
function BodyLoadHandler() {	
	
	Guser=session['LOGON.USERID']
	document.getElementById('UserDR').value=Guser;
	GuserCode=session["LOGON.USERCODE"];
	RegNoobj=document.getElementById('RegNo');
	CardNoobj=document.getElementById('CardNo');
	CardIDobj=document.getElementById('CardID');
	PatNameobj=document.getElementById('PatName');
	PatientIDobj=document.getElementById('PatientID');
	IDCardNoobj=document.getElementById('IDCardNo');
	CredTypeobj=document.getElementById('CredType');
	ActiveFlagobj=document.getElementById('ActiveFlag');
	Flagobj=document.getElementById('Flag');
	getpatclassobj==document.getElementById('getpatclass');
	///ReportTheLossobj=document.getElementById('ReportTheLoss');
	Clearobj=document.getElementById('Refresh');	
	RLNameobj=document.getElementById('RLName');
	RLCredTypeobj=document.getElementById('RLCredType');
	RLCredTypeIDobj=document.getElementById('RLCredTypeID');
	RLCredNoobj=document.getElementById('RLCredNo');
	RLAddressobj=document.getElementById('RLAddress');
	RLPhoneNoobj=document.getElementById('RLPhoneNo');
	RLRemarkobj=document.getElementById('RLRemark');
	DHCWebD_ClearAllListA('CardTypeDefine');
	if (RLCredNoobj) RLCredNoobj.onkeydown = RLCredNo_Click;

	RLNameobj.onkeydown = nextfocus;
	RLAddressobj.onkeydown = nextfocus;
	RLPhoneNoobj.onkeydown = nextfocus;
	RLRemarkobj.onkeydown = nextfocus;
	
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
		myobj.disabled=true;
	}
	loadCardType();
	///if (ReportTheLossobj) ReportTheLossobj.onclick = ReportTheLoss_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	if (RLCredNoobj) RLCredNoobj.onkeydown=RLCredNo_Click;
	RLCredTypeListObj=document.getElementById('RLCredTypeList');
	if (RLCredTypeListObj){
		RLCredTypeListObj.onkeydown = nextfocus;
		RLCredTypeListObj.size=1;
		RLCredTypeListObj.multiple=false;	
	}
	
	var myobj=document.getElementById('bReturn');
	if (myobj){
		myobj.onclick=ReturnManageMainWithCardID;
	}
	
    CardNoobj.readOnly=true;
    ActiveFlagobj.readOnly=true;
    Flagobj.readOnly=true;
    IDCardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    RegNoobj.readOnly=true;
    CardVerify="";
    bcheckpwd="";
    bcheckcred="";
	m_PatCardStChangeValidate="";
    
	///getdefaultcredtype()
	//DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RLCredTypeList");
	}
	
	document.onkeydown=Doc_OnKeyDown;
	
	DHCWeb_DisBtnA("BtnCancel");
	
	if (CardIDobj.value!=""){
		getpatbycard();
		websys_setfocus('RLName');		
	}
    
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
}

function Doc_OnKeyDown()
{
	//nextfocus();
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
	
	///F8119
	if (key==119){
		var myobj=document.getElementById("BtnCancel");
		{
			if (!myobj.disabled){
				BtnCancel_Click();
			}
		}
	}
	
	///F9120
	if (key==120){
		//Clear_Click();
	}
	
	////F7
	if (key==118){
		Clear_Click();
	}

}

function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}

	//获取卡类型的基本配置
	//同时要求初始化界面
	//继续.....
	
	///alert(myary);

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
	///CTD_StChangeValidate			27	    是否需要验证
	m_CardNoLength=myary[17];
	m_PatCardStChangeValidate=myary[27];	
}

function SetCardNOLength(){
	var obj=document.getElementById('RCardNo');
	if (obj.value!='') {
		if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
			for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
				obj.value="0"+obj.value
			}
		}
		var myCardobj=document.getElementById('CardNo');
		if (myCardobj){
			myCardobj.value=obj.value;
		}
	}
}

function getdefaultcredtype()
{
	var getregno=document.getElementById('getcredtypeClass');
	if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth);
	var myarray=rtn.split("^");
	if (myarray[0]=='0')
	{
		RLCredTypeListObj.value=myarray[2];
		RLCredTypeIDobj.value=myarray[2];
	}
}
function getRLCredTypeid(value) {	
	var val=value.split("^");	
	RLCredTypeIDobj.value=val[1];
}

function Clear_Click()
{	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardCancel";
}

function getpatbycard()
{
	if (CardIDobj.value!="")
	{
		p1=CardIDobj.value			
		var getregno=document.getElementById('ReadCardPatEncrypt');
		if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'setpatinfo_val','',p1)=='1'){

		}		
	}
}

function setListBoxValue(controlName,val)
{
	var list=document.getElementById(controlName);
	for(i=0;i<list.options.length;i++)
	{
		var myary=list.options[i].value.split("^");
		if(myary[0]==val){
			list.selectedIndex=i;
		}
			
	}
	
}
	
function setpatinfo_val(value)
	{
		//RegNo_"^"_Papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_cardverify2_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo_"^"_CardID_"^"_FlagName_"^"_Balance_"^"_CredNo_"^"_CredType_"^"_CredTypeID_"^"_address_"^"_phone
		var val=value.split("^");	
		
		if (val[4]!="")
		{
			RegNoobj.value=val[0];
			RegNo=val[0];
			PatientIDobj.value=val[1];
			PatNameobj.value=val[2];
			RLNameobj.value=val[2];
			IDCardNoobj.value=val[3];
			//CredTypeobj.value=val[13];
			setListBoxValue('RLCredTypeList',val[14]);
			RLCredNoobj.value=val[3];
			CardNoobj.value=val[4];	
			ActiveFlagobj.value=val[6];
			RLAddressobj.value=val[15];
			RLPhoneNoobj.value=val[16];
			Flagobj.value=val[10];
			setListBoxValue('CardTypeDefine',val[17]);
			DHCWebD_SetObjValueC('CardFareCost',val[18]);
			DHCWebD_SetObjValueC('ReceiptNO',val[19]);
			DHCWebD_SetObjValueC("Sex",val[20]);
			DHCWebD_SetObjValueC("Birth",val[21]);
			
			var myTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine")
			if (myTypeValue!=""){
				var myary=myTypeValue.split("^");
				if (myary[7]=="Y"){
					var myobj=document.getElementById("BtnCancel");
					if (myobj){
						DHCC_AvailabilityBtn(myobj) ;
						myobj.onclick=BtnCancel_Click;
					}
				}else{
					DHCWeb_DisBtnA("BtnCancel");
					alert(t["NotCanBack"]);
				}
			}
		}
		else
		{
			RegNoobj.value="";
			RegNo="";
			PatientIDobj.value="";
			PatNameobj.value="";
			IDCardNoobj.value="";
			CredTypeobj.value="";
			CardIDobj.value="";
		    ActiveFlagobj.value="";
		}
	}
	
function RLCredNo_Click()
{
	bcheckcred=""
	var key=websys_getKey(e);
	if (key==13) 
	{
		if(m_PatCardStChangeValidate=="Y")
		{
			if (RLCredNoobj.value!="")
			{
				var mytmparray=RLCredTypeListObj.value.split("^");
				var CredTypeID=CredTypeobj.value;			
				if (IDCardNoobj.value==RLCredNoobj.value &&( CredTypeID==mytmparray[0] || CredTypeID==""))
				{	
					bcheckcred="OK";
					///ReportTheLossobj.disabled=false;
					websys_setfocus('RLPhoneNo');
				}
				else
				{
					///ReportTheLossobj.disabled=true;
					alert(t[2066]);
					websys_setfocus('RLCredNo');
					return;
				}
			}
			else
			{
				bcheckcred="F";
				///ReportTheLossobj.disabled=true;
				alert(t[2066])
				websys_setfocus('RLCredNo');
				return;
			}
		}
		else
		{
			bcheckcred="OK";
			
			///ReportTheLossobj.disabled=false;
			///ReportTheLossobj.onclick = ReportTheLoss_Click;
			//alert(t[2087]);
			websys_setfocus('RLPhoneNo');
		}
	}
}

function CheckRptLoss()
{
	if (CardIDobj.value=="")
	{
		alert(t[2018])			 
		return false;
	}
	var CardStatusFlag=DHCWebD_GetObjValue("Flag");
	if (CardStatusFlag!="正常"){
		alert("非正常卡不能退卡!")
		return false;
	}
	if (ActiveFlagobj.value!="N")
	{
		//alert(t[2018])
		//return false;
	}
	return true;
}

function BtnCancel_Click() 
{
	var myrtn=confirm("患者就诊是否完成?");
	if (!myrtn){
		return;
	}
	
	var rtn=CheckRptLoss();
	if(!rtn)
	{
		return;
	}
	var mytmparray=RLCredTypeListObj.value.split("^");
	
	//var RLCredTypeIDobj=document.getElementById("RLCredTypeID");
	//RLCredTypeIDobj.value=combo_zone1.value;
	//记录操作电脑的名字
   var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_SetObjValueA("ComputerIP",computername);
	var ParseInfo=DHCWebD_GetObjValue("InitCardStatusChangeEntity");
	var myCardInfo=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
	var getregno=document.getElementById('ReadCardCancelEncrypt');
	if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	var encmeth=DHCWebD_GetObjValue("ReadCardCancelEncrypt");
	/// UserDR , sFlag , CardStatusChangeInfo , ExpStr
	var myUserDR=session['LOGON.USERID'];
	var myExpStr=session['LOGON.HOSPID'];
	var myrtn=cspRunServerMethod(encmeth,myUserDR,"A",myCardInfo, myExpStr)
	var myrtnAry=myrtn.split('$');			
	if(myrtnAry[0]=='-355')//非正常卡不能挂失
	{
		alert(t[2087]);
	}
	else if(myrtnAry[0]=='-373')//非正常卡不能挂失
	{
		alert("卡对应着有效账户,不能办理退卡,建议使用门诊账户结算");
	}
	else if(myrtnAry[0]==0)//挂失成功
	{
		alert(t[2016]);
		//Clear_Click();
		var InvInfo=myrtnAry[1];
		var myParkRowID=myrtnAry[2];
		//BillPrintDeposit(InvInfo);
		PatRegPatInfoPrint(myParkRowID,"UDHCCardInvPrt2","ReadAccCarDPEncrypt")
		//ReturnManageMain();
		ReSearchClick()
	}
	else
	{
		alert(t[2017]);//
	}
	
}

function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function ReturnManageMain(){
	//window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardMana&CardID=";
}
function ReturnManageMainWithCardID(){
	var myValue=DHCWebD_GetObjValue("CardID");
	//window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardMana&CardID=" + myValue;
}

function BillPrintDeposit(INVstr){
	var PrtXMLName="UDHCAccDeposit";
	DHCP_GetXMLConfig("InvPrintEncrypt","UDHCAccDeposit");
	if (PrtXMLName==""){
		return;
	}
	var INVtmp=INVstr.split("^");
	for (var invi=0;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var encmeth=DHCWebD_GetObjValue("ReadAccDPEncrypt");
			///var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintDeposit",PrtXMLName,INVtmp[invi], Guser, myExpStr);
		}
	}
}

function InvPrintDeposit(TxtInfo,ListInfo){
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	//DHCP_GetXMLConfig("InvPrintEncrypt","UDHCAccDeposit2")
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}
//调用js 函数 退卡打印收据
///参数：dhc_cardinvprt Rowid，"UDHCCardInvPrt", "ReadAccCarDPEncrypt"
//PatRegPatInfoPrint("","UDHCCardInvPrt","ReadAccCarDPEncrypt")
function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName)
{
	if (CurXMLName==""){
		return;
	}
	var INVtmp=RowIDStr.split("^");
	if (INVtmp.length>0)
	{
		DHCP_GetXMLConfig("InvPrintEncrypt",CurXMLName);
	}
	for (var invi=0;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var encmeth=DHCWebD_GetObjValue(EncryptItemName);
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew","",INVtmp[invi], Guser,"");
			   
	}			
	}
}
function InvPrintNew(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

function ReSearchClick(){
	parent.parent.frames[0].ReSearch()
	//alert(window.name)
	//alert(parent.frames[0].window.name)
	//alert(parent.parent.frames[1].window.name)	
	
	}

document.body.onload = BodyLoadHandler; 
