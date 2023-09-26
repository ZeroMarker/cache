/// DHCPEInvRcptPayDetailPrint.js
/// ����ʱ��		2007.10.26
/// ������			xuwm
/// ��Ҫ����		��ӡ ����շ�Աͳ�� ���ݵ�����Excel�ļ�
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;

// �������ݵ��ļ�
function InvRcptPayDetailPrint(aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDesc) {
	//alert('InvRcptPayDetailPrint');
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPInvRcptPayPrint.xls'; // ģ���ļ�
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	var objExcel= new DHCPEExcel(Templatefilepath,false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		IPDFileChange(objExcel, aBeginDate, aEndDate, aPayModeDesc);
		
		// ��������
		ImportInvRcptPayDetail(objExcel, aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDesc);
		
		var IsPreview=false;
		objExcel.SetPrintArea('$A$1:$H$'+(FRow-1)); //
		objExcel.Print(IsPreview); //��Ԥ��
		objExcel.Colse(false); // ������
	}

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



