/**
 * 名称:	 药房公共-移动设置-菜单字典
 * 编写人:	 yunhaibao
 * 编写日期: 2019-12-05
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

// 查询条件
function InitDict(){
	// 检索别名
	PHA.SearchBox("conMenuAlias", {
		width: 300,
        searcher: Query,
        placeholder: "可输入菜单的简拼、代码、名称..."
    });
    
    // 查询参数列表是否使用查询条件
	$('#chk-FindAll').checkbox({
		onCheckChange: function(e, value){
			Query();
		}
	});
}

// 表格 - 产品线
function InitGridPro() {
	var columns = [
		[{
				field: "RowId",
				title: '产品线Id',
				hidden: true,
				width: 100
			},
			{
				field: "Description",
				title: '名称',
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

// 表格 - 菜单
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
				title: '菜单代码',
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
				title: '菜单名称',
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
				title: '菜单图标',
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
				title: '分组号',
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
				title: '跳转界面',
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
				title: '可用',
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
				title: '产品线ID',
				hidden: true,
				width: 100
			},
			{
				field: "menuProDesc",
				title: '产品线',
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


// 事件
function InitEvents() {
	$("#btnAdd").on("click", AddMenu);
	$("#btnSave").on("click", Save);
	$("#btnDelete").on("click", Delete);
	$("#btnAddPro").on("click", AddPro);
	$("#btnExport").on("click", Export);
	$("#btnImport").on("click", Import);
}

// 查询 - 产品线
function QueryPro(){
	$("#gridPro").datagrid("query", {
		InputStr: ''
	});
}

// 查询
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
	// 获取产品线
	var selRowData = $("#gridPro").datagrid("getSelected") || {};
	var proId = selRowData.RowId || "";
	if (proId == "") {
		PHA.Popover({
			msg: "请先选择产品线！",
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

// 保存
function Save() {
	// 获取产品线
	var selRowData = $("#gridPro").datagrid("getSelected") || {};
	var proId = selRowData.RowId || "";
	if (proId == "") {
		PHA.Popover({
			msg: "请先选择产品线！",
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
		PHA.Alert('提示', saveInfo, saveVal);
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		$('#gridMenu').datagrid("reload");
	}
}

// 删除
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
	});
}

// 关联产品线
function AddPro(){
	// 获取产品线
	var selRowData = $("#gridPro").datagrid("getSelected") || {};
	var proId = selRowData.RowId || "";
	if (proId == "") {
		PHA.Popover({
			msg: "请先选择产品线！",
			type: 'alert'
		});
		return;
	}
	var proDesc = selRowData.Description;
	
	// 获取菜单
	var selMenuData = $("#gridMenu").datagrid("getSelected");
	if (selMenuData == null) {
		PHA.Popover({
			msg: "请选择要关联的菜单！",
			type: 'alert'
		});
		return;
	}
	var menuId = selMenuData.menuId || "";
	var menuCode = selMenuData.menuCode || "";
	var menuDesc = selMenuData.menuDesc || "";
	if (menuId == "") {
		PHA.Popover({
			msg: "需要关联的菜单没有保存！",
			type: 'alert'
		});
		return;
	}
	var menuProId = selMenuData.menuProId || "";
	var menuProDesc = selMenuData.menuProDesc || "";
	
	// 确认操作
	var confirmInfo = "您确认将菜单<b>" + menuDesc + "</b><br/>关联到产品线<b>" + proDesc + "</b>?";
	PHA.Confirm("提示", confirmInfo, function () {
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
			PHA.Alert('提示', saveInfo, saveVal);
		} else {
			PHA.Popover({
				msg: '关联成功',
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
			msg: '没有需要导出的数据',
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
			PHA.Alert('提示', retArr[1], 'error');
		} else {
			PHA.Popover({
				msg: '导入成功',
				type: 'success'
			});
			$('#gridMenu').datagrid("reload");
		}
	});
}