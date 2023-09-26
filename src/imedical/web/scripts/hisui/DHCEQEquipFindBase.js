var SelectedRow=0;
var rowid=0;
var readonly;
var BatchFlag="N";
function BodyLoadHandler() 
{
	InitPage();
	initButtonWidth();	//modified by czf 20180821 HISUI改造
	setItem(); //hisui调整 add by lmm 2018-07-31
}
///初始化页面
function InitPage()
{
	document.body.scroll="no";
	KeyUp("UseLoc^EquipType^PurposeType^Service^EquiCat^Provider^ManuFactory^PurchaseType^Origin^StatCat^FundsType^FundsRecord^StoreLoc^MasterItem^Location^Hospital","N")
	//alertShow(document.getElementById("ProviderDR").value)
	Muilt_LookUp("UseLoc^EquipType^PurposeType^Service^EquiCat^Provider^ManuFactory^PurchaseType^Origin^StatCat^FundsType^FundsRecord^StoreLoc^MasterItem^Location^Hospital");
	//ManageLoc^Keeper^StoreLoc^PurchaseType^
	var obj=document.getElementById("StatusDisplay");
	if (obj) {obj.onchange=StatusDisplay_KeyUp;}
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BSaveTXT");
	if (obj) obj.onclick=BSaveTXT_Click;
	var obj=document.getElementById(GetLookupName("EquiCat"));
	if (obj) obj.onclick=EquiCat_Click;
	var obj=document.getElementById(GetLookupName("MIHold1Desc"));
	if (obj) obj.onclick=MIHold1Desc_Click
	var obj=document.getElementById("MIHold1Desc");
	if (obj) obj.onkeyup=MIHold1Desc_KeyUp;
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=BPrintBar_Click;
	// Mozy	2011-3-7
	var obj=document.getElementById("BPrintCard");
	if (obj) obj.onclick=BPrintCard_Click;
	
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
	var obj=document.getElementById("BFilter");
	if (obj) obj.onclick=BFilter_Click;
}

///打印卡片
///Mozy	2011-3-7
function BPrintCard_Click()
{
	if (BatchFlag!="N")
	{
		alertShow("批量显示模式,无法打印,请按非批量模式查找后打印!");
		return;
	}
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode&Type=Card';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=480,height=280,left=120,top=0')
}

function StatusDisplay_KeyUp()
{
	var obj=document.getElementById("Status");
	if (obj) obj.value=""
}

function BAdd_Click()
{
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquip";  //hisui改造 modify by lmm 2018-08-18
	parent.location.href=lnk;
}

function BFind_Click()
{
	var lnk=GetLnk();
	//parent.DHCEQEquipList.test();
	//return;
	//alertShow(lnk);
	window.location.href=lnk  //hisui改造 modify by lmm 2018-08-18
	//parent.DHCEQEquipList.location.href=lnk;   //hisui改造 modify by lmm 2018-08-18
}

function GetLnk()
{
	Component=GetElementValue("ComponentName");	  //hisui改造 modify by lmm 2018-08-18
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&WEBSYS.TCOMPONENT1=DHCEQEquipList";  //hisui改造 modify by lmm 2018-08-18
	lnk=lnk+"&Data="
	lnk=lnk+"^No="+GetElementValue("No");
	lnk=lnk+"^Name="+GetElementValue("Name");
	lnk=lnk+"^CommonName="+GetElementValue("CommonName");
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
	BatchFlag=GetChkElementValue("BatchFlag");
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
	lnk=lnk+"^BeginTransAssetDate="+GetElementValue("BeginTransAssetDate")
	lnk=lnk+"^EndTransAssetDate="+GetElementValue("EndTransAssetDate")
	lnk=lnk+"^FundsTypeDR="+GetElementValue("FundsTypeDR")
	lnk=lnk+"^FundsRecordDR="+GetElementValue("FundsRecordDR")
	lnk=lnk+"^BeginDisuseDate="+GetElementValue("BeginDisuseDate");
	lnk=lnk+"^EndDisuseDate="+GetElementValue("EndDisuseDate");
	lnk=lnk+"^BeginOutDate="+GetElementValue("BeginOutDate");
	lnk=lnk+"^EndOutDate="+GetElementValue("EndOutDate");
	lnk=lnk+"^MasterItemDR="+GetElementValue("MasterItemDR");
	var LocIncludeFlag="0";
	if (GetChkElementValue("LocIncludeFlag")==true)
	{
		var LocIncludeFlag="1"
	}
	lnk=lnk+"^LocIncludeFlag="+LocIncludeFlag;
	lnk=lnk+"^InStockNo="+GetElementValue("InStockNo");			//入库单号
	lnk=lnk+"^LeaveFactoryNo="+GetElementValue("LeaveFactoryNo");
	lnk=lnk+"^StoreMoveNo="+GetElementValue("StoreMoveNo");
	lnk=lnk+"^TreeNo="+GetElementValue("TreeNo");
	lnk=lnk+"^PreDisuseFlag="+GetElementValue("PreDisuseFlag");
	lnk=lnk+"^HospitalDR="+GetElementValue("HospitalDR");
	lnk=lnk+"^FilterFlag="+GetElementValue("FilterFlag");
	lnk=lnk+"^"+GetElementValue("FilterData");
	lnk=lnk+"^MIHold1="+GetElementValue("MIHold1");	//Mozy0110
	lnk=lnk+"^CommonageFlag="+GetElementValue("CommonageFlag");	//add by zy 20140107  zy0109
	lnk=lnk+"^Model="+GetElementValue("Model");	//20150819  Mozy0159
	lnk=lnk+"^FileNo="+GetElementValue("FileNo");	//20150819  Mozy0159
	lnk=lnk+"^LocationDR="+GetElementValue("LocationDR");	//20150827  Mozy0163	存放地点
	lnk=lnk+"^UseLoc="+GetElementValue("UseLoc");   //hisui改造 modify by lmm 2018-08-18
	lnk=lnk+"^Chk=";	//未打印条码
	if (GetChkElementValue("Chk")==true)
	{
		lnk=lnk+"1";
	}
	lnk=lnk+"^UnCheckLimitFlag="+GetElementValue("UnCheckLimitFlag");
	var CheckRentFlag="0";
	if (GetChkElementValue("CheckRentFlag")==true)
	{
		var CheckRentFlag="1";
	}
	lnk=lnk+"^CheckRentFlag="+CheckRentFlag;
	lnk=lnk+"^AdvanceDisFlag="+GetElementValue("AdvanceDisFlag");
	
	
	//hisui改造 add by lmm 2018-07-31 begin
	lnk=lnk+"^ManageLoc="+GetElementValue("ManageLoc");
	lnk=lnk+"^StoreLoc="+GetElementValue("StoreLoc");
	lnk=lnk+"^Provider="+GetElementValue("Provider");
	lnk=lnk+"^ManuFactory="+GetElementValue("ManuFactory");
	lnk=lnk+"^Service="+GetElementValue("Service");
	lnk=lnk+"^EquipCat="+GetElementValue("EquiCat");	
	lnk=lnk+"^EquipType="+GetElementValue("EquipType");
	lnk=lnk+"^PurposeType="+GetElementValue("PurposeType");
	lnk=lnk+"^Origin="+GetElementValue("Origin");
	lnk=lnk+"^PurchaseType="+GetElementValue("PurchaseType");
	lnk=lnk+"^StatCat="+GetElementValue("StatCat")
	lnk=lnk+"^FundsType="+GetElementValue("FundsType")
	lnk=lnk+"^FundsRecord="+GetElementValue("FundsRecord")
	lnk=lnk+"^MasterItem="+GetElementValue("MasterItem");
	lnk=lnk+"^Hospital="+GetElementValue("Hospital");
	lnk=lnk+"^Location="+GetElementValue("Location");
	lnk=lnk+"^ConfigFlag="+GetElementValue("ConfigFlag");	//Mozy	754500	2018-12-18
	
	lnk=lnk+"&ReadOnly="+readonly;
	return lnk;
}
function BPrint_Click()
{
	var vData="";
	var obj=parent.frames["DHCEQEquipList"].document.getElementById("Data");
	if (obj) vData=obj.value;
	PrintDHCEQEquip(vData,0);		//打印
}
function BSaveExcel_Click()
{
	var vData="";
	var obj=parent.frames["DHCEQEquipList"].document.getElementById("Data");
	if (obj) vData=obj.value;
	PrintDHCEQEquip(vData,1);		//保存
}
function BSaveTXT_Click()
{
    PrintDHCEQEquipToTXT();
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
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;  //hisui改造 modify by lmm 2018-08-18
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

function GetFundsType(value)
{
	GetLookUpID("FundsTypeDR",value);
}

function GetFundsRecord(value)
{
	GetLookUpID("FundsRecordDR",value);
}
///打印条码
function BPrintBar_Click()
{
	if (BatchFlag!="N")
	{
		alertShow("批量显示模式,无法打印,请按非批量模式查找后打印!");
		return;
	}
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode';  //hisui改造 modify by lmm 2018-08-18
    showWindow(str,"批量条码打印","","7row","icon-w-paper","modal","","","small");  //modify by lmm 2020-06-05 UI
}

//add by ZY 2010-08-09
function GetMasterItemID(value)
{
	GetLookUpID("MasterItemDR",value);
}

//20150827  Mozy0163	存放地点
function SetLocation(value)
{
	list=value.split("^");
	SetElement("LocationDR",list[0]);
	SetElement("Location",list[2]);
	
}
/*
function ServiceHandlerDesc_KeyUp()
{
	SetElement("ServiceHandler","");
}*/
function GetHospitalDR(value)
{
	GetLookUpID("HospitalDR",value);
}
//Mozy0110
function MIHold1Desc_Click()
{
	var CatName=GetElementValue("MIHold1Desc")
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTree&TreeType=1&Type=SelectTree&CatName="+CatName;  //hisui改造 modify by lmm 2018-08-18
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}
function MIHold1Desc_KeyUp()
{
	var obj=document.getElementById("MIHold1");	
	if (obj) obj.value="";
}
function SetTreeDR(id,text)
{
	var obj=document.getElementById("MIHold1");	
	if (obj) obj.value=id;
	var obj=document.getElementById("MIHold1Desc");
	if (obj) obj.value=text;
}

function BFilter_Click()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipFilter&FilterData='+GetElementValue("FilterData");  //hisui改造 modify by lmm 2018-08-18
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=480,left=120,top=0')
}
///Mozy		785784	2018-12-21
///描述：hisui改造 用于复合界面点击查询
function setItem()
{
	var Data=GetElementValue("Data")
	var Data=Data.split("^")
	var len=Data.length
	for(i=1;i<len;i++)
	{
		var field=Data[i].split("=")
		SetElement(field[0],field[1]);
	}
}

document.body.onload = BodyLoadHandler;