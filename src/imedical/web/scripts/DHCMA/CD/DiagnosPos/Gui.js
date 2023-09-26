//页面Gui
function InitQueryWin(){
	var obj = new Object();
    obj.RecRowID = '';	
    $.parser.parse(); // 解析整个页面  
   
   obj.gridDiagPos = $HUI.treegrid("#DiagnosPos",{
		fit: true,
		title:'肿瘤诊断部位',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		idField:'RowId',           //关键字段来标识树节点，不能重复  
		treeField:'RowDesc', //树节点字段，也就是树节点的名称
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCMed.CDService.DiagnosPosSrv',
			QueryName:'QryDiagPosTree'
	    },
		columns:[[
			//{field:'ID',title:'ID',width:80},
			{field:'RowDesc',title:'诊断部位(亚部位)',width:400},
			{field:'CRCode',title:'代码',width:80},
			/*{field:'CRDesc',title:'诊断部位(亚部位)',width:300},*/
			{field:'PosFlagDesc',title:'部位标志',width:80}, 
			{field:'IsActDesc',title:'有效标志',width:80}, 
			{field:'Resume',title:'备注',width:400}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDiagPos_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridDiagPos_onDbselect(rowData);
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


