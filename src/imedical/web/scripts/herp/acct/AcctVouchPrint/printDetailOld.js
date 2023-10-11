function printDetail(rs){
	
	var xlApp,xlsheet,xlBook,arr;

    var hostport=document.location.host;

	xlApp = new ActiveXObject("Excel.Application");
	var url="http://"+hostport;
	// alert(url);
	xlBook = xlApp.Workbooks.Add(url+"/dthealth/web/scripts/herp/acct/PrintFile/会计凭证模板.xls");
	xlsheet = xlBook.ActiveSheet;
	var arr=rs.split('#');
	// alert("arr="+arr);
	var number=arr.length-1;	//数据条数,减去最后一条空数据
	var title="";
	//var address=window.location.href;
    //var thisDLoc=document.location;  
    
    //alert(address)
	//alert(thisDLoc)
	//alert(url+"/dthealth/web/scripts/herp/acct/PrintFile/会计凭证模板.xls")
	
	var count=0
	var VouchNo=""
	var SubjNameAll=""
	var Summary=""
	var AmtDebit=0
	var AmtCredit=0
	var BillNum=0
	var yyname=""
	var bookName=""
    var Operator=""
    var Poster=""
    var printdate=""
	var prevpager=""
	var allpager=""
	var auditor=""
	var checker=""
	
	var i;
	var j;
	var rownum=0;
	var rows=0;
	var title="";
	var AmtDebitAll=0,AmtCreditAll=0		//累计
	
	allpager=Math.ceil(number/5);	//总页数，每页5条，向上取整
	// alert("allpager:"+allpager+"^"+number);
	for(j=1;j<=allpager;j++){

		// alert('第'+j+'次');
		var AmtDebitPrev=0,AmtCreditPrev=0;		//当前页合计
		
		//每页5条；arr最后一项为空，所以i最大能取到arr.length-2（数组从0开始）
		// for(i=5*(j-1);(i<j*5)&&(i<number);i++)
		for(i=5*(j-1)+1;(i<=j*5)&&(i<=number);i++)
		{
			rownum=(i-1)%5;		//当前页第几行
			rows=i;		//总数据第几行数据
		    
			title=arr[i].split('^');
			// alert("arr["+i+"]="+arr[i]);
			count=title[0];
			VouchNo=title[1];
			SubjNameAll=title[2];
			Summary=title[3];
			AmtDebit=title[4];
			AmtCredit=title[5];
			BillNum=title[6];
			yyname=title[7];
			yearmonth=title[8];
			bookname=title[9];
			Operator=title[10];
			Poster=title[11];
			printdate=title[12];
			auditor=title[13];
			checker=title[14];

			xlsheet.Cells(rownum+6,1).value=Summary;    
			xlsheet.Cells(rownum+6,2).value=SubjNameAll;    
			xlsheet.Cells(rownum+6,3).value=AmtDebit;
			xlsheet.Cells(rownum+6,4).value=AmtCredit;
			
			if(AmtDebit=="") AmtDebit=0;
			if(AmtCredit=="") AmtCredit=0;
			
			AmtDebitPrev+=parseFloat(AmtDebit); 
			AmtCreditPrev+=parseFloat(AmtCredit);
			// alert("借、贷明细："+AmtDebit+"^"+AmtCredit+"^"+AmtDebitPrev+"^"+AmtCreditPrev);
			
		
		}

				prevpager=Math.ceil(rows/5);	//当前页
				// alert(prevpager);

				xlsheet.cells(2,1).value=yearmonth;
				xlsheet.cells(3,1).value="编制单位："+yyname;
				xlsheet.cells(4,1).value="核算单位："+bookname;

				xlsheet.cells(3,3).value="附件数："+BillNum;
				xlsheet.cells(12,4).value="制单："+Operator ; //制单人员
				xlsheet.cells(12,2).value="   记账："+ Poster+"      复核："+auditor;
				xlsheet.cells(12,3).value="出纳："+checker;
				xlsheet.cells(4,3).value="第"+VouchNo+"号"+"-"+prevpager+"/"+allpager;
				xlsheet.cells(13,3).value="打印时间："+printdate;
				
				AmtDebitAll+=AmtDebitPrev;
				AmtCreditAll+=AmtCreditPrev;
				
				if(j<allpager){

					xlsheet.cells(11,3).value=AmtDebitPrev;
					xlsheet.cells(11,4).value=AmtCreditPrev;
					// alert("借贷合计："+AmtDebitPrev+"^"+AmtCreditPrev);
				}else{
					
					xlsheet.cells(11,3).value=AmtDebitAll;
					xlsheet.cells(11,4).value=AmtCreditAll;
					xlsheet.cells(11,2).value='=SUBSTITUTE(SUBSTITUTE(IF(C11<0,"负","")&TEXT(TRUNC(ABS(ROUND(C11,2))),"[DBNum2]")&"元"&IF(ISERR(FIND(".",ROUND(C11,2))),"",TEXT(RIGHT(TRUNC(ROUND(C11,2)*10)),"[DBNum2]"))&IF(ISERR(FIND(".0",TEXT(C11,"0.00"))),"角","")&IF(LEFT(RIGHT(ROUND(C11,2),3))=".",TEXT(RIGHT(ROUND(C11,2)),"[DBNum2]")&"分",IF(ROUND(C11,2)=0,"","整")),"零元零",""),"零元","")';
					// alert("借贷汇总："+AmtDebitAll+"^"+AmtCreditAll);
				}	
				xlApp.Visible=false;
				// xlsheet.PrintPreview();
				xlsheet.printout;
				
				xlsheet.Cells(6,1).value="";    
				xlsheet.Cells(6,2).value="";    
				xlsheet.Cells(6,3).value="";
				xlsheet.Cells(6,4).value="";
				
				xlsheet.Cells(7,1).value="";    
				xlsheet.Cells(7,2).value="";    
				xlsheet.Cells(7,3).value="";
				xlsheet.Cells(7,4).value="";
				
				xlsheet.Cells(8,1).value="";    
				xlsheet.Cells(8,2).value="";    
				xlsheet.Cells(8,3).value="";
				xlsheet.Cells(8,4).value="";
				
				xlsheet.Cells(9,1).value="";    
				xlsheet.Cells(9,2).value="";    
				xlsheet.Cells(9,3).value="";
				xlsheet.Cells(9,4).value="";
				
				xlsheet.Cells(10,1).value="";    
				xlsheet.Cells(10,2).value="";    
				xlsheet.Cells(10,3).value="";
				xlsheet.Cells(10,4).value="";
		
		
	}	

    xlBook.Close (savechanges=false);
    xlApp.Quit();
}
	
		/* for(i=0;i<number-1;i++)
		{
			var title=arr[i].split("^");
			rownum=i%5;		
			rows=i+1;
			
			count=title[0]
			VouchNo=title[1]
			SubjNameAll=title[2]
			Summary=title[3]
			AmtDebit=title[4]
			AmtCredit=title[5]
			BillNum=title[6]
			yyname=title[7]
			yearmonth=title[8]
			bookname=title[9]
			Operator=title[10]
			Poster=title[11]
			printdate=title[12]

			//alert(yyname)
			//alert(Summary)

			
			xlsheet.Cells(rownum+6,1).value=Summary;    
			xlsheet.Cells(rownum+6,2).value=SubjNameAll;    
			xlsheet.Cells(rownum+6,3).value=AmtDebit;
			xlsheet.Cells(rownum+6,4).value=AmtCredit; 
			
			if (rownum==4)
			{
				xlsheet.cells(2,1).value=yearmonth
				xlsheet.cells(3,1).value="编制单位："+yyname;
				xlsheet.cells(4,1).value="核算单位："+bookname;

				xlsheet.cells(3,3).value="附件数："+BillNum
				xlsheet.cells(12,4).value=""+Operator ; //制单人员
				xlsheet.cells(12,2).value="  记账:"+ Poster+"      复核：         出纳：";
				xlsheet.cells(4,3).value="第"+VouchNo+"号"+"-"+rows+"/"+count;
				xlsheet.cells(13,3).value="打印时间："+printdate
				xlApp.Visible=true;
				xlsheet.PrintPreview();
				//xlsheet.printout;
				
				xlsheet.Cells(6,1).value="";    
				xlsheet.Cells(6,2).value="";    
				xlsheet.Cells(6,3).value="";
				xlsheet.Cells(6,4).value="";
				
				xlsheet.Cells(7,1).value="";    
				xlsheet.Cells(7,2).value="";    
				xlsheet.Cells(7,3).value="";
				xlsheet.Cells(7,4).value="";
				
				xlsheet.Cells(8,1).value="";    
				xlsheet.Cells(8,2).value="";    
				xlsheet.Cells(8,3).value="";
				xlsheet.Cells(8,4).value="";
				
				xlsheet.Cells(9,1).value="";    
				xlsheet.Cells(9,2).value="";    
				xlsheet.Cells(9,3).value="";
				xlsheet.Cells(9,4).value="";
				
				xlsheet.Cells(10,1).value="";    
				xlsheet.Cells(10,2).value="";    
				xlsheet.Cells(10,3).value="";
				xlsheet.Cells(10,4).value="";
		
			} 

			
		}
			
			if (count<4){
				xlsheet.cells(2,1).value=yearmonth
				xlsheet.cells(3,1).value="编制单位："+yyname;
				xlsheet.cells(4,1).value="核算单位："+bookname;

				xlsheet.cells(3,3).value="附件数："+BillNum
				xlsheet.cells(12,4).value=""+Operator ; //制单人员
				xlsheet.cells(12,2).value="  记账:"+ Poster+"      复核：         出纳：";		
				xlsheet.cells(4,3).value="第"+VouchNo+"号"+"-"+prevpager+"/"+allpager;
				xlsheet.cells(13,3).value="打印时间："+printdate
				xlApp.Visible=true;
				xlsheet.PrintPreview(); //打印预览
				//xlsheet.printout; //直接打印

			}
			if ((count>4) && (rownum<4)){
				xlsheet.cells(2,1).value=yearmonth
				xlsheet.cells(3,1).value="编制单位："+yyname;
				xlsheet.cells(4,1).value="核算单位："+bookname;
				xlsheet.cells(12,4).value=""+Operator ; //制单人员
				xlsheet.cells(12,2).value="  记账:"+ Poster+"      复核：         出纳：";			

				xlsheet.cells(3,3).value="附件数："+BillNum
				xlsheet.cells(4,3).value="第"+VouchNo+"号"+"-"+rows+"/"+count;
				xlsheet.cells(13,3).value="打印时间："+printdate
				xlApp.Visible=true;
				xlsheet.PrintPreview(); //打印预览
				//xlsheet.printout; //直接打印

			}*/
   