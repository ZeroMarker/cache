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


function ExportDataToExcel(ReportID,strFileName)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.EPDService.EpidemicReportExport",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"dhcmed.epd.HIVFollow.xls";
	
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.EPDService.CaseFollowSrv","ExportHIVCaseRep","fillxlSheet",ReportID);
	
	var fname = xls.Application.GetSaveAsFilename("HIV个案随访表("+strFileName+")","Excel Spreadsheets (*.xls), *.xls");
	xlBook.SaveAs(fname);
   
	xlSheet=null;
	xlBook.Close (savechanges=true);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	xlSheet=true;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}

function PrintDataToExcel(ReportID,strFileName)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.EPDService.EpidemicReportExport",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"dhcmed.epd.HIVFollow.xls";
	
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.EPDService.CaseFollowSrv","ExportHIVCaseRep","fillxlSheet",ReportID);
	
	var fname = xls.Application.GetSaveAsFilename("HIV个案随访表("+strFileName+")","Excel Spreadsheets (*.xls), *.xls");
	xlSheet.printout();
	
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	xlSheet=true;
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
}