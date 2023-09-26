var TemplatePath;
var TJob;
var BeginDate;
var EndDate;

function InitReportCommon()
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Clicked;
	BeginDate=GetElementValue("BeginDate");
	EndDate=GetElementValue("EndDate");
	MonthStr=GetElementValue("MonthStr");
	StartMonth=GetElementValue("StartMonth");
	EndMonth=GetElementValue("EndMonth");
}

function BPrint_Clicked()
{
	PrintExcel("0");
}

function BExport_Clicked()
{
	PrintExcel("1");	
}

function PrintExcel(isExport)
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	TemplatePath=cspRunServerMethod(encmeth);
	var ComponentName=GetElementValue("ComponentName");
	var objtbl=document.getElementById('t'+ComponentName);
	var rows=objtbl.rows.length;
	if (rows<2)
	{
		alertShow(t['nodata']);
		return;
	}
	TJob=GetElementValue("TJobz1");
	if (ComponentName=="DHCEQSAssetDeal")
	{
		AssetDeal(isExport);
	}
	else if (ComponentName=="DHCEQSAssetComposite")
	{
		AssetComposite(isExport);
	}
	else if (ComponentName=="DHCEQSAssetCount")
	{
		AssetCount(isExport);
	}
	else if (ComponentName=="DHCEQSDepreDetail")
	{
		DepreDetail(isExport);
	}
	else if (ComponentName=="DHCEQSDepreCat")
	{
		DepreCat(isExport);
	}
	else if (ComponentName=="DHCEQSDepreLoc")
	{
		DepreLoc(isExport);
	}
	else if (ComponentName=="DHCEQSMonthReport")
	{
		MonthReport(isExport);
	}
	else if (ComponentName=="DHCEQSMonthReportFunds")
	{
		MonthReportFunds(isExport);		//2014-01-03  Mozy0115
	}
}

///�ʲ����������
function AssetDeal(isExport)
{
	var Node="ReportEx.AssetDeal";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
		//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TDealType_"^"_TEqNo_"^"_TEquipName_"^"_TModel_"^"_TStartDate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreTotal_"^"_TDealFee_"^"_TRemainIncome_"^"_TUseMonths_"^"_TRemainMonths_"^"_TDealDate_"^"_TDealReason
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSAssetDeal.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
				//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TDealType_"^"_TEqNo_"^"_TEquipName_"^"_TModel_"^"_TStartDate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreTotal_"^"_TDealFee_"^"_TRemainIncome_"^"_TUseMonths_"^"_TRemainMonths_"^"_TDealDate_"^"_TDealReason
		    	xlsheet.cells(j,col++)=OneDetailList[2];	//TEquiCat
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//TDealType
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//TEqNo
		    	xlsheet.cells(j,col++)=OneDetailList[5];	//TEquipName
		    	xlsheet.cells(j,col++)=OneDetailList[6];	//TModel
		    	xlsheet.cells(j,col++)=OneDetailList[7];	//TStartDate
		    	xlsheet.cells(j,col++)=OneDetailList[8];	//TQuantity
		    	xlsheet.cells(j,col++)=OneDetailList[9];	//TOriginalFee
		    	xlsheet.cells(j,col++)=OneDetailList[10];	//TDepreTotal
		    	//xlsheet.cells(j,col++)=OneDetailList[11];	//TDealFee
		    	//xlsheet.cells(j,col++)=OneDetailList[12];	//TRemainIncome
		    	xlsheet.cells(j,col++)=OneDetailList[13];	//TUseMonths
		    	xlsheet.cells(j,col++)=OneDetailList[14];	//TRemainMonths
		    	xlsheet.cells(j,col++)=OneDetailList[15];	//TDealDate
		    	xlsheet.cells(j,col++)=OneDetailList[16];	//TDealReason		    	
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

///�ʲ����ɷ�����
function AssetComposite(isExport)
{
	var Node="ReportEx.AssetComposite";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
		//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TEqNo_"^"_TEquipName_"^"_TModel_"^"_TStartDate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSAssetComposite.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1)+GetElementValue("GetCurDate");
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
				//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TDealType_"^"_TEqNo_"^"_TEquipName_"^"_TModel_"^"_TStartDate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreTotal_"^"_TDealFee_"^"_TRemainIncome_"^"_TUseMonths_"^"_TRemainMonths_"^"_TDealDate_"^"_TDealReason
		    	xlsheet.cells(j,col++)=OneDetailList[2];	//TEquiCat
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//TEqNo
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//TEquipName
		    	//xlsheet.cells(j,col++)=OneDetailList[5];	//TModel
		    	//xlsheet.cells(j,col++)=OneDetailList[6];	//TStartDate
		    	xlsheet.cells(j,col++)=OneDetailList[7];	//TQuantity
		    	xlsheet.cells(j,col++)=OneDetailList[8];	//TOriginalFee
		    	xlsheet.cells(j,col++)=OneDetailList[9];	//TDepreTotal
		    	xlsheet.cells(j,col++)=OneDetailList[10];	//TNetFee		    	
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

///�ʲ�����ͳ�Ʊ�
function AssetCount(isExport)
{
	var Node="ReportEx.AssetCount";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
		//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TEqNo_"^"_TEquipName_"^"_TModel_"^"_TStartDate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSAssetCount.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+GetElementValue("GetCurDate");
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
				//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TQuantity_"^"_TOriginalFee_"^"_TJob
		    	xlsheet.cells(j,col++)=OneDetailList[2];	//TEquiCat
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//TQuantity
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//TOriginalFee	    	
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

///�ʲ��۾���ϸ��
function DepreDetail(isExport)
{
	var Node="ReportEx.DepreDetail";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		//   0            1             2            3             4            5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
		//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TDealType_"^"_TEqNo_"^"_TEquipName_"^"_TModel_"^"_TStartDate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreTotal_"^"_TDealFee_"^"_TRemainIncome_"^"_TUseMonths_"^"_TRemainMonths_"^"_TDealDate_"^"_TDealReason
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSDepreDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//   0            1             2            3             4            5             6               7               8             9              10            11              12               13             14              15                16             17          18         19            20              
				//TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TEqNo_"^"_TEquipName_"^"_TUseMonths_"^"_TUsedMonths_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//TEqNo
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//TEquipName
		    	xlsheet.cells(j,col++)=OneDetailList[5];	//TUseMonths
		    	xlsheet.cells(j,col++)=OneDetailList[6];	//TUsedMonths
		    	xlsheet.cells(j,col++)=OneDetailList[7];	//TDepreRate
		    	xlsheet.cells(j,col++)=OneDetailList[8];	//TQuantity
		    	xlsheet.cells(j,col++)=OneDetailList[9];	//TOriginalFee
		    	xlsheet.cells(j,col++)=OneDetailList[10];	//TDepreFee
		    	xlsheet.cells(j,col++)=OneDetailList[11];	//TDepreYearFee
		    	xlsheet.cells(j,col++)=OneDetailList[12];	//TDepreTotal
		    	xlsheet.cells(j,col++)=OneDetailList[13];	//TNetFee
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

///�ʲ��۾ɷ����
function DepreCat(isExport)
{
	var Node="ReportEx.DepreCat";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		//    0             1             2             3                4                 5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
		//TEquipType_"^"_TEquiCat_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSDepreCat.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//    0             1             2             3                4                 5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
				//TEquipType_"^"_TEquiCat_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
		    	xlsheet.cells(j,col++)=OneDetailList[0];	//TEquipType
		    	xlsheet.cells(j,col++)=OneDetailList[1];	//TEquiCat
		    	xlsheet.cells(j,col++)=OneDetailList[2];	//TQuantity
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//TOriginalFee
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//TDepreFee
		    	xlsheet.cells(j,col++)=OneDetailList[5];	//TDepreYearFee
		    	xlsheet.cells(j,col++)=OneDetailList[6];	//TDepreTotal
		    	xlsheet.cells(j,col++)=OneDetailList[7];	//TNetFee
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

///�ʲ��۾ɿ��ұ�
function DepreLoc(isExport)
{
	var Node="ReportEx.DepreLoc";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		//    0             1             2             3                4                 5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
		//TStoreLoc_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSDepreLoc.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//    0             1             2             3                4                 5           6             7               8             9              10            11              12               13             14              15                16             17          18         19            20              
				//TEquipType_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
		    	xlsheet.cells(j,col++)=GetShortName(OneDetailList[0],"-");	//TStoreLoc
		    	xlsheet.cells(j,col++)=OneDetailList[1];	//TQuantity
		    	xlsheet.cells(j,col++)=OneDetailList[2];	//TOriginalFee
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//TDepreFee
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//TDepreYearFee
		    	xlsheet.cells(j,col++)=OneDetailList[5];	//TDepreTotal
		    	xlsheet.cells(j,col++)=OneDetailList[6];	//TNetFee
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

///�䶯�½��
function MonthReport(isExport)
{
	var Node="Report.MonthReport";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	MonthStr=StartMonth;
	if (EndMonth!="") MonthStr=MonthStr+"--"+EndMonth;
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSMonthReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//ҽԺ�����滻 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//    0             1             2             3             4               5                6             7               8             9           10            11              12          13             14           15           16           17          18           19            20              
				//StatCat_"^"_StatCatDesc_"^"_StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_StartDate_"^"_EndDate_"^"_MonthStr_"^"_TotalEnd_"^"_ChangeAccount
				//OriginDesc_"^"_EquipTypeDesc_"^"_$J_"^"_TotalDepre_"^"_Depre_"^"_StockDisused_"^"_StoreMoveIn_"^"_StoreMoveOut
		    	xlsheet.cells(j,col++)=OneDetailList[22];	//EquipType
		    	xlsheet.cells(j,col++)=parseFloat(OneDetailList[2])+parseFloat(OneDetailList[9]);	//StockBegin+UsedBegin
		    	xlsheet.cells(j,col++)=OneDetailList[3];	//StockIn
		    	xlsheet.cells(j,col++)=OneDetailList[4];	//StockReturn
		    	xlsheet.cells(j,col++)=OneDetailList[14];	//Disused
		    	xlsheet.cells(j,col++)=OneDetailList[5];	//StockReduce		    	
		    	xlsheet.cells(j,col++)=OneDetailList[20];	//ChangeAccount
		    	xlsheet.cells(j,col++)=OneDetailList[19];	//TotalEnd
		    	
		    	xlsheet.cells(j,col++)=OneDetailList[25];	//Depre
		    	xlsheet.cells(j,col++)=OneDetailList[24];	//TotalDepre
		    	xlsheet.cells(j,col++)=parseFloat(OneDetailList[19])-parseFloat(OneDetailList[24]);	//TotalEnd-TotalDepre
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
			}
			else
			{	xlsheet.printout;	} //��ӡ���
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
/// 2014-01-03  Mozy0115
/// �䶯����(�ʽ���Դ)
function MonthReportFunds(isExport)
{
	var Node="Report.MonthReportFunds";
	var encmeth=GetElementValue("GetTempDataRows");
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	MonthStr=StartMonth;
	if (EndMonth!="") MonthStr=MonthStr+"--"+EndMonth;
	//alertShow(MonthStr)
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSMonthReportFunds.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k;
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	//alertShow(OneDetail);
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	var col=0;
		    	//EquipType_"^"_EquipTypeDesc_"^"_StatCat_"^"_StatCatDesc_"^"_ListInfo
		    	xlsheet.cells(j,col+1)=OneDetailList[1];	//��������
		    	xlsheet.cells(j,col+2)=OneDetailList[3];	//�������
		    	xlsheet.cells(j,col+3)=OneDetailList[4];	//�ڳ�(�Գ�)
		    	xlsheet.cells(j,col+4)=OneDetailList[10];	//�ڳ�(����)
		    	xlsheet.cells(j,col+5)=OneDetailList[16];	//�ڳ�(�ƽ�)
		    	xlsheet.cells(j,col+6)=OneDetailList[22];	//�ڳ�(С��)
		    	
		    	xlsheet.cells(j,col+7)=OneDetailList[5];	//��������(�Գ�)
		    	xlsheet.cells(j,col+8)=OneDetailList[11];	//��������(����)
		    	xlsheet.cells(j,col+9)=OneDetailList[17];	//��������(�ƽ�)
		       	xlsheet.cells(j,col+10)=OneDetailList[23];	//��������(С��)
		       	
		    	xlsheet.cells(j,col+11)=OneDetailList[7];	//��ĩ(�Գ�)
		    	xlsheet.cells(j,col+12)=OneDetailList[13];	//��ĩ(����)
		    	xlsheet.cells(j,col+13)=OneDetailList[19];	//��ĩ(�ƽ�)
		    	xlsheet.cells(j,col+14)=OneDetailList[25];	//��ĩ(С��)
		    	
		    	xlsheet.cells(j,col+15)=OneDetailList[6];	//���ڼ���(�Գ�)
		    	xlsheet.cells(j,col+16)=OneDetailList[12];	//���ڼ���(����)
		    	xlsheet.cells(j,col+17)=OneDetailList[18];	//���ڼ���(�ƽ�)
		    	xlsheet.cells(j,col+18)=OneDetailList[24];	//���ڼ���(С��)
		    	
		    	xlsheet.cells(j,col+19)=OneDetailList[8];	//�۾�(�Գ�)
		    	xlsheet.cells(j,col+20)=OneDetailList[14];	//�۾�(����)
		    	xlsheet.cells(j,col+21)=OneDetailList[20];	//�۾�(�ƽ�)
		    	xlsheet.cells(j,col+22)=OneDetailList[26];	//�۾�(С��)
		    	
		    	xlsheet.cells(j,col+23)=OneDetailList[9];	//�ۼ��۾�(�Գ�)
		    	xlsheet.cells(j,col+24)=OneDetailList[15];	//�ۼ��۾�(����)
		    	xlsheet.cells(j,col+25)=OneDetailList[21];	//�ۼ��۾�(�ƽ�)
		    	xlsheet.cells(j,col+26)=OneDetailList[27];	//�ۼ��۾�(С��)
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName
			if (isExport=="1")
			{
				var savepath=GetFileName();
				if (savepath!="") xlBook.SaveAs(savepath);
			}
			else
			{
				//xlsheet.printout;	//��ӡ���
				xlApp.Visible=true;
    			xlsheet.PrintPreview();
			} 
	    	xlBook.Close (savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("�������!");
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
