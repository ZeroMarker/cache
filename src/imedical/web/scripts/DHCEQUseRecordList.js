var SelectedRow = 0;
var rowid=0;

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQUseRecordList');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow)	 return;
	
	if (SelectedRow==selectrow)	{
		SelectedRow=0;
		parent.DHCEQUseRecord.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord"
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		parent.DHCEQUseRecord.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&RowID="+rowid
		}
}
