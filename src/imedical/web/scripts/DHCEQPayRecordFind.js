/// -------------------------------
/// Create by JDL 2011-05-16 JDL0081
/// 付款检索
/// -------------------------------
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	if (GetElementValue("vData")!="")
	{
		fillData();
	}
	else	
	{
		BFind_Click();
	}
}

///初始化页面
function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	KeyUp("Loc^Provider^EquipType","N");
	Muilt_LookUp("Loc^Provider^EquipType");
}

function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayRecordFind"+val;
}

function GetVData()
{
	var	val="^ISNo="+GetElementValue("ISNo");
	val=val+"^LocDR="+GetElementValue("LocDR");
	val=val+"^InStockStatus="+GetElementValue("InStockStatus");
	val=val+"^InDateFrom="+GetElementValue("InDateFrom");
	val=val+"^InDateTo="+GetElementValue("InDateTo");
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^InvoiceInfoDR="+GetElementValue("InvoiceInfoDR");
	val=val+"^PayRecordInfoDR="+GetElementValue("PayRecordInfoDR");
	val=val+"^PayNo="+GetElementValue("PayNo");
	val=val+"^PayDateFrom="+GetElementValue("PayDateFrom");
	val=val+"^PayDateTo="+GetElementValue("PayDateTo");
	val=val+"^InvoiceNo="+GetElementValue("InvoiceNo");
	val=val+"^InvoiceDateFrom="+GetElementValue("InvoiceDateFrom");
	val=val+"^InvoiceDateTo="+GetElementValue("InvoiceDateTo");
	val=val+"^PlanPayDateFrom="+GetElementValue("PlanPayDateFrom");
	val=val+"^PlanPayDateTo="+GetElementValue("PlanPayDateTo");
	val=val+"^PayPlanDR="+GetElementValue("PayPlanDR");
	val=val+"^PayPlan="+GetElementValue("PayPlan");
	val=val+"^QXType="+GetElementValue("QXType");
	return val;
}

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
	var val="";
	val=val+"prov=Provider="+GetElementValue("ProviderDR")+"^";
	val=val+"dept=Loc="+GetElementValue("LocDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	var encmeth=GetElementValue("GetDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function GetPayPlan(value)
{
	var list=value.split("^");
	SetElement("PayPlan",list[3]);
	SetElement("PayPlanDR",list[2]);
}


function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}

document.body.onload = BodyLoadHandler;