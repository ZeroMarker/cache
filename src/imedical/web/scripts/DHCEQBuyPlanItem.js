//�����������������,�������ƹ̶�
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQBuyPlanItem'); //�õ����   t+�������
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
	var BuyPlanDR=GetElementValue("BuyPlanDR");
	if (selectrow==SelectedRow){
		SelectedRow=0;
		parent.frames["DHCEQBuyPlanItemEdit"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanItemEdit&RowID=&BuyPlanDR='+BuyPlanDR;
		return;}
	SelectedRow = selectrow;
	var RowID=GetElementValue("TRowIDz"+SelectedRow);
	parent.frames["DHCEQBuyPlanItemEdit"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanItemEdit&RowID='+RowID+'&BuyPlanDR='+BuyPlanDR;
}