function BodyLoadHandler()
{
	var obj=document.getElementById('tDHCEQTroubleResolvent');
	if (obj) {obj.ondblclick=DB_Clicked;}

}
function DB_Clicked()
{
	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tDHCEQTroubleAnalyze');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TDealMethodDRz'+selectrow);
	var DealMethodDR=obj.value;
	var obj=document.getElementById('TDealMethodz'+selectrow);
	var DealMethod=obj.innerText;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQTroubleAnalyzeDetail&FaultCaseDR='+""+'&FaultCase='+""+'&FaultReasonDR='+""+'&FaultReason='+""+'&DealMethodDR='+DealMethodDR+'&DealMethod='+DealMethod;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}

document.body.onload = BodyLoadHandler;