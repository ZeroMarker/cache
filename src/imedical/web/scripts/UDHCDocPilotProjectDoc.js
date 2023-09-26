//UDHCDocPilotProjectDoc.js
var SelectedRow=0
function BodyLoadHandler(){
		var obj=document.getElementById("SearchSettle");
	if (obj) obj.onclick=SearchSettleClickHander;
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCDocPilotProjectDoc');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if ((SelectedRow!=0)&&(selectrow==SelectedRow)){
		SelectedRow=0;
		return;
	}
	SelectedRow = selectrow;
}
function SearchSettleClickHander(){
	if (SelectedRow==0){
		alert("请先选择一个项目!")
		return false;
	}
	var PPRowId=DHCC_GetColumnData("PPRowId",SelectedRow);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProAllSettle&PPRowId="+PPRowId;
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProState&PPRowId="+PPRowId;
	win=window.open(lnk,"ChangeState","status=1,scrollbars=1,top=0,left=20,width=1300,height=600");
}
document.body.onload = BodyLoadHandler;