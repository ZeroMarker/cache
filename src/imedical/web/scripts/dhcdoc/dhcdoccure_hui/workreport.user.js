var CureReportDataGrid;
$(document).ready(function(){
	Init();
	InitEvent();
	CureReportDataGridLoad();
});

function Init(){
	InitDate();
	InitDoc(); 
  	InitArcimDesc(); 
  	InitCureReportDataGrid();	
}

function InitEvent(){
	$('#btnFind').bind('click', function(){
		   CureReportDataGridLoad();
    });
    
    $('#btnExport').bind('click', function(){
		   ExportCureReport();
    });
}

function InitCureReportDataGrid()
{
	CureReportDataGrid=$('#tabRecordReportList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"seqno",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		//<!--出参是：执行人、资源组（医嘱项）、执行数量、金额-->
		columns :[[ 
				{field:'seqno',title:'序号',width:30,hidden:true}, 
				{field:'FinishUser',title:'执行人',width:30}, 
				{field:'ArcimDesc',title:'治疗项目',width:50},								
				{field:'UnitPrice',title:'单价(元)',width:20}, 
				{field:'OrderQty',title:'执行数量',width:20}, 
				{field:'OrdBillUOM',title:'单位',width:30}, 
				{field:'OrdPrice',title:'总金额(元)',align:'right',width:30}, 
				{field:'Job',title:'Job',width:30,hidden:true}   
			 ]] 
	});
}
function CureReportDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryDoc=$("#ComboDoc").combobox("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryWorkReportFor",
		'query':"doc",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryDoc':queryDoc,
		'queryLoc':session['LOGON.CTLOCID'],
		'queryArcim':queryArcim,
		Pagerows:CureReportDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})	
}

function ExportCureReport(){
	try{
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryDoc=$("#ComboDoc").combobox("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;	
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID']);
		var Title=myret+"个人治疗工作量统计"
		//导出
		var rtn = $cm({
			dataType:'text',
			ResultSetType:'Excel',
			ExcelName:Title,
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForExport",
			'query':"doc",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':queryDoc,
			'queryLoc':session['LOGON.CTLOCID'],
			'queryArcim':queryArcim,
		}, false);
		location.href = rtn;
		//打印
		var PrintNum = 1; //打印次数
		var IndirPrint = "N"; //是否预览打印
		var TaskName=Title; //打印任务名称
		
		var GridData=$.cm({
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForExport",
			'query':"doc",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':queryDoc,
			'queryLoc':session['LOGON.CTLOCID'],
			'queryArcim':queryArcim,
			Pagerows:CureReportDataGrid.datagrid("options").pageSize,
			rows:99999
		},false)	
		var DetailData=GridData.rows; //明细信息
		if (DetailData.length==0) {
			$.messager.alert("提示","没有需要打印的数据!");
			return false
		}
		//明细信息展示
		var Cols=[
			{field:"FinishUser",title:"执行人",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"治疗项目",width:"10%",align:"left"},
			{field:"UnitPrice",title:"单价(元)",width:"10%",align:"right"},
			{field:"OrderQty",title:"执行数量",width:"10%",align:"right"},
			{field:"OrdPrice",title:"总金额",width:"10%",align:"right"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
		return;
		
		
		var UserID=session['LOGON.USERID'];
		var RowIDs=CureReportDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("提示","未有需要导出的数据");
			return false;
		}
		CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}

		if(ProcessNo==""){
			$.messager.alert("提示","获取进程号错误");
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("提示","获取导出数据错误");
			return false;
		}
	
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureWorkReportUser.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	
    	var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
    	var DateStr=StartDate+"至"+EndDate
    	xlsheet.cells(2,2)=DateStr;
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID']);
		var Title=myret+"个人治疗工作量统计"
    	var xlsrow=3;
		xlsheet.cells(1,1)=Title;
	    for(var i=1;i<=datacount;i++){
			var ret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForInfo",ProcessNo,i,UserID);
			if(ret=="") return ;
			var arr=ret.split("^");
			xlsrow=xlsrow+1;
			var FinishUser=arr[6]
			var ArcimDesc=arr[1]
			var UnitPrice=arr[2]
			var OrderQty=arr[3]
			var OrdBillUOM=arr[4]
			var OrdPrice=arr[5]
			if(OrdBillUOM!="")OrdBillUOM="/"+OrdBillUOM;
			xlsheet.cells(xlsrow,1)=FinishUser;
			xlsheet.cells(xlsrow,2)=ArcimDesc;
			xlsheet.cells(xlsrow,3)=UnitPrice+"元";;
		    xlsheet.cells(xlsrow,4)=OrderQty+OrdBillUOM;
		    xlsheet.cells(xlsrow,5)=OrdPrice+"元";;		    
	    }
	    xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,5)
		xlBook.Close (savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}catch(e){
		alert(e.message);	
	}
}
