/// DHCEQManageEquipList.js
function BodyLoadHandler()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=BPrintBar_Clicked;
	SetTableRow();
	SetBackGroupColor('tDHCEQManageEquipList');
}
function BFind_Click()
{
	var lnk="&LocDR="+GetElementValue("LocDR")+"&job="+GetElementValue("job")+"&FileNo="+GetElementValue("FileNo")+"&No="+GetElementValue("No")+"&Name="+GetElementValue("Name")+"&Chk=";
	if (GetElementValue("Chk")==true) lnk=lnk+"Y";
	//alertShow(lnk)
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQManageEquipList"+lnk;
}
function SetTableRow()
{
	var objtbl=document.getElementById('tDHCEQManageEquipList');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQManageEquipList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="dhceqequiplistnew.csp?&ReadOnly=1&BatchFlag=&InStockListDR=&StoreLocDR="+GetElementValue("TStoreLocDRz"+selectrow)+"&RowID="+GetElementValue("TRowIDz"+selectrow);
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=800,left=200,top=10');
}
function BPrintBar_Clicked()
{
	var obj=document.getElementById("GetManageEquipListEQDRs");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"",GetElementValue("job"),GetElementValue("LocDR"),GetElementValue("No"),GetElementValue("Name"));
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split(":");
	var truthBeTold = window.confirm("确定打印当前全部设备条码?     共 "+list[0]+" 台");
	if (truthBeTold)
	{
		var encmeth=GetElementValue("SaveOperateLog");
		if (encmeth=="") return;
		var EQDRs=list[1].split("^");
		for (var i=0;i<list[0];i++)
		{
			//alertShow(EQDRs[i])
			DHCEQPrintQrcode(EQDRs[i],2,"tiaoma");
			cspRunServerMethod(encmeth,"^52^"+EQDRs[i],2);
		}
	}
}
document.body.onload = BodyLoadHandler;