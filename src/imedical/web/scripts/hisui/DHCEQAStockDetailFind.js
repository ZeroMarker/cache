//add by wjt 2019-03-08
//modified by wl 2019-10-12 hisui改造
function BodyLoadHandler()
{	
	InitPage();
	SetStatus();
	Muilt_LookUp("Loc^AccessoryType");
	HiddenTableIcon("DHCEQAStockDetailFind","TRowID","TDetail");
	initButtonWidth();           //增加初始化按钮方法   
	SetTableRow();
		
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
function InitPage()
{
	KeyUp("Loc^AccessoryType");
	ClearDR();
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}
//add by: GBX 2014-8-21 21:42:36
function GetAccessoryType (value)
{
    GetLookUpID("AccessoryTypeDR",value);
}

function GetAccessoryLookUpID(ename,value)
{
	var val=value.split("^");
	var obj=document.getElementById(ename);
	if (obj)	{	obj.value=val[2];}
	else {alertShow(ename);}		
}
function ClearDR()
{
	var AccessoryType=GetElementValue("AccessoryType");
	var Loc=GetElementValue("Loc");
	if (AccessoryType=="")
	{
		SetElement("AccessoryTypeDR","");
	}
	if (Loc=="")
	{
		SetElement("LocDR","");
	}
}

function SelectRowHandler(rowIndex,rowData)
{
	if (SelectedRow==rowIndex)
	{
		SelectedRow=-1;
		rowid=0;
		setElement("RowID","");
	}
	else{
		SelectedRow=rowIndex;
		rowid=rowData.TRowID;
		setElement("RowID",rowid)
	}
}

function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.TRowID>0)
	{
		var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAccessory&RowID="+rowData.TRowID;
		showWindow(str,"配件项","","10row","icon-w-paper","modal","","","middle",refreshWindow);	
	}
}
document.body.onload = BodyLoadHandler;