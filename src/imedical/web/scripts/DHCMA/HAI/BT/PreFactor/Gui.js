﻿//页面Gui
function InitPreFactorWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//易感因素列表
	obj.gridPreFactor = $HUI.datagrid("#gridPreFactor",{
		fit: true,
		//title: "易感因素维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.BTS.PreFactorSrv",
			QueryName:"QueryPreFactor"
	    },
		columns:[[
			{field:'ID',title:'ID',width:100},
			{field:'BTCode',title:'代码',width:100},
			{field:'BTDesc',title:'名称',width:400},
			{field:'BTIndNo',title:'排序码',width:100},
			{field:'BTIsNewborn',title:'是否新生儿',width:100},
			{field:'BTIsActive',title:'是否有效',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPreFactor_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridPreFactor_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitPreFactorWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}