/// DHCEQEquipRentPrint.js
/// �������޵ǼǱ��ӡ
function BEquipRentPrint(RowID)
{
	if (RowID=="") return;
	var encmeth=GetElementValue("fillData");////2276482 Modify By BRB �޸�fillData��Сд2016-11-16	
	if (encmeth=="") return;
	var RentData=cspRunServerMethod(encmeth,RowID);
	RentData=RentData.replace(/\\n/g,"\n");
	var list=RentData.split("^");
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	//alertShow(RentData)
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQEquipRent.xls";
	    xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.TopMargin=0;
	    //alertShow(list[52])
	    ///add by lmm 2017-04-06
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    
		xlsheet.cells(2,3)=list[0];
		xlsheet.cells(3,3)=list[50];   //���޿���
	    xlsheet.cells(3,7)=list[98];   //��ϵ�绰
		xlsheet.cells(4,3)=list[57];   //��Ʒ����
	    xlsheet.cells(4,5)=list[96];   //������
		xlsheet.cells(4,7)=list[97];   //�������
	    
	    xlsheet.cells(14,3)=strToDate(list[58]+" "+list[59]);  //��������
	    //xlsheet.cells(14,5)=list[52];  //������
	    //xlsheet.cells(14,7)=list[63];  //������
	    xlsheet.cells(15,3)=strToDate(list[70]+" "+list[71]);  //
	    
	    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    var size=obj.GetPaperInfo("letter");
	    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    xlsheet.printout; //��ӡ���
	    xlBook.Close (savechanges=false);	    
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	}
	catch(e)
	{
		alertShow(e.message);
	}
	xlApp=null;
}
// add by zx 2016-07-04
// ʱ��ת��
//Modified  by wy 2017-5-25 ����ϵͳʱ���ʽ��ת��
function strToDate(str) {
	var tempStrs = str.split(" ");
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat")  
	if ((SysDateFormat=="")||(SysDateFormat=="4"))
	{ 
	  var dateStrs = tempStrs[0].split("/");
	  var year = parseInt(dateStrs[2], 10);
	  var month = parseInt(dateStrs[1], 10) ;
	  var day = parseInt(dateStrs[0], 10);   
	} 
	if (SysDateFormat=="1")
	{
	    
	  var dateStrs = tempStrs[0].split("/");
	  var year = parseInt(dateStrs[2], 10);
	  var month = parseInt(dateStrs[0], 10) ;
	  var day = parseInt(dateStrs[1], 10);   
	}
	if (SysDateFormat=="3")
	{
	  var dateStrs = tempStrs[0].split("-");
	  var year = parseInt(dateStrs[0], 10);
	  var month = parseInt(dateStrs[1], 10) ;
	  var day = parseInt(dateStrs[2], 10);    
	
	}
	var timeStrs = tempStrs[1].split(":");
	var hour = parseInt(timeStrs [0], 10);
	var minute = parseInt(timeStrs[1], 10) ;
	var second = parseInt(timeStrs[2], 10);
	if(isNaN(year))
	{
		year="    ";
	}
	if(isNaN(month))
	{
		month="    ";
	}
	if(isNaN(day))
	{
		day="    ";
	}
	if(isNaN(hour))
	{
		hour="    ";
	}
	var date = year+"��"+month+"��"+day+"��"+hour+"ʱ"
	return date;
}