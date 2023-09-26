function GridExportExcel(objGrid)
{
	var objFSO = new ActiveXObject("Scripting.FileSystemObject");
	var objTmpFolder = objFSO.GetSpecialFolder(2);
	var tmpFileName = objTmpFolder.Path + "\\" + objFSO.GetTempName();
	var objFile = objFSO.CreateTextFile(tmpFileName, true, true);
	var strHTML = "<HTML><BODY>\r\n";
	strHTML += "<STYLE>\r\n";
	strHTML += "td {padding:0 0 0 0;margin:0 0 0 0;height:23px;border:none;border-color:Gray;}\r\n";
	strHTML += "th {padding:9px;line-height:18px;text-align:left;vertical-align:top;border:none;background-color:rgb(238,238,238)}\r\n";
	strHTML += "</STYLE>\r\n";
	strHTML += "<TABLE>";
	strHTML += "<TR>";
	for(var i = 0; i < objGrid.Cols; i ++){
		if(objGrid.TextMatrix(0, i)  == "") continue;
		//记录有关号码的位置
	    var index1,index2, index3,index4
		if(objGrid.TextMatrix(0, i).indexOf("病案号")>-1) {
		   index1=i;
		}else if(objGrid.TextMatrix(0, i).indexOf("住院号")>-1) {
		   index2=i;
		}else if(objGrid.TextMatrix(0, i).indexOf("健康卡号")>-1) {
		   index3=i;
		}else if(objGrid.TextMatrix(0, i).indexOf("身份证件号")>-1) {
		   index4=i;
		}
		strHTML += "<TH>" + objGrid.TextMatrix(0, i) + "</TH>"
	}
	strHTML += "</TR>\r\n"
	objFile.WriteLine(strHTML);
	strHTML = "";
	for(var i = 1; i < objGrid.Rows; i ++){
		strHTML = "<TR>"
		
		for(var col = 0; col < objGrid.Cols; col ++) {
			strHTML += "<TD>";
			if(objGrid.TextMatrix(i, col) != "")
				//strHTML += objGrid.TextMatrix(i, col);
				//号码是数字类型的都转换成字符串
				if ((col==index1)||(col==index2)||(col==index3)||(col==index4)){
				  strHTML +="'"+objGrid.TextMatrix(i, col);
				}else {
				  strHTML += objGrid.TextMatrix(i, col);
				}
			else
				strHTML += "&nbsp;"
			strHTML += "</TD>";
		}
		
		strHTML += "</TR>\r\n"
		objFile.WriteLine(strHTML);
	}
	
	objFile.WriteLine("</TABLE>\r\n");
	objFile.WriteLine("</BODY>\r\n");
	objFile.Close();	
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	var objBook = objExcel.Workbooks.Add(tmpFileName);
	objExcel.Application.Dialogs.Item(5).Show("report.xls", 1);
}