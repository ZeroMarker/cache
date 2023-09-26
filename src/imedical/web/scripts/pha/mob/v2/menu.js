/**
 * ����:	 ҩ������-�ƶ�����-�˵��ֵ�
 * ��д��:	 yunhaibao
 * ��д����: 2019-12-05
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
				title: '�˵�Id',
				hidden: true,
				width: 100
			},
			{
				field: "menuCode",
				title: '����',
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
				title: '����',
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


// �¼�
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
			msg: "û����Ҫ���������",
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
			msg: '����ɹ�',
			type: 'success'
		});
	}
	$('#gridMenu').datagrid("reload");
}

function Delete() {
	var gridSelect = $('#gridMenu').datagrid("getSelected");
	if (gridSelect == null) {
		PHA.Popover({
			msg: '��ѡ����Ҫɾ���ļ�¼',
			type: 'alert'
		});
		return;
	}
	PHA.Confirm("ɾ����ʾ", "��ȷ��ɾ����?", function () {
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
				PHA.Alert('��ʾ', saveInfo, saveVal);
			} else {
				PHA.Popover({
					msg: 'ɾ���ɹ�',
					type: 'success'
				});
				$('#gridMenu').datagrid("deleteRow", rowIndex);
			}
		}
	})

}