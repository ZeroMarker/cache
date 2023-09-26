var ExcelObj=""
var ExcelBook=""
var ExcelSheet=""
var ExcelRows=0  
var ExcelCols=0
var del="^"
var sep="@"
var FetchRows=2000
var CircleNums=2
function DisplayError(RetClass,i)
{
	window.status="��������:"+i+"��"
	if ((RetClass!="")&&(RetClass!="Ok"))
		{
			RetStr=ConvertEnter("��"+(i)+"��"+RetClass);
			if (ErrorText=="") {ErrorText=RetStr;}
			else {ErrorText=ErrorText+"\n"+RetStr;}
		}		
}
function DHCFAddToList(ListElement,ListMethodElement,Para)
{
	var sep="&"
	var ListMethodElementObj=document.getElementById(ListMethodElement);
	if (ListMethodElementObj) {} else {return 1+"^"+ListMethodElement };
	var ElementObj=document.getElementById(ListElement);
	if (ElementObj) {} else {return 1+"^"+ListElement };
	if (ListMethodElementObj) {var encmeth=ListMethodElementObj.value} else {var encmeth=''};
	var ListStr=cspRunServerMethod(encmeth, Para);
	if (ListStr.length<1) {return "1.1"+"^"+ListMethodElement}; 
	
	ElementObj.size=1;
	ElementObj.multiple=false;
	ElementObj.options.length=0;
	var ListRow=ListStr.split(del);
	for (i=0;i<ListRow.length;i++)
	{   
	    var ListTxt=ListRow[i].split(sep)
		ElementObj.options[i]=new Option (ListTxt[1],ListTxt[0]);
	}
	ElementObj.options[0].selected=true;
	return ""
}
function DHCFGetCellValue(Element){
	var RetValue="";
	var ElementObj=document.getElementById(Element);
	if (ElementObj)
	{
		switch (ElementObj.type)
		{
			case "checkbox":
				RetValue=ElementObj.checked;
				break;
			case "text":
				RetValue=ElementObj.value;
				break;
			case "hidden":
				RetValue=ElementObj.value;
				break;
			case "select-one":
				var myidx=ElementObj.selectedIndex;
				RetValue=ElementObj.options[myidx].text;
				break;
			default:
				RetValue=ElementObj.innerText;
		}
	}
	
	return RetValue;
}
function ExcelOpen(FileName) //��EXCEL�ļ�
	{
    	//FileName="e:\\mystudy\\fhqiqiq.xls"
		
    	if ((ExcelObj=="") || (ExcelObj==null))
    		{	
    			ExcelObj = new ActiveXObject("Excel.Application");
    			ExcelObj.DisplayAlerts = false;
    		}  //��� Excel û��������������
    	if (FileName.length > 0) {ExcelBook = ExcelObj.Workbooks.Open(FileName)}
    	else {ExcelBook = ExcelObj.Workbooks.Add}
		ExcelSheet = ExcelBook.Worksheets(1)
     	ExcelSheet.Activate
		
	}
function ExcelClose(SaveType) //�ر�EXCEL�ļ�
	{	
		
		if (SaveType!="") 
			{	var FileName=""
				FileName = ExcelObj.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
				if ((FileName!="")&&(FileName!=false)) {alert(FileName);ExcelBook.SaveAs(FileName)}
			
			}
		ExcelBook.Close (savechanges=false);
		//xls.visible = false;
		ExcelObj.Quit();
		ExcelObj=null;
		
	}
function ReadFromExcel(FileName,Circle) //��EXCEL�ļ��ж�ȡ����
	{	if (Circle>CircleNums) {return ""}
		ExcelOpen(FileName);
		ExcelRows=ExcelSheet.UsedRange.Cells.Rows.Count;   
		ExcelCols=ExcelSheet.UsedRange.Cells.Columns.Count;
		CircleNums=Math.ceil(ExcelRows/FetchRows)
		
		var TmpValue=""
		var FromRow=(Circle-1)*FetchRows+1
		var EndRow=(Circle)*FetchRows+1
		if (FromRow>ExcelRows){return ""}
		if (EndRow>ExcelRows){EndRow=ExcelRows+1}
		if (FromRow>EndRow) {return ""}
		var RowArray=new Array()
		var ind=0
		for (i=FromRow;i<EndRow;i++)
			{	var rowstr=""
				for (j=1;j<ExcelCols+1;j++)
					{	
					  TmpValue=ExcelSheet.Cells(i,j).text+sep+ExcelSheet.Cells(i,j).ColumnWidth
						if (j==1){rowstr=TmpValue}
						else {rowstr=rowstr+"^"+TmpValue}
					}
				RowArray[ind]=rowstr
				window.status="��ȡ"+FileName+"  :"+i+"��"
				ind=ind+1
			}
		ExcelClose("")
		return RowArray
		
	}
function TableFill(TableName,TableData,FromRow,EndRow,Circle)  //����TABLE���������������
	{	
	   
		var TableObj=document.getElementById(TableName)
		if (!TableObj) {return}
		var tbody = document.createElement("TBODY")
		var RowNum=TableData.length
		var TmpStr=""
		var ColText=""
		var TableWidth=0
		//if (ExcelRows>RowNum) {ExcelRows=Rownum;}
		if (FromRow=="") {FromRow=1}
		if (EndRow=="") {EndRow=RowNum}
		
		for (var i=FromRow;i<EndRow+1;i++)
			{	var TableRow= document.createElement("TR"); 
				var RowStr=TableData[i-1].split(del)
				delete TableData[i-1];
				
				for (j=1;j<ExcelCols+1;j++)
					{	
						
						if ((j==1))  //��Ϊ��һ����Ϊ��һ��ʱ��һ�к�
							{	var TableCol=document.createElement("TH")
								TableCol.innerHTML=(i-1)+((Circle-1)*FetchRows);
							    TableCol.width=50
							 
							    if ((Circle==1)&&(j==1)&&(i==1))   //��һ����Ϊ��һ��ʱ�ӱ���
									{	
										TableCol.innerHTML="�к�";
							  		TableCol.width=50
		
									}
							    TableRow.appendChild(TableCol)
							}
						
						if (i!=1) {var TableCol=document.createElement("TD")}
						else {var TableCol=document.createElement("TH")}
						
						if (j<=RowStr.length) 
						    {	
						      ColText=RowStr[j-1].split(sep)
							    TableCol.innerHTML=ColText[0];
							    TableCol.width=ColText[1]*10
							 
							    if (i==FromRow) {TableWidth=TableWidth+ColText[1]*10}
							 }
						else {TableCol.innerHTML="";}
						
						TableRow.appendChild(TableCol)
					}
					
				tbody.appendChild(TableRow)	
				window.status="�����:"+i+"��"		
				
			}
		TableObj.appendChild(tbody)
		TableObj.width=TableWidth

	}
function SetTableWidth(FirstTableName,SecondTableName)  //�����������Ŀ��Ϊһ��
{	
	var FirstTableNameObj=document.getElementById(FirstTableName)
	var SecondTableNameObj=document.getElementById(SecondTableName)
	if ((!FirstTableNameObj)||(!SecondTableNameObj)) {return}
	var FirstCols=FirstTableNameObj.rows[0].cells.length
	var SecondCols=SecondTableNameObj.rows[0].cells.length
	var EndNum=FirstCols
	if (FirstCols>SecondCols) {EndNum=SecondCols}
	for (var i=0;i<EndNum;i++)
	{
		SecondTableNameObj.rows[0].cells[i].width=FirstTableNameObj.rows[0].cells[i].width
		//alert(SecondTableNameObj.rows[0].cells[i].width)
		//alert(FirstTableNameObj.rows[0].cells[i].width)
	}
	SecondTableNameObj.width=FirstTableNameObj.width
	return
}
function TableReadarea(TableData)
	{	
		if (!TableObj) {return ""}
		var TableRows=TableObj.rows.length
		var TableCols=0
		var RetArray=new Array(TableRows)
		var TmpStr=""
		for (i=0;i<TableRows;i++)
			{	
				TableCols=TableObj.rows.item(i).cells.length
				for (j=1;j<TableCols;j++) 
					{	if (j!=1) {TmpStr=TmpStr+del+TableObj.rows.item(i).cells.item(j).innerText}
						else {TmpStr=TableObj.rows.item(i).cells.item(j).innerText}		
					}
				RetArray[i]=TmpStr
				window.status="��ȡ���:"+i+"��"
			}
		return RetArray
	}
function TableRead(TableData,Serial)
	{	
		
		var TableObj=document.getElementById(TableData)
		if (!TableObj) {return ""}
		var TableRows=TableObj.rows.length
		var TableCols=0
		
		var TmpStr=""
		var num=0
		var StartRow=Serial*FetchRows
		var EndRow=(Serial+1)*FetchRows
		if (EndRow>TableRows) {EndRow=TableRows}
		var RetArray=new Array()
		for (i=StartRow;i<EndRow;i++)
			{	TableCols=TableObj.rows.item(i).cells.length
				for (j=1;j<TableCols;j++) 
					{	if (j!=1) {TmpStr=TmpStr+del+TableObj.rows.item(i).cells.item(j).innerText}
						else {TmpStr=TableObj.rows.item(i).cells.item(j).innerText}		
					}
				num=num+1;
				RetArray[num-1]=TmpStr;
				window.status="��ȡ���:"+(i+1)+"��";	
			}
		return RetArray;
	}
function ConvertEnter(ConStr)
{	var RetStr=""
		if (ConStr=="") {return ""}
		var TmpStr=ConStr.split(sep)
		for (var i=0;i<TmpStr.length;i++)
			{	if (i!=0) {RetStr=RetStr+"\n"+"    "+TmpStr[i]}
				else  {RetStr=TmpStr[i]}
			}
		return RetStr
}
function MoveCursor(ObjectName)	  //�����¼��ƶ���¼
{
	var ObjectNameObj=document.getElementById(ObjectName);
	if (!ObjectNameObj) {return;}
	if (ObjectNameObj.tagName=="INPUT")
	{
		if (ObjectNameObj.type=="text")  
			{if (event.keyCode==13)	{event.keyCode=9;return;}}
	}
	//alert(ObjectNameObj.type)
	if (ObjectNameObj.tagName=="TABLE")
	{	if (event.keyCode==38)  //����
		{	if (selectedRowObj.rowIndex==""){return;}
			var SelectRow=selectedRowObj.rowIndex;
			if (SelectRow<0) 	{	return;	}
			if (SelectRow=="") {return;}
			if (SelectRow==1) {return;}
			var TableRow=ObjectNameObj.rows[SelectRow-1];
			TableRow.click();
		}
	
		if (event.keyCode==40)  //����
		{	if (selectedRowObj.rowIndex==""){return;}
			var SelectRow=selectedRowObj.rowIndex;
			if (SelectRow<0) 	{return;}
			if (SelectRow=="") {return;}
			if (SelectRow==(ObjectNameObj.rows.length-1)) {return;}
			var TableRow=ObjectNameObj.rows[SelectRow+1];
			TableRow.click();
		}
		return;
	}
}
function Error(ErrorCode)
{
	if (ErrorCode==1) {return "Ԫ�ز�����"}
	if (ErrorCode==1.1) {return "Ԫ���ڵķ�������"}
	if (ErrorCode==3) {return "�������Ϊ��"}
	
}
