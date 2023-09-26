function BodyLoadHandler() 
{	
	InitPage();
}

function InitPage()
{	
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
}

function BExport_Click()
{
	var Row;
	var node="DHCEQInventory.ResultList";
	var job=GetElementValue("TJobz1");	
	var encmeth=GetElementValue("GetTempNum");
	if (job=="")
	{
		alertShow(t['NoData']);
		return;
	}
	var num=cspRunServerMethod(encmeth,node,job);
	if (num<1)
	{
		alertShow(t['NoData']);
		return;
	}
	
	encmeth=GetElementValue("GetRepPath");
	var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"DHCEQInventoryResult.xls";
	
	var FileName=GetFileName();
	if (FileName=="") {return;}
	
	encmeth=GetElementValue("GetTempList"); 
        var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var firstRow=3;
	var firstCol=2;
	var Col;
	//num=1000;
	for (Row=1;Row<=num;Row++)
	    { 
	   		var str=cspRunServerMethod(encmeth,node,job,Row);
			var List=str.split("^");
			if (Row<num) xlsheet.Rows(Row+firstRow).Insert();
			Col=firstCol;
			//0 TRowID_"^"_TInventoryDR_"^"_TBillEquipDR_"^"_TActerEquipDR_"^"_TBillStoreLocDR_"^"_TBillUseLocDR_"^"_TActerStoreLocDR_"^"_TActerUseLocDR_"^"_TBillOriginalFee_"^"_TBillNetFee_"^"_10  TBillDepreTotalFee_"^"_TUserDR_"^"_TDate_"^"_TTime_"^"_TStatus_"^"_TRemark_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"20_THold5_"^"_TBillName_"^"_TActerName_"^"_TBillNo_"^"_TActerNo_"^"_TModel_"^"_TEquiCat_"^"_TEquipType_"^"_TStatCat_"^"_TUnit_"^"30_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TProvider_"^"_TLimitYearsNum_"^"_TDepreMethod_"^"_TEquipRemark_"^"_TBillStoreLoc_"^"_TBillUseLoc_"^"_TActerStoreLoc_"^"_TActerUseLoc_"^"40_TManuFactory_"^"_TOrigin_"^"_TUser
			xlsheet.cells(Row+firstRow,Col++)=List[36]; //台帐科室
			xlsheet.cells(Row+firstRow,Col++)=List[23]; //设备编号
			xlsheet.cells(Row+firstRow,Col++)=List[21]; //设备名称
			xlsheet.cells(Row+firstRow,Col++)=List[25]; //设备机型
			xlsheet.cells(Row+firstRow,Col++)=List[8];  //原值
			xlsheet.cells(Row+firstRow,Col++)=List[38]; //实际科室
			xlsheet.cells(Row+firstRow,Col++)=List[43]; //存放位置
			xlsheet.cells(Row+firstRow,Col++)=List[44]; //盘点一致			
	     }
	
	var curDate=GetCurrentDate();
	var username=curUserName;
	xlsheet.cells(Row+firstRow,3)=FormatDate(curDate);
	xlsheet.cells(Row+firstRow,9)=username;
	    xlBook.SaveAs(FileName);
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    alertShow(t['ExportSuccess']);
}

document.body.onload = BodyLoadHandler;