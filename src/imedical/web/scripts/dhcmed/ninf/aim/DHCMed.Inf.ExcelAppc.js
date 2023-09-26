/****************************************
  JSName          DHCMed.Inf.ExcelApp.js
  BuildDate	      2010.06.18
  Function	      Operate Excel Application
*****************************************/

function ExcelApplacation()
{
  try{
    this.xlApp=new ActiveXObject("Excel.Application");
  }catch(e)
  {
    this.xlApp=null;
    Ext.Msx.alert("提示","创建Excel应用失败！");
    return null;
  }
  this.xlApp.visible=false;
  /*
  try{
    this.xlBook=this.xlApp.Workbooks.Add();
    
  }catch(e)
  {
    this.xlBook=null;
    Ext.Msg.alert("提示","新建WorkBook失败！");
    return null;
  }
  
  this.xlSheet=this.xlBook.Worksheets(1);
  */
  this.xlBook=null;
  this.xlSheet=null;
  this.RowCount=3;
  this.AddBook=AddBook;
  this.SaveBook=SaveBook;
  this.GetSheet=GetSheet;
  this.WriteData=WriteData;
  this.Close=Close;
  this.ReadData=ReadData;
  this.ChangeSheet=ChangeSheet;
  this.PrintArea=PrintArea;
  this.PrintOut=PrintOut;
  this.xlsVisible=xlsVisible;
  this.SetRowCount=SetRowCount;
  this.HeaderMain=HeaderMain;
  this.WriteSubHeader=WriteSubHeader;
  return this;
}

function AddBook(fileName)
{
       // http://localhost/trakcarelive/med/Results/Template/DHCMed.INF.Report.xls
       if (fileName&&fileName!==""){
		try {
			this.xlBook = this.xlApp.Workbooks.Add(fileName);
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
	this.xlSheet=this.xlBook.Worksheets(1);
	return true;
}

function xlsVisible(IsProceVisible)
{
	if (IsProceVisible==true){
		this.xlApp.visible = true;
	}else{
		this.xlApp.visible = false;
	}
}

// Save workook
function SaveBook(FileName)
{
	if (FileName=="" || typeof(FileName)=="undefined"){
		var fname = this.xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
		if (fname!=""){
			this.xlBook.SaveAs(fname);
		}
	}else{
		this.xlBook.SaveAs(FileName);
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
		this.xlSheet.Cells(Row, Col).Value=value;
		return true;
	}else {
		return false;
	}
}

//Write Date to Cell
function WriteSubHeader(Row, Col, value){
	if (this.xlSheet){
		//this.xlSheet.Rows(Row).HorizontalAlignment = 3;
		this.xlSheet.Cells(Row, Col).HorizontalAlignment = 3;
                this.xlSheet.Cells(Row, Col).Font.Size=12;
                this.xlSheet.Cells(Row, Col).Font.Bold = true;
                this.xlSheet.Cells(Row, Col).Font.Name="宋体";   //设置字体
		this.xlSheet.Cells(Row, Col).Value=value;
		
		return true;
	}else {
		return false;
	}
}

// Read Date from Cell
function ReadData(Row, Col){
	if (this.xlSheet) {
		return this.xlSheet.Cells(Row,Col).Value; 
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
	if ((typeof(IsPreview)=="boolean")&&(IsPreview==true)){
		this.xlSheet.PrintPreview();
	}else{
		this.xlSheet.PrintOut();
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

function SetRowCount(nums){	
  if(typeof(nums)=="number"){	
    this.RowCount=this.RowCount+nums;	
  }
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HeaderMain(rowN,str) 
{
    this.xlSheet.Rows(rowN).RowHeight=20; 
    this.xlSheet.Rows(rowN).HorizontalAlignment = 3;
    this.xlSheet.Rows(rowN).Font.Size=16;
    this.xlSheet.Rows(rowN).Font.Size=16;
    this.xlSheet.Rows(rowN).Font.Size=16;
    this.xlSheet.Rows(rowN).Font.Name="宋体";   //设置字体
    this.xlSheet.Range(this.xlSheet.Cells(rowN,1),this.xlSheet.Cells(rowN,7)).mergecells=true; //合并单元格
    this.xlSheet.Range(this.xlSheet.Cells(rowN,1),this.xlSheet.Cells(rowN,7)).value=str;
}


////////////////////2010-11-11 //////////add by cjb  for GetDataFrom DB

