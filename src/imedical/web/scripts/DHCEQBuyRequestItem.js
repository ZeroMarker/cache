
//�����������������,�������ƹ̶�
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQBuyRequestItem'); //�õ����   t+�������
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
	var BuyRequestDR=GetElementValue("BuyRequestDR");
	if (selectrow==SelectedRow){
		SelectedRow=0;
		parent.frames["DHCEQBuyRequestItemEdit"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestItemEdit&RowID=&BuyRequestDR='+BuyRequestDR;
		return;}
	SelectedRow = selectrow;
	var RowID=GetElementValue("TRowIDz"+SelectedRow);
	parent.frames["DHCEQBuyRequestItemEdit"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestItemEdit&RowID='+RowID+'&BuyRequestDR='+BuyRequestDR;
}
