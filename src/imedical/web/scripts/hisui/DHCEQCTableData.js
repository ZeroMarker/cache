///Creator: zy 2011-07-19 ZY0074
///Description:��������������ά��
var SelectedRow = -1;  //modify by lmm 2018-10-11 hisui���죺��ʼ�к��޸�
var varTableDR=""; //����id

function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
	$("#tDHCEQCTableData").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //add by lmm 2018-09-26 hisui���죺���ط�ҳ������
}
///modify by lmm 2018-10-11 hisui���죺����к�����¼��޸�
function SelectRowHandler(selectrow,rowdata)	
{
	
	var lnk=""
	if (SelectedRow==selectrow)	
	{	
		SelectedRow=-1;
		varTableDR=""
		lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColumns"
		$('#tDHCEQCTableData').datagrid('unselectAll');  //hisui����:ȡ��ѡ�� add by lmm 2018-10-10
	}
	else
	{
		SelectedRow=selectrow;		
		varTableDR=rowdata.TRowID;
		lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColumns&TableDR="+(varTableDR);
	}
	parent.DHCEQCColumns.location.href=lnk;
}
document.body.style.padding="10px 5px 10px 10px" //add by lmm 2019-01-18
document.body.onload = BodyLoadHandler;