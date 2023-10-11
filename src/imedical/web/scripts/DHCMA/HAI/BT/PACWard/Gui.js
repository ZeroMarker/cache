//页面Gui
function InitPACWardWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//病区分布定义列表
	obj.gridPACWard = $HUI.datagrid("#gridPACWard",{
		fit: true,
		fitColumns: true,
		//title: "病区分布定义",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:true,
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'LocDesc',title:'病区',width:200},
			{field:'SubNo',title:'分区号',width:100},
			{field:'AreaColor',title:'背景色',width:100},
			{field:'Building',title:'病房大楼',width:200},
			{field:'Floor',title:'楼层',width:120},
			{field:'Area',title:'区域',width:120}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPACWard_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridPACWard_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnWardSubNo").linkbutton("disable");
		}
	});
	
	//病房大楼下拉框
	var TypeCode="WardBuilding";
	obj.WardBuilding = $HUI.combobox("#WardBuilding", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+TypeCode+"&aActive=1";
		   	$("#WardBuilding").combobox('reload',url);
		}
	});
	
	InitPACWardWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}﻿