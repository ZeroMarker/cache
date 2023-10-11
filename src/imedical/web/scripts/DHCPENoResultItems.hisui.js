//名称	DHCPENoResultItems.hisui.js
//功能	未回传结果项目查询
//创建	2019.06.10
//创建人  xy

$(function(){
			
	InitCombobox();
	
	InitNoResultItemDataGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
          
    //导出
	$("#BExport").click(function() {	
		BExport_click();		
        });
    	
	$('#ArrivedFlag').checkbox({
		onCheckChange:function(e,vaule){
			SetButtonName(vaule);
			
			}
			
	});     
})


function SetButtonName(vaule)
{
	if(vaule==true)
	{
		document.getElementById('tDateFrom').innerHTML="到达开始日期";	
		document.getElementById('tDateTo').innerHTML="到达结束日期";
	}else{
		document.getElementById('tDateFrom').innerHTML="收表开始日期";	
		document.getElementById('tDateTo').innerHTML="收表结束日期";
	}
}
//清屏
function BClear_click()
{
	$("#DateFrom,#DateTo").datebox('setValue',"")
	$("#RecLoc").combogrid('setValue',"")
	$("#ArrivedFlag").checkbox('setValue',"")
	BFind_click();
}

//导出
function BExportNew_click()
{
	
			var DateFromTo=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetDateFromTo");
			var QueryTime=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetQueryTime");
			if(QueryTime=="")
			{
				$.messager.alert('提示','请重新查询',"info");
				return; 
			}
		var RowsLen=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowLength");  
		if(RowsLen==0){	
			$.messager.alert('提示','此次查询结果为空',"info");	
	   		return;
		}
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
		var Templatefilepath=prnpath+'DHCPENoResultItems.xlsx';
		

	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"+
     
         "xlSheet.Cells(1,1).Value='查询时间段:"+DateFromTo+"';"+
         "xlSheet.Cells(2,1).Value='打印时间:"+QueryTime+"';"+
         "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,4)).mergecells=true;"+   //合并单元格
		"xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells(2,4)).mergecells=true;"    //合并单元格
         
        var ret=""
		var k=2
		for(var i=1;i<=RowsLen;i++)
		{  
			var DataStr=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowData",i); 
			var tempcol=DataStr.split("^");
			k=k+1;
			//xlsheet.Rows(k+1).insert(); 
			if((tempcol[1]==""))
			{    
			    
			     if(ret==""){
				    ret="xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+     //写科室名称
					 "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",4)).mergecells=true;"    //合并单元格
					  k=k+1;
					  
					 ret=ret+"xlSheet.Cells("+k+",1).Value='姓名';"+
				  	 "xlSheet.Cells("+k+",2).Value='登记号';"
				  	 
				  	var ArrivedFlag=$('#ArrivedFlag').checkbox('getValue');
				if(ArrivedFlag){
					ret=ret+"xlSheet.Cells("+k+",3).Value='到达日期';"
					}
				else {
					ret=ret+"xlSheet.Cells("+k+",3).Value='收表日期';"
					}
					
				ret=ret+"xlSheet.Cells("+k+",4).Value='项目';"+
				"xlSheet.Columns(2).NumberFormatLocal='@';"+	//设置登记号为文本型 
				"xlSheet.Columns(3).NumberFormatLocal='@';"	
				
			     }else{
				     ret=ret+"xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+     //写科室名称
					 "xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+",4)).mergecells=true;"   //合并单元格
					  k=k+1;
					 ret=ret+ "xlSheet.Cells("+k+",1).Value='姓名';"+
				  	 "xlSheet.Cells("+k+",2).Value='登记号';"
				  	   	var ArrivedFlag=$('#ArrivedFlag').checkbox('getValue');
					if(ArrivedFlag){
						ret=ret+"xlSheet.Cells("+k+",3).Value='到达日期';"
					}
					else {
						ret=ret+"xlSheet.Cells("+k+",3).Value='收表日期';"
					}
					ret=ret+"xlSheet.Cells("+k+",4).Value='项目';"+
					"xlSheet.Columns(2).NumberFormatLocal='@';"+	//设置登记号为文本型 
					"xlSheet.Columns(3).NumberFormatLocal='@';"	
			     }
			    
			
			}
			else
			{ 
				if(ret==""){
					ret="xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+
				  	"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+
				  	"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+
				  	"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"
					}else{
						ret=ret+"xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+
				  		"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+
				  		"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+
				  		"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"
					}
			                          
			}  
		}
		var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",4)).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
             "xlSheet.PrintOut();"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           // alert(Str)
		//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ;
}
//导出
function BExport_click()
{
	
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
		try{
			var DateFromTo=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetDateFromTo");
			var QueryTime=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetQueryTime");
			if(QueryTime=="")
			{
				$.messager.alert('提示','请重新查询',"info");
				return; 
			}
		var RowsLen=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowLength");  
		if(RowsLen==0){	
			$.messager.alert('提示','此次查询结果为空',"info");	
	   		return;
		}
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
		var Templatefilepath=prnpath+'DHCPENoResultItems.xlsx';
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
    	xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	
  
	
		xlsheet.cells(1,1).value="查询时间段:"+DateFromTo;
		
		xlsheet.cells(2,1).value="打印时间:"+QueryTime;
		
		var k=2
		for(var i=1;i<=RowsLen;i++)
		{  
			var DataStr=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowData",i); 
			var tempcol=DataStr.split("^");
			k=k+1
			xlsheet.Rows(k+1).insert(); 
			if((tempcol[1]==""))
			{   
				xlsheet.cells(k,1)=tempcol[0]; //写科室名称
				var Range=xlsheet.Cells(k,1);
	        	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,4)).mergecells=true; //合并单元格
	        	k=k+1
				xlsheet.Rows(k+1).insert();  
				xlsheet.cells(k,1)="姓名"
				xlsheet.cells(k,2)="登记号" 
				var ArrivedFlag=$('#ArrivedFlag').checkbox('getValue');
				if(ArrivedFlag){xlsheet.cells(k,3)="到达日期";}
				else {xlsheet.cells(k,3)="收表日期"; }
				
				xlsheet.cells(k,4)="项目" 
				xlsheet.Columns(2).NumberFormatLocal="@";  //设置登记号为文本型 
				xlsheet.Columns(3).NumberFormatLocal="@";   
			}
			else
			{
				xlsheet.cells(k,1)=tempcol[0]
				xlsheet.cells(k,2)=tempcol[1]
				xlsheet.cells(k,3)=tempcol[2]
				xlsheet.cells(k,4)=tempcol[3]
			                          
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

//查询
function BFind_click()
{	
	var ArrivedFlag=$("#ArrivedFlag").checkbox('getValue');
	if(ArrivedFlag){
		var columns =[[
			{field:'Name',width:'300',title:'姓名'},
			{field:'RegNo',width:'300',title:'登记号'},
			{field:'ARCIMDesc',width:'600',title:'项目'},
			{field:'Date',width:'300',title:'到达日期'},
						 
		]];
	}else{
		var columns =[[
			{field:'Name',width:'300',title:'姓名'},
			{field:'RegNo',width:'300',title:'登记号'},
			{field:'ARCIMDesc',width:'600',title:'项目'},
			{field:'TReceivedDate',width:'300',title:'收表日期'},
						 
		]];
	}


	$HUI.datagrid("#NoResultItemGrid",{
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
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.NoResultItems",
			QueryName:"NoResultItems",
			DateFrom:$("#DateFrom").datebox('getValue'),
		    DateTo:$("#DateTo").datebox('getValue'),
			ArrivedFlag:$HUI.checkbox('#ArrivedFlag').getValue() ? "on" : "",
			RecLocID:$("#RecLoc").combogrid('getValue'),  
			CurLocID:session['LOGON.CTLOCID'] 

		},
		columns:columns,
			
	})
}


var columns =[[
			{field:'Name',width:'300',title:'姓名'},
			{field:'RegNo',width:'300',title:'登记号'},
			{field:'ARCIMDesc',width:'600',title:'项目'},
			{field:'TReceivedDate',width:'300',title:'收表日期'},
						 
		]];

function InitNoResultItemDataGrid()
{
	$HUI.datagrid("#NoResultItemGrid",{
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
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.NoResultItems",
			QueryName:"NoResultItems",
			DateFrom:$("#DateFrom").datebox('getValue'),
		    DateTo:$("#DateTo").datebox('getValue'),
			ArrivedFlag:"",
			RecLocID:"",   
			CurLocID:session['LOGON.CTLOCID'] 

		},
		columns:columns,
			
	})
}



function InitCombobox()
{
		//接收科室
		var LocObj = $HUI.combogrid("#RecLoc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'科室编码',width:100},
			{field:'Desc',title:'科室名称',width:200}
			
			
			
		]]
	});
}