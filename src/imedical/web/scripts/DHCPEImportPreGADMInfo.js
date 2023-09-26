/// DHCPEImportPreGADMInfo.js
/// ����ʱ��		2008.01.21
/// ������		xuwm
/// ��Ҫ����		Ϊ����ʵ�ֵĹ���:����ԤԼ�������ϸ����
/// ��ע			�������������г�ͻ:�����������ǵ�ǰ���ܵ��Ӽ�
/// 			��Ա����������?����¹�����ͳ��?��������������
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;
   
	var btnobj=document.getElementById("PrintGPerson");
	if (btnobj){ btnobj.onclick=PrintGPerson_Click; }
	
function PrintGPerson_Click() {

	var iRowId='', iName='';
	var obj;
	//�������
	obj=document.getElementById('RowId');
	if (obj) { iRowId=obj.value;  }
	if (""==iRowId) { return false; }
	
	//��������
	obj=document.getElementById('RowId_Name');
	if (obj) { iName=obj.value;  }
	if (""==iName) { return false; }

	ImportPreGADMInfo(iRowId,iName);
}	
	
// ����ÿ�¿ͻ���ϸ����
function ImportPreGADMInfo(ID,Name) {
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEImportPreGADMInfo.xls';// ��ͳ�Ʊ���
	}else{ alert("��Чģ��·��"); }
	
	var objExcel= new DHCPEExcel(Templatefilepath);
	if (objExcel)
	{
		PGIFileChange(objExcel,ID,Name);
		PGIToExcel(objExcel,ID);
		alert("���ݵ������");
		objExcel.Colse(true);
		objExcel=null;
	}

}
// ����ģ���ļ�,���Ϊ,���Title
function PGIFileChange(objExcel,ID,Name) {
		var today=new Date();
		var DataSaveFilePath='D:\\'+Name+'('+today.getTime()+').xls';
		objExcel.SaveTo(DataSaveFilePath);
}
var FRow=1;
// ��ȡ����
function PGIToExcel(objExcel,ID) {
	
	var Instring=ID;
	var Ins=document.getElementById('PreGADMInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
	FExcel=objExcel;
	FRow=2;
	objExcel.GetSheet("GroupInfo");
	var retvalue=cspRunServerMethod(encmeth,'PreGADMInfoToExcel','',Instring+'^1');
	if (""!=retvalue) { FExcel.SetSheet("GroupInfo",retvalue); }
	
	//FExcel=objExcel;
	FRow=1;
	objExcel.GetSheet("PersonList");
	var retvalue=cspRunServerMethod(encmeth,'PreGADMPersonListToExcel','',Instring+'^2');
	if (""!=retvalue) { FExcel.SetSheet("PersonList",retvalue); }

	
	//FExcel=objExcel;
	FRow=1;
	objExcel.GetSheet("FeeDetail");
	var retvalue=cspRunServerMethod(encmeth,'PreGADMFeeToExcel','',Instring+'^3');
	if (""!=retvalue) { FExcel.SetSheet("FeeDetail",retvalue); }
	
	FExcel=null;
}


// ��������ͳ�����ݵ�Excel�ļ�
function PreGADMInfoToExcel(Datas) {
	//alert(' PreGADMInfoToExcel \n'+Datas);
	var objExcel=FExcel;

	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("StationDayStatisticToExcel\n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	objExcel.Borders(iRow,2,'BOTTOM^');
	FRow=FRow+1;
}

// �����ͻ���Ϣ��Excel�ļ�
function PreGADMPersonListToExcel(Datas) {
	//alert(' PreGADMPersonListToExcel \n'+Datas);
	var objExcel=FExcel;

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

// �����ͻ�������Ϣ��Excel�ļ�
function PreGADMFeeToExcel(Datas) {
	var objExcel=FExcel;

	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("StationDayStatisticToExcel\n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
		if (''!=DayData[1]) { objExcel.Borders(iRow,iCol+1,'TOP^'); }
	}
	
	FRow=FRow+1;
}