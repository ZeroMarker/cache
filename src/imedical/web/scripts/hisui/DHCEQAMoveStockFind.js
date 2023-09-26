/// DHCEQAMoveStockFind.js
var tmpRowIDs="";	// Mozy003006		2020-04-03
function BodyLoadHandler()
{
	initButtonWidth();		/// Mozy		888605	2019-5-21	Hisui改造
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"));
	//SetTableRow();		/// Mozy		888605	2019-5-21	Hisui改造
	SetBackGroupColor('tDHCEQAMoveStockFind');
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"));
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc");
	Muilt_LookUp("FromLoc^ToLoc");
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	var obj=document.getElementById("BBatchOpt");
	if (obj) obj.onclick=BBatchOpt_Clicked;
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
	var obj=document.getElementById("BAdd");	// Mozy003003	1247088		2020-3-27	声明新增按钮点击事件
	if (obj) obj.onclick=BAdd_Clicked;
}
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAdd",true);
	}
}

/// 描述:修改设备转移类型的时候,给供给科室和接受科室传递不同的科室类型参数
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value=="0")
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}else if (value=="3")
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}else
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0102");
	}
}
/*// Mozy		888605	2019-5-21	Hisui改造
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAMoveStockFind");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAMoveStockFind");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID="+GetElementValue("TRowIDz"+selectrow)+"&CurRole="+GetElementValue("ApproveRole")+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD")+"&QXType="+GetElementValue("QXType");
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	window.location.href=str;
}*/
function BBatchOpt_Clicked()
{
	var count=0;
	var valRowIDs="";
	var objtbl=document.getElementById("tDHCEQAMoveStockFind");
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var id=GetElementValue("TRowIDz"+i);
		var Chk=GetChkElementValue("TChkz"+i);
		if ((Chk)&&(id!="")&&(GetElementValue("TMoveTypez"+i)=="出库"))
		{
			count=count+1;
			if (valRowIDs!="") valRowIDs=valRowIDs+",";
			valRowIDs=valRowIDs+GetElementValue("TRowIDz"+i);
		}
	}
	if (valRowIDs=="")
	{
		alertShow("未选择有效打印行.");
		return;
	}
	//alertShow(valRowIDs)
	if (count>0)
	{
		// Mozy003006		2020-04-03
		tmpRowIDs=valRowIDs;
		messageShow("confirm","","","将对当前列表 "+count+" 张出库单进行批量处理,确定执行吗?","",ConfirmOpt,DisConfirmOpt);
	}
	else
	{	alertShow("无待操作的出库单!");	}
}
// Mozy003006		2020-04-03
function ConfirmOpt()
{
	var encmeth=GetElementValue("Execute")
	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,tmpRowIDs);
	if (Rtn>0)
	{
		 alertShow("执行成功!")
		 location.reload();
	}
	else
	{
		alertShow("执行失败!")
	}
}
function DisConfirmOpt()
{
}
function SelectAll_Clicked()
{
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tDHCEQAMoveStockFind');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		if (GetElementValue("TMoveTypez"+i)=="出库")
		{
			var selobj=document.getElementById('TChkz'+i);
			selobj.checked=obj.checked;
		}
	}
}
// Mozy0229		2019-10-28
function BAdd_Clicked()
{
	var url="dhceq.mp.storemove.csp?"+"&Type="+GetElementValue("Type")+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD");
	showWindow(url,"配件转移单","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
document.body.onload = BodyLoadHandler;