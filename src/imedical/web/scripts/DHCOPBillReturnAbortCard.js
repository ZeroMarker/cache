var DOPInfo_ReadInfoType=0;

var m_Version="";
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var AccCardRowid=""
var CardFlagValue=""
function BodyLoadHandler() 
{
	ValidateDocumentData()
	//读卡
	var obj=document.getElementById("ReadCard");
	if (obj)
	{
		obj.onclick=ReadHFMagCard_Click;
	}
	//卡类型
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
	}
	//退卡
	DHCWeb_DisBtnA("RetCard");
	//var obj=document.getElementById("RetCard");
	//if (obj)
	//{
	//	obj.onclick=BtnCancel_Click;
	//}
	CardTypeDefine_OnChange();
}
function ReadHFMagCard_Click()
{
	var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");

	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
	}
	var myary=myrtn.split("^");
	var rtn=myary[0];
	CardFlagValue=myary[0];
	switch (rtn)
	{
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			var obj=document.getElementById("RCardNo");
			obj.value=myary[1];
			var obj=document.getElementById("PatName");
			obj.value=myary[3];
			var obj=document.getElementById("CardStatus");
			obj.value=myary[9];
			AccCardRowid=myary[8];
			//
			var myobj=document.getElementById("RetCard");
			if (myobj)
			{
				myobj.disabled=false;
				myobj.onclick=BtnCancel_Click;
			}
			break;
		case "-200":
			alert("该卡为无效卡");
			Clear_Click();
			break;
		case "-1":
			var obj=document.getElementById("RCardNo");
			obj.value=myary[1];
			alert("此卡为挂失卡");
			Clear_Click();
			break;
		case "-2":
			var obj=document.getElementById("RCardNo");
			obj.value=myary[1];
			alert("此卡已经回收");
			Clear_Click();
			break;
		case "-3":
			var obj=document.getElementById("RCardNo");
			obj.value=myary[1];
			alert("此卡正在使用");
			Clear_Click();
			
			break;
		default:
			///alert("");
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
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
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
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("RCardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		///DHCWeb_DisBtnA("ReadPCSC");
	}
	else
	{
		var ReloadFlag=document.getElementById("ReloadFlag");
		var vReloadFlag=ReloadFlag.value;
		if ((vReloadFlag!="3")&&(vReloadFlag!="2"))
		{
			var myobj=document.getElementById("RCardNo");
			if (myobj)
			{
				myobj.readOnly = true;
			}
			var obj=document.getElementById("ReadCard");
			if (obj)
			{
				obj.disabled=false;
				obj.onclick=ReadHFMagCard_Click;
			}
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle")
	{
		DHCWeb_setfocus("RCardNo");
	}else{
		DHCWeb_setfocus("ReadPCSC");
	}
	
	m_CardNoLength=myary[17];
}
function ValidateDocumentData()
{
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj)
	{
		myobj.size=1;
		myobj.multiple=false;
	}	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!="")
	{
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function BtnCancel_Click() 
{
	
	//AccCardRowid
	var myUserDR=session['LOGON.USERID'];
	var CancleObj=document.getElementById('ReadCardCancelEncrypt');
	if (CancleObj) {var encmeth=CancleObj.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,AccCardRowid,myUserDR,"S");		
	if(rtn!="0")
	{
		alert("作废失败");
		return;
	}
	else 
	{
		alert("作废成功");
		var Obj=document.getElementById('GetCurrValue');
		if (Obj) {var encmeth=Obj.value} else {var encmeth=''};
		var rtn=cspRunServerMethod(encmeth);		
		DHCP_GetXMLConfig("InvPrintEncrypt","UDHCCardInvPrt");
		Print_Click(rtn);
		DHCP_GetXMLConfig("InvPrintEncrypt","UDHCCardInvPrt2");
		Print_Click1(rtn);
	}
	
	
}

function Print_Click(value)
{
	var myUserCode=session['LOGON.USERCODE'];
	var obj=document.getElementById("RCardNo");
	var CardNoValue=obj.value
	var obj=document.getElementById("PatName");
	var PatNameValue=obj.value
	var myary=value.split("^");
	var TxtInfo,ListInfo
	var c=String.fromCharCode(2)
	TxtInfo="PatNo"+c+CardNoValue+"^"+"PatName"+c+PatNameValue+"^"+"CostsUpper"+c+myary[2]+"^"+"Amount"+c+myary[1]+"^"
	TxtInfo=TxtInfo+"UsrCode"+c+myUserCode+"^"+"PrintDate"+c+myary[0]
	ListInfo=""
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}	
function Print_Click1(value)
{
	Print_Click(value)
}		
function Clear_Click() 
{
	var obj=document.getElementById("RegNo");
	obj.value="";
	var obj=document.getElementById("PatName");
	obj.value="";
	var obj=document.getElementById("CardStatus");
	obj.value="";
}
document.body.onload = BodyLoadHandler;
