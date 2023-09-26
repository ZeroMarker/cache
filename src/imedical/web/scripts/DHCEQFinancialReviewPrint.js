function PDFPrint_Clicked(vFRRowID,vUserName,vFundsType)
{
	if (vFRRowID=="") return;
	/*****************总单信息********************/
	/*
	var encmetha=GetElementValue("GetSumInfo");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,vFRRowID,vFundsType);
	*/
	var ReturnList=tkMakeServerCall("web.DHCEQ.Interface.Inner.DHCEQFinancialReview","GetSumInfo",vFRRowID,vFundsType)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var Job=lista[1];
	var TBussinessNo=lista[2];
	var TEquipTypes=lista[4];
	var TBussinessSDate=lista[5];
	var TBussinessEDate=lista[6];
	var TMonth=lista[3];
	rows=lista[0];
	if (rows<=1) return
	/********************明细信息******************/
	var PageRows=rows;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	/*
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	*/
	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")
    var xlApp,xlsheet,xlBook;
    var Template=TemplatePath+"DHCEQFRDepreSum.xls";
    xlApp = new ActiveXObject("Excel.Application");
	/*
	var encmeth=GetElementValue("GetSumListInfo");
	if (encmeth=="") return;
	*/
	
	var GetRowsPerTime=100	//每输出50行粘贴一次
	var strArr=new Array();
	var strLine="";
	var strConcat="";
	var CurRowCount=0
	for (var i=0;i<=Pages;i++)
    {
    	xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
    	xlsheet.cells(2,1)="单号:"+TBussinessNo;
    	xlsheet.cells(2,4)=TMonth;
    	var OnePageRow=PageRows;
   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
   		for (var j=1;j<=OnePageRow;j++)
		{
			//var	PrintList=cspRunServerMethod(encmeth,Job,i*PageRows+j);
			var PrintList=tkMakeServerCall("web.DHCEQ.Interface.Inner.DHCEQFinancialReview","GetSumListInfo",Job,i*PageRows+j)
			PrintList=PrintList.replace(/\\n/g,"\n");
			PrintList=PrintList.replace(/\t/g," ");
			PrintList=PrintList.replace(/\r\n/g," ");	
			var List=PrintList.split("^");
			var Row=4+j;
			PrintList=List[0]+"\t"+List[1]+"\t"+List[2]+"\t"+List[3]+"\t"+List[4]+"\t"+List[5]+"\t"+List[6]+"\t"+List[7]+"\t"
			if (strLine=="")
			{
				strLine=PrintList;
			}
			else
			{
				strLine="\r"+PrintList;
			}
			strArr.push(strLine);
			CurRowCount=CurRowCount+1;
			if (CurRowCount==GetRowsPerTime)
			{
		     	strConcat=String.prototype.concat.apply("",strArr);
		     	xlsheet.Cells(i*PageRows+j-CurRowCount+4,1).Select();
			 	window.clipboardData.setData("Text",strConcat);
			 	xlsheet.Paste();
				strLine=""
				strConcat=""
				CurRowCount=0
				var strArr=new Array();
			}
			else if (rows==i*PageRows+j)
			{
		     	strConcat=String.prototype.concat.apply("",strArr);
		     	xlsheet.Cells(rows-CurRowCount+4,1).Select();
			 	window.clipboardData.setData("Text",strConcat);
			 	xlsheet.Paste();
				strLine=""
				strConcat=""
				CurRowCount=0
				var strArr=new Array();
			}
    	}
    	xlsheet.Range("A4",xlsheet.Cells(rows*1+3,8)).Borders.Weight = 2;
    	//var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    //var size=obj.GetPaperInfo("DHCEQInStock");
	    //if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    //xlBook.SaveAs(FileName);
    	xlsheet.printout; 	//打印输出
    	xlBook.Close (savechanges=false);
    	
    	xlsheet.Quit;
    	xlsheet=null;
    }
	xlApp=null;
}