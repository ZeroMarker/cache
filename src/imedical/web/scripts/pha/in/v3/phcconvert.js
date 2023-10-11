/**
 * 模块: 药库 - 草药颗粒剂与饮片转换维护
 * csp:  csp/pha.in.v3.phcconvert.csp
 * js:   scripts/pha/in/v3/phcconvert.js
 * Huxt 2023-02-07
 */
var HospId = session['LOGON.HOSPID'];
$(function () {
	InitHospCombo(); // 加载医院

	InitDict();
	InitEvent();
	InitGridPhcConvert();
});

/**
 * 初始化事件
 */
function InitEvent() {
	$('#btnFind').on('click', Query);
	$('#btnClear').on('click', Clear);

	$('#btnAdd').on('click', function () {
		BeforeEdit('add');
	});
	$('#btnUpdate').on('click', function () {
		BeforeEdit('update');
	});
	$('#btnDelete').on('click', Delete);
	$('#btnExport').on('click', Export);
	$('#btnImport').on('click', Import);
	$("#btn-transfer").linkbutton('enable');
}

/**
 * 初始化字典
 */
function InitDict() {
	// 定义类型Store
	var typeOpts = {
		url: PHA_STORE.Url + 'ClassName=PHA.IN.PhcConvert.Query&QueryName=CMPrescType',
		width: 240,
		onBeforeLoad: function (params) {
			params.pJsonStr = JSON.stringify({
				hospID: HospId
			})
		}
	}
	// 定义药学项Store
	var phcOpts = {
		url: PHA_STORE.Url + 'ClassName=PHA.IN.PhcConvert.Query&QueryName=PHCDrgMast',
		idField: 'phcId',
		textField: 'phcDesc',
		width: 240,
		panelWidth: 420,
		mode: 'remote',
		columns: [[{
					field: 'phcId',
					title: 'phcId',
					width: 100,
					hidden: true
				}, {
					field: 'phcCode',
					title: '代码',
					width: 120
				}, {
					field: 'phcDesc',
					title: '名称',
					width: 300
				}
			]
		],
		fitColumns: true
	}

	// 处方类型
	PHA.ComboBox('prescType', $.extend({}, typeOpts, {
		onSelect: function (rowData, rowIndex) {
			Query();
		}
	}));

	// 药学项下拉
	PHA.ComboGrid('phcId', $.extend({}, phcOpts, {
		onSelect: function (rowData, rowIndex) {
			Query();
		},
		onBeforeLoad: function (params) {
			var prescTypeId = $('#prescType').combobox('getValue') || '';
			params.pJsonStr = JSON.stringify({
				hospID: HospId,
				prescTypeId: prescTypeId,
				alias: params.q
			})
		}
	}));

	// 弹窗 - 类型
	PHA.ComboBox('fromType', $.extend({}, typeOpts,{
		onSelect: function (rowData, rowIndex) {
			$("#fromPhcId").combogrid("clear")
		}
	}));
	
	// 弹窗 - 药品
	PHA.ComboGrid('fromPhcId', $.extend({}, phcOpts, {
		onBeforeLoad: function (params) {
			var prescTypeId = $('#fromType').combobox('getValue') || '';
			params.pJsonStr = JSON.stringify({
				hospID: HospId,
				prescTypeId: prescTypeId,
				alias: params.q,
				phcId: params.phcId || '',
			})
		},
		onShowPanel: function(){
			var cmg = $.data(this, 'combogrid');
			if (cmg) {
				$(cmg.grid).datagrid('load', {
					q: '',
					phcId: ($('#fromPhcId').combogrid('getValue') || '')
				});
			}
		}
	}));
	
	// 弹窗 - 转换类型
	PHA.ComboBox('toType', $.extend({}, typeOpts,{
		onSelect: function (rowData, rowIndex) {
			$("#toPhcId").combogrid("clear")
		}
	}
	));
	
	// 弹窗 - 转换药品
	PHA.ComboGrid('toPhcId', $.extend({}, phcOpts, {
		onBeforeLoad: function (params) {
			var prescTypeId = $('#toType').combobox('getValue') || '';
			params.pJsonStr = JSON.stringify({
				hospID: HospId,
				prescTypeId: prescTypeId,
				alias: params.q,
				phcId: params.phcId || '',
			})
		},
		onShowPanel: function() {
			var cmg = $.data(this, 'combogrid');
			if (cmg) {
				$(cmg.grid).datagrid('load', {
					q: '',
					phcId: ($('#toPhcId').combogrid('getValue') || '')
				});
			}
		}
	}));
}

/**
 * 初始化表格
 */
function InitGridPhcConvert() {
	var columns = [[{
				field: 'pcId',
				title: 'pcId',
				width: 100,
				hidden: true
			}, {
				field: 'fromTypeDesc',
				title: '类型',
				width: 100
			}, {
				field: 'fromPhcCode',
				title: '药品代码',
				width: 120
			}, {
				field: 'fromPhcDesc',
				title: '药品名称',
				width: 300
			}, {
				field: 'fromNum',
				title: '数量',
				width: 100,
				align: 'right'
			}, {
				field: 'toTypeDesc',
				title: '转换类型',
				width: 100
			}, {
				field: 'toPhcCode',
				title: '转换药品代码',
				width: 120
			}, {
				field: 'toPhcDesc',
				title: '转换药品名称',
				width: 300
			}, {
				field: 'toNum',
				title: '转换数量',
				align: 'right',
				width: 100
			}
		]
	];
	var gridOptions = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.PhcConvert.Query',
			QueryName: 'PhcConvert',
			pJsonStr: JSON.stringify({
				hospID: HospId
			})
		},
		toolbar: '#gridPhcConvertBar',
		columns: columns,
		rownumbers: false,
		singleSelect: true,
		onDblClickRow: function (rowIndex, rowData) {
			BeforeEdit('update');
		},
		onSelect: function (rowIndex, rowData) {
			$(this).datagrid('options').seletedIndex = rowIndex;
		},
		onLoadSuccess: function(data) {
			if (data && data.total > 0) {
				var seletedIndex = $(this).datagrid('options').seletedIndex;
				if (seletedIndex >= 0) {
					$(this).datagrid('selectRow', seletedIndex);
				} else {
					$(this).datagrid('selectRow', 0);
				}
			}
		}
	}
	PHA.Grid('gridPhcConvert', gridOptions);
}

/**
 * 查询表格
 */
function Query() {
	var prescType = $('#prescType').combobox('getValue') || '';
	var phcId = $('#phcId').combobox('getValue') || '';
	$('#gridPhcConvert').datagrid('query', {
		ClassName: 'PHA.IN.PhcConvert.Query',
		QueryName: 'PhcConvert',
		pJsonStr: JSON.stringify({
			hospID: HospId,
			prescType: prescType,
			phcId: phcId,
			pcId: ''
		})
	});
}

/**
 * 维护弹出框
 */
function BeforeEdit(action) {
	if (action == 'update') {
		var seletctedRow = $('#gridPhcConvert').datagrid('getSelected');
		if (seletctedRow == null) {
			PHA.Popover({
				type: 'alert',
				msg: '请选择需要修改的行'
			});
			return;
		}
	}

	EditShow({
		title: $g('草药处方类型转换系数') + (action == 'update' ? $g('修改') : $g('增加')),
		iconCls: action == 'update' ? 'icon-w-edit' : 'icon-w-add',
		action: action
	});
}

/**
 * 编辑弹窗
 */
function EditShow(_options) {
	$('#maintainWin').dialog($.extend({}, {
		title: '维护',
		width: 715,
		// height: 200,
		modal: true,
		closed: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		onBeforeClose: function () {
			ClearWin();
		},
		buttons: [
			{
				text: '保存',
				handler: function () {
					Save();
				}
			}, {
				text: '关闭',
				handler: function () {
					$('#maintainWin').dialog('close');
				}
			}
		]
	}, _options)).dialog('open');

	if (_options.action == 'update') {
		var gridSelected = $('#gridPhcConvert').datagrid('getSelected');
		var pcId = gridSelected.pcId;

		$.cm({
			ClassName: 'PHA.IN.PhcConvert.Query',
			QueryName: 'PhcConvert',
			pJsonStr: JSON.stringify({
				hospID: HospId,
				pcId: pcId
			}),
			ResultSetType: 'Array'
		}, function (retJson) {
			retJson[0].fromPhcId = {
				phcId: retJson[0].fromPhcId,
				phcDesc: retJson[0].fromPhcDesc
			}
			retJson[0].toPhcId = {
				phcId: retJson[0].toPhcId,
				phcDesc: retJson[0].toPhcDesc
			}
			PHA.SetVals(retJson);
		});
	} else {
		ClearWin();
	}
}

/**
 * 保存内容
 */
function Save() {
	// 获取参数
	var selectedRow = $('#gridPhcConvert').datagrid('getSelected');
	var pcId = '';
	if ($('#maintainWin').dialog('options').action == 'update') {
		pcId = selectedRow.pcId;
	} else {
		pcId = '';
	}
	var pJsonArr = PHA.GetVals([
		'fromType',
		'fromPhcId',
		'fromNum',
		'toType',
		'toPhcId',
		'toNum'
	], 'Json');
	if (!pJsonArr || pJsonArr.length == 0) {
		return;
	}
	var pJson = pJsonArr[0];
	pJson.hospID = HospId;
	pJson.pcId = pcId;

	// 验证参数
	if (parseFloat(pJson.fromNum) <= 0) {
		PHA.Popover({
			type: 'alert',
			msg: '数量不能小于或等于0'
		});
		return;
	}
	if (parseFloat(pJson.toNum) <= 0) {
		PHA.Popover({
			type: 'alert',
			msg: '转换数量不能小于或等于0'
		});
		return;
	}
	if (pJson.fromPhcId == $('#fromPhcId').combogrid('getText')) {
		PHA.Popover({
			type: 'alert',
			msg: '请选择药品'
		});
		return;
	}
	if (pJson.toPhcId == $('#toPhcId').combogrid('getText')) {
		PHA.Popover({
			type: 'alert',
			msg: '请选择转换药品'
		});
		return;
	}

	// 保存数据
	$.m({
		ClassName: 'PHA.IN.PhcConvert.Save',
		MethodName: 'SavePhcConvert',
		pJsonStr: JSON.stringify(pJson),
		hospID: HospId
	}, function (retStr) {
		var retArr = retStr.split('^');
		if (retArr[0] > 0) {
			PHA.Popover({
				type: 'success',
				msg: '保存成功'
			});
			$('#maintainWin').dialog('close');
			Query();
		} else {
			PHA.Alert('温馨提示', '保存失败: ' + retStr, 'error');
		}
	});
}

/**
 * 删除
 */
function Delete() {
	var seletctedRow = $('#gridPhcConvert').datagrid('getSelected');
	if (seletctedRow == null) {
		PHA.Popover({
			type: 'alert',
			msg: '请选择需要删除的行'
		});
		return;
	}
	PHA.Confirm('温馨提示', '您确认删除吗?', function () {
		var pcId = seletctedRow.pcId;
		$.m({
			ClassName: 'PHA.IN.PhcConvert.Save',
			MethodName: 'DeleteDHCPhcConvert',
			pcId: pcId,
			hospID: HospId
		}, function (retText) {
			if (retText == 0) {
				PHA.Popover({
					type: 'success',
					msg: '删除成功'
				});
				Query();
			} else {
				PHA.Alert('温馨提示', '删除失败', 'error');
			}
		});
	});
}

/**
 * 清屏
 */
function Clear() {
	PHA.ClearVals([
		'prescType',
		'phcId'
	]);
	Query();
}
function ClearWin() {
	PHA.ClearVals([
		'fromType',
		'fromPhcId',
		'fromNum',
		'toType',
		'toPhcId',
		'toNum'
	]);
}

/**
 * 导出
 */
function Export(){
	PHA_COM.ExportGrid('gridPhcConvert');
}

/**
 * 导入
 */
function Import(){
	PHA_COM.ImportFile({
		suffixReg: /^(.xls)|(.xlsx)$/
	}, function(data){
		console.log(data);
	});
}

/**
 * 多院区
 */
function InitHospCombo() {
	var genHospObj = PHA_COM.GenHospCombo({
		tableName: 'DHC_PhcConvert'
	});
	if (typeof genHospObj === 'object') {
		$('#_HospList').combogrid('options').onSelect = function (index, record) {
			NewHospId = record.HOSPRowId;
			if (NewHospId != HospId) {
				HospId = NewHospId;
				Clear();
				ClearWin();
				Query();
				InitDict();
			}
		};
	}
}
