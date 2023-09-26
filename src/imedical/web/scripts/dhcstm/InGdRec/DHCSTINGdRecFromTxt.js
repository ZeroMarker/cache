// /����: ��ⵥ����
// /����: ��ⵥ����

function MakeRecFromTxt(file,Fn )
{
	// file :txt�ļ�����
	var fso = new ActiveXObject("Scripting.FileSystemObject"); 
	var ForReading = 1, ForWriting = 2;
	ts = fso.OpenTextFile(file,ForReading); 
	var cnt=0;
	try
	{
		var ret;
	    while (ts.AtEndOfStream==false)
		{
			// ��ȡ�ļ�һ�����ݵ��ַ��� 
			s = ts.ReadLine(); 
			cnt++;
			if(cnt==1){
				continue;		//���˱�ͷ
			}
			if (Fn(s, cnt)==false)	return ;
		}	
	}
	catch(e)
	{
		return ;
	}
	
	ts.Close();
	 //��ȡ�ɹ��󣬸ĵ�����
	var fileRead=file.substr(0,file.indexOf("."));
	fileRead=fileRead+".old";		
	
	var f1=fso.GetFile(file);	
	f1.Copy(fileRead);	
	
}

// ���� ------- ��Ʊ��---- - ����----- - ����----- ��� - ----����- ------Ч��------
function ReadFromExcel(fileName, Fn){
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		Msg.info("warning","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
		return false;
	}

	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: ʹ�õ�һ��sheet
		ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn);
	}catch(e){
		Msg.info('error', '��ȡExcelʧ��:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return;		//û��returnʱ,EXCEL.exe���̽�������,why?
}

function ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	
	var StartRow = 1;		//��2�п�ʼ
	for(var i = StartRow; i < rowsLen; i++){
		//var rowData = xlsSheet.Range[ 'A1:G1' ].Copy;	//��䲻����, why?
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


