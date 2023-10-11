var SelectedRow = -1;	//hisui改造：修改开始行号  Add By DJ 2018-10-12
var rowid=0;
//create by GR0005 2014-09-02
function BodyLoadHandler()
{
    $("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQMTroubleAnalyze").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
	initButtonWidth();	//hisui改造 Add By DJ 2018-10-12
	initPanelHeaderStyle();//hisui改造 add by zyq 2023-02-02
	var obj=document.getElementById('tDHCEQMTroubleAnalyze');
	if (obj) {obj.ondblclick=DB_Clicked;}
}
function DB_Clicked()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMTroubleAnalyze');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TFaultCaseDRz'+selectrow);
	var FaultCaseDR=obj.value;
	var obj=document.getElementById('TFaultCasez'+selectrow);
	var FaultCase=obj.innerText;
	//新?设备故障详细分析?组件DHCEQMMaintRequestDetail不存在
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequestDetail&FaultCaseDR='+FaultCaseDR+'&FaultCase='+FaultCase+'&FaultReasonDR='+""+'&FaultReason='+""+'&DealMethodDR='+""+'&DealMethod='+"";
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}

function GetFaultCase(value){
	var user=value.split("^");
	var obj=document.getElementById('FaultCase');
	obj.value=user[0];
	var obj=document.getElementById('FaultCaseDR');
	obj.value=user[1];
}
///hisui改造： Add By DJ 2018-10-12
function SelectRowHandler(index,rowdata){
	var FaultCaseDR="";
	var FaultReasonDR="";
	if (index==SelectedRow){
		SelectedRow= -1;
		$('#tDHCEQMTroubleAnalyze').datagrid('unselectAll'); 
		parent.DHCEQMTroubleReason.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleReason&FaultCaseDR="+"";
		parent.DHCEQMTroubleResolvent.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+""+"&FaultReasonDR="+"";
		return;
		}
	SelectedRow = rowdata.TRowID;
	FaultCaseDR=rowdata.TFaultCaseDR;
	parent.DHCEQMTroubleReason.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleReason&FaultCaseDR="+(FaultCaseDR);
	parent.DHCEQMTroubleResolvent.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+(FaultCaseDR)+"&FaultReasonDR="+FaultReasonDR;
	SelectedRow = index;
}
document.body.style.padding="10px 5px 10px 10px"
document.body.onload = BodyLoadHandler;
