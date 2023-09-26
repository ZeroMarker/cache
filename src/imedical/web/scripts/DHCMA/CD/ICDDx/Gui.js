//页面Gui
function InitQueryWin(){
	var obj = new Object();
    obj.RecRowID = '';	
    //$.parser.parse(); // 解析整个页面  
   
    obj.gridICDDx = $HUI.datagrid("#ICDDxDic",{
		fit: true,
		title:'肿瘤诊断字典',
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
			ClassName:'DHCMed.CDService.ICDDxSrv',
			QueryName:'QryICDDx'
	    },
		columns:[[
			{field:'CRCode',title:'代码',width:100},
			{field:'CRDesc',title:'名称',width:300},
			{field:'FullName',title:'诊断名称',width:500},
			{field:'IsActDesc',title:'是否有效',width:80},
			{field:'Resume',title:'备注',width:200}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridICDDx_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridICDDx_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


