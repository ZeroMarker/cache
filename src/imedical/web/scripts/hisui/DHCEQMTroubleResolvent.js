function BodyLoadHandler()
{
	$("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-���� ȥ��y�� ������
	$("#tDHCEQMTroubleResolvent").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui���죺���ط�ҳ������
	initPanelHeaderStyle();//hisui���� add by zyq 2023-02-02
}
document.body.style.padding="10px 10px 10px 5px"
document.body.onload = BodyLoadHandler;
