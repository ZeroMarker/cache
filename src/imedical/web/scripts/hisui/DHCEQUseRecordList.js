var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;

///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
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
