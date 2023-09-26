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
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	InitButton(false);
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	if (GetElementValue("Status")=="2")
	{
		DisableBElement("BSubmit",isselected);
	}
	else
	{
		DisableBElement("BSubmit",!isselected);
	}
}
function BClose_Click()
{
	parent.close();
}
function BUpdate_Click() 
{
	if (CheckNull()) return;
	var val=CombinData();
	UpdateConfig(val,"0");
}
function BSubmit_Click() 
{
	if (CheckNull()) return;
	var val=GetSubmitValueList();
	UpdateConfig(val,"1");
}
function GetSubmitValueList()
{
	var ValueList=""
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+GetElementValue("Status");
	ValueList=ValueList+"^"+curUserID;
	return ValueList
}
function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["02"]);
    if (!truthBeTold) return;
    var val=GetSubmitValueList()
    UpdateConfig(val,"2");

}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("ConfigItemDR") ;
  	combindata=combindata+"^"+GetElementValue("Value") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+curUserID ;
  	/*combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;*/
  	return combindata;
}

function UpdateConfig(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var result=cspRunServerMethod(encmeth,'','',val,AppType);
	if (result>0)
	{	
		//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//****************************
		location.reload();	
	}
	else
	{	alertShow(t["01"]);}
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
	var objtbl=document.getElementById('tDHCEQConfig'); //得到表格   t+组件名称
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
		SetElement("Status","");
		SetElement("Unit","");
		InitButton(false);
		return;}
	FillData(selectrow);
	InitButton(true);
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=11
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("ConfigItemDR",list[1]);
	SetElement("ConfigItem",list[sort+1]);
	SetElement("Value",list[2]);
	SetElement("Remark",list[3]);
	SetElement("Status",list[4]);
	SetElement("Unit",list[sort+4]);
	/*SetElement("UpdateUserDR",list[5]);
	SetElement("UpdateUser",list[sort+2]);
	SetElement("UpdateDate",list[6]);
	SetElement("UpdateTime",list[7]);
	SetElement("AuditUserDR",list[8]);
	SetElement("AuditUser",list[sort+3]);
	SetElement("AuditDate",list[9]);
	SetElement("AuditTime",list[10]);*/
}
function GetConfigItem(value)
{
	Return=value.split("^");
	SetElement("ConfigItemDR",Return[1]);
	SetElement("Unit",Return[2]);
}
document.body.onload = BodyLoadHandler;
