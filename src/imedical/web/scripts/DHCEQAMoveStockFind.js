/// DHCEQAMoveStockFind.js
function BodyLoadHandler()
{
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"));
	SetTableRow();
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
}
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
		var truthBeTold = window.confirm("将对当前列表 "+count+" 张出库单进行批量处理,确定执行吗?");
    	if (truthBeTold)
    	{
			var encmeth=GetElementValue("Execute")
			if (encmeth=="") return;
			var Rtn=cspRunServerMethod(encmeth,valRowIDs);
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
	}
	else
	{	alertShow("无待操作的出库单!");	}
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
document.body.onload = BodyLoadHandler;