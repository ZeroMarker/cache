//页面Gui
function InitLabAntiCatWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridLabAntiCat = $HUI.datagrid("#gridLabAntiCat",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'ACCode',title:'分类代码',width:300},
			{field:'ACDesc',title:'分类名称',width:550}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabAntiCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabAntiCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitLabAntiCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabAntiCatWin();
});
