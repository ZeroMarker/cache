/// DHCPEIllnessCollectImport.js

///��켲�����ܲ�ѯ ���ݵ�����Excel�ļ�

var FExcel;

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

// ������ۺϲ�ѯ����
function IllnessCollectImport(DataSaveFilePath) {
	//alert('IllnessCollectImport');
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEIllnessCollect.xls'; // ����ۺϲ�ѯ����
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		ISFileChange(objExcel,DataSaveFilePath);
		
		// ������ۺϲ�ѯ
		ImportIllnessCollect(objExcel);
		objExcel.Colse(true);
		objExcel=null;
		alert("���ݵ������");

	}

}
// ���õ����ļ�(����ļ���,����)
function ISFileChange(objExcel,DataSaveFilePath) {
		//var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		//var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		//objExcel.GetSheet('����');
		//var iCol=1;
		//var iRow=1;
		//objExcel.writeData(iRow, iCol, importMonth+"�·��������ҵ���������");
		objExcel.SaveTo(DataSaveFilePath);
}

// ������ۺϲ�ѯ
var FRow=2; // 
var OldSheetName='';
function ImportIllnessCollect(objExcel) {
	//alert(ImportIllnessCollect);
	FExcel=objExcel;
	FRow=2;
	var Instring='';
	OldSheetName='';
	var obj=document.getElementById('DSJ');
	if (obj) { Instring=obj.value; }
	var Ins=document.getElementById('IllnessCollectBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'IllnessCollectToExcel','','0')	
	if (""==value) { return false; }
	OldSheetName='';
}

// ���������ۺϲ�ѯ���ݵ�Excel�ļ�,�� ImportPEPersonStatistic �е���
function IllnessCollectToExcel(SheetName,Datas) {
	//alert(SheetName+'\n'+Datas);
	//return ;
	var objExcel=FExcel;
	if (OldSheetName!=SheetName) 
	{
		objExcel.GetSheet(SheetName);
		OldSheetName=SheetName;
	}
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


