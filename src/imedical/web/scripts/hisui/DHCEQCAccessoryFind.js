var SelectedRow = -1; //hly 20190213
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	KeyUp("Type^Cat");	//modify by wl 2020-02-17 WL0047 调整初始化的位置
	Muilt_LookUp("Type^Cat");
	InitUserInfo();
	InitEvent();	//初始化
	// Mozy003003	1246525		2020-3-27	注释initButtonWidth()和InitButton()
	//initButtonWidth(); 
	//InitButton();	//add by sjh 2019-11-06 hisui改造，初始化按钮宽度 BUG00017    
	ChangeStatus(false);
	//SetTableRow();		//Mozy	914720	2019-5-27	注释旧版双击事件并新建新事件方法
	initButtonWidth()  		//hisui改造 Mozy		2019-10-18
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
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

//hly add 20190225
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExtendCode="+GetElementValue("ExtendCode");
	val=val+"&TypeDR="+GetElementValue("TypeDR");
	val=val+"&CatDR="+GetElementValue("CatDR");
	//Mozy	914720	2019-5-27
	val=val+"&Type="+GetElementValue("Type");
	val=val+"&Cat="+GetElementValue("Cat");
	val=val+"&CurBPrice="+GetElementValue("CurBPrice");
	val=val+"&CurBPriceTo="+GetElementValue("CurBPriceTo");
	val=val+"&ShortDesc="+GetElementValue("ShortDesc");
	val=val+"&Model="+GetElementValue("Model");
	if(GetElementValue("SortFlag"))
	{
		val=val+"&SortFlag=1";
	}
	val=val+"&CheckPrice="+GetElementValue("CheckPrice");	// MZY0031	1355251,1355265		2020-06-08
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessoryFind"+val;	
}

function BAdd_Click()
{
	//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory'
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory";
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=270,top=150');
	showWindow(str,"配件项","","10row","icon-w-paper","modal","","","middle",refreshWindowNew);	 //modify by lmm 2020-06-05 UI
}

function BDelete_Click()
{
	messageShow("confirm","","",t["-4003"],"",ConfirmOpt,DisConfirmOpt);	// Mozy003006		2020-04-03
}
// Mozy003006		2020-04-03
function ConfirmOpt()
{
    rowid=GetElementValue("RowID");
	if (rowid=="") return
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t["01"]);
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) { window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessoryFind";}
}
function DisConfirmOpt()
{
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
//hly 20190215
function SelectRowHandler(rowIndex,rowData)
{
	/*var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCAccessoryFind');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;*/
	//if (!selectrow)	 return;
	//alertShow($('#SortFlag').attr("true"))
	if (SelectedRow==rowIndex)
	{
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		ChangeStatus(false);
	}
	else{
		SelectedRow=rowIndex;
		//rowid=GetElementValue("TRowIDz"+SelectedRow);
		rowid=rowData.TRowID;
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
	// MZY0029	1340070		2020-05-29
	if (GetElementValue("CheckPrice")==1)
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCopy",true);
		DisableBElement("BAdd",true);
	}
	else
	{
		InitEvent();
		DisableBElement("BUpdate",!Value);
		DisableBElement("BDelete",!Value);
		DisableBElement("BCopy",!Value);
		DisableBElement("BAdd",Value);
	}
}
//Mozy	914720	2019-5-27	注释旧版双击事件并新建新事件方法
/*function SetTableRow()
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
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&RowID="+GetElementValue("TRowIDz"+selectrow); //hly 20190213
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=10');
}*/
function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.TRowID>0)
	{
		// MZY0029	1340070		2020-05-29	增加传递审核标识参数CheckPrice
		var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&RowID="+rowData.TRowID+"&CheckPrice="+GetElementValue("CheckPrice");
		//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=300,left=100,top=10');
		showWindow(str,"配件项","","10row","icon-w-paper","modal","","","middle",refreshWindowNew);	 //modify by lmm 2020-06-05 UI
	}
}
function BCopy_Click()
{
	var row = $('#tDHCEQCAccessoryFind').datagrid('getSelected');//hly add 20190225
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCAccessory&AccessoryInfo=1&RowID="+row.TRowID; //hly 20190225
	
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=270,top=150');
	showWindow(str,"配件项","","10row","icon-w-paper","modal","","","middle",refreshWindowNew);	 //modify by lmm 2020-06-05 UI
}
// Mozy003010	1268133		2020-04-13
function refreshWindowNew()
{
	$("#tDHCEQCAccessoryFind").datagrid('reload');
}


//定义页面加载方法
document.body.onload = BodyLoadHandler;
