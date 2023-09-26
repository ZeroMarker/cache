function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
	SetBEnable();		// 需求序号:	717110	Mozy	2018-11-8
	initButtonWidth();
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
		DisableBElement("BAdd",true);
		DisableBElement("BAdd1",true);	
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
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
// 需求序号:	717110	Mozy	2018-11-8
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		//DisableBElement("BAdd1",true);
		hiddenObj("BAdd1",1);
	}
	else
	{
		var obj=document.getElementById("BAdd1");
		if (obj) obj.onclick=BAdd_Clicked;
	}
}
// 20181028 Mozy0216
function BAdd_Clicked()
{
	var QXType=GetElementValue("QXType");
	var Type=GetElementValue("Type");
	var val="&ContractType=1&QXType="+QXType+"&Type="+Type;
	url="dhceq.con.contractformaint.csp?"+val
	showWindow(url,"保修合同","","","icon-w-paper","modal","","","verylarge");	//modify by lmm 2020-06-04 UI
}
document.body.onload = BodyLoadHandler;