function AddFrame(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1;
}
                  // xlsSheet,0,    0,  7,   5,  row+1,   1
function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1;
}                      
function FrameGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(7).LineStyle=-4119;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(10).LineStyle=-4119;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(9).LineStyle=-4119;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(8).LineStyle=-4119;
} 
function SetRowH(obj , sel , Heigh) //set row height
{  
    obj.Rows(sel).Select
    obj.Rows(sel).RowHeight = Heigh
}
function xlstyle(objSheet,row,c1,c2,no)
{
    objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).HorizontalAlignment =no;
}
    
    //Selection.ClearContents                     
function ClearContents (objSheet,str)
{        
    objSheet.Range(str).ClearContents();
    //objSheet.Range(objSheet.Cells(srow, c1), objSheet.Cells(erow,c2)).ClearContents();
}
   //HorizontalAlignment
function xlcenter(objSheet,row,c1,c2)
{
    objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).HorizontalAlignment =-4108;
}
function nxlcenter(objSheet,row1,row2,c1,c2)
{
   objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).HorizontalAlignment =-4108;
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
function FontStyle(objSheet,row,c1,c2,num)
{
    objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).Font.Size =num;
}
function nfontcell(objSheet,row1,row2,c1,c2,num)
{
    objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Font.Size =num;
}
function gridlist(objSheet,row1,row2,c1,c2)
{
    objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1;
}
function gridlistlink(objSheet,row1,row2,c1,c2)
{
	for (i=row2;i<=row1;i++)
	{
		for (j=c1;j<=c2;j++)
		{
			var tmpstr=objSheet.Cells(i, j).text
			var tmpArr=tmpstr.split("____");
			if ((tmpstr!="")&&(tmpArr.length!=1))
			{
		        objSheet.Range(objSheet.Cells(i, j), objSheet.Cells(i,j)).Borders(8).LineStyle=-4142;
		        var tmpstr2=objSheet.Cells(i-1, j).text;
			    var tmpArr2=tmpstr2.split("____");
		        if ((tmpstr2!="")&&(tmpArr2.length==1))
		        {
		            objSheet.Cells(i-1, j)="* "+tmpstr2;			
		        }
			}
		}
	}	   
 }

function ExcelSet(objSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)
{
    var titleRowsStr, titleColsStr
    if ((titleRows > 0)&&( titleRows < 6)) {titleRowsStr="$1:$"+titleRows}
    else { titleRowsStr = ""}
    titleColsStr = "";
    if (titleCols==1) titleColsStr = "$A:$A"    //'maxcols is 5
    if (titleCols==2) titleColsStr = "$A:$B"
    if (titleCols==3) titleColsStr = "$A:$C"
    if (titleCols==4) titleColsStr = "$A:$D"
    if (titleCols==5) titleColsStr = "$A:$E"
   
    objSheet.PageSetup.PrintTitleRows = titleRowsStr
    objSheet.PageSetup.PrintTitleColumns = titleColsStr
        
    objSheet.PageSetup.PrintArea = ""
    objSheet.PageSetup.LeftHeader = LeftHeader
    objSheet.PageSetup.CenterHeader = CenterHeader
    objSheet.PageSetup.RightHeader = RightHeader
    objSheet.PageSetup.LeftFooter = LeftFooter
    objSheet.PageSetup.CenterFooter = CenterFooter
    objSheet.PageSetup.RightFooter = RightFooter
}

function gridlistRow(objSheet,row1,row2,c1,c2)
{
    objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
    objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1;
}
function ClearXls(objSheet,xlsTop,xlsLeft,xlsBottom,xlsRight)
{
    for (var i=xlsTop;i<=xlsBottom;i++){
	    for (var j=xlsLeft;j<=xlsRight;j++){
		    objSheet.cells(i,j)="";
	    }
	}
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsBottom,xlsRight)).Borders(3).LineStyle=-4142;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsBottom,xlsRight)).Borders(4).LineStyle=-4142;
}
function gridlisttwocol(objSheet,row1,row2)
{
	var i,j;
	for (i=row1;i<=row2;i++)
	{
		var tmpstr=objSheet.Cells(i, 1).text + objSheet.Cells(i, 2).text
		var prestr=tmpstr;
		for (j=i+1;j<=row2;j++)
		{
			var tmpstr2=objSheet.Cells(j, 1).text + objSheet.Cells(j, 2).text
			if ((tmpstr2!="")&&(tmpstr2==prestr))
			{
				objSheet.Cells(j, 1)="";
				objSheet.Cells(j, 2)="";
				i=j;
			}
			else 
			{
				break;	
			}
		}
	}	   
 }
function KillGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=0 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=0 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=0 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=0 ;
}
function AddOutFrame(objSheet,fRow,fCol,tRow,tCol)
{        
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow, fCol)).Borders(7).LineStyle=1;
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(fRow, tCol)).Borders(8).LineStyle=1;
    objSheet.Range(objSheet.Cells(tRow, fCol), objSheet.Cells(tRow, tCol)).Borders(9).LineStyle=1;
    objSheet.Range(objSheet.Cells(fRow, tRow), objSheet.Cells(tRow, tCol)).Borders(10).LineStyle=1;
}
function gridlistRowMergy(objSheet,row1,row2,c1,c2)
{
    for (i=row2;i<=row1;i++)
	{
		var tmpstr=objSheet.Cells(i, c1).text;
		var tmpArr=tmpstr.split("____");
		if (tmpArr.length<2)
		{
    		objSheet.Range(objSheet.Cells(i, c1), objSheet.Cells(i,c2)).Borders(3).LineStyle=1;
		}
	}
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row1,c2)).Borders(4).LineStyle=1;
}