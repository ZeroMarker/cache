/// DHCPEMonthStatisticImport.js
/// ����ʱ��		2007.07.13
/// ������			xuwm
/// ��Ҫ����		ʵ�ֵ����±���Ĺ���
/// ��Ӧ��			��Ҫ DHCPEExcelPublic.js �ļ�ʵ��EXCEL����
/// ����޸�ʱ��
/// ����޸���

var FMonthSheetName="";
var FExcel;

// ����ÿ�¿ͻ���ϸ����
function MonthStatisticImport(ImportDate,DataSaveFilePath) {
	
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEMonthStatistic.xls';// ��ͳ�Ʊ���
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	var objExcel= new DHCPEExcel(Templatefilepath, false);

	if (objExcel)
	{
         
		// ���õ����ļ�(���Ϊ�ļ���,����)
		MSFileChange(objExcel,ImportDate,DataSaveFilePath);
	
		
		// �¹�����(��ÿ�������Ա���)����
		MonthStatisticDataToExcel(objExcel, ImportDate, FMonthSheetName);
	
		
		// �����¹���������
		StationStatisticToExcel(objExcel, ImportDate);
		
		
		// ����ÿ��(����)����������
		ImportStationDayStatistic(objExcel, ImportDate);
		
		// ҽ��ÿ��(����)����������
		ImportDayDoctorStatistic(objExcel, ImportDate);
		
		// �����Ŀÿ��(����)����������
		ImportDayOEItemStatistic(objExcel, ImportDate);
		objExcel.Colse(true);
		objExcel=null;
		alert("���ݵ������");
		
		
	}

}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

// ���õ����ļ�(����ļ���,����)
function MSFileChange(objExcel,ImportDate,DataSaveFilePath) {
		//alert('ImportDate'+ImportDate+"  DataSaveFilePath"+DataSaveFilePath);
		var ImportDateArr=ImportDate.split("^");
		var ImportDateStr=ImportDateArr[0];
		var importMonth=ImportDateStr.substring(ImportDateStr.indexOf('-')+1,ImportDateStr.length);
		var importYear=ImportDateStr.substring(0,ImportDateStr.indexOf('-'));
		objExcel.GetSheet('�·�����ͳ��');
		objExcel.SetSheet('�·�����ͳ��',importMonth+'�·�����ͳ��');
		objExcel.GetSheet(importMonth+'�·�����ͳ��');
		FMonthSheetName=importMonth+'�·�����ͳ��';
		var iCol=1;
		var iRow=1;
		
		objExcel.writeData(iRow, iCol, importMonth+objExcel.ReadData(iCol, iRow));
		objExcel.SaveTo(DataSaveFilePath);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


// ������ͳ������(ÿ��Ĺ�����?���ҹ�����)��Excel�ļ�
var FRow=5; // �ӵ����п�ʼ��������
function MonthStatisticDataToExcel(objExcel, ImportDate) {
	//alert('MonthStatisticDataToExcel'+ImportDate);
	
	FExcel=objExcel;
	var Instring=ImportDate;
	FRow=5;
	var Ins=document.getElementById('MonthStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	//										ÿ�������Ա��Ϣ����
	var retvalue=cspRunServerMethod(encmeth,'MonthPEIADMToExcel','',Instring)	
	if (""==retvalue) { return false; }
	else{
		var ListTitle=ImportDate+"������";
		objExcel.GetSheet("����");
		objExcel.writeData(1, 1, ListTitle);
	}
	
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
	
	// ÿ��Ĺ�����
	objExcel.GetSheet(FMonthSheetName);
	var DayDatas=retvalue.split(";")
	var DayData=null;
	var Num,mDay,mAumont;
	var iCol,iRow;
	var ColCount=16; // ��������
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		
		DayData=DayDatas[iDayLoop].split("^");
		
		Num=parseInt(DayData[0],10);		
		iRow=((Num-1) % ColCount)+5;
		iCol=(parseInt((Num-1) / ColCount))*2+1;
		mDay=DayData[1];		
		objExcel.writeData(iRow, iCol, mDay);
		mAumont=parseFloat(DayData[2]);
		//objExcel.writeData(iRow, iCol+1, Num+"("+iRow+","+iCol+')-('+(Num % ColCount)+','+parseInt(Num / ColCount)+')---'+DayDatas[iDayLoop]);
		objExcel.writeData(iRow, iCol+1, mAumont);
	}
	
}

// ����ÿ�������Ա��Ϣ,��MonthStatisticDataToExcel����
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
		objExcel.writeData(iRow, 1, DayData[0]); // ����
		objExcel.writeData(iRow, 2, DayData[1]); // ҵ��Ա
		objExcel.writeData(iRow, 3, DayData[2]); // �ײ�
		objExcel.writeData(iRow, 4, DayData[3]); // �۸�
		objExcel.writeData(iRow, 5, DayData[4]); // ����
		objExcel.writeData(iRow, 6, DayData[5]); // ��λ
		objExcel.writeData(iRow, 7, DayData[6]); // �绰
		objExcel.writeData(iRow, 8, DayData[7]); // �շ����-���
		objExcel.writeData(iRow, 9, DayData[8]); // �շ����-�����
		objExcel.writeData(iRow, 10, DayData[9]); // ������Ŀ
		objExcel.writeData(iRow, 11, DayData[10]); // �����շ�
		objExcel.writeData(iRow, 12, DayData[11]); // �ۿ�
		objExcel.writeData(iRow, 13, DayData[12]); // ��ע
		
		iRow=iRow+1;
	}
	FRow=iRow;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

// ����ÿ�¿���ͳ�����ݵ�Excel�ļ�
function StationStatisticToExcel(objExcel,ImportDate) {
	
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
		objExcel.writeData(iRow, iCol, DayDatas[iDayLoop]);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


// ����ÿ��ͳ�����ݵ�--------���Ҽ���
var FRow=1; // 
function ImportStationDayStatistic(objExcel, ImportDate) {
	//alert('ImportStationDayStatistic'+ImportDate)
	FExcel=objExcel;
	FRow=1;
	var Instring=ImportDate;
	var Ins=document.getElementById('StationDayStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'StationDayStatisticToExcel','',Instring)	
	//alert("value:"+value)
	if (""==value) { return false; }
}

// �������ÿ��ͳ�����ݵ�Excel�ļ�,�� ImportStationDayStatistic �е���
function StationDayStatisticToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("���Ҽ���");
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) { objExcel.writeData(iRow, iCol+1, DayData[iCol]); }
	}
	FRow=FRow+1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
var FCol=1;
// ҽ��ÿ��ͳ�����ݵ�--------ҽ������
function ImportDayDoctorStatistic(objExcel, ImportDate) {
	//alert('ImportStationDayStatistic'+ImportDate)
	FExcel=objExcel;
	FCol=1;
	var Instring=ImportDate;
	var Ins=document.getElementById('DayDoctorWorkStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'DayDoctorStatisticToExcel','',Instring)	
	if (""==value) { return false; }
}
// ���ҽ��ÿ��Ĺ�����ͳ�����ݵ�Excel�ļ��� ImportDayDoctorStatistic �е���
function DayDoctorStatisticToExcel(Datas) {
	//alert("DayDoctorStatisticToExcel \n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("ҽ������");
	var DayData=null;
	var iRow=0,iCol=FCol;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iRow=iDayLoop;
		if (DayData[iRow]&&''!=DayData[iRow]) { objExcel.writeData(iRow+1, iCol, DayData[iRow]); }
		
	}
	FCol=FCol+1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function ImportDayOEItemStatistic(objExcel, ImportDate) {
	//alert('ImportStationDayStatistic'+ImportDate)
	FExcel=objExcel;
	FRow=1;
	var Instring=ImportDate;
	var Ins=document.getElementById('DayOEItemWorkStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'DayOEItemStatisticToExcel','',Instring)	
	if (""==value) { return false; }
}


// ���ҽ��ÿ��Ĺ�����ͳ�����ݵ�Excel�ļ��� ImportDayOEItemStatistic �е���
function DayOEItemStatisticToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("��Ŀ����");
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) { objExcel.writeData(iRow, iCol+1, DayData[iCol]); }
	
	}
	FRow=FRow+1;
}




