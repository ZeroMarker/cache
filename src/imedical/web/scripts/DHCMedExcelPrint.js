//打印程序添加说明
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("类方法"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  打印  websys/print_compile.gif
//btnExport 打印  websys/print_compile.gif
var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function PrintDataByExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{
	var strMethod = document.getElementById(strMethodGetServer).value;
	var TemplatePath=GetWebConfig(strMethod).Path;
	var strMethod = document.getElementById(strMethodGetData).value;
	if (strMethod=="") return false;
	if (TemplatePath==""){
		return false;
	}else{
		var FileName=TemplatePath+"\\\\"+strTemplateName;
		//var FileName="http://127.0.0.1/trakcarelive/trak/med/results/template/\DHCWMRCirculMROP.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
		//if (flg>0){xlSheet.printout();}
		xlSheet.printout();
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}
	return true;
}

function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{
	var strMethod = document.getElementById(strMethodGetServer).value;
	var TemplatePath=GetWebConfig(strMethod).Path;
	var strMethod = document.getElementById(strMethodGetData).value;
	if (strMethod=="") return false;
	if (TemplatePath==""){
		return false;
	}else{
		var FileName=TemplatePath+"\\\\"+strTemplateName;
		//var FileName="http://127.0.0.1/trakcarelive/trak/med/results/template/\DHCWMRDischargeList.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
		var fname = xls.Application.GetSaveAsFilename(strTemplateName,"Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
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