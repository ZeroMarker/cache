var SelectedRow=0;
var rowid=0;
var readonly;
function BodyLoadHandler() 
{
	InitPage();
}
///初始化页面
function InitPage()
{
	document.body.scroll="no";
	KeyUp("UseLoc^EquipType^PurposeType^Service^EquiCat^Provider^ManuFactory^PurchaseType^Origin^StatCat^Hospital","N")
	Muilt_LookUp("UseLoc^EquipType^PurposeType^Service^EquiCat^Provider^ManuFactory^PurchaseType^Origin^StatCat^Hospital");
	//ManageLoc^Keeper^StoreLoc^PurchaseType^
	var obj=document.getElementById("StatusDisplay");
	if (obj) {obj.onchange=StatusDisplay_KeyUp;}
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
	
	var obj=document.getElementById(GetLookupName("EquiCat"));
	if (obj) obj.onclick=EquiCat_Click;
	readonly=GetElementValue("ReadOnly")
	
	if ("1"==readonly)
	{
		DisableBElement("BAdd",true)
	}
	else
	{
		var obj=document.getElementById("BAdd");
		if (obj) obj.onclick=BAdd_Click;
	}
}

function StatusDisplay_KeyUp()
{
	var obj=document.getElementById("Status");
	if (obj) obj.value=""
}



function BFind_Click()
{
	if (GetElementValue("SnapShotID")=="")
	{
		alertShow("请先选择快照!");
		return;
	}
	var lnk=GetLnk();
	lnk=lnk+"&SnapShotID="+GetElementValue("SnapShotID");
	parent.DHCEQSnapEquipList.location.href=lnk;
}

function GetLnk()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSnapEquipList";
	lnk=lnk+"&vData="
	lnk=lnk+"^No="+GetElementValue("No");
	lnk=lnk+"^Name="+GetElementValue("Name");
	lnk=lnk+"^Code="+GetElementValue("Code");
	lnk=lnk+"^UseLocDR="+GetElementValue("UseLocDR");
	lnk=lnk+"^ManageLocDR="+GetElementValue("ManageLocDR");
	lnk=lnk+"^StoreLocDR="+GetElementValue("StoreLocDR");
	lnk=lnk+"^ModelDR="+GetElementValue("ModelDR");
	lnk=lnk+"^Status="+GetElementValue("Status");
	lnk=lnk+"^MinValue="+GetElementValue("MinValue");
	lnk=lnk+"^MaxValue="+GetElementValue("MaxValue");
	lnk=lnk+"^ProviderDR="+GetElementValue("ProviderDR");
	lnk=lnk+"^ManuFactoryDR="+GetElementValue("ManuFactoryDR");
	lnk=lnk+"^ServiceDR="+GetElementValue("ServiceDR");
	lnk=lnk+"^EquipCatDR="+GetElementValue("EquiCatDR");	
	lnk=lnk+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	lnk=lnk+"^PurposeTypeDR="+GetElementValue("PurposeTypeDR");
	lnk=lnk+"^QXType="+GetElementValue("QXType");
	lnk=lnk+"^OriginDR="+GetElementValue("OriginDR");
	lnk=lnk+"^PurchaseTypeDR="+GetElementValue("PurchaseTypeDR");
	
	lnk=lnk+"^BeginInStockDate="+GetElementValue("BeginInStockDate");
	lnk=lnk+"^EndInStockDate="+GetElementValue("EndInStockDate");
	var BatchFlag=GetChkElementValue("BatchFlag");
	if (BatchFlag==true) BatchFlag="Y";
	if (BatchFlag==false) BatchFlag="N";
	lnk=lnk+"^BatchFlag="+BatchFlag;
	var IncludeFlag="0";
	if (GetChkElementValue("IncludeFlag")==true)
	{
		var IncludeFlag="1"
	}
	lnk=lnk+"^IncludeFlag="+IncludeFlag;
	lnk=lnk+"^StatCatDR="+GetElementValue("StatCatDR")
	
	lnk=lnk+"^InvoiceNo="+GetElementValue("InvoiceNo")
	lnk=lnk+"^ContractNo="+GetElementValue("ContractNo")
	lnk=lnk+"^IsDisused="+GetElementValue("IsDisused")
	lnk=lnk+"^IsDisusing="+GetElementValue("IsDisusing")
	lnk=lnk+"^IsOut="+GetElementValue("IsOut")
	lnk=lnk+"^ComputerFlag="+GetElementValue("ComputerFlag")
	lnk=lnk+"^MemoryCode="+GetElementValue("MemoryCode")
	
	//add by JDL 2009-9-16 JDL0033
	lnk=lnk+"^BeginTransAssetDate="+GetElementValue("BeginTransAssetDate")
	lnk=lnk+"^EndTransAssetDate="+GetElementValue("EndTransAssetDate")
	lnk=lnk+"^HospitalDR="+GetElementValue("HospitalDR");
	lnk=lnk+"&ReadOnly="+readonly;
	
	//alertShow(GetElementValue("SnapShotID"));
	
	
	return lnk;
}
/// 20111027  Mozy0066
function BSaveExcel_Click()
{
	var job="";
	var obj=parent.frames["DHCEQSnapEquipList"].document.getElementById("TJobz1");
	if(obj)
	{
		job=obj.value;
		PrintDHCEQEquipNew("Equip",1,job,"","SnapEquipList",50);
	}
	else
	{
		alertShow("没有数据!");
	}
}

function GetService(value)
{
    GetLookUpID("ServiceDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetOrigin (value)
{
    GetLookUpID("OriginDR",value);
}
function GetStatCat(value)
{
	GetLookUpID("StatCatDR",value);
}
function EquiCat_Click()
{
	var CatName=GetElementValue("EquiCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquiCat",text);
	SetElement("EquiCatDR",id);
}

function GetStoreLocID(value)
{
	GetLookUpID("StoreLocDR",value);
}

function GetSnapShotID(value)
{
	var list=value.split("^");
	SetElement("SnapShotID",list[1]);
}
function GetHospitalDR(value)
{
	GetLookUpID("HospitalDR",value);
}
document.body.onload = BodyLoadHandler;