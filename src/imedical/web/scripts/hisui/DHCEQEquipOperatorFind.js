var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
var rowid=0;
//add by QW 2018-10-11 hisui���죺���ط�ҳ������
function BodyLoadHandler() 
{
	$("#tDHCEQEquipOperatorFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});

}
///ѡ�����д����˷���
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
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
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
