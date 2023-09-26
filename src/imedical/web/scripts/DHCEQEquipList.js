var SelectedRow=0;
var rowid=0;

function BodyLoadHandler() 
{
	var objtbl=document.getElementById('tDHCEQEquipList');
	var rows=objtbl.rows.length;
	if ((GetElementValue("TRowIDz1")<1)&&(GetElementValue("TInStockListDRz1")<1))
	{
		DisableBElement("TNamez1",true);
		HiddenObj("TNamez1",1)
	}
	var lastrowindex=rows - 1;
	if (lastrowindex>0)
	{
		if (GetElementValue("TRowIDz"+lastrowindex)<1&&GetElementValue("TInStockListDRz"+lastrowindex)<1)
		{
			DisableBElement("TNamez"+lastrowindex,true);
			HiddenObj("TNamez"+lastrowindex,1)
		}
	}
	SetTableRow();
	HiddenTableIcon("DHCEQEquipList","TRowID","TDetail");	/// 20150922  Mozy0166
	SetOddColor();
	SetBackGroupColor('tDHCEQEquipList');
}

function SelectRowHandler()	{
	var selectrow=0;
	var eSrc=websys_getSrcElement(e);	
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc)
	if (eSrc.tagName=="TD")
	{
		var rowObj=getRow(eSrc);
		selectrow=rowObj.rowIndex;
	}
	else
	{
		selectrow=GetRowByColName(eSrc.id);//µ÷ÓÃ
	}
	
	if (!selectrow) return;
	if (SelectedRow==selectrow)	{	
		SelectedRow=0;
		rowid=0;
		///parent.parent.frames["eprmenu"].document.forms["fEPRMENU"].PatientID.value="";
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+selectrow);
		///parent.parent.frames["eprmenu"].document.forms["fEPRMENU"].PatientID.value=rowid;
		}
	//alertShow(parent.frames["eprmenu"].document.forms["fEPRMENU"].PatientID.value);
}
function SetTableRow()
{
	var objtbl=document.getElementById('tDHCEQEquipList');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		if (GetElementValue("TRowIDz"+i)!="")	objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQEquipList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="dhceqequiplistnew.csp?&BatchFlag="+GetElementValue("TBatchFlagz"+selectrow)+"&InStockListDR="+GetElementValue("TInStockListDRz"+selectrow)+"&StoreLocDR="+GetElementValue("TStoreLocDRz"+selectrow)+"&RowID="+GetElementValue("TRowIDz"+selectrow)+"&ReadOnly="+GetElementValue("ReadOnly");
  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=800,left=200,top=10');
}
document.body.onload = BodyLoadHandler;
