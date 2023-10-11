 var VouchPrint=function(itemGridp){
        var rowObj = itemGrid.getSelectionModel().getSelections();
		var Templete = itemGridp.getSelectionModel().getSelections();
           //var records = this.getSelectionModel().getSelections();
		 var TempName=Templete[0].get("Name");
		 var TempCode=Templete[0].get("Code");
		 var rowid=Templete[0].get("rowid");
        var len = rowObj.length;
        var tmpRowid = "";
        //alert('凭证打印')
        if(len < 1)
        {
            Ext.Msg.show({title:'注意',msg:'请选择需要打印的凭证！ ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            return;
        }else{
			Ext.MessageBox.confirm('提示', '您确定要打印所选择的凭证吗? ', function handler(id){
				if (id == 'yes'){
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
							if (v == len) {
								Ext.MessageBox.hide();
								Ext.MessageBox.alert('完成', '所选凭证已打印完成! ');
							} else {
								var i = v / len;
								Ext.MessageBox.updateProgress(i, '共'+len+'条，正在打印第'+v+'条：'+Math.round(100 * i) + '%已完成 ');
							}
						};
					};
					for (var i = 0; i <= len; i++) {
						setTimeout(f(i), i * 800);
					};
					var rowID1="";
					Ext.each(rowObj, function(record) {
						tmpRowid = record.get("rowid");
						// alert("打印："+tmpRowid);
						
						//alert("打印开始....")
						if (rowID1==tmpRowid){
								return;
						}
						else{  
							rowID1=tmpRowid;
									
							Ext.Ajax.request({
								url:'herp.acct.acctvouchprintexe.csp?action=print&VouchID='+tmpRowid+'&userid='+userid,
								waitMsg:'打印中...',
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接！ ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success=='true') {
										vurl="http://127.0.0.1";
										// vurl="D:\DtHealth\app\dthis\web\scripts\herp\acct\PrintFile";
										str=jsonData.info;

										printDetail(str,vurl);
									}else{
										Ext.Msg.show({title:'错误',msg:'错误！ ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});  
						}
					});
				}
			});	
            //--------------
		    // rowID1=tmpRowid;
        }
    


function printDetail(rs,url){
	//alert(rowid);
	var data="";
	var start="";
	Ext.Ajax.request({
		 url:'../csp/herp.acct.acctvouchprintexe.csp?action=editinfo&rowid='+ rowid,
        method: 'GET',
        success: function(result, request) {
        jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
		 data= jsonData.info;
		PrintT();
		}
		}
	});
	
 var PrintT=function(){
	//alert(rs);
	
	var rowidp=data.split("||")[0];
	var Codep=data.split("||")[1];
	var Namep=data.split("||")[2];
	var RowDataNump=parseInt(data.split("||")[3]);
	var ColumnDataNump=parseInt(data.split("||")[4]);
	var IfTitlep=data.split("||")[5];
	var IfPrintLinep=data.split("||")[6];
	var Title=data.split("||")[7];
	var ColumnDatap=data.split("||")[8];
	var coludata=ColumnDatap.split("#");
	//var PaperDirection=data.split("||")[9];
	//alert(RowDataNump+" "+ColumnDataNump);
	var xlApp,xlsheet,xlBook,arr;

    var hostport=document.location.host;

	xlApp = new ActiveXObject("Excel.Application");
	url="http://"+hostport;
	 //alert(url);
	xlBook = xlApp.Workbooks.Add(url+"/dthealth/web/scripts/herp/acct/PrintFile/"+TempName+".xls");
   // alert(xlBook.Workbooks);
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
	
	allpager=Math.ceil(number/RowDataNump);	//总页数，每页5条，向上取整
	//alert("allpager:"+allpager+"^"+number);
	for(j=1;j<=allpager;j++){
		var creCol="";
		var debCol="";
        var total="";
		// alert('第'+j+'次');
		var AmtDebitPrev=0,AmtCreditPrev=0;		//当前页合计
		
		//每页5条；arr最后一项为空，所以i最大能取到arr.length-2（数组从0开始）
		// for(i=5*(j-1);(i<j*5)&&(i<number);i++)
		for(i=RowDataNump*(j-1);(i<=j*RowDataNump)&&(i<=number);i++)
		{
			//alert(i);
			rownum=(i)%RowDataNump;		//当前页第几行
			rows=i+1;		//总数据第几行数据
		    
			title=arr[i].split('^');
			 //alert("arr["+i+"]="+arr[i]);
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
			vouchdate=title[15];
			VouchType=title[16];
			//alert(AmtDebit+"#"+AmtCredit)
			
			var numberd="";
			
				if(IfTitlep=="1"){
					numberd=6;
				}else{numberd=5;}
				
			for(var m=0;m<ColumnDataNump;m++){
				
				//alert(numberd);
			var content=coludata[m].split("^")[1];
			if(content=="Summary"){
				xlsheet.Cells(rownum+numberd,m+1).value=Summary;    
				if(m+1!=1){
				total=m+1;
				}
			}else if(content=="SubjName"){
				xlsheet.Cells(rownum+numberd,m+1).value=SubjNameAll;  
              if(m+1!=1){
				total=m+1;
				}				
			}else if(content=="AmtDebit"){
				xlsheet.Cells(rownum+numberd,m+1).value=AmtDebit; 
                 debCol=m+1;				
			}else if(content=="AmtCredit"){
				xlsheet.Cells(rownum+numberd,m+1).value=AmtCredit;  
               creCol=m+1;	
			}else if(content=="VouchDate"){
				xlsheet.Cells(rownum+numberd,m+1).value=vouchdate;   
              if(m+1!=1){
				total=m+1;
				}				
			}else if(content=="VouchType"){
				xlsheet.Cells(rownum+numberd,m+1).value=VouchType;   
            if(m+1!=1){
				total=m+1;
				}				
			}
			
			}
			// xlsheet.Cells(rownum+6,1).value=Summary;    
			// xlsheet.Cells(rownum+6,2).value=SubjNameAll;    
			// xlsheet.Cells(rownum+6,3).value=AmtDebit;
			// xlsheet.Cells(rownum+6,4).value=AmtCredit;
			
			if(AmtDebit=="") AmtDebit=0;
			if(AmtCredit=="") AmtCredit=0;
			
			AmtDebitPrev+=parseFloat(AmtDebit); 
			AmtCreditPrev+=parseFloat(AmtCredit);
			// alert("借、贷明细："+AmtDebit+"^"+AmtCredit+"^"+AmtDebitPrev+"^"+AmtCreditPrev);
			
		
		}

				prevpager=Math.ceil(rows/RowDataNump);	//当前页
				// alert(prevpager);

				xlsheet.cells(2,1).value=yearmonth;
				xlsheet.cells(3,1).value="编制单位："+yyname;
				xlsheet.cells(4,1).value="核算单位："+bookname;

				xlsheet.cells(3,3).value="附件数："+BillNum;
				xlsheet.cells(RowDataNump+numberd+1,4).value="  制单："+Operator ; //制单人员
				xlsheet.cells(RowDataNump+numberd+1,2).value="  记账:"+ Poster+"     复核："+auditor;
				xlsheet.cells(RowDataNump+numberd+1,3).value="       出纳："+checker;
				xlsheet.cells(4,3).value="第"+VouchNo+"号"+"-"+prevpager+"/"+allpager;
				xlsheet.cells(RowDataNump+numberd+2,3).value="打印时间："+printdate;
				
				AmtDebitAll+=AmtDebitPrev;
				AmtCreditAll+=AmtCreditPrev;
				
				if(j<allpager){
                   // alert(debCol+" "+creCol);
					xlsheet.cells(RowDataNump+numberd,debCol).value=AmtDebitPrev;
					xlsheet.cells(RowDataNump+numberd,creCol).value=AmtCreditPrev;
					// alert("借贷合计："+AmtDebitPrev+"^"+AmtCreditPrev);
				}else{
					var money=parseInt(RowDataNump+numberd);
					//alert(debCol+" "+creCol+" "+total);
					xlsheet.cells(RowDataNump+numberd,debCol).value=AmtDebitAll;
					xlsheet.cells(RowDataNump+numberd,creCol).value=AmtCreditAll;
					xlsheet.cells(RowDataNump+numberd,total).value='=SUBSTITUTE(SUBSTITUTE(IF(C'+money+'<0,"负","")&TEXT(TRUNC(ABS(ROUND(C'+money+',2))),"[DBNum2]")&"元"&IF(ISERR(FIND(".",ROUND(C'+money+',2))),"",TEXT(RIGHT(TRUNC(ROUND(C'+money+',2)*10)),"[DBNum2]"))&IF(ISERR(FIND(".0",TEXT(C'+money+',"0.00"))),"角","")&IF(LEFT(RIGHT(ROUND(C'+money+',2),3))=".",TEXT(RIGHT(ROUND(C'+money+',2)),"[DBNum2]")&"分",IF(ROUND(C'+money+',2)=0,"","整")),"零元零",""),"零元","")';
					// alert("借贷汇总："+AmtDebitAll+"^"+AmtCreditAll);
				}	
				xlApp.Visible=false;
				// xlsheet.PrintPreview();
				xlsheet.printout;
				for(var k=numberd;k<numberd+RowDataNump;k++){
					for(var n=1;n<=ColumnDataNump;n++){
						//alert();
						xlsheet.Cells(k,n).value="";    
					}
				}
				// xlsheet.Cells(6,1).value="";    
				// xlsheet.Cells(6,2).value="";    
				// xlsheet.Cells(6,3).value="";
				// xlsheet.Cells(6,4).value="";
				
				// xlsheet.Cells(7,1).value="";    
				// xlsheet.Cells(7,2).value="";    
				// xlsheet.Cells(7,3).value="";
				// xlsheet.Cells(7,4).value="";
				
				// xlsheet.Cells(8,1).value="";    
				// xlsheet.Cells(8,2).value="";    
				// xlsheet.Cells(8,3).value="";
				// xlsheet.Cells(8,4).value="";
				
				// xlsheet.Cells(9,1).value="";    
				// xlsheet.Cells(9,2).value="";    
				// xlsheet.Cells(9,3).value="";
				// xlsheet.Cells(9,4).value="";
				
				// xlsheet.Cells(10,1).value="";    
				// xlsheet.Cells(10,2).value="";    
				// xlsheet.Cells(10,3).value="";
				// xlsheet.Cells(10,4).value="";
				
			    // xlsheet.Cells(11,1).value="";    
				// xlsheet.Cells(11,2).value="";    
				// xlsheet.Cells(11,3).value="";
				// xlsheet.Cells(11,4).value="";
				
				// xlsheet.Cells(12,1).value="";    
				// xlsheet.Cells(12,2).value="";    
				// xlsheet.Cells(12,3).value="";
				// xlsheet.Cells(12,4).value="";
				
				// xlsheet.Cells(13,1).value="";    
				// xlsheet.Cells(13,2).value="";    
				// xlsheet.Cells(13,3).value="";
				// xlsheet.Cells(13,4).value="";
				
				// xlsheet.Cells(14,1).value="";    
				// xlsheet.Cells(14,2).value="";    
				// xlsheet.Cells(14,3).value="";
				// xlsheet.Cells(14,4).value="";
				
			    // xlsheet.Cells(15,1).value="";    
				// xlsheet.Cells(15,2).value="";    
				// xlsheet.Cells(15,3).value="";
				// xlsheet.Cells(15,4).value="";
				/*
				xlsheet.Cells(16,1).value="";    
				xlsheet.Cells(16,2).value="";    
				xlsheet.Cells(16,3).value="";
				xlsheet.Cells(16,4).value="";
				
				xlsheet.Cells(17,1).value="";    
				xlsheet.Cells(17,2).value="";    
				xlsheet.Cells(17,3).value="";
				xlsheet.Cells(17,4).value="";
		 */
		
	}	

    xlBook.Close (savechanges=false);
    xlApp.Quit();
}
	
}
 }