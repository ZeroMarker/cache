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
		xlsheet.cells(row,col)=dataList[content];
		if ((col==1)&&(dataList[content]=="")) xlsheet.cells(row,1)="�ϼ�";	// Mozy	2016-4-26
		for (var J = 1; J < 5; J++)
		{
			xlsheet.cells(row,col).Borders(J).LineStyle=1; //2011-03-10 DJ
			xlsheet.cells(row,col).Borders(J).Weight=2; //2011-03-10 DJ
		}
	}
}

function PrintEQReport(templateName,isSave,savefilename,colset)
{
	var TemplatePath=getElementValue("GetRepPath");
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
		}
	    
	    var row=PrintEQReportFooter(xlsheet,row);

	    if (isSave==1)
	    {	
	    	xlBook.SaveAs(savefilename);
	    	messageShow('popover','alert','��ʾ','����ɹ�,����·��:'+savefilename)
	    } 
	    else
	    {	xlsheet.printout;	}	// ��ӡ���
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

///Modified by jdl 2011-10-28 JDL0099  ����Ϊ�����ĵ�������ӡ����?
///				�����п����õĳ��򶼿�ʹ��
///				���Ӳ���TempNode:��ʱglobal��洢ʱ�õĽڵ�
function GetNum(TempNode,job) {
    var getnum=document.getElementById('GetNum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	num=cspRunServerMethod(encmeth,TempNode,job)
	}

///Modified by jdl 2011-10-28 JDL0099  ����Ϊ�����ĵ�������ӡ����?
///				�����п����õĳ��򶼿�ʹ��
///				���Ӳ���TempNode:��ʱglobal��洢ʱ�õĽڵ�
///	����˵��?TableName:�����õı���
///			  SaveOrPrint:1Ϊ���� ����Ϊ��ӡ
///			  job:
///			  vData:�滻����
///			  TempNode:��ʱglobal��洢ʱ�õĽڵ�
///			  
///add by jdl 2009-9-22  JDL0028
function  PrintDHCEQEquipNew(TableName,SaveOrPrint,job,vData,TempNode,GetRowsPerTime)
{
	if (getElementValue("ChromeFlag")=="1")
	{
		PrintDHCEQEquipChrome(TableName,SaveOrPrint,job,vData,TempNode);
		return
	}
	window.clipboardData.clearData(); // Modified by QW 20170808  QW0007
	///Modified by jdl 2011-10-28 JDL0099
	if (!TempNode)
	{
		TempNode="";
	} 
	GetNum(TempNode,job);
	
	if (num<=0) {messageShow('popover','alert','��ʾ',"��ûֵ")}  //add by zx 2019-07-24
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
			
		encmeth=getElementValue("GetColSets");
		var	colsets=cspRunServerMethod(encmeth,"","2","",TableName); //�û�������
		if (colsets=="")
		{
			var	colsets=cspRunServerMethod(encmeth,"","1","",TableName); //��ȫ�鼶����
			if (colsets=="")
			{
				var	colsets=cspRunServerMethod(encmeth,"","0","",TableName); //ϵͳ����
			}
		}
		if (colsets=="")
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
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
	    //��ȡ��ͷ��Ϣ
	    var TitleInfo=getElementValue("GetTitleInfo")
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
	    xlsheet.PageSetup.LeftFooter="�Ʊ���:"+session['LOGON.USERNAME']
	    xlsheet.PageSetup.RightFooter="��&Pҳ(��&Nҳ)"
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
	    /// Modified by jdl 2013-7-16 JDL0133 �Ż�̨�ʵ���Ч��?���Ӳ���ÿ�λ�ȡ������Ϣ
	    var splitChar=String.fromCharCode(2);
	    var endRow;
	    
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
		 	
		 	/// Modified by jdl 2013-7-16 JDL0133 �Ż�̨�ʵ���Ч��?���Ӳ���ÿ�λ�ȡ������Ϣ
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
			
	     }
	     
	     if (SaveOrPrint=="1")
	     {
		     xlBook.SaveAs(FileName);
	     }
	     else
	     {
		     xlsheet.printout; //��ӡ���
	     }
	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    if (SaveOrPrint=="1")
	    {
		    messageShow('popover','alert','��ʾ',"�������!")
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
	//"11:YYYY��MM��DD��"
	//"12:dd/mm/yyyy"
	//"2:0.00"
	//"3:�����Ƹ���-��ȡ
	//"4:�ı���ʽ?��Ҫ�������豸��ŵȿ�ѧ��������ʾ������?
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
	if (Find!=null) {xlsheet.cells.replace("[Hospital]",getElementValue("GetHospitalDesc"))}
	
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
function  PrintDHCEQEquipChrome(TableName,SaveOrPrint,job,vData,TempNode,GetRowsPerTime)
{
	if (!TempNode)
	{
		TempNode="";
	}
	GetNum(TempNode,job);
	if (num<=0)
	{
		messageShow('popover','alert','��ʾ',"��ûֵ")
		return
	}
	if (SaveOrPrint=="1")
	{
		var FileName=GetFileName();
		if (FileName=="") {return;}
		var NewFileName=filepath(FileName,"\\","\\\\")
		var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	}
  	var GetPrescPath=document.getElementById("GetRepPath");
	if (GetPrescPath)
	{
		var encmeth=GetPrescPath.value
	} 
	else 
	{
		var encmeth=''
	}
	if (encmeth!="") 
	{
		var	TemplatePath=cspRunServerMethod(encmeth);
	}
	
	encmeth=getElementValue("GetColSets");
	var	colsets=cspRunServerMethod(encmeth,"","2","",TableName); //�û�������
	if (colsets=="")
	{
		var	colsets=cspRunServerMethod(encmeth,"","1","",TableName); //��ȫ�鼶����
		if (colsets=="")
		{
			var	colsets=cspRunServerMethod(encmeth,"","0","",TableName); //ϵͳ����
		}
	}
	if (colsets=="")
	{
		messageShow('popover','alert','��ʾ',"����������δ����!")
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
	var TitleInfo=getElementValue("GetTitleInfo");
	var OneBatchInfo=new Array();
	
	var list=document.getElementById('GetList');
	if (list) {var encmeth=list.value} else {var encmeth=''};
    
    for (Row=1;Row<=num;Row++)
    {
	 	if (!GetRowsPerTime)
	 	{	endRow=Row;	}
	 	else
		{	endRow=Row+GetRowsPerTime-1;	}
		if (endRow>num) endRow=num;
		var rowsCount=endRow-Row+1;
	
	 	if (!GetRowsPerTime)
	 	{
		 	var str=cspRunServerMethod(encmeth,TempNode,job,Row)
	 	}
	 	else
	 	{
			var str=cspRunServerMethod(encmeth,TempNode,job,Row,rowsCount)
	 	}
	 	str=filepath(str,",","��");
	 	OneBatchInfo.push(str)
		for (j=0;j<rowsCount;j++)
		{
	    	if (Row<endRow) Row++;
		}
    }
    var colcaptionStr=colcaption.toString()
    var colwidthStr=colwidth.toString()
    var colpositionStr=colposition.toString()
    var OneBatchInfoStr=OneBatchInfo.toString()
    var colformatStr=colformat.toString()
    var splitChar=String.fromCharCode(2);
	///Chrome�����Դ���
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="var colcaptionStr='"+colcaptionStr+"';"
	Str +="var colcaption=colcaptionStr.split(',');"
	Str +="var colwidthStr='"+colwidthStr+"';"
	Str +="var colwidth=colwidthStr.split(',');"
	Str +="var colpositionStr='"+colpositionStr+"';"
	Str +="var colposition=colpositionStr.split(',');"
	Str +="var OneBatchInfoStr='"+OneBatchInfoStr+"';"
	Str +="var OneBatchInfo=OneBatchInfoStr.split(',');"
	Str +="var colformatStr='"+colformatStr+"';"
	Str +="var colformat=colformatStr.split(',');"
	Str +="var Template='"+TemplatePath+"DHCEQBlank.xls';"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add(Template);"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="var TitleRow=0;"
	Str +="var TitleInfo='"+TitleInfo+"';"
	Str +="if (TitleInfo!=''){"
	Str +="TitleInfo=TitleInfo.split('@');"
	Str +="TitleRow=TitleInfo[0]*1;"
	Str +="var ParaInfo=TitleInfo[1].split('&');"	
	Str +="for (i=1;i<=TitleRow;i++){"
	Str +="xlsheet.Range(xlsheet.Cells(i,1),xlsheet.Cells(i,"+cols+")).MergeCells = true;"
	Str +="xlsheet.cells(i,1)=ParaInfo[i-1];}"
	Str +="if (TitleRow>0){"
	Str +="xlsheet.cells(1,1).Font.Bold = true;"
	Str +="xlsheet.cells(1,1).Font.Size = 20;"
	Str +="xlsheet.cells(1,1).EntireRow.AutoFit;"
	Str +="xlsheet.cells(1,1).HorizontalAlignment = 3;"
	Str +="xlsheet.PageSetup.PrintTitleRows ='$1:$'+(TitleRow+1);}"
	Str +="("+ParameterReplace+")(xlsheet,'"+vData+"');}else{"
	Str +="xlsheet.PageSetup.PrintTitleRows ='$1:$1';}"
	Str +="xlsheet.PageSetup.LeftFooter='�Ʊ���:"+curUserName+"';"
	Str +="xlsheet.PageSetup.RightFooter='��&Pҳ(��&Nҳ)';"		
	Str +="for (i=0;i<"+cols+";i++){"
	Str +="xlsheet.cells(TitleRow+1,i+1)=colcaption[i];"
	Str +="if (colwidth[i]!='') {"
	Str +="xlsheet.Columns(i+1).ColumnWidth =colwidth[i];}}"
	Str +="var num="+num+";"
	Str +="var endRow;"
	Str +="var CurBatch=0;"	
	Str +="for (Row=1;Row<=num;Row++){"
	Str +="var list='"+document.getElementById('GetList')+"';"
	Str +="if (list) {var encmeth=list.value} else {var encmeth=''};"
	Str +="if (!"+GetRowsPerTime+") {endRow=Row;} else {endRow=Row+"+GetRowsPerTime+"-1;}"
	Str +="if (endRow>num) endRow=num;"
	Str +="var rowsCount=endRow-Row+1;"
	Str +="var strConcat='';"
	Str +="var strArr=new Array();"
	Str +="var beginRow=Row;"
	Str +="var fieldVal;"	
	Str +="if (!"+GetRowsPerTime+") {"
	Str +="var strinfo=OneBatchInfo[Row-1];} else {"
	Str +="var strinfo=OneBatchInfo[CurBatch++];}"
	Str +="var rowVal=strinfo.split('"+splitChar+"');"
	Str +="for (j=0;j<rowsCount;j++) {"
	Str +="var List=rowVal[j].split('^');"
	Str +="var strLine='';"
	Str +="for (i=1;i<="+cols+";i++) {"
	Str +="var position=colposition[i-1];"
	Str +="if (position>0) {position=position-1;} else {position=0;}"
	Str +="fieldVal=List[position];"	
	Str +="if (colformat[i-1]==2){"
	Str +="if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = '0.00_ ';}"
	Str +="else if (colformat[i-1]==4){"
	Str +="if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = '@';}"
	Str +="else if (colformat[i-1]==3){"
	Str +="fieldVal=("+GetShortName+")(fieldVal,'-');}"	
	Str +="fieldVal=fieldVal.replace(/\\t/g,' ');"
	Str +="fieldVal=fieldVal.replace(/\\r\\n/g,' ');"
	Str +="xlsheet.cells(Row+TitleRow+1,i)=fieldVal;}}}"
	Str +="if ("+SaveOrPrint+"==1){xlBook.SaveAs('"+NewFileName+"');}else{xlsheet.printout;}"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlApp=null;"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;"
	Str +="return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 0;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
	if ((SaveOrPrint=="1")&&(rtn.rtn==1))
	{
	    alertShow("�������!");
	}
}