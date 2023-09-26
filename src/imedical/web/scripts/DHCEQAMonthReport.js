//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	InitPage();	//��ʼ��
	//KeyUp("Loc","N");	//���ѡ��	
	Muilt_LookUp("Loc");
}

function InitPage() //��ʼ��
{
	var obj=document.getElementById("BPrint");
	//if (obj) obj.onclick=BPrint_Click;
	if (obj) obj.onclick=BPrintNew_Click;
	var obj=document.getElementById("StartMonth");
	if (obj) obj.onchange=StartMonth_Change;
	var obj=document.getElementById("EndMonth");
	if (obj) obj.onchange=EndMonth_Change;
}

function BPrint_Click()
{
	///Ԫ��?GetRepPath?GetReportData
	var templateName="DHCEQAMonthReport.xls";
	var isSave=1;
	var isSave=0;	//��ӡ
	var savefilename="";
	if (isSave==1) savefilename=GetFileName();
	///locdesc_"^"_AccessoryTypedesc_"^"_deprefee
	//var colset="1:1^2:2^3:0^4:3";///��x1:��������y1λ^��x2:��������y2λ.....
	//var colset="1:4^2:0^3:5^4:6^5:2^6:9^7:10^8:11^9:10^10:13^11:14";///��x1:��������y1λ^��x2:��������y2λ.....
	var colset="1:4^2:6^3:0^4:1^5:2^6:3";///��x1:��������y1λ^��x2:��������y2λ.....
	PrintEQReport(templateName,isSave,savefilename,colset);
}

function PrintEQReportHeader(xlsheet)
{
	var row=2;	
	xlsheet.cells(row,1)="�����·�:"+GetElementValue("StartMonth")	//+"��"+GetElementValue("EndMonth");
	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	row=row+1;
	return row;
}

function GetReportData(num)
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneReportInfo");
	var rtn=cspRunServerMethod(encmeth,num,TJob);
	return rtn;
}

function PrintEQReportFooter(xlsheet,row)
{
	///���һ����Ӵ���
	xlsheet.cells(row+4,3)="������:"
	xlsheet.cells(row+4,5)="������:"
}

function StartMonth_Change()
{
	CheckMonth("StartMonth");
}

function EndMonth_Change()
{
	CheckMonth("EndMonth");
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}
function CheckMonth(StrName)
{
	var MonthStr=GetElementValue(StrName);
	var encmeth=GetElementValue("IsMonth");
	var IsMonth=cspRunServerMethod(encmeth,MonthStr);
	if (IsMonth=="1")
	{		
		alertShow(t["01"]);
		SetFocus(StrName);
		return;
	}
}
function GetFundsType(value) // ItemDR
{
	var obj=document.getElementById("FundsTypeDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function BPrintNew_Click()
{
	try {
        var xlApp,xlsheet,xlBook;
		var PrintInfo=GetReportData(1);
		//alertShow(PrintInfo)
	    var Template=GetElementValue("GetRepPath")+"DHCEQAMonthReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.TopMargin=0;
	    
	    //ҽԺ�����滻 Add By DJ 2011-07-14
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
		xlsheet.cells(2,1)="�����·�:"+GetElementValue("StartMonth")	//+"��"+GetElementValue("EndMonth");
		
		var List=PrintInfo.split("^");
		xlsheet.cells(4,1)=List[4];
		//xlsheet.cells(4,2)=List[1];
		xlsheet.cells(4,3)=List[0];
		xlsheet.cells(4,4)=List[1];
		xlsheet.cells(4,5)=List[2];
		xlsheet.cells(4,6)=List[3];
		
		PrintEQReportFooter(xlsheet,4);
	    
	    //xlsheet.cells(PageRows+5,8)="�Ƶ���:"+lista[sort+2];
	    //xlsheet.cells(PageRows+5,7)="����:"+ChangeDateFormat(lista[4]);
	    //xlsheet.cells(15,9)=username; //�Ƶ���
	    //xlsheet.cells(12,7)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";   //ʱ��
	    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    
	    xlsheet.printout; //��ӡ���
	    //xlBook.SaveAs("D:\\StoreMove"+i+".xls");
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
	    
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
