

function BodyLoadHandler() 
{	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	FillData();
}
function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	KeyUp("BuyRequest^Model^ManuFac^EquipCat^PurposeType")
	Muilt_LookUp("BuyRequest^Model^ManuFac^EquipCat^PurposeType");
	
	var obj=document.getElementById("Name")
	if (obj) obj.onchange=clear;
	var obj=document.getElementById("PriceFee");
	if (obj) obj.onchange=SetTotal;
	var obj=document.getElementById("QuantityNum");
	if (obj) obj.onchange=SetTotal;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquiCat_Click;
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
function SetTotal()
{
	var PriceFee=GetElementValue("PriceFee")
	var QuantityNum=GetElementValue("QuantityNum")
	SetElement("TotalFee",PriceFee*QuantityNum)
}
function clear()
{
	SetElement("BuyRequestListDR","");
	SetElement("ItemDR","")
	/*SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("ManuFacDR","");
	SetElement("ManuFac","");
	SetElement("QuantityNum","");
	SetElement("PriceFee","");
	SetElement("TotalFee","");
	SetChkElement("TestFlag","0");*/
}
function BClose_Click() 
{
	parent.close();
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
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")
	{
		Fill("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
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
	var sort=25
	//SetElement("BuyPlanDR",list[0]);
	SetElement("BuyPlan",list[sort+0]);
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
	SetElement("BuyRequestListDR",list[9]);
	SetElement("BuyRequestList",list[sort+3]);
	SetElement("ContractDR",list[10]);
	SetElement("Contract",list[sort+4]);
	SetElement("UpdateUserDR",list[11]);
	SetElement("UpdateUser",list[sort+5]);
	SetElement("UpdateDate",list[12]);
	SetElement("UpdateTime",list[13]);
	SetElement("CurrencyDR",list[14]);
	SetElement("Currency",list[sort+6]);
	SetElement("EquipCatDR",list[15]);
	SetElement("EquipCat",list[sort+7]);
	//SetElement("Hold1",list[16]);
	SetElement("ArriveNum",list[16]);
	SetElement("ItemDR",list[17]);
	//SetElement("PurchaseType",list[sort+8]);
	SetElement("ArriveDate",list[18]);
	//SetElement("PurposeTypeDR",list[19]);
	SetElement("Hold3",list[19]);
	SetElement("PurposeType",list[sort+8]);
	SetChkElement("RefuseFlag",list[20]);
	SetElement("RefuseReason",list[21]);
	SetElement("BuyRequestDR",list[sort+9]);
	SetElement("BuyRequest",list[sort+10]);
	
	SetElement("Hold1",list[23]);
	SetElement("Hold2",list[24]);
	SetElement("Hold1Desc",list[sort+11]);
	
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
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
	SetBStatus();
}
function SetBuyPlan()
{
	var BuyPlanDR=GetElementValue("BuyPlanDR");
	var encemeth=GetElementValue("getFeeNum");
	var Return=cspRunServerMethod(encemeth,"","",BuyPlanDR,2);
	var ReturnList=Return.split("^");
	var obj=parent.opener.document.getElementById("TotalFee");
	if (obj) obj.value=ReturnList[0];
	var obj=parent.opener.document.getElementById("QuantityNum");
	if (obj) obj.value=ReturnList[1];
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("BuyPlanDR") ;
  	combindata=combindata+"^"+GetElementValue("Name") ;
  	combindata=combindata+"^"+GetElementValue("ModelDR") ;
  	combindata=combindata+"^"+GetElementValue("ManuFacDR") ;
  	combindata=combindata+"^"+GetChkElementValue("TestFlag") ;
  	combindata=combindata+"^"+GetElementValue("PriceFee") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("TotalFee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("BuyRequestListDR") ;
  	combindata=combindata+"^"+GetElementValue("ContractDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipCatDR") ;
  	//combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("ArriveNum") ;
  	
  	combindata=combindata+"^"+GetElementValue("ItemDR") ;
  	combindata=combindata+"^"+GetElementValue("ArriveDate") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;//PurposeTypeDR
  	combindata=combindata+"^"+GetChkElementValue("RefuseFlag") ;
  	combindata=combindata+"^"+GetElementValue("RefuseReason") ;
  	
  	combindata=combindata+"^" ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	
  	user=curUserID;
	var Return=cspRunServerMethod(encmeth,"","",combindata,AppType,user);
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		SetBuyPlan();
		var BuyPlanDR=GetElementValue("BuyPlanDR")
		window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanItemEdit&RowID=&BuyPlanDR='+BuyPlanDR;
		parent.frames["DHCEQBuyPlanItem"].location.reload();
			
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	if (CheckItemNull(2,"BuyRequestListDR","²É¹ºÉêÇëÃ÷Ï¸")) return true;
	/*
	if (CheckItemNull(1,"BuyRequest")) return true;
	if (CheckItemNull(2,"BuyRequestListDR","²É¹ºÉêÇëÃ÷Ï¸")) return true;
	if (CheckItemNull(2,"QuantityNum")) return true;
	*/
	return false;
}
function GetEquipCat(Value)
{
	GetLookUpID("EquipCatDR",Value);
}
function GetPurposeType(Value)
{
	GetLookUpID("PurposeTypeDR",Value);
}
function GetBuyRequest(Value)
{
	GetLookUpID("BuyRequestDR",Value);
}
function GetModel(Value)
{
	GetLookUpID("ModelDR",Value);
}
function GetManuFac(Value)
{
	GetLookUpID("ManuFacDR",Value);
}
function GetOtherValue(Value)
{
	var ReturnList=Value.split("^");
	if (GetBuyPlanDR(ReturnList[1]).length>0)
	{
		SetElement("Name","");
		alertShow(t["03"]);
	}
	else
	{
		SetElement("BuyRequestListDR",ReturnList[1]);
		SetOtherValue(ReturnList[1]);
	}
	
}
function SetOtherValue(BuyRequestListDR)
{
	var encmeth=GetElementValue("getBRListDetail");
	var Return=cspRunServerMethod(encmeth,"","",BuyRequestListDR);
	ReturnList=Return.split("^");
	SetElement("ModelDR",ReturnList[0]);
	SetElement("Model",ReturnList[1]);
	SetElement("ManuFacDR",ReturnList[2]);
	SetElement("ManuFac",ReturnList[3]);
	SetElement("QuantityNum",ReturnList[4]);
	SetElement("PriceFee",ReturnList[5]);
	SetElement("TotalFee",ReturnList[6]);
	if (ReturnList[7]=="Y")
	{
		ReturnList[7]="1";
	}
	else
	{
		ReturnList[7]="0";
	}
	SetChkElement("TestFlag",ReturnList[7]);
	SetElement("CurrencyDR",ReturnList[8]);
	SetElement("EquipCatDR",ReturnList[9]);
	SetElement("EquipCat",ReturnList[10]);
	SetElement("Hold1",ReturnList[11]);
	SetElement("ItemDR",ReturnList[12]);
	SetElement("ArriveDate",ReturnList[13]);
	SetElement("PurposeTypeDR",ReturnList[14]);
	SetElement("PurposeType",ReturnList[15]);
	
	SetElement("Hold2",ReturnList[11]);
	SetElement("Hold3",ReturnList[11]);
	SetElement("Hold1Desc",ReturnList[11]);
}
function GetBuyPlanDR(BuyRequestListDR)
{
	var encmeth=GetElementValue("getBuyPlanDR");
	return cspRunServerMethod(encmeth,"","",BuyRequestListDR);
}

function BodyUnLoadHandler()
{
	parent.opener.parent.frames["DHCEQBuyPlanItem"].location.reload();
}

function GetProvider (value)
{
	var val=value.split("^");
	SetElement("Hold1",val[1]);
}

document.body.onload = BodyLoadHandler;
parent.document.body.onunload = BodyUnLoadHandler;