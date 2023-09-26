/// DHCPEInvRcptPayDetailPrint.js
/// 创建时间		2007.10.22
/// 创建人			xuwm
/// 主要功能		打印 体检收费员统计 数据导出到Excel文件
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FExcel;

// 导出数据到文件
function InvRcptPayDetailPrint( aBeginDate, aEndDate,aCurDate, aPayModeDesc) {
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEInvRcptPay.xls'; // 模板文件
	}else{
		alert("无效模板路径");
		return;
	}
	
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1")     //Excel下标的名称
    
    
    xlsheet.cells(2, 1).value = xlsheet.cells(2, 1).value+aBeginDate+"---"+aEndDate;
    xlsheet.cells(2, 10).value = xlsheet.cells(2, 10).value+aCurDate;
	var title=xlsheet.cells(1, 1).value
	xlsheet.cells(1, 1).value=title.replace("*",aPayModeDesc)
	
	var eSrc=window.event.srcElement;
	var tbObj=document.getElementById('tDHCPEInvRcptPayDetail');	
	var rowObj = tbObj.getElementsByTagName("tr");
   if(tbObj)
   {
	  //rowNumber行序号
      var str = "" ,rowNumber,columnNumber //列序号
      for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
      { //rowObj[rowNumber].cells.length
      	
         for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length
;columnNumber ++ )
         {
            str=rowObj[0].cells[columnNumber].innerText;
            if (str==" ") break;
            str = rowObj[rowNumber].cells[columnNumber].innerText;
            xlsheet.cells(rowNumber+3, columnNumber).value = str;
         }
      }
   }
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
// 设置导出文件(另村文件名,标题)
function IPDFileChange(objExcel, aBeginDate, aEndDate, aPayModeDesc) {
		objExcel.GetSheet('报表');
		
		var iCol=1;
		var iRow=1;
		var headLine='体检'+aPayModeDesc+'报账表';
		objExcel.writeData(iRow, iCol, headLine);
		
		var iCol=2;
		var iRow=2;
		var headLine='查询日期 '+aBeginDate+' 至 '+aEndDate;
		objExcel.writeData(iRow, iCol, headLine);
		//objExcel.SaveTo(DataSaveFilePath);
}
// 导体检综合查询
var FRow=3; // 
function ImportInvRcptPayDetail(objExcel, aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDec)
{
	// objExcel.GetSheet('报表');
	FExcel=objExcel;
	FRow=3;
	
	var Instring=aUserID+'^'+aBeginDate+'^'+aEndDate+'^'+aPayMode;
	var Ins=document.getElementById('InvRcptPayDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
	var value=cspRunServerMethod(encmeth,'InvRcptPayDetailToExcel', '', Instring);
	//alert("hhhh");
	//var value=cspRunServerMethod(encmeth,'', '', Instring);
	//alert("gggg");
	//alert(value);
	if (""==value) { return false; }

}

// 输出导体检综合查询数据到Excel文件,在 ImportPEPersonStatistic 中调用
function InvRcptPayDetailToExcel(Datas) {
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("InvRcptPayDetailToExcel \n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		FExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}



