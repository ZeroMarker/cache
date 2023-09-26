//create by GR0005 2014-09-02 
function BodyLoadHandler()
{
}
//没有新的?设备详细分析?DHCEQMTroubleAnalyzeDetail菜单?双击事件暂不使用
/*
{
	var obj=document.getElementById('tDHCEQMTroubleReason');
	if (obj) {obj.ondblclick=DB_Clicked;}

}
function DB_Clicked()
{
	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tDHCEQMTroubleAnalyze');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TFaultReasonDRz'+selectrow);
	var FaultReasonDR=obj.value;
	var obj=document.getElementById('TFaultReasonz'+selectrow);
	var FaultReason=obj.innerText;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleAnalyzeDetail&FaultCaseDR='+""+'&FaultCase='+""+'&FaultReasonDR='+FaultReasonDR+'&FaultReason='+FaultReason+'&DealMethodDR='+""+'&DealMethod='+"";
    
    //alertShow("str="+str);
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}
*/
var SelectedRow = 0;
function SelectRowHandler()	{
	//下面基本为固定写法
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQMTroubleReason'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	var FaultCaseDR="";
	var FaultReasonDR="";
	var obj1=document.getElementById('FaultCaseDR');
	var obj=document.getElementById('TFaultReasonDRz'+selectrow);
	var FaultCaseDR=obj1.value;
	var FaultReasonDR=obj.value
	if (selectrow==SelectedRow){
		//FaultCaseDR="";
		FaultReasonDR="";
		SelectedRow=0;
		parent.DHCEQMTroubleResolvent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+(FaultCaseDR)+"&FaultReasonDR="+"";
	
		return;}
	SelectedRow = selectrow;
	parent.DHCEQMTroubleResolvent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleResolvent&FaultCaseDR="+(FaultCaseDR)+"&FaultReasonDR="+FaultReasonDR;
	//parent.location.href= "DHCEQMMaintManage.csp?FaultCaseDR="+FaultCaseDR+"&FaultReasonDR="+FaultReasonDR;
}
document.body.onload = BodyLoadHandler;