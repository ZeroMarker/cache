//页面Gui
function InitPathEntityListWin(){
	var obj = new Object();
	obj.RecRowID= "";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridPathEntity = $HUI.datagrid("#gridPathEntity",{
		fit: true,
		title: "手术并发症类型字典",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.IMP.BTS.OperCompDicSrv",
			QueryName:"QryOperCompDic",
			aIsActive:""
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'160',sortable:true},
			{field:'BTDesc',title:'名称',width:'320'}, 
			{field:'BTIsActive',title:'是否有效',width:'100'},
			{field:'BTOrder',title:'顺序号',width:'160'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathEntity_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathEntity_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitPathEntityListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


