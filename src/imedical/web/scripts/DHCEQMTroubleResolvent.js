function BodyLoadHandler()
{
	$("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQMTroubleResolvent").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
	initPanelHeaderStyle();//hisui改造 add by zyq 2023-02-02
}
document.body.style.padding="10px 10px 10px 5px"
document.body.onload = BodyLoadHandler;
