/**
 * Desc:    处方类型字典维护
 * Creator: Huxt 2019-09-11
 * csp:		pha.in.v3.mob.presctypedict.csp
 * js:		scripts/pha/mob/v2/presctypedict.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	InitGridPrescType();

	$('#btnFind').on("click", Query);
	$('#btnAdd').on("click", AddNewRow);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);
});

// 初始化表格
function InitGridPrescType() {
	var columns = [
		[{
				field: 'pipt',
				title: 'pipt',
				width: 100,
				hidden: true
			}, {
				field: 'piptCode',
				title: '类型代码',
				width: 200,
				sortable: true,
				align: 'left',
				editor: GridEditors.validatebox
			}, {
				field: 'piptDesc',
				title: '类型名称',
				width: 225,
				align: 'left',
				editor: GridEditors.validatebox
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.TypeDict.Query',
			QueryName: 'TypeDict'
		},
		columns: columns,
		rownumbers: true,
		toolbar: "#gridPrescTypeBar",
		editFieldSort: ["piptCode", "piptDesc"],
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPrescType",
				index: index,
				field: field
			});
		},
		onClickRow: function (rowIndex, rowData) {
			PHA_GridEditor.End("gridPrescType");
		}
	};
	PHA.Grid("gridPrescType", dataGridOption);
}

// 查询
function Query() {
	$('#gridPrescType').datagrid("reload");
}

// 新增行
function AddNewRow() {
	PHA_GridEditor.Add({
		gridID: 'gridPrescType',
		field: 'piptCode'
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
	var chkRetStr = PHA_GridEditor.CheckValues('gridPrescType');
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pJsonStr = JSON.stringify(gridChanges);

	var saveRet = tkMakeServerCall("PHA.MOB.TypeDict.Save", "SaveMulti", pJsonStr);
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
			var pipt = gridSelect.pipt || "";
			if (pipt == "") {
				var rowIndex = $('#gridPrescType').datagrid('getRowIndex', gridSelect);
				$('#gridPrescType').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.TypeDict.Save", "Delete", pipt);
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


/*
 * Grid Editors for this page
 */
var GridEditors = {
	// 文本
	validatebox: {
		type: 'validatebox',
		options: {
			required: true,
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	}
}