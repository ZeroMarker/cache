//页面Gui
function InitOrdMastWin(){
	var obj = new Object();
    $.parser.parse(); // 解析整个页面 
	
	obj.gridOrdMast = $HUI.datagrid("#gridOrdMast",{
		fit: true,
		title: "医嘱项",
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
		    ClassName:"DHCMA.Util.EPS.OrdMastSrv",
			QueryName:"QryOrdMast"
	    },
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'OID',title:'医嘱ID',width:120},
			{field:'BTCode',title:'医嘱代码',width:150},
			{field:'BTDesc',title:'医嘱名称',width:300},
			{field:'CatDesc',title:'医嘱分类',width:200},
			{field:'TypeDesc',title:'医嘱类型',width:100},
			{field:'IsActDesc',title:'是否有效',width:80},
			{field:'ActDate',title:'处置日期',width:100},
			{field:'ActTime',title:'处置时间',width:80},
			{field:'UserDesc',title:'处置人',width:100}
		]]
	});

	InitOrdMastWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


