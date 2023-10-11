//页面Gui
function InitKeyWordWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	//关键词列表
	obj.gridKeyWord = $HUI.datagrid("#gridKeyWord",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,    //是否是服务器对数据排序
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:50,sortable:true,sorter:Sort_int},
			{field:'Desc',title:'名称',width:200,sortable:true},
			{field:'Note',title:'说明',width:200}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridKeyWord_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridKeyWord_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitKeyWordWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}