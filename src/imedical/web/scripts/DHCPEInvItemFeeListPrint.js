/// DHCPEInvItemFeeListPrint.js
/// ����ʱ��		2007.10.23
/// ������			xuwm
/// ��Ҫ����		��ӡ �������嵥 ���ݵ�����Excel�ļ�
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;

// �������ݵ��ļ�
function InvItemFeeListPrint(aInvRptDR) {
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPETarIemDetail.xls'; // ģ���ļ�
	}else{
		alert("��Чģ��·��");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var info=tkMakeServerCall("web.DHCPE.InvPrt","GetTarItemInfo",aInvRptDR);
	var Char_2=String.fromCharCode(2);
	var Char_1=String.fromCharCode(1);
	var infoArr=info.split(Char_2);
	var baseInfo=infoArr[0];
	var tarItemInfo=infoArr[1];
	var baseArr=baseInfo.split("^");
	xlsheet.cells(2,1).Value=xlsheet.cells(2,1).Value+baseArr[0];
	xlsheet.cells(2,4).Value=xlsheet.cells(2,4).Value+baseArr[1];
	tarItemArr=tarItemInfo.split(Char_1);
	var i=tarItemArr.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++){
		oneTarItem=tarItemArr[iLLoop];
		oneArr=oneTarItem.split("^");
		xlsheet.cells(4+iLLoop,1).value=oneArr[0];
		xlsheet.cells(4+iLLoop,2).value=oneArr[1];
		xlsheet.cells(4+iLLoop,3).value=oneArr[2];
		xlsheet.cells(4+iLLoop,4).value=oneArr[3];
		xlsheet.cells(4+iLLoop,5).value=oneArr[4];
		xlsheet.cells(4+iLLoop,6).value=oneArr[5];

	}
	//xlsheet.SaveAs("d:\\test.xls");
    	//xlApp.Visible = true;
   //	xlApp.UserControl = true;
	//xlsheet.saveas("d:\\aa.xls")
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
function IIFLFileChange(objExcel, aInvRptDR) {
		objExcel.GetSheet('��Ʊ�嵥');
		//objExcel.SaveTo('d:\sss.xls');
}
// ������ۺϲ�ѯ
var FRow=5; // 
function ImportInvItemFeeList(objExcel, aInvRptDR)
{
	// objExcel.GetSheet('����');
	FExcel=objExcel;
	FRow=5;
	FExcel.GetSheet('��Ʊ�嵥');
	var Instring=aInvRptDR;
	var Ins=document.getElementById('InvItemFeeListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'InvPatInfoToExcel^InvItemFeeListToExcel', '', Instring);
	if (""==value) { return false; }

}
// ����ͻ���Ϣ���ݵ�Excel�ļ�,�� ImportInvItemFeeList �е���
function InvPatInfoToExcel(Datas) {
	var DayData=null;
	DayData=Datas.split("^");
	var iRow=0,iCol=0;
	
	iRow=2;
	iCol=2;
	if (DayData[0]) FExcel.writeData(iRow, iCol, DayData[1]);
	
	iRow=2;
	iCol=4;
	if (DayData[1]) FExcel.writeData(iRow, iCol, DayData[0]);
		
	iRow=3;
	iCol=2;
	if (DayData[2]) FExcel.writeData(iRow, iCol, DayData[2]);
	
	
}

// ������������ݵ�Excel�ļ�,�� ImportInvItemFeeList �е���
function InvItemFeeListToExcel(Datas) {
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



