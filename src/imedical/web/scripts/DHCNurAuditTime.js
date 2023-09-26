function BodyLoadHandler(){
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCNurAuditTime');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtRowID');
	var obj1=document.getElementById('txtBatch');
	var obj2=document.getElementById('txtFromTime');
	var obj3=document.getElementById('txtEndTime');
	var obj4=document.getElementById('txtAuditTime');
	
	var SelRowObj=document.getElementById('RowIDz'+selectrow);
	var SelRowObj1=document.getElementById('Batchz'+selectrow);
	var SelRowObj2=document.getElementById('FromTimez'+selectrow);
	var SelRowObj3=document.getElementById('EndTimez'+selectrow);
	var SelRowObj4=document.getElementById('AuditTimez'+selectrow);

	if (obj) obj.value=SelRowObj.innerText;
	if (obj1) obj1.value=SelRowObj1.innerText;
	if (obj2) obj2.value=SelRowObj2.innerText;
	if (obj3) obj3.value=SelRowObj3.innerText;
	if (obj4) obj4.value=SelRowObj4.innerText;
	return;
	}
document.body.onload=BodyLoadHandler;