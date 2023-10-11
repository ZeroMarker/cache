
//名称	DHCPEIReportPHistory.hisui.js
//功能	已打报告	
//创建	2019.04.02
//创建人  xy

$(function(){
	 
	InitCombobox();
	 
	InitIReportPHistoryDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
	});
        
	//导出
	$("#BExport").click(function() {	
		BExport_click();		
	});
})



function BExportNew_click(){
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEIRptPrintHistory.xls';

   	 
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
         var RowStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","ColStr",""); 
   	 		if (""==RowStr) { return false; } 
          var headStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","Header",""); 
		 var DayDatas=headStr.split("^");
	     var iCol=0;
	     var ret=""
	     for (var iCol=1;iCol<=DayDatas.length;iCol++) { 
		      if(ret==""){ret="xlSheet.Cells(1,"+iCol+").Value='"+DayDatas[iCol-1]+"';" }
		      else{ret=ret+"xlSheet.Cells(1,"+iCol+").Value='"+DayDatas[iCol-1]+"';" }
		      
	     }
	     if(""==!RowStr) {
	   		var row=RowStr.split("^")
	   		for (var i=0;i<row.length;i++){
	   		var DataRowStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","RowStr",row[i],i); 
	   		 var DataRowDatas=DataRowStr.split("^");
	     	
	     	for (var iCol=1;iCol<=DataRowDatas.length;iCol++) {
		     	
		     	var k=i+2
		     	 if(ret==""){ret="xlSheet.Cells("+k+","+iCol+").Value='"+DataRowDatas[iCol-1]+"';" }
		         else{ret=ret+"xlSheet.Cells("+k+","+iCol+").Value='"+DataRowDatas[iCol-1]+"';"}
	     		}
			}
	   		}
   	       
		    var rows=row.length+1;
   	       var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+rows+","+DayDatas.length+")).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ;
	    
	
}


function BExport_click()
{
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
      try{
      var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	   var Templatefilepath=prnpath+'DHCPEIRptPrintHistory.xls';
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
    	xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1"); 
		 var headStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","Header",""); 
		 var DayDatas=headStr.split("^");
	     var iCol=0;
	     for (var iCol=1;iCol<=DayDatas.length;iCol++) {
				xlsheet.cells(1,iCol)=DayDatas[iCol-1]
	     }
	     var RowStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","ColStr",""); 
   	    if (""==RowStr) { return false; }
   	    else {
	   		var row=RowStr.split("^")
	   		for (var i=0;i<row.length;i++){
	   		var DataRowStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","RowStr",row[i],i); 
	   		 var DataRowDatas=DataRowStr.split("^");
	     	
	     	for (var iCol=1;iCol<=DataRowDatas.length;iCol++) {
				xlsheet.cells(i+2,iCol)=DataRowDatas[iCol-1]
	     		}
			}
   	       }
	     xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;

		
   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
	}else{
		BExportNew_click()
	}
		
}

	
function InitCombobox()
{
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	});
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},

		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}			
			
		]]
	});
	
	// 打印人
	var UserObj = $HUI.combobox("#PUser",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPEUser&Type=RPT&ResultSetType=array",
		valueField:'UserID',
		textField:'UserName'
	});
}

//查询
function BFind_click(){
	
	$("#IReportPHistoryQueryTab").datagrid('load',{
		ClassName:"web.DHCPE.PrintIAdmInfo",
		QueryName:"GetIPrtIAdmInfo",
		PDateFrom:$("#PDateFrom").datebox('getValue'),
		PDateTo:$("#PDateTo").datebox('getValue'),
		GroupID:$("#GroupName").combogrid('getValue'),
		VIPLevel:$("#VIPLevel").combobox('getValue'),
		PUserId:$("#PUser").combobox('getValue')
	});
	
}

function InitIReportPHistoryDataGrid(){
	
	$HUI.datagrid("#IReportPHistoryQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.PrintIAdmInfo",
			QueryName:"GetIPrtIAdmInfo",
			PDateFrom:$("#PDateFrom").datebox('getValue'),
			PDateTo:$("#PDateTo").datebox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			PUserId:$("#PUser").combobox('getValue')
		},
		columns:[[
		    {field:'TPAPMINo',width:'150',title:'登记号'},
			{field:'TName',width:'150',title:'姓名'},
			{field:'TAge',width:'80',title:'年龄'},
			{field:'TSex',width:'80',title:'性别'},
			{field:'TPrtFlag',width:'150',title:'VIP等级'},
			{field:'TGrpName',width:'200',title:'团体名称'},
			{field:'TAuditDate',width:'150',title:'审核日期'},
			{field:'TAuditOpr',width:'150',title:'审核人'},
			{field:'TCheckDate',width:'150',title:'打印日期'},
			{field:'TReportOpr',width:'150',title:'打印人'}
		]]
	});
		
}


