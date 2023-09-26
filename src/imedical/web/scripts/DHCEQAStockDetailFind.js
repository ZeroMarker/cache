function BodyLoadHandler()
{
	var objtbl=document.getElementById('tDHCEQAStockDetailFind');
	var rows=objtbl.rows.length;
	///var gbx=GetElementValue("TRowIDz1")
	if ((GetElementValue("TRowIDz1")<1))
	{
		DisableBElement("TDetailz1",true);
	}
	var lastrowindex=rows - 1;
	if (lastrowindex>0)
	{
		if (GetElementValue("TRowIDz"+lastrowindex)<1)
		{
			DisableBElement("TDetailz"+lastrowindex,true);
		}
	}	
	InitPage();
	SetStatus();
	Muilt_LookUp("Loc^AccessoryType");
	HiddenTableIcon("DHCEQAStockDetailFind","TRowID","TDetail");
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
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAStockDetailFind");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAStockDetailFind");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAccessory&RowID="+GetElementValue("TRowIDz"+selectrow);
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	//window.location.href=str;
}
document.body.onload = BodyLoadHandler;