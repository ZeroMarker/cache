//页面Gui
function InitCsssUrWin(){
	var obj = new Object();
	obj.RecRowID = "";
	$.parser.parse(); // 解析整个页面
	
	//监测对象列表
	obj.gridEvObject = $HUI.datagrid("#gridEvObject",{
		fit: true,
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:false,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
		columns:[[
			{field:'ID',title:'ID',width:60},
			{field:'SESurvNumber',title:'调查编号',width:150},
			{field:'SESurvSttDate',title:'开始日期',width:150},
			{field:'SESurvEndDate',title:'结束日期',width:150},
			{field:'HospDesc',title:'医院',width:350},
			{field:'UserDesc',title:'更新人员',width:150}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridEvObject_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridEvObject_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//关联院区[多选]
	$HUI.combobox("#cboHospital",{
        url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospitalToSelect&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,

		valueField:'ID',
		textField:'BTDesc',
		rowStyle:'checkbox',
		multiple:true
	})
	InitCsssUrWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
	
}