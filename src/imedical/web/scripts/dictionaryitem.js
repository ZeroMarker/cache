<!--js dictionaryitem.js-->
<!--入口函数-->
$(function() {
	setPageLayout();
});
function setPageLayout() {
	initdicconfigCombo();
	SetDicInfoItem();
	DeleteDic();
	UpdateData();
	ClearData();

	///功能说明：导入字典信息
	$('#ImportBtn').click(function() {
		var GlobalDataFlg = "0"; //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName = "BILL.CFG.COM.DictionaryCtl"; //导入处理类名
		var MethodName = "ImportDicdataByExcel"; //导入处理方法名
		var ExtStrPam = ""; //备用参数()
		//Insuqc_ExcelTool.ExcelImport(ClassName,MethodName,"0",ExtStrPam,UserDr,2,SetDicInfoItem());
		ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,SetDicInfoItem);		
	});
}

function DeleteDic() {
	$('#DeleteBtn').click(function() {
		removeDic();
	});
}
function UpdateData() {
	$('#UpdateBtn').click(function() {
		updateData();
	});
}
function ClearData() {
	$('#clearBtn').click(function() {
		$('#DicCode').val("");
		$('#DicDesc').val("");
		$('#DefaultValue').val("");
		$("#StartDate").datebox("setValue", "");
		$("#EndDate").datebox("setValue", "");
		$('#EndDate').val("");
		$('#Creator').val("");
		$('#DicMemo').val("");
		$('#DataSrcFilterMode').val("");	//数据源检索模式
		$('#DataSrcTableProperty').val("");	//数据源表名及字段名
		$('#DicList').datagrid('unselectAll');	//清除选择
	});
}
//业务类型下拉框
//业务类型下拉框
function initdicconfigCombo() {
	$HUI.combobox("#DicType", {
		valueField: 'DicCode',
		textField: 'DicDesc',
		url: $URL,
		onBeforeLoad: function(param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = 'QueryDetComboxInfo';

			param.ResultSetType = 'Array';
			$("#DicType").combobox('setValue', "SYS");
		},
		onChange: function() {
			SetDicInfoItem();
			$('#DicCode').val("");
			$('#DicDesc').val("");
			$('#DefaultValue').val("");
			$("#StartDate").datebox("setValue", "");
			$('#EndDate').datebox("setValue", "");
			$('#Creator').val("");
			$('#DicMemo').val("");
			$('#DataSrcFilterMode').val("");	//数据源检索模式
			$('#DataSrcTableProperty').val("");	//数据源表名及字段名
		}

	})

};
//字典明细信息列表
function SetDicInfoItem() {
	var DicType = $('#DicType').combobox('getValue');
	$('#DicList').datagrid({
		pagination: true,
		// 分页工具栏
		pageSize: 10,
		pageList: [10,20,50,100],
		singleSelect: true,
		striped: true,	// 显示斑马线效果
		fitColumns:true,
		height: 400,
		rownumbers: true,
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			QueryName: "QueryDicDataInfo",
			Type: DicType
		},
		columns: [[{
			field: 'ID',
			title: 'ID',
			hidden: true
		},
		{
			field: 'DicType',
			title: '字典类型',
			width: 150
		},
		{
			field: 'DicCode',
			title: '字典编码',
			width: 150
		},
		{
			field: 'DicDesc',
			title: '字典描述',
			width: 150
		},
		{
			field: 'DefaultValue',
			title: '默认值',
			width: 100
		},
		{
			field: 'StartDate',
			title: '开始日期',
			width: 100
		},
		{
			field: 'DateTo',
			title: '结束日期',
			width: 100
		},
		{
			field: 'Creator',
			title: '创建人',
			width: 100
		},
		{
			field: 'DicMemo',
			title: '备注',
			width: 100
		},
		{
			field: 'DataSrcFilterMode',
			title: '数据源检索模式',
			width: 100
		},
		{
			field: 'DataSrcTableProperty',
			title: '数据源表名及字段名',
			width: 100
		}
		]],
		onClickRow: function(rowIndex, rowData) {

			var selected = $('#DicList').datagrid('getSelected');
			if (selected) {
				SetEditAreaVaule(selected);
			} else {
				ClearEditeForm();
			}

		}
	});
}
//将选中的数据信息添加到字框架中		
function SetEditAreaVaule(data) {
	$("#DicType").combobox('setValue', data.DicType);
	$('#DicCode').val(data.DicCode);
	$('#DicDesc').val(data.DicDesc);
	$('#DefaultValue').val(data.DefaultValue);
	$("#StartDate").datebox("setValue", data.StartDate);
	$("#EndDate").datebox("setValue", data.DateTo);
	$('#Creator').val(data.Creator);
	$('#DicMemo').val(data.DicMemo);
	$('#DataSrcFilterMode').val(data.DataSrcFilterMode);	//数据源检索模式
	$('#DataSrcTableProperty').val(data.DataSrcTableProperty);	//数据源表名及字段名
}
function ClearEditeForm(data) {
	$("#DicType").combobox('setValue', data.DicType);
	$('#DicCode').val("");
	$('#DicDesc').val("");
	$('#DefaultValue').val("");
	$("#StartDate").datebox("setValue", "");
	$("#EndDate").datebox("setValue", "");
	$('#Creator').val("");
	$('#DicMemo').val("");
	$('#DataSrcFilterMode').val("");	//数据源检索模式
	$('#DataSrcTableProperty').val("");	//数据源表名及字段名
}

//删除
function removeDic() {
	var selectedRow = $('#DicList').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('消息', '请选择需要删除的行');
		return;
	}
	$.messager.confirm('消息', '您确定要删除该条记录吗?',
	function(r) {
		if (!r) {
			return;
		}
		var ID = selectedRow.ID;
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "DeleteDicDataInfo",
			ID: ID
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('消息', value);
				ClearEditeForm(selectedRow);
				SetDicInfoItem();
				if ($('#DicType').combobox('getValue') == "SYS"){
					$('#DicType').combobox('reload');
				}
				return;
			}
		});
	});
	
}

//更新
function updateData() {
	var DicCode = $('#DicCode').val(); //字典编码
	if ($.trim(DicCode) == "") {
		$.messager.alert('提示信息', "字典编码不能为空！");
		return;
	}
	var selectedRow = $('#DicList').datagrid('getSelected');
	if ((!selectedRow) || (selectedRow.ID == undefined)) {
		var DataStr = $('#DicType').combobox('getValue') + "^" + $('#DicCode').val() + "^" + $("#DicDesc").val() + "^" + $("#DefaultValue").val() + "^" + $("#StartDate").datebox("getValue") + "^" + $("#EndDate").datebox("getValue") + "^" + $("#Creator").val() + "^" + $("#DicMemo").val()+ "^" + $("#DataSrcFilterMode").val()+ "^" + $("#DataSrcTableProperty").val();
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "SaveDicdataInfo",
			DataStr: DataStr
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('消息', value);
				var data={DicType:$('#DicType').combobox('getValue')}
				ClearEditeForm(data);
				SetDicInfoItem();
				if ($('#DicType').combobox('getValue') == "SYS"){
					$('#DicType').combobox('reload');
				}
				return;
			}
		});

	} else {
		var ID = selectedRow.ID;
		var DataStr = ID + "^" + $('#DicType').combobox('getValue') + "^" + $('#DicCode').val() + "^" + $("#DicDesc").val() + "^" + $("#DefaultValue").val() + "^" + $("#StartDate").datebox("getValue") + "^" + $("#EndDate").datebox("getValue") + "^" + $("#Creator").val() + "^" + $("#DicMemo").val()+ "^" + $("#DataSrcFilterMode").val()+ "^" + $("#DataSrcTableProperty").val();
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "UpdateDicDataInfo",
			DataStr: DataStr
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('消息', value);
				ClearEditeForm(selectedRow);
				SetDicInfoItem();
				if ($('#DicType').combobox('getValue') == "SYS"){
					$('#DicType').combobox('reload');
				}
				return;
			}
		});
	}
}
