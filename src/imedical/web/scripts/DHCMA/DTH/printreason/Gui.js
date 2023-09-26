//页面Gui
function InitPrintReason(){
	var obj = new Object();		
    $.parser.parse(); // 解析整个页面  
    obj.ReportID = ReportID;
 
	obj.gridPrintReason = $HUI.datagrid("#gridPrintReason",{
		fit: true,
		//title:'死亡证明书打印明细',
		//headerCls:'panel-header-gray',
		//iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.DTHService.ReportSrv",
			QueryName:"QryPrintReasonByInDate",		
			reportId: obj.ReportID
	    },
		columns:[[
			{field:'PrintType',title:'打印类型',width:'120'},
			{field:'PrintDate',title:'打印日期',width:'100'},
			{field:'PrintTime',title:'打印时间',width:'80'},
			{field:'PrintUser',title:'打印人',width:'120'},
			{field:'ResumeText',title:'补打原因',width:'200'},
			{field:'PrintNum',title:'打印次数',width:'80'},
			{field:'UserID',title:'授权人',width:'120'}	
		]]
	});

	InitPrintReasonEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


