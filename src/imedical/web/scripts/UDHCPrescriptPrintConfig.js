var SelectedRow=0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("Add");
	if(obj)obj.onclick=Add_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick=Update_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick=Delete_Click;

}
function LoclookupSet(value)
{
	var Str=value.split("^");
	var LocRowId=Str[1];
	var LocDesc=Str[0];
	var obj=document.getElementById("LocID");
	if(obj)obj.value=LocRowId;

}
function PrintTypeLookup(value)
{
	var Str=value.split("^");
	var PrintTypeRowId=Str[1];
	var PrintTypeDesc=Str[0];
	var obj=document.getElementById("PrintTypeID");
	if(obj)obj.value=PrintTypeRowId;

}
function Add_Click()
{
	var obj=document.getElementById("PrintType");
	if(obj.value==""){
		alert("��ѡ���ӡ��ʽ");
		return;
	}
	var obj=document.getElementById("Loc");
	if(obj.value==""){
		alert("��ѡ�����");
		return;
	}
	var Add=document.getElementById("insertMethod");
	if (Add) {var encmeth=Add.value} else {var encmeth=''};
	var LocID=document.getElementById("LocID").value;
	var PrintTypeID=document.getElementById("PrintTypeID").value;
	var rtn=cspRunServerMethod(encmeth,LocID,PrintTypeID);
	if(rtn=="0"){
		alert("����ɹ�!");
		window.location.reload();
	}
	else{
		if(rtn=="200")alert("��ѡ���ӡ��ʽ�Ϳ���.");
		else if(rtn=="201"){alert("��¼�ظ�!")}
		else alert("����ʧ��!");
	}
}
function Update_Click()
{
	
}
function Delete_Click()
{
	var LocID=document.getElementById("LocID").value;
	if(LocID==""){
		alert("��ѡ����");
		return;
		}
	var Delete=document.getElementById("DeleteMethod");
	if (Delete) {var encmeth=Delete.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,LocID);
	if(rtn=="0"){
		alert("ɾ���ɹ�");
		}
		else{
			alert("ɾ��ʧ��");
			}
    window.location.reload();
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCPrescriptPrintConfig');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	/*
	var obj=document.getElementById('Mon');
	var obj1=document.getElementById('RegNo');
	
	var TotalFee=DHCC_GetColumnData('TabPrice',selectrow);
	var AppFee=DHCC_GetColumnData('TabAppFee',selectrow);
	var ChangeSum=DHCC_GetColumnData('TabChangeSum',selectrow);
	var ReturnFee=TotalFee-AppFee;
	DHCC_SetElementData("mon",ReturnFee)
	DHCC_SetElementData("ChangeSum",ChangeSum)
	*/
	//var aid=document.getElementById('Arcdrz'+selectrow).interText;
	if (selectrow!=SelectedRow){
		var depId=document.getElementById('TLocIDz'+selectrow).value;
		var obj=document.getElementById("LocID");
		if(obj)obj.value=depId;
		SelectedRow = selectrow;
	}else{
		var obj=document.getElementById("LocID");
		if(obj)obj.value="";
		SelectedRow=0;
	}
}

