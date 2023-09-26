var SelectedRow = 0;
var rowid=0;

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQEquipServiceFind');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	var EquipDR=GetElementValue("EquipDR")
	if (!selectrow)	 return;
	
	if (SelectedRow==selectrow)	{
		SelectedRow=0;
		parent.DHCEQUseRecord.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+EquipDR
		SetElement("ServiceDR","")
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TServiceRowIDz"+SelectedRow);
		parent.DHCEQUseRecord.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+EquipDR+"&ServiceItemDR="+rowid
		SetElement("ServiceDR",rowid)
		}
}

