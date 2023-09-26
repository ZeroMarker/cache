///DHCEQCheckInStock.js
function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	Muilt_LookUp("Loc^Provider^EquipType^BuyLoc");
}

function InitPage()
{
	KeyUp("Loc^Provider^EquipType^BuyLoc");
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BCheck");
	if (obj) obj.onclick=BCheck_Click;
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
}
function BFind_Click()
{
	var val=GetVData();
	//alertShow(val)
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckInStock"+val;
}
function GetVData()
{
	var	val="&InStockNo="+GetElementValue("InStockNo");
	val=val+"&LocDR="+GetElementValue("LocDR");
	val=val+"&Loc="+GetElementValue("Loc");
	val=val+"&ProviderDR="+GetElementValue("ProviderDR");
	val=val+"&Provider="+GetElementValue("Provider");
	val=val+"&EquipNo="+GetElementValue("EquipNo");
	val=val+"&EquipName="+GetElementValue("EquipName");
	val=val+"&BuyLocDR="+GetElementValue("BuyLocDR");
	val=val+"&BuyLoc="+GetElementValue("BuyLoc");
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"&EquipType="+GetElementValue("EquipType");
	val=val+"&StartDate="+GetElementValue("StartDate");
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&ApproveRole="+GetElementValue("ApproveRole");
	var CheckedFlag=GetChkElementValue("CheckedFlag");
	if (CheckedFlag==true) CheckedFlag="Y";
	if (CheckedFlag==false) CheckedFlag="N";
	val=val+"&CheckedFlag="+CheckedFlag;
	
	return val;
}
function SelectAll_Clicked()
{
	//var valRowIDs=""
	//var eSrc=window.event.srcElement;
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tDHCEQCheckInStock');
	var Rows=Objtbl.rows.length;
	//alertShow(Rows)
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TChkz'+i);
		selobj.checked=obj.checked;
	}
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}
function GetBuyLoc(value)
{
	GetLookUpID("BuyLocDR",value);
}
function BCheck_Click()
{
	var encmeth=GetElementValue("GetToCheck");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var tmpRowIDs="";
	var objtbl=document.getElementById("tDHCEQCheckInStock");
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var id=GetElementValue("TRowIDz"+i);
		var Chk=GetChkElementValue("TChkz"+i);
		//alertShow(Chk)
		if ((Chk)&&(id!=""))
		{
			if (tmpRowIDs!="") tmpRowIDs=tmpRowIDs+"^";
			tmpRowIDs=tmpRowIDs+GetElementValue("TRowIDz"+i);
		}
	}
	if (tmpRowIDs=="")
	{
		//未选择任何记录则汇总当前页所有入库单
		alertShow("未选择有效审阅行.");
		return;
	}
	var result=cspRunServerMethod(encmeth,tmpRowIDs,GetElementValue("ApproveRole"));
	if (result<0)
	{
		alertShow(result);
	}
	else
	{
		location.reload();
	}
}

document.body.onload = BodyLoadHandler;

