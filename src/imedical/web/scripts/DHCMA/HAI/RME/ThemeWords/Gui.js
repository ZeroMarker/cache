//页面Gui
function InitThemeWordsWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.gridThemeWords = $HUI.datagrid("#gridThemeWords",{
		fit: true,
		//title: "主题词库",
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
			ClassName : "DHCHAI.RMES.ThemeWordsSrv",
			QueryName : "QryThemeWords",
			aThemeTypeID: $("#cboThemeTypeS").combobox("getValue")
			
	    },
		columns:[[
			{field:'ID',title:'ID',width:40},
			{field:'KeyWord',title:'关键词',width:200},
			{field:'LimitWord',title:'关联属性',width:180},
			{field:'WordTypeDesc',title:'词组分类',width:180},
			{field:'Context',title:'词组语境',width:220},
			{field:'WordAttrDesc',title:'关键词类型',width:150},
			{field:'IsActive',title:'是否<br>有效',width:60,
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'ActDate',title:'更新时间',width:180,
				formatter: function (value,row,index) {
					return value + " " + row.ActTime;
				}
			},
			{field:'ActUser',title:'更新人',width:180}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridThemeWords_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridThemeWords_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	$HUI.combobox("#cboThemeTypeS", {
		url:$URL+"?ClassName=DHCHAI.RMES.ThemeTypeSrv&QueryName=QryThemeType&ResultSetType=array",
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc',
		onSelect:function(){
			obj.gridThemeWords.load({
				ClassName : "DHCHAI.RMES.ThemeWordsSrv",
				QueryName : "QryThemeWords",
				aThemeTypeID: $("#cboThemeTypeS").combobox("getValue")
			})
		}
		,onLoadSuccess:function() {
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
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
	$HUI.combobox("#cboWordType", {
		url:$URL+"?ClassName=DHCHAI.RMES.ThWordTypeSrv&QueryName=QryThWordType&ResultSetType=array",
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc'
	});	
	
	 $HUI.combobox("#cboWordAttr",{
		data:[
			{value:'1',text:'特异指标'},
			{value:'2',text:'一般指标'}
		],
		allowNull:true,
		valueField:'value',
		textField:'text'
	});
	
	InitThemeWordsEvent(obj);
	obj.LoadEvent(arguments)
	return obj;
}
$(InitThemeWordsWin);