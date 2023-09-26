
//名称	DHCPESpecDetail.hisui.js
//功能	标本采集信息	
//创建	2019.06.25
//创建人  xy
var columns =[[
			{field:'RecordSum',title:'RecordSum',hidden: true},
			{field:'TRegNo',width:'150',title:'数量'},
			{field:'TName',width:'400',title:'项目'},
			{field:'TSpecNo',title:'标本号',hidden: true},
			{field:'TReceiver',width:'250',title:'采集人'},
			{field:'TRecDate',title:'采集时间',hidden: true},	
			{field:'TSpecDesc',width:'200',title:'容器',
				formatter:function(value,row,index){ 
					if(row.TSpecColor!=""&& row.TSpecColor!="#ffffff" && row.TSpecColor!="白色"){
						return  '<span style="color:white">'+value+'</span>';
					}else
					{
 						return value;
					}
				}, 
				styler: function (value,row,index) {
					return 'background-color:'+row.TSpecColor;
				}  },
			{field:'TSpecColor',hidden:true},	
			{field:'TSpecCode',hidden:true},
			{field:'TResultStatus',width:'100',title:'检验状态'}		
			 
		]];
		
$(function(){
	 
	
	 	
	InitCombobox();
	 
	 info();
	 
	InitSpecDetailGrid();
	

	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
   //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
          
     //获取检验结果
	$("#BGetLisResult").click(function() {	
		BGetLisResult_click();		
        });
        
       
      // 标本核收清单
	$("#BPrintASpecimen").click(function(){
		BPrintASpecimenList_click();		
        });   
    
    /*    
   //类型
	$("#Type").combobox({
       onSelect:function(){
			Type_change();
	}
	});

    */
    
        
})
 
 
 function info(){
	 $("#BeginDate").datebox('setValue',BeginDate);
	 $("#EndDate").datebox('setValue',EndDate);
	 $("#Type").combobox('setValue',Type);
 }
 
 //清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue',"")
	$(".hisui-combobox").combobox('setValue',"");
	$("#RegNo,#Name").val("");
	$("#ArrivedFlag").checkbox('setValue',"")
	
}

//获取检验结果
function BGetLisResult_click(){

	var UserID=session['LOGON.USERID'];
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	 
	var rtn=tkMakeServerCall("web.DHCPE.BarPrintFind","GetLisResult",BeginDate+"^"+EndDate,UserID);
	
	if(rtn=="1"){
		$.messager.alert("提示","获取检验结果完成","success");
	}else{
		$.messager.alert("提示","没有检验项目","info");	
	}
	
}



	
function BPrintASpecimenListNew_click(){
	
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	
         
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
        
  
	var ExportName="DHCPESpecDetail";
	var CurFindType=$("#Type").combobox('getValue');
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName,CurFindType);
	var ret="";
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			  if(ret==""){ret="xlSheet.Cells("+Row+","+i+").Value='"+DataArr[i]+"';" }
		      else{
			      ret=ret+"xlSheet.Cells("+Row+","+i+").Value='"+DataArr[i]+"';"
			      
			       }
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	
	}
	
	 var col=i-1
	 
	 var Str=Str+ret+
	   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+Row+","+col+")).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
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
	
	


// 标本核收清单
function BPrintASpecimenList_click(){
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	try{
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	xlApp = new ActiveXObject("Excel.Application"); 
	xlApp.UserControl = true;
    xlApp.visible = true; 
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  
	xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	var ExportName="DHCPESpecDetail";
	var CurFindType=$("#Type").combobox('getValue');
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName,CurFindType);
	
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	
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
	 BPrintASpecimenListNew_click();
}
	
}

//查询
function BFind_click(){
	
	var Type=$("#Type").combobox('getValue');
	
	if(Type=="Detail"){
		var columns =[[
			{field:'RecordSum',title:'RecordSum',hidden: true},
			{field:'TRegNo',width:'180',title:'登记号'},
			{field:'TName',width:'180',title:'姓名'},
			{field:'TSpecNo',width:'200',title:'标本号'},
			{field:'TReceiver',width:'150',title:'采集人'},
			{field:'TRecDate',width:'250',title:'采集时间'},			 
		]];
	}
	if(Type=="Item"){
		var columns =[[
			{field:'TRegNo',width:'150',title:'数量'},
			{field:'TName',width:'450',title:'项目'},
			{field:'TReceiver',width:'150',title:'采集人'},	
			{field:'TSpecDesc',width:'200',title:'容器',
				formatter:function(value,row,index){ 
					if(row.TSpecColor!=""&& row.TSpecColor!="#ffffff" && row.TSpecColor!="白色"){
						return  '<span style="color:white">'+value+'</span>';
					}else
					{
 						return value;
					}
				}, 
				styler: function (value,row,index) {
					return 'background-color:'+row.TSpecColor;
				}},
			{field:'TSpecColor',hidden:true},	
			{field:'TSpecCode',hidden:true}	 
		]];
	}
 	if(Type=="Person"){
		var columns =[[
			{field:'TRegNo',width:'400',title:'数量'},
			{field:'TReceiver',width:'400',title:'采集人'},
			 
		]];
	}
	
	var ShowTotal=$("#ShowTotal").checkbox('getValue')
	if(ShowTotal){var iShowTotal="1";}
	else{var iShowTotal="0";}
	var SpecCode=$("#Container").combogrid("getValue");
	if(SpecCode=="undefind") SpecCode="";
	
	$HUI.datagrid("#SpecDetailTab",{
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
			ClassName:"web.DHCPE.BarPrintFind",
			QueryName:"FindSpecDetail",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			FindType:$("#Type").combobox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			ShowTotal:iShowTotal,
			VName:$("#Name").val(),
			SpecCode:SpecCode
				
		},
		
		columns:columns,
			
	})
}





function InitSpecDetailGrid(){
	
	$HUI.datagrid("#SpecDetailTab",{
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
			ClassName:"web.DHCPE.BarPrintFind",
			QueryName:"FindSpecDetail",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			FindType:$("#Type").combobox('getValue'),
					
		},
		columns:columns,
			
	})
		
}


function InitCombobox(){
	
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
		
		
	//类型
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'Detail',text:'明细'},
            {id:'Item',text:'项目'},
            {id:'Person',text:'个人'},
        ]

	});	
	var ContainerObj=$HUI.combogrid("#Container",{
		panelWidth: 320,
		idField: 'SpecCode',
		textField: 'SpecDesc',
		method: 'get',
		url:$URL+'?ClassName=web.DHCPE.BarPrintFind&QueryName=QuerySPECContainers',
		onBeforeLoad:function(param){
			param.Desc = param.q
		},
		mode:'remote',
		delay:200,
		columns: [[           				            			
			{field:'SpecCode',title:'代码',width:50},
			{field:'SpecDesc',title:'容器',width:100,
				formatter:function(value,row,index){ 
					if(row.SpecColor!=""&& row.SpecColor!="#ffffff" && row.SpecColor!="白色"){
						return  '<span style="color:white">'+value+'</span>';
					}else
					{
 						return value;
					}
				}, 
				styler: function (value,row,index) {
					return 'background-color:'+row.SpecColor;
				}  
			},
			{field:'SpecColor',hidden:true}
		]],
		fitColumns: true,
		pagination:true,
		pageSize:20,
		displayMsg:''
	});
}