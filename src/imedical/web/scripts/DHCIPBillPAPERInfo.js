
///DHCIPBillPAPERInfo.js
var SelectedRow = 0;
function BodyLoadHandler()
{  
	var obj=document.getElementById("tDHCIPBillPAPERInfo");
	if (obj) obj.ondblclick=PAPERSelect_Click;
	
}
function PAPERSelect_Click()	{
	if (SelectedRow==0) return;
	
	var Regno=document.getElementById('TPAPERNoz'+SelectedRow).innerText;
	
	var Parobj=window.opener
    var objRegno=Parobj.document.getElementById("Regno")
    if (objRegno) objRegno.value=Regno;
	self.close();
	Parobj.getpatinfo1()
	Parobj.websys_setfocus('name'); 
	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCIPBillPAPERInfo');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

	SelectedRow = selectrow;
}


document.body.onload = BodyLoadHandler;