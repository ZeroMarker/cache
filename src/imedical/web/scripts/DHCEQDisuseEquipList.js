/// Modified By JDL 2011-12-13 JDL0104
/// 重写该js内容
/// -------------------------------
/// 创    建:ZY  2009-08-16  No.ZY0009
/// 修改描述:批量报废设备明细
/// --------------------------------

var SelectedRow = 0;
function BodyLoadHandler() 
{
	InitPage();
}
function InitPage()
{
	var Status=GetElementValue("Status");
	if ((Status==0)||(Status==""))
	{	
		var obj=document.getElementById("BUpdate");
		if (obj) obj.onclick=BUpdate_Clicked;
		var obj=document.getElementById("SelectAll");
		if (obj) obj.onclick=SelectAll_Clicked;
	}
	else
	{
		DisableBElement("BUpdate",true)
		DisableBElement("SelectAll",true)
	}
}

function BUpdate_Clicked()
{
	var valRowIDs=GetElementValue("RowIDs");
	
	var objtbl=document.getElementById('tDHCEQDisuseEquipList');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i);
		if (GetChkElementValue("Selectz"+i)==true)
		{
			valRowIDs=AddIDToIDs(valRowIDs,TRowID,",");
		}
		else
		{
			valRowIDs=RemoveIDFromIDs(valRowIDs,TRowID,",");
		}
	}
	if (valRowIDs=="")
	{
		alertShow("请选择要报废的设备!");
		return;
	}
	
	SetElement("RowIDs", valRowIDs);
	
	var encmeth=GetElementValue("GetEquipNoAndLeaveFactoryNo");
	var rtn=cspRunServerMethod(encmeth,"","",valRowIDs);
	var list=rtn.split("^")

	var SelectRow=GetElementValue("SelectRow");
	var qty=valRowIDs.split(",").length;
	opener.SetEquipIDs(valRowIDs,list[1],list[0],qty,SelectRow)
	
	var lnk=window.location.href;
	var index=lnk.indexOf("&RowIDs=")
	if (index>0) lnk=lnk.substring(0,index);
	lnk=lnk+"&RowIDs="+valRowIDs
	window.location.href=lnk
}

function SelectAll_Clicked()
{
	var valRowIDs=GetElementValue("RowIDs");
	var SelectValue=GetElementValue("SelectAll");
	var Objtbl=document.getElementById('tDHCEQDisuseEquipList');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i);
		SetElement('Selectz'+i,SelectValue);
		if (SelectValue==true)
		{			
			valRowIDs=AddIDToIDs(valRowIDs,TRowID,",");
		}
		else
		{
			valRowIDs=RemoveIDFromIDs(valRowIDs,TRowID,",");
		}
	}	
	SetElement("RowIDs", valRowIDs);
}

document.body.onload = BodyLoadHandler;

