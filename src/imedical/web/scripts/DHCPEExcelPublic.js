/// DHCPEExcelPublic.js

///ʵ�ֲ���Excel�Ĺ��ܺ���

function DHCPEExcel(FilePath,IsVisible) {
	
  
	this.FilePath=FilePath;
	try {
		this.xlApp = new ActiveXObject("Excel.Application");
	}
	
	catch (e) {
		this.xlApp =null;
		alert("���ļ�ʧ��: \n�����:"+e.number+'\n\n����:\n\n'+e.description);
		return null;
	}
 
	try {

		this.xlBook = this.xlApp.Workbooks.Add(this.FilePath);
	}
	catch (e) {
		this.xlBook = null;
		this.xlApp =null;
		alert("���ļ�ʧ��: \n�����:"+e.number+'\n\n����:\n\n'+e.description);
		return null;
	}
	
    //this.xlsheet = this.xlBook.WorkSheets("Sheet2"); 

	this.sheetName="";
	
	if (IsVisible) {
		// �Ƿ����
		this.xlApp.Visible = true;
	}
 
	// ���ܺ���
	this.id=this.FilePath;
	this.Colse=DHCPEExcel_Colse;					// �رն���
	this.GetSheet=DHCPEExcel_GetSheet;				// ��ȡ���ӱ��(sheet)����
	this.writeData=DHCPEExcel_writeData;			// д������
	this.writeDataToRow=DHCPEExcel_writeDataToRow;	// 
	this.ReadData=DHCPEExcel_ReadData;				// ��ȡ����
	this.writeDataToCol=DHCPEExcel_writeDataToCol;	// 
	this.Borders=DHCPEExcel_Borders;				// ���߿���
	this.SetSheet=DHCPEExcel_SetSheet;				// �����ӱ��������
	this.SaveTo=DHCPEExcel_SaveTo;					// �ļ����Ϊ
	this.Print=DHCPEExcel_Print;		            // ��ӡ(��ֹ��ӡ����)
	this.SetPrintArea=DHCPEExcel_SetPrintArea;		// ���ô�ӡ����
	this.Merge=DHCPEExcel_Merge;					// �ϲ���Ԫ��
	// ������
	this.Error=false;
	this.Code='';
	this.Message='';
	
	this.ShowMessage=DHCPEExcel_ShowMessage;
	this.Debug=false;

	return this;
}

// �ر� Excel �ļ�
// IsSavechanges �Ƿ񱣴�
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

// �����ֻ�ȡ Excel ������
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
				this.ShowMessage('δ�ҵ�'+sheetName+'������! \n'+e.toString(), 'E', 1);
				return false;
			}
			this.sheetName=sheetName;
			return true;
		}
	}
	return false;
}

// �����ӱ�����
function DHCPEExcel_SetSheet(oldName, NewName){
	this.ShowMessage("", 'E', 0);
	if (oldName && ""!=oldName) {
		this.GetSheet(oldName);

	}
	this.xlsheet.Name=NewName;
	this.GetSheet(NewName);
	return true;	
}

// Excel ���Ϊ
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
		// ע�ⱻ�ϲ���Ԫ���ֵ�ǲ����ڵ�(��Ԫ�����Ǵ��ڵ�-Objectֻ��Ϊ��)
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

// ���ñ߿�(��ɫ)ʵ��
// BordersIndex = 'LEFT^'+'TOP^'+'BOTTOM^'+'RIGHT^'
function DHCPEExcel_Borders(Row, Col, BordersIndex) {
	//BordersIndex=BordersIndex.upperCase();
	this.ShowMessage("", 'E', 0);
	var Range=this.xlsheet.Cells(Row,Col);
	
	// Const xlEdgeLeft = 7		Excel.XlBordersIndex �ĳ�Ա
	if (BordersIndex.indexOf("LEFT^")>-1)
	{
		Range.Borders(7).LineStyle = 1;
		Range.Borders(7).Weight = 2;
		Range.Borders(7).ColorIndex = -4105;
	}

	// Const xlEdgeTop = 8	    Excel.XlBordersIndex �ĳ�Ա	
	if (BordersIndex.indexOf("TOP^")>-1)
	{
		//alert('TOP');
		Range.Borders(8).LineStyle = 1;
		Range.Borders(8).Weight = 2;
		Range.Borders(8).ColorIndex = -4105;
	}
		
	// Const xlEdgeBottom = 9	Excel.XlBordersIndex �ĳ�Ա		
	if (BordersIndex.indexOf("BOTTOM^")>-1)
	{
		Range.Borders(9).LineStyle = 1;
		Range.Borders(9).Weight = 2;
		Range.Borders(9).ColorIndex = -4105;
	}
	
	// Const xlEdgeRight = 10	Excel.XlBordersIndex �ĳ�Ա
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

// ��ӡ(��ֹ��ӡ����)
function DHCPEExcel_Print(IsPreview) {
	this.ShowMessage('', 'E', 0);
	if (IsPreview) { this.xlsheet.PrintPreview(); }
	else { this.xlsheet.PrintOut(); }

}

// ���ô�ӡ���� 
// Range : "$A$1:$I$44"
function DHCPEExcel_SetPrintArea(Range) {
	this.ShowMessage('', 'E', 0);
	this.xlsheet.PageSetup.PrintArea = Range;
}

// �ϲ���Ԫ��
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
	
	// ��Ϣ
	if ((!(Type))||('M'==Type)) {
		this.Error = false;
		this.Code=Code;
		this.Message=Message;
	}
	
	// ���ô���
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
	
	// ����
	if ('A'==Type) {
		this.Error = false;
		this.Code=Code;
		this.Message=Message;
	}
	
	if ((this.Debug)||(Debug)) {
		alert(Message);
	}
}
