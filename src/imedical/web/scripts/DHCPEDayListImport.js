/// DHCPEDayListImport.js
/// ����ʱ��		2008.01.10
/// ������			xuwm
/// ��Ҫ����		��ӡÿ�������Ա�б�
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FMonthSheetName="";
var FExcel;


// ����ÿ�¿ͻ���ϸ����
function PrintPEDayList(ImportDate) {
	//alert('PrintPEDayList');
	var obj;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPEDayList.xls';// ��ͳ�Ʊ���
	}else{
		alert("��Чģ��·��");
		return;
	}
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		PDLFileChange(objExcel, ImportDate);
		
		ImportPEDayList(objExcel, ImportDate);
		objExcel.Print(false);
		objExcel.Colse(false);
		objExcel=null;
		//alert("��ӡ���");
	}
}

// ���õ����ļ�(����ļ���,����)
function PDLFileChange(objExcel, ImportDate) {
	var PEDate=ImportDate.split('/');
	objExcel.GetSheet('����');
	var iCol=1;
	var iRow=1;
	var Title=PEDate[2]+'-'+PEDate[1]+'-'+PEDate[0]+objExcel.ReadData(iRow, iCol);
	objExcel.writeData(iRow, iCol, Title);
}

var FRow=3; //
function ImportPEDayList(objExcel, ImportDate) {
	FExcel=objExcel;
	objExcel.GetSheet('����')
	FRow=3;
	var Instring=ImportDate;
	var Ins=document.getElementById('PEDayListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'PEDayListToExcel','',Instring)	
	if (""==value) { return false; }
	objExcel.SetPrintArea("$A$1:$F$"+FRow);
}

function PEDayListToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}


