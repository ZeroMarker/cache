//页面Gui
function InitOEANTListWin(){
	var obj = new Object();
	obj.gridOEItemList = $HUI.datagrid("#gridOEItemList",{
		fit:true,
		title: "手术申请",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		nowrap: false,
		rownumbers:true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 20,
		pageList : [20,50,100,200,1000],
		columns:[[
			{field:'OperName',title:'手术名称',width:300,sortable:true},
			{field:'OperType',title:'手术类型',width:80,sortable:true},
			{field:'OperLocDesc',title:'手术科室',width:150,sortable:true},
			{field:'OperStartDate',title:'手术开始时间',width:150,sortable:true},
			{field:'OperEndDate',title:'手术结束时间',width:150,sortable:true},
			{field:'OperStatus',title:'手术状态',width:80,sortable:true},
			{field:'OpertorName',title:'手术医生',width:80,sortable:true},
			{field:'AnesthDesc',title:'麻醉方式',width:80,sortable:true},
			{field:'ASADesc',title:'ASA评分',width:130,sortable:true},
			{field:'CuteTypeDesc',title:'切口类型',width:80,sortable:true},
			{field:'HealDesc',title:'愈合情况',width:100,sortable:true},
			{field:'NNISDesc',title:'NNIS分级',width:100,sortable:true}
		]],
		onSelect:function(rindex,rowData){
		
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
           // dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	InitOEANTListWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
