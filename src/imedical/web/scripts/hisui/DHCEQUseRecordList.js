var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
var rowid=0;

///ѡ�����д����˷���
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
	    SelectedRow=-1;	
		parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord"
		$('#tDHCEQUseRecordList').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&RowID="+rowdata.TRowID

}
