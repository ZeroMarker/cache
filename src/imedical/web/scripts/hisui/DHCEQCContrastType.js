var SelectedRow = -1; //hisui���� add by zc 2018-08-31
var varRowID=""; //ID
var varTypeCode=""; //����

function BodyLoadHandler() 
{
	$("#tDHCEQCContrastType").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //add by lmm 2018-09-26 hisui���죺���ط�ҳ������
	//document.body.scroll="no";
	InitUserInfo();
}
function SelectRowHandler(index,rowdata){
	
	Selected(index , rowdata);
	
}
function Selected(selectrow, rowdata)
{	
	if (SelectedRow==selectrow)
	{		
		SelectedRow=-1; //hisui���� add by zc 2018-08-31
		varRowID="";
		varTypeCode="";
		parent.DHCEQCContrastInfo.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo";	//hisui���� add by zc 2018-08-31
	
		$('#tDHCEQCContrastType').datagrid('unselectAll');  //hisui���� add by zc 2018-08-31
	}
	else
	{
		SelectedRow=selectrow;
		varRowID=rowdata.TRowID; //hisui���� add by zc 2018-08-31
		varDataType=rowdata.TDataType;	 //hisui���� add by zc 2018-08-31	

		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo&DataType="+varDataType+"&ContrastTypeDR="+varRowID;
		//alertShow("lnk="+lnk);
		parent.DHCEQCContrastInfo.location.href=lnk;
		//parent.DHCEQCContrastInfo.LookupDataType(rowdata.TDataType)		 //hisui���죺 add by zc 2018-09-04
	}		
}
document.body.style.padding="10px 5px 10px 10px" //// hisui-���� add by kdf 2018-11-09   ��������� �� �� �� �ڱ߾�
document.body.onload = BodyLoadHandler;