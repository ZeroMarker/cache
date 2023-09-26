// /名称: 入库单倒入
// /描述: 入库单倒入

function MakeRecFromTxt(file,Fn )
{
	// file :txt文件名称
	var fso = new ActiveXObject("Scripting.FileSystemObject"); 
	var ForReading = 1, ForWriting = 2;
	ts = fso.OpenTextFile(file,ForReading); 
	var cnt=0;
	try
	{
		var ret;
	    while (ts.AtEndOfStream==false)
		{
			// 读取文件一行内容到字符串 
			s = ts.ReadLine(); 
			cnt++;
			if(cnt==1){
				continue;		//过滤表头
			}
			if (Fn(s, cnt)==false)	return ;
		}	
	}
	catch(e)
	{
		return ;
	}
	
	ts.Close();
	 //读取成功后，改掉名称
	var fileRead=file.substr(0,file.indexOf("."));
	fileRead=fileRead+".old";		
	
	var f1=fso.GetFile(file);	
	f1.Copy(fileRead);	
	
}

// 代码 ------- 发票号---- - 数量----- - 单价----- 金额 - ----批号- ------效期------
function ReadFromExcel(fileName, Fn){
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return false;
	}

	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: 使用第一个sheet
		ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn);
	}catch(e){
		Msg.info('error', '读取Excel失败:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return;		//没有return时,EXCEL.exe进程结束不了,why?
}

function ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	
	var StartRow = 1;		//第2行开始
	for(var i = StartRow; i < rowsLen; i++){
		//var rowData = xlsSheet.Range[ 'A1:G1' ].Copy;	//这句不能用, why?
		var rowData = '';
		for(var j = 0; j < colsLen; j++){
			var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
			CellContent = typeof(CellContent)=='undefined'? '' : CellContent;
			if(!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date'){
				CellContent = new Date(CellContent).format(ARG_DATEFORMAT);
			}
			if(j == 0){
				rowData = CellContent;
			}else{
				rowData = rowData + '\t' + CellContent;
			}
		}
		Fn(rowData, i+1);
	}
}


