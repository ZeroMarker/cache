/// DHCPEExcelPublic.js

///实现操作Excel的功能函数

function DHCPEExcel(FilePath,IsVisible) {
	
  
	this.FilePath=FilePath;
	try {
		this.xlApp = new ActiveXObject("Excel.Application");
	}
	
	catch (e) {
		this.xlApp =null;
		alert("打开文件失败: \n错误号:"+e.number+'\n\n描述:\n\n'+e.description);
		return null;
	}
 
	try {

		this.xlBook = this.xlApp.Workbooks.Add(this.FilePath);
	}
	catch (e) {
		this.xlBook = null;
		this.xlApp =null;
		alert("打开文件失败: \n错误号:"+e.number+'\n\n描述:\n\n'+e.description);
		return null;
	}
	
    //this.xlsheet = this.xlBook.WorkSheets("Sheet2"); 

	this.sheetName="";
	
	if (IsVisible) {
		// 是否可视
		this.xlApp.Visible = true;
	}
 
	// 功能函数
	this.id=this.FilePath;
	this.Colse=DHCPEExcel_Colse;					// 关闭对象
	this.GetSheet=DHCPEExcel_GetSheet;				// 获取电子表格(sheet)对象
	this.writeData=DHCPEExcel_writeData;			// 写入数据
	this.writeDataToRow=DHCPEExcel_writeDataToRow;	// 
	this.ReadData=DHCPEExcel_ReadData;				// 读取数据
	this.writeDataToCol=DHCPEExcel_writeDataToCol;	// 
	this.Borders=DHCPEExcel_Borders;				// 给边框画线
	this.SetSheet=DHCPEExcel_SetSheet;				// 给电子表格对象改名
	this.SaveTo=DHCPEExcel_SaveTo;					// 文件另存为
	this.Print=DHCPEExcel_Print;		            // 打印(防止打印重名)
	this.SetPrintArea=DHCPEExcel_SetPrintArea;		// 设置打印区域
	this.Merge=DHCPEExcel_Merge;					// 合并单元格
	// 错误处理
	this.Error=false;
	this.Code='';
	this.Message='';
	
	this.ShowMessage=DHCPEExcel_ShowMessage;
	this.Debug=false;

	return this;
}

// 关闭 Excel 文件
// IsSavechanges 是否保存
function DHCPEExcel_Colse(IsSavechanges){
	this.xlBook.Close(savechanges=IsSavechanges);
	this.xlsheet=null;
	this.xlBook=null;
	this.xlApp=null;
}

// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////

// 按名字获取 Excel 表格对象
function DHCPEExcel_GetSheet(sheetName){
	this.ShowMessage("", 'E', 0);
	if (this.xlBook) {
		if (sheetName && ""!=sheetName) {
			try {
				this.ShowMessage("", 'E', 0);
				this.xlsheet = this.xlBook.Worksheets.Item(sheetName);
			}
			catch (e) {
				this.xlsheet = null;
				this.ShowMessage('未找到'+sheetName+'表格对象! \n'+e.toString(), 'E', 1);
				return false;
			}
			this.sheetName=sheetName;
			return true;
		}
	}
	return false;
}

// 给电子表格改名
function DHCPEExcel_SetSheet(oldName, NewName){
	this.ShowMessage("", 'E', 0);
	if (oldName && ""!=oldName) {
		this.GetSheet(oldName);

	}
	this.xlsheet.Name=NewName;
	this.GetSheet(NewName);
	return true;	
}

// Excel 另存为
function DHCPEExcel_SaveTo(NewFilePath) {

	this.ShowMessage("", 'E', 0);
	if (this.xlBook)
	{   
		this.xlBook.SaveAs(NewFilePath);
	
		return true;
	}
	else { return false; }
}

// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////

function DHCPEExcel_writeData(Row, Col, value){
	this.ShowMessage("", 'E', 0);
	if (this.xlsheet)
	{
		if ('undefined'!=typeof(value)) 
		{ 
			this.xlsheet.Cells(Row, Col).Value=value; 
		}
		return true;
	}else { return false; }
}

function DHCPEExcel_ReadData(Row, Col){
	this.ShowMessage("", 'E', 0);
	if (this.xlsheet) {
		// 注意被合并单元格的值是不存在的(单元格本身是存在的-Object只是为空)
		if ('undefined'!=typeof(this.xlsheet.Cells(Row,Col).Value)) { return this.xlsheet.Cells(Row,Col).Value; } 
		else { return '';}
		}
	else { return ''; }
}

// 
function DHCPEExcel_writeDataToRow(Datas,aRowIndex,aColBegin) {
	this.ShowMessage("", 'E', 0);
	var DayData=null;
	var iRow=aRowIndex,iCol=aColBegin;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=aColBegin+iDayLoop;
		if (DayData[iDayLoop] && ''!=DayData[iDayLoop]) 
		{
			this.xlsheet.Cells(aRowIndex,iCol).Value=DayData[iDayLoop];
		}
	}
}

// 
function DHCPEExcel_writeDataToCol(Datas,aColIndex,aRowBegin) {
	this.ShowMessage("", 'E', 0);
	var DayData=null;
	var iRow=0,iCol=aColIndex;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iRow=aRowBegin+iDayLoop;
		this.xlsheet.Cells(iCol,iRow).Value=DayData[iDayLoop];
	}
}

// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////

// 设置边框(黑色)实线
// BordersIndex = 'LEFT^'+'TOP^'+'BOTTOM^'+'RIGHT^'
function DHCPEExcel_Borders(Row, Col, BordersIndex) {
	//BordersIndex=BordersIndex.upperCase();
	this.ShowMessage("", 'E', 0);
	var Range=this.xlsheet.Cells(Row,Col);
	
	// Const xlEdgeLeft = 7		Excel.XlBordersIndex 的成员
	if (BordersIndex.indexOf("LEFT^")>-1)
	{
		Range.Borders(7).LineStyle = 1;
		Range.Borders(7).Weight = 2;
		Range.Borders(7).ColorIndex = -4105;
	}

	// Const xlEdgeTop = 8	    Excel.XlBordersIndex 的成员	
	if (BordersIndex.indexOf("TOP^")>-1)
	{
		//alert('TOP');
		Range.Borders(8).LineStyle = 1;
		Range.Borders(8).Weight = 2;
		Range.Borders(8).ColorIndex = -4105;
	}
		
	// Const xlEdgeBottom = 9	Excel.XlBordersIndex 的成员		
	if (BordersIndex.indexOf("BOTTOM^")>-1)
	{
		Range.Borders(9).LineStyle = 1;
		Range.Borders(9).Weight = 2;
		Range.Borders(9).ColorIndex = -4105;
	}
	
	// Const xlEdgeRight = 10	Excel.XlBordersIndex 的成员
	if (BordersIndex.indexOf("RIGHT^")>-1)
	{
		Range.Borders(10).LineStyle = 1;
		Range.Borders(10).Weight = 2;
		Range.Borders(10).ColorIndex = -4105;
	}

}

// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////

// 打印(防止打印重名)
function DHCPEExcel_Print(IsPreview) {
	this.ShowMessage('', 'E', 0);
	if (IsPreview) { this.xlsheet.PrintPreview(); }
	else { this.xlsheet.PrintOut(); }

}

// 设置打印区域 
// Range : "$A$1:$I$44"
function DHCPEExcel_SetPrintArea(Range) {
	this.ShowMessage('', 'E', 0);
	this.xlsheet.PageSetup.PrintArea = Range;
}

// 合并单元格
// sRange : "A1" eRange : "A44"
function DHCPEExcel_Merge(sRange,eRange) {
	var Selection=this.xlsheet.Range(sRange, eRange);
    Selection.Merge();
}

// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////

function DHCPEExcel_ShowMessage(Message, Type, Code)
{
	
	// 消息
	if ((!(Type))||('M'==Type)) {
		this.Error = false;
		this.Code=Code;
		this.Message=Message;
	}
	
	// 设置错误
	if ('E'==Type) {
		
		if (0==Code) { this.Error = false; }
		else{ this.Error = true; }
		this.Code=Code;
		this.Message=Message;
		return ;
	}
	
	if ('SE'==Type) {
		alert(this.Message);
	}
	
	// 警告
	if ('A'==Type) {
		this.Error = false;
		this.Code=Code;
		this.Message=Message;
	}
	
	if ((this.Debug)||(Debug)) {
		alert(Message);
	}
}
