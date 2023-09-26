//页面Gui
function InitQueryWin(){
	var obj = new Object();
    obj.RecRowID = '';	
    //$.parser.parse(); // 解析整个页面  
   
   obj.gridAnatomy = $HUI.datagrid("#Anatomy",{
		fit: true,
		title:'解剖学编码字典',
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
			ClassName:'DHCMed.CDService.AnatomySrv',
			QueryName:'QryAnatomy'
	    },
		columns:[[
			{field:'CRCode',title:'代码',width:100},
			{field:'CRDesc',title:'描述',width:800},
			{field:'IsActDesc',title:'有效标志',width:100}, 
			{field:'Resume',title:'备注',width:200}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridAnatomy_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridAnatomy_onDbselect(rowData);
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


