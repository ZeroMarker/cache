//create by GR0005 2014-09-02 
function BodyLoadHandler()
{
}
//û���µ�?�豸��ϸ����?DHCEQMTroubleAnalyzeDetail�˵�?˫���¼��ݲ�ʹ��
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
	//�������Ϊ�̶�д��
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQMTroubleReason'); //�õ����   t+�������
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
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