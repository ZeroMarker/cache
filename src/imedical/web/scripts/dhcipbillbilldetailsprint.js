function IPrintBillDetail(BillNo,UserCode,StartPage,Job,PrintDateTime){
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j ;
    var Template;
    var path=tkMakeServerCall("web.UDHCJFTITMP","getpath");
	Template=path+"JF_PatFeeDetail.xls"	;    
	//alert(Template)
	//Template="D:\\JF_PatFeeDetail.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	///
	var tmpstr=tkMakeServerCall("web.UDHCJFBillDetail","getpatinfodetail","","",BillNo);
	//alert(tmpstr);
	var str=tmpstr.split("#");
    var patstr=str[0].split("^");
    var admstr=str[1].split("^");
	var CurDate=PrintDateTime;
	var currRow=1;
	//GetHospitalDesc();
	xlsheet.cells(currRow,1).value=HospitalDesc+"费用结算清单";
	xlsheet.cells(++currRow,1).value="登记号:"+patstr[0]+"  住院号:"+patstr[2]+"  姓 名: "+patstr[1]+"  性 别: "+patstr[4];  //"科  室:"+str2[3]+
	xlsheet.cells(++currRow,1).value="出院科室: "+admstr[3] + "  入院日期: "+admstr[0]+"  出院日期: "+admstr[1]+"  住院天数: "+admstr[6];
    ///
	++currRow;
	CellLine(xlsheet,currRow,currRow,1,8,3,1);
	CellLine(xlsheet,currRow,currRow,1,8,4,1);

	xlsheet.cells(currRow,1)="收费项目";
	xlsheet.cells(currRow,2)="医嘱";
	xlsheet.cells(currRow,3)="单位";
	xlsheet.cells(currRow,4)="单价";
	xlsheet.cells(currRow,5)="数量";
	xlsheet.cells(currRow,6)="金额";
	///
    var num=tkMakeServerCall("web.UDHCJFBillDetail","GetNum","","",BillNo,Job);
    var NumAry=num.split("^");
    var num=NumAry[0];
    var prtRow=currRow;
	var ind=1;
	for (var i=1;i<=num;i++){ 
	  var str=tkMakeServerCall("web.UDHCJFBillDetail","List","","",BillNo,Job,i);
	  //alert(str);
	  str=str.split("^")
	  var qty=str[4];
	  var sum=str[5];
	  for (j=1;j<8;j++){
		  if(str[j-1]=="小计:"){
			  CellLine(xlsheet,i+prtRow,i+prtRow,6,8,3,2)
			  CellLine(xlsheet,i+prtRow,i+prtRow,1,8,4,1)   
			  xlsheet.rows(i+prtRow).Font.Bold=true;
		  }
		  if(str[j-1]=="合计:"){
			  CellLine(xlsheet,i+5,i+5,1,8,3,1) 
			  xlsheet.rows(i+prtRow).Font.Bold=true;
		  }
		   xlsheet.cells(i+prtRow,j)=str[j-1]
	    }
	     ++currRow
	  }
	  ++currRow;
	  xlsheet.cells(currRow,1).value="      打印人: "+UserCode+"   打印时间: "+CurDate;    
	  xlsheet.PageSetup.CenterFooter = "第 &P+"+StartPage+" 页";  //StartPage:为起始页码
	  var EndPageNum=xlsheet.HPageBreaks.Count+1;		//结束页码
	  //xlApp.Visible=true
	  //xlsheet.PrintPreview();
	  xlsheet.PrintOut;
	  xlBook.Close (savechanges=false);
	  xlApp.Quit();
	  xlApp=null;
	  xlsheet=null;
	  ///
	  return EndPageNum;
}
function CellLine(objSheet,row1,row2,c1,c2,Style){     
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(Style).LineStyle=1;
}