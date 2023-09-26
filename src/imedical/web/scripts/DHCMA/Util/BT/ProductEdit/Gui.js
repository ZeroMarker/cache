//页面Gui
function InitProEditWin(){
	var obj = new Object();
	//obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridProduct = $HUI.datagrid("#gridProduct",{
		title: "产品线列表",
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.BTS.ProductSrv",
			QueryName:"QryProduct"
	    },
		columns:[[
			{field:'ProID',title:'ID',width:'50'},
			{field:'ProCode',title:'产品代码',width:'80'},
			{field:'ProDesc',title:'产品名称',width:'200'},
			{field:'ProVersion',title:'版本号',width:'150'},
			{field:'ProIconCls',title:'图标样式',width:'150'},
			{field:'ProIndNo',title:'顺序号',width:'80'},
			{field:'IsActDesc',title:'是否有效',width:'80'},
			{field:'ProResume',title:'备注',width:'275'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridProduct_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridProduct_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitProEditWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


