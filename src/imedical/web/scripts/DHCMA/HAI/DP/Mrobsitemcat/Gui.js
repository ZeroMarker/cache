//页面Gui
function InitMROBSItemCatWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
    
    obj.gridMROBSItemCat = $HUI.datagrid("#gridMROBSItemCat",{
		fit: true,
		title: "",
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
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.MROBSItemCatSrv",
			QueryName:"QryMROBSItemCat"
	    },
		columns:[[
			{field:'ID',title:'ID',width:200},
			{field:'BTCode',title:'代码',width:500,sortable:true},
			{field:'BTDesc',title:'名称',width:500}, 
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMROBSItemCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMROBSItemCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitMROBSItemCatWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}