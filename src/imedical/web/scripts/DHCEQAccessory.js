function BodyLoadHandler() 
{
	//InitPage();
	FillData();
	//SetEnabled();
	KeyUp("BaseUOM^ManuFactory");  //modify BY:GBX 2014-9-22 19:50:39
	Muilt_LookUp("BaseUOM^ManuFactory");
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
}

function BUpdate_Click()  //modify BY:GBX 2014-9-22 19:50:49
{
	var combindata=""
	var combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("Model");
	combindata=combindata+"^"+GetElementValue("BaseUOM");
	combindata=combindata+"^"+GetElementValue("BaseUOMDR");
	combindata=combindata+"^"+GetElementValue("ManuFactory");
	combindata=combindata+"^"+GetElementValue("ManuFactoryDR") ;
	combindata=combindata+"^"+GetElementValue("SeriaNo");
	var encmeth=GetElementValue("GetUpdate")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAccessory&RowID='+Rtn;
	}
    else
    {
	    alertShow(EQMsg(t["01"],Rtn));
    }
}

function GetManuFactory(value)  //modify BY:GBX 2014-9-22 19:50:55
{
	GetLookUpID("ManuFactoryDR",value);
}

function GetBaseUOM(value)  //modify BY:GBX 2014-9-22 19:51:01
{
	GetLookUpID("BaseUOMDR",value);	
}

function SetEnabled()
{
	DisableBElement("Loc",true);
	DisableBElement("Code",true);
	DisableBElement("Desc",true);
	DisableBElement("BatchNo",true);
	DisableBElement("ExpiryDate",true);
	DisableBElement("Bprice",true);
	//DisableBElement("SeriaNo",true);
	DisableBElement("No",true);
	DisableBElement("AccessoryType",true);
	DisableBElement("Status",true);
	//DisableBElement("BaseUOM",true);
	//DisableBElement("ManuFactory",true);
	//DisableBElement("Model",true);
	DisableBElement("Provider",true);
	DisableBElement("Stock",true);
	DisableBElement("StartDate",true);
	DisableBElement("DisuseDate",true);
	DisableBElement("InType",true);
	DisableBElement("InSourceID",true);
	DisableBElement("ToType",true);
	DisableBElement("ToSourceID",true);
	DisableBElement("StdSPrice",true);
	DisableBElement("PlaceOfProduction",true);
	DisableBElement("GeneralName",true);
	DisableBElement("CommercialName",true);  //modify BY:GBX 2014-9-15 11:45:34
	DisableBElement("RegisterNo",true);
	DisableBElement("ProductionLicence",true);  //modify BY:GBX 2014-9-15 12:02:31
	DisableBElement("PakageType",true);
	DisableBElement("ExpiredFlag",true);
	DisableBElement("ExpiredDays",true);
	DisableBElement("WarningDays",true);	
	DisableBElement("Status",true);
	DisableBElement("Type",true);
	if (GetElementValue("BatchFlag")=="1")
	{
		DisableBElement("SeriaNo",true);
	}
	
	
	DisableBElement("BatchFlag",true);
	DisableBElement("SerialFlag",true);
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj)
	{
		var encmeth=obj.value;
	} 
	else
	{
		var encmeth="";
		return;
	}
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(ReturnList)
	list=ReturnList.split("^");
	var sort=35;
	SetElement("LocDR",list[0]);
	SetElement("Loc",list[sort+0]);
	SetElement("Code",list[3]);
	SetElement("Desc",list[4]);
	SetElement("BatchNo",list[5]);
	SetElement("ExpiryDate",list[6]);
	SetElement("Bprice",list[7]);
	SetElement("SeriaNo",list[8]);
	SetElement("No",list[9]);
	SetElement("AccessoryTypeDR",list[10]);
	SetElement("AccessoryType",list[sort+1]);
	SetElement("Status",list[11]);
	SetElement("BaseUOMDR",list[12]);
	SetElement("BaseUOM",list[sort+2]);
	SetElement("ManuFactoryDR",list[13]);
	SetElement("ManuFactory",list[sort+3]);
	SetElement("Model",list[14]);
	SetElement("ProviderDR",list[15]);
	SetElement("Provider",list[sort+4]);
	SetElement("Stock",list[16]);
	SetElement("StartDate",list[18]);
	SetElement("DisuseDate",list[19]);
	SetElement("InType",list[21]);
	SetElement("InSourceID",list[22]);
	SetElement("ToType",list[23]);
	SetElement("ToSourceID",list[24]);
	SetElement("StdSPrice",list[sort+11]);
	SetElement("PlaceOfProduction",list[sort+21]);
	SetElement("GeneralName",list[sort+22]);
	SetElement("CommercialName",list[sort+23]);  //modify BY:GBX  2014-9-15 11:49:42
	SetElement("RegisterNo",list[sort+26]);
	SetElement("ProductionLicence",list[sort+28]);  //modify BY:GBX 2014-9-15 17:59:58
	SetElement("PakageType",list[sort+32]);
	SetChkElement("ExpiredFlag",list[sort+36]);
	SetElement("ExpiredDays",list[sort+37]);
	SetElement("WarningDays",list[sort+38]);
	SetElement("TypeDR",list[sort+18]); ///配件类组
	SetElement("Type",list[sort+97]);
	SetChkElement("BatchFlag",list[sort+95]);  ///是否批号管理
	SetChkElement("SerialFlag",list[sort+94]);  ///是否序列号管理
	SetElement("Location",list[27]);
	SetElement("BillPage",list[28]);
}

document.body.onload = BodyLoadHandler;