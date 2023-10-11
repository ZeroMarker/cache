///---------------------------------------------------
///创建:2009-08-25 党军 DJ0029
///描述:设备配件信息维护(包括:新增,修改,删除,查找)
///---------------------------------------------------
var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();	//初始化
	FillData();
	KeyUp("ManuFactory^BaseUOM^Country^Type^Cat");	//清空选择
	Muilt_LookUp("ManuFactory^BaseUOM^Country^Type^Cat");
	SetChkElement("AutoSaveProvider",1);	//默认自动把生产厂商生成供应商
	initButtonWidth()  //hisui改造		Mozy0244 2020-1-20	1177453
	// MZY0029	1340070		2020-05-29
	if ((GetElementValue("RowID")=="")||(GetElementValue("CheckPrice")=="")||(GetElementValue("Hold3")!="")) hiddenObj("BCheckPrice",1);
	// MZY0042	1436514		2020-8-4	增加复制操作过滤
	if ((GetElementValue("AccessoryInfo")!=1)&&((GetElementValue("CheckPrice")==1)||(GetElementValue("Hold3")!="")))
	{
		hiddenObj("BClear",1);
		hiddenObj("BUpdate",1);
	}
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BNewOrder");
	if (obj) obj.onclick=BNewOrder_Click;
	var obj=document.getElementById("Desc");
	if (obj) obj.onchange=GetCode;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BClose")
	if (obj) obj.onclick=CloseWindow;
	// MZY0029	1340070		2020-05-29
	var obj=document.getElementById("BCheckPrice")
	if (obj) obj.onclick=BCheckPrice_Click;
	
	///add by lmm 360064
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BClear",true)
		hiddenObj("BCheckPrice",1);
	}
}

function GetCode()
{
	var Desc=GetElementValue("Desc");
	var Code=GetPYCode(Desc);
	SetElement("Code",Code);
	SetElement("ShortDesc",Code);
}

//HISUI改造 hly add 20190221
function CloseWindow()
{
	var openerType=typeof(window.opener)
	if (openerType!="undefined")
	{
		window.close();
	}
	closeWindow('modal');
}

function BNewOrder_Click()
{
	window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory' //hly 20190213
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	
	if ((GetChkElementValue("ExpiredFlag")==true)&&(GetElementValue("ExpiredDays")==""))  //Begin add BY:GBX 2014-9-16 22:23:49 
	{
		alertShow("请输入保质期天数!");		// MZY0028	1334583		2020-05-26
		return;
	}
	if ((GetChkElementValue("ExpiredFlag")==false)&&(GetElementValue("ExpiredDays")!=""))
	{
		alertShow("无保质期,不需要保质期天数");		// MZY0028	1334583		2020-05-26
		SetElement("ExpiredDays","");
		return;
	}
	var result=cspRunServerMethod(encmeth,plist);
	//alertShow(result)
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		
		messageShow("","","",t["02"]);//hly add 20190222
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&RowID='+result //hly 20190213
		
		// add by kdf 2018-02-03 需求号：542633 
		// 父界面点击新增，子界面若是通过open的方式打开，下面的方法可以自动刷新父界面。
		//self.opener.location.reload();
		 
		websys_showModal("options").mth();//hly add 20190222

		  
	}
	else
	{
		if (result=="-1")  //modify BY:DJ 2014-9-19 17:04:15
		{
			alertShow("数据重复!请检查.")
		}
		alertShow(t["01"])
	}
}

function CombinData()
{
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod");
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
    combindata=combindata+"^"+GetElementValue("Code") ;//2 编码
    combindata=combindata+"^"+GetElementValue("Desc") ;//3 名称
    combindata=combindata+"^"+GetElementValue("ShortDesc") ;//4 简称
    combindata=combindata+"^"+GetElementValue("Model") ;//5 规格
    combindata=combindata+"^"+GetElementValue("BaseUOMDR") ;//6 基本单位
	combindata=combindata+"^"+GetElementValue("BillUOMDR") ;//7
	combindata=combindata+"^"+GetElementValue("StdSPrice") ;//8
	combindata=combindata+"^"+GetElementValue("MinSPrice") ;//9
	combindata=combindata+"^"+GetElementValue("MaxSPrice") ;//10
	combindata=combindata+"^"+GetElementValue("CurBPrice") ;//11
	combindata=combindata+"^"+GetElementValue("MinBPrice") ;//12
	combindata=combindata+"^"+GetElementValue("MaxBPrice") ;//13
	combindata=combindata+"^"+GetElementValue("FeeRulesDR");//14
	combindata=combindata+"^"+GetElementValue("TypeDR") ;//15
	combindata=combindata+"^"+GetElementValue("CatDR") ;//16
	combindata=combindata+"^"+GetElementValue("CountryDR") ;//17
	combindata=combindata+"^"+GetElementValue("PlaceOfProduction") ;//18
	combindata=combindata+"^"+GetElementValue("GeneralName");//19
	combindata=combindata+"^"+GetElementValue("CommercialName");//20
	combindata=combindata+"^"+GetElementValue("Brand");//21
	combindata=combindata+"^"+GetElementValue("BrandCertificate");//22
	combindata=combindata+"^"+GetElementValue("RegisterNo");//23
	combindata=combindata+"^"+GetElementValue("CertificateNo");//24
	combindata=combindata+"^"+GetElementValue("ProductionLicence");//25
	combindata=combindata+"^"+GetElementValue("ImportNo");//26
	combindata=combindata+"^"+GetElementValue("ImportRegisterNo");//27
	combindata=combindata+"^"+GetManuFactoryRowID(GetManuFactoryOperMethod)	//GetElementValue("ManuFactoryDR");//28
	combindata=combindata+"^"+GetElementValue("PakageType");//29
	combindata=combindata+"^"+GetElementValue("WastageRate");//30
	combindata=combindata+"^"+GetChkElementValue("SolitudeFlag");//31
	combindata=combindata+"^"+GetElementValue("BarCode");//32
	combindata=combindata+"^"+GetChkElementValue("ExpiredFlag");//33
	combindata=combindata+"^"+GetElementValue("ExpiredDays");//34
	combindata=combindata+"^"+GetElementValue("WarningDays");//35
	combindata=combindata+"^"+GetChkElementValue("SerialFlag");//36
	combindata=combindata+"^"+GetElementValue("MinOrderQty");//37
	combindata=combindata+"^"+GetElementValue("MaxOrderQty");//38
	combindata=combindata+"^"+GetElementValue("ABCType");//39
	combindata=combindata+"^"+GetElementValue("OverStock");//40
	combindata=combindata+"^"+GetChkElementValue("SelfMakeFlag");//41
	combindata=combindata+"^"+GetChkElementValue("SaleFlag");//42
	combindata=combindata+"^"+GetChkElementValue("VirtualFlag");//43
	combindata=combindata+"^"+GetChkElementValue("PurchaseFlag");//44
	combindata=combindata+"^"+GetElementValue("FixPreDays");//45
	combindata=combindata+"^"+GetElementValue("ExpSaleRate");//46
	combindata=combindata+"^"+GetElementValue("WorthQty");//47
	combindata=combindata+"^"+GetElementValue("SafeQty");//48
	combindata=combindata+"^"+GetElementValue("MinQty");//49
	combindata=combindata+"^"+GetElementValue("MaxQty");//50
	combindata=combindata+"^"+GetChkElementValue("StockEnabledFlag");//51
	combindata=combindata+"^"+GetElementValue("Volume");//52
	combindata=combindata+"^"+GetElementValue("VolumeUOMDR");//53
	combindata=combindata+"^"+GetElementValue("Weight");//54
	combindata=combindata+"^"+GetElementValue("WeightUOMDR");//55
	combindata=combindata+"^"+GetElementValue("RequireNote");//56
	combindata=combindata+"^"+GetElementValue("ShowMessage");//57
	combindata=combindata+"^"+GetChkElementValue("NeedTest");//58
	combindata=combindata+"^"+GetChkElementValue("AllowOrderNoStock");//59
	combindata=combindata+"^"+GetElementValue("EffDate");//60
	combindata=combindata+"^"+GetElementValue("EffTime");//61
	combindata=combindata+"^"+GetElementValue("EffDateTo");//62
	combindata=combindata+"^"+GetElementValue("EffTimeTo");//63
	combindata=combindata+"^"+GetChkElementValue("VisibleInOrderList");//64
	combindata=combindata+"^"+GetElementValue("ServMaterial");//65
	combindata=combindata+"^"+GetElementValue("Version");//66
	combindata=combindata+"^"+GetElementValue("ExtendCode");//67
	combindata=combindata+"^"+GetChkElementValue("ReturnableFlag");//68
	combindata=combindata+"^"+GetElementValue("ReturnInspectRequirement");//69
	combindata=combindata+"^"+GetElementValue("PickingRule");//70
	combindata=combindata+"^"+GetElementValue("Remark");//71
	combindata=combindata+"^"+GetChkElementValue("BatchFlag");//72
	combindata=combindata+"^"+GetElementValue("Hold1");//73
	combindata=combindata+"^"+GetElementValue("Hold2");//74
	combindata=combindata+"^"+GetElementValue("Hold3");//75
	combindata=combindata+"^"+GetElementValue("Hold4");//76
	combindata=combindata+"^"+GetElementValue("Hold5");//77
	combindata=combindata+"^"+GetElementValue("Hold6");//78
	combindata=combindata+"^"+GetElementValue("Hold7");//79
	combindata=combindata+"^"+GetElementValue("Hold8");//80
	combindata=combindata+"^"+GetElementValue("Hold9");//81
	combindata=combindata+"^"+GetElementValue("Hold10");//82
	combindata=combindata+"^"+GetChkElementValue("AutoSaveProvider");	//生成供应商
  	return combindata;
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;
	// MZY0028	1334583		2020-05-26
	if (IsValidateNumber(getElementValue("ExpiredDays"),1,0,0,1)==0)
	{
		alertShow("保质期天数数据异常,请核对.")
		return true;
	}
	return false;
}

function FillData()
{
	var RowID=GetElementValue("RowID");	
	if ((RowID=="")||(RowID<1)) 
	{
		return;	
	}
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var sort=89
	
	var list=ReturnList.split("^");
	//alertShow(ReturnList+"  "+list[sort+0]+" &  "+list[sort+1])
	SetElement("RowID",list[sort+0]);
	SetElement("Code",list[0]);
	SetElement("Desc",list[1]);
	SetElement("ShortDesc",list[2]);
	SetElement("Model",list[3]);
	SetElement("BaseUOMDR",list[4]);
	SetElement("BaseUOM",list[sort+1]);
	SetElement("BillUOMDR",list[5]);
	SetElement("BillUOM",list[sort+2]);
	SetElement("StdSPrice",list[6]);
	SetElement("MinSPrice",list[7]);
	SetElement("MaxSPrice",list[8]);
	SetElement("CurBPrice",list[9]);
	SetElement("MinBPrice",list[10]);
	SetElement("MaxBPrice",list[11]);
	SetElement("FeeRulesDR",list[12]);
	SetElement("FeeRules",list[sort+3]);
	SetElement("TypeDR",list[13]);
	SetElement("Type",list[sort+4]);
	SetElement("CatDR",list[14]);
	SetElement("Cat",list[sort+5]);
	SetElement("CountryDR",list[15]);
	SetElement("Country",list[sort+6]);
	SetElement("PlaceOfProduction",list[16]);
	SetElement("GeneralName",list[17]);
	SetElement("CommercialName",list[18]);
	SetElement("Brand",list[19]);
	SetElement("BrandCertificate",list[20]);
	SetElement("RegisterNo",list[21]);
	SetElement("CertificateNo",list[22]);
	SetElement("ProductionLicence",list[23]);
	SetElement("ImportNo",list[24]);
	SetElement("ImportRegisterNo",list[25]);
	SetElement("ManuFactoryDR",list[26]);
	SetElement("ManuFactory",list[sort+7]);
	SetElement("PakageType",list[27]);
	SetElement("WastageRate",list[28]);
	SetChkElement("SolitudeFlag",list[sort+14]);
	SetElement("BarCode",list[30]);
	SetChkElement("ExpiredFlag",list[sort+15]);
	SetElement("ExpiredDays",list[32]);
	SetElement("WarningDays",list[33]);
	SetChkElement("SerialFlag",list[sort+16]);
	SetElement("MinOrderQty",list[35]);
	SetElement("MaxOrderQty",list[36]);
	SetElement("ABCType",list[37]);
	SetElement("OverStock",list[38]);
	SetChkElement("SelfMakeFlag",list[sort+17]);
	SetChkElement("SaleFlag",list[sort+18]);
	SetChkElement("VirtualFlag",list[sort+19]);
	SetChkElement("PurchaseFlag",list[sort+20]);
	SetElement("FixPreDays",list[43]);
	SetElement("ExpSaleRate",list[44]);
	SetElement("WorthQty",list[45]);
	SetElement("SafeQty",list[46]);
	SetElement("MinQty",list[47]);
	SetElement("MaxQty",list[48]);
	SetChkElement("StockEnabledFlag",list[sort+21]);
	SetElement("Volume",list[50]);
	SetElement("VolumeUOMDR",list[51]);
	SetElement("VolumeUOM",list[sort+8]);
	SetElement("Weight",list[52]);
	SetElement("WeightUOMDR",list[53]);
	SetElement("WeightUOM",list[sort+9]);
	SetElement("RequireNote",list[54]);
	SetElement("ShowMessage",list[55]);
	SetChkElement("NeedTest",list[sort+12]);
	SetChkElement("AllowOrderNoStock",list[sort+23]);
	SetElement("EffDate",list[sort+12]);
	SetElement("EffTime",list[sort+19]);
	SetElement("EffDateTo",list[sort+13]);
	SetElement("EffTimeTo",list[sort+11]);
	SetChkElement("VisibleInOrderList",list[sort+24]);
	SetElement("ServMaterial",list[63]);
	SetElement("Version",list[64]);
	SetElement("ExtendCode",list[65]);
	SetChkElement("ReturnableFlag",list[sort+25]);
	SetElement("ReturnInspectRequirement",list[67]);
	SetElement("PickingRule",list[68]);
	SetElement("Remark",list[69]);
	SetChkElement("BatchFlag",list[sort+26]);
	SetElement("Hold1",list[77]);
	SetElement("Hold2",list[78]);
	SetElement("Hold3",list[79]);
	SetElement("Hold4",list[80]);
	SetElement("Hold5",list[81]);
	SetElement("Hold6",list[82]);
	SetElement("Hold7",list[83]);
	SetElement("Hold8",list[84]);
	SetElement("Hold9",list[85]);
	SetElement("Hold10",list[86]);
	
	/// 设置传递配件项信息
	if (GetElementValue("AccessoryInfo")==1)
	{
		SetElement("RowID","");
		//需求序号:	409347		Mozy	20170710
		//SetElement("Model","");
		//SetElement("CurBPrice","");
	}
}

function GetManuFactory(value)
{
	GetLookUpID("ManuFactoryDR",value);
}

function GetBillUOM(value)
{
	GetLookUpID("BillUOMDR",value);
}
function GetBaseUOM(value)
{
	GetLookUpID("BaseUOMDR",value);
}
function GetVolumeUOM(value)
{
	GetLookUpID("VolumeUOMDR",value);
}
function GetWeightUOM(value)
{
	GetLookUpID("WeightUOMDR",value);
}
function GetCountry(value)
{
	GetLookUpID("CountryDR",value);
}
function GetAccessoryCat(value)
{
	GetLookUpID("CatDR",value);
}
function GetAccessoryType(value)
{
	GetLookUpID("TypeDR",value);
}
function GetFeeRules(value)
{
	GetLookUpID("FeeRulesDR",value);
}
function BClear_Click()
{
	window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory' //hly 20190213
}
// MZY0029	1340070		2020-05-29
function BCheckPrice_Click()
{
	var result=tkMakeServerCall("web.DHCEQCAccessory","UpdateHold3",getElementValue("RowID"));
	if (result>0)
	{
		messageShow("","","",t["02"]);
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&RowID='+result+"&CheckPrice="+GetElementValue("CheckPrice");
		websys_showModal("options").mth();
	}
	else
	{
		alertShow(t["01"])
	}
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
