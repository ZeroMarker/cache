/// GR0054 保修合同设备查询 从DHCEQContractFind.js独立出来，方便日后与采购合同业务分开
function BodyLoadHandler()
{
	InitPage();
	fillData();
	RefreshData();
	initButtonWidth();
	HiddenTableIcon("DHCEQContractMaintEquipList","TRowID","TDetail");	/// 需求号:266909  Mozy	2016-10-13
}

function InitPage()
{
	KeyUp("SignLoc^Provider^Status");
	Muilt_LookUp("SignLoc^Provider^Status");

	var Type=GetElementValue("Type");
	if (Type=="0")
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("ReplacesAD");
	}
	else
	{
		//DisableBElement("BAdd",true);
		//DisableBElement("BAdd1",true);	
	}
	var obj=document.getElementById("BFind"); //add by csj 20180329 需求号：571627
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
}
//add by csj 20180329
function BFind_Click()
{
	var val="&vData="+GetVData();
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQContractMaintEquipList"+val;
}
//add by csj 20180329
function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			SetElement(Detail[0],Detail[1]);
		}
	}
}
//Modify by Mozy 2018-11-6	588850
function GetVData()
{
	var val="^ContractName="+GetElementValue("ContractName");
	val=val+"^ContractNo="+GetElementValue("ContractNo");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");
	val=val+"^Provider="+GetElementValue("Provider");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^StatusDR="+GetElementValue("StatusDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^SignLocDR="+GetElementValue("SignLocDR");
	val=val+"^SignLoc="+GetElementValue("SignLoc");
	val=val+"^EquipName="+GetElementValue("EquipName");
	val=val+"^QXType="+GetElementValue("QXType");
	val=val+"^ContractType="+GetElementValue("ContractType");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	
	return val;
}
//add by csj 20180329
function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2)	BFind_Click();
}
function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}

function GetSignLoc (value)
{
    GetLookUpID("SignLocDR",value);
}
function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
function BClose_Click() 
{
	closeWindow("modal");
}
document.body.onload = BodyLoadHandler;