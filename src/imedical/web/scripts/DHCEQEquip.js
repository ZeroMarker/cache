/// -------------------------------
/// Add by DJ 2010-02-22 DJ 0039
/// Add:共用设备增加设备分摊设置
/// -------------------------------
/// 修改:zy 2009-11-11 BugNo.ZY0016
/// 修改函数CombinData,InitStandardKeyUp
/// 修改错误:在InStockListDR为空时?不能批量修改
/// 描述:改进功能,对机型,供应商,生产厂商取RowID?
/// 备注0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
/// -------------------------------
/// 修    改:zy 2009-11-03  BugNo ZY0015
/// 增加函数:BClose_Click()
/// 描述:增加关闭按钮
/// -------------------------------
/// Modified by jdl 2009-07-21 JDL0020
/// Modified:增加定义变量AppendFileSourceType
/// -------------------------------
/// Modified by jdl 2009-06-02 JDL0006
/// Modified Method:SetData,CombinData,Clear
/// --------------------------------
var AppendFileSourceType=4;
var EQTypeFlag="";
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();	
	FillData();
	var InStockListDR=GetElementValue("InStockListDR");
	if (InStockListDR=="") DisableBElement("BBatchUpdate",true);
	if (""==GetElementValue("BUBuildingDR"))
	{
		DisableBElement("BBuildingUnitAllotDetail",true);
	}
}

///填充数据
function FillData()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1)) 
	{	//SetDisable(true);
		return;	}
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid);
	SetData(result);
	
	var CommonageFlag=GetChkElementValue("CommonageFlag");
	if (CommonageFlag==false)
	{
		DisableBElement("BDepreAllot",true)
	}
}

function SetDisable(value)
{
	DisableBElement("BAffix",value);
	DisableBElement("BAppendFee",value);
	DisableBElement("BDoc",value);
	DisableBElement("BDelete",value);
	DisableBElement("BSerContract",value);
	DisableBElement("BPicture",value);
	DisableBElement("BMonthDepre",value);
	DisableBElement("BConfig",value);		
}

function SetData(gbldata)
{
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow(gbldata)
	var sort=EquipGlobalLen;
	SetElement("Name",list[sort+36]);	//2013-06-24 DJ0118
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
	SetElement("LocationDR",list[71]);			///20150827  Mozy0163
	SetElement("GuaranteePeriodNum",list[72]);	///20150827  Mozy0163
	SetElement("Service",list[sort+27]);
	SetElement("StatCatDR",list[74])
	SetElement("StatCat",list[sort+31])
	
	SetElement("ContractNo",list[75])	//2014-08-21 DJ0126
	SetElement("OpenCheckListDR",list[76])
	SetElement("DepreRate",list[77])
	SetElement("OldLoc",list[78])
	SetChkElement("Hold5",list[79])		//Modify DJ 2017-01-20
	SetChkElement("BenefitAnalyFlag",list[80]);
	SetChkElement("CommonageFlag",list[81]);
	SetChkElement("AutoCollectFlag",list[82]);
	SetElement("WorkLoadPerMonth",list[83]);
	SetElement("FileNo",list[84]);
	SetElement("RentLocDR",list[85]);
	SetElement("RentStatus",list[86]);
	SetElement("FaultStatus",list[87]);
	SetElement("DisuseDate",list[88]);
	SetElement("AccountNo",list[89]);
	SetElement("OldNo",list[90]);	//2014-08-21 DJ0126
	SetElement("RegistrationNo",list[91]);
	SetElement("AdvanceDisFlag",list[92]);	/// 20150922  Mozy0166
	SetElement("BrandDR",list[93]);	//2013-12-11 DJ0122
	SetElement("Hold10",list[94]);
	SetElement("CommonName",list[0]);	//2013-06-24 DJ0118
	SetElement("Brand",list[sort+40]);	//2013-12-11 DJ0122
	///20150827  Mozy0163
	SetElement("Location",list[sort+34])
	//add by Mozy 2009-07-30  mzy0019
	SetElement("MIHold1",list[sort+37]);
	SetElement("MIHold1Code",list[sort+38]);//Mozy0110
	SetElement("MIHold1Desc",list[sort+39]);//Mozy0110
	SetElement("FundsInfo",list[sort+41]);
	SetElement("InStockNo",list[sort+42]);	//Mozy0132	2014-6-25
	SetElement("OCRRowID",list[sort+43]);
	//Add By DJ 2014-08-21 DJ0126
	SetElement("RunStatus",list[sort+44]);
	SetElement("ConfigLicense",list[sort+45]);
	SetElement("NewOldPercent",list[sort+46]);
	SetElement("Power",list[sort+47]);
	SetElement("Voltage",list[sort+48]);
	SetElement("Electriccurrent",list[sort+49]);
	SetChkElement("RaditionFlag",list[sort+50]);
	SetElement("ReciveDate",list[sort+51]);
	//SetElement("Hold1",list[sort+52]);
	SetElement("UnusualRemark",list[sort+52]);	/// 20150918  Mozy0166
	SetElement("Hold2",list[sort+53]);
	SetElement("Hold3",list[sort+54]);
	SetElement("Hold4",list[sort+55]);
	
	SetElement("ValueType",list[sort+56]);
	SetElement("DirectionsUse",list[sort+57]);
	SetElement("UserDR",list[sort+58]);
	SetElement("AccountShape",list[sort+59]);
	SetElement("ProjectNo",list[sort+60]);
	SetElement("User",list[sort+61]);
	SetElement("MaintTotalFee",list[sort+62]);  //modify BY :GBX 2014-11-02  维修费用合计
	SetElement("AddDepreMonths",list[sort+63]);  //add by zy 20150610 ZY0128  //显示调账处增加的折旧月份数
	SetElement("Hold10Desc",list[sort+64]);		//20150630  Mozy0154
	SetElement("RentLoc",list[sort+65]);
	// Mozy0217  2018-11-01 友谊医院，台账增加服务商联系人,服务商联系电话,档案号分类，特种标记 
	SetElement("ServiceHandler",list[sort+66]);
	SetElement("ServiceTel",list[sort+67]);
	SetElement("FileCat",list[sort+68]);		
	SetChkElement("SpecialFlag",list[sort+69]);
	SetElement("SalesManager",list[sort+70]);	//Mozy	2018-5-15
	SetElement("SalesManagerTel",list[sort+71]);	//Mozy	2018-5-15
  	SetElement("ParentDR",list[sort+72]);		//zy	2018-5-16
  	SetElement("Spec",list[sort+73]);		//zy	2018-5-16
  	SetElement("Hold13",list[sort+74]);		//zy	2018-5-16
  	SetElement("Hold14",list[sort+75]);		//zy	2018-5-16
  	SetElement("Hold15",list[sort+76]);		//zy	2018-5-16
	
	FillAssetTypeInfo();
}


///初始化页面
function InitPage()
{
	InitStandardKeyUp();
	
	var obj=document.getElementById("BAffix");
	if (obj) obj.onclick=MenuAffix;
	
	var obj=document.getElementById("BAppendFee");
	if (obj) obj.onclick=MenuAppendFee;
	
	var obj=document.getElementById("BDoc");
	if (obj) obj.onclick=MenuDoc;
	
	var obj=document.getElementById("BPicture");
	if (obj) obj.onclick=MenuPicture;
	
	var obj=document.getElementById("BMonthDepre");
	if (obj) obj.onclick=BMonthDepre_Click;
	
	var obj=document.getElementById("BConfig");
	if (obj) obj.onclick=MenuConfig;
	
	var obj=document.getElementById("BSerContract");
	if (obj) obj.onclick=MenuServiceContract;
	
	var obj=document.getElementById(GetLookupName("EquiCat"));
	if (obj) obj.onclick=EquiCat_Click;	
	
	var obj=document.getElementById(GetLookupName("MIHold1Desc"));
	if (obj) obj.onclick=MIHold1Desc_Click;
	
	var obj=document.getElementById("Name");
	if (obj) obj.onchange=Name_change;
	
	var obj=document.getElementById("BBuildingUnitAllotDetail");
	if (obj) obj.onclick=BBuildingUnitAllotDetail_Click;
	
	var obj=document.getElementById("BCheckEquipZZ");
	if (obj) obj.onclick=BCheckEquipZZ_Click;
	
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BClear",true)
		DisableBElement("BBatchUpdate",true)
		DisableBElement("BDepreAllot",true)
		DisableBElement("BPrintBar",true)
		DisableBElement("BPrintBarSml",true)
		DisableBElement("BPrintCardVerso",true)
		DisableBElement("BPrintCard",true)
	}
	else
	{
		var obj=document.getElementById("BUpdate");
		if (obj) obj.onclick=BUpdate_Click;
	
		var obj=document.getElementById("BBatchUpdate");
		if (obj) obj.onclick=BBatchUpdate_Click;
		var obj=document.getElementById("BDelete");
		if (obj) obj.onclick=BDelete_Click;
	
		var obj=document.getElementById("BClear");
		if (obj) obj.onclick=BClear_Click;
		
		var obj=document.getElementById("BPrintBar");
		if (obj) obj.onclick=DHCEQEquipPrintBar;		//Modify DJ 2016-07-19
		
		var obj=document.getElementById("BPrintBarSml");
		if (obj) obj.onclick=DHCEQEquipPrintBar;		//Modify DJ 2016-07-19
		
		var obj=document.getElementById("BPrintCard");
		if (obj) obj.onclick=BPrintCard_Click;
		
		var obj=document.getElementById("BPrintCardVerso");
		if (obj) obj.onclick=BPrintCardVerso_Click;	
		
		var obj=document.getElementById("BBatchUpdate");
		if (obj) obj.onclick=BBatchUpdate_Click;	
		
		var obj=document.getElementById("BDepreAllot");
		if (obj) obj.onclick=BDepreAllot_Click;
		
		var obj=document.getElementById("BEquipConfig");	// Mozy0217  2018-11-01
	    	if (obj) obj.onclick=BEquipConfig_Clicked;
	
	    	var obj=document.getElementById("BConfig");		// Mozy0217  2018-11-01
	    	if (obj) obj.onclick=BConfig_Clicked;
	    	
		obj=document.getElementById("BExportToJQ");
		if (obj) obj.onclick=BExportToApp;
	}
	if ((opener)||(parent.opener))
	{
		var obj=document.getElementById("BClose")
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
}

function BDepreAllot_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCostAllot&EquipDR='+GetElementValue("RowID")+'&Types=1'
  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BBatchUpdate_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipBatchUpdate&RowID='+GetElementValue("RowID")
  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function Name_change()
{
	SetElement("ItemDR","")
}
function BMonthDepre_Click()
{
	var depredata=GetElementValue("GetDepreSet")	
	if (depredata=="") return;
	var list=depredata.split("^");
	var str='dhceqmonthdepre.csp?EquipDR='+GetElementValue("RowID")+"&DepreSetId="+list[18]+"&DepreMethodId="+list[1]+"&CostAllotId="+list[6]+"&PreDepreMonth="+list[4]
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
     
function BUpdate_Click() 
{	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	SaveData(encmeth);	
}

function BDelete_Click()
{
	if (GetElementValue("RowID")=="")	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (truthBeTold) {	    
	    var encmeth=GetElementValue("GetDelete");
		if (encmeth=="")
		{
			alertShow(t[-4001]);
			return;
		}
		var result=cspRunServerMethod(encmeth,'','',GetElementValue("RowID"),Guser);		
		if (result==0)
		{
			//BClear_Click();
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquip";
			location.href=lnk;
			//SetDisable(true);
		}
    }
}

function BClear_Click()
{
	Clear();
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



function CheckSaveData()
{
	if (CheckMustItemNull("Provider^ManuFactory^Model")) return true;
	//2009-10-26 ZY begin ZY0013
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
	/*
	if (CheckItemNull(0,"Code")) return false;
	if (CheckItemNull(0,"Name")) return false;
	*/
	if (CheckItemNull(0,"ItemDR")) return true;	// Mozy0152	2015-2-9	编辑设备名称后设备项DR被清空
	return false;
}

function GetEquipDR()
{
	return GetElementValue("RowID");
}

/*
function CheckMenu()
{
	if (GetElementValue("RowID")==""||GetElementValue("RowID")<1)
	{
		alertShow(t[-4004]);
		return false;
	}
	return true;
}
*/

function SaveData(encmeth)
{
	if (CheckSaveData()) return;
	var result=CheckEqCatIsEnd(GetElementValue("EquiCatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
	//20150822  Mozy0162	档案号的唯一性限制参数设置
	//检测档案号是否有重复	20150819  Mozy0159
	var result=cspRunServerMethod(GetElementValue("CheckFileNo"), 2, GetElementValue("RowID"), GetElementValue("FileNo"));
	if ((result!=0)&&(GetElementValue("CheckFileNoFlag")!=0))
	{
		alertShow("已有设备使用此档案号,请修正档案号!")
		return
	}
	var plist=CombinData();	
	var Info=GetAssetTypeInfo();
	//alertShow(plist);
	var result=cspRunServerMethod(encmeth,'','',plist,Guser,Info);
	if (result>0)
	{
		/*	GR0014 2014-12-11	js已移动位置
		var resultNew;
		var EQplist=CombinDataNew();
		if(EQTypeFlag == "EQBuildingFlag")
		{
			encmeth=GetElementValue("SaveEQBuilding");
			//alertShow(EQplist);
			resultNew=cspRunServerMethod(encmeth,EQplist);
		}
		else if(EQTypeFlag == "EQVehicleFlag")
		{
			encmeth=GetElementValue("SaveEQVehicle");
			//alertShow(EQplist);
			resultNew=cspRunServerMethod(encmeth,EQplist);
		}
		if(resultNew<1)
		{
			alertShow(resultNew);
			return;
		}
		
		SetElement("RowID",result);
		*/
		//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//****************************
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&RowID="+result;
		location.href=lnk;
		//alertShow(location.href)
		//location.reload();
	}
	else
	{
		if (result==-1)
		{
			alertShow("内容不一致,请刷新页面后更新!")
		}
		else
		{
			alertShow(result);
		}
	}
}

function CombinData()
{	
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	var GetLocationOperMethod=GetElementValue("GetLocationOperMethod")	//20150822  Mozy0162	台帐不能更新保存编辑的信息
	var GetBrandOperMethod=GetElementValue("GetBrandOperMethod")		//Add By DJ 2016-07-21
	
	var combindata="";
	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("Name") ;
  	combindata=combindata+"^"+GetElementValue("ABCType") ;
  	combindata=combindata+"^"+GetModelRowID(ModelOperMethod) ; //2009-11-11  ZY  ZY0016
  	combindata=combindata+"^"+GetElementValue("EquiCatDR") ;
  	combindata=combindata+"^"+GetElementValue("UnitDR") ;
  	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("ItemDR") ;
  	combindata=combindata+"^"+GetElementValue("InstallLocDR") ;
  	combindata=combindata+"^"+GetElementValue("InstallDate") ;
  	combindata=combindata+"^"+GetElementValue("LeaveFactoryNo") ;
  	combindata=combindata+"^"+GetElementValue("LeaveFactoryDate") ;
  	combindata=combindata+"^"+GetElementValue("OpenCheckDate") ;
  	combindata=combindata+"^"+GetElementValue("CheckDate") ;
  	combindata=combindata+"^"+GetElementValue("MakeDate") ;
  	combindata=combindata+"^"+GetChkElementValue("ComputerFlag") ;
  	combindata=combindata+"^"+GetElementValue("CountryDR") ;
  	combindata=combindata+"^"+GetElementValue("ManageLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ManageLevelDR") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("OriginDR") ;
  	combindata=combindata+"^"+GetElementValue("FromDeptDR") ;
  	combindata=combindata+"^"+GetElementValue("ToDeptDR") ;
  	combindata=combindata+"^"+GetElementValue("BuyTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTechLevelDR") ;
    combindata=combindata+"^"+GetProviderRowID(GetProviderOperMethod)  //2009-11-11  ZY  ZY0016 GetElementValue("ProviderDR") ;
  	combindata=combindata+"^"+GetManuFactoryRowID(GetManuFactoryOperMethod)   //2009-11-11  ZY  ZY0016 GetElementValue("ManuFactoryDR") ;
  	combindata=combindata+"^"+GetElementValue("OriginalFee") ;
  	combindata=combindata+"^"+GetElementValue("NetFee") ;
  	combindata=combindata+"^"+GetElementValue("NetRemainFee") ;
  	combindata=combindata+"^"+GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("LimitYearsNum") ;
  	combindata=combindata+"^"+GetElementValue("ContractListDR") ;
  	combindata=combindata+"^"+GetElementValue("DepreMethodDR") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("DepreTotalFee") ;
  	combindata=combindata+"^"+GetElementValue("DesignWorkLoadNum") ;
  	combindata=combindata+"^"+GetElementValue("WorkLoadUnitDR") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("ManageUserDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintUserDR") ;
  	combindata=combindata+"^"+GetElementValue("ProviderHandler") ;
  	combindata=combindata+"^"+GetElementValue("ProviderTel") ;
  	combindata=combindata+"^"+GetElementValue("AppendFeeTotalFee") ;
  	combindata=combindata+"^"+GetElementValue("StartDate") ;
  	combindata=combindata+"^"+GetElementValue("TransAssetDate") ;
  	combindata=combindata+"^"+GetChkElementValue("GuaranteeFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("InputFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("TestFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("MedicalFlag") ;
  	combindata=combindata+"^"+GetElementValue("GuaranteeStartDate") ;
  	combindata=combindata+"^"+GetElementValue("GuaranteeEndDate") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	//添加
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	combindata=combindata+"^"+GetElementValue("StockStatus") ;
  	combindata=combindata+"^"+GetElementValue("MemoryCode") ;
  	combindata=combindata+"^"+GetChkElementValue("UrgencyFlag") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PurposeTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("KeeperDR") ;
  	combindata=combindata+"^"+GetElementValue("StoreLocDR") ;
  	combindata=combindata+"^"+GetElementValue("StartDepreMonth") ;
  	combindata=combindata+"^"+GetElementValue("ServiceDR") ;
  	combindata=combindata+"^"+GetElementValue("InStockListDR") ;
  	combindata=combindata+"^"+GetElementValue("No") ;
  	combindata=combindata+"^"+GetLocationRowID(GetLocationOperMethod);	///20150827  Mozy0163
  	combindata=combindata+"^"+GetElementValue("GuaranteePeriodNum");	///20150827  Mozy0163
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;
  	
  	//add by jdl 2009-06-02 JDL0006
  	combindata=combindata+"^"+GetElementValue("ContractNo") ;
  	combindata=combindata+"^"+GetElementValue("OpenCheckListDR") ;
  	combindata=combindata+"^"+GetElementValue("DepreRate") ;
  	combindata=combindata+"^"+GetElementValue("OldLoc") ;
  	combindata=combindata+"^"+GetChkElementValue("Hold5") ;			///Modify DJ 2017-01-20
  	
  	//新增:党军 2009-11-16 begin DJ0035
  	combindata=combindata+"^"+GetChkElementValue("BenefitAnalyFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("CommonageFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("AutoCollectFlag") ;
  	combindata=combindata+"^"+GetElementValue("WorkLoadPerMonth") ;
  	//党军 2009-11-16 end DJ0035
  	
  	//add by jdl 2010-8-24
  	combindata=combindata+"^"+GetElementValue("FileNo") ;
  	combindata=combindata+"^"+GetElementValue("RentLocDR") ;
  	combindata=combindata+"^"+GetElementValue("RentStatus") ;
  	combindata=combindata+"^"+GetElementValue("FaultStatus") ;
  	combindata=combindata+"^"+GetElementValue("DisuseDate") ;
  	combindata=combindata+"^"+GetElementValue("AccountNo") ;
  	combindata=combindata+"^"+GetElementValue("OldNo");		//2014-08-21 DJ0126
  	combindata=combindata+"^"+GetElementValue("RegistrationNo");
  	combindata=combindata+"^"+GetElementValue("AdvanceDisFlag");
  	combindata=combindata+"^"+GetBrandRowID(GetBrandOperMethod);	//Modify DJ 2016-07-21
  	combindata=combindata+"^"+GetElementValue("Hold10");
  	//Add By DJ 2013-06-24 DJ0118
  	combindata=combindata+"^"+GetElementValue("CommonName");
  	//Add By DJ 2014-08-21 DJ0126
  	combindata=combindata+"^"+GetElementValue("RunStatus");
  	combindata=combindata+"^"+GetElementValue("ConfigLicense");
  	combindata=combindata+"^"+GetElementValue("NewOldPercent");
  	combindata=combindata+"^"+GetElementValue("Power");
  	combindata=combindata+"^"+GetElementValue("Voltage");
  	combindata=combindata+"^"+GetElementValue("Electriccurrent");
  	combindata=combindata+"^"+GetChkElementValue("RaditionFlag");
  	combindata=combindata+"^"+GetElementValue("ReciveDate");
  	combindata=combindata+"^"+GetElementValue("UnusualRemark")	/// 20150918  Mozy0166	异常状态备注	GetElementValue("Hold1")
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
	
	combindata=combindata+"^"+GetElementValue("ValueType");
  	combindata=combindata+"^"+GetElementValue("DirectionsUse");
  	combindata=combindata+"^"+GetElementValue("UserDR");
  	combindata=combindata+"^"+GetElementValue("AccountShape");
  	combindata=combindata+"^"+GetElementValue("ProjectNo");
  	// Mozy0217  2018-11-01 友谊医院，台账增加服务商联系人,服务商联系电话,档案号分类，特种标记 
  	combindata=combindata+"^"+GetElementValue("ServiceHandler");
  	combindata=combindata+"^"+GetElementValue("ServiceTel");
  	combindata=combindata+"^"+GetElementValue("FileCat");
  	combindata=combindata+"^"+GetChkElementValue("SpecialFlag");
  	combindata=combindata+"^"+GetElementValue("SalesManager");	//Mozy	2018-5-15
  	combindata=combindata+"^"+GetElementValue("SalesManagerTel");	//Mozy	2018-5-15
  	combindata=combindata+"^"+GetElementValue("ParentDR");		//zy	2018-5-16
  	combindata=combindata+"^"+GetElementValue("Spec");		//zy	2018-5-16
  	combindata=combindata+"^"+GetElementValue("Hold13");		//zy	2018-5-16
  	combindata=combindata+"^"+GetElementValue("Hold14");		//zy	2018-5-16
  	combindata=combindata+"^"+GetElementValue("Hold15");		//zy	2018-5-16
	
 	return combindata;
}
//add by Mozy 2009-08-04 Mzy0019
function CombinDataNew()
{
	var combindataEQ=GetElementValue("RowID");
  	if(EQTypeFlag == "EQBuildingFlag")
  	{
		combindataEQ=combindataEQ+"^"+GetElementValue("BuildingArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("UtilizationArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("SubArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("Place");
		combindataEQ=combindataEQ+"^"+GetChkElementValue("OwnerFlag");
		combindataEQ=combindataEQ+"^"+GetElementValue("SelfUseArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("LendingArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("RentArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("WorkArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("IdleArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("OtherArea");
		combindataEQ=combindataEQ+"^"+GetElementValue("LendCompany");
		combindataEQ=combindataEQ+"^"+GetElementValue("RentCompany");
		combindataEQ=combindataEQ+"^"+GetElementValue("OwnerCertificate");
		combindataEQ=combindataEQ+"^"+GetElementValue("CertificateNo");
		combindataEQ=combindataEQ+"^"+GetElementValue("CertificateDate");
		combindataEQ=combindataEQ+"^"+GetElementValue("FloorNum");
		combindataEQ=combindataEQ+"^"+GetElementValue("UnderFloorNum");
		combindataEQ=combindataEQ+"^"+GetElementValue("BDHold1");
		combindataEQ=combindataEQ+"^"+GetElementValue("BDHold2");
		combindataEQ=combindataEQ+"^"+GetElementValue("BDHold3");
		combindataEQ=combindataEQ+"^"+GetElementValue("BDHold4");
		combindataEQ=combindataEQ+"^"+GetElementValue("BDHold5");
  	}else if(EQTypeFlag == "EQVehicleFlag")
  	{
		combindataEQ=combindataEQ+"^"+GetElementValue("VehicleNo");
		combindataEQ=combindataEQ+"^"+GetElementValue("EngineNo");
		combindataEQ=combindataEQ+"^"+GetElementValue("CarFrameNo");
		combindataEQ=combindataEQ+"^"+GetElementValue("Displacemint");
		combindataEQ=combindataEQ+"^"+GetElementValue("Mileage");
		combindataEQ=combindataEQ+"^"+GetElementValue("Color");
		combindataEQ=combindataEQ+"^"+GetElementValue("VHold1");
		combindataEQ=combindataEQ+"^"+GetElementValue("VHold2");
		combindataEQ=combindataEQ+"^"+GetElementValue("VHold3");
		combindataEQ=combindataEQ+"^"+GetElementValue("VHold4");
		combindataEQ=combindataEQ+"^"+GetElementValue("VHold5");
  	}
  	return combindataEQ;
}

function FillAssetTypeInfo()
{
// 专属信息		Mozy0145	20141017
	encmeth=GetElementValue("GetInfoData");
	if (encmeth=="") return;
	var InfoList=cspRunServerMethod(encmeth,1,GetElementValue("RowID"));
	InfoList=InfoList.replace(/\\n/g,"\n");
	//alertShow(InfoList)
	var Info=InfoList.split("^");
	//var AssetType=GetElementValue("AssetType");
	//InfoList增加返回AssetType并放在第一位，后面为附加资产信息
	var AssetType=Info[0];
	SetElement("AssetType",AssetType);
	
    SetElement("ATRowID",Info[1]);
    if (AssetType==1)
    {
	    //GR0019 土地资产卡片
	    //--------------------------DHC_EQLand-------------------------------------------
	    var LCount=40
    	//SetElement("LRowID",Info[1]);
	    //SetElement("LEquipDR",Info[2]);
	    SetElement("LArea",Info[3]);
	    SetElement("LLandNo",Info[4]);
	    SetElement("LOwnerFlag",Info[5]);
	    SetElement("LPlace",Info[6]);
	    SetElement("LSelfUsedArea",Info[7]);
	    SetElement("LIdleArea",Info[8]);
	    SetElement("LLendingArea",Info[9]);
	    SetElement("LRentArea",Info[10]);
	    SetElement("LWorkArea",Info[11]);
	    SetElement("LOtherArea",Info[12]);
	    SetElement("LLendCompany",Info[13]);
	    SetElement("LRentCompany",Info[14]);
	    SetElement("LOwnerCertificate",Info[15]);
	    SetElement("LCertificateNo",Info[16]);
	    SetElement("LCertificateDate",Info[17]);
	    SetElement("LOwnerKind",Info[18]);
	    SetElement("LCertificateArea",Info[19]);
	    SetElement("LHold1",Info[20]);
	    SetElement("LHold2",Info[21]);
	    SetElement("LHold3",Info[22]);
	    SetElement("LHold4",Info[23]);
	    SetElement("LHold5",Info[24]);
	    SetElement("LSelfUsedFee",Info[25]);
	    SetElement("LIdleFee",Info[26]);
	    SetElement("LLendingFee",Info[27]);
	    SetElement("LRentFee",Info[28])
	    SetElement("LWorkFee",Info[29])
	    SetElement("LOtherFee",Info[30])
	    SetElement("LSelfOwnFee",Info[31]) 
	    SetElement("LShareFee",Info[32])
	    SetElement("LSubjectsRecorded",Info[33])
	    SetElement("LUsersrightType",Info[34])
	    SetElement("LOwnershipYear",Info[35])
	    SetElement("LGetFee",Info[36])
	    //SetElement("LSourceType",Info[37])
	    //SetElement("LSourceID",Info[38])
	    SetElement("LUserRightArea",Info[39])
	    SetElement("LRemark",Info[40])
	    //----------DHC_EQEquip-----------
	    var EQCount=1
	    SetElement("EQAddDate",Info[LCount+1]);
    }
    else if (AssetType==2)
    {
	    //-----------DHC_EQStructures--------
	    var BDCount=38
   		//GR0014 房屋资产卡片
    	//SetElement("BDRowID",Info[1]);
	    //SetElement("BDEquipDR",Info[2]);
	    SetElement("BDStructDR",Info[3]);
	    SetElement("BDBuildingArea",Info[4]);
	    SetElement("BDUtilizationArea",Info[5]);
	    SetElement("BDSubArea",Info[6]);
	    SetElement("BDPlace",Info[7]);
	    SetElement("BDOwnerFlag",Info[8]);
	    SetElement("BDSelfUseArea",Info[9]);
	    SetElement("BDLendingArea",Info[10]);
	    SetElement("BDRentArea",Info[11]);
	    SetElement("BDWorkArea",Info[12]);
	    SetElement("BDIdleArea",Info[13]);
	    SetElement("BDOtherArea",Info[14]);
	    SetElement("BDLendCompany",Info[15]);
	    SetElement("BDRentCompany",Info[16]);
	    SetElement("BDOwnerCertificate",Info[17]);
	    SetElement("BDCertificateNo",Info[18]);
	    SetElement("BDCertificateDate",Info[19]);
	    SetElement("BDFloorNum",Info[20]);
	    SetElement("BDUnderFloorNum",Info[21]);
	    SetElement("BDHold1",Info[22]);
	    SetElement("BDHold2",Info[23]);
	    SetElement("BDHold3",Info[24]);
	    SetElement("BDHold4",Info[25]);
	    SetElement("BDHold5",Info[26]);
	    //SetElement("BDSourceType",Info[27]);
	    //SetElement("BDSourceID",Info[28])
	    SetElement("BDOwnerKind",Info[29])
	    SetElement("BDOwnershipYear",Info[30])
	    SetElement("BDOwner",Info[31])
	    SetElement("BDCompletionDate",Info[32])
	    SetElement("BDSelfUseFee",Info[33])
	    SetElement("BDLendingFee",Info[34])
	    SetElement("BDRentFee",Info[35])
	    SetElement("BDWorkFee",Info[36])
	    SetElement("BDIdleFee",Info[37])
	    SetElement("BDOtherFee",Info[38])
	    //SetElement("BDLandPurposeDR",Info[39])
	    //----------DHC_EQEquip-----------
	    var EQCount=1
	    SetElement("EQAddDate",Info[BDCount+1]);
	    //-----------DHCEQCBuildingStruct--------
	    var ESCount=1
	    SetElement("BDStruct",Info[BDCount+ESCount+1]);
	    
	    SetElement("BUBuildingDR",Info[1]) //房屋资产分配明细 GR0014
    }
    else if (AssetType==3)
    {
   		//GR0021 构筑物资产卡
	    //-----------DHC_EQStructures--------
	    var SCount=7
	    //SetElement("SRowID",Info[1]);
   		SetElement("SStructDR",Info[2]);
	    SetElement("SPlace",Info[3]);
	    SetElement("SOwnerFlag",Info[4]);
	    SetElement("SOwnerKind",Info[5]);
	    SetElement("SCompletionDate",Info[6]);
	    SetElement("SRemark",Info[7]);
	    //SetElement("SInvalidFlag",Info[8]);
	    //SetElement("SSourceType",Info[9]);
	    //SetElement("SSourceID",Info[10]);
	    //----------DHC_EQEquip-----------
	    var EQCount=1
	    SetElement("EQAddDate",Info[SCount+1]);
	    
	    //-------DHC_EQCBuildingStruct------
	    var BSCount=1
	    SetElement("SStruct",Info[SCount+EQCount+1]);
    }
    else if (AssetType==4)
    {
   		//SetElement("VRowID");
	    SetElement("VehicleNo",Info[3]);
	    SetElement("EngineNo",Info[4]);
	    SetElement("CarFrameNo",Info[5]);
	    SetElement("Displacemint",Info[6]);
	    SetElement("Mileage",Info[7]);
	    SetElement("SeatNum",Info[14]);
	    SetElement("VehicleOrigin",Info[15]);
	    SetElement("VPurpose",Info[16]);
	    SetElement("Plait",Info[17]);
    }
    else if (AssetType==5)
    {
   	
    }
    else if (AssetType==6)
    {
   	
    }
    else if (AssetType==7)
    {
   	
    }
    else if (AssetType==8)
    {
   		 SetElement("Level",Info[4]);
		SetElement("Year",Info[5]);
		SetElement("OriginPlace",Info[6]);
    }
    else if (AssetType==9)
    {
	     SetElement("OriginPlace",Info[7]);
		SetElement("Classes",Info[6]);
		SetElement("Life",Info[5]);
		SetElement("PlantDate",Info[4]);
   	
   	
    }
    else if (AssetType==10)
    {
   	
    }
    else if (AssetType==11)
    {
	    SetElement("TitleOfInvention",Info[4]);
		SetElement("CertificateNo",Info[5]);
		SetElement("RegistrationDept",Info[6]);
		SetElement("RegistrationDate",Info[7]);
		SetElement("ApprovalNo",Info[8]);
		SetElement("PatentNo",Info[9]);
		SetElement("Inventor",Info[10]);
		SetElement("AnnouncementDate",Info[11]);
    }
}

// 专属信息		Mozy0145	20141017
function GetAssetTypeInfo()
{
	var AssetType=GetElementValue("AssetType");
	var combindata=AssetType;
    combindata=AssetType+"^"+GetElementValue("ATRowID");
    
    if (AssetType==1)
    {
	    //GR0019 土地资产卡片
    	//combindata=combindata+"^"+GetElementValue("LRowID");			//0
	    //combindata=combindata+"^"+GetElementValue("LEquipDR");
	    combindata=combindata+"^"+GetElementValue("RowID");
	    combindata=combindata+"^"+GetElementValue("LArea");
	    combindata=combindata+"^"+GetElementValue("LLandNo");
	    combindata=combindata+"^"+GetElementValue("LOwnerFlag");
	    combindata=combindata+"^"+GetElementValue("LPlace");
	    combindata=combindata+"^"+GetElementValue("LSelfUsedArea");
	    combindata=combindata+"^"+GetElementValue("LIdleArea");
	    combindata=combindata+"^"+GetElementValue("LLendingArea");
	    combindata=combindata+"^"+GetElementValue("LRentArea");
	    combindata=combindata+"^"+GetElementValue("LWorkArea");	//10
	    combindata=combindata+"^"+GetElementValue("LOtherArea");
	    combindata=combindata+"^"+GetElementValue("LLendCompany");
	    combindata=combindata+"^"+GetElementValue("LRentCompany");
	    combindata=combindata+"^"+GetElementValue("LOwnerCertificate");
	    combindata=combindata+"^"+GetElementValue("LCertificateNo");
	    combindata=combindata+"^"+GetElementValue("LCertificateDate");
	    combindata=combindata+"^"+GetElementValue("LOwnerKind");
	    combindata=combindata+"^"+GetElementValue("LCertificateArea");
	    combindata=combindata+"^"+GetElementValue("LHold1");
	    combindata=combindata+"^"+GetElementValue("LHold2");	//20
	    combindata=combindata+"^"+GetElementValue("LHold3");
	    combindata=combindata+"^"+GetElementValue("LHold4");
	    combindata=combindata+"^"+GetElementValue("LHold5");
	    combindata=combindata+"^"+GetElementValue("LSelfUsedFee");
	    combindata=combindata+"^"+GetElementValue("LIdleFee");
	    combindata=combindata+"^"+GetElementValue("LLendingFee");
	    combindata=combindata+"^"+GetElementValue("LRentFee");
	    combindata=combindata+"^"+GetElementValue("LWorkFee");
	    combindata=combindata+"^"+GetElementValue("LOtherFee");	
	    combindata=combindata+"^"+GetElementValue("LSelfOwnFee");	//30
	    combindata=combindata+"^"+GetElementValue("LShareFee");
	    combindata=combindata+"^"+GetElementValue("LSubjectsRecorded");
	    combindata=combindata+"^"+GetElementValue("LUsersrightType");
	    combindata=combindata+"^"+GetElementValue("LOwnershipYear");
	    combindata=combindata+"^"+GetElementValue("LGetFee");
	    //combindata=combindata+"^"+GetElementValue("LSourceType");
	    //combindata=combindata+"^"+GetElementValue("LSourceID");
	    combindata=combindata+"^^^"+GetElementValue("LUserRightArea");
	    combindata=combindata+"^^^"+GetElementValue("LRemark");
	    
    }
    else if (AssetType==2)
    {
	    //GR0014 房屋资产卡片
    	//combindata=combindata+"^"+GetElementValue("BDRowID");
	    //combindata=combindata+"^"+GetElementValue("BDEquipDR");
	    combindata=combindata+"^"+GetElementValue("RowID");
	    combindata=combindata+"^"+GetElementValue("BDStructDR");
	    combindata=combindata+"^"+GetElementValue("BDBuildingArea");
	    combindata=combindata+"^"+GetElementValue("BDUtilizationArea");
	    combindata=combindata+"^"+GetElementValue("BDSubArea");
	    combindata=combindata+"^"+GetElementValue("BDPlace");
	    combindata=combindata+"^"+GetElementValue("BDOwnerFlag");
	    combindata=combindata+"^"+GetElementValue("BDSelfUseArea");
	    combindata=combindata+"^"+GetElementValue("BDLendingArea");
	    combindata=combindata+"^"+GetElementValue("BDRentArea");
	    combindata=combindata+"^"+GetElementValue("BDWorkArea");
	    combindata=combindata+"^"+GetElementValue("BDIdleArea");
	    combindata=combindata+"^"+GetElementValue("BDOtherArea");
	    combindata=combindata+"^"+GetElementValue("BDLendCompany");
	    combindata=combindata+"^"+GetElementValue("BDRentCompany");
	    combindata=combindata+"^"+GetElementValue("BDOwnerCertificate");
	    combindata=combindata+"^"+GetElementValue("BDCertificateNo");
	    combindata=combindata+"^"+GetElementValue("BDCertificateDate");
	    combindata=combindata+"^"+GetElementValue("BDFloorNum");
	    combindata=combindata+"^"+GetElementValue("BDUnderFloorNum");
	    combindata=combindata+"^"+GetElementValue("BDHold1");
	    combindata=combindata+"^"+GetElementValue("BDHold2");
	    combindata=combindata+"^"+GetElementValue("BDHold3");
	    combindata=combindata+"^"+GetElementValue("BDHold4");
	    combindata=combindata+"^"+GetElementValue("BDHold5");
	    //combindata=combindata+"^"+GetElementValue("BDSourceType");
	    //combindata=combindata+"^"+GetElementValue("BDSourceID");
	    combindata=combindata+"^^^"+GetElementValue("BDOwnerKind"); 
	    combindata=combindata+"^"+GetElementValue("BDOwnershipYear");
	    combindata=combindata+"^"+GetElementValue("BDOwner");
	    combindata=combindata+"^"+GetElementValue("BDCompletionDate");
	    combindata=combindata+"^"+GetElementValue("BDSelfUseFee");
	    combindata=combindata+"^"+GetElementValue("BDLendingFee");
	    combindata=combindata+"^"+GetElementValue("BDRentFee");
	    combindata=combindata+"^"+GetElementValue("BDWorkFee");
	    combindata=combindata+"^"+GetElementValue("BDIdleFee");
	    combindata=combindata+"^"+GetElementValue("BDOtherFee");
	    //combindata=combindata+"^"+GetElementValue("BDLandPurposeDR");
    }
    else if (AssetType==3)
    {
   		//GR0021 构筑物资产卡片
    	//combindata=combindata+"^"+GetElementValue("SRowID");
	    combindata=combindata+"^"+GetElementValue("SStructDR");
	    combindata=combindata+"^"+GetElementValue("SPlace");
	    combindata=combindata+"^"+GetElementValue("SOwnerFlag");
	    combindata=combindata+"^"+GetElementValue("SOwnerKind");
	    combindata=combindata+"^"+GetElementValue("SCompletionDate");
	    combindata=combindata+"^"+GetElementValue("SRemark");
	    //combindata=combindata+"^"+GetElementValue("SInvalidFlag");
	    //combindata=combindata+"^"+GetElementValue("SSourceType");
	    //combindata=combindata+"^"+GetElementValue("SSourceID");
    }
    else if (AssetType==4)
    {
   		//combindata=combindata+"^"+GetElementValue("VRowID");
   		combindata=combindata+"^"+GetElementValue("RowID");
	    combindata=combindata+"^"+GetElementValue("VehicleNo");
	    combindata=combindata+"^"+GetElementValue("EngineNo");
	    combindata=combindata+"^"+GetElementValue("CarFrameNo");
	    combindata=combindata+"^"+GetElementValue("Displacemint");
	    combindata=combindata+"^"+GetElementValue("Mileage");
	    combindata=combindata+"^^^^^^^"+GetElementValue("SeatNum");
	    combindata=combindata+"^"+GetElementValue("VehicleOrigin");
	    combindata=combindata+"^"+GetElementValue("VPurpose");
	    combindata=combindata+"^"+GetElementValue("Plait");
    }
    else if (AssetType==5)
    {
   	
    }
    else if (AssetType==6)
    {
   	
    }
    else if (AssetType==7)
    {
   	
    }
    else if (AssetType==8)
    {
   	combindata=combindata+"^^^"+GetElementValue("Level");
	    combindata=combindata+"^"+GetElementValue("Year");
	    combindata=combindata+"^"+GetElementValue("OriginPlace");
   	
    }
    else if (AssetType==9)
    {
	    combindata=combindata+"^^^"+GetElementValue("PlantDate");
	    combindata=combindata+"^"+GetElementValue("Life");
	    combindata=combindata+"^"+GetElementValue("Classes");
	    combindata=combindata+"^"+GetElementValue("OriginPlace");
   	
    }
    else if (AssetType==10)
    {
   	
    }
    else if (AssetType==11)
    {
	    combindata=combindata+"^"+GetElementValue("TitleOfInvention");
	    combindata=combindata+"^"+GetElementValue("CertificateNo");
	    combindata=combindata+"^"+GetElementValue("RegistrationDept");
	    combindata=combindata+"^"+GetElementValue("RegistrationDate");
	    combindata=combindata+"^"+GetElementValue("ApprovalNo");
	    combindata=combindata+"^"+GetElementValue("PatentNo");
	    combindata=combindata+"^"+GetElementValue("Inventor");
	    combindata=combindata+"^"+GetElementValue("AnnouncementDate");
    }
    
    return combindata;
}
function InitStandardKeyUp()
{
	KeyUp("Model^EquiCat^Unit^InstallLoc^Country^ManageLoc^UseLoc^Origin^FromDept^ToDept^BuyType^EquipTechLevel^Provider^ManuFactory^ContractList^DepreMethod^WorkLoadUnit^MaintUser^EquipType^PurchaseType^Keeper^StoreLoc^Service^StatCat^Brand^SStruct^Location","N");
	//Group^ManageUser^AddUser^UpdateUser^Currency^ManageUser^
	Muilt_LookUp("Name^Model^EquiCat^Unit^InstallLoc^Country^ManageLoc^UseLoc^Origin^FromDept^ToDept^BuyType^EquipTechLevel^Provider^ManuFactory^ContractList^DepreMethod^WorkLoadUnit^MaintUser^EquipType^PurchaseType^Keeper^StoreLoc^Service^StatCat^PurposeType^Location^MIHold1Desc^Brand^SStruct");
	var ModelOperMethod=GetElementValue("GetModelOperMethod") //2009-07-09 党军 begin
	if (ModelOperMethod==1) //1:手工录入 0:放大镜选择操作.
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").removeNode(true)
	} //2009-07-09 党军 end
	
	//2009-11-11 ZY begin ZY0016
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetManuFactoryOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iManuFactory").removeNode(true)
	}
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}	
	//2009-11-11 ZY end
	
	//20150827  Mozy0163	存放地点
	//var obj=document.getElementById("ServiceHandlerDesc");
	//if (obj) obj.onkeyup=ServiceHandlerDesc_KeyUp;
	
	return;
	var obj=document.getElementById("Model");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("EquiCat");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Unit");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("InstallLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Country");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ManageLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ManageLevel");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UseLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Origin");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("FromDept");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ToDept");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("BuyType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("EquipTechLevel");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Provider");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ManuFactory");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Group");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ContractList");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("DepreMethod");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("WorkLoadUnit");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ManageUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("MaintUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AddUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UpdateUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Currency");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("EquipType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("PurchaseType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("PurposeType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Keeper");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("StoreLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Service");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("StatCat");
	if (obj) obj.onkeyup=Standard_KeyUp;
	
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Name","");
	SetElement("ABCType","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("EquiCat","");
	SetElement("EquiCatDR","");
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("Code","");
	SetElement("ItemDR","");
	SetElement("InstallLoc","");
	SetElement("InstallLocDR","");
	SetElement("InstallDate","");
	SetElement("LeaveFactoryNo","");
	SetElement("LeaveFactoryDate","");
	SetElement("OpenCheckDate","");
	SetElement("CheckDate","");
	SetElement("MakeDate","");
	SetChkElement("ComputerFlag",0);
	SetElement("Country","");
	SetElement("CountryDR","");
	SetElement("ManageLoc","");
	SetElement("ManageLocDR","");
	SetElement("ManageLevel","");
	SetElement("ManageLevelDR","");
	SetElement("UseLoc","");
	SetElement("UseLocDR","");
	SetElement("Origin","");
	SetElement("OriginDR","");
	SetElement("FromDept","");
	SetElement("FromDeptDR","");
	SetElement("ToDept","");
	SetElement("ToDeptDR","");
	SetElement("BuyType","");
	SetElement("BuyTypeDR","");
	SetElement("EquipTechLevel","");
	SetElement("EquipTechLevelDR","");
	SetElement("Provider","");
	SetElement("ProviderDR","");
	SetElement("ManuFactory","");
	SetElement("ManuFactoryDR","");
	SetElement("OriginalFee","");
	SetElement("NetFee","");
	SetElement("NetRemainFee","");
	SetElement("Group","");
	SetElement("GroupDR","");
	SetElement("LimitYearsNum","");
	SetElement("ContractList","");
	SetElement("ContractListDR","");
	SetElement("DepreMethod","");
	SetElement("DepreMethodDR","");
	SetElement("Remark","");
	SetElement("DepreTotalFee","");
	SetElement("DesignWorkLoadNum","");
	SetElement("WorkLoadUnit","");
	SetElement("WorkLoadUnitDR","");
	SetElement("Status","");
	SetElement("ManageUser","");
	SetElement("ManageUserDR","");
	SetElement("MaintUser","");
	SetElement("MaintUserDR","");
	SetElement("ProviderHandler","");
	SetElement("ProviderTel","");
	SetElement("AppendFeeTotalFee","");
	SetElement("StartDate","");
	SetElement("TransAssetDate","");
	SetChkElement("GuaranteeFlag",0);
	SetChkElement("InputFlag",0);
	SetChkElement("TestFlag",0);
	SetChkElement("MedicalFlag",0);
	SetElement("GuaranteeStartDate","");
	SetElement("GuaranteeEndDate","");
	SetElement("AddUser","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUser","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("Currency","");
	SetElement("CurrencyDR","");
	SetElement("No","")
	SetElement("StatusDisplay","");
	
	//SetElement("InvalidFlag","");
	SetElement("StockStatus","");
	SetElement("MemoryCode","");
	SetChkElement("UrgencyFlag",0);
	//SetElement("UrgencyFlag","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("PurchaseType","");
	SetElement("PurchaseTypeDR","");
	SetElement("PurposeType","");
	SetElement("PurposeTypeDR","");
	SetElement("Keeper","");
	SetElement("KeeperDR","");
	SetElement("StoreLoc","");
	SetElement("StoreLocDR","");
	SetElement("StartDepreMonth","");
	SetElement("Service","");
	SetElement("ServiceDR","");
	//SetElement("InStockListDR","");
	SetElement("No","");
	SetElement("ServiceHandler","");
	SetElement("ServiceTel","");
	SetElement("StatCatDR","");
	SetElement("StatCat","");
	
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("MIHold1","");
	SetElement("MIHold1Desc","");
	SetElement("CommonName",""); 	//2013-06-24 DJ0118
	SetElement("BrandDR","");	//2013-12-11 DJ0122
	SetElement("Brand","");	//2013-12-11 DJ0122

	SetElement("ContractNo","")	//2014-08-21 DJ0126
	SetElement("OpenCheckListDR","")
	SetElement("DepreRate","")
	SetElement("OldLoc","")
	SetElement("OldNo","")
	SetElement("RegistrationNo","");
	SetElement("AdvanceDisFlag","");
	SetElement("RunStatus","");
	SetElement("ConfigLicense","");
	SetElement("NewOldPercent","");
	SetElement("Power","");
	SetElement("Voltage","");
	SetElement("Electriccurrent","");
	SetChkElement("RaditionFlag",0);
	SetElement("ReciveDate","");
	// Mozy0217  2018-11-01 友谊医院，台账增加服务商联系人,服务商联系电话,档案号分类，特种标记 
	SetElement("ServiceHandler","");
	SetElement("ServiceTel","");
	SetElement("FileCat","");
	SetChkElement("SpecialFlag",0);	
	SetElement("SalesManager","");		//Mozy	2018-5-15
	SetElement("SalesManagerTel","");	//Mozy	2018-5-15
  	SetElement("ParentDR","");		//zy	2018-5-16
  	SetElement("Spec","");			//zy	2018-5-16
  	SetElement("Hold13","");		//zy	2018-5-16
  	SetElement("Hold14","");		//zy	2018-5-16
  	SetElement("Hold15","");		//zy	2018-5-16
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
function GetKeeper (value)
{
    GetLookUpID("KeeperDR",value);
}
function GetStoreLoc (value)
{
    GetLookUpID("StoreLocDR",value);
}
function GetService (value)
{
    GetLookUpID("ServiceDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}

function GetUser (value)
{
    GetLookUpID("UserDR",value);
}

//Craetor:Mozy
//Date:2009-2-27
function GetManageLevelDR (value)
{
    GetLookUpID("ManageLevelDR",value);
}
function GetItem(value)
{
	var ReturnList=value.split("^")
	SetElement("ItemDR",ReturnList[1]);
	SetElement("EquiCatDR",ReturnList[3]);
	SetElement("EquiCat",ReturnList[4]);
	SetElement("UnitDR",ReturnList[5]);
	SetElement("Unit",ReturnList[6]);
	SetElement("CommonName",ReturnList[0]);	//2013-06-24 DJ0118
}
///20150630  Mozy0154
function GetExpenditures(value)
{
	var ReturnList=value.split("^")
	SetElement("Hold10",ReturnList[1]);
}
function PrintAffix()
{	
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1)){
		return;
	}
	
	var otherInfo=cspRunServerMethod(GetElementValue("GetOtherListInfo"),RowID);
	var otherlist=otherInfo.split("@");
	var affixlist=otherlist[0].split("&");
	var doclist=otherlist[1].split("&");
	var affixrows=affixlist.length;
	var docrows=doclist.length;
	
	var TemplatePath=GetElementValue("GetRepPath");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQCheck.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    for (var Row=0;Row<affixrows;Row++)
		{
			var affix=affixlist[Row].split("^");
			xlsheet.cells(Row+7,2)=affix[0];
			xlsheet.cells(Row+7,4)=affix[1];
			xlsheet.cells(Row+7,5)=affix[2];
			xlsheet.cells(Row+7,6)=affix[3];
		}

	    xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}	
}

function BPrintCard_Click()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1))	return;
	PrintEQCard(rowid);
}

function BPrintCardVerso_Click()
{
	//BExportToApp();
	//return;
	//ShowLand();
	//return;
	
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1))	return;
	PrintEQCardVerso(rowid);
}

///
function ShowLand()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1))	return;
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLand&EquipDR="+rowid;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=760,height=460,left=150,top=150')
}

//add by dj 2009-05-20  dj0003
function BBatchUpdate_Click()
{
 	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipBatchUpdate&RowID='+GetElementValue("RowID")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

///add by jdl 2010-2-5
function BExportToApp()
{
	var rowid=GetElementValue("RowID");	
	if ((rowid=="")||(rowid<1)) 
	{	
		return;	
	}
	alertShow("请确认应用窗口已经打开,并为新增状态!");
	var encmeth=GetElementValue("GetEquipToApp");
	var result=cspRunServerMethod(encmeth,rowid,"JQ");
	if (result=="") return;
	//alertShow(result);
	var objMessage= new ActiveXObject("Message.ClsMessage");
	///替换,trakcare不识别字符替换方式??1="??"
	///"行政事业单位资产管理信息系统??事业版 - [" 替换为"行政事业单位资产管理信息系统?1事业版 - ["
	result=objMessage.FillMessage("DT^JQ^EQUIP", t['jqzy'], "1", result)
	if (result=="NoWindow") 
	{
		alertShow("没有找到相应窗口,请检查应用窗口是否打开!");
	}
	else
	{
		alertShow("向应用窗口填充信息完成,请检查!");
	}
}

//20150825  Mozy0163	存放地点
function SetLocation(value)
{
	list=value.split("^");
	SetElement("LocationDR",list[0]);
	SetElement("Location",list[2]);
}
/*20150825  Mozy0163	存放地点
function ServiceHandlerDesc_KeyUp()
{
	SetElement("ServiceHandler","");
}*/
function SetEQFlag(value)
{
	//	1 房屋及建筑物	2 专用设备	3 一般设备	4 图书	5 其他
	if(value=="") return;
	EQTypeFlag="";

	var listBFlag=GetElementValue("BuildingFlag").split(",");
	var listVFlag=GetElementValue("VehicleFlag").split(",");
	for(var i=0;i<listBFlag.length;i++)
	{
		if(+value==listBFlag[i])
		{
			EQTypeFlag="EQBuildingFlag";
		}
	}
	for(var i=0;i<listVFlag.length;i++)
	{
		if(+value==listVFlag[i])
		{
			EQTypeFlag="EQVehicleFlag";
		}
	}
}
//Mozy0110
function MIHold1Desc_Click()
{
	var CatName=GetElementValue("MIHold1Desc")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCTree&TreeType=1&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

///房屋单元分配明细.Add By HZY 2012-10-15
function BBuildingUnitAllotDetail_Click()
{
	var BUBuildingDR=GetElementValue("BUBuildingDR");
	var BuildingName=GetElementValue("Name");	
	if ((BUBuildingDR=="")||(BUBuildingDR<1)) 
	{	
		return;	
	}
	var readonly=GetElementValue("ReadOnly");
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuildingUnit&BuildingDR="+BUBuildingDR+"&Building="+BuildingName+"&ReadOnly="+readonly+"&QXType=0";
	//alertShow(str);
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=800,left=150,top=150');
}
//Add By DJ2013-12-11 DJ0122
function GetBrandID(value)
{
	var obj=document.getElementById("BrandDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

function BCheckEquipZZ_Click()
{
	var SourceID=GetElementValue("RowID");
	var SourceListID=GetElementValue("RowID");
	var OCRRowID=GetElementValue("OCRRowID");
	var OCLRowID=GetElementValue("OpenCheckListDR");	//2014-08-21 DJ 0126
	if (1==GetElementValue("ReadOnly"))
	{
		var SourceStatus=2
	}
	else
	{
		var SourceStatus=0
	}
	if (OCLRowID>0)
	{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQ0007&SourceID='+OCRRowID+'&SourceListID='+OCLRowID+'&SourceStatus='+SourceStatus+'&SourceType=OpenCheckRequest';
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0')
	}
	else
	{
		if (SourceListID>0)
		{
			var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQ0007&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus+'&SourceType=Equip';
    		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0')
		}
	}
}

function GetSStructDR(para)
{
	var Info=para.split("^");
	SetElement("SStruct",Info[2]);
	SetElement("SStructDR",Info[0]);
	
}
function GetBDStructDR(para)
{
	//alertShow(para)
	var Info=para.split("^");
	SetElement("BDStruct",Info[2]);
	SetElement("BDStructDR",Info[0]);
	
}

// Mozy0217  2018-11-01
//台账增加附属设备和配置补录
function BEquipConfig_Clicked()
{
	var RowID=GetElementValue("RowID")
	var Flag=0
	var code=201011
	var encmeth=GetElementValue("GetSysInfo");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,code);
	if (result>=0) return
	var ParentDR=GetElementValue("ParentDR")
	if (ParentDR!="") return;
	var str='dhceq.process.equipconfig.csp?&SourceType=2&SourceID='+GetElementValue("RowID")+'&Status=0'+'&Flag='+Flag;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=940,height=650,left=120,top=0')
}
function BConfig_Clicked()
{
	var RowID=GetElementValue("RowID")
	var Flag=1
	var str='dhceq.process.config.csp?&SourceType=2&SourceID='+GetElementValue("RowID")+'&Status=0'+'&Flag='+Flag;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=940,height=650,left=120,top=0')
}
document.body.onload = BodyLoadHandler;
