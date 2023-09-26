/// DHCPEPersonStatisticImport.js
/// ����ʱ��		2007.08.30
/// ������			xuwm
/// ��Ҫ����		����ۺϲ�ѯ ���ݵ�����Excel�ļ�
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

// ��������
function PersonStatisticImport(DataSaveFilePath) {

	var obj;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPersonStatistic.xls'; // ģ���ļ�
		
	}else{
		alert("��Чģ��·��");
		return;
	}
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		PSFileChange(objExcel,DataSaveFilePath);
		// ������ۺϲ�ѯ
		ImportPEPersonStatistic(objExcel);
		objExcel.Colse(true);
		objExcel=null;
		alert("���ݵ������");
	}

}
// ���õ����ļ�(����ļ���,����)
function PSFileChange(objExcel,DataSaveFilePath) {
		//var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		//var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		objExcel.GetSheet('����');
		//var iCol=1;
		//var iRow=1;
		//objExcel.writeData(iRow, iCol, importMonth+"�·��������ҵ���������");
		objExcel.SaveTo(DataSaveFilePath);
		
}
function EndDate(){
   var d,  s="";    // ����������
   d = new Date();                                    
   s += d.getDate() + "/";                            
   s += (d.getMonth() + 1)+ "/"; 
   s += d.getYear()
             
   return(s);                               
}
// ������ۺϲ�ѯ
var FRow=4; // 
function ImportPEPersonStatistic(objExcel) {
	objExcel.GetSheet("����");
	FExcel=objExcel;

	var iBeginDate=document.getElementById('PEBeginDate').value;
	var iEndDate=document.getElementById('PEEndDate').value;
    if (iEndDate=="")
	{ iEndDate=EndDate()}
   
   //var iEndDate=iEndDate.split("/")[2]+"-"+iEndDate.split("/")[1]+"-"+iEndDate.split("/")[0]; 
   //if (iBeginDate!="") {iBeginDate=iBeginDate.split("/")[2]+"-"+iBeginDate.split("/")[1]+"-"+iBeginDate.split("/")[0];}
   //if (iBeginDate=="") 
    //{iBeginDate=document.getElementById('PESystemStartDate').value;}
  
	FExcel.writeData(1, 2, iBeginDate);
	FExcel.writeData(2, 2, iEndDate);
	
	var Ins=document.getElementById('PEPersonStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'PEPersonStatisticToExcel','','');
	if (""==value) { return false; }
	FExcel=null;
}

// ���������ۺϲ�ѯ���ݵ�Excel�ļ�,�� ImportPEPersonStatistic �е���
function PEPersonStatisticToExcel(Datas) {
	var DayData=null;	
	var iCol=0, iRow=FRow;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		FExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}


/*
// ������ۺϲ�ѯ
var FRow=2; // 
function ImportPEPersonStatistic(objExcel) {
	FExcel=objExcel;
	var iRow=0;
	var Data='';
	var SelRowObj;
	var obj;
		
	obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);
	if (objtbl) { var rows=objtbl.rows.length; }
	//var lastrowindex=rows - 1;
	for (iRow=1;iRow<rows;iRow++) {
		Data='';
		
		// �ǼǺ�
		SelRowObj=document.getElementById('PA_RegNo'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}
		
		// ����
		SelRowObj=document.getElementById('PA_Name'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}
		
		// �Ǽ�����
		SelRowObj=document.getElementById('PA_AdmDate'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ״̬
		SelRowObj=document.getElementById('PA_Status'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ����״̬
		SelRowObj=document.getElementById('PA_ReportStatus'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// Ӧ�ս��
		SelRowObj=document.getElementById('PA_AccountAmount'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// �Żݽ��
		SelRowObj=document.getElementById('PA_DiscountedAmount'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ���ս��
		SelRowObj=document.getElementById('PA_Payed'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// δ�ս��
		SelRowObj=document.getElementById('PA_UnPayed'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ����
		SelRowObj=document.getElementById('PA_ADMNo'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ��λ
		SelRowObj=document.getElementById('PA_Company'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ����
		SelRowObj=document.getElementById('PA_GDesc'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// ҵ��Ա
		SelRowObj=document.getElementById('PA_Saler'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}


		PEPersonStatisticToExcel(Data,iRow+1)
	}
	
}

// ���������ۺϲ�ѯ���ݵ�Excel�ļ�,�� ImportPEPersonStatistic �е���
function PEPersonStatisticToExcel(Datas,iRow) {
	var objExcel=FExcel;
	objExcel.GetSheet("����");
	var DayData=null;
	var iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
}

*/
