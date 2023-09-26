/// 修    改:zy 2009-11-12  BugNo ZY0016
/// 修改函数:BodyLoadHandler,InitEvent,BBatchUpdate_Click
/// 描述:增加关闭按钮
/// -------------------------------
/// 修    改:zy 2009-11-03  BugNo ZY0015
/// 增加函数:BClose_Click()
/// 描述:增加关闭按钮
/// -------------------------------
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	FillData();
	KeyUp("Model^Unit^EquiCat^ManuFactory^Origin^FromDept^PurposeType^PurchaseType^Country^BuyType^DepreMethod^ItemDR^KeeperDR^MaintUserDR^Provider^Location","N");	//清空选择 //2009-08-17 党军
	Muilt_LookUp("Name^Model^Unit^EquiCat^ManuFactory^Origin^FromDept^PurposeType^PurchaseType^Country^BuyType^DepreMethod^ItemDR^KeeperDR^MaintUserDR^Provider^Location"); //回车选择 //2009-08-17 党军
	var ModelOperMethod=GetElementValue("GetModelOperMethod") //2009-07-09 党军 begin
	if (ModelOperMethod==1) //1:手工录入 0:放大镜选择操作.
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").removeNode(true)
	} //2009-07-09 党军 end
}
function FillData()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1)) 
	{
		return;	}
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid);
	SetData(result);	
}
function SetData(gbldata)
{
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=EquipGlobalLen;
	SetElement("Name",list[0]);
	SetElement("ABCType",list[1]);
	SetElement("ModelDR",list[2]);
	SetElement("Model",list[sort+0]);
	SetElement("EquiCatDR",list[3]);
	SetElement("EquiCat",list[sort+1]);
	SetElement("UnitDR",list[4]);
	SetElement("Unit",list[sort+2]);
	SetElement("Code",list[5]);
	SetElement("ItemDR",list[6]);
	SetElement("InstallLocDR",list[7]);
	SetElement("InstallLoc",list[sort+3]);
	SetElement("InstallDate",list[8]);
	SetElement("LeaveFactoryNo",list[9]);
	SetElement("LeaveFactoryDate",list[10]);
	SetElement("OpenCheckDate",list[11]);
	SetElement("CheckDate",list[12]);
	SetElement("MakeDate",list[13]);
	SetChkElement("ComputerFlag",list[14]);
	SetElement("CountryDR",list[15]);
	SetElement("Country",list[sort+4]);
	SetElement("ManageLocDR",list[16]);
	SetElement("ManageLoc",list[sort+5]);
	SetElement("ManageLevelDR",list[17]);
	SetElement("ManageLevel",list[sort+6]);
	SetElement("UseLocDR",list[18]);
	SetElement("UseLoc",list[sort+7]);
	SetElement("OriginDR",list[19]);
	SetElement("Origin",list[sort+8]);
	SetElement("FromDeptDR",list[20]);
	SetElement("FromDept",list[sort+9]);
	SetElement("ToDeptDR",list[21]);
	SetElement("ToDept",list[sort+10]);
	SetElement("BuyTypeDR",list[22]);
	SetElement("BuyType",list[sort+11]);
	SetElement("EquipTechLevelDR",list[23]);
	SetElement("ProviderDR",list[24]);
	SetElement("Provider",list[sort+12]);
	SetElement("ManuFactoryDR",list[25]);
	SetElement("ManuFactory",list[sort+13]);
	SetElement("OriginalFee",list[26]);
	SetElement("NetFee",list[27]);
	SetElement("NetRemainFee",list[28]);
	SetElement("GroupDR",list[29]);
	SetElement("Group",list[sort+14]);
	SetElement("LimitYearsNum",list[30]);
	SetElement("ContractListDR",list[31]);
	SetElement("ContractList",list[sort+15]);
	SetElement("DepreMethodDR",list[32]);
	SetElement("DepreMethod",list[sort+16]);
	SetElement("Remark",list[33]);
	SetElement("DepreTotalFee",list[34]);
	SetElement("DesignWorkLoadNum",list[35]);
	SetElement("WorkLoadUnitDR",list[36]);
	SetElement("WorkLoadUnit",list[sort+17]);
	SetElement("Status",list[37]);
	SetElement("ManageUserDR",list[38]);
	SetElement("ManageUser",list[sort+18]);
	SetElement("MaintUserDR",list[39]);
	SetElement("MaintUser",list[sort+19]);
	SetElement("ProviderHandler",list[40]);
	SetElement("ProviderTel",list[41]);
	SetElement("AppendFeeTotalFee",list[42]);
	SetElement("StartDate",list[43]);
	SetElement("TransAssetDate",list[44]);
	SetChkElement("GuaranteeFlag",list[45]);
	SetChkElement("InputFlag",list[46]);
	SetChkElement("TestFlag",list[47]);
	SetChkElement("MedicalFlag",list[48]);
	SetElement("GuaranteeStartDate",list[49]);
	SetElement("GuaranteeEndDate",list[50]);
	SetElement("AddUserDR",list[51]);
	SetElement("AddUser",list[sort+20]);
	SetElement("AddDate",list[52]);
	SetElement("AddTime",list[53]);
	SetElement("UpdateUserDR",list[54]);
	SetElement("UpdateUser",list[sort+21]);
	SetElement("UpdateDate",list[55]);
	SetElement("UpdateTime",list[56]);
	
	SetElement("StatusDisplay",list[sort+29]);
	//添加
	SetElement("MemoryCode",list[60]);
	SetChkElement("UrgencyFlag",list[61]);
	SetElement("EquipTypeDR",list[62]);
	SetElement("EquipType",list[sort+22]);
	SetElement("PurchaseTypeDR",list[63]);
	SetElement("PurchaseType",list[sort+23]);
	SetElement("PurposeTypeDR",list[64]);
	SetElement("PurposeType",list[sort+24]);
	SetElement("KeeperDR",list[65]);
	SetElement("Keeper",list[sort+25]);
	SetElement("StoreLocDR",list[66]);
	SetElement("StoreLoc",list[sort+26]);
	SetElement("StartDepreMonth",list[67]);
	SetElement("ServiceDR",list[68]);
	SetElement("Service",list[sort+27]);
	SetElement("InStockListDR",list[69]);
	SetElement("No",list[70]);
	SetElement("EquipTechLevel",list[sort+30]);
	SetElement("LocationDR",list[71]);
	SetElement("GuaranteePeriodNum",list[72]);
	SetElement("Service",list[sort+27]);
	SetElement("StatCatDR",list[74])
	SetElement("StatCat",list[sort+31])
	SetElement("Location",list[sort+34]);
}
function InitEvent() //初始化
{
	var obj=document.getElementById("BBatchUpdate");  //全部更新
	if (obj) obj.onclick=BBatchUpdate_Click;
	///modifid bu ZY 2009-11-02 ZY0015
	if ((opener)||(parent.opener))
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=BCloseClick;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	///end By ZY  2009-11-02 ZY0015
	//2009-11-11 ZY begin ZY0016
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod") 
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (ModelOperMethod==1)
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").removeNode(true)
	} 
	if (GetManuFactoryOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iManuFactory").removeNode(true)
	}
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}	
	//2009-11-11 ZY end  ZY0016
	
}
function BBatchUpdate_Click()
{
	if (CheckSaveData()) return;
	var truthBeTold = window.confirm(t["01"]);
	if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var ProviderOperMethod=GetElementValue("GetProviderOperMethod")
	var ModelDR=GetModelRowID(ModelOperMethod);
	var ManuFactoryDR=GetManuFactoryRowID(GetManuFactoryOperMethod);
	var ProviderDR=GetProviderRowID(ProviderOperMethod);
	SetElement("ModelDR",ModelDR);
	SetElement("ManuFactoryDR",ManuFactoryDR);
	SetElement("ProviderDR",ProviderDR);
	var plist=PackageData("Name^ABCType^ModelDR^EquiCatDR^UnitDR^Code^LeaveFactoryDate^CountryDR^OriginDR^FromDeptDR^BuyTypeDR^ManuFactoryDR^LimitYearsNum^DepreMethodDR^DepreTotalFee^DesignWorkLoadNum^WorkLoadUnitDR^MemoryCode^EquipTypeDR^PurchaseTypeDR^PurposeTypeDR^ServiceDR^InStockListDR^ServiceTel^StatCatDR^ComputerFlag^GuaranteeFlag^ItemDR^KeeperDR^MaintUserDR^NetRemainFee^OpenCheckDate^ProviderHandler^ProviderTel^ServiceHandler^StartDepreMonth^ProviderDR^LocationDR^GuaranteePeriodNum"); //函数调用 //2009-08-17 党军
	var result=cspRunServerMethod(encmeth,'','',plist,'1');
	if (result=="All")
	{
		alertShow(t["02"])
		opener.location.reload();
		location.reload(); //刷新当前窗口,刷新父窗口
		return
	}
	if(result=="") 
	{
		alertShow(t["03"]);
		return
	}
}
function CheckSaveData()
{
	//2009-10-26 ZY begin ZY0013
	if (CheckMustItemNull("ManuFactory^Model^Provider")) return true;
	
	var obj=document.getElementById("cManuFactory");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetManuFactoryOperMethod")==0)
		{
			if (CheckItemNull(1,"ManuFactory")==true) return true;
		}
		else
		{
			if (CheckItemNull("","ManuFactory")==true) return true;
		}		
	} 
	var obj=document.getElementById("cModel");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetModelOperMethod")==0)
		{
			if (CheckItemNull(1,"Model")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Model")==true) return true;
		}		
	}
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetProviderOperMethod")==0)
		{
			if (CheckItemNull(1,"Provider")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Provider")==true) return true;
		}		
	} 
	return false;
}

function GetManuFactory(value)
{
	var ManuFactory=value.split("^");
	var obj=document.getElementById("ManuFactoryDR");
	obj.value=ManuFactory[1];
}

function GetItem(value)
{
	var ReturnList=value.split("^")
	SetElement("ItemDR",ReturnList[1]);
	SetElement("EquiCatDR",ReturnList[3]);
	SetElement("EquiCat",ReturnList[4]);
	SetElement("UnitDR",ReturnList[5]);
	SetElement("Unit",ReturnList[6]);
}
function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetKeeper (value)
{
    GetLookUpID("KeeperDR",value);
}
function GetService (value)
{
    GetLookUpID("ServiceDR",value);
}
///20150827  Mozy0163	存放地点
function SetLocation(value)
{
	list=value.split("^");
	SetElement("LocationDR",list[0]);
	SetElement("Location",list[2]);
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
