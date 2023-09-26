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
	var ServerInfo = $m({                  
		ClassName:"DHCMed.CDService.PrintService",
		MethodName:"GetServerInfo"
	},false);
	var TemplatePath=GetWebConfig(ServerInfo).Path;
	var FileName=TemplatePath+"\\\\"+"DHCMed.CD.CRReportNYZD.xls";
	
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		$.messager.alert("提示","创建Excel应用对象失败!",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.CDService.PrintService","ExportCRRepNYZD","fillxlSheet",strArguments);
	/*
	var listStatus = $m({                  
		ClassName:"DHCMed.CDService.PrintService",
		MethodName:"ExportCRRepNYZD",
		//itmjs:"fillxlSheet",
		strArguments:strArguments
	},false);
	
	listStatus = listStatus.split(";");
	for (var i=0; i<(listStatus.length-1); i++) {
		var tmpItem = listStatus[i].replace("(","").replace(")","").split(",");
		fillxlSheet(xlSheet,tmpItem[1].replace("'","").replace("'",""),parseInt(tmpItem[2]),parseInt(tmpItem[3]));
	}
	*/
	var fname = xls.Application.GetSaveAsFilename(strTemplateName,"Excel Spreadsheets (*.xls), *.xls");
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

function PrintDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{
	var ServerInfo = $m({                  
		ClassName:"DHCMed.CDService.PrintService",
		MethodName:"GetServerInfo"
	},false);

	var TemplatePath=GetWebConfig(ServerInfo).Path;
	var FileName=TemplatePath+"\\\\"+"DHCMed.CD.CRReportNYZD.xls";
	try {	
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		$.messager.alert("提示","创建Excel应用对象失败!",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	
	var flg = tkMakeServerCall("DHCMed.CDService.PrintService","ExportCRRepNYZD","fillxlSheet",strArguments);
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
}