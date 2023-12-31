//页面Gui
function InitThWordTypeWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridThWordType = $HUI.datagrid("#gridThWordType",{
		fit: true,
		//title: "主题词分类",
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
			ClassName : "DHCHAI.RMES.ThWordTypeSrv",
			QueryName : "QryThWordType",			
	    },
		columns:[[
			{field:'ID',title:'ID',width:40},
			{field:'Code',title:'代码',width:200},
			{field:'Desc',title:'名称',width:220},
			{field:'ThemeTypeDesc',title:'主题类型',width:220}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridThWordType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridThWordType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	$HUI.combobox("#cboThemeType", {
		url:$URL+"?ClassName=DHCHAI.RMES.ThemeTypeSrv&QueryName=QryThemeType&ResultSetType=array",
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc'
	});	
	InitThWordTypeWinEvent(obj);
	obj.LoadEvent(arguments)
	return obj;
}
$(InitThWordTypeWin);