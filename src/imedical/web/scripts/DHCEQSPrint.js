
//设备采购申请	打印
function PrintClickBuyRequest()
{
	try {
		//没有保存返回
		var RowID=GetElementValue("RowID");
		if (RowID=="") return;
		//没有明细返回
		var encmeth=GetElementValue("GetDetail");
		var Result=cspRunServerMethod(encmeth,RowID);
		if (Result=="")
		{
			alertShow("无明细可打印!")
			return;
		}
		var encmeth=GetElementValue("GetRepPath");
		var TemplatePath=cspRunServerMethod(encmeth);
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBuyRequestSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    //xlsheet.PageSetup.RightMargin=0;
		var RequestLoc=GetElementValue("RequestLoc");
		var RequestLoc=GetShortName(RequestLoc,"-");
		var RequestDate=GetElementValue("RequestDate");
		var YearFlag=GetChkElementValue("YearFlag");
		var YearPlan="非年度计划"
		if (YearFlag) {YearPlan="年度计划";}
		var RequestNo=GetElementValue("RequestNo");
		var Year=ChangeDateFormat(RequestDate);
		xlsheet.cells(2,1)=xlsheet.cells(2,1)+" "+RequestLoc;
		xlsheet.cells(2,3)=xlsheet.cells(2,3)+" "+RequestNo;
		xlsheet.cells(2,6)=Year;
		xlsheet.cells(3,1)=xlsheet.cells(3,1)+" "+GetElementValue("PrjName");
		xlsheet.cells(3,3)=xlsheet.cells(3,3)+" "+YearPlan
		xlsheet.cells(3,6)=GetElementValue("EquipType");
		var ResultList=Result.split("^");
		var BRLTotal=ResultList.length;
		var StartRow=5;
		var List=0;
		var encmeth=GetElementValue("GetOneDetail");
		var sort=21;
		for (List=0;List<BRLTotal;List++)
		{
			var BRLID=ResultList[List];
			var OneDetail=cspRunServerMethod(encmeth,"","",BRLID);
			var OneList=OneDetail.split("^");
			var Row=StartRow+List;
			xlsheet.Rows(Row).Insert();
			xlsheet.cells(Row,1)=OneList[1];
			xlsheet.cells(Row,2)=OneList[sort+1];
			xlsheet.cells(Row,3)=OneList[sort+6];
			xlsheet.cells(Row,4)=OneList[sort+2];
			xlsheet.cells(Row,5)=OneList[6];
			xlsheet.cells(Row,6)=OneList[5];
			xlsheet.cells(Row,7)=OneList[7];
		}
		xlsheet.cells(Row+1,1)="合计";
		xlsheet.cells(Row+1,5)=GetElementValue("QuantityNum");
		xlsheet.cells(Row+1,7)=GetElementValue("TotalFee");
		xlsheet.cells(Row+2,5)=xlsheet.cells(Row+2,5)+" "+GetElementValue("AddUser");
		xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\DHCEQBuyRequest.xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

//设备采购计划打印
function PrintClickBuyPlan()
{
	try {
		//没有保存返回
		var RowID=GetElementValue("RowID");
		if (RowID=="") return;
		//没有明细返回
		var encmeth=GetElementValue("GetDetail");
		var Result=cspRunServerMethod(encmeth,RowID);
		if (Result=="") return;
		
		var encmeth=GetElementValue("GetRepPath");
		var TemplatePath=cspRunServerMethod(encmeth);
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBuyPlanSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    //xlsheet.PageSetup.RightMargin=0;
		var PlanNo=GetElementValue("PlanNo");
		var PlanDate=GetElementValue("PlanDate");
		var PlanType=GetElementValue("PlanType");
		var YearPlan="一般"
		if (PlanType=="1") {YearPlan="年度";}
		if (PlanType=="2") {YearPlan="年度分配";}
		var PurchaseType=GetElementValue("PurchaseType");
		var Year=ChangeDateFormat(PlanDate);
		xlsheet.cells(2,1)=xlsheet.cells(2,1)+" "+PlanNo;
		xlsheet.cells(2,3)=xlsheet.cells(2,3)+" "+PurchaseType;
		xlsheet.cells(2,6)=Year;
		xlsheet.cells(3,1)=xlsheet.cells(3,1)+" "+GetElementValue("PlanName");
		xlsheet.cells(3,3)=xlsheet.cells(3,3)+" "+YearPlan
		xlsheet.cells(3,6)=GetElementValue("EquipType");
		var ResultList=Result.split("^");
		var BPLTotal=ResultList.length;
		var StartRow=5;
		var List=0;
		var encmeth=GetElementValue("GetOneDetail");
		var sort=25;
		for (List=0;List<BPLTotal;List++)
		{
			var BPLID=ResultList[List];
			var OneDetail=cspRunServerMethod(encmeth,"","",BPLID);
			var OneList=OneDetail.split("^");
			var Row=StartRow+List;
			xlsheet.Rows(Row).Insert();
			xlsheet.cells(Row,1)=OneList[1];
			xlsheet.cells(Row,2)=OneList[sort+1];
			xlsheet.cells(Row,3)=OneList[sort+7];
			xlsheet.cells(Row,4)=OneList[sort+2];
			xlsheet.cells(Row,5)=OneList[6];
			xlsheet.cells(Row,6)=OneList[5];
			xlsheet.cells(Row,7)=OneList[7];
		}
		xlsheet.cells(Row+1,1)="合计";
		xlsheet.cells(Row+1,5)=GetElementValue("QuantityNum");
		xlsheet.cells(Row+1,7)=GetElementValue("TotalFee");
		xlsheet.cells(Row+2,5)=xlsheet.cells(Row+2,5)+" "+GetElementValue("AddUser");
		xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\DHCEQBuyPlan.xls");   
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}