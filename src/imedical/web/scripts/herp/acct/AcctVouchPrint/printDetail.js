
var printDetail=function(rs) {
	// alert("jr")
	// var fileName="记账凭证模板.xls";	//模板名称（汉字+文件后缀）
	// var rowNumPage = 5; //设置每页最大条数

	var fileName="记账凭证模板(纵向-15).xls";	//模板名称（汉字+文件后缀）
	var rowNumPage = 15; //设置每页最大条数
	
	var xlApp,
	xlsheet,
	xlBook,
	allArr,
	arr,
	templateurl;

	var hostport = document.location.host;
	templateurl = "http://" + hostport+ "/dthealth/web/scripts/herp/acct/PrintFile/"+fileName;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(templateurl);
	// xlsheet = xlBook.ActiveSheet;	
	
	// alert(templateurl)
	
	//每个凭证号对应的明细
	var allArr=rs.split('&');
	var VouchNum=allArr.length;
	// alert("allArr="+allArr+'\n'+"rs="+rs);
	var printPageCount=0;	//打印的总页数
	for(var k=0;k<VouchNum;k++){
		
		// alert("allArr["+k+"]="+allArr[k])
		var arr = allArr[k].split('#');
		var number = arr.length; //同一个凭证号下打印的凭证明细数据总数

		var vouchdetail = "";
		var count = 0
		var VouchNo = ""
		var SubjNameAll = ""
		var Summary = ""
		var AmtDebit = 0
		var AmtCredit = 0
		var BillNum = 0
		var yyname = ""
		var bookName = ""
		var Operator = ""
		var Poster = ""
		var printdate = ""
		var prevpager = ""
		var allpager = ""
		var auditor = ""
		var checker = ""

		var i;
		var j;
		var rownum = 0;
		var rows = 0;
		var AmtDebitAll = 0,AmtCreditAll = 0 //累计
		
		//每页最少显示4条分录，最多15条。
		if (number <= 4){
			rowNumPage = 4;
		}else if (number>4&&number<=15){
				rowNumPage = number;
		}else{
			rowNumPage = 15;	
		}
		allpager = Math.ceil(number / rowNumPage); //总页数，每页4条，向上取整
		// alert("allpager:"+allpager+"^"+number);
		
		
		for (var j = 1; j <= allpager; j++) {

			xlsheet = xlBook.ActiveSheet;
			// alert('第'+j+'页');
			//每次从第一个sheet中复制模板到sheetj
			xlBook.Worksheets(j).Copy(xlBook.Worksheets(1));
			
			//凭证明细分页后清空当前页的数据，重新添加下一页
			for (var rowId = 5; rowId <= rowNumPage; rowId++) {
				xlsheet.Cells(rowId, 1).value = "";
				xlsheet.Cells(rowId, 5).value = "";
				xlsheet.Cells(rowId, 13).value = "";
				xlsheet.Cells(rowId, 15).value = "";
			}
			
			var AmtDebitPrev = 0,
			AmtCreditPrev = 0; //当前页合计
			
			//每页rowNumPage条；i最大能取到arr.length（数组从0开始）
			for (var i = rowNumPage * (j - 1); i < j * rowNumPage && i < number ; i++) {
				var dataRowNum=0;	//每页分录数
				rownum = i % rowNumPage+1; //当前页的第几条分录
				rows = i+1; //总分录中的第几条
				
				vouchdetail = arr[i].split('^');
				count = vouchdetail[0];
				VouchNo = vouchdetail[1];
				SubjNameAll = vouchdetail[2];
				Summary = vouchdetail[3];
				AmtDebit = vouchdetail[4];
				AmtCredit = vouchdetail[5];
				BillNum = vouchdetail[6];
				yyname = vouchdetail[7];
				yearmonth = vouchdetail[8];
				bookname = vouchdetail[9];
				Operator = vouchdetail[10];
				Poster = vouchdetail[11];
				printdate = vouchdetail[12];
				auditor = vouchdetail[13];
				checker = vouchdetail[14];
				
				//如果分录条数大于4，小于等于15（满一页），只增加10次
				/* if(rownum>4&&rownum<=rowNumPage){
					// xlsheet.Rows(i+4).Insert;
					//合并单元格
					xlsheet.Range("A"+(i+4)+":"+"D"+(i+4)).MergeCells = true;
					xlsheet.Range("E"+(i+4)+":"+"K"+(i+4)).MergeCells = true;
					xlsheet.Range("L"+(i+4)+":"+"M"+(i+4)).MergeCells = true;
					xlsheet.Range("N"+(i+4)+":"+"O"+(i+4)).MergeCells = true;
					xlsheet.Cells(i+4,1).WrapText=true//自动换行
					xlsheet.Cells(i+4,5).WrapText=true//自动换行
					xlsheet.Range("L"+(i+4)+":"+"O"+(i+4)).NumberFormat = "#,##0.00";	//数字格式为会计专用
					xlsheet.Range("A"+(i+4)+":"+"O"+(i+4)).Font.Size = 9;	//字号
					xlsheet.Rows(i+4).RowHeight = 40;	//设置行高
					xlsheet.Range("A"+(i+4)+":"+"O"+(i+4)).Borders.Weight = 2;	//边框
					
					
				} */
				
				//计算本页合计，将空值转换成0
				if (AmtDebit == ""){
					AmtDebit = 0;
				}
				if (AmtCredit == ""){
					AmtCredit = 0;
				}
				
				AmtDebitPrev += parseFloat(AmtDebit);
				AmtCreditPrev += parseFloat(AmtCredit);
				// alert("借、贷明细："+AmtDebit+"^"+AmtCredit+"^"+AmtDebitPrev+"^"+AmtCreditPrev);
				
				//0在会计专用格式下显示为短横线 -
				if (AmtDebit == 0){
					AmtDebit = "";
				}
				if (AmtCredit == 0){
					AmtCredit = "";
				}
				
				xlsheet.Cells(rownum + 4, 1).value = Summary;
				xlsheet.Cells(rownum + 4, 5).value = SubjNameAll;
				xlsheet.Cells(rownum + 4, 13).value = AmtDebit;
				xlsheet.Cells(rownum + 4, 15).value = AmtCredit;

			}



			//计算分录最后一行的行号
			if(rownum<4){
				dataRowNum = 8;	//4行标题+4行最少分录
			}
			else{
				//每页最后一行分录在excel中的行号：标题占4行，每页最多rowNumPage行数据
				dataRowNum = rownum + 4
			}
			// alert(dataRowNum);
			if(dataRowNum<19){
				//删除多余的空行
				xlsheet.Range("A"+(dataRowNum+1)+":R19").Delete;
				//删除后，设置上移行的行高
				xlsheet.Rows(dataRowNum+1).RowHeight=25;
				xlsheet.Rows(dataRowNum+2).RowHeight=20;
				xlsheet.Rows(dataRowNum+3).RowHeight=13.5;

			}

			prevpager = Math.ceil(rows / rowNumPage); //当前页
			// alert("prevpager:"+prevpager);
			
			//表头
			year=yearmonth.split('-')[0];
			month=yearmonth.split('-')[1];
			day=yearmonth.split('-')[2];
			// alert(year+"/"+month+"/"+day)
			xlsheet.cells(2, 5).value = year
			xlsheet.cells(2, 8).value = month;
			xlsheet.cells(2, 10).value = day;
			xlsheet.cells(3, 2).value = yyname;		//编制单位
			xlsheet.cells(3, 9).value = BillNum;	//附件数
			// xlsheet.cells(4, 1).value = "核算单位：" + bookname;
			xlsheet.cells(3, 14).value = "第" + VouchNo + "号" + "-" + prevpager + "/" + allpager;

			xlsheet.cells(dataRowNum + 2, 4).value = Poster; //记账人员
			xlsheet.cells(dataRowNum + 2, 9).value = auditor; //复核人员
			xlsheet.cells(dataRowNum + 2, 14).value = checker; //出纳人员
			xlsheet.cells(dataRowNum + 2, 16).value = Operator; //制单人员
			xlsheet.cells(dataRowNum + 3, 14).value ="打印时间: "+ printdate; //打印时间

			AmtDebitAll += AmtDebitPrev;
			AmtCreditAll += AmtCreditPrev;

			
			if (j!=allpager) {
				//0在会计专用格式下显示为短横线 -
				if (AmtDebitPrev == 0){
					AmtDebitPrev = "";
				}
				if (AmtCreditPrev == 0){
					AmtCreditPrev = "";
				}
				xlsheet.cells(dataRowNum + 1, 13).value = AmtDebitPrev;
				xlsheet.cells(dataRowNum + 1, 15).value = AmtCreditPrev;
				xlsheet.cells(dataRowNum + 1, 2).value =""
				// alert("借贷合计："+AmtDebitPrev+"^"+AmtCreditPrev);
			} else {
				if (AmtDebitAll == 0){
					AmtDebitAll = "";
				}
				if (AmtCreditAll == 0){
					AmtCreditAll = "";
				}
				xlsheet.cells(dataRowNum + 1, 13).value = AmtDebitAll;
				xlsheet.cells(dataRowNum + 1, 15).value = AmtCreditAll;
				xlsheet.cells(dataRowNum + 1, 2).value = '=SUBSTITUTE(SUBSTITUTE(IF(M' + (dataRowNum + 1) + '<0,"负","")&TEXT(TRUNC(ABS(ROUND(M' + (dataRowNum + 1) + ',2))),"[DBNum2]")&"元"&IF(ISERR(FIND(".",ROUND(M' + (dataRowNum + 1) + ',2))),"",TEXT(RIGHT(TRUNC(ROUND(M' + (dataRowNum + 1) + ',2)*10)),"[DBNum2]"))&IF(ISERR(FIND(".0",TEXT(M' + (dataRowNum + 1) + ',"0.00"))),"角","")&IF(LEFT(RIGHT(ROUND(M' + (dataRowNum + 1) + ',2),3))=".",TEXT(RIGHT(ROUND(M' + (dataRowNum + 1) + ',2)),"[DBNum2]")&"分",IF(ROUND(M' + (dataRowNum + 1) + ',2)=0,"","整")),"零元零",""),"零元","")';
				// alert("借贷汇总："+AmtDebitAll+"^"+AmtCreditAll);
			}
			//打印的总页数
			printPageCount++;
		}
	}
	
	//打印进度条
	var progressBar = Ext.MessageBox.show({
			title : "打印",
			msg : "正在打印中...",
			width : 300,
			progress : true,
			closable : true
		});
	var f = function (v) {
		return function () {
			if (v == printPageCount) {
				Ext.MessageBox.hide();
				Ext.MessageBox.alert('完成', '所选凭证已打印完成! ');
			} else {
				var i = v / printPageCount;
				Ext.MessageBox.updateProgress(i, '共' + printPageCount + '页，正在打印第' + v + '页：' + Math.round(100 * i) + '%已完成 ');
			}
		};
	};
	for (var t = 1; t <= printPageCount; t++) {
		// alert(printPageCount)
		setTimeout(f(t), t * 1500);
	};


		// xlApp.Visible = true;
		// xlsheet.PrintPreview();
		xlBook.printout(2);	//从第二个sheet开始打印（第一个是模板）

		xlBook.Close(false);
		xlApp.Quit();
			
}


