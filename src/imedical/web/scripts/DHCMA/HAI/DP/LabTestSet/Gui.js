//页面Gui
function InitLabTestSetWin(){
	var obj = new Object();
	obj.RecRowID=""
	obj.RecRowID2=""
	//检验医嘱分类
	obj.gridLabSetCat = $HUI.datagrid("#gridLabSetCat",{
		fit: true,
		title: "检验医嘱分类",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		loadFilter:pagerFilter,
		nowrap:true,
		fitColumns: true,
	    /*url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.LabTestSetSrv",
			QueryName:"QryLabSetCat"
	    },*/
		columns:[[
			{field:'BTCode',title:'分类代码',width:120},
			{field:'BTDesc',title:'分类名称',width:250}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabSetCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabSetCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
			$("#btnAdd_two").linkbutton("disable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
		}
	});
	
	obj.gridLabTestSet = $HUI.datagrid("#gridLabTestSet",{
		fit: true,
		title: "检验医嘱配置",
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
		    ClassName:"DHCHAI.DPS.LabTestSetSrv",
			QueryName:"QryLabSetByCat",
			aCatID:""
	    },*/
		columns:[[
			{field:'TSCode',title:'检验医嘱代码',width:100},
			{field:'TestSet',title:'检验医嘱名称',width:200,showTip:true},
			{field:'CatDesc',title:'分类名称',width:150},			
			{field:'IsSubItemDesc',title:'是否<br>送检项目',width:80},
			{field:'IsVirusDesc',title:'病毒<br>检验项目',width:80},
			{field:'IsActDesc',title:'是否<br>有效',width:80},
			{field:'Note',title:'备注',width:120,showTip:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabTestSet_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabTestSet_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
		}
	});
	
	InitLabTestSetWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabTestSetWin();
});