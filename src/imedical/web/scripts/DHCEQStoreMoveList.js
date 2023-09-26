var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	if (eSrc.tagName=="IMG") return;
	var objtbl=document.getElementById('tDHCEQStoreMoveList'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	var Tobj=document.getElementById('TRowIDz'+selectrow);
	var Tobj1=document.getElementById('TStoreMoveDRz'+selectrow);
	var StoreMoveDR=Tobj1.value
	if (selectrow==SelectedRow){
		SelectedRow=0;
		if(parent.DHCEQStoreMoveListAdd) parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+StoreMoveDR+"&RowID="
		return;}
	var RowID=Tobj.value ;
	SelectedRow = selectrow;
	if(parent.DHCEQStoreMoveListAdd) parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+StoreMoveDR+"&RowID="+RowID 
}
