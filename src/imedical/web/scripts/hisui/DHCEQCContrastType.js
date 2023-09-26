var SelectedRow = -1; //hisui改造 add by zc 2018-08-31
var varRowID=""; //ID
var varTypeCode=""; //编码

function BodyLoadHandler() 
{
	$("#tDHCEQCContrastType").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //add by lmm 2018-09-26 hisui改造：隐藏翻页条内容
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
		SelectedRow=-1; //hisui改造 add by zc 2018-08-31
		varRowID="";
		varTypeCode="";
		parent.DHCEQCContrastInfo.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo";	//hisui改造 add by zc 2018-08-31
	
		$('#tDHCEQCContrastType').datagrid('unselectAll');  //hisui改造 add by zc 2018-08-31
	}
	else
	{
		SelectedRow=selectrow;
		varRowID=rowdata.TRowID; //hisui改造 add by zc 2018-08-31
		varDataType=rowdata.TDataType;	 //hisui改造 add by zc 2018-08-31	

		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo&DataType="+varDataType+"&ContrastTypeDR="+varRowID;
		//alertShow("lnk="+lnk);
		parent.DHCEQCContrastInfo.location.href=lnk;
		//parent.DHCEQCContrastInfo.LookupDataType(rowdata.TDataType)		 //hisui改造： add by zc 2018-09-04
	}		
}
document.body.style.padding="10px 5px 10px 10px" //// hisui-调整 add by kdf 2018-11-09   设置面板上 右 下 左 内边距
document.body.onload = BodyLoadHandler;