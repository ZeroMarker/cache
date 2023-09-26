/// DHCPESalerStatisticImport.js
/// ����ʱ��		2007.08.03
/// ������			xuwm
/// ��Ҫ����		ҵ��Աҵ�����
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FMonthSheetName="";
var FExcel;


// ����ÿ�¿ͻ���ϸ����
function SalerStatisticImport(ImportDate,DataSaveFilePath) {
	//alert('MonthStatisticImport');
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPESalerStatistic.xls';// ��ͳ�Ʊ���
	}else{
		alert("��Чģ��·��");
		return;
	}
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		SSFileChange(objExcel,ImportDate,DataSaveFilePath);
		
		// ҵ��Աҵ�����
		ImportSalerStatistic(objExcel, ImportDate);
		objExcel.Colse(true);
		objExcel=null;
		alert("���ݵ������");		
	}

}
// ���õ����ļ�(����ļ���,����)
function SSFileChange(objExcel,ImportDate,DataSaveFilePath) {
		var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		objExcel.GetSheet('����');
		var iCol=1;
		var iRow=1;
		objExcel.writeData(iRow, iCol, importMonth+"�·��������ҵ���������");
		objExcel.SaveTo(DataSaveFilePath);
}
// ����ÿ��ͳ�����ݵ���
var FRow=1; // 
function ImportSalerStatistic(objExcel, ImportDate) {
	FExcel=objExcel;
	FRow=3;
	var Instring=ImportDate;
	var Ins=document.getElementById('SalerStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'SalerStatisticToExcel','',Instring)
    if (value=="��������ȷ������")	{
		alert("��������ȷ������");
		return false; 
	}
	if (""==value) { return false; }
}

// �������ÿ��ͳ�����ݵ�Excel�ļ�,��ImportStationDayStatistic�е���
function SalerStatisticToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("����");
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("StationDayStatisticToExcel\n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}


