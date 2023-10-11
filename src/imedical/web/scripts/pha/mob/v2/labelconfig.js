/**
 * Desc:    贵重药标签维护
 * Creator: Huxt 2019-09-11
 * Js: 		scripts/pha/mob/v2/labelconfig.js
 * csp:		pha.in.v3.mob.labelconfig.csp
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
$(function () {
	InitDict();
	InitGridLabelInci();
	$('#btnFind').on("click", Query);
	// $('#btnClear').on("click", Clear);

	$('#btnAdd').on("click", Add);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);

	$('#inciText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			Query();
		}
	})
});

// 初始化 - 表单字典
function InitDict() {
	$('#type').combobox({
		valueField: 'RowId',
		textField: 'Description',
		placeholder: '类型...',
		panelHeight: 'auto',
		data: [{
				RowId: "OP",
				Description: "门诊"
			}, {
				RowId: "IP",
				Description: "住院"
			}
		],
		onSelect: function (record) {
			Query();
		},
		onChange: function (newValue, oldValue) {
			if (newValue == "") {
				Query();
			}
		}
	});

	InitHospCombo();
}

// 初始化表格
function InitGridLabelInci() {
	var columns = [
		[{
				field: 'pilc',
				title: 'pilc',
				width: 100,
				hidden: true
			}, {
				field: 'type',
				title: 'type',
				width: 100,
				sortable: 'true',
				align: 'center',
				hidden: true
			}, {
				field: 'typeDesc',
				title: '类型',
				width: 90,
				sortable: 'true',
				align: 'center'
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 200,
				sortable: 'true'
			}, {
				field: 'inci',
				title: '药品Id',
				width: 50,
				sortable: 'true',
				hidden: true
			}, {
				title: "药品名称",
				field: "inciDesc",
				descField: 'inciDesc',
				width: 300,
				align: "left",
				editor: GridEditors.inci,
				formatter: function (value, rowData, index) {
					return rowData.inciDesc;
				}
			}, {
				field: 'inciSpec',
				title: '规格',
				width: 120,
				sortable: 'true'
			}, {
				field: 'activeFlag',
				title: '是否激活',
				width: 90,
				sortable: 'true',
				align: 'center',
				editor: GridEditors.activeFlag,
				formatter: FormatterYes
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.LabelCfg.Query',
			QueryName: 'LabelConfig'
		},
		columns: columns,
		toolbar: "#gridLabelCfgBar",
		isAutoShowPanel: false,
		editFieldSort: ["inci", "activeFlag"],
		onClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridLabelCfg",
				index: index,
				field: field
			});
		}
	};
	PHA.Grid("gridLabelCfg", dataGridOption);
}

// 查询
function Query() {
	var type = $('#type').combobox('getValue') || "";
	var inciText = $("#inciText").val() || "";
	$('#gridLabelCfg').datagrid("load", {
		ClassName: 'PHA.MOB.LabelCfg.Query',
		QueryName: 'LabelConfig',
		QText: inciText,
		pJsonStr: JSON.stringify({
			type: type
		}),
		HospId: HospId
	});
}

// 清屏
function Clear() {
	$('#gridLabelCfg').datagrid("clear");
	$('#type').combobox('setValue', '');
	$('#inciText').val('');
}

// 新增
function Add() {
	var type = $('#type').combobox('getValue') || "";
	if (type == "") {
		$.messager.popover({
			msg: "请先选择类型!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var typeDesc = "";
	if (type == "OP") {
		typeDesc = "门诊";
	}
	if (type == "IP") {
		typeDesc = "住院";
	}
	// 添加新行
	$('#gridLabelCfg').datagrid('insertRow', {
		index: 0,
		row: {
			type: type,
			typeDesc: typeDesc,
			activeFlag: 'Y'
		}
	});

	// 开始编辑
	PHA_GridEditor.Edit({
		gridID: "gridLabelCfg",
		index: 0,
		field: 'inciDesc'
	});
}

// 保存
function Save() {
	$('#gridLabelCfg').datagrid('endEditing');
	var gridChanges = $('#gridLabelCfg').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("提示", "没有需要保存的数据", "warning");
		return;
	}
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridLabelCfg');
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// 验证重复
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridLabelCfg',
		fields: ['type', 'inci']
	});
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// 保存后台
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.LabelCfg.Save", "SaveMulti", pJsonStr, HospId);
	var saveArr = saveRet.split("^");
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		$.messager.alert("提示", saveInfo, "warning");
		return;
	}
	$.messager.popover({
		msg: "保存成功!",
		type: "success",
		timeout: 1000
	});
	Query();
}

// 删除
function Delete() {
	var gridSelect = $('#gridLabelCfg').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "请选择需要删除的记录!",
			type: "alert",
			timeout: 1000
		});
		return;
	}

	$.messager.confirm('确认对话框', '确定删除吗？', function (r) {
		if (r) {
			var pilc = gridSelect.pilc || "";
			if (pilc == "") {
				var rowIndex = $('#gridLabelCfg').datagrid('getRowIndex', gridSelect);
				$('#gridLabelCfg').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.LabelCfg.Save", "Delete", pilc);
				var delRetArr = delRet.split('^');
				if (delRetArr[0] < 0) {
					$.messager.alert("提示", delRetArr[1], (delRetArr[0] == "-1") ? "warning" : "error");
					return;
				}
				$.messager.popover({
					msg: "删除成功!",
					type: "success",
					timeout: 1000
				});
				Query();
			}
		}
	});
}

function FormatterYes(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// 药品
	inci: {
		type: 'combogrid',
		options: {
			regExp: /\S/,
			regTxt: '不能为空!',
			idField: 'incRowId',
			textField: 'incDesc',
			placeholder: '药品名称...',
			pagination: true,
			pageList: [10, 20, 50],
			pageSize: 10,
			width: 400,
			panelWidth: 600,
			mode: 'remote',
			columns: [[{
						field: 'incRowId',
						title: 'incItmRowId',
						width: 80,
						sortable: true,
						hidden: true
					}, {
						field: 'incCode',
						title: '药品代码',
						width: 100,
						sortable: true
					}, {
						field: 'incDesc',
						title: '药品名称',
						width: 360,
						sortable: true
					}, {
						field: 'incSpec',
						title: '规格',
						width: 100,
						sortable: true
					}
				]],
			url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=IncItm",
			onBeforeLoad: function (param) {
				param.q = param.q || "";
				if (param.q == "") {
					var gridSelect = $('#gridLabelCfg').datagrid("getSelected") || {};
					param.q = gridSelect.inciDesc;
				}
				param.QText = param.q;
				param.filterText = param.q;
				param.HospId = HospId;
			},
			onSelect: function (index, row) {
				// 更新选中的行
				var gridSelect = $('#gridLabelCfg').datagrid("getSelected");
				if (gridSelect == null) {
					return;
				}
				var rowIndex = $('#gridLabelCfg').datagrid('getRowIndex', gridSelect);
				// 延时 -- 否则报错???
				setTimeout(function () {
					$('#gridLabelCfg').datagrid('updateRow', {
						index: rowIndex,
						row: {
							inci: row.incRowId,
							inciCode: row.incCode,
							inciSpec: row.incSpec
						}
					});
				}, 500);
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	// 是否可用
	activeFlag: {
		type: 'icheckbox',
		options: {
			on: 'Y',
			off: 'N'
		}
	}
}

function InitHospCombo() {
	var genHospObj = PHA_COM.GenHospCombo({
		tableName: 'PHAIP_LabelConfig'
	});
	if (typeof genHospObj === 'object') {
		genHospObj.options().onSelect = function (index, record) {
			var newHospId = record.HOSPRowId;
			if (newHospId != HospId) {
				HospId = newHospId;
				Query();
			}
		}
		genHospObj.options().onLoadSuccess = function (data) {
			Query();
		}
	}
}
