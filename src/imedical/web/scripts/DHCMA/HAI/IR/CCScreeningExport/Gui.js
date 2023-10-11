//页面Gui
var objScreen = new Object();
function InitCCScreenExportWin(){
	var obj = objScreen;
    obj.RecRowID = '';	
     
    obj.gridScreenExport = $HUI.datagrid("#ScreenExport",{
		fit: true,
		title:'疑似病例筛查列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		/* url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QryScreenAllInfo',
			aTypeFlag: aTypeFlag,
	    	aDateFrom: aDateFrom,
	    	aDateTo: aDateTo,
	    	aHospIDs: aHospIDs,
	    	aViewFlag: aViewFlag,
	    	aGroupUser: aGroupUser,
	    	aPatInfo: aPatInfo,
	    	aShowType: aShowType,
	    }, */
		columns:[[
			{field:'RegNo',title:'登记号',width:110,sortable:true},
			{field:'PatName',title:'姓名',width:80},
			{field:'Sex',title:'性别',width:50},
			{field:'Age',title:'年龄',width:50},
			{field:'InHospDate',title:'入院日期',width:100},
			{field:'OutHospDate',title:'出院日期',width:100},
			{field:'CurrLoc',title:'当前科室',width:200},
			{field:'CurrBed',title:'当前床位',width:80},
			{field:'ResultNotes',title:'筛查指标',width:200,showTip:true},
			{field:'VisitStatus',title:'在院状态',width:80},
			{field:'NeedMsgDesc',title:'需关注备注',width:400}
		]]
	});
	
	InitCCScreenExportWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


