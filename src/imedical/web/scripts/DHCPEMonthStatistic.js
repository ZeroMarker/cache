/// DHCPEMonthStatistic.js
/// ����ʱ��		2007.07.13
/// ������			xuwm
/// ��Ҫ����		��ͳ�Ʋ�ѯ
/// ���			DHCPEMonthStatistic
/// ��Ӧ��			
/// ����޸�ʱ��	
/// ����޸���		

var CurrentSel=0;

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("btnImportMonthStatistic")
	if (obj) { obj.onclick=ImportMonthStatistic_click; }

	obj=document.getElementById("btnImportSalerStatistic")
	if (obj) { obj.onclick=ImportSalerStatistic_click; }
	
	obj=document.getElementById("Find")
	if (obj) { obj.onclick=Find_click; }
	
	obj=document.getElementById('ImportDate');
	if (obj) {
		obj.onchange = ImportDate_change;
	}
	
	iniForm();

}

function BodyUnLoadHandler() {

	var obj;

}

function iniForm() {
	var obj;

	var now= new Date();
	obj=document.getElementById("ImportDate")
	if (obj && ""==obj.value) {
		//obj.value=now.getYear()+"-"+(now.getMonth()+1);
		obj.value=now.getFullYear()+"-"+(now.getMonth()+1);
	}
	var ImportDate=obj.value.split("-");
	
	if (ImportDate.length>1 && IsFloat(ImportDate[1])) {
		var Month=ImportDate[1];
		if ((Month<0)||(Month>12)) { return false;}
		
		obj=document.getElementById("MonthStatisticSavePath")
		if (obj) { obj.value='D:\\'+Month+"�·�����.xls"; }
		
		obj=document.getElementById("SalerStatisticSavePath")
		if (obj) { obj.value='D:\\'+Month+"�·�ҵ���ܻ�.xls"; }
		
		
	}

}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function ImportDate_change() {
	var obj;
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		var ImportDate=obj.value.split("-");
		
		if (ImportDate.length>1 && IsFloat(ImportDate[1])) {
			var Month=ImportDate[1];
			if ((Month<0)||(Month>12)) { return false;}
			
			obj=document.getElementById("MonthStatisticSavePath")
			if (obj) { obj.value='D:\\'+Month+"�·�����.xls"; }

			obj=document.getElementById("SalerStatisticSavePath")
			if (obj) { obj.value='D:\\'+Month+"�·�ҵ���ܻ�.xls"; }
			
		}
		
		
	}
	
}
function Find_click(){
	var ImportDate="",StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ImportDate")
	if(""==obj.value){
		alert("������Ҫ��ѯ���·�");
		return false
		}

	if (obj && ""!=obj.value) {
		ImportDate=obj.value.split("-");
		if (ImportDate.length>1 && IsFloat(ImportDate[1])) {

			if ((ImportDate[1]<1)||(ImportDate[1]>12)) { return false;}
			//ImportDate=ImportDate+"^"+StartDate+"^"+EndDate;
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEMonthStatistic"
					+"&ImportDate="+"01/"+ImportDate[1]+"/"+ImportDate[0]+"&StartDate="+StartDate+"&EndDate="+EndDate;
				;
			location.href=lnk;			
		
		}
		else { return false; }
		
	}

}
/*
// ��ͳ������
function ImportMonthStatistic_click() {
	var obj;
	
	var SaveFilePath='';
	var ImportDate="",StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}

	obj=document.getElementById("MonthStatisticSavePath")
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }
	ImportDate=ImportDate+"^"+StartDate+"^"+EndDate;
	//alert("ImportMonthStatistic_click")
	MonthStatisticImport(ImportDate,SaveFilePath); // DHCPEMonthStatisticImport.js
	
}
*/


// ��ͳ������
function ImportMonthStatistic_click() {
	var obj;
	var ImportDate="",StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ImportDate")
	if(""==obj.value){
		alert("�������·�")
		return false
		
		}

	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}

	ImportDate=ImportDate+"^"+StartDate+"^"+EndDate

    obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEMonthStatistic.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet1= xlBook.WorkSheets("����"); //Excel�±������
	xlsheet2= xlBook.WorkSheets("�·�����ͳ��"); //Excel�±������
	xlsheet3= xlBook.WorkSheets("���Ҽ���"); //Excel�±������
	xlsheet4= xlBook.WorkSheets("��Ŀ����"); //Excel�±������
	xlsheet5= xlBook.WorkSheets("Sheet2"); //Excel�±������
	xlsheet6= xlBook.WorkSheets("ҽ������"); //Excel�±������
	

	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.Report.MonthStatistic.MonthDataImport"))
	var Ins=document.getElementById('MonthStatisticBox');
	if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; }
	
	//ÿ�������Ա��Ϣ����
	var retvalue=cspRunServerMethod(encmeth,'','',ImportDate)
	var Rows=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","GetMonthStatisticRows")
	for (var i=0;i<Rows;i++)
	{
		var Datas=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","GetMonthStatisticInfo",i+1)
		DayData=Datas.split("^");
		for (var j=0;j<DayData.length;j++) 
		{
		xlsheet1.cells(i+5,j+1).value=DayData[j];
		
	}
	} 
	
	
	var ColCount=16; // ��������
	var DayDatas=retvalue.split(";")
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		
		DayData=DayDatas[iDayLoop].split("^");
		Num=parseInt(DayData[0],10); 
		iRow=((Num-1) % ColCount)+5;
		iCol=(parseInt((Num-1) / ColCount))*2+1; 
		mDay=DayData[1]; 
		xlsheet2.cells(iRow, iCol).value=mDay
		mAumont=parseFloat(DayData[2]);
		xlsheet2.cells(iRow, iCol+1).value=mAumont
		
	}
	var Ins=document.getElementById('StationStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',ImportDate)
	var DayDatas=value.split(";")
	var iCol=1,iRow=1;
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		iRow=iDayLoop+21;
		mDay=1;
		xlsheet2.cells(iRow,iCol).value=DayDatas[iDayLoop];
	}
	
	//���Ҽ���
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.Report.StationWorkStatistic.StationDayStatisticImport"))
	var Ins=document.getElementById('StationDayStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',ImportDate) 
	var Datas=value.split(";");
    for (var iRow=0;iRow<Datas.length;iRow++) {
	 var DayData=Datas[iRow].split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) { 
		xlsheet3.cells(iRow+1, iCol+1).value=DayData[iCol];
		 }
	}
    }
	
	//ҽ������
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.Report.DoctorWorkStatistic.DayDoctorWorkStatisticImport"))
	var Ins=document.getElementById('DayDoctorWorkStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',ImportDate)
	var Datas=value.split(";");
    for (var iRow=0;iRow<Datas.length;iRow++) {
	DayData=Datas[iRow].split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) { 
		xlsheet6.cells(iCol+1,iRow+1).value=DayData[iCol];
		 }
		
	}
    }
    
	//��Ŀ����
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.Report.OEItemStatus.OEItemDayStatisticImport"))
	var Ins=document.getElementById('DayOEItemWorkStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=""
	var value=cspRunServerMethod(encmeth,'','',ImportDate) 
	var Datas=value.split(";");
	
    for (var iRow=0;iRow<Datas.length;iRow++) {
	DayData=Datas[iRow].split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) {
			xlsheet4.cells(iRow+1,iCol+1).value=DayData[iCol];
			  
			 }
	
	}
    }
    
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet1 = null;
	xlsheet2 = null;
	xlsheet3 = null;
	xlsheet4 = null;
	xlsheet5 = null;
	xlsheet6 = null;

}

/*
// ҵ��Աҵ�����
function ImportSalerStatistic_click() {
	var obj;
	
	var SaveFilePath='';
	var ImportDate="",StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}
	ImportDate=ImportDate+"^"+StartDate+"^"+EndDate;
	obj=document.getElementById("SalerStatisticSavePath")
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }
	//alert('ImportSalerStatistic_click 1 ');
	SalerStatisticImport(ImportDate,SaveFilePath); // DHCPESalerStatisticImport.js
	//alert('ImportSalerStatistic_click 1 ');
}
*/
// ҵ��Աҵ�����
function ImportSalerStatistic_click() {
	var obj;
	
	var ImportDate="",StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ImportDate")
	if(""==obj.value){
		alert("�������·�")
		return false
	}

	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}
	ImportDate=ImportDate+"^"+StartDate+"^"+EndDate;
	
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPESalerStatistic.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet= xlBook.WorkSheets("����"); //Excel�±������
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.Report.SalerStatistic.SalerStatisticImport"))
	var Ins=document.getElementById('SalerStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',ImportDate)
    if (value=="��������ȷ������") {
		alert("��������ȷ������");
		return false; 
	}
	if (""==value) { return false; }
	
	var Datas=value.split(";");
	for (var i=0;i<Datas.length;i++)
	{
		DayData=Datas[i].split("^");
		for (var j=0;j<DayData.length;j++) 
		{
		xlsheet.cells(i+3,j+1).value=DayData[j];
		
	}
	}
	

	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

document.body.onload = BodyLoadHandler;