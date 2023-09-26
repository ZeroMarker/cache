var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;
//add by QW 2018-10-11 hisui改造：隐藏翻页条内容
function BodyLoadHandler() 
{
	$("#tDHCEQEquipOperatorFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});

}
///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		parent.DHCEQEquipServiceFind.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipServiceFind"
		parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord"
		SelectedRow=-1;	
		SetElement("EquipDR","")
		$('#tDHCEQEquipOperatorFind').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	parent.DHCEQEquipServiceFind.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipServiceFind&EquipDR="+rowdata.TEquipDR
	parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+rowdata.TEquipDR
	SetElement("EquipDR",rowdata.TEquipDR)
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
