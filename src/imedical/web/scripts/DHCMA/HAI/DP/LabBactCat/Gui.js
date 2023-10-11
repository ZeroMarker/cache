//页面Gui
function InitLabBactCatWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.RecRowID2 = "";
	//细菌分类
	obj.gridLabBactCat = $HUI.datagrid("#gridLabBactCat",{
		fit: true,
		title: "细菌分类",
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
	    /*url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBactCat"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BCCode',title:'分类代码',width:150},
			{field:'BCDesc',title:'分类名称',width:250}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabBactCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabBactCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
		}
	});
	
	//细菌类型
	obj.gridLabBactType = $HUI.datagrid("#gridLabBactType",{
		fit: true,
		title: "细菌类型",
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
	    /*url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBactType"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BCCode',title:'类型代码',width:150},
			{field:'BCDesc',title:'类型名称',width:150}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabBactType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabBactType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
		}
	});
	
	InitLabBactCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabBactCatWin();
});