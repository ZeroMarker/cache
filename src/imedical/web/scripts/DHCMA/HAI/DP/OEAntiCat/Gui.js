//页面Gui
function InitOEAntiCatWin(){
	var obj = new Object();
	obj.RecRowID = "";

	obj.gridOEAntiCat = $HUI.datagrid("#gridOEAntiCat",{
		fit: true,
		//title: "抗菌药物分类维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		nowrap:true,
		fitColumns:true,
		columns:[[
			{field:'ID',title:'ID',width:100},
			{field:'BTCode',title:'代码',width:100},
			{field:'BTDesc',title:'名称',width:200}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEAntiCat_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				//alert(JSON.stringify(rowData));
				obj.gridOEAntiCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitOEAntiCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}