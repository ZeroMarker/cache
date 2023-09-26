///修改: ZY 2009-11-17 ZY0017
///修改函数BPrint_Click
///描述:导出时保存路径的设置
/// -------------------------------
function BodyLoadHandler(){
	KeyUp("Loc^Provider^EquipType");
	SetElement("InvoiceInfo",GetElementValue("InvoiceInfoDR"))
	SetElement("PayRecordInfo",GetElementValue("PayRecordInfoDR"))
	InitPage();
	Muilt_LookUp("Loc^Provider^EquipType");
}

function InitPage()
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()
{
	var val="&ISNo="+GetElementValue("ISNo")
	val=val+"&LocDR="+GetElementValue("LocDR")
	val=val+"&Loc="+GetElementValue("Loc")
	val=val+"&StartDate="+GetElementValue("StartDate")
	val=val+"&EndDate="+GetElementValue("EndDate")
	val=val+"&InvoiceNos="+GetElementValue("InvoiceNos")
	val=val+"&MinPrice="+GetElementValue("MinPrice")
	val=val+"&MaxPrice="+GetElementValue("MaxPrice")
	val=val+"&ProviderDR="+GetElementValue("ProviderDR")
	val=val+"&Provider="+GetElementValue("Provider")
	val=val+"&Name="+GetElementValue("Name")
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR")
	val=val+"&EquipType="+GetElementValue("EquipType")
	val=val+"&InvoiceInfoDR="+GetElementValue("InvoiceInfo")
	val=val+"&PayRecordInfoDR="+GetElementValue("PayRecordInfo")
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListFind'+val
}

function BClear_Click()
{
	SetElement("ISNo","")
	SetElement("InvoiceNos","")
	SetElement("Status","")
	SetElement("LocDR","")
	SetElement("Loc","")
	SetElement("ProviderDR","")
	SetElement("Provider","")
	SetElement("EquipTypeDR","")
	SetElement("EquipType","")
	SetElement("Name","")
	SetElement("StartDate","")
	SetElement("EndDate","")
	SetElement("MinPrice","")
	SetElement("MaxPrice","")
	SetElement("InvoiceInfo","")
	SetElement("PayRecordInfo","")
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}
function GetStatus(value)
{
	GetLookUpID("StatusDR",value);
}
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}

document.body.onload = BodyLoadHandler;