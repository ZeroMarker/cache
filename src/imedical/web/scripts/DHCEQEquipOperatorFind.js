var SelectedRow = 0;
var rowid=0;

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQEquipOperatorFind');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		SelectedRow=0;
		parent.DHCEQEquipServiceFind.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipServiceFind"
		parent.DHCEQUseRecord.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord"
		SetElement("EquipDR","")
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TEquipDRz"+SelectedRow);
		parent.DHCEQEquipServiceFind.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipServiceFind&EquipDR="+rowid
		parent.DHCEQUseRecord.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+rowid
		SetElement("EquipDR",rowid)
		}
}

