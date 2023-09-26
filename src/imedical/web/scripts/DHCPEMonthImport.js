/// DHCPEReportPrint.js
/// ����ʱ��		2007.07.13
/// ������			xuwm
/// ��Ҫ����		ʵ�ֵ�����ӡ�±���Ĺ���
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FMonthSheetName="";
var FExcel;

// ����ÿ�¿ͻ���ϸ����
var FCol,FRow=5;
function DataImport(ImportDate,DataSaveFilePath) {
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEMonthStatistic.xls';// ��ͳ�Ʊ���
	}else{ alert("��Чģ��·��"); }
	var objExcel= new DHCPEExcel(Templatefilepath);
	if (objExcel)
	{
		FileChange(objExcel,ImportDate,DataSaveFilePath);
		MonthStatisticDataToExcel(objExcel, FMonthSheetName);
		StationStatisticToExcel(objExcel)
		alert("���ݵ������");
		objExcel.Colse(true);
		
	}

}

function FileChange(objExcel,ImportDate,DataSaveFilePath) {
		var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		objExcel.GetSheet('�·�����ͳ��');
		objExcel.SetSheet('�·�����ͳ��',importMonth+'�·�����ͳ��');
		objExcel.GetSheet(importMonth+'�·�����ͳ��');
		FMonthSheetName=importMonth+'�·�����ͳ��';
		var iCol=1;
		var iRow=1;
		objExcel.writeData(iCol, iRow, importMonth+objExcel.ReadData(iCol, iRow));
		objExcel.SaveTo(DataSaveFilePath);
}

// ������ͳ������
function MonthStatisticDataToExcel(objExcel) {
	//alert("MonthStatisticDataToExcel");
	//var DayDatas=Datas.split(";")
	
	var ImportDate="";
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}
	FExcel=objExcel;
	var Instring=ImportDate;
	var Ins=document.getElementById('MonthStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var retvalue=cspRunServerMethod(encmeth,'MonthPEIADMToExcel','',Instring)	
	if (""==retvalue) { return false; }
	/*
	var  retvalue='1^2007/04/1^45;'
				+'2^2007/04/2^51;'
				+'7^2007/04/7^12;'
				+'10^2007/04/10^45;'
				+'13^2007/04/13^32;'
				+'15^2007/04/15^21;'
				+'16^2007/04/16^52;'
				+'23^2007/04/23^101;'
				+'29^2007/04/29^85;'
				+'30^2007/04/30^96;'
	*/
	objExcel.GetSheet(FMonthSheetName);
	var DayDatas=retvalue.split(";")
	var DayData=null;
	var Num,mDay,mAumont;
	var iCol,iRow;
	FRow=5;
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		//alert(DayDatas[iDayLoop]);
		DayData=DayDatas[iDayLoop].split("^");
		Num=parseInt(DayData[0],10)-1;
		iCol=(parseInt(Num / 16))*2+1;
		iRow=(Num % 16)+5;
		mDay=DayData[1];
		mAumont=parseFloat(DayData[2]);
		objExcel.writeData(iCol, iRow,mDay);
		//objExcel.writeData(iCol+1, iRow,Num+"("+iCol+","+iRow+")"+mAumont);
		objExcel.writeData(iCol+1, iRow, mAumont);
	}
	
}
// ����ÿ�¿���ͳ������
function StationStatisticToExcel(objExcel) {
	var ImportDate="";
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}
	var Instring=ImportDate;
	var Ins=document.getElementById('StationStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',Instring)	
	objExcel.GetSheet(FMonthSheetName);
	var DayDatas=value.split(";")
	var iCol=1,iRow=1;
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		iRow=iDayLoop+21;
		mDay=1;
		objExcel.writeData(iCol, iRow,DayDatas[iDayLoop]);
	}
}



function MonthPEIADMToExcel(Datas) {
	//alert("MonthPEIADMToExcel\n"+Datas);
	var objExcel=FExcel;
	var DayDatas=Datas.split(";");
	//alert("MonthPEIADMToExcel GetSheet");
	objExcel.GetSheet("����");
	
	var DayData=null;
	var Num,mDay,mAumont;
	var iCol,iRow=FRow;
	//alert("MonthPEIADMToExcel for");
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {

		DayData=DayDatas[iDayLoop].split("^");
		objExcel.writeData(1, iRow, DayData[0]); // ����
		objExcel.writeData(2, iRow, DayData[1]); // ҵ��Ա
		objExcel.writeData(3, iRow, DayData[2]); // �ײ�
		objExcel.writeData(4, iRow, DayData[3]); // �۸�
		objExcel.writeData(5, iRow, DayData[4]); // ����
		objExcel.writeData(6, iRow, DayData[5]); // ��λ
		objExcel.writeData(7, iRow, DayData[6]); // �绰
		objExcel.writeData(8, iRow, DayData[7]); // �շ����-���
		objExcel.writeData(9, iRow, DayData[8]); // �շ����-�����
		objExcel.writeData(10, iRow, DayData[9]); // ������Ŀ
		objExcel.writeData(11, iRow, DayData[10]); // �����շ�
		objExcel.writeData(12, iRow, DayData[11]); // �ۿ�
		objExcel.writeData(13, iRow, DayData[12]); // ��ע
		
		iRow=iRow+1;
	}
	FRow=iRow;
}


// ����ÿ�¿ͻ���ϸ����
function MonthPEIADMImport(objExcel) {
	var DayDatas=Datas.split(";")
	
	var ImportDate="";
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}
	var Instring=ImportDate;
	var Ins=document.getElementById('MonthStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',Instring)	

	
	var DayDatas=value.split(";")
	
	var DayData=null;
	var Num,mDay,mAumont;
	var iCol,iRow;
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		//alert(DayDatas[iDayLoop]);
		DayData=DayDatas[iDayLoop].split("^");
		Num=parseInt(DayData[0],10)-1;
		iCol=(parseInt(Num / 16))*2+1;
		iRow=(Num % 16)+5;
		mDay=DayData[1];
		mAumont=parseFloat(DayData[2]);
		objExcel.writeData(iCol, iRow,mDay);
		//objExcel.writeData(iCol+1, iRow,Num+"("+iCol+","+iRow+")"+mAumont);
		objExcel.writeData(iCol+1, iRow, mAumont);
	}

}
