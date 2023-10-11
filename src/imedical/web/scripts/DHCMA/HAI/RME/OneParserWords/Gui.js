//页面Gui
function InitOneParserWordsWin(obj){
	var obj = new Object();
	obj.RecRowID = "";	 //归一词
	obj.RecRowID_two = "";  //语义词
	
	obj.gridOneWords = $HUI.datagrid("#gridOneWords",{
		fit: true,
		title: "归一词维护",
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
		pageList : [20,50,100,200],
	    url:$URL,
	  	queryParams:{  
			ClassName : "DHCHAI.RMES.OneWordsSrv",
			QueryName : "QryOneWords",
			aVersionDr: $("#cboVerSearch").combobox("getValue")
	    },		
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'OneWord',title:'归一词',width:160},
			{field:'CatDesc',title:'实体分类',width:100},
			{field:'ActDate',title:'更新时间',width:120}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOneWords_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOneWords_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	obj.gridParserWords = $HUI.datagrid("#gridParserWords",{
		fit: true,
		title: "语义词维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:false,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{  
			ClassName : "DHCHAI.RMES.ParserWordsSrv",
			QueryName : "QryParserWords",
			aVersionDr: $("#cboVerSearch").combobox("getValue"),
			aOneWordDr:''
	    },  
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'KeyWord',title:'语义词',width:120},
			{field:'LimitWord',title:'关联属性',width:140},
			{field:'Context',title:'词组语境',width:140},
			{field:'OneWord',title:'归一词',width:140},
			{field:'IsCheck',title:'审核<br>标志',width:60,
			  formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'IsActive',title:'有效<br>标志',width:60,
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'ActDate',title:'更新时间',width:180},
			{field:'ActUser',title:'更新人',width:180}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridParserWords_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridParserWords_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			if (obj.RecRowID == ""){
				$("#btnAdd_two").linkbutton("disable");
			}else{
				$("#btnAdd_two").linkbutton("enable");
			}
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
			
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
			obj.gridOneWords.load({
				ClassName : "DHCHAI.RMES.OneWordsSrv",
				QueryName : "QryOneWords",
				aVersionDr: $("#cboVerSearch").combobox("getValue")	
			})
		},
		onLoadSuccess:function() {
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});	
	$HUI.combobox("#cboVersion,#cboVersion_two", {
		url:$URL+"?ClassName=DHCHAI.RMES.VersionSrv&QueryName=QryVersion&ResultSetType=array",
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc'
	});	
	$HUI.combobox("#cboCat", {
		editable: false,       
		defaultFilter:4,
		allowNull: true,    
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.RMES.ResultCatSrv&QueryName=QryResultCat&ResultSetType=array";
			$("#cboCat").combobox('reload',url);
		}
	});

	InitOneParserWordsWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;	
}
$(InitOneParserWordsWin);