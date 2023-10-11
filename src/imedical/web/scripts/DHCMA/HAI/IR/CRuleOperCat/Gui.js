$(function () {
	InitOROperCatWin();
});

//页面Gui
function InitOROperCatWin() {
	var obj = new Object();
	var SelectedInd = 0;
	obj.RecRowID= "";
	obj.RecKeyID= "";

    //手术分类
    obj.gridOperCat= $HUI.datagrid("#gridOperCat",{
		fit: true,
		title: "手术分类",
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
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
			QueryName:"QryOperCat"
		},
		columns:[[
			{field:'OperCat',title:'分类名称',width:160,sortable:true},
			{field:'KeyTypeDesc',title:'关键词类型',width:100},
			{field:'IncludeKey',title:'包含词',width:150}, 
			{field:'ExcludeKeys',title:'排除词',width:80},
			{field:'OperTypeDesc',title:'类别',width:50}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOperCat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOperCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			//所有列进行合并操作
            //$(this).datagrid("autoMergeCells");
            //指定列进行合并操作
            $(this).datagrid("autoMergeCells", ['OperCat']);
		}
	});
	
	obj.LoadgridOROper  = function() { 
		$HUI.datagrid("#gridOROper",{
			fit: true,
			title: "手术信息",
			iconCls:"icon-resort",
			headerCls:'panel-header-gray',
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: false, //如果为true, 则显示一个行号列
			nowrap:true,
			fitColumns: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			pageSize: 100,
			pageList : [100,200,500,1000],
			url:$URL,
			queryParams:{
				ClassName:"DHCHAI.IRS.CRuleOperCatSrv",
				QueryName:"QryOperAnaes",
				aOperCat:$('#cboOperCat').combobox('getValue'),
				aAlias:$('#searchbox').searchbox('getValue'),
				aShowAll:0
			},
			columns:[[
				{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
				{field:'OperICD',title:'主要编码',width:150},
				{field:'OperDesc',title:'名称',width:200,sortable:true},
				{field:'OperType',title:'类别',width:100,sortable:true},
				{field:'OperCatList',title:'分类名称',width:300}
			]],
			onLoadSuccess:function(data){
				$("#gridOROper").datagrid('clearChecked');
				$("#btnOper").linkbutton("disable");
				$("#btnCancle").linkbutton("disable");
			},
			onSelect: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==1) {
					$("#btnOper").linkbutton("enable");
					$("#btnCancle").linkbutton("enable");
				}				
			},
			onCheck: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==1) {
					$("#btnOper").linkbutton("enable");
					$("#btnCancle").linkbutton("enable");
				}				
			},
			onCheckAll: function (rows) {
				$("#btnOper").linkbutton("enable");
				$("#btnCancle").linkbutton("enable");					
			},
			onSelectAll: function (rows) {
				$("#btnOper").linkbutton("enable");
				$("#btnCancle").linkbutton("enable");					
			},
			onUnselect: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==0) {
					$("#btnOper").linkbutton("disable");
					$("#btnCancle").linkbutton("disable");
				}				
			},
			onUncheck: function (rowIndex, rowData) {
				var rows = $("#gridOROper").datagrid('getChecked');
				var len = rows.length;
				if (len==0) {
					$("#btnOper").linkbutton("disable");
					$("#btnCancle").linkbutton("disable");
				}				
			},
			onUncheckAll: function (rows) {
				$("#btnOper").linkbutton("disable");
				$("#btnCancle").linkbutton("disable");							
			},		
			onUnselectAll: function (rows) {
				$("#btnOper").linkbutton("disable");
				$("#btnCancle").linkbutton("disable");							
			}		
		});
	}
	
	
	$HUI.combobox("#cboOperType",{
		data:[
			{value:'I',text:'手术',selected:true},
			{value:'D',text:'操作'}
		],
		editable: false,
		valueField:'value',
		textField:'text'
	});
	$HUI.combobox("#cboKeyType",{
		data:[
			{value:'K',text:'手术名称',selected:true},
			{value:'I',text:'ICD-9-CM-3'}
		],
		editable: false,
		valueField:'value',
		textField:'text'
	});
	
	$HUI.combobox("#cboOperCat",{
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'OperCat',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=array&aIsActive=1";
			$("#cboOperCat").combobox('reload',url);
		}	
		,onSelect: function (rd) {
			var OperType =rd.OperType;
			$('#cboOperType').combobox('setValue',OperType);
			debugger
		}
	});

	
	$HUI.combobox("#cboOperCatMap",{
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'OperCat',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=array&aIsActive=1";
			$("#cboOperCatMap").combobox('reload',url);
		}	
	});
	

	InitOROperCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}