/**
 * @Description: 移动药房 - 电子标签(药夹子)查询
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.etag.csp
 * @Js:          pha/mob/v2/etag.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	// 初始化
	InitDict();
	InitGridETag();

	// 事件绑定
	$('#etagID').on('keypress', function (e) {
		if (e.keyCode == 13) {
			QueryETag();
		}
	});
	$('#etagBarCode').on('keypress', function (e) {
		if (e.keyCode == 13) {
			QueryETag();
		}
	});
	$('#txtBarCode').focus();

	$('#btnFind').on("click", QueryETag);
	$('#btnClear').on("click", Clear);
	$('#btnCancel').on("click", Cancel);
	$('#btnExport').on("click", ExportXls);
	$('#btnImport').on("click", ImportXls);
	$('#btnAdd').on("click", Add);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);
})

// 初始化表单
function InitDict() {
	$("#etagStat").combobox({
		valueField: 'RowId',
		textField: 'Description',
		placeholder: '选择状态...',
		width: '12em',
		editable: false,
		panelHeight: 'auto',
		data: [{
				RowId: 0,
				Description: '全部'
			}, {
				RowId: 1,
				Description: '绑定'
			}, {
				RowId: 2,
				Description: '呼叫'
			}, {
				RowId: 3,
				Description: '空闲'
			}
		]
	});
	$("#etagStat").combobox("setValue", 0);
}

// 初始化表格
function InitGridETag() {
	var columns = [[{
				field: 'tSelect',
				checkbox: true
			}, {
				field: 'piet',
				title: 'piet',
				width: 80,
				hidden: true
			}, {
				field: 'pietID',
				title: '标签ID',
				width: 150,
				editor: GridEditors.textbox
			}, {
				field: 'pietBarCode',
				title: '标签条码号',
				width: 90,
				editor: GridEditors.textbox
			}, {
				field: 'pietColor',
				title: '标签颜色',
				width: 80,
				align: 'center',
				editor: GridEditors.pietColor
			}, {
				field: 'pietColorVal',
				title: '颜色值',
				width: 80,
				align: 'center',
				editor: GridEditors.pietColor,
				styler: function (value, rowData, rowIndex) {
					if (!value) {
						return;
					}
					return 'background-color:' + value;
				}
			}, {
				field: 'pietState',
				descField: 'pietStateDesc',
				title: '标签状态',
				width: 80,
				align: 'center',
				editor: GridEditors.pietState,
				formatter: function (value, rowData, index) {
					return rowData.pietStateDesc;
				}
			}, {
				field: 'pietAppType',
				descField: 'pietAppTypeDesc',
				title: '应用程序',
				width: 80,
				editor: GridEditors.pietAppType,
				formatter: function (value, rowData, index) {
					return rowData.pietAppTypeDesc;
				}
			}, {
				field: 'pietPrescNo',
				title: '当前关联处方号',
				width: 150,
				align: 'center',
				editor: GridEditors.textbox
			}, {
				field: 'pietPlace',
				title: '标签位置',
				width: 100,
				editor: GridEditors.textbox
			}, {
				field: 'pietType',
				descField: 'pietTypeDesc',
				title: '标签类型',
				width: 140,
				editor: GridEditors.pietType,
				formatter: function (value, rowData, index) {
					return rowData.pietTypeDesc;
				}
			}, {
				field: 'pietBattery',
				title: '标签电量',
				width: 80,
				align: 'center',
				editor: GridEditors.textbox
			}, {
				field: 'pietActiveTime',
				title: '激活时间(绑定时间)',
				width: 155,
				align: 'center'
			}, {
				field: 'pietDeactiveTime',
				title: '停用时间(解绑时间)',
				width: 155,
				align: 'center'
			}, {
				field: 'pietCreateTime',
				title: '创建时间',
				width: 155,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.ETag.Query',
			QueryName: 'ETag',
		},
		columns: columns,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		toolbar: '#gridETagBar',
		isAutoShowPanel: false,
		editFieldSort: ["pietID", "pietBarCode", "pietColor", "pietColorVal", "pietState", "pietAppType", "pietPrescNo", "pietPlace", "pietType", "pietBattery"],
		onSelect: function (rowIndex, rowData) {},
		onClickRow: function () {
			PHA_GridEditor.End("gridETag");
		},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridETag",
				index: index,
				field: field
			});
		},
		onLoadSuccess: function (data) {
			$('#etagBarCode').val("");
			$('#etagBarCode').focus();
			$('#gridETag').siblings('.datagrid-view2').find('.datagrid-header-check').children().eq(0).prop("checked", false);
			PHA_GridEditor.End("gridETag");
		}
	};
	PHA.Grid("gridETag", dataGridOption);
}

// 查询
function QueryETag() {
	var formDataArr = PHA.DomData("#gridETagBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridETag').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// 清屏
function Clear(){
	PHA.DomData("#gridETagBar", {
		doType: 'clear'
	});
	$('#etagStat').combobox('setValue', '0');
	$('#etagID').val('');
	$('#etagBarCode').val('');
	$('#gridETag').datagrid('clear');
}

// 新增
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridETag',
		field: 'pietID',
		rowData: {}
	});
}

// 保存
function Save() {
	// 获取数据发生改变的行
	$('#gridETag').datagrid('endEditing');
	var changesData = $('#gridETag').datagrid('getChanges');
	if (changesData == null || changesData.length == 0) {
		PHA.Popover({
			msg: '数据未发生改变,不需要保存!',
			type: "info"
		});
		return;
	}
	
	// 确定行数
	var newChangesData = [];
	for (var i = 0; i < changesData.length; i++) {
		var oneRowData = changesData[i];
		oneRowData.rowIndex = GetGridRowIndex('gridETag', oneRowData) + 1;
		newChangesData.push(oneRowData);
	}
	var pJsonStr = JSON.stringify(newChangesData);

	// 保存到后台
	var retStr = tkMakeServerCall("PHA.MOB.ETag.Save", "SaveMulti", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("提示", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "保存成功!",
		type: "success",
		timeout: 1000
	});
	QueryETag();
}

// 删除
function Delete() {
	// 循环删除
	var checkedItems = $('#gridETag').datagrid('getChecked');
	if (!checkedItems || checkedItems.length == 0) {
		PHA.Popover({
			msg: '未勾选需要删除的数据！',
			type: "alert"
		});
		return;
	}
	
	$.messager.confirm('确认提示', '确定删除勾选的数据吗？', function (r) {
		if (r) {
			for (var i = 0; i < checkedItems.length; i++) {
				var oneItem = checkedItems[i];
				var piet = oneItem.piet || "";
				if (piet == "") {
					var rowIndex = $('#gridETag').datagrid('getRowIndex', oneItem);
					var rowData = $('#gridETag').datagrid('getRows')[rowIndex];
					$('#gridETag').datagrid("deleteRow", rowIndex);
				} else {
					var delRet = tkMakeServerCall("PHA.MOB.ETag.Save", "Delete", piet);
					var delRetArr = delRet.split('^');
					if (delRetArr[0] < 0) {
						$.messager.alert("提示", delRetArr[1], (delRetArr[0] == "-1") ? "warning" : "error");
						return;
					}
				}
			}
			// 提示
			$.messager.popover({
				msg: "删除成功!",
				type: "success",
				timeout: 1000
			});
			QueryETag();
		}
	});
}

// 取消关联(调用接口)
function Cancel() {
	var newCheckedItems = [];
	var checkedItems = $('#gridETag').datagrid('getChecked');
	for (var i = 0; i < checkedItems.length; i++) {
		var oneItem = checkedItems[i];
		var pietID = oneItem.pietID || "";
		var pietPrescNo = oneItem.pietPrescNo || "";
		if (pietPrescNo == "") {
			continue;
		}
		newCheckedItems.push({
			pietID: pietID,
			pietPrescNo: pietPrescNo
		});
	}
	if (newCheckedItems.length == 0) {
		$.messager.popover({
			msg: "未勾选需要取消绑定处方的标签，或者勾选的标签未绑定处方!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pJsonStr = JSON.stringify(newCheckedItems);

	var retStr = tkMakeServerCall("PHA.MOB.ETag.Save", "CancelMulti", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("提示", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "取消成功!",
		type: "success",
		timeout: 1000
	});
	QueryETag();
}

// 根据行数据获取行号
function GetGridRowIndex(_id, _rowData) {
	var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
	return rowIndex;
}

// 下载模板
var Xlsx_title = {
	pietID: "标签ID",
	pietBarCode: "标签条码",
	pietColor: "标签颜色",
	pietColorVal: "颜色值",
	pietState: "空闲/绑定/呼叫",
	pietAppType: "处方/设备",
	pierPrescNo: "当前关联处方号",
	pietPlace: "标签位置",
	pietType: "标签类型",
	pietBattery: "标签电量"
};

function ExportXls() {
	var Xlsx_data = [{
		pietID: "04960f02ac5c84",
		pietBarCode: "M7394",
		pietColor: "绿色",
		pietColorVal: "#ff00ff00",
		pietState: "空闲/绑定/呼叫",
		pietAppType: "处方/设备",
		pierPrescNo: "",
		pietPlace: "",
		pietType: "声光标签/普通电子标签",
		pietBattery: ""
	}];
	var fileName = "电子标签数据模板.xlsx";
	PHA_COM.ExportFile(Xlsx_title, Xlsx_data, fileName);
}

// 导入数据
function ImportXls() {
	PHA_COM.ImportFile({
		suffixReg: /^(.xls)|(.xlsx)$/
	}, function (data, file) {
		// 反向对照
		var Xlsx_title_tmp = {};
		for (var k in Xlsx_title) {
			var title_Desc = Xlsx_title[k];
			Xlsx_title_tmp[title_Desc] = k;
		}

		// 获取数据
		var newData = [];
		for (var i = 0; i < data.length; i++) {
			var oneRow = data[i];
			var newOneRow = {};
			for (var j in oneRow) {
				if (Xlsx_title_tmp[j]) {
					newOneRow[Xlsx_title_tmp[j]] = oneRow[j];
				}
			}
			newData.push(newOneRow);
		}
		var pJsonStr = JSON.stringify(newData);

		// 保存到后台
		var retStr = tkMakeServerCall("PHA.MOB.ETag.Save", "ImportData", pJsonStr);
		var retArr = retStr.split("^");
		if (retArr[0] < 0) {
			$.messager.alert("提示", retArr[1], "warning");
			return;
		}
		$.messager.popover({
			msg: "导入成功!",
			type: "success",
			timeout: 1000
		});
		QueryETag();
	});
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// 文本
	textbox: {
		type: 'validatebox',
		options: {
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietColor: {
		type: 'validatebox',
		options: {
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietState: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.ETag.Query&QueryName=ComboData&type=State',
			onBeforeLoad: function (param) {
				param.QText = param.q;
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietAppType: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.ETag.Query&QueryName=ComboData&type=AppType',
			onBeforeLoad: function (param) {
				param.QText = param.q;
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietType: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.ETag.Query&QueryName=ComboData&type=Type',
			onBeforeLoad: function (param) {
				param.QText = param.q;
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	}
}
