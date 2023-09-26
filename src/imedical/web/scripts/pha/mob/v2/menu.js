/**
 * 名称:	 药房公共-移动设置-菜单字典
 * 编写人:	 yunhaibao
 * 编写日期: 2019-12-05
 */
PHA_COM.App.Csp = "pha.mob.v2.menu.csp";
PHA_COM.App.Name = "MOB.MENU";
$(function () {
	InitGridMenu();
	InitEvents();
});

function InitGridMenu() {
	var columns = [
		[{
				field: "menuId",
				title: '菜单Id',
				hidden: true,
				width: 100
			},
			{
				field: "menuCode",
				title: '代码',
				width: 300,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},
			{
				field: "menuDesc",
				title: '名称',
				width: 300,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.Menu.Query',
			QueryName: 'PHAINMobMenu'
		},
		pagination: true,
		columns: columns,
		shrinkToFit: true,
		toolbar: "#gridMenuBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditCell', {
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid("gridMenu", dataGridOption);
}


// 事件
function InitEvents() {
	$("#btnAdd").on("click", function () {
		$("#gridMenu").datagrid('addNewRow', {});
	})
	$("#btnSave").on("click", Save);
	$("#btnDel").on("click",Delete);
}

function Save() {
	$('#gridMenu').datagrid('endEditing');
	var gridChanges = $('#gridMenu').datagrid('getChanges');
	var gridDelChanges= $('#gridMenu').datagrid('getChanges','deleted');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据",
			type: 'alert'
		});
		return;
	}
	var inputStrArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		if (gridDelChanges.indexOf(iData)>=0){
			continue;
		}
		var params = (iData.menuId || "") + "^" + (iData.menuCode || "") + "^" + (iData.menuDesc || "");
		inputStrArr.push(params)
	}
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
		ClassName: 'PHA.MOB.Menu.Save',
		MethodName: 'SaveMulti',
		MultiDataStr: inputStr,
		dataType: 'text',
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Popover({
			msg: saveInfo,
			type: 'alert'
		});
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
	}
	$('#gridMenu').datagrid("reload");
}

function Delete() {
	var gridSelect = $('#gridMenu').datagrid("getSelected");
	if (gridSelect == null) {
		PHA.Popover({
			msg: '请选择需要删除的记录',
			type: 'alert'
		});
		return;
	}
	PHA.Confirm("删除提示", "您确认删除吗?", function () {
		var menuId = gridSelect.menuId || "";
		var rowIndex = $('#gridMenu').datagrid('getRowIndex', gridSelect);
		if (menuId == "") {
			$('#gridMenu').datagrid("deleteRow", rowIndex);
		} else {
			var saveRet = $.cm({
				ClassName: 'PHA.MOB.Menu.Save',
				MethodName: 'Delete',
				RowId: menuId,
				dataType: 'text',
			}, false);
			var saveArr = saveRet.split('^');
			var saveVal = saveArr[0];
			var saveInfo = saveArr[1];
			if (saveVal < 0) {
				PHA.Alert('提示', saveInfo, saveVal);
			} else {
				PHA.Popover({
					msg: '删除成功',
					type: 'success'
				});
				$('#gridMenu').datagrid("deleteRow", rowIndex);
			}
		}
	})

}