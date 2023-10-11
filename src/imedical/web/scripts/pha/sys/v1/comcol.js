/**
 * description: 前台参数设置 - 通用列维护
 * creator:     Huxt 2021-08-01
 * csp:         pha.sys.v1.comcol.csp
 * js:          pha/sys/v1/comcol.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('系统管理');
PHA_COM.App.Csp = 'pha.sys.v1.comcol.csp';
PHA_COM.App.Name = $g('通用列维护');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_GridEditor.AutoUpd = true;

$(function () {
	if (PHA_COM.IsTabsMenu()){
		$('#panelMain').panel({
			title: '',
			iconCls: 'icon-set-col',
			headerCls: 'panel-header-gray',
			fit: true
		});
	}
	
	InitDict();
	InitGridComCol();
	InitEvents();
	
	Query();
});

// 初始化 - 事件
function InitEvents() {
	// 按钮
	$('#btnRefresh').on('click', Query);
	$('#btnAdd').on('click', Add);
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#btnMoveUp').on('click', UpAndDown);
	$('#btnMoveDown').on('click', UpAndDown);
	$('#btnHelp').on('click', ShowHelp);
}

// 初始化 - 表单
function InitDict() {
	InitDictVal();
}
function InitDictVal(){
}

// 初始化 - 表格
function InitGridComCol() {
	var columns = [[{
				field: 'ColId',
				title: 'ColId',
				hidden: true,
				width: 100
			}, {
				field: 'ColTableName',
				title: 'ColTableName',
				hidden: true,
				width: 100
			}, {
				field: 'ColPointer',
				title: 'ColPointer',
				hidden: true,
				width: 100
			}, {
				field: 'ColSort',
				title: '列顺序',
				hidden: true,
				width: 70,
				align: 'center'
			}, {
				field: 'ColField',
				title: '字段',
				width: 110,
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'ColTitle',
				title: '名称',
				width: 110,
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'ColWidth',
				title: '宽度',
				width: 70,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
					checkValue: function(val, chkRet){
						if (!val) {
							return true;
						}
						if (isNaN(val)) {
							chkRet.msg = '请输入数字';
							return false;
						}
						val = parseFloat(val);
						if (val <= 20) {
							chkRet.msg = '请输入大于20的数字';
							return false;
						}
						return true;
					}
				})
			}, {
				field: 'ColAlign',
				title: '对齐',
				width: 88,
				align: 'left',
				editor: PHA_GridEditor.ComboBox({
					panelHeight: 'auto',
					data: [{
							RowId: 'left',
							Description: 'left'
						}, {
							RowId: 'center',
							Description: 'center'
						}, {
							RowId: 'right',
							Description: 'right'
						}
					]
				})
			}, {
				field: 'ColTipWidth',
				title: '提示宽度',
				width: 70,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'ColValExp',
				title: '取值表达式',
				width: 300,
				rowHeight: 28,
				editor: PHA_GridEditor.ComboGrid({
					url: $URL + '?ResultSetType=Json&ClassName=PHA.SYS.Col.Query&QueryName=ValExp',
					panelWidth: 500,
					fitColumns: true,
					idField: 'RowId',
					textField: 'RowId',
					pageSize: 30,
					qLen: 0,
					columns: [[{
							field: 'RowId',
							title: '表达式',
							width: 150,
						}, {
							field: 'Description',
							title: '表达式描述',
							width: 100,
						}
					]],
					onBeforeNext: function(cmbRowData, gridRowData, gridRowIndex){
						gridRowData.ColValExpDesc = cmbRowData.Description;
					}
				})
			}, {
				field: 'ColValExpDesc',
				title: '取值表达式描述',
				width: 160
			}, {
				field: 'ColValConvert',
				title: '值转换表达式',
				width: 140,
				editor: PHA_GridEditor.ComboGrid({
					url: $URL + '?ResultSetType=Json&ClassName=PHA.SYS.Col.Query&QueryName=ValConvert',
					panelWidth: 410,
					fitColumns: true,
					idField: 'RowId',
					textField: 'RowId',
					pageSize: 30,
					qLen: 0,
					columns: [[{
							field: 'RowId',
							title: '表达式',
							width: 100,
						}, {
							field: 'Description',
							title: '表达式描述',
							width: 150,
						}
					]],
					onBeforeNext: function(cmbRowData, gridRowData, gridRowIndex){
						gridRowData.ColValConvertDesc = cmbRowData.Description;
					}
				})
			}, {
				field: 'ColValConvertDesc',
				title: '值转换表达式描述',
				width: 160
			}, {
				field: 'ColSortable',
				title: '排序',
				width: 60,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColHidden',
				title: '隐藏',
				width: 60,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColIfExport',
				title: '导出',
				width: 60,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColIsCheckbox',
				title: '勾选框',
				width: 62,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColFrozen',
				title: '列冻结',
				width: 62,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColFixed',
				title: '列宽固定',
				width: 70,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Col.Query',
			QueryName: 'PHAINCol'
		},
		fitColumns: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		gridSave: true,
		isCellEdit: true,
		editFieldSort: ['ColField', 'ColTitle', 'ColWidth', 'ColAlign', 'ColTipWidth', 'ColValExp', 'ColValConvert'],
		toolbar: '#gridComColBar',
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function(data){
			$('#btnMoveUp').prop('disabled', '');
			$('#btnMoveDown').prop('disabled', '');
			var selectedRowIndex = $(this).datagrid('options').selectedRowIndex;
			if (selectedRowIndex >= 0 && data.total > selectedRowIndex) {
				$(this).datagrid('selectRow', selectedRowIndex);
			}
		},
		onClickCell: function(index, field, value){
			PHA_GridEditor.Edit({
				gridID: 'gridComCol',
				index: index,
				field: field
			});
		}
	};
	PHA.Grid('gridComCol', dgOptions);
}

// 查询
function Query() {
	var comColStr = GetCOMColStr();
	$('#gridComCol').datagrid('options').url = $URL;
	$('#gridComCol').datagrid('load', {
		ClassName: 'PHA.SYS.Col.Query',
		QueryName: 'PHAINCol',
		inputStr: comColStr,
		includeAllFlag: ''
	});
}

// 新增
function Add(){
	var comColStr = GetCOMColStr();
	var comColArr = comColStr.split('^');
	PHA_GridEditor.Add({
		gridID: 'gridComCol',
		field: 'ColField',
		rowData: {
			ColId: '',
			ColTableName: comColArr[0],
			ColPointer: comColArr[1],
			ColSort: 'N',
			ColField: '',
			ColTitle: '',
			ColWidth: 100,
			ColAlign: 'left',
			ColTipWidth: '',
			ColValExp: '',
			ColValExpDesc: '',
			ColValConvert: '',
			ColValConvertDesc: '',
			ColSortable: 'N',
			ColHidden: 'N',
			ColIfExport: 'Y',
			ColIsCheckbox: 'N',
			ColFrozen: 'N',
			ColFixed: 'N'
		},
		checkRow: true
	});
}

// 保存
function Save(){
	PHA_GridEditor.End('gridComCol');
	var rowsData = $('#gridComCol').datagrid('getRows');
	if ((rowsData == null || rowsData.length == 0)) {
		PHA.Popover({
			msg: "没有需要保存的数据!",
			type: "alert"
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridComCol',
		fields: ['ColField']
	});
	if (chkRetStr != '') {
		PHA.Popover({
			msg: '字段' + ':' + chkRetStr,
			type: 'alert'
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridComCol');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	
	var jsonColStr = JSON.stringify(rowsData);
	var jsonCol = JSON.parse(jsonColStr);
	for (var i = 0; i < jsonCol.length; i++) {
		var iCol = jsonCol[i];
		if (iCol.ColValConvert && iCol.ColValConvert != '') {
			iCol.ColValExp = iCol.ColValExp + '-' + iCol.ColValConvert;
		}
	}
	jsonColStr = JSON.stringify(jsonCol);
	
	var retText = tkMakeServerCall('PHA.SYS.Col.Save', 'SaveForPIPIS', jsonColStr);
	var retArr = retText.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: "保存成功!",
		type: "success"
	});
	Query();
}

// 删除行
function Delete() {
	var gridSelect = $('#gridComCol').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择要删除的列",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var colId = gridSelect.ColId || '';
	PHA.Confirm("温馨提示", '是否确认删除该列？', function () {
		if (colId == '') {
			var rowIndex = $('#gridComCol').datagrid('getRowIndex', gridSelect);
			$('#gridComCol').datagrid('deleteRow', rowIndex);
			return;
		}
		
		var saveRet = $.cm({
			ClassName: 'PHA.SYS.Col.Save',
			MethodName: 'Delete',
			Id: colId,
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('温馨提示', saveInfo, saveVal);
			return;
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: 'success'
			});
			Query();
		}
	});
}

// 上下移动
function UpAndDown(e){
	PHA_GridEditor.End('gridComCol');
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridComCol',
		fields: ['ColField']
	});
	if (chkRetStr != '') {
		PHA.Popover({
			msg: '字段' + ':' + chkRetStr,
			type: 'alert'
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridComCol');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	
	var ret = PHA_GridEditor.__UpAndDown_Exchange({
		gridID: 'gridComCol',
		ifUp: (e.currentTarget.id.indexOf('Up') > 0 ? true : false)
	});
	if (!ret) {
		return;
	}
	var selectedRow = $('#gridComCol').datagrid('getSelected') || {};
	var selectedRowIndex = $('#gridComCol').datagrid('getRowIndex', selectedRow);
	$('#gridComCol').datagrid('options').selectedRowIndex = selectedRowIndex;
	
	$('#btnMoveUp').prop('disabled', 'disabled');
	$('#btnMoveDown').prop('disabled', 'disabled');
	var rowsData = $('#gridComCol').datagrid('getRows');
	var jsonColStr = JSON.stringify(rowsData);
	var saveRet = tkMakeServerCall('PHA.SYS.Col.Save', 'SaveForPIPIS', jsonColStr);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('温馨提示', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: '操作成功!',
			type: 'success'
		});
		Query();
	}
}

// 获取字符串
function GetCOMColStr(){
	if (PHA_COM.VAR.COMColStr) {
		return PHA_COM.VAR.COMColStr;
	}
	PHA_COM.VAR.COMColStr = tkMakeServerCall('PHA.SYS.Col.Query', 'GetCOMColStr');
	return PHA_COM.VAR.COMColStr;
}

// 帮助弹窗
function ShowHelp(){
	/* 帮助弹窗 */
	var winId = "comcol_help_win";
	var winContentId = winId + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 650,
			height: 480,
			modal: true,
			title: '通用列维护帮助',
			iconCls: 'icon-w-list',
			content: "<div id='" + winContentId + "'style='margin:10px;'></div>",
			closable: true
		});
		$('#' + winContentId).html(GetInitHtml());
	}
	$('#' + winId).dialog('open');
	
	/* 帮助内容 */
	function GetInitHtml(){
		var helpHtml = '';
		helpHtml += GetItemTitle('通用列');
		helpHtml += GetItemContent('通用列是指可以在各界面每个表格都显示的列，开发人员不要再单独到每个界面添加列信息。');
		helpHtml += GetItemTitle('通用列的维护');
		helpHtml += GetItemContent('通用列信息的维护主要包含字段和字段的取值。');
		helpHtml += GetItemTitle('后台查询调用');
		helpHtml += GetItemContent('维护好通用列信息之后，需要在对应的方法中调用一个通用的取值方法，才能根据取值表达式取值。通用的取值方法如下：');
		helpHtml += GetItemContent('s colVals = ##class(PHA.SYS.Col.Value).%New()');
		helpHtml += GetItemContent('s colVals.inci = inci');
		helpHtml += GetItemContent('s colVals.arcim = arcim');
		helpHtml += GetItemContent('s colVals...');
		helpHtml += GetItemContent('s rowData = colVals.GetRowJson(.outVal)');
		helpHtml += GetItemTitle('通用列的显示');
		helpHtml += GetItemContent('维护好通用列，并且在后台调用对应的取值方法之后，如果有界面上的某个表格需要显示这些列，则可以在【列设置弹窗】勾选显示通用列或者在【页面设置】界面设置显示通用列。');
		return helpHtml;
	}
	function GetItemTitle(title){
		return '<div style="margin-top:10px;"><b>' + trans(title) + '：</b></div>';
	}
	function GetItemContent(content){
		return '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + trans(content) + '</p>';
	}
	function trans(val){
		try {
			return $g(val);
		} catch(ex){
			return val;
		}
	}
}