var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI����
var rowid=0;

//add by QW 2018-10-11 hisui���죺���ط�ҳ������
function BodyLoadHandler() 
{
	$("#tDHCEQEquipServiceFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   

}
///ѡ�����д����˷���
///Modify By QW 2018-10-11 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
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

//����ҳ����ط���
document.body.onload = BodyLoadHandler;