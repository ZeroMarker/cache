//页面Gui
var aflg=""
function InitLabTestSetMapWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.RecRowIDTC = "";
   	obj.layer_rd=""	;
	var IsCheckFlag=false;
	//检验医嘱
	obj.gridLabTestSetMap = $HUI.datagrid("#gridLabTestSetMap",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.DPS.LabTestSetSrv",
			QueryName:"QryLabTestSetMap",	
			aFlg:aflg,
			aAlias:''	
	    },
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'TestSet',title:'检验医嘱',width:180},
			{field:'OrdDesc',title:'医嘱项',width:180},
			{field:'MapItemDesc',title:'标准名称',width:100},
			{field:'MapNote',title:'备注',width:150},
			{field:'HospGroup',title:'医院',width:180},
			{field:'IsActDesc',title:'有效<br>标志',width:50}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabTestSetMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabTestSetMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnEdit").linkbutton("disable");
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//检验项目
	obj.gridLabTestCode = $HUI.datagrid("#gridLabTestCode",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.DPS.LabTCMapSrv",
			QueryName:"QryMapTestCode",	
			aFlg:aflg,
			aAlias:''	
	    },
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'TestCode',title:'检验项目',width:80},
			{field:'TestDesc',title:'项目名称',width:220,showTip:true},
			{field:'TestSetList',title:'检验医嘱',width:300,showTip:true},
			{field:'MapItemDesc',title:'对照医嘱',width:200},
			{field:'IsActDesc',title:'是否<br>有效',width:50}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabTestCode_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnAddTC").linkbutton("disable");
			$("#btnDeleteTC").linkbutton("disable");
		}
	});
	
	obj.gridLabTestSet = $HUI.datagrid("#gridLabTestSet",{
		fit: true,
		title: "检验医嘱标准字典",
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
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.DPS.LabTestSetSrv",
			QueryName:"QryLabTestSet"
	    },
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'TSCode',title:'检验医嘱代码',width:100},
			{field:'TestSet',title:'检验医嘱名称',width:150}
		]],
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridLabTestSet').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		}
	});
	
	InitLabTestSetMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabTestSetMapWin();
});