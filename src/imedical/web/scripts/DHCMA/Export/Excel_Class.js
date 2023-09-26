var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function ExportGridByCls(grid,filename)
{
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
    var columns = grid.options().columns[0];
	var rows=grid.getData().originalRows;   //本地所有数据
	
	for (var i = 0; i < columns.length; i++) {
	 	if ((columns[i].hidden)||(!columns[i].title)||(columns[i].title=="操作")) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //隐藏列不写入
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
    
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {	
			if ((columns[j].hidden)||(!columns[j].title)||(columns[j].title=="操作")) continue;   //隐藏列不写入
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	xlSheet.Cells.EntireColumn.AutoFit;  //列宽自适应
	
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
		//不知对选择“否”的处理如何写，暂时不处理
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}
/// Filter Titles  慢病报卡查询
function ExportMainOfGrid(grid,filename)
{
	var hideCols = "";
	if (!!arguments[2]){
		hideCols = arguments[2];
	}
	
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
    var columns = grid.options().columns[0];
	var rows=grid.getData().originalRows;   //本地所有数据
	
	for (var i = 0; i < columns.length; i++) {
	 	if ((columns[i].hidden)||(!columns[i].title)) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //隐藏列不写入
		}
		if (hideCols!=""){
			if(hideCols.indexOf(columns[i].title) >= 0){
				xlSheet.Columns(i+1).Hidden = true;	
		 		continue;   //隐藏列不写入
			}
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
    
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {		
			if ((columns[j].hidden)||(!columns[j].title)) continue;   //隐藏列不写入
            if (hideCols!=""){
				if(hideCols.indexOf(columns[j].title) >= 0){
		 			continue;   //隐藏列不写入
				}
			}
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	xlSheet.Cells.EntireColumn.AutoFit;  //列宽自适应
	
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
		//不知对选择“否”的处理如何写，暂时不处理
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}
function PrintGridByCls(grid,filename)
{
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return null;
	}
	xls.Visible = true;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
	var columns = grid.options().columns[0];
	var rows=grid.getData().originalRows;   //本地所有数据
	for (var i = 0; i < columns.length; i++) {
		if ((columns[i].hidden)||(!columns[i].title)) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //隐藏列不写入
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
	
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {		
			if ((columns[j].hidden)||(!columns[j].title)) continue;   //隐藏列不写入		
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
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

function ExportCheckGridByCls(grid,filename)
{
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
    var columns = grid.options().columns[0];
	var rows=grid.getChecked();   //选择的数据
    
	for (var i = 0; i < columns.length; i++) {
		if ((columns[i].hidden)||(!columns[i].title)||(columns[i].title=="操作")) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //隐藏列不写入
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {		
			if ((columns[j].hidden)||(!columns[j].title)||(columns[j].title=="操作")) continue;   //隐藏列不写入	
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	xlSheet.Cells.EntireColumn.AutoFit;  //列宽自适应
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
		//不知对选择“否”的处理如何写，暂时不处理
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}

function ReplaceText(str, find, repl)
 {
 	var strTmp = str;
 	while(strTmp.indexOf(find) >=0)
 	{
 		strTmp = strTmp.replace(find, repl);	
 	}	
 	return strTmp;
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
			//设置单元格格式（文本）
			cells(cRow+i,cCol+j).NumberFormatLocal = "@";
			//给单元格赋值
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