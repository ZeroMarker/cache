//页面Gui
function InitSpecimenWin(){
	var obj = new Object();
    $.parser.parse(); // 解析整个页面 
	
	obj.gridSpecimen = $HUI.datagrid("#gridSpecimen",{
		fit: true,
		title: "送检标本",
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
		    ClassName:"DHCMA.Util.EPS.SpecimenSrv",
			QueryName:"QrySpecimen"
	    },
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'OID',title:'标本ID',width:120},
			{field:'BTCode',title:'标本代码',width:150},
			{field:'BTDesc',title:'标本名称',width:300},
			{field:'IsActDesc',title:'是否有效',width:80},
			{field:'ActDate',title:'处置日期',width:100},
			{field:'ActTime',title:'处置时间',width:80},
			{field:'UserDesc',title:'处置人',width:100}
		]]
	});

	InitSpecimenWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


