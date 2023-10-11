
/// 会诊日志窗口
OpenCsLogWin = function(){

	if (CstItmID == ""){
		$.messager.alert("提示:","请先选择一条会诊记录！","warning");
		return;
	}
	
	if($('#LogWin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="LogWinDiv" style="padding:10px;"></div>');
	$("#LogWinDiv").append('<div id="LogWin"></div>');

	/// 日志窗口window
	var option = {
		collapsible:true,
		border:true,
		closed:"true",
		iconCls:'icon-paper',
		collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false
	};
	InitLogGrid();  /// 初始定义窗口DataGrid
	new WindowUX('会诊日志详情', 'LogWinDiv', (window.screen.availWidth-500), '400', option).Init();
	//$("#LogWin").html();
}

/// 初始定义窗口DataGrid
function InitLogGrid(){
	
	///  定义columns
	var columns=[[
		{field:'Status',title:'状态',width:100,align:'center',formatter:
			function (value, row, index){
				if ((value == "取消")||(value == "拒绝")||(value == "驳回")){
					return '<font style="color:red;font-weight:bold;">'+value+'</font>';
				}else{
					return '<font style="color:green;font-weight:bold;">'+value+'</font>';
				}
			}
		},
		{field:'LgDate',title:'日期',width:100,align:'center'},
		{field:'LgTime',title:"时间",width:100,align:'center'},
		{field:'LgUser',title:"操作人",width:100},
		{field:'LogNotes',title:"备注",width:500,formatter:SetCellField}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		fit : true,
		nowrap : false,
	    onDblClickRow: function (rowIndex, rowData) {
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonCsLog&itmID="+CstItmID+"&MWToken="+websys_getMWToken();
	new ListComponent('LogWin', columns, uniturl, option).Init();
}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}