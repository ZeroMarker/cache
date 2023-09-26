//页面Gui
function InitPathVarCatListWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridPathVarCat = $HUI.datagrid("#gridPathVarCat",{
		fit: true,
		title: "变异原因分类维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathVarCatSrv",
			QueryName:"QryPathVarCat"
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'100'},
			{field:'BTCode',title:'代码',width:'255',sortable:true},
			{field:'BTDesc',title:'名称',width:'720'}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {	
				obj.gridPathVarCat_onSelect();	
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathVarCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitPathVarCatListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


