/**
 * ����:	 ҩ������-�ƶ�����-�˵��ֵ�
 * ��д��:	 yunhaibao
 * ��д����: 2019-12-05
 * csp:      pha.mob.v2.menu.csp
 * js:       pha/mob/v2/menu.js
 */
PHA_COM.App.Csp = "pha.mob.v2.menu.csp";
PHA_COM.App.Name = "MOB.MENU";

$(function () {
	InitDict();
	InitGridPro();
	InitGridMenu();
	InitEvents();
	
	PHA_UX.Translate({
		buttonID: 'btnTranslate',
		gridID: 'gridMenu',
		idField: 'menuId',
		sqlTableName: 'PHAIN_MobMenu'
	});
});

// ��ѯ����
function InitDict(){
	// ��������
	PHA.SearchBox("conMenuAlias", {
		width: 300,
        searcher: Query,
        placeholder: "������˵��ļ�ƴ�����롢����..."
    });
    
    // ��ѯ�����б��Ƿ�ʹ�ò�ѯ����
	$('#chk-FindAll').checkbox({
		onCheckChange: function(e, value){
			Query();
		}
	});
}

// ��� - ��Ʒ��
function InitGridPro() {
	var columns = [
		[{
				field: "RowId",
				title: '��Ʒ��Id',
				hidden: true,
				width: 100
			},
			{
				field: "Description",
				title: '����',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Store',
			QueryName: 'DHCStkSysPro',
			ActiveFlag: "Y"
		},
		pagination: false,
		columns: columns,
		fitColumns: true,
		toolbar: null,
		enableDnd: false,
		onSelect: function (rowIndex, rowData) {
			Query();
			$("#gridPro").datagrid("options").selectedRowIndex = rowIndex;
		},
		onLoadSuccess: function(data){
			var total = data.total;
			if (total > 0) {
				var selRowIdx = $("#gridPro").datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$("#gridPro").datagrid("selectRow", selRowIdx);
				} else {
					$("#gridPro").datagrid("selectRow", 0);
				}
			}
		}
	};

	PHA.Grid("gridPro", dataGridOption);
	$('#gridPro').parent().parent().css('border-radius', '0px');
}

// ��� - �˵�
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
				title: '�˵�����',
				width: 200,
				lineHeight: 24,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},
			{
				field: "menuDesc",
				title: '�˵�����',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},
			{
				field: "menuIcon",
				title: '�˵�ͼ��',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			},
			{
				field: "menuGroupName",
				title: '�����',
				width: 60,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			},
			{
				field: "menuGoPage",
				title: '��ת����',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			},
			{
				field: "activeFlag",
				title: '����',
				width: 70,
				align: 'center',
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "menuProId",
				title: '��Ʒ��ID',
				hidden: true,
				width: 100
			},
			{
				field: "menuProDesc",
				title: '��Ʒ��',
				hidden: false,
				width: 175
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
		fitColumns: true,
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
	$("#btnAdd").on("click", AddMenu);
	$("#btnSave").on("click", Save);
	$("#btnDelete").on("click", Delete);
	$("#btnAddPro").on("click", AddPro);
	$("#btnExport").on("click", Export);
	$("#btnImport").on("click", Import);
}

// ��ѯ - ��Ʒ��
function QueryPro(){
	$("#gridPro").datagrid("query", {
		InputStr: ''
	});
}

// ��ѯ
function Query(){
	var selRowData = $("#gridPro").datagrid("getSelected");
	if (selRowData == null) {
		return false;
	}
	var proId = selRowData.RowId || "";
	if (proId == "") {
		return false;
	}
	var QText = $('#conMenuAlias').searchbox('getValue') || "";
	var findAllFlag = $('#chk-FindAll').checkbox('getValue') == true ? "Y" : "N";
	
	$("#gridMenu").datagrid("query", {
		QText: QText,
		InputStr: proId + "^" + findAllFlag
	});
}

function AddMenu(){
	// ��ȡ��Ʒ��
	var selRowData = $("#gridPro").datagrid("getSelected") || {};
	var proId = selRowData.RowId || "";
	if (proId == "") {
		PHA.Popover({
			msg: "����ѡ���Ʒ�ߣ�",
			type: 'alert'
		});
		return;
	}
	var proDesc = selRowData.Description;
	
	$("#gridMenu").datagrid('addNewRow', {
		defaultRow: {
			menuProId: proId,
			menuProDesc: proDesc,
			activeFlag: 'Y'
		},
		editField: 'menuCode'
	});
}

// ����
function Save() {
	// ��ȡ��Ʒ��
	var selRowData = $("#gridPro").datagrid("getSelected") || {};
	var proId = selRowData.RowId || "";
	if (proId == "") {
		PHA.Popover({
			msg: "����ѡ���Ʒ�ߣ�",
			type: 'alert'
		});
		return;
	}
	
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
		var params = (iData.menuId || "") + "^" 
					+ (iData.menuCode || "") + "^" 
					+ (iData.menuDesc || "") + "^" 
					+ proId + "^" 
					+ (iData.menuIcon || "") + "^" 
					+ (iData.menuGroupName || "") + "^" 
					+ (iData.menuGoPage || "") + "^"
					+ (iData.activeFlag || "");
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
		PHA.Alert('��ʾ', saveInfo, saveVal);
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
		$('#gridMenu').datagrid("reload");
	}
}

// ɾ��
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
	});
}

// ������Ʒ��
function AddPro(){
	// ��ȡ��Ʒ��
	var selRowData = $("#gridPro").datagrid("getSelected") || {};
	var proId = selRowData.RowId || "";
	if (proId == "") {
		PHA.Popover({
			msg: "����ѡ���Ʒ�ߣ�",
			type: 'alert'
		});
		return;
	}
	var proDesc = selRowData.Description;
	
	// ��ȡ�˵�
	var selMenuData = $("#gridMenu").datagrid("getSelected");
	if (selMenuData == null) {
		PHA.Popover({
			msg: "��ѡ��Ҫ�����Ĳ˵���",
			type: 'alert'
		});
		return;
	}
	var menuId = selMenuData.menuId || "";
	var menuCode = selMenuData.menuCode || "";
	var menuDesc = selMenuData.menuDesc || "";
	if (menuId == "") {
		PHA.Popover({
			msg: "��Ҫ�����Ĳ˵�û�б��棡",
			type: 'alert'
		});
		return;
	}
	var menuProId = selMenuData.menuProId || "";
	var menuProDesc = selMenuData.menuProDesc || "";
	
	// ȷ�ϲ���
	var confirmInfo = "��ȷ�Ͻ��˵�<b>" + menuDesc + "</b><br/>��������Ʒ��<b>" + proDesc + "</b>?";
	PHA.Confirm("��ʾ", confirmInfo, function () {
		var DataStr = menuCode + "^" + menuDesc + "^" + proId;
		var saveRet = $.cm({
			ClassName: 'PHA.MOB.Menu.Save',
			MethodName: 'AddMenuToPro',
			DataStr: DataStr,
			dataType: 'text',
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('��ʾ', saveInfo, saveVal);
		} else {
			PHA.Popover({
				msg: '�����ɹ�',
				type: 'success'
			});
			Query();
		}
	});
}

function Export(){
	var rowsData = $('#gridMenu').datagrid('getRows') || [];
	if (rowsData.length == 0) {
		PHA.Popover({
			msg: 'û����Ҫ����������',
			type: 'alert'
		});
		return;
	}
	PHA_COM.ExportGrid('gridMenu');
}

function Import(){
	PHA_COM.ImportFile({
		suffixReg: /^(.xlsx)|(.xls)$/
	}, function(result){
		var pJsonStr = JSON.stringify(result);
		var retStr = tkMakeServerCall('PHA.MOB.Menu.Save', 'Import', pJsonStr);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			PHA.Alert('��ʾ', retArr[1], 'error');
		} else {
			PHA.Popover({
				msg: '����ɹ�',
				type: 'success'
			});
			$('#gridMenu').datagrid("reload");
		}
	});
}