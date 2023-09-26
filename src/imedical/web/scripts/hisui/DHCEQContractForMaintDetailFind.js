/// GR0054 买保合同查询 从DHCEQContractFind.js独立出来，方便日后与采购合同业务分开

function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
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
	// 20181028 Mozy0216
	var obj=document.getElementById("BAdd1");
	if (obj) obj.onclick=BAdd_Clicked;
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
// 20181028 Mozy0216
function BAdd_Clicked()
{
	var QXType=GetElementValue("QXType");
	var Type=GetElementValue("Type");
	var val="&ContractType=1&QXType="+QXType+"&Type="+Type;
	url="dhceq.con.contractformaint.csp?"+val
	websys_lu(url,false,'width=1500,height=800,hisui=true')
}
document.body.onload = BodyLoadHandler;