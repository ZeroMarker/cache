var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitPage();
	InitUserInfo();
	KeyUp("Affix^AffixCat^ManuFactory^Receiver^Currency")
	Muilt_LookUp("Affix^AffixCat^ManuFactory^Receiver^Currency");
}


function InitPage()
{
	InitButton();
	SetBEnble();
}

function InitButton()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
}
function SetBEnble()
{
	DisableBElement("BUpdate",true);
	DisableBElement("BDelete",true);
	var Status=GetElementValue("Status")
	if (Status!="0") DisableBElement("BAdd",true);
}
function BClose_Click()
{
	window.close();
}
function BUpdate_Click() 
{
	if (CheckNull()) return;
	var val=CombinData();
	UpdateConfig(val,"0");
}
function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["02"]);
    if (!truthBeTold) return;
   UpdateConfig("","2");

}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("ContractListDR") ;
  	combindata=combindata+"^"+GetElementValue("AffixDR") ;
  	combindata=combindata+"^"+GetElementValue("AffixCatDR") ;
  	combindata=combindata+"^"+GetElementValue("PartSpec") ;
  	combindata=combindata+"^"+GetElementValue("PartModel") ;
  	combindata=combindata+"^"+GetElementValue("ManuFactoryDR") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("ReceiverDR") ;
  	combindata=combindata+"^"+GetElementValue("LeaveFacNo") ;
  	combindata=combindata+"^"+GetElementValue("LeaveDate") ;
  	combindata=combindata+"^"+GetElementValue("PriceFee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
  	return combindata;
}

function UpdateConfig(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var RowID=GetElementValue("RowID");
	val=RowID+"^"+val
	var result=cspRunServerMethod(encmeth,val,AppType);
	if (result>0)
	{	location.reload();	}
	else
	{	alertShow(result+" "+t["01"]);}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Affix")) return true;
	if (CheckItemNull(1,"AffixCat")) return true;
	if (CheckItemNull(2,"PriceFee")) return true;
	if (CheckItemNull(2,"QuantityNum")) return true;
	*/
	return false;
}
function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQContractAffix'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow)
	{
		SelectedRow=0
		fill("^^^^^^^^^^^^^^^^^^^^^^^^^^^")
		InitButton();
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		var Status=GetElementValue("Status");
		if (Status=="0") DisableBElement("BAdd",false);
		return;}
	FillData(selectrow);
	InitButton();
	DisableBElement("BAdd",true);
	var Status=GetElementValue("Status");
	if (Status=="0")
	{
		DisableBElement("BUpdate",false);
		DisableBElement("BDelete",false);
	}
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=GetElementValue("TRowIDz"+selectrow);
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	fill(ReturnList)
}
function fill(ReturnList)
{
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=13
	//SetElement("ContractListDR",list[0]);
	//SetElement("ContractList",list[sort+0]);
	SetElement("AffixDR",list[1]);
	SetElement("Affix",list[sort+1]);
	SetElement("AffixCatDR",list[2]);
	SetElement("AffixCat",list[sort+2]);
	SetElement("PartSpec",list[3]);
	SetElement("PartModel",list[4]);
	SetElement("ManuFactoryDR",list[5]);
	SetElement("ManuFactory",list[sort+3]);
	SetElement("QuantityNum",list[6]);
	SetElement("ReceiverDR",list[7]);
	SetElement("Receiver",list[sort+4]);
	SetElement("LeaveFacNo",list[8]);
	SetElement("LeaveDate",list[9]);
	SetElement("PriceFee",list[10]);
	SetElement("Remark",list[11]);
	SetElement("CurrencyDR",list[12]);
	SetElement("Currency",list[sort+5]);
}
function GetAffix (value)
{
    GetLookUpID("AffixDR",value);
}
function GetAffixCat (value)
{
    GetLookUpID("AffixCatDR",value);
}
function GetManuFactory (value)
{
    GetLookUpID("ManuFactoryDR",value);
}
function GetReceiver (value)
{
    GetLookUpID("ReceiverDR",value);
}
function GetCurrency (value)
{
    GetLookUpID("CurrencyDR",value);
}
document.body.onload = BodyLoadHandler;
