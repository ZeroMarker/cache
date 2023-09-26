/// DHCPEInvRcptPayDetailPrint.js
/// ����ʱ��		2007.10.22
/// ������			xuwm
/// ��Ҫ����		��ӡ ����շ�Աͳ�� ���ݵ�����Excel�ļ�
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;

// �������ݵ��ļ�
function InvRcptPayDetailPrint( aBeginDate, aEndDate,aCurDate, aPayModeDesc) {
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEInvRcptPay.xls'; // ģ���ļ�
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1")     //Excel�±������
    
    
    xlsheet.cells(2, 1).value = xlsheet.cells(2, 1).value+aBeginDate+"---"+aEndDate;
    xlsheet.cells(2, 10).value = xlsheet.cells(2, 10).value+aCurDate;
	var title=xlsheet.cells(1, 1).value
	xlsheet.cells(1, 1).value=title.replace("*",aPayModeDesc)
	
	var eSrc=window.event.srcElement;
	var tbObj=document.getElementById('tDHCPEInvRcptPayDetail');	
	var rowObj = tbObj.getElementsByTagName("tr");
   if(tbObj)
   {
	  //rowNumber�����
      var str = "" ,rowNumber,columnNumber //�����
      for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
      { //rowObj[rowNumber].cells.length
      	
         for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length
;columnNumber ++ )
         {
            str=rowObj[0].cells[columnNumber].innerText;
            if (str==" ") break;
            str = rowObj[rowNumber].cells[columnNumber].innerText;
            xlsheet.cells(rowNumber+3, columnNumber).value = str;
         }
      }
   }
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
// ���õ����ļ�(����ļ���,����)
function IPDFileChange(objExcel, aBeginDate, aEndDate, aPayModeDesc) {
		objExcel.GetSheet('����');
		
		var iCol=1;
		var iRow=1;
		var headLine='���'+aPayModeDesc+'���˱�';
		objExcel.writeData(iRow, iCol, headLine);
		
		var iCol=2;
		var iRow=2;
		var headLine='��ѯ���� '+aBeginDate+' �� '+aEndDate;
		objExcel.writeData(iRow, iCol, headLine);
		//objExcel.SaveTo(DataSaveFilePath);
}
// ������ۺϲ�ѯ
var FRow=3; // 
function ImportInvRcptPayDetail(objExcel, aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDec)
{
	// objExcel.GetSheet('����');
	FExcel=objExcel;
	FRow=3;
	
	var Instring=aUserID+'^'+aBeginDate+'^'+aEndDate+'^'+aPayMode;
	var Ins=document.getElementById('InvRcptPayDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
	var value=cspRunServerMethod(encmeth,'InvRcptPayDetailToExcel', '', Instring);
	//alert("hhhh");
	//var value=cspRunServerMethod(encmeth,'', '', Instring);
	//alert("gggg");
	//alert(value);
	if (""==value) { return false; }

}

// ���������ۺϲ�ѯ���ݵ�Excel�ļ�,�� ImportPEPersonStatistic �е���
function InvRcptPayDetailToExcel(Datas) {
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("InvRcptPayDetailToExcel \n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		FExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}



