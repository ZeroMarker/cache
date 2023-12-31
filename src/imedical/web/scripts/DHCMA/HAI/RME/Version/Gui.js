//页面Gui

function InitVersionWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridVersion = $HUI.datagrid("#gridVersion",{
		fit: true,
		//title: "词库版本",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
	    url:$URL,
	   queryParams:{  
			ClassName : "DHCHAI.RMES.VersionSrv",
			QueryName : "QryVersion"
	    },
		columns:[[
			{field:'ID',title:'ID',width:40},
			{field:'Code',title:'版本代码',width:200},
			{field:'Desc',title:'版本名称',width:340},
			{field:'LCode',title:'外部关联码',width:520}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridVersion_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridVersion_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitVersionWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(InitVersionWin);