//create by GR0005 2014-09-02
function BodyLoadHandler()
{
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
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequestDetail&FaultCaseDR='+FaultCaseDR+'&FaultCase='+FaultCase+'&FaultReasonDR='+""+'&FaultReason='+""+'&DealMethodDR='+""+'&DealMethod='+"";
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}

function GetFaultCase(value){
	var user=value.split("^");
	var obj=document.getElementById('FaultCase');
	obj.value=user[0];
	var obj=document.getElementById('FaultCaseDR');
	obj.value=user[1];
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()
{
	//下面基本为固定写法
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQMTroubleAnalyze'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	var FaultCaseDR="";
	var FaultReasonDR="";
	var obj=document.getElementById('TFaultCaseDRz'+selectrow);
	var FaultCaseDR=obj.value;
	if (selectrow==SelectedRow){
		FaultCaseDR="";
		SelectedRow=0;
		parent.DHCEQMTroubleReason.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleReason&FaultCaseDR="+"";
		parent.DHCEQMTroubleResolvent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+""+"&FaultReasonDR="+"";
	
		return;}
	SelectedRow = selectrow;
	parent.DHCEQMTroubleReason.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleReason&FaultCaseDR="+(FaultCaseDR);
	parent.DHCEQMTroubleResolvent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+(FaultCaseDR)+"&FaultReasonDR="+FaultReasonDR;
	//parent.location.href= "DHCEQMMaintManage.csp?FaultCaseDR="+FaultCaseDR+"&FaultReasonDR="+FaultReasonDR;
}

document.body.onload = BodyLoadHandler;