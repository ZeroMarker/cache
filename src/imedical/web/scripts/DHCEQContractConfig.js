var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitPage();
	InitUserInfo();
	KeyUp("ConfigItem");
	Muilt_LookUp("ConfigItem");
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
  	combindata=combindata+"^"+GetElementValue("ConfigItemDR") ;
  	combindata=combindata+"^"+GetElementValue("Value") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	/*combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;*/
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
	if (CheckItemNull(1,"ConfigItem")) return true;
	if (CheckItemNull(2,"Value")) return true;
	*/
	return false;
}
function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQContractConfig'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow)
	{
		SelectedRow=0
		SetElement("RowID","");
		SetElement("ConfigItemDR","");
		SetElement("ConfigItem","");
		SetElement("Value","");
		SetElement("Remark","");
		SetElement("Unit","");
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
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=7
	//SetElement("ContractListDR",list[0]);
	//SetElement("ContractList",list[sort+0]);
	SetElement("ConfigItemDR",list[1]);
	SetElement("ConfigItem",list[sort+1]);
	SetElement("Value",list[2]);
	SetElement("Remark",list[3]);
	/*SetElement("UpdateUserDR",list[4]);
	SetElement("UpdateUser",list[sort+2]);
	SetElement("UpdateDate",list[5]);
	SetElement("UpdateTime",list[6]);*/
	SetElement("Unit",list[sort+3]);
}
function GetConfigItem(value)
{
	Return=value.split("^");
	SetElement("ConfigItemDR",Return[1]);
	SetElement("Unit",Return[2]);
}
document.body.onload = BodyLoadHandler;
