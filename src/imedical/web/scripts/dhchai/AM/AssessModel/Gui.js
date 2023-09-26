//页面Gui
function InitAssModelWin(){
	var obj = new Object();
    obj.RecRowID = '';	
  	
    obj.gridAssModel = $HUI.datagrid("#AssessModel",{
		fit: true,
		title:'疑似病例筛查评估模型',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.AMS.AssessModelSrv',
			QueryName:'QryAssessModel'
	    },
		columns:[[
			{field:'AMCode',title:'评估模型代码',width:100},
			{field:'AMDesc',title:'评估模型定义',width:150},
			{field:'AdmStatusDesc',title:'就诊状态',width:100},
			{field:'ClassName',title:'类方法',width:300},
			{field:'Note',title:'规则说明',width:320},
			{field:'IsActDesc',title:'是否有效',width:100}, 
			{field:'SttDate',title:'开始日期',width:100},
			{field:'EndDate',title:'结束日期',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridAssModel_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridAssModel_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitAssModelWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


