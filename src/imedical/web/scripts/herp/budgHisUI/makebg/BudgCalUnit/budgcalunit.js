﻿ /*
Creator: Liu XiaoMing
CreatDate: 2018-09-04
Description: 全面预算管理-基础信息-计量单位
CSPName: herp.budg.hisui.budgcalUnit.csp
ClassName: herp.budg.hisui.udata.uBudgCalUnit
herp.budg.udata.uBudgCalUnit
 */

var startIndex = undefined;

//判断是否结束编辑
function endEditing() {

	if (startIndex == undefined) {
		return true
	}
	if ($('#calUnitGrid').datagrid('validateRow', startIndex)) {
		$('#calUnitGrid').datagrid('endEdit', startIndex);
		startIndex = undefined;
		return true;
	} else {
		return false;
	}
}

var calUnitColumn = [[{
			field: 'ck',
			checkbox: true
		}, {
			field: 'rowid',
			title: 'ID',
			hidden: true
		}, {
			field: 'code',
			title: '编码',
			width: 300,
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}

			}
		}, {
			field: 'name',
			title: '名称',
			width: 300,
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}

	]]

//增加按钮
var AddBtn = {
	id: 'Add',
	iconCls: 'icon-add',
	text: '新增',
	handler: function () {

		if (endEditing()) {
			$('#calUnitGrid').datagrid('appendRow', {
				rowid: '',
				code: '',
				name: ''
			});

			startIndex = $('#calUnitGrid').datagrid('getRows').length - 1;
			$('#calUnitGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);

		}
	}
}

//保存按钮
var SaveBtn = {
	id: 'Save',
	iconCls: 'icon-save',
	text: '保存',
	handler: function () {
		Save();
	}
}

//删除按钮
var DelBtn = {
	id: 'Del',
	iconCls: 'icon-cancel',
	text: '删除',
	handler: function () {
		Del();
	}
}

var calUnitGridObj = $HUI.datagrid('#calUnitGrid', {
		headerCls: 'panel-header-gray',
		region: 'center',
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCalUnit',
			MethodName: 'List',
			hospid: hospid,
			userid: userid
		},
		columns: calUnitColumn,
		rownumbers: true, //行号
		pagination: true, //分页
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100],
		toolbar: [AddBtn, SaveBtn, DelBtn],
		onClickCell: ClickCell
	});

//点击单元格事件
function ClickCell(index, field) {

	//alert(startIndex+"^"+index);
	startIndex = index;
	if (endEditing()) {
		$('#calUnitGrid').datagrid('editCell', {
			index: index,
			field: field
		});
	}
}

//保存前校验
function chkBefSave(rowIndex, grid, row) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = row[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined) || (parseInt(reValue) == 0)) {
						var info = "请注意必填项不能为空或零！";
						$.messager.popover({
							msg: info,
							type: 'alert',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 1
							}
						});
						return false;
					}
				}
			}
		}
		return true;
}

//保存方法
function Save() {

	var grid = $('#calUnitGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "";
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
			if (t) {
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var tempdata = row.rowid
							 + "^" + row.code
							 + "^" + row.name;

						if (mainData == "") {
							mainData = tempdata;
						} else {
							mainData = mainData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				if (flag == 1) {
					DoSave(mainData);
				}
				grid.datagrid("reload");
			}
		})
	}
}

//保存请求后台方法
var DoSave = function (mainData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgCalUnit',
		MethodName: 'Save',
		userid: userid,
		mainData: mainData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '保存成功！',
				type: 'success',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '保存失败！' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 1
				}
			});
		}
	});
}

function Del() {
	var rows = $('#calUnitGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '请选中要删除的记录！',
			type: 'alert',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 1
			}
		});
		return;
	}

	$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
		if (t) {
			var mainData = "";
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var rowid = row.rowid;
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//新增的行删除
					editIndex = $('#calUnitGrid').datagrid('getRowIndex', row);
					$('#calUnitGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
				}
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgCalUnit',
				MethodName: 'Del',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: '删除成功！',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 1
						}
					});
					$('#calUnitGrid').datagrid("reload");
				} else {
					$.messager.popover({
						msg: '删除失败！' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 1
						}
					});
				}
			});

			$('#calUnitGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
			startIndex = undefined;
			return startIndex;
		}
	})
}
