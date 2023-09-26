//自定义控件
$.haiExcel = new Object();

$.haiExcel.ExcelApp = function(){
	this.InitApp=InitApp;
	this.AddBook=AddBook;
	this.SaveBook=SaveBook;
	this.GetSheet=GetSheet;
	this.WriteData=WriteData;
	this.ReadData=ReadData;
	this.ChangeSheet=ChangeSheet;
	this.PrintArea=PrintArea;
	this.PrintOut=PrintOut;
	this.Close=Close;
	
	this.SetVisible=SetVisible;
	this.SetDisplayAlerts=SetDisplayAlerts;
	this.MergeCells=MergeCells;
	this.SetCellsRowHeigth=SetCellsRowHeigth;
	this.SetCellsFontSize=SetCellsFontSize;
	this.SetCellsHorizontalAlignment=SetCellsHorizontalAlignment;
	this.GetRange=GetRange;
	this.SetRangeBordersLineStyle=SetRangeBordersLineStyle;
	this.SetRangeFontSize=SetRangeFontSize;
	this.SetRangeFontBold=SetRangeFontBold;
	this.SetRangeHorizontalAlignment=SetRangeHorizontalAlignment;
	this.SetRangeColumnWidth=SetRangeColumnWidth;
	this.SetRangeNumberFormatLocal=SetRangeNumberFormatLocal;
	
	return this;
}();

function InitApp()
{
	try {
		this.xlApp = new ActiveXObject("Excel.Application");
	}catch (e) {
		this.xlApp =null;
		alert("Creat ExcelApplacation Error!");
		return null;
	}
	
	this.xlApp.Visible = false;
	
	if (arguments[0]){
		try {
			this.xlBook = this.xlApp.Workbooks.Add(arguments[0]);
		}catch (e) {
			this.xlBook = null;
			alert("Creat WorkBook Error!");
			return null;
		}
	}else{
		try {
			this.xlBook = this.xlApp.Workbooks.Add();
		}catch (e) {
			this.xlBook = null;
			alert("Creat New WorkBook Error!");
			return null;
		}
	}
	
	this.xlSheet=this.xlBook.Worksheets(1);
}

//Set App Visible
function SetVisible(IsVisible)
{
	if (IsVisible==true){
		this.xlApp.Visible = true;
	}else{
		this.xlApp.Visible = false;
	}
}

//Set App DisplayAlerts
function SetDisplayAlerts(IsDisplayAlerts)
{
	if (IsDisplayAlerts==true){
		this.xlApp.DisplayAlerts = true;
	}else{
		this.xlApp.DisplayAlerts = false;
	}
}

//Merge Cells
function MergeCells(Row1,Col1,Row2,Col2)
{
	var cells=this.xlSheet.Cells;
	try {
		this.GetRange(Row1,Col1,Row2,Col2).MergeCells =1;
	}catch(e){
		alert('Merge Cells Error!');
		return false;
	}
	return true;
}

function SetCellsRowHeigth(val)
{
	this.xlSheet.Cells.RowHeight=val;
	return true;
}

function SetCellsFontSize(val)
{
	this.xlSheet.Cells.Font.Size=val;
	return true;
}

function SetCellsHorizontalAlignment(val)
{
	this.xlSheet.Cells.HorizontalAlignment=val;
	return true;
}

function GetRange(Row1,Col1,Row2,Col2)
{
	var cells=this.xlSheet.Cells;
	return this.xlSheet.Range(cells(Row1,Col1),cells(Row2,Col2));
}

function SetRangeBordersLineStyle(Row1,Col1,Row2,Col2,val)
{
	this.GetRange(Row1,Col1,Row2,Col2).Borders.LineStyle = val;
	return true;
}

function SetRangeFontSize(Row1,Col1,Row2,Col2,val)
{
	this.GetRange(Row1,Col1,Row2,Col2).Font.Size = val;
	return true;
}

function SetRangeFontBold(Row1,Col1,Row2,Col2,val)
{
	this.GetRange(Row1,Col1,Row2,Col2).Font.Bold = val;
	return true;
}

function SetRangeHorizontalAlignment(Row1,Col1,Row2,Col2,val)
{
	this.GetRange(Row1,Col1,Row2,Col2).HorizontalAlignment = val;
	return true;
}

function SetRangeColumnWidth(Row1,Col1,Row2,Col2,val)
{
	this.GetRange(Row1,Col1,Row2,Col2).ColumnWidth = val;
	return true;
}

function SetRangeNumberFormatLocal(Row1,Col1,Row2,Col2,val)
{
	this.GetRange(Row1,Col1,Row2,Col2).NumberFormatLocal = val;
	return true;
}

//Add a workbook
function AddBook(FileName)
{
	if (FileName&&FileName!==""){
		try {
			this.xlBook = this.xlApp.Workbooks.Add(FileName);
		}catch (e) {
			this.xlBook = null;
			alert("Add a workbook Error!");
			return false;
		}
	}else{
		try {
			this.xlBook = this.xlApp.Workbooks.Add();
		}catch (e) {
			this.xlBook = null;
			alert("Add a new workbook Error!");
			return false;
		}
	}
	return true;
}

// Save workook
function SaveBook(FileName)
{
	if (FileName=="" || typeof(FileName)=="undefined"){
		var fname = this.xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
	}else{
		var fname = this.xlApp.Application.GetSaveAsFilename(FileName+".xls", "Excel Spreadsheets (*.xls), *.xls");
	}
	if (fname!=""){
		//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
		//不知对选择“否”的处理如何写，暂时不处理
		try {
			this.xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
}

// Get Sheet Name
function GetSheetNames(){
	if (this.xlBook){
		var count=this.xlBook.Worksheets.Count;
		if (count>0){
			var arrSheet=new Array(count);
			for (var i=1;i<=count;i++){
				arrSheet[i-1]=this.xlBook.Worksheets(i).Name;
			}
			return arrSheet;
		}else{
			return null;
		}
	}else{
		return null;
	}
}

// Get sheet by name
function GetSheet(SheetName){
	if (this.xlBook){
		if (SheetName && ""!==SheetName) {
			this.xlSheet = this.xlBook.Worksheets.Item(SheetName);
			if (this.xlSheet===null){
				alert('Not find the Sheet Object named '+SheetName+'!');
				return false;
			}
		}else{
			return false;
		}
	}else{
		return false;
	}
	return true;
}

//Write Date to Cell
function WriteData(Row, Col, value){
	if (this.xlSheet){
		this.xlSheet.Cells(Row, Col).NumberFormatLocal= "@ ";
		this.xlSheet.Cells(Row, Col).Value=value;
		return true;
	}else {
		return false;
	}
}

// Read Date from Cell
function ReadData(Row, Col){
	if (this.xlSheet) {
		var ret=this.xlSheet.Cells(Row,Col).Value;
		if (ret){
			return ret;
		}else{
			return '';
		}
	}else {
		return '';
	}
}

// Change Sheet Name
function ChangeSheet(NewName){
	if (NewName&&NewName!==""){
		this.xlSheet.Name=NewName;
		return true;
	}else{
		return false;
	};
}

// Range:"$A$1:$I$44"
function PrintArea(Range){
	if (Range){
		this.xlSheet.PageSetup.PrintArea = Range;
		return true;
	}else{
		return false;
	}
}

// IsPreview:true/false
function PrintOut(IsPreview)
{
	if ((typeof(IsPreview)=='boolean')&&(IsPreview==true)){
		this.xlSheet.PrintPreview();
	}else{
		this.xlSheet.printout();
	}
}

function Close()
{
	this.xlSheet=null;
    this.xlBook.Close (savechanges=false);
    this.xlBook=null;
    this.xlApp.Quit();
    this.xlApp=null;
    idTmr=window.setInterval("Cleanup();",1);
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

ExcelApp=$.haiExcel.ExcelApp;