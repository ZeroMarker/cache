var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	RowidLink();//rowid连接
}
function RowidLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQDepreSetList');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TDetailz'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//调用
		SelRowObj.href="#";
	//parent.frames["DHCEQDepreSetList"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetList&EquipNameDR='+EquipNameDR+'&DepreMethodDR='+DepreMethodDR;
		}	
	}
}
function lnk_Click()
{
	var eSrc=websys_getSrcElement(e);	
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc)
	var row=GetRowByColName(eSrc.id);//调用
	 var TRowID=GetElementValue("TRowIDz"+row);
 	var TEquipDR=GetElementValue("TEquipDRz"+row);
	var lnk='dhceqdepreset.csp?EquipDR='+TEquipDR+'&TRowID='+TRowID;
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDepreSetList');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		parent.frames["DHCEQDepreSet"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet'
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		return;
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		var TEquipDR=GetElementValue("TEquipDRz"+SelectedRow)
		parent.frames["DHCEQDepreSet"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet&RowID='+rowid;
		return;
		//var lnk='DHCEQDepreSet.csp?EquipDR='+TEquipDR+'&TRowID='+rowid;
	//window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
		}
}
document.body.onload = BodyLoadHandler;