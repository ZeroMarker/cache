//页面Gui
function InitTestSetWin(){
	var obj = new Object();
	obj.RecRowID1 = '';
	obj.RecRowID2 = '';
    $.parser.parse(); // 解析整个页面 
	
	obj.gridTestSet = $HUI.datagrid("#gridTestSet",{
		fit: true,
		title: "检验医嘱",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.EPS.TestSetSrv",
			QueryName:"QryTestSetByTC",
			aTCID:obj.RecRowID2
	    },
		columns:[[
			{field:'OID',title:'检验医嘱ID',width:100},
			{field:'BTCode',title:'检验医嘱代码',width:100},
			{field:'BTDesc',title:'检验医嘱名称',width:240},
			{field:'BTCode2',title:'检验医嘱代码2',width:120},
			{field:'BTDesc2',title:'检验医嘱名称2',width:240},
			{field:'IsActDesc',title:'是否有效',width:80},
			{field:'ActDate',title:'处置日期',width:100},
			{field:'ActTime',title:'处置时间',width:80},
			{field:'UserDesc',title:'处置人',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.RecRowID1=rowData.ID;
				obj.gridTestCode.reload();
			}
		},onBeforeLoad: function (param) {
			param.aTCID = obj.RecRowID2;
		}
	});
	
	obj.gridTestCode = $HUI.datagrid("#gridTestCode",{
		fit: true,
		title: "检验项目",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.EPS.TestSetSrv",
			QueryName:"QryTestCodeByTS",
			aTSID:obj.RecRowID1
	    },
		columns:[[
			{field:'OID',title:'检验项目ID',width:100},
			{field:'BTCode',title:'检验项目代码',width:100},
			{field:'BTDesc',title:'检验项目名称',width:200},
			{field:'WCode',title:'缩写码',width:80},
			{field:'RstFormat',title:'结果类型',width:80},
			{field:'AbFlagS',title:'异常标志',width:100},
			{field:'ClDiagnos',title:'临床意义',width:150},
			{field:'RefRanges',title:'正常参考值',width:100},
			{field:'IsActDesc',title:'是否有效',width:80},
			{field:'ActDate',title:'处置日期',width:100},
			{field:'ActTime',title:'处置时间',width:80},
			{field:'UserDesc',title:'处置人',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.RecRowID2=rowData.ID;
				obj.gridTestSet.reload();
			}
		},onBeforeLoad: function (param) {
			param.aTSID = obj.RecRowID1;
		}
	});

	InitTestSetWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


