//for shenyang   中国医大
function PrintSYYDSSD()  
{	
	if(arguments[0].text=="全部打印")
	{
		PrintSYYDOPANList("SYYSSD","N","A");
	}
	else
	{
		PrintSYYDOPANList("SYYSSD","N","S");
	}
}

function PrintSYYDOPANList(prnType,exportFlag,selPrintTp)  //LHW20110806SYYD
{
	var parent=objControlArry['ViewScreen'];
	if (prnType=="") return;
	var name,fileName,path,operStat,printTitle,operNum;
	var xlsExcel,xlsBook,xlsSheet;
	var row=3;
	var booleanSQD=false;
	var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	path=GetFilePath();
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	printTitle=_UDHCANOPSET.GetPrintTitle();
	var printStr=printTitle.split("!");
	if (printTitle.length<4) return;
	name=printStr[0];	
	fileName=printStr[1];
	fileName=path+fileName;
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) ;
	xlsSheet = xlsBook.ActiveSheet;
	operStat=printStr[2];
	var strList=printStr[3].split("^")
	var printLen=strList.length;
	for (var i=0;i<printLen;i++)
	{
		xlsSheet.cells(row,i+1)=strList[i].split("|")[0];
	}
	var row=3;
	operNum=0;
	var preLoc="";
	var preRoom="";
	var count=parent.retGridPanelStore.getCount();//数据行数
	for (var i=0;i<count;i++)
	{
		var chk="";
		var record=parent.retGridPanelStore.getAt(i);
		chk=record.get('checked');
		var stat=record.get('status');
		if (((selPrintTp=="A")&&((stat==operStat)||(operStat=="")))||((selPrintTp=="S")&&(chk==true)))
		{
			booleanSQD=true;
			row=row+1;
			operNum=operNum+1;
			//Sort by loc, insert empty row between different loc 
			var loc=record.get('loc');
			var locarr=loc.split("/");
			if (locarr.length>1) loc=locarr[0];
			if ((preLoc!="")&&(preLoc!=loc))
			{
				for(var j=0;j<printLen;j++)
				{
					xlsSheet.cells(row,j+1)="";
				}
				row=row+1;
			}
			for(var j=0;j<printLen;j++)
			{
				var colName=strList[j].split("|")[1];
				var colVal=record.get(colName)
				if(colVal)
				{
					if ((colName=="oproom")||(colName=="opordno"))
					{
						if((colVal=='无')||(colVal=='未排')) xlsSheet.cells(row,j+1)="";
						else xlsSheet.cells(row,j+1)=colVal
					}
					else if(colName=="opname")
					{
						var opName=colVal.split(';');
						var colValLen=colVal.length;
						var firstOpNameLen=opName[0].length;
						xlsSheet.cells(row,j+1).FormulaR1C1=colVal;
						xlsSheet.cells(row,j+1).Characters(1,firstOpNameLen).Font.Name="宋体";
						xlsSheet.cells(row,j+1).Characters(firstOpNameLen+2,colValLen-firstOpNameLen).Font.Italic=true;
					}
					else
					{	
						xlsSheet.cells(row,j+1)=colVal;
					}
				}
				else xlsSheet.cells(row,j+1)="";
			}
			preLoc=loc;
		}	
	}
	if(booleanSQD)
	{
		PrintSYYDTitle(xlsSheet,prnType,printStr,operNum,preLoc);
		titleRows=3;
		titleCols=1;
		LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
		ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter);
		AddGrid(xlsSheet,3,0,row,printLen-1,3,1);
		FrameGrid(xlsSheet,3,0,row,printLen-1,3,1);
	}
	if (exportFlag=="N")
	{
		if (booleanSQD) 
		{
			xlsSheet.PrintOut(); 
		}
		else
		{
			alert("主任未审核,不能打印!");
		}
	}
	else
	{
		if (exportFlag=="Y")
		{
			var savefileName="C:\\Documents and Settings\\";
			var savefileName=_UDHCANOPSET.GetExportParth()
			var d = new Date();
			savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xls"
			xlsSheet.SaveAs(savefileName);	
		}	
	}
	xlsSheet = null;
	xlsBook.Close(savechanges=false)
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}

function GetFilePath()
{   
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var path=_DHCLCNUREXCUTE.GetPath();
	return path;
}

function PrintSYYDTitle(objSheet,PrnTyp,printStr,operNum,preLoc)
{
	var parent=objControlArry['ViewScreen'];
	var sheetName=printStr[0];	
	var setList=printStr[3].split("^")
	var colnum=setList.length;
	var _DHCCLCom=ExtTool.StaticServerObject('web.DHCCLCom');
	var hospitalDesc=_DHCCLCom.GetHospital()
	mergcell(objSheet,1,1,colnum);
	xlcenter(objSheet,1,1,colnum);
	fontcell(objSheet,1,1,colnum,16);
	var OperStartDate=parent.dateFrm.getRawValue();
	var tmpOperStartDate=OperStartDate.split("/");
	if (tmpOperStartDate.length>2)
		OperStartDate=tmpOperStartDate[2]+" 年 "+tmpOperStartDate[1]+" 月 "+tmpOperStartDate[0]+" 日";
	objSheet.cells(1,1)=hospitalDesc+sheetName;
	mergcell(objSheet,2,1,colnum);
	fontcell(objSheet,2,1,colnum,10);
	var d=new Date();
	objSheet.cells(2,1)="手术室:"+preLoc+"        通知日期:"+tmpOperStartDate[2]+" 年 "+tmpOperStartDate[1]+" 月 "+d.getDate()+"日                              "+"手术日期:"+OperStartDate;
}