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
		alert("Creat ExcelApplacation Error!");
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
	//处理Excel表头,返回取值字段fields
	var fields = BuildHeaderByGrid(grid,1,1);
	if (fields != '') {
		var params = grid.getStore().lastOptions.params;
		var xClass = params.ClassName;
		var xQuery = params.QueryName;
		var ArgCnt = params.ArgCnt * 1;
		var xArguments = '';
		for (var i = 1; i <= ArgCnt; i++){
			if (i == 1) xArguments = params.Arg1;
			if (i == 2) xArguments = xArguments + CHR_1 + params.Arg2;
			if (i == 3) xArguments = xArguments + CHR_1 + params.Arg3;
			if (i == 4) xArguments = xArguments + CHR_1 + params.Arg4;
			if (i == 5) xArguments = xArguments + CHR_1 + params.Arg5;
			if (i == 6) xArguments = xArguments + CHR_1 + params.Arg6;
			if (i == 7) xArguments = xArguments + CHR_1 + params.Arg7;
			if (i == 8) xArguments = xArguments + CHR_1 + params.Arg8;
			if (i == 9) xArguments = xArguments + CHR_1 + params.Arg9;
			if (i == 10) xArguments = xArguments + CHR_1 + params.Arg10;
			if (i == 11) xArguments = xArguments + CHR_1 + params.Arg11;
			if (i == 12) xArguments = xArguments + CHR_1 + params.Arg12;
			if (i == 13) xArguments = xArguments + CHR_1 + params.Arg13;
			if (i == 14) xArguments = xArguments + CHR_1 + params.Arg14;
			if (i == 15) xArguments = xArguments + CHR_1 + params.Arg15;
		}
		var flg = ExtTool.RunServerMethod("DHCMed.SSService.ExcelSrv","ExportGrid","fillxlSheet",xClass,xQuery,xArguments,fields);
	}
	
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
		alert("Creat ExcelApplacation Error!");
		return null;
	}
	xls.Visible = true;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
	//处理Excel表头,返回取值字段fields
	var fields = BuildHeaderByGrid(grid,1,1);
	if (fields != '') {
		var params = grid.getStore().lastOptions.params;
		var xClass = params.ClassName;
		var xQuery = params.QueryName;
		var ArgCnt = params.ArgCnt * 1;
		var xArguments = '';
		for (var i = 1; i <= ArgCnt; i++){
			if (i == 1) xArguments = params.Arg1;
			if (i == 2) xArguments = xArguments + CHR_1 + params.Arg2;
			if (i == 3) xArguments = xArguments + CHR_1 + params.Arg3;
			if (i == 4) xArguments = xArguments + CHR_1 + params.Arg4;
			if (i == 5) xArguments = xArguments + CHR_1 + params.Arg5;
			if (i == 6) xArguments = xArguments + CHR_1 + params.Arg6;
			if (i == 7) xArguments = xArguments + CHR_1 + params.Arg7;
			if (i == 8) xArguments = xArguments + CHR_1 + params.Arg8;
			if (i == 9) xArguments = xArguments + CHR_1 + params.Arg9;
			if (i == 10) xArguments = xArguments + CHR_1 + params.Arg10;
			if (i == 11) xArguments = xArguments + CHR_1 + params.Arg11;
			if (i == 12) xArguments = xArguments + CHR_1 + params.Arg12;
			if (i == 13) xArguments = xArguments + CHR_1 + params.Arg13;
			if (i == 14) xArguments = xArguments + CHR_1 + params.Arg14;
			if (i == 15) xArguments = xArguments + CHR_1 + params.Arg15;
		}
		var flg = ExtTool.RunServerMethod("DHCMed.SSService.ExcelSrv","ExportGrid","fillxlSheet",xClass,xQuery,xArguments,fields);
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

function BuildHeaderByGrid(grid,row,col)
{
	var fields = '';
    var cm = grid.getColumnModel();
    var cfg = null;
	var index = 0;
    for(var i=0;i<cm.config.length;++i)
    {
        cfg = cm.config[i];
		if (cfg.header == '') continue;     //无表头列
		if (cfg.id == 'checker') continue;  //选择列
		if (cfg.id=='numberer') continue;   //序号列
		if (cfg.id=='expander') continue;   //明细列
		if (!cfg.dataIndex) continue;       //列未设置dataIndex属性,不输出
		
		var header = cfg.header;
		header = ReplaceText(header, "<BR/>", "\n");
		header = ReplaceText(header, "<br/>", "\n");
		header = ReplaceText(header, "<br>", "\n");
		fillxlSheet(xlSheet,header,row,col+index);
		
		if (index < 1) {
			fields = cfg.dataIndex;
		} else {
			fields = fields + CHR_1 + cfg.dataIndex;
		}
		
        var colwidth=cfg.width;
        if(cfg.id != 'expander'){
        	xlSheet.Columns(col+index).ColumnWidth=colwidth/5;
        }else{
        	xlSheet.Columns(col+index).ColumnWidth = 50;
        }
		
		index++;
    }
	
	return fields;
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