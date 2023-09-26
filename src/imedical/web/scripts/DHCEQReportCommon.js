function getPosition(ids,id)
{
	var idlist=ids.split(",");
	var Length=idlist.length;
	for(var I = 0; I < Length; I++)
	{
		if (idlist[I]==id)
		{
			return I;
		}
	}
	return -1;
}


function fillColCaption(xlsheet,row,startCol,colCaptions)
{
	var captionList=colCaptions.split(",");
	var Length=captionList.length;
	var col;
	for(var I = 0; I < Length; I++)
	{
		col=startCol+I;
		xlsheet.cells(row,col)=captionList[I];
	}
}


function fillRowData(xlsheet,row,data,colset)
{
	var dataList=data.split("^");
	var colsetList=colset.split("^");
	var Length=colsetList.length;
	for(var I = 0; I < Length; I++)
	{
		var colinfo=colsetList[I].split(":");
		
		var col=colinfo[0];
		var content=colinfo[1];
		col=parseInt(col);
		content=parseInt(content);
		///alertShow(content+"&"+col+"&"+dataList[content]);
		xlsheet.cells(row,col)=dataList[content];
		if ((col==1)&&(dataList[content]=="")) xlsheet.cells(row,1)="合计";	// Mozy	2016-4-26
		for (var J = 1; J < 5; J++)
		{
			xlsheet.cells(row,col).Borders(J).LineStyle=1; //2011-03-10 DJ
			xlsheet.cells(row,col).Borders(J).Weight=2; //2011-03-10 DJ
		}
	}
}

function PrintEQReport(templateName,isSave,savefilename,colset)
{
	var TemplatePath=GetElementValue("GetRepPath");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+templateName; ///"DHCEQVendorReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;

	    var row=PrintEQReportHeader(xlsheet);
	    
	    var HadData=true;
		var PreVendorID=0;
		var sumFee=0;
		
		var num=1;
		while (HadData)
		{
			var rtn=GetReportData(num)
			if (rtn=="")
			{
				HadData=false;
			}
			else
			{
				row=row+1;
				fillRowData(xlsheet,row,rtn,colset);
				num=num+1;
			}
			///if (num>5) HadData=false;
		}
	    
	    var row=PrintEQReportFooter(xlsheet,row);

	    if (isSave==1)
	    {	
	    	xlBook.SaveAs(savefilename);
	    	alertShow('保存成功,保存路径:'+savefilename);
	    } ///"D:\\DHCEQStatCatReport.xls"
	    else
	    {	xlsheet.printout;	}	// 打印输出
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

/*****************************************************************/

///Modified by jdl 2011-10-28 JDL0099  处理为公共的导出及打印方法?
///				导出列可设置的程序都可使用
///				增加参数TempNode:临时global里存储时用的节点
function GetNum(TempNode,job) {
    var getnum=document.getElementById('GetNum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	num=cspRunServerMethod(encmeth,TempNode,job)
	}

///Modified by jdl 2011-10-28 JDL0099  处理为公共的导出及打印方法?
///				导出列可设置的程序都可使用
///				增加参数TempNode:临时global里存储时用的节点
///	参数说明?TableName:列设置的表名
///			  SaveOrPrint:1为保存 其它为打印
///			  job:
///			  vData:替换内容
///			  TempNode:临时global里存储时用的节点
///			  
///add by jdl 2009-9-22  JDL0028
function  PrintDHCEQEquipNew(TableName,SaveOrPrint,job,vData,TempNode,GetRowsPerTime)
{
	window.clipboardData.clearData(); // Modified by QW 20170808  QW0007
	///Modified by jdl 2011-10-28 JDL0099
	if (!TempNode)
	{
		TempNode="";
	} 
	GetNum(TempNode,job);
	
	if (num<=0) {alertShow("表没值")}  //modified by QW20191216 QW0033 修改只有一条数据时不能导出
	else
	{
     try {
	     if (SaveOrPrint=="1")
	     {
		     var FileName=GetFileName();
		     if (FileName=="") {return;}
	     }
      	var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath)
		 {
			 var encmeth=GetPrescPath.value
			 } 
		else 
		{
			var encmeth=''
			};
		if (encmeth!="") 
		{
			var	TemplatePath=cspRunServerMethod(encmeth);
			}
			
		encmeth=GetElementValue("GetColSets");
		var	colsets=cspRunServerMethod(encmeth,"","2","",TableName); //用户级设置
		if (colsets=="")
		{
			var	colsets=cspRunServerMethod(encmeth,"","1","",TableName); //安全组级设置
			if (colsets=="")
			{
				var	colsets=cspRunServerMethod(encmeth,"","0","",TableName); //系统设置
			}
		}
		if (colsets=="")
		{
			alertShow("导出数据列未设置!")
			return
		}
		var colsetlist=colsets.split("&");
		var colname=new Array()
		var colcaption=new Array()
		var colposition=new Array()
		var colformat=new Array()
		var colwidth=new Array()
		var cols=colsetlist.length
		for (i=0;i<cols;i++)
		{
			var colsetinfo=colsetlist[i].split("^");
			colcaption[i]=colsetinfo[1];
			colname[i]=colsetinfo[2];
			colposition[i]=colsetinfo[3];
			colformat[i]=colsetinfo[4];
			colwidth[i]=colsetinfo[5];
		}
			
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBlank.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    //获取表头信息
	    var TitleInfo=GetElementValue("GetTitleInfo")
	    var TitleRow=0
	    if (TitleInfo!="")
	    {
		    TitleInfo=TitleInfo.split("@")
		    TitleRow=TitleInfo[0]*1
		    var ParaInfo=TitleInfo[1].split("&")
		    for (i=1;i<=TitleRow;i++)
		    {
			    xlsheet.Range(xlsheet.Cells(i,1),xlsheet.Cells(i,cols)).MergeCells = true;
			    xlsheet.cells(i,1)=ParaInfo[i-1]
		    }
		    if (TitleRow>0)
		    {
			    xlsheet.cells(1,1).Font.Bold = true;
			    xlsheet.cells(1,1).Font.Size = 20;
			    xlsheet.cells(1,1).EntireRow.AutoFit
			    xlsheet.cells(1,1).HorizontalAlignment = 3;
			    xlsheet.PageSetup.PrintTitleRows ="$1:$"+(TitleRow+1)
		    }
		    ParameterReplace(xlsheet,vData)
	    }
	    else
	    {
		    xlsheet.PageSetup.PrintTitleRows ="$1:$1"
	    }
	    xlsheet.PageSetup.LeftFooter="制表人:"+curUserName
	    xlsheet.PageSetup.RightFooter="第&P页(共&N页)"
	    //
	    for (i=0;i<cols;i++)
	    {
		    xlsheet.cells(TitleRow+1,i+1)=colcaption[i];
	    	if (colwidth[i]!="")
	    	{
		    	xlsheet.Columns(i+1).ColumnWidth =colwidth[i];
	    	}
		}
	    num=parseFloat(num);
	    
	    ///Modified by jdl 2011-10-28 JDL0099  web.DHCEQEquipSave GetList
	    /// Modified by jdl 2013-7-16 JDL0133 优化台帐导出效率?增加参数每次获取行数信息
	    var splitChar=String.fromCharCode(2);
	    var endRow;
	    
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
		 	
		 	/// Modified by jdl 2013-7-16 JDL0133 优化台帐导出效率?增加参数每次获取行数信息
		 	if (!GetRowsPerTime)
		 	{	endRow=Row;	}
		 	else
			{	endRow=Row+GetRowsPerTime-1;	}
			if (endRow>num) endRow=num;
			var rowsCount=endRow-Row+1;
			var strConcat="";
			var strArr=new Array();
			var beginRow=Row;
			var fieldVal;
		
		 	///Modified by jdl 2011-10-28 JDL0099
		 	if (!GetRowsPerTime)
		 	{
			 	var str=cspRunServerMethod(encmeth,TempNode,job,Row)
		 	}
		 	else
		 	{
				var str=cspRunServerMethod(encmeth,TempNode,job,Row,rowsCount)
		 	}
			var rowVal=str.split(splitChar);
			
			for (j=0;j<rowsCount;j++)
			{
				//if ((Row>430)&(Row<450)) alertShow(j+"&"+rowVal[j]+String.fromCharCode(67));			
				var List=rowVal[j].split("^");
				//xlsheet.Rows(Row+TitleRow+1).Insert()
		    	var strLine=""
		    	for (i=1;i<=cols;i++)
		    	{
			    	var position=colposition[i-1];
			    	if (position>0)
			    	{	position=position-1;}
			    	else
			    	{	position=0}
			    	
			    	fieldVal=List[position];
			    	if (colformat[i-1]==2)
				    {
					   	if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "0.00_ ";
					}
					else if (colformat[i-1]==4)
					{
					    if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "@";
					}
				    else if (colformat[i-1]!="")
				    {
				    	fieldVal=ColFormat(fieldVal,colformat[i-1]);
				    }
				    fieldVal=fieldVal.replace(/\t/g," ");
				    fieldVal=fieldVal.replace(/\r\n/g," ");
				    strLine=strLine+fieldVal;
				    if (i<cols) strLine=strLine+"\t";
		    	}
		    	if (j!=0) strLine="\r"+strLine;
		    	strArr.push(strLine);
		    	if (Row<endRow) Row++;
			}
	     	strConcat=String.prototype.concat.apply("",strArr);
	     	xlsheet.Cells(beginRow+TitleRow+1,1).Select();
		 	window.clipboardData.setData("Text",strConcat);
		 	xlsheet.Paste();
			
	    	/*	
			for (i=1;i<=cols;i++)
	    	{
		    	var position=colposition[i-1];
		    	if (position>0)
		    	{	position=position-1;}
		    	else
		    	{	position=0}
		    	
		    	//if (Row==1) alertShow(position+"&"+List[position]);
		    	if (colformat[i-1]!="")
		    	{
			    	if (colformat[i-1]==2)
			    	{
				    	if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "0.00_ ";
				    	xlsheet.cells(Row+TitleRow+1,i)=List[position];
				    }
				    else if (colformat[i-1]==4)
				    {
					    if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "@";
					    xlsheet.cells(Row+TitleRow+1,i)=List[position];
					}
			    	else
			    	{
			    		xlsheet.cells(Row+TitleRow+1,i)=ColFormat(List[position],colformat[i-1]);
			    	}
		    	}
		    	else
		    	{
		    		xlsheet.cells(Row+TitleRow+1,i)=List[position];
		    	}
			}	
			*/		
			
	     }
	     
	     if (SaveOrPrint=="1")
	     {
		     xlBook.SaveAs(FileName);
	     }
	     else
	     {
		     xlsheet.printout; //打印输出
	     }
	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    if (SaveOrPrint=="1")
	    {
		    alertShow("导出完成!");
	    }
	    } 
	catch(e)
	 {
		alertShow(e.message);
	 }
	}
}

function ColFormat(val,format)
{
	//"1:YYYY-MM-DD"
	//"11:YYYY年MM月DD日"
	//"12:dd/mm/yyyy"
	//"2:0.00"
	//"3:短名称根据-截取
	//"4:文本格式?主要处理如设备编号等科学记数法显示的问题?
	if (format=="1")
	{
		return FormatDate(val,"","");
	}
	else if (format=="2")
	{
		val=val*100;
		val=Math.round(val,2);
		val=val/100;
		val=val.toFixed(2);
		return val;
	}
	else if (format=="3")
	{
		val=GetShortName(val,"-");
		return val;
	}
	else
	{
		return val
	}
	
}

function SetExcelColFormat(xlsheet,col,startrow,endrow,format)
{
	xlsheet.Range(xlsheet.Cells(startrow,col),xlsheet.Cells(endrow,col)).NumberFormatLocal = "0.00_ "	
}

function ParameterReplace(xlsheet,vData)
{
	var Find=xlsheet.cells.find("[Hospital]")
	if (Find!=null) {xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))}
	
	var vInfo=vData.split("^")
	var vCount=vInfo.length
	var vCurInfo=""
	for (var i=1;i<vCount;i++)
	{
		vCurInfo=vInfo[i].split("=")
		Find=xlsheet.cells.find("["+vCurInfo[0]+"]")
		if (Find!=null)
		{
			xlsheet.cells.replace("["+vCurInfo[0]+"]",vCurInfo[1])
		}
	}
}
