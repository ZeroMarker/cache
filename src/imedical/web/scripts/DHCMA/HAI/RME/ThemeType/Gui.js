//页面Gui
function InitThemeTypeWin(){
	var obj = new Object();
	
	obj.gridThemeType = $HUI.datagrid("#gridThemeType",{
		fit: true,
		//title: "主题分类",
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
			ClassName : "DHCHAI.RMES.ThemeTypeSrv",
			QueryName : "QryThemeType",
			aVersionDr: $("#cboVerSearch").combobox("getValue")
			
	    },
		columns:[[
			{field:'ID',title:'ID',width:40},
			{field:'Code',title:'代码',width:200},
			{field:'Desc',title:'名称',width:220},
			{field:'VerDesc',title:'词库版本',width:320},
			
			{field:'IsActive',title:'是否<br>有效',width:60,
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'ActDate',title:'更新时间',width:200,
				formatter: function (value,row,index) {
					return (value+ ' ' + row["ActTime"])
				}
			},
			{field:'ActUser',title:'更新人',width:180}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridThemeType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridThemeType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	$HUI.combobox("#cboVerSearch", {
		url:$URL+"?ClassName=DHCHAI.RMES.VersionSrv&QueryName=QryVersion&ResultSetType=array",
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc',
		onSelect:function(){
			obj.gridThemeType.load({
				ClassName : "DHCHAI.RMES.ThemeTypeSrv",
				QueryName : "QryThemeType",
				aVersionDr: $("#cboVerSearch").combobox("getValue")
			});
			obj.RecRowID="";
		}
	});	
	$HUI.combobox("#cboVersion", {
		url:$URL+"?ClassName=DHCHAI.RMES.VersionSrv&QueryName=QryVersion&ResultSetType=array",
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc'
	});	
	InitThemeTypeWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(InitThemeTypeWin);