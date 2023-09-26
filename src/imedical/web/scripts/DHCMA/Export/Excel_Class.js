var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function ExportGridByCls(grid,filename)
{
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
    var columns = grid.options().columns[0];
	var rows=grid.getData().originalRows;   //������������
	
	for (var i = 0; i < columns.length; i++) {
	 	if ((columns[i].hidden)||(!columns[i].title)||(columns[i].title=="����")) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //�����в�д��
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
    
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {	
			if ((columns[j].hidden)||(!columns[j].title)||(columns[j].title=="����")) continue;   //�����в�д��
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	xlSheet.Cells.EntireColumn.AutoFit;  //�п�����Ӧ
	
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
		//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}
/// Filter Titles  ����������ѯ
function ExportMainOfGrid(grid,filename)
{
	var hideCols = "";
	if (!!arguments[2]){
		hideCols = arguments[2];
	}
	
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
    var columns = grid.options().columns[0];
	var rows=grid.getData().originalRows;   //������������
	
	for (var i = 0; i < columns.length; i++) {
	 	if ((columns[i].hidden)||(!columns[i].title)) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //�����в�д��
		}
		if (hideCols!=""){
			if(hideCols.indexOf(columns[i].title) >= 0){
				xlSheet.Columns(i+1).Hidden = true;	
		 		continue;   //�����в�д��
			}
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
    
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {		
			if ((columns[j].hidden)||(!columns[j].title)) continue;   //�����в�д��
            if (hideCols!=""){
				if(hideCols.indexOf(columns[j].title) >= 0){
		 			continue;   //�����в�д��
				}
			}
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	xlSheet.Cells.EntireColumn.AutoFit;  //�п�����Ӧ
	
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
		//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}
function PrintGridByCls(grid,filename)
{
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return null;
	}
	xls.Visible = true;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
	var columns = grid.options().columns[0];
	var rows=grid.getData().originalRows;   //������������
	for (var i = 0; i < columns.length; i++) {
		if ((columns[i].hidden)||(!columns[i].title)) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //�����в�д��
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
	
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {		
			if ((columns[j].hidden)||(!columns[j].title)) continue;   //�����в�д��		
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	xlSheet.printout();
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}

function ExportCheckGridByCls(grid,filename)
{
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch (e) {
		xls =null;
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return null;
	}
	xls.Visible = false;
	xlBook = xls.Workbooks.Add();
	xlSheet=xlBook.Worksheets(1);
	
    var columns = grid.options().columns[0];
	var rows=grid.getChecked();   //ѡ�������
    
	for (var i = 0; i < columns.length; i++) {
		if ((columns[i].hidden)||(!columns[i].title)||(columns[i].title=="����")) {
		 	xlSheet.Columns(i+1).Hidden = true;	
		 	continue;   //�����в�д��
		}
		var title =columns[i].title;
		title = ReplaceText(title, "<BR/>", "\n");
		title = ReplaceText(title, "<br/>", "\n");
		title = ReplaceText(title, "<br>", "\n");
		xlSheet.Cells(1, i + 1).value = title;	
    }
    for (var i = 0; i <rows.length; i++) {
        for (var j = 0; j < columns.length; j++) {		
			if ((columns[j].hidden)||(!columns[j].title)||(columns[j].title=="����")) continue;   //�����в�д��	
            if (rows[i][columns[j].field] != null) {
				xlSheet.Cells(i + 2, j + 1).NumberFormatLocal = "@";
				xlSheet.Cells(i + 2, j + 1).value = rows[i][columns[j].field].toString();            
            } else {			
               xlSheet.Cells(i + 2, j + 1).value = "";
            }
        }
	}
	xlSheet.Cells.EntireColumn.AutoFit;  //�п�����Ӧ
	if (filename){
		filename = filename + ".xls"
	} else {
		filename = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
		//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	
	return true;
}

function ReplaceText(str, find, repl)
 {
 	var strTmp = str;
 	while(strTmp.indexOf(find) >=0)
 	{
 		strTmp = strTmp.replace(find, repl);	
 	}	
 	return strTmp;
 }

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			//���õ�Ԫ���ʽ���ı���
			cells(cRow+i,cCol+j).NumberFormatLocal = "@";
			//����Ԫ��ֵ
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//����Ԫ��
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//��Ԫ��ϲ�
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//��Ԫ�����
//-4130 �����
//-4131 �Ҷ���
//-4108 ���ж���
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}