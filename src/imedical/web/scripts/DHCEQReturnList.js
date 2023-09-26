var isReturn;
var SelectedRow = 0;
function SelectRowHandler()	{
	isReturn=GetElementValue("IsReturn");
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl;
	if (isReturn=="N")
	{
		objtbl=document.getElementById('tDHCEQOutStockList'); //得到表格   t+组件名称
	}
	else
	{
		objtbl=document.getElementById('tDHCEQReturnList'); //得到表格   t+组件名称
	}
	
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	var Tobj=document.getElementById('TRowIDz'+selectrow);
	var Tobj1=document.getElementById('ReturnDR');
	var ReturnDR=Tobj1.value
	if (selectrow==SelectedRow){
		SelectedRow=0;
		if (isReturn=="N")
		{
			if (parent.DHCEQOutStockListAdd) parent.DHCEQOutStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStockListAdd&ReturnDR="+ReturnDR+"&RowID="
		}
		else
		{
			if (parent.DHCEQReturnListAdd) parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+ReturnDR+"&RowID="
		}
		return;}
	var RowID=Tobj.value ;
	SelectedRow = selectrow;
	if (isReturn=="N")
	{
		if (parent.DHCEQOutStockListAdd) parent.DHCEQOutStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStockListAdd&ReturnDR="+ReturnDR+"&RowID="+RowID 
	}
	else
	{
		if (parent.DHCEQReturnListAdd) parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+ReturnDR+"&RowID="+RowID 
	}
}
