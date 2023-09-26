

function BodyLoadHandler() 
{	
	SetEvent();
	KeyUp("Model^ManuFac^EquipCat^PurposeType");
	Muilt_LookUp("Name^Model^ManuFac^EquipCat^PurposeType");
	ChangeStatus(false);
	InitUserInfo();
	FillData();
}


function SetEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	var obj=document.getElementById("BArgu"); //ÂÛÖ¤
	if (obj) obj.onclick=BArgu_Click;
	var obj=document.getElementById("PriceFee");
	if (obj) obj.onchange=SetTotal;
	var obj=document.getElementById("QuantityNum");
	if (obj) obj.onchange=SetTotal;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquiCat_Click;
	var obj=document.getElementById("Name");
	if (obj) obj.onchange=Name_Change;
}
function Name_Change()
{
	SetElement("ItemDR","")
}
function EquiCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
function BArgu_Click()
{
	
	var RowID=GetElementValue("RowID")
	if (RowID=="")
	{
		alertShow(t["03"]);
		return;
	}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQArgumentation&RowID='+GetElementValue("ArgumentationDR")+'&BuyRequestListDR='+RowID+'&Type=0'
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=930,height=650,left=120,top=0')
}

function SetTotal()
{
	var PriceFee=GetElementValue("PriceFee")
	var QuantityNum=GetElementValue("QuantityNum")
	SetElement("TotalFee",PriceFee*QuantityNum)
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")
	{
		Fill("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		ChangeStatus(false);
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList);
	ChangeStatus(true);
	
}
function Fill(ReturnList)
{
	list=ReturnList.split("^");
	var sort=21
	//SetElement("BuyRequestDR",list[0]);
	//SetElement("BuyRequest",list[sort+0]);
	SetElement("Name",list[1]);
	SetElement("ModelDR",list[2]);
	SetElement("Model",list[sort+1]);
	SetElement("ManuFacDR",list[3]);
	SetElement("ManuFac",list[sort+2]);
	SetChkElement("TestFlag",list[4]);
	SetElement("PriceFee",list[5]);
	SetElement("QuantityNum",list[6]);
	SetElement("TotalFee",list[7]);
	SetElement("Remark",list[8]);
	SetElement("UpdateUserDR",list[9]);
	SetElement("UpdateUser",list[sort+3]);
	SetElement("UpdateDate",list[10]);
	SetElement("UpdateTime",list[11]);
	SetElement("BuyPlanDR",list[12]);
	SetElement("BuyPlan",list[sort+4]);
	SetElement("CurrencyDR",list[13]);
	SetElement("Currency",list[sort+5]);
	SetElement("EquipCatDR",list[14]);
	SetElement("EquipCat",list[sort+6]);
	SetElement("Hold1",list[15]);
	SetElement("ItemDR",list[16]);
	SetElement("RequestReason",list[17]);
	SetElement("ArriveDate",list[18]);
	SetElement("ArgumentationDR",list[19]);
	SetElement("Argumentation",list[sort+7]);
	SetElement("PurposeTypeDR",list[20]);
	SetElement("PurposeType",list[sort+8]);
}
function SetBStatus()
{
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status!="0")
		{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);

		}
}
function ChangeStatus(Value)
{
	SetEvent();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
	SetBStatus();
}
function BClose_Click() 
{
	parent.close();
}
function SetBuyRequest()
{
	var BuyRequestDR=GetElementValue("BuyRequestDR");
	var encemeth=GetElementValue("getFeeNum");
	var Return=cspRunServerMethod(encemeth,"","",BuyRequestDR,2);
	var ReturnList=Return.split("^");
	var obj=parent.opener.document.getElementById("TotalFee");
	if (obj) obj.value=ReturnList[0];
	var obj=parent.opener.document.getElementById("QuantityNum");
	if (obj) obj.value=ReturnList[1];
}
function BAdd_Click() 
{
	if (CheckNull()) return;
	UpdateData("0");
}

function BUpdate_Click() 
{
	if (CheckNull()) return;
	UpdateData("1");
}

function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	UpdateData("2");
	
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("BuyRequestDR") ;
  	combindata=combindata+"^"+GetElementValue("Name") ;
  	combindata=combindata+"^"+GetElementValue("ModelDR") ;
  	combindata=combindata+"^"+GetElementValue("ManuFacDR") ;
  	combindata=combindata+"^"+GetChkElementValue("TestFlag") ;
  	combindata=combindata+"^"+GetElementValue("PriceFee") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("TotalFee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("BuyPlanDR") ;
  	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipCatDR") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("ItemDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestReason") ;
  	combindata=combindata+"^"+GetElementValue("ArriveDate") ;
  	combindata=combindata+"^"+GetElementValue("ArgumentationDR") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+GetElementValue("PurposeTypeDR")
	var Return=cspRunServerMethod(encmeth,"","",combindata,AppType);
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		SetBuyRequest();
		var BuyRequestDR=GetElementValue("BuyRequestDR")
		window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestItemEdit&RowID=&BuyRequestDR='+BuyRequestDR;
		parent.frames["DHCEQBuyRequestItem"].location.reload();
			
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"QuantityNum")) return true;
	if (CheckItemNull(2,"PriceFee")) return true;
	*/
	return false;
}
function GetModel (value)
{
    GetLookUpID("ModelDR",value);
}
function GetManuFac (value)
{
    GetLookUpID("ManuFacDR",value);
}
function GetEquipCat (value)
{ 
    GetLookUpID("EquipCatDR",value);
}
function GetPurposeType (value)
{ 
    GetLookUpID("PurposeTypeDR",value);
}
function GetMasterItem(value)
{
	var ReturnList=value.split("^")
	SetElement("ItemDR",ReturnList[1]);
	SetElement("EquipCatDR",ReturnList[3]);
	SetElement("EquipCat",ReturnList[4]);
	//SetElement("UnitDR",ReturnList[5]);
	//SetElement("Unit",ReturnList[6]);
}
function BodyUnLoadHandler()
{
	parent.opener.parent.frames["DHCEQBuyRequestItem"].location.reload();
}
document.body.onload = BodyLoadHandler;
parent.document.body.onunload = BodyUnLoadHandler;