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
	xlsheet.cells(currRow,1).value=HospitalDesc+"���ý����嵥";
	xlsheet.cells(++currRow,1).value="�ǼǺ�:"+patstr[0]+"  סԺ��:"+patstr[2]+"  �� ��: "+patstr[1]+"  �� ��: "+patstr[4];  //"��  ��:"+str2[3]+
	xlsheet.cells(++currRow,1).value="��Ժ����: "+admstr[3] + "  ��Ժ����: "+admstr[0]+"  ��Ժ����: "+admstr[1]+"  סԺ����: "+admstr[6];
    ///
	++currRow;
	CellLine(xlsheet,currRow,currRow,1,8,3,1);
	CellLine(xlsheet,currRow,currRow,1,8,4,1);

	xlsheet.cells(currRow,1)="�շ���Ŀ";
	xlsheet.cells(currRow,2)="ҽ��";
	xlsheet.cells(currRow,3)="��λ";
	xlsheet.cells(currRow,4)="����";
	xlsheet.cells(currRow,5)="����";
	xlsheet.cells(currRow,6)="���";
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
		  if(str[j-1]=="С��:"){
			  CellLine(xlsheet,i+prtRow,i+prtRow,6,8,3,2)
			  CellLine(xlsheet,i+prtRow,i+prtRow,1,8,4,1)   
			  xlsheet.rows(i+prtRow).Font.Bold=true;
		  }
		  if(str[j-1]=="�ϼ�:"){
			  CellLine(xlsheet,i+5,i+5,1,8,3,1) 
			  xlsheet.rows(i+prtRow).Font.Bold=true;
		  }
		   xlsheet.cells(i+prtRow,j)=str[j-1]
	    }
	     ++currRow
	  }
	  ++currRow;
	  xlsheet.cells(currRow,1).value="      ��ӡ��: "+UserCode+"   ��ӡʱ��: "+CurDate;    
	  xlsheet.PageSetup.CenterFooter = "�� &P+"+StartPage+" ҳ";  //StartPage:Ϊ��ʼҳ��
	  var EndPageNum=xlsheet.HPageBreaks.Count+1;		//����ҳ��
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