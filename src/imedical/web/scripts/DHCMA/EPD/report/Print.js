var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var RepString ="";  //用于输出整份报告数据
var HIVString ="";  //用于输出HIV附卡数据
var STDString ="";  //用于输出STD附卡数据
var HBVString ="";  //用于输出HBV附卡数据

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


function ExportDataToExcel(ReportID,CardType,strFileName)
{
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){

		var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
		var FileName=TemplatePath+"\\\\"+"DHCMedEpidemicReportNew.xls";
		
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheet",ReportID);
		if (CardType=='HIV') {
			xlSheet=xlBook.Worksheets.Item(2);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheet",ReportID);
		}  
		if(CardType=='STD'){
			xlSheet=xlBook.Worksheets.Item(3);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheet",ReportID);
		}
		if(CardType=='HBV'){
			xlSheet=xlBook.Worksheets.Item(4);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheet",ReportID);
		}
		
		var fname = xls.Application.GetSaveAsFilename("传染病报告("+strFileName+")","Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
	   
		xlSheet=null;
		xlBook.Close (savechanges=true);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		xlSheet=true;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //中间件运行
	   	var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedEpidemicReportNew.xls"
		FileName=FileName.replace(/\\/g,"/");
			
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheetStr",ReportID);
        if (CardType=='HIV') {
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheetHIV",ReportID);
		}  
		if(CardType=='STD'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheetSTD",ReportID);
		}
		if(CardType=='HBV'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheetHBV",ReportID);
		}		

		var Str ="(function test(x){"
			Str += "var xlApp = new ActiveXObject('Excel.Application');"
			Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
			Str += "var xlSheet = xlBook.Worksheets.Item(1);"
		    Str += RepString 	  //后面一定不能有;
			Str += ((CardType=="HIV")?("var xlSheet = xlBook.Worksheets.Item(2);"+HIVString) : "")   //结束一定不能有;一律使用双引号
		    Str += ((CardType=="STD")?("var xlSheet = xlBook.Worksheets.Item(3);"+STDtring) : "")
		    Str += ((CardType=="HBV")?("var xlSheet = xlBook.Worksheets.Item(4);"+HBVString) : "")
	    	//Str += "var fname = xlApp.Application.GetSaveAsFilename('传染病报告("+strFileName+")"+","+"Excel Spreadsheets (*.xls), *.xls"+"');"
	    	//Str += "xlBook.SaveAs(fname);"
	    	Str += "xlBook.SaveAs('传染病报告("+strFileName+")');"
		    Str += "xlApp.Visible = false;"
		    Str += "xlApp.UserControl = false;"
		    Str += "xlBook.Close(savechanges=false);"
		    Str += "xlApp.Quit();"
		    Str += "xlSheet=null;"
		    Str += "xlBook=null;"
		    Str += "xlApp=null;"
		    Str += "return 1;}());";
		
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	}	

	return true;
}

function PrintDataToExcel(ReportID,CardType,strFileName)
{
	if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ){
		var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
		var FileName=TemplatePath+"\\\\"+"DHCMedEpidemicReportNew.xls";
		
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheet",ReportID);
	    xlSheet.printout();
		if (CardType=='HIV') {
			xlSheet=xlBook.Worksheets.Item(2);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheet",ReportID);
			xlSheet.printout();
		}  
		if(CardType=='STD'){
			xlSheet=xlBook.Worksheets.Item(3);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheet",ReportID);
			xlSheet.printout();
		}
		if(CardType=='HBV'){
			xlSheet=xlBook.Worksheets.Item(4);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheet",ReportID);
			xlSheet.printout();
		}
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		xlSheet=true;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //中间件运行
	   	var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedEpidemicReportNew.xls";
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheetStr",ReportID);
        if (CardType=='HIV') {
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheetHIV",ReportID);
		}  
		if(CardType=='STD'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheetSTD",ReportID);
		}
		if(CardType=='HBV'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheetHBV",ReportID);
		}		

	    var Str="(function test(x){"
			Str +="var xlApp = new ActiveXObject('Excel.Application');"
			Str +="var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //标点符号很重要，值都是''引起来才能使用
			Str +="var xlSheet = xlBook.Worksheets.Item(1);"
			Str +=RepString 	  //后面一定不能有;
			Str +="xlSheet.PrintOut();"
			Str +=((CardType=="HIV")?("var xlSheet = xlBook.Worksheets.Item(2);"+HIVString+"xlSheet.PrintOut();") : "")   //结束一定不能有;一律使用双引号
			Str +=((CardType=="STD")?("var xlSheet = xlBook.Worksheets.Item(3);"+STDtring+"xlSheet.PrintOut();") : "")
			Str +=((CardType=="HBV")?("var xlSheet = xlBook.Worksheets.Item(4);"+HBVString+"xlSheet.PrintOut();") : "")
			Str +="xlApp.Visible = false;"
			Str +="xlApp.UserControl = false;"
			Str +="xlBook.Close(savechanges=false);"
			Str +="xlApp.Quit();"
			Str +="xlSheet=null;"
			Str +="xlBook=null;"
			Str +="xlApp=null;"
			Str +="return 1;}());";
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	}

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
}


function fillxlSheetStr(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			RepString=RepString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //标点符号很重要，一个都不能少
		}
	}
	 
	return RepString; 
}

function fillxlSheetHIV(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			HIVString=HIVString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //标点符号很重要，一个都不能少
		}
	}
	 
	return HIVString; 
}

function fillxlSheetSTD(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			STDString=STDString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //标点符号很重要，一个都不能少
		}
	}
	 
	return STDString; 
}

function fillxlSheetHBV(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			HBVString=HBVString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //标点符号很重要，一个都不能少，也不能多
		}
	}
	 
	return HBVString; 
}
