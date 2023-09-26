var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;

//add by QW 2018-10-11 hisui改造：隐藏翻页条内容
function BodyLoadHandler() 
{
	$("#tDHCEQEquipServiceFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   

}
///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	var EquipDR=GetElementValue("EquipDR")	
	if(index==SelectedRow)
    {
		parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+EquipDR
		SetElement("ServiceDR","")
		SelectedRow=-1;	
		$('#tDHCEQEquipServiceFind').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	parent.DHCEQUseRecord.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecord&SourceIDDR="+EquipDR+"&ServiceItemDR="+rowdata.TServiceRowID
	SetElement("ServiceDR",rowdata.TServiceRowID)
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;