//PrintQueryComponent
//By LiYang 2008-09-28



var QueryTool = new Object();
QueryTool.ConnectionString = "";

//Run query 
//Parameter:
//1:ClassName
//2:QueryName
//3...Parameter
//Return value:result of a query
QueryTool.RunQuery = function()
{
	var arryResult = new Array();
	if(arguments.length < 2) return arryResult;
	var objFactory = new ActiveXObject("CacheObject.Factory");
	var tmpField = "";
	var tmpRow = "";
	if(QueryTool.ConnectionString == "")
		QueryTool.ConnectionString = objFactory.ConnectDlg();
	if (!objFactory.Connect(QueryTool.ConnectionString)) 
	{
		window.alert("Connot connect to the server!!!!");
		return arryResult;
	}
	var objResultSet = objFactory.ResultSet(arguments[0], arguments[1]);
	var intColCnt = objResultSet.GetColumnCount();
	for(var i = 1; i <= intColCnt; i ++)
	{
		tmpField = objResultSet.GetColumnHeader(i);
		tmpRow = tmpRow + tmpField + String.fromCharCode(1);
	}
	arryResult.push(tmpRow);
	var strArg = "var intResult = objResultSet.Execute("
	for(var i = 2; i < arguments.length; i ++)
	{
		if(i > 2)
			strArg += ",";
		strArg += "arguments[" + i + "]";
	}
	strArg += ");";
	eval(strArg);

	while (objResultSet.Next())
	{
		tmpRow = "";
		for(var i = 1; i <= intColCnt; i ++)
		{
		  	//update by zf 20100517
			try
			{
				tmpField = objResultSet.GetData(i);
			}catch(e)
			{
				tmpField="";
			}
			tmpRow = tmpRow + tmpField + String.fromCharCode(1);
		}
		arryResult.push(tmpRow);
	}
	objResultSet.Close();
	objResultSet = null;
	objFactory = null;
	return arryResult;
}



//Generate Excel File 
//Parameter:
//arryResult:Query Result by RunQuery
//Row:row number of table to be placed, start from 1
//Col:col number of table to be placed start from 1
//HandlerFun:After this function ended, it can call user defined function to process extra operation.
//           Fundtion sign:   handlerFn(objExcelApp, objWorkBook, objSheet)
//Scope:HandlerFunction Scope
QueryTool.CreateExcelFile = function(arryResult, Row, Col, HandlerFunction, Scope)
{
	var objExcelApp = new ActiveXObject("Excel.Application");
	var objWorkBook = objExcelApp.Workbooks.Add();
	var objSheet = objWorkBook.Worksheets.Add();
	var strRow = "";
	var arryField = null;
	if(Row == null)
		Row = 1;
	if(Col == null)
		Col = 1;
	for(var row = 0; row < arryResult.length; row ++)
	{
		strRow = arryResult[row];
		arryField = strRow.split(String.fromCharCode(1));
		for(var col = 0; col < arryField.length; col ++)
		{
			objSheet.Cells(Row + row,Col + col).Value = arryField[col];
		}
	}
	if(HandlerFunction != null)
	{
		HandlerFunction.call(Scope, objExcelApp, objWorkBook, objSheet);
	}
	else
	{
		objExcelApp.Visible = true;
	}
}