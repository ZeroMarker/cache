var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl;
	objtbl=document.getElementById('tDHCEQDisuseRequestList'); //�õ����   t+�������
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
	var Type=GetElementValue("Type");
	var DisuseRequestDR=GetElementValue("DisuseRequestDR");
	var RequestLocDR=GetElementValue("RequestLocDR");
	var Tobj=document.getElementById('TRowIDz'+selectrow);
	if (selectrow==SelectedRow){
		SelectedRow=0;
		parent.DHCEQDisuseRequestListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListAdd&DisuseRequestDR="+DisuseRequestDR+"&Type="+Type+"&RequestLocDR="+RequestLocDR+"&RowID="
		return;}
	var RowID=Tobj.value ;
	SelectedRow = selectrow;
	parent.DHCEQDisuseRequestListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListAdd&DisuseRequestDR="+DisuseRequestDR+"&Type="+Type+"&RequestLocDR="+RequestLocDR+"&RowID="+RowID 	
}
