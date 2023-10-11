//分页打印
///打印报销单
//打印函数
	function printCost(listm,listd,rows,billcode)
	{
		
		var PageRows=4;//每页固定行数
		//alert(rows);
		var Pages=parseInt(rows / PageRows); //总页数-1  
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}

		var xlApp,xlsheet,xlBook,arr;
		xlApp = new ActiveXObject("Excel.Application");
		var path=tkMakeServerCall("web.DHCOPBillDailyCollect","GetPath","","");
		var Template=path+"Herp.Budg.CostPrint.xls";
		//alert("zhixing");
		//alert(Pages);
		for (var i=0;i<=Pages;i++)
	    {	//alert("sss");
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	//alert(listm[6]);
			//主表信息 dname_"^"_printtime_"^"_audname_"^"_uname_"^"_rname_"^"_desc
	    	xlsheet.cells(2,1)="报销单号:"+billcode;//报销单号
	    	xlsheet.cells(3,1)="报销科室:"+listm[0];//报销科室
	    	xlsheet.cells(2,3)=listm[1];//打印时间
	    	xlsheet.cells(3,3)="事由:"+listm[5];//描述
	    	xlsheet.cells(3,8)="第"+(i+1)+"页 共"+(Pages*1+1)+"页";//页码	
	    	//xlsheet.cells(12,2)=listm[2];//归口科室	
	    	xlsheet.cells(12,5)="报销人:"+listm[3];//报销人
	    	xlsheet.cells(12,7)="制单人:"+listm[4];//制单人
	    	xlsheet.cells(11,3)=listm[6];//合计大写	
	    	xlsheet.cells(10,3)=listm[7];//申请合计	
	    	xlsheet.cells(10,5)=listm[8];//审批合计	
	    	xlsheet.cells(11,7)="(小写)￥:"+listm[8];//合计小写
	    	xlsheet.cells(13,1)="审核人:"+listm[9];//审核人
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Listl=listd[i*PageRows+Row];
				var List=Listl.split("^");
				var cellRow=Row+5;
				//alert(List[1])
					xlsheet.cells(cellRow,1)=List[0];//预算科目
					xlsheet.cells(cellRow,3)=List[1];//申请金额
					xlsheet.cells(cellRow,5)=List[2];//审批金额
				
			}
		
			xlsheet.printout ;
	    }	xlBook.Close (savechanges=false);
		    xlsheet.Quit;
		    xlsheet=null;
		    xlApp=null;
	}

///打印报销单成差旅费格式
//打印函数
	function printCostTravel(listm,listd,rows,billcode)
	{
		
		var PageRows=5;//每页固定行数
		//alert(rows);
		var Pages=parseInt(rows / PageRows); //总页数-1  
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}

		var xlApp,xlsheet,xlBook,arr;
		xlApp = new ActiveXObject("Excel.Application");
		var path=tkMakeServerCall("web.DHCOPBillDailyCollect","GetPath","","");
		var Template=path+"Herp.Budg.CostTravelPrint.xlsx";
		//alert("zhixing");
		//alert(Pages);
		for (var i=0;i<=Pages;i++)
	    {	//alert("sss");
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
			//主表信息 dname_"^"_printtime_"^"_audname_"^"_uname_"^"_rname_"^"_desc
	    	xlsheet.cells(2,1)="报销单号:"+billcode;//报销单号
	    	xlsheet.cells(3,1)="报销科室:"+listm[0];//报销科室
	    	xlsheet.cells(2,3)=listm[1];//打印时间
	    	xlsheet.cells(3,3)="事由:"+listm[5];//描述
	    	xlsheet.cells(3,8)="第"+(i+1)+"页 共"+(Pages*1+1)+"页";//页码	
	    	//xlsheet.cells(12,2)=listm[2];//归口科室	
	    	xlsheet.cells(13,5)="报销人:"+listm[3];//报销人
	    	xlsheet.cells(13,7)="制单人:"+listm[4];//制单人
	    	xlsheet.cells(12,1)="合计人民币(大写):"+listm[6];//合计大写	
	    	//xlsheet.cells(10,3)=listm[7];//申请合计	
	    	//xlsheet.cells(10,5)=listm[8];//审批合计	
	    	xlsheet.cells(12,6)="(小写)￥:"+listm[8];//合计小写
	    	xlsheet.cells(13,1)="审核人:"+listm[9];//审核人
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Listl=listd[i*PageRows+Row];
				var List=Listl.split("^");
				var cellRow=Row+5;
				//alert(List[1])
					//xlsheet.cells(cellRow,1)=List[0];//预算科目
					//xlsheet.cells(cellRow,3)=List[1];//申请金额
					//xlsheet.cells(cellRow,5)=List[2];//审批金额
				
			}
		
			xlsheet.printout ;
	    }	xlBook.Close (savechanges=false);
		    xlsheet.Quit;
		    xlsheet=null;
		    xlApp=null;
	}

//支出控制借款单打印
	function printApply(listm,listd,rows,billcode)
	{
		
		var PageRows=3;//每页固定行数
		//alert(rows);
		var Pages=parseInt(rows / PageRows); //总页数-1
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}

		var xlApp,xlsheet,xlBook,arr;
		xlApp = new ActiveXObject("Excel.Application");
		var path=tkMakeServerCall("web.DHCOPBillDailyCollect","GetPath","","");
		var Template=path+"Herp.Budg.ApplyPrint.xls";
		//alert("zhixing");
		//alert(Pages);
		for (var i=0;i<=Pages;i++)
	    {	
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
			//主表信息
	    	xlsheet.cells(2,1)="借款单号:"+billcode;//借款单号
	    	xlsheet.cells(3,1)="借款科室:"+listm[0];//借款科室
	    	xlsheet.cells(2,3)=listm[1];//打印时间
	    	xlsheet.cells(3,3)="事由:"+listm[5];//描述
	    	xlsheet.cells(3,8)="第"+(i+1)+"页 共"+(Pages*1+1)+"页";//页码	
	    	//xlsheet.cells(12,3)="归口科室:"+listm[2];//归口科室	
	    	xlsheet.cells(13,5)="借款人:"+listm[3];//借款人
	    	xlsheet.cells(13,7)="制单人:"+listm[4];//制单人
	    	xlsheet.cells(10,3)=listm[6];//合计大写	
	    	xlsheet.cells(9,3)=listm[7];//申请合计	
	    	xlsheet.cells(9,5)=listm[8];//审批合计	
	    	xlsheet.cells(10,7)="(小写)￥:"+listm[8];//合计小写
	    	xlsheet.cells(13,1)="审批人:"+listm[9];//审核人
	    	xlsheet.cells(2,7)="支付方式:"+listm[10];//付款方式
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Listl=listd[i*PageRows+Row];
				var List=Listl.split("^");
				var cellRow=Row+5;
				//alert(List[1])
					xlsheet.cells(cellRow,1)=List[0];//预算科目
					xlsheet.cells(cellRow,3)=List[1];//申请金额
					xlsheet.cells(cellRow,5)=List[2];//审批金额	
			//alert(Row);
			}
			xlsheet.printout ;		
	    }
			xlBook.Close (savechanges=false);
	    
		    xlsheet.Quit;
		    xlsheet=null;	
		    xlApp=null;
	}

/*
//打印程序添加说明
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("类方法"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  打印  websys/print_compile.gif
//btnExport 打印  websys/print_compile.gif
var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		if (encmeth!=""){
			var TempFileds=encmeth.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}

function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{
	
	var objCaseSrv = ExtTool.StaticServerObject("herp.comm.PrintService");
	var ServerInfo=objCaseSrv.GetServerInfo();
	var TemplatePath=GetWebConfig(ServerInfo).Path;
	var FileName=TemplatePath+"\\\\"+"Herp.Budg.CostPrint.xls";
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		alert("创建Excel应用对象失败!");
		return false;
	}
	xls.visible=true;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg=objCaseSrv.ExportCRRepMBBK("fillxlSheet",strArguments);
	//var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
	var fname = xls.Application.GetSaveAsFilename(strTemplateName,"Excel Spreadsheets (*.xls), *.xls");
	xlBook.SaveAs(fname);
	xlSheet=null;
	xlBook.Close (savechanges=true);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}

function PrintDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{	
	var objCaseSrv = ExtTool.StaticServerObject("herp.comm.PrintService");
	var ServerInfo=objCaseSrv.GetServerInfo();
	var TemplatePath=GetWebConfig(ServerInfo).Path;
	var FileName=TemplatePath+"\\\\"+"Herp.Budg.CostPrint.xls";
	try {	
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		alert("创建Excel应用对象失败!");
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg=objCaseSrv.ExportCRRepMBBK("fillxlSheet",strArguments);
	//var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
	xlSheet.printout();
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//画单元格
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//单元格合并
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}*/