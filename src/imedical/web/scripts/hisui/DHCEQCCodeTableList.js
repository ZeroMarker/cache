var SelectedRow = -1;   //modify by lmm 2018-09-02 hisui���죺�޸���亯����ʼ�к�
var varTabName=""; //����
var varTabNameStr=""; //����
var varPreFix="";  //ǰ׺
var varType="";    //����
var varReadOnly="";//ֻ��

function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
	$("#tDHCEQCCodeTableList").datagrid({showRefresh:false,showPageList:false,displayMsg:''});   //add by lmm 2019-02-19 hisui���죺���ط�ҳ������
}
///modify by lmm 2018-09-02
///����������������¼�
///��Σ�index �к�
///      rowData ѡ����json�¼�
function SelectRowHandler(index,rowData)	{
	Selected(index,rowData);
}
function Selected(selectrow,rowData)
{	
	if (SelectedRow==selectrow)	{			
		SelectedRow=-1;  //modify by lmm 2018-09-02 hisui���죺�޸Ŀ�ʼ�к�
		varTabName="";
		varPreFix=""	
		varType="1";
		varReadOnly="";
		parent.DHCEQCCodeTable.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable"  //modify by lmm 2018-09-02 hisui���죺�޸�hisuiĬ��csp   modify hly 20190801

		//SetData();			
		}
	else{
		SelectedRow=selectrow;		
		varTabNameStr=rowData.TCodeDesc;
		varTabName=rowData.TCodeName;		
		varPreFix=rowData.TShortDesc;
		varType=rowData.TType;
		varReadOnly=rowData.TReadOnly;
		SetData();		
		}		
}
function SetData()	{
	if(varType=="1")
	{
		//��׼�����
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable&TabName="+(varTabName)+"&PreFix="+(varPreFix)+"&ReadOnly="+(varReadOnly)+"&titleName="+(varTabNameStr); //modify by lmm 2018-09-02 hisui���죺�޸�hisuiĬ��csp
		parent.DHCEQCCodeTable.location.href=lnk;
	}
	else
	{
		var value=varTabName.split("_")
		if(value.length>2)
		{
			alertShow('������ı���,��������Χ!');
			return;
		}
		if(varType=="2")
		{
			//�Ǳ�׼�����				
			parent.DHCEQCCodeTable.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=" + value[0] + value[1]+"&ReadOnly="+(varReadOnly);  //modify by lmm 2018-09-02 hisui���죺�޸�hisuiĬ��csp
			
		}
		else
		{
			//csp page
			var varUrl=value[0] + value[1]+".csp?ReadOnly="+(varReadOnly);
			parent.DHCEQCCodeTable.location.href=varUrl;
		}
	}
}
document.body.style.padding="10px 5px 10px 10px" ////modify by lmm 2019-02-19 829712
document.body.onload = BodyLoadHandler;