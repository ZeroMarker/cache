//create by GR0005 2014-09-02
function BodyLoadHandler()
{
}
//没有新的?设备详细分析?DHCEQMTroubleAnalyzeDetail菜单?双击事件暂不使用
/*
{
	var obj=document.getElementById('tDHCEQMTroubleResolvent');
	if (obj) {obj.ondblclick=DB_Clicked;}

}
function DB_Clicked()
{
	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tDHCEQMTroubleAnalyze');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TDealMethodDRz'+selectrow);
	var DealMethodDR=obj.value;
	var obj=document.getElementById('TDealMethodz'+selectrow);
	var DealMethod=obj.innerText;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMTroubleAnalyzeDetail&FaultCaseDR='+""+'&FaultCase='+""+'&FaultReasonDR='+""+'&FaultReason='+""+'&DealMethodDR='+DealMethodDR+'&DealMethod='+DealMethod;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}
*/

document.body.onload = BodyLoadHandler;