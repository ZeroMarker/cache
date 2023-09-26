var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Type^Cat");	//清空选择
	Muilt_LookUp("Type^Cat");
	ChangeStatus(false);
	SetTableRow();		//双击事件设置
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BCopy");
	if (obj) obj.onclick=BCopy_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function BAdd_Click()
{
	//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory'
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory";
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=10');
}

function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	if (rowid=="") return
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t["01"])
	return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	//需求序号:	400167		Mozy	20170710
	if (result>0) { window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessoryFind";}
}

function BClear_Click()
{
	SetElement("Code","")
	SetElement("Desc","")
	SetElement("ExtendCode","")
	SetElement("Cat","")
	SetElement("CatDR","")
	SetElement("Type","")
	SetElement("TypeDR","")
	SetElement("CurBPrice","")
	SetElement("CurBPriceTo","")
}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCAccessoryFind');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		ChangeStatus(false);
	}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid)
		ChangeStatus(true);
	}
}

function GetAccessoryCat(value)
{
	GetLookUpID("CatDR",value);
}
function GetAccessoryType(value)
{
	GetLookUpID("TypeDR",value);
}

function ChangeStatus(Value)
{
	InitEvent();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BCopy",!Value);
	DisableBElement("BAdd",Value);
}
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQCAccessoryFind");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQCAccessoryFind");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&RowID="+GetElementValue("TRowIDz"+selectrow);
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=10');
}
function BCopy_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&AccessoryInfo=1&RowID="+GetElementValue("TRowIDz"+SelectedRow);
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=10');
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
