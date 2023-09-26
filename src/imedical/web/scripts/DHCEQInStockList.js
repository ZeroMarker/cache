var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQInStockList'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	//ChangeRowStyleTest(rowObj);
	var selectrow=rowObj.rowIndex; //当前选择行
	var Tobj=document.getElementById('TRowIDz'+selectrow);
	var Tobj1=document.getElementById('TInStockDRz'+selectrow);
	var InStockDR=Tobj1.value
	var Type=GetElementValue("Type")
	if (selectrow==SelectedRow){
		SelectedRow=0;
		parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+InStockDR+"&RowID="+"&Type="+Type
		return;}
	var RowID=Tobj.value ;
	SelectedRow = selectrow;
	parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+InStockDR+"&RowID="+RowID+"&Type="+Type
}
