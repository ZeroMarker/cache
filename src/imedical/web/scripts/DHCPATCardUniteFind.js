document.body.onload = DocumentLoadHandler;
var SelectedRow=0;
function DocumentLoadHandler()
{
	var obj;
	obj=document.getElementById("CancelUnit");
	if (obj) obj.onclick=CancelUnit_click;
}
function CancelUnit_click()
{
	if (SelectedRow==0) return;
	var obj,CancelDate=" ",NewRegNo="",OldRegNo="";
	var obj=document.getElementById("TCancelDatez"+SelectedRow);
	if (obj) CancelDate=obj.innerText;
	if (CancelDate!=" "){
		alert('已经撤销合并,不需要再次操作')
		return false;
	}
	var obj=document.getElementById("TOldRegNoz"+SelectedRow);
	if (obj) OldRegNo=obj.innerText;
	var obj=document.getElementById("TNewRegNoz"+SelectedRow);
	if (obj) NewRegNo=obj.innerText;
	if (!confirm("确实要撤销'"+OldRegNo+"'合并到'"+NewRegNo+"'吗")) return false;
	var rtn=tkMakeServerCall("web.DHCPATCardUnite","CardConverse",OldRegNo,NewRegNo);
	if (rtn==""){
		alert("撤销合并成功");
		location.reload();
	}else{
		alert(rtn);
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPATCardUniteFind');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

	SelectedRow = selectrow;
}
