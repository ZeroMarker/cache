/**
 * 模块:     处方类型维护
 * 编写日期: 2020-20-20
 * 编写人:   Huxt
 * pha.in.v3.mob.presctype.csp
 * scripts/pha/mob/v2/presctype.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	InitGridPrescType();
	InitGridCMPrescType();
	$('#btnAdd').on("click", AddNewRow);
	$('#btnSave').on("click", SavePrescType);
	$('#btnDelete').on("click", DelPrescType);
	$('#btnSaveType').on("click", SaveCMPrescType);
});

// 配方类型
function InitGridPrescType() {
	var columns = [
		[{
				field: "phpt",
				title: 'phpt',
				hidden: true
			}, {
				field: 'phptCode',
				title: '类型代码',
				width: 225,
				sortable: 'true',
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function () {
							PHA_GridEditor.Next();
						}
					}
				}
			}, {
				field: 'phptDesc',
				title: '类型名称',
				width: 225,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function () {
							PHA_GridEditor.Next();
						}
					}
				}
			}, {
				field: 'phptDefault',
				title: '默认类型',
				width: 100,
				sortable: 'true',
				align: 'center',
				hidden: true, // 没啥用,暂时去掉吧
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
			ClassName: 'PHA.MOB.PrescType.Query',
			QueryName: 'HerbPrescType'
		},
		columns: columns,
		toolbar: "#gridPrescTypeBar",
		isAutoShowPanel: true,
		editFieldSort: ["phptCode", "phptDesc"],
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPrescType",
				index: index,
				field: field
			});
		},
		onClickRow: function (index, rowData) {
			$(this).datagrid('endEditing');
			QueryCMPrescType();
		}
	};
	PHA.Grid("gridPrescType", dataGridOption);
}

// 草药处方类型列表 (取医生站)
function InitGridCMPrescType() {
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				field: 'cmptCode',
				title: '代码',
				width: 225
			}, {
				field: 'cmptDesc',
				title: '名称',
				width: 225
			}, {
				field: 'cmptActive',
				title: '是否可用',
				width: 80,
				sortable: 'true',
				align: 'center',
				formatter: FormatterYes
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescType.Query',
			QueryName: 'CMPrescType'
		},
		singleSelect: false,
		columns: columns,
		toolbar: "#gridCMPrescTypeBar",
		onLoadSuccess: function(data) {
			var rowsData = data.rows;
			if (!rowsData || rowsData.length == 0) {
				return;
			}
			var checkedRows = 0;
			for (var i = 0; i < rowsData.length; i++) {
				var rowData = rowsData[i];
				if (rowData.checkedFlag == "Y") {
					$('#gridCMPrescType').datagrid('selectRow', i);
					checkedRows = checkedRows + 1;
				}
			}
			if (checkedRows != rowsData.length) {
				$('#gridCMPrescType').prev().find('.datagrid-header-check').children().eq(0).removeAttr('checked');
			}
		}
	};
	PHA.Grid("gridCMPrescType", dataGridOption);
}

// 查询
function Query() {
	$('#gridPrescType').datagrid('load', {
		ClassName: 'PHA.MOB.PrescType.Query',
		QueryName: 'HerbPrescType'
	});
}

// 新增行
function AddNewRow() {
	PHA_GridEditor.Add({
		gridID: 'gridPrescType',
		field: 'phptCode',
		rowData: {
			phptDefault: 'N'
		}
	});
}

// 保存维护的配方类型
function SavePrescType() {
	$('#gridPrescType').datagrid('endEditing');
	// 获取数据
	var gridChanges = $('#gridPrescType').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("提示", "没有需要保存的数据", "warning");
		return;
	}
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridPrescType');
	if (chkRetStr != "") {
		PHA.Popover({
			msg: chkRetStr,
			type: "alert"
		});
		return;
	}
	// 重复行验证
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridPrescType',
		fields: ['phptCode']
	});
	if (chkRetStr != "") {
		PHA.Popover({
			msg: chkRetStr,
			type: "alert"
		});
		return;
	}
	// 保存
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.PrescType.Save", "SaveMulti", pJsonStr);
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

// 删除维护的配方类型
function DelPrescType() {
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("提示", "请选择需要删除的记录!", "warning");
		return;
	}
	$.messager.confirm('确认对话框', '确定删除吗？', function (r) {
		if (r) {
			var phpt = gridSelect.phpt || "";
			if (phpt == "") {
				var rowIndex = $('#gridPrescType').datagrid('getRowIndex', gridSelect);
				$('#gridPrescType').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.PrescType.Save", "Delete", phpt);
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
				QueryCMPrescType();
			}
		}
	})
}

// 刷新子列表
function QueryCMPrescType() {
	var gridSelect = $('#gridPrescType').datagrid("getSelected") || {};
	var pJsonStr = JSON.stringify(gridSelect);
	$('#gridCMPrescType').datagrid('load', {
		ClassName: 'PHA.MOB.PrescType.Query',
		QueryName: 'CMPrescType',
		pJsonStr: pJsonStr,
		gLocId: SessionLoc
	});
}

// 保存关联的处方类型
function SaveCMPrescType() {
	var gridSelect = $("#gridPrescType").datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "请先选中左侧需要维护的配方类型!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var phpt = gridSelect.phpt;
	
	var gridDetailChecked = $("#gridCMPrescType").datagrid("getChecked");
	var pJsonStr = JSON.stringify(gridDetailChecked);
	
	var saveRet = tkMakeServerCall("PHA.MOB.PrescType.Save", "SaveItmMulti", phpt, pJsonStr);
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
	QueryCMPrescType();
}

// 格式化
function FormatterYes(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}
