
function setLeft(sheet,row,col)
{  //xlLeft:-4131
   sheet.Range(sheet.Cells(row,col),sheet.Cells(row,col)).HorizontalAlignment =-4131;
}

function setRight(sheet,row,col)
{  //xlRight:-4152
   sheet.Range(sheet.Cells(row,col),sheet.Cells(row,col)).HorizontalAlignment =-4152;
}
function nxlcenter(objSheet,row1,row2,c1,c2)
{  //
 objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).HorizontalAlignment =-4108;
}

function xlVertCenter(objSheet,row,c1,c2)
{  //xlCenter:-4108
objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).VerticalAlignment =-4108;
}
function xlVertBottom(objSheet,row,c1,c2)
{  //xlBottom :-4107
objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).VerticalAlignment =-4107;
}
function xlVertTop(objSheet,row,c1,c2)
{  //xlTop :-4160
objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).VerticalAlignment =-4160;
}

function setBottomLine(objSheet,row,startcol,colnum)
{   //single line
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}

function setBottomDblLine(objSheet,row,startcol,colnum)  
{   //double line 
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=-4119 ;
}
function setBottomPieceLine(objSheet,row,startcol,colnum)  
{   //internal line 
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=-4118 ;
}

function mergcell(objSheet,row,c1,c2)
{
	objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).MergeCells =1;
}
function nmergcell(objSheet,row1,row2,c1,c2)
{
    objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).MergeCells =1;
}
function fontcell(objSheet,row,c1,c2,num)
{
	objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).Font.Size =num;
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1;
}

function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
}
