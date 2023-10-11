/**
 * Desc:    送药路径维护
 * Creator: Huxt 2019-09-11
 * csp:		csp/pha.in.v3.mob.sendloc.csp
 * js:		scripts/pha/mob/v2/sendloc.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
PHA_COM.Param.PageRows = 99999;
$(function () {
	InitDict();
	InitGridPhLoc();
	InitGridSendLoc();
	InitGridWardLoc();

	$('#btnFind').on('click', function () {
		QueryCom();
	});
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#btnSaveAllWard').on('click', SaveAllWard);
	$('#wardLocCon').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryCom();
		}
	});
});

// 初始化 - 表单
function InitDict() {
	PHA.SearchBox("phLocAlias", {
		width: 265,
		searcher: QueryPhLoc,
		placeholder: "请输入简拼或名称回车查询..."
	});
	PHA.SearchBox("wardLocAlias", {
		width: 265,
		searcher: QueryWardLoc,
		placeholder: "请输入简拼或名称回车查询..."
	});

}

// 初始化 - 初始化药房科室
function InitGridPhLoc() {
	var columns = [
		[{
				field: 'RowId',
				title: 'RowId',
				width: 100,
				hidden: true
			}, {
				field: 'Description',
				title: '药房科室',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.STORE.Org',
			QueryName: 'CTLoc',
			TypeStr: 'D',
			HospId: session['LOGON.HOSPID'],
			page: 1,
			rows: PHA_COM.Param.PageRows
		},
		columns: columns,
		toolbar: "#gridPhLocBar",
		rownumbers: true,
		fitColumns: true,
		pagination: false,
		onSelect: function (rowIndex, rowData) {
			$('#phLocDesc').val(rowData.Description);
			QuerySendLoc();
			QueryWardLoc();
		},
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$('#gridPhLoc').datagrid('selectRow', 0);
			}
		}
	};
	PHA.Grid("gridPhLoc", dataGridOption);
}

// 初始化 - 送药科室表格
function InitGridSendLoc() {
	var columns = [
		[{
				field: 'phsl',
				title: 'phsl',
				width: 100,
				hidden: true
			}, {
				field: 'phLocId',
				title: 'phLocId',
				width: 100,
				hidden: true
			}, {
				field: 'phLocDesc',
				title: '药房',
				width: 100,
				hidden: true
			}, {
				field: 'wardLocId',
				title: 'wardLocId',
				width: 100,
				hidden: true
			}, {
				field: 'wardLocDesc',
				title: '接收科室/病区',
				width: 250
			}, {
				field: 'sendFlag',
				title: '是否送药',
				width: 100,
				align: 'center',
				editor: GridEditors.checkbox,
				formatter: function (value, row, index) {
					if (value == 'Y') {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}, {
				field: 'wardQue',
				title: '显示序号',
				width: 100,
				editor: GridEditors.validatebox
			}, {
				field: 'sendFreqDesc',
				title: '送药频率名称',
				width: 100,
				editor: GridEditors.validatebox
			},
			{
				field: 'sendFreqFac',
				title: '送药频率系数',
				width: 100,
				editor: GridEditors.validatebox
			}, {
				field: 'sendFac',
				title: '付数系数',
				width: 100,
				editor: GridEditors.validatebox
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.SendLoc.Query',
			QueryName: 'PHSenLoc',
			QText: '',
			pJsonStr: '',
			page: 1,
			rows: PHA_COM.Param.PageRows
		},
		columns: columns,
		toolbar: "#gridSendLocBar",
		pagination: false,
		pageSize: 9999,
		rownumbers: true,
		fitColumns: true,
		editFieldSort: ["sendFlag", "wardQue", "sendFreqDesc", "sendFreqFac", "sendFac"],
		onClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridSendLoc",
				index: index,
				field: field
			});
		},
		onClickRow: function (rowIndex, rowData) {
			PHA_GridEditor.End("gridSendLoc");
		}
	};
	PHA.Grid("gridSendLoc", dataGridOption);
}

// 初始化 - 病区表格
function InitGridWardLoc() {
	var columns = [
		[{
				field: 'RowId',
				title: 'RowId',
				width: 100,
				hidden: true
			}, {
				field: 'wardOperate',
				title: '操作',
				width: 20,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return '<img title="接收科室/病区【已维护】" onclick="AddToSendLoc()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border:0px;cursor:pointer">';
				}
			}, {
				field: 'Description',
				title: '病区/科室',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.SendLoc.Query',
			QueryName: 'NotUsedWard',
			page: 1,
			rows: PHA_COM.Param.PageRows,
			pJsonStr: JSON.stringify({
				TypeStr: 'D,W',
				HospId: session['LOGON.HOSPID']
			})
		},
		columns: columns,
		toolbar: "#gridWardLocBar",
		rownumbers: true,
		fitColumns: true,
		pagination: false,
		onClickRow: function (rowIndex, rowData) {},
		onClickRow: function (rowIndex, rowData) {}
	};
	PHA.Grid("gridWardLoc", dataGridOption);
}

// 查询 - 药房
function QueryPhLoc() {
	var phLocAlias = $("#phLocAlias").searchbox("getValue") || "";
	$('#gridPhLoc').datagrid("reload", {
		ClassName: 'PHA.STORE.Org',
		QueryName: 'CTLoc',
		TypeStr: 'D',
		HospId: session['LOGON.HOSPID'],
		QText: phLocAlias,
		page: 1,
		rows: PHA_COM.Param.PageRows
	});
}

// 查询 - 已维护的病区
function QuerySendLoc() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	var wardLocCon = $("#wardLocCon").val();
	var pJson = {
		phLocId: phLocId
	}
	var pJsonStr = JSON.stringify(pJson);
	$('#gridSendLoc').datagrid("reload", {
		ClassName: 'PHA.MOB.SendLoc.Query',
		QueryName: 'PHSenLoc',
		QText: wardLocCon,
		pJsonStr: pJsonStr,
		page: 1,
		rows: PHA_COM.Param.PageRows
	});
}

// 查询 - 未维护的病区
function QueryWardLoc() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	var wardLocAlias = $("#wardLocAlias").searchbox("getValue") || "";
	var pJson = {
		TypeStr: 'D,W',
		HospId: session['LOGON.HOSPID'],
		phLocId: phLocId
	}
	var pJsonStr = JSON.stringify(pJson);
	$('#gridWardLoc').datagrid("reload", {
		ClassName: 'PHA.MOB.SendLoc.Query',
		QueryName: 'NotUsedWard',
		QText: wardLocAlias,
		pJsonStr: JSON.stringify(pJson),
		page: 1,
		rows: PHA_COM.Param.PageRows
	});
}

// 查询
function QueryCom() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	if (phLocId == "") {
		$.messager.popover({
			msg: "请输先选择药房！",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	QuerySendLoc();
	QueryWardLoc();
}

// 保存
function Save() {
	$('#gridSendLoc').datagrid('endEditing');
	// 获取数据
	var gridChanges = $('#gridSendLoc').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("提示", "没有需要保存的数据", "warning");
		return;
	}
	// 检查值
	var chkRetStr = PHA_GridEditor.CheckValues('gridSendLoc');
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// 检查序号是否重复
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridSendLoc',
		isCheckNull: false,
		fields: ['wardQue']
	});
	if (chkRetStr != "") {
		$.messager.popover({
			msg: "显示序号: " + chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.SendLoc.Save", "SaveMulti", pJsonStr);
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
	QueryCom();
}

// 删除
function Delete() {
	var gridSelect = $('#gridSendLoc').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("提示", "请选择需要删除的记录!", "warning");
		return;
	}

	$.messager.confirm('确认对话框', '确定删除吗？', function (r) {
		if (r) {
			var phsl = gridSelect.phsl || "";
			if (phsl == "") {
				var rowIndex = $('#gridSendLoc').datagrid('getRowIndex', gridSelect);
				var rowData = $('#gridSendLoc').datagrid('getRows')[rowIndex];
				$('#gridSendLoc').datagrid("deleteRow", rowIndex);
				$('#gridWardLoc').datagrid('appendRow', {
					RowId: rowData.wardLocId,
					Description: rowData.wardLocDesc,
				});
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.SendLoc.Save", "Delete", phsl);
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
				QueryCom();
			}
		}
	});
}

// 设置所有的出库科室
function SaveAllWard() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	if (phLocId == "") {
		$.messager.popover({
			msg: "请选择药房!",
			type: "info",
			timeout: 1000
		});
		return;
	}
	var phLocDesc = selPhLocData.Description;

	$.messager.confirm('确认对话框', '确定设置<b>所有病区</b>为<b>' + phLocDesc + '</b>的接收科室吗？', function (r) {
		if (r) {
			var retStr = tkMakeServerCall("PHA.MOB.SendLoc.Save", "SaveAllWard", phLocId);
			var retArr = retStr.split("^");
			if (retArr[0] < 0) {
				$.messager.alert("提示", "保存失败:" + retArr[1], "warning");
				return;
			}
			$.messager.popover({
				msg: "保存成功!",
				type: "success",
				timeout: 1000
			});
			QueryCom();
		}
	})
}

// 右侧添加到
function AddToSendLoc(wardLocId) {
	// 获取药房
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	if (phLocId == "") {
		$.messager.popover({
			msg: "请选择药房!",
			type: "info",
			timeout: 1000
		});
		return;
	}
	var phLocDesc = selPhLocData.Description;

	// 获取病区数据
	var $target = $(event.target);
	var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
	var rowData = $('#gridWardLoc').datagrid('getRows')[rowIndex];
	var wardLocId = rowData.RowId;
	var wardLocDesc = rowData.Description;

	// 新增一行
	var newRowData = {
		phLocId: phLocId,
		phLocDesc: phLocDesc,
		wardLocId: wardLocId,
		wardLocDesc: wardLocDesc
	}
	PHA_GridEditor.Add({
		gridID: 'gridSendLoc',
		field: 'wardQue',
		rowData: newRowData,
		checkRow: true
	});

	// 删除一行
	$('#gridWardLoc').datagrid('deleteRow', rowIndex);
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// 文本
	validatebox: {
		type: 'validatebox',
		options: {
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	// 文本框
	checkbox: {
		type: 'icheckbox',
		options: {
			on: 'Y',
			off: 'N'
		}
	}
}

// 显示提示弹窗
function ShowHelpTips() {
	if ($('#winHelpTips').length == 0) {
		var helpHtmlStr = '';
		helpHtmlStr += '<div style="margin:10px;">';
		helpHtmlStr += '<p><b>住院药房送药路径：（西药）</b></p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;1、主要配送到各个病区；</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;2、住院移动药房大屏显示的病区和顺序。</p>';
		helpHtmlStr += '<br/>';
		helpHtmlStr += '<p><b>中药房送药路径：（中药）</b></p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;1、中药房(配药) -> 中药房(窗口) -> 发放；</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;2、中药房(配药) -> 煎药室 -> 中药房(窗口) -> 发放；</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;3、中药房(配药) -> 各个病区 -> 病区接收；</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;4、中药房(配药) -> 煎药室 -> 各个病区 -> 病区接收。</p>';
		helpHtmlStr += '</div>';

		$('<div id="winHelpTips"></div>').appendTo('body');
		$('#winHelpTips').dialog({
			width: 420,
			height: 300,
			modal: true,
			title: '接收科室/病区维护帮助',
			iconCls: 'icon-w-list',
			content: helpHtmlStr,
			closable: true
		});
	}
	$('#winHelpTips').dialog('open');
}
