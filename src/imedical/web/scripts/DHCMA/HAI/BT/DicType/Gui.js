//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridDicType = $HUI.datagrid("#gridDicType",{
		fit: true,
		//title: "字典类型",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	   
		columns:[[
			{field:'ID',title:'ID',width:180,align:'center'},
			{field:'Code',title:'类型代码',width:560},
			{field:'Desc',title:'类型名称',width:560}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDicType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDicType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}
$(InitWin);

