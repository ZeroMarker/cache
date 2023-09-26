/****************************************
  JSName          DHC.WMR.ExcelApp.js
  BuildDate	      2007.10.27
  Function	      Operate Excel Application
*****************************************/
function ExcelApplacation()
{
	try {
		this.xlApp = new ActiveXObject("Excel.Application");
	}catch (e) {
		this.xlApp =null;
		alert("Creat ExcelApplacation Error!");
		return null;
	}
	
	this.xlApp.visible = false;
	
	try {
		this.xlBook = this.xlApp.Workbooks.Add();
	}catch (e) {
		this.xlBook = null;
		alert("Creat New WorkBook Error!");
		return null;
	}
	
	this.xlSheet=this.xlBook.Worksheets(1);
	
	this.AddBook=AddBook;
	this.SaveBook=SaveBook;
	this.GetSheet=GetSheet;
	this.WriteData=WriteData;
	this.ReadData=ReadData;
	this.ChangeSheet=ChangeSheet;
	this.PrintArea=PrintArea;
	this.PrintOut=PrintOut;
	this.Close=Close;
	return this;
}

//Set App visible
function xlsVisible(IsProceVisible)
{
	if (ProceVisible==true){
		xls.visible = true;
	}else{
		xls.visible = false;
	}
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
		var fname = xls.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
		if (fname!=""){
			xlbook.SaveAs(fname);
		}
	}else{
		xlbook.SaveAs(FileName);
	}
}

// Get sheet by name
function GetSheet(SheetName){
	if (this.xlBook){
		if (SheetName && ""!==SheetName) {
			this.xlsheet = this.xlBook.Worksheets.Item(SheetName);
			if (this.xlsheet===null){
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
	if (this.xlsheet){
		this.xlsheet.Cells(Row, Col).Value=value;
		return true;
	}else {
		return false;
	}
}

// Read Date from Cell
function ReadData(Row, Col){
	if (this.xlsheet) {
		return this.xlsheet.Cells(Row,Col).Value; 
	}else {
		return '';
	}
}

// Change Sheet Name
function ChangeSheet(NewName){
	if (NewName&&NewName!==""){
		this.xlsheet.Name=NewName;
		return true;
	}else{
		return false;
	};
}

// Range:"$A$1:$I$44"
function PrintArea(Range){
	if (Range){
		this.xlsheet.PageSetup.PrintArea = Range;
		return true;
	}else{
		return false;
	}
}

// IsPreview:true/false
function PrintOut(IsPreview)
{
	if ((typeof(IsPreview)==boolear)&&(IsPreview==true)){
		this.xlsheet.PrintPreview();
	}else{
		this.xlsheet.PrintOut();
	}
}

function Close()
{
	this.xlsheet=null;
    this.xlbook.Close (savechanges=false);
    this.xlbook=null;
    this.xls.Quit();
    this.xls=null;
    idTmr=window.setInterval("Cleanup();",1);
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}





