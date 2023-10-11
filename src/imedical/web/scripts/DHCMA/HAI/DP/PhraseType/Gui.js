//页面Gui
function InitPhraseTypeWin(){
	var obj = new Object();
	obj.RecRowID = "";
	$.parser.parse(); // 解析整个页面
	
	//短语分类列表
	obj.gridPhraseType = $HUI.datagrid("#gridPhraseType",{
		fit: true,
		title: "",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns:true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		columns:[[
			{field:'ID',title:'ID',width:100,sortable:true},
			{field:'Code',title:'代码',width:380,sortable:true},
			{field:'Desc',title:'描述',width:380,sortable:true},
			{field:'DicTypeCode',title:'对照字典分类代码',width:380,sortable:true},
			{field:'DicTypeDesc',title:'对照字典分类描述',width:380,sortable:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPhraseType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPhraseType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	
	//字典分类
	$HUI.combobox("#cboDicType",{
		defaultFilter:4,
		url:$URL+'?ClassName=DHCHAI.BTS.DicTypeSrv&QueryName=QryDicType&ResultSetType=Array',
		valueField:'Code',
		textField:'Desc',
		panelHeight:300,
		editable:true  
	})
	
	InitPhraseTypeWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}