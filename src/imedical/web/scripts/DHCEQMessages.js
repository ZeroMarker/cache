function BodyLoadHandler() 
{
	KeyUp("FromUser^FromLoc^FromRole^ToUser^ToLoc^ToRole^SendUser^DealUser^BussType^ReadUser^EmergencyLevel","N");
	Muilt_LookUp("FromUser^FromLoc^FromRole^ToUser^ToLoc^ToRole^SendUser^DealUser^BussType^ReadUser^EmergencyLevel")
    InitUserInfo(); //系统参数
	fillData()
	InitEvent();
	//modified by zy 2011-02-18 ZY0055
	//Modified by JDL 2011-3-2 jdl0071
	//DoReadAction()
	SetEnabled();
	SendType()
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BSend")
	if (obj) obj.onclick=BSend_Click;
	var obj=document.getElementById("BReturn")
	if (obj) obj.onclick=BReturn_Click;
	var obj=document.getElementById("SendType")
	if (obj) obj.onchange=SendType;
}

function SendType()
{
	var value=GetElementValue("SendType")
	if (value=="0") //0?发送到指定人
	{
		DisableElement("ToUser",false);
		DisableElement("ToLoc",true);
		DisableElement("ToRole",true);
		DisableElement("SendAll",true);
		ReadOnlyElement("ToUser",false);
		HiddenObj(GetLookupName("ToUser"),false);
		ReadOnlyElement("ToLoc",true);
		ReadOnlyElement("ToRole",true);
		HiddenObj(GetLookupName("ToRole"),true);
		ReadOnlyElement("SendAll",true);
	}else if (value=="1") //1:发送到指定科室
	{
		DisableElement("ToUser",true);
		DisableElement("ToLoc",false);
		DisableElement("ToRole",true);
		ReadOnlyElement("ToUser",true);
		ReadOnlyElement("ToLoc",false);
		ReadOnlyElement("ToRole",true);
	}else if (value=="2") //2?发送到指定角色 
	{
		DisableElement("ToUser",true);
		DisableElement("ToLoc",true);
		DisableElement("ToRole",false);
		DisableElement("SendAll",false);
		ReadOnlyElement("ToUser",true);
		HiddenObj(GetLookupName("ToUser"),true);
		ReadOnlyElement("ToLoc",true);
		ReadOnlyElement("ToRole",false);
		HiddenObj(GetLookupName("ToRole"),false);
		ReadOnlyElement("SendAll",false);
	}else if (value=="3") // 3?发送到指定科室的指定角色
	{
		DisableElement("ToUser",true);
		DisableElement("ToLoc",false);
		DisableElement("ToRole",false);
		ReadOnlyElement("ToUser",true);
		ReadOnlyElement("ToLoc",false);
		ReadOnlyElement("ToRole",false);
	}else if (value=="9") //9:其他
	{
		DisableElement("ToUser",true);
		DisableElement("ToLoc",true);
		DisableElement("ToRole",true);
		ReadOnlyElement("ToUser",true);
		ReadOnlyElement("ToLoc",true);
		ReadOnlyElement("ToRole",true);
		HiddenObj(GetLookupName("ToUser"),true);
		HiddenObj(GetLookupName("ToRole"),true);
	}
}
function BUpdate_Click()
{
	if (condition()) return;
	var SendType=GetElementValue("SendType");
	if (SendType==0)
	{
		if (GetElementValue("ToUser")=="")
		{
			alertShow("接收人不能为空!")
			return
		}
	}
	else if (SendType==1)
	{		
		if (GetElementValue("ToLoc")=="")
		{
			alertShow("接收科室不能为空!")
			return
		}
	}
	else if (SendType==2)
	{
		if (GetElementValue("ToRole")=="")
		{
			alertShow("接受角色不能为空!")
			return
		}
	}
	else if (SendType==3)
	{
		if ((GetElementValue("ToLoc")=="")||(GetElementValue("ToRole")==""))
		{
			alertShow("没有接收单位!")
			return
		}
	}
	else if (SendType==9)
	{
		alertShow("没有接收单位!")
		return;
	}
	
	
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist);
	if (result>0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMessages&RowID='+result;
	}
	else
	{
		alertShow(result)
	}
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Title") ;//2
	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;//3
	combindata=combindata+"^"+GetElementValue("ManageLocDR") ;//4
	combindata=combindata+"^"+GetElementValue("MessageTypeDR") ;//5
	combindata=combindata+"^"+GetChkElementValue("SendAll") ;//6
	combindata=combindata+"^"+GetChkElementValue("SendEmailFlag") ;//7
	combindata=combindata+"^"+GetChkElementValue("MobileMessageFlag") ;//8
	combindata=combindata+"^"+GetElementValue("SendType") ;//9
	combindata=combindata+"^"+GetElementValue("SendUserDR") ;//10
	combindata=combindata+"^"+GetElementValue("SendDate") ;//11
	combindata=combindata+"^"+GetElementValue("SendTime") ;//12
	combindata=combindata+"^"+GetElementValue("FromUserDR") ;//13
	combindata=combindata+"^"+GetElementValue("FromLocDR") ;//14
	combindata=combindata+"^"+GetElementValue("FromRoleDR") ;//15
	combindata=combindata+"^"+GetElementValue("ToUserDR") ;//15
	combindata=combindata+"^"+GetElementValue("ToLocDR") ;//16
	combindata=combindata+"^"+GetElementValue("ToRoleDR") ;//17
	combindata=combindata+"^"+GetElementValue("Info") ;//18
	combindata=combindata+"^"+GetElementValue("ReadUserDR") ;//19
	combindata=combindata+"^"+GetElementValue("ReadDate") ;//20
	combindata=combindata+"^"+GetElementValue("ReadTime") ;//21
	combindata=combindata+"^"+GetElementValue("DealUserDR") ;//22
	combindata=combindata+"^"+GetElementValue("DealDate") ;//23
	combindata=combindata+"^"+GetElementValue("DealTime") ;//24
	combindata=combindata+"^"+GetElementValue("BussTypeDR") ;//25
	combindata=combindata+"^"+GetElementValue("Status") ;//26
	combindata=combindata+"^"+GetElementValue("Remark") ;//27
	combindata=combindata+"^"+GetElementValue("SourceMessageDR") ;//28
	combindata=combindata+"^"+GetElementValue("EmergencyLevelDR") ;//29
	combindata=combindata+"^"+GetChkElementValue("InBoxInvalidFlag") ;//30
	combindata=combindata+"^"+GetElementValue("InBoxDelUserDR") ;//31
	combindata=combindata+"^"+GetElementValue("InBoxDelDate") ;//32
	combindata=combindata+"^"+GetElementValue("InBoxDelTime") ;//33
	combindata=combindata+"^"+GetChkElementValue("OutBoxInvalidFlag") ;//34
	combindata=combindata+"^"+GetElementValue("OutBoxDelUserDR") ;//35
	combindata=combindata+"^"+GetElementValue("OutBoxDelDate") ;//36
	combindata=combindata+"^"+GetElementValue("OutBoxDelTime") ;//37
	combindata=combindata+"^"+GetElementValue("ContactInfo") ;//38
	combindata=combindata+"^"+GetElementValue("DealFlagDR") ;//38
	combindata=combindata+"^"+GetElementValue("Hold1") ;//39
	combindata=combindata+"^"+GetElementValue("Hold2") ;//40
	combindata=combindata+"^"+GetElementValue("Hold3") ;//41
	combindata=combindata+"^"+GetElementValue("Hold4") ;//42
	combindata=combindata+"^"+GetElementValue("Hold5") ;//43
  	
  	return combindata;
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var truthBeTold = window.confirm("确定删除消息?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("DeleteData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result==0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMessages';
	}
	else
	{
		alertShow(result)
	}
}
function BSend_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SendData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result>0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMessages&RowID='+rowid;
	}
	else
	{
		alertShow("发送失败!")
	}	
}
function BReturn_Click()
{
	var	val="&SourceMessageDR="+GetElementValue("RowID");
	val=val+"&Title="+"回复:"+GetElementValue("Title");
	val=val+"&ToUser="+GetElementValue("SendUser");
	val=val+"&ToUserDR="+GetElementValue("SendUserDR");
	val=val+"&SendType=0";
	val=val+"&MessagesType="+GetElementValue("MessagesType");
	val=val+"&ReadOnly="+GetElementValue("ReadOnly");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMessages'+val;
}

function BClear_Click()
{
	SetElement("RowID","")
	SetElement("Title","")
	SetElement("EquipType","")
	SetElement("EquipTypeDR","")
	SetElement("ManageLoc","")
	SetElement("ManageLocDR","")
	SetElement("MessageType","")
	SetChkElement("SendAll","")
	SetChkElement("SendEmailFlag","")
	SetChkElement("MobileMessageFlag","")
	SetElement("SendType","")
	SetElement("SendUser","")
	SetElement("SendUserDR","")
	SetElement("SendDate","")
	SetElement("SendTime","")
	SetElement("FromUser","")
	SetElement("FromUserDR","")
	SetElement("FromLoc","")
	SetElement("FromLocDR","")
	SetElement("FromRole","")
	SetElement("FromRoleDR","")
	SetElement("ToUser","")
	SetElement("ToUserDR","")
	SetElement("ToLoc","")
	SetElement("ToLocDR","")
	SetElement("ToRole","")
	SetElement("ToRoleDR","")
	SetElement("Info","")
	SetElement("ReadUser","")
	SetElement("ReadUserDR","")
	SetElement("ReadDate","")
	SetElement("ReadTime","")
	SetElement("DealUser","")
	SetElement("DealUserDR","")
	SetElement("DealDate","")
	SetElement("DealTime","")
	SetElement("BussType","")
	SetElement("Status","")
	SetElement("Remark","")
	SetElement("SourceMessageDR","")
	SetElement("EmergencyLevelDR","")
	SetElement("EmergencyLevel","")
	SetChkElement("InBoxInvalidFlag","")
	SetElement("InBoxDelUserDR","")
	SetElement("InBoxDelUser","")
	SetElement("InBoxDelDate","")
	SetElement("InBoxDelTime","")
	SetChkElement("OutBoxInvalidFlag","")
	SetElement("OutBoxDelUserDR","")
	SetElement("OutBoxDelUser","")
	SetElement("OutBoxDelDate","")
	SetElement("OutBoxDelTime","")
	SetElement("ContactInfo","")
	SetElement("DealFlagDR","")
	SetElement("DealFlag","")
	SetElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","")

}
function fillData()
{
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1))return;
	var encmeth=GetElementValue("fillData");
	if (encmeth=="") return;
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	//Modified by JDL 2011-3-2 jdl0071
	var sort=46;
	SetElement("Title",list[0])
	SetElement("EquipTypeDR",list[1])
	SetElement("ManageLocDR",list[2])
	SetElement("MessageType",list[3])
	SetChkElement("SendAll",list[4])
	SetChkElement("SendEmailFlag",list[5])
	SetChkElement("MobileMessageFlag",list[6])
	SetElement("SendType",list[7])
	SetElement("SendUserDR",list[8])
	//SetElement("SendDate",list[9])
	//SetElement("SendTime",list[10])
	SetElement("FromUserDR",list[11])
	SetElement("FromLocDR",list[12])
	SetElement("FromRoleDR",list[13])
	SetElement("ToUserDR",list[14])
	SetElement("ToLocDR",list[15])
	SetElement("ToRoleDR",list[16])
	SetElement("Info",list[17])
	SetElement("ReadUserDR",list[18])
	//SetElement("ReadDate",list[19])
	//SetElement("ReadTime",list[20])
	SetElement("DealUserDR",list[21])
	//SetElement("DealDate",list[22])
	//SetElement("DealTime",list[23])
	SetElement("BussTypeDR",list[24])
	SetElement("Status",list[25])
	SetElement("Remark",list[26])
	SetElement("SourceMessageDR",list[27])
	SetElement("EmergencyLevelDR",list[28])
	SetChkElement("InBoxInvalidFlag",list[29])
	//SetElement("InBoxDelUserDR",list[30])
	//SetElement("InBoxDelDate",list[31])
	//SetElement("InBoxDelTime",list[32])
	SetChkElement("OutBoxInvalidFlag",list[33])
	//SetElement("OutBoxDelUserDR",list[34])
	//SetElement("OutBoxDelDate",list[35])
	//SetElement("OutBoxDelTime",list[36])
	SetElement("ContactInfo",list[37])
	SetElement("DealFlagDR",list[37])
	SetElement("Hold1",list[39])
	SetElement("Hold2",list[40])
	SetElement("Hold3",list[41])
	SetElement("Hold4",list[42])
	SetElement("Hold5",list[43])
	
	SetElement("EquipType",list[sort+0])
	SetElement("ManageLoc",list[sort+1])	
	//SetElement("MessageType",list[sort+2])
	SetChkElement("SendAll",list[sort+3])
	SetChkElement("SendEmailFlag",list[sort+4])
	SetChkElement("MobileMessageFlag",list[sort+5])
	//SetElement("SendType",list[sort+6])
	SetElement("SendUser",list[sort+7])
	SetElement("SendDate",list[sort+8])
	SetElement("SendTime",list[sort+9])
	SetElement("FromUser",list[sort+10])
	SetElement("FromLoc",list[sort+11])
	SetElement("FromRole",list[sort+12])
	SetElement("ToUser",list[sort+13])
	SetElement("ToLoc",list[sort+14])
	SetElement("ToRole",list[sort+15])
	SetElement("ReadUser",list[sort+16])
	SetElement("ReadDate",list[sort+17])
	SetElement("ReadTime",list[sort+18])
	SetElement("DealUser",list[sort+19])
	SetElement("DealDate",list[sort+20])
	SetElement("DealTime",list[sort+21])
	SetElement("BussType",list[sort+22])
	//SetElement("Status",list[sort+1])	
	SetElement("EmergencyLevel",list[sort+24])
	SetChkElement("InBoxInvalidFlag",list[sort+25])
	SetElement("InBoxDelUser",list[sort+26])
	SetElement("InBoxDelDate",list[sort+27])
	SetElement("InBoxDelTime",list[sort+28])
	SetChkElement("OutBoxInvalidFlag",list[sort+29])
	SetElement("OutBoxDelUser",list[sort+30])
	SetElement("OutBoxDelDate",list[sort+31])
	SetElement("OutBoxDelTime",list[sort+32])
	SetElement("DealFlagDR",list[sort+33])
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

function GetBussTypeID(value)
{
	GetLookUpID("BussTypeDR",value);
}
function GetDealUserID(value)
{
	GetLookUpID("DealUserDR",value);
}
function GetEquipTypeID(value)
{
	GetLookUpID("EquipTypeDR",value);
}
function GetFromRoleID(value)
{
	GetLookUpID("FromRoleDR",value);
}
function GetFromLocID(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetFromUserID(value)
{
	GetLookUpID("FromUserDR",value);
}
function GetManageLocID(value)
{
	GetLookUpID("ManageLocDR",value);
}

function GetReadUserID(value)
{
	GetLookUpID("ReadUserDR",value);
}

function GetSendUserID(value)
{
	GetLookUpID("SendUserDR",value);
}
function GetToUserID(value)
{
	GetLookUpID("ToUserDR",value);
}
function GetToRoleID(value)
{
	GetLookUpID("ToRoleDR",value);
}
function GetToLocID(value)
{
	GetLookUpID("ToLocDR",value);
}

function GetInBoxDelUserID(value)
{
	GetLookUpID("InBoxDelUserDR",value);
}
function GetOutBoxDelUserID(value)
{
	GetLookUpID("OutBoxDelUserDR",value);
}
function GetEmergencyLevelID(value)
{
	GetLookUpID("EmergencyLevelDR",value);
}

function DoReadAction()
{
	if (GetElementValue("Status")>"1") return
	if (GetElementValue("ReadOnly")!="1") return
	rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("ReadMessage");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result>0)
	{
		SetElement("Status","2")		//modified by zy 2011-02-18 ZY0055
	}
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	if (Status=="")  DisableBElement("BDelete",true);
	if (Status>"0")  DisableBElement("BUpdate",true);
	if (Status!="0") DisableBElement("BSend",true);
	if (Status<"2")  DisableBElement("BReturn",true);
}
document.body.onload = BodyLoadHandler;
