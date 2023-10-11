var SelectedRow = -1;	//hisui改造：修改开始行号  Add By DJ 2018-10-12
var rowid=0;
function BodyLoadHandler()
{
	$("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQMTroubleReason").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
	initButtonWidth();	//hisui改造 Add By DJ 2018-10-12
	initPanelHeaderStyle();//hisui改造 add by zyq 2023-02-02
}
///hisui改造： Add By DJ 2018-10-12
function SelectRowHandler(index,rowdata){
	var FaultCaseDR="";
	var FaultReasonDR="";
	FaultCaseDR=getElementValue("FaultCaseDR");
	if (index==SelectedRow){
		SelectedRow= -1;
		$('#tDHCEQMTroubleReason').datagrid('unselectAll'); 
		parent.DHCEQMTroubleResolvent.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+(FaultCaseDR)+"&FaultReasonDR="+"";
		return;
		}
	SelectedRow = rowdata.TRowID;
	FaultReasonDR=rowdata.TFaultReasonDR;
	parent.DHCEQMTroubleResolvent.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+(FaultCaseDR)+"&FaultReasonDR="+FaultReasonDR;
	SelectedRow = index;
}
document.body.style.padding="10px 5px 10px 5px"
document.body.onload = BodyLoadHandler;
