/**
 * Desc:    用户/科室/安全组关联处方配药类型 维护
 * Creator: Huxt 2019-09-11
 * csp:		pha.in.v3.mob.presctypesort.csp
 * js:		scripts/pha/mob/v2/presctypesort.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	InitDict();
	InitGridPrescType();
	InitGridPrescTypeSort();

	$('#btnFind').on("click", Query);
	$('#btnAdd').on("click", Add);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);
	$('#btnAddItm').on("click", AddItm);
	$('#btnSaveItm').on("click", SaveItm);
	$('#btnDeleteItm').on("click", DeleteItm);
});

// 初始化 - 表单字典
function InitDict(){
	PHA.ComboBox('type', {
		placeholder: '关联类型...',
		url: $URL + '?ClassName=PHA.MOB.Dictionary&QueryName=TypeList&ResultSetType=array',
		panelHeight: 'auto',
		onSelect: function(record){
			Query();
		},
		onChange: function(newValue, oldValue){
			if (newValue == "") {
				Query();
			}
		}
	});
	$('#QText').on('keydown', function(e){
		if (e.keyCode == 13) {
			Query();
		}
	});
}

// 初始化 - 表格
function InitGridPrescType() {
	var columns = [
		[{
				field: "pipc",
				title: 'pipc',
				align: 'center',
				width: 100,
				hidden: true
			}, {
				field: "type",
				title: 'type',
				align: 'center',
				width: 100,
				hidden: false
			}, {
				field: 'typeDesc',
				title: '关联类型',
				width: 150,
				sortable: 'true'
			}, {
				field: 'pointer',
				descField: 'pointerDesc',
				title: '关联指向',
				width: 250,
				sortable: 'true',
				editor: GridEditors.pointer,
				formatter: function (value, row, index) {
					return row.pointerDesc
				}
			}, {
				field: 'herbPrescTypeId', // 该字段指向表: PHAHERB_PresType
				descField: 'herbPrescTypeDesc',
				title: '可配类型(描述)',
				width: 150,
				sortable: 'true',
				editor: GridEditors.herbPrescTypeId,
				formatter: function (value, row, index) {
					return row.herbPrescTypeDesc;
				}
			}, {
				field: 'OPFlag',
				title: '门诊处方',
				width: 80,
				sortable: 'true',
				align: 'center',
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: FormatterYes
			}, {
				field: 'IPFlag',
				title: '住院处方',
				width: 80,
				sortable: 'true',
				align: 'center',
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: FormatterYes
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescSort.Query',
			QueryName: 'PrescConfig',
			pJsonStr: JSON.stringify({
				hospId: session['LOGON.HOSPID']
			})
		},
		fitColumns: true,
		columns: columns,
		toolbar: "#gridPrescTypeBar",
		isAutoShowPanel: false,
		editFieldSort: ["pointer", "herbPrescTypeId", "OPFlag", "IPFlag"],
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPrescType",
				index: index,
				field: field
			});
		},
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
			QueryItm();
		}
	};
	PHA.Grid("gridPrescType", dataGridOption);
}

// 初始化 - 子表格
function InitGridPrescTypeSort() {
	var columns = [
		[{
				field: "pipc",
				title: 'pipc',
				width: 100,
				hidden: true
			},{
				field: "pipci",
				title: 'pipci',
				width: 100,
				hidden: true
			}, {
				field: 'OPIP',
				descField: 'OPIPDesc',
				title: '门诊/住院',
				width: 100,
				sortable: 'true',
				editor: GridEditors.OPIP,
				formatter: function (value, row, index) {
					return row.OPIPDesc
				}
			}, {
				field: 'prescTypeId',
				descField: 'prescTypeDesc',
				title: '处方类型',
				width: 150,
				sortable: 'true',
				editor: GridEditors.prescTypeId,
				formatter: function (value, row, index) {
					return row.prescTypeDesc
				}
			}, {
				field: 'sortNum',
				title: '排序码',
				width: 100,
				sortable: 'true',
				align: 'center',
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},

		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescSort.Query',
			QueryName: 'PrescConfigItm'
		},
		columns: columns,
		toolbar: "#gridPrescTypeSortBar",
		isAutoShowPanel: false,
		editFieldSort: ["OPIP", "prescTypeId", "sortNum"],
		onClickRow: function (rowIndex, rowData) {},
		onDblClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPrescTypeSort",
				index: index,
				field: field
			});
		},
		onClickCell: function (index, field, value) {
			$(this).datagrid('endEditing');
		}
	};
	PHA.Grid("gridPrescTypeSort", dataGridOption);
}

// 查询
function Query() {
	var type = $('#type').combobox('getValue');
	var QText = $('#QText').val();
	$('#gridPrescType').datagrid("load", {
		ClassName: 'PHA.MOB.PrescSort.Query',
		QueryName: 'PrescConfig',
		QText: QText,
		pJsonStr: JSON.stringify({
			type: type,
			hospId: session['LOGON.HOSPID']
		}),
	});
	$('#gridPrescTypeSort').datagrid("clear");
}

// 新增
function Add() {
	// 类型
	var seltype = $('#type').combobox('getValue') || "";
	var typeDesc = $('#type').combobox('getText') || "";
	if (seltype == "" || typeDesc == "") {
		$.messager.popover({
			msg: '请先选择*关联类型！',
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// 添加行
	PHA_GridEditor.Add({
		gridID: 'gridPrescType',
		field: 'pointer',
		rowData: {
			type: seltype,
			typeDesc: typeDesc
		}
	});
}

// 保存
function Save() {
	$('#gridPrescType').datagrid('endEditing');
	var gridChanges = $('#gridPrescType').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("提示", "没有需要保存的数据", "warning");
		return;
	}
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridPrescType');
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
		gridID: 'gridPrescType',
		fields: ['type', 'pointer']
	});
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.PrescSort.Save", "SaveMulti", pJsonStr);
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
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("提示", "请选择需要删除的记录!", "warning");
		return;
	}
	$.messager.confirm('确认对话框', '确定删除吗？', function (r) {
		if (r) {
			var pipc = gridSelect.pipc || "";
			if (pipc == "") {
				var rowIndex = $('#gridPrescType').datagrid('getRowIndex', gridSelect);
				$('#gridPrescType').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.PrescSort.Save", "Delete", pipc);
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
	})
}

// 查询 - 明细
function QueryItm() {
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		return;
	}
	var pipc = gridSelect.pipc || "";
	$('#gridPrescTypeSort').datagrid("reload", {
		ClassName: 'PHA.MOB.PrescSort.Query',
		QueryName: 'PrescConfigItm',
		QText: '',
		pJsonStr: JSON.stringify({
			pipc: pipc
		})
	});
}

// 新增 - 明细
function AddItm() {
	// 是否选中主表
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: '请先选择左侧表格的一条数据！',
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pipc = gridSelect.pipc || "";
	if (pipc == "") {
		$.messager.popover({
			msg: '请先选择左侧表格选中的数据！',
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// 获取默认类型
	var OPIPArr = [], OPIPDescArr = [];
	var OPFlag = gridSelect.OPFlag || "N";
	var IPFlag = gridSelect.IPFlag || "N";
	if ((OPFlag == "Y")&&(IPFlag != "Y")) {
		OPIPArr.push("OP");
		OPIPDescArr.push("门诊");
	}
	if ((IPFlag == "Y")&&(OPFlag != "Y")) {
		OPIPArr.push("IP");
		OPIPDescArr.push("住院");
	}
	// 获取最大顺序号
	var maxSortNum = 0;
	var rowsData = $('#gridPrescTypeSort').datagrid('getRows');
	for (var r = 0; r < rowsData.length; r++) {
		var rData = rowsData[r];
		var sortNum = rData.sortNum || "";
		if (sortNum == "") {
			continue;
		}
		sortNum = parseInt(sortNum);
		if (isNaN(sortNum)) {
			continue;
		}
		if (sortNum > maxSortNum) {
			maxSortNum = sortNum;
		}
	}
	// 添加行
	PHA_GridEditor.Add({
		gridID: 'gridPrescTypeSort',
		field: OPIPArr.length == 1 ? 'prescTypeId' : 'OPIP',
		rowData: {
			pipc: pipc,
			OPIP: OPIPArr.length > 0 ? OPIPArr[0] : '',
			OPIPDesc: OPIPDescArr.length > 0 ? OPIPDescArr[0] : '',
			sortNum: maxSortNum + 1
		}
	});
}

// 保存 - 明细
function SaveItm() {
	// 主表ID
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "请先选择左侧表格的一条数据！",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pipc = gridSelect.pipc;
	
	var OPIPArr = [], OPIPDescArr = [];
	if (gridSelect.OPFlag == 'Y') {
		OPIPArr.push('OP');
		OPIPDescArr.push('门诊');
	}
	if (gridSelect.IPFlag == 'Y') {
		OPIPArr.push('IP');
		OPIPDescArr.push('住院');
	}

	// 明细数据
	$('#gridPrescTypeSort').datagrid('endEditing');
	var gridChanges = $('#gridPrescTypeSort').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.popover({
			msg: "没有需要保存的数据!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridPrescTypeSort');
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
		gridID: 'gridPrescTypeSort',
		fields: ['OPIP', 'prescTypeId']
	});
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.PrescSort.Save", "SaveItmMulti", pJsonStr);
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
	QueryItm();
}

// 删除 - 明细
function DeleteItm() {
	var gridSelect = $('#gridPrescTypeSort').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("提示", "请选择需要删除的记录!", "warning");
		return;
	}
	$.messager.confirm('确认对话框', '确定删除吗？', function (r) {
		if (r) {
			var pipci = gridSelect.pipci || "";
			if (pipci == "") {
				var rowIndex = $('#gridPrescTypeSort').datagrid('getRowIndex', gridSelect);
				$('#gridPrescTypeSort').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.PrescSort.Save", "DeleteItm", pipci);
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
				QueryItm();
			}
		}
	})
}

// 格式化
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
	// 类型值
	pointer: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: true,
			url: $URL,
			onBeforeLoad: function (param) {
				// 关联类型
				var rowData = $('#gridPrescType').datagrid('getSelected');
				selType = rowData ? rowData.type : ($('#type').combobox('getValue') || "");
				if (selType == "") {
					$.messager.popover({
						msg: '请先选择*关联类型！',
						type: "alert",
						timeout: 1000
					});
					return;
				}
				// 参数值
				param.QText = param.q;
				param.ClassName = "PHA.STORE.Org";
				param.ResultSetType = "array";
				param.HospId = session['LOGON.HOSPID'];
				if (selType == "U") {
					param.QueryName = "SSUser";
				} else if (selType == "L") {
					param.QueryName = "CTLoc";
				} else if (selType == "G") {
					param.QueryName = "SSGroup";
				}
			},
			onShowPanel: function(){
				PHA_GridEditor.Show();
			},
			onHidePanel: function(){
				PHA_GridEditor.Next();
			}
		}
	},
	// 处方类型
	herbPrescTypeId:{
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: true,
			url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=HerbPrescTypeList&ResultSetType=array",
			onBeforeLoad: function (param) {
				param.filterText = param.q;
			},
			onShowPanel: function(){
				PHA_GridEditor.Show();
			},
			onHidePanel: function(){
				PHA_GridEditor.Next();
			}
		}
	},
	// 门诊/住院
	OPIP: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: false,
			panelHeight: 'auto',
			data: [{
					RowId: 'OP',
					Description: '门诊'
				}, {
					RowId: 'IP',
					Description: '住院'
				}
			],
			onShowPanel: function(){
				PHA_GridEditor.Show();
			},
			onHidePanel: function(){
				PHA_GridEditor.Next();
			}
		}
	},
	// 处方类型
	prescTypeId: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: true,
			url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=PrescTypeList&ResultSetType=array",
			onBeforeLoad: function (param) {
				param.filterText = param.q;
			},
			onShowPanel: function(){
				PHA_GridEditor.Show();
			},
			onHidePanel: function(){
				PHA_GridEditor.Next();
			}
		}
	}
}