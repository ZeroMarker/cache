/**
 * 名称:	 药房公共-系统管理-页面维护
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-21
 * Update: 	 Huxt 2020-03-03
 * pha/sys/v1/page.js
 */
PHA_COM.App.Csp = "pha.sys.v1.page.csp";
PHA_COM.App.Name = "SYS.PAGE";

$(function () {
	PHA_COM.ResizePanel({
		layoutId: 'layout-right',
		region: 'north',
		height: 0.6
	});

	InitDict();
	InitGridPro();
	InitGridPage();
	InitGridPageItm();
	InitEvents();

	$('#gridPro').parent().parent().css('border-radius', '0px');
});

/**
 * @description: 事件绑定
 */
function InitEvents() {
	$("#btnAdd,#btnEdit").on("click", function () {
		ShowDiagPage(this);
	});
	$("#btnAddItm,#btnEditItm").on("click", function () {
		ShowDiagPageItm(this);
	});
	$("#btnDel").on("click", Delete);
	$("#btnDelItm").on("click", DeleteItm);
	$("#btnFind").on("click", QueryPage);
	$('#isFindAll').checkbox({
		onCheckChange: function (event, value) {
			QueryPage();
		}
	});
	$("#txtPage").on("keydown", function (e) {
		if (e.keyCode == 13) {
			QueryPage();
		}
	});
	$('#btnUpItm').on('click', UpAndDownItm);
	$('#btnDownItm').on('click', UpAndDownItm);
}

/**
 * @description: 初始化字典
 */
function InitDict() {
	PHA.ComboBox("pageItmEleDR", {
		url: $URL + "?ResultSetType=Array&ClassName=PHA.SYS.Store&QueryName=PHAINEle",
		groupField: '_group'
	});
	PHA.ComboBox("proId", {
		width: 260,
		url: $URL + "?ResultSetType=Array&ClassName=PHA.SYS.Store&QueryName=DHCStkSysPro&ActiveFlag=Y"
	});
	PHA.ComboBox("pageModel", {
		width: 260,
		url: $URL + "?ResultSetType=Array&ClassName=PHA.SYS.PageCom.Query&MethodName=QueryPageModel"
	});
}

/**
 * @description: 初始化表格-产品线
 */
function InitGridPro() {
	var columns = [
		[{
				field: "RowId",
				title: '产品线Id',
				hidden: true,
				width: 100
			}, {
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
		onClickRow: function (rowIndex, rowData) {},
		onSelect: function (rowIndex, rowData) {
			QueryPage();
		},
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$(this).datagrid("selectRow", 0);
			}
			$(this).datagrid("appendRow", {
				RowId: '0',
				Description: $g('未维护')
			});
		},
		gridSave: false
	};
	PHA.Grid("gridPro", dataGridOption);
}

/**
 * @description: 初始化表格-页面
 */
function InitGridPage() {
	var columns = [
		[{
				field: "pageId",
				title: '页面ID',
				width: 100,
				hidden: true
			}, {
				field: "pageDesc",
				title: '名称',
				width: 300
			}, {
				field: "pageLink",
				title: '链接',
				width: 300
			}, {
				field: "pageModel",
				title: '页面模板代码',
				width: 200,
				hidden: true
			}, {
				field: "pageModelDesc",
				title: '页面模板',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return '<label style="color:#017bce;cursor:pointer;" onclick=OpenModelSetWin("' + rowData.pageId + '")>' + value + '</label>';
				}
			}, {
				field: "proDesc",
				title: '产品线',
				width: 150
			}, {
				field: "proId",
				title: '产品线ID',
				width: 100,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'PHAINPage'
		},
		pagination: true,
		columns: columns,
		toolbar: "#gridPageBar",
		onClickRow: function (rowIndex, rowData) {},
		onSelect: function (rowIndex, rowData) {
			QueryPageItm();
		},
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$("#gridPage").datagrid("selectRow", 0);
			} else {
				$("#gridPageItm").datagrid("clear");
			}
		},
		onDblClickRow: function (rowIndex, rowData) {
			ShowDiagPage({
				id: 'btnEdit',
				text: $g('修改')
			});
		},
		gridSave: false
	};
	PHA.Grid("gridPage", dataGridOption);
}
function QueryPage() {
	var selectedRow = $("#gridPro").datagrid("getSelected") || "";
	if (selectedRow == "") {
		return;
	}
	var proId = selectedRow.RowId || "";
	var isFindAll = $('#isFindAll').checkbox('getValue');
	if (isFindAll) {
		proId = "";
	}
	var filterText = $("#txtPage").val() || "";
	var inputStr = proId + "^" + filterText;

	$("#gridPage").datagrid('options').url = $URL;
	$("#gridPage").datagrid("query", {
		inputStr: inputStr,
	});
}
// 与pageset.js里面的一样,如修改需同时修改
function OpenModelSetWin(pageId){
	// 显示弹窗
	var winId = 'model_set_win';
	if ($('#' + winId).length == 0) {
		var tipImg = '../scripts_lib/hisui-0.1.0/dist/css/icons/tip.png';
		var layoutHtml = '';
		layoutHtml += '<div style="margin:0 10px 0 10px">';
		layoutHtml += '	<table cellspacing="10">';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="cols">' + $g('表单布局列数') + '</label></td>';
		layoutHtml += '			<td><input id="cols" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('设置表单布局列数') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="width">' + $g('左侧面板宽度') + '</label></td>';
		layoutHtml += '			<td><input id="width" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('当页面模板为左右结构时，设置左侧面板宽度(数字或比例)，其他模板设置无效') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="height">' + $g('上侧面板高度') + '</label></td>';
		layoutHtml += '			<td><input id="height" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('当页面模板为上下结构时，设置上侧面板高度(数字或比例)，其他模板设置无效') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="pkey">' + $g('查询传参') + '</label></td>';
		layoutHtml += '			<td><input id="pkey" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('查询时传参方式，根据表格查询后台的方法设置，比如后台查询Query的入参名为InputStr此处就填InputStr。填写此参数后会将所有表单值作为json串传递到后台，不填此参数默认按照单个表单参数传递。') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="query">' + $g('自动查询') + '</label></td>';
		layoutHtml += '			<td><input id="query" class="hisui-checkbox" data-pha="class:\'hisui-checkbox\',save:true,query:true,clear:true" type="checkbox" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('当页面加载完成时是否自动触发查询。') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '	</table>';
		layoutHtml += '</div>';
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: '页面模板属性',
			collapsible: false,
			minimizable: false,
			iconCls: "icon-w-edit",
			border: false,
			closed: true,
			modal: true,
			width: 335,
			height: 300,
			content: layoutHtml,
			buttons:[{
				text: '保存',
				handler: saveOtherCfg
			},{
				text: '关闭',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	$('#' + winId).attr('pageId', pageId);
	// 显示数据
	var pageOtherCfg = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'GetOtherCfg',
		pageId: pageId
	}, false);
	$('#' + winId).find('input[id]').each(function(){
		$('#' + this.id).val('');
	});
	$('#' + winId).find('#cols').val('6');
	$('#' + winId).find('#pkey').val('pJsonStr');
	for (var k in pageOtherCfg) {
		$('#' + winId).find('#' + k).val(pageOtherCfg[k]);
	}
	// 保存数据
	function saveOtherCfg(){
		var checkNumArr = ['cols', 'width', 'height'];
		var isErr = false;
		var pJson = {};
		$('#' + winId).find('input[id]').each(function(){
			if ($(this).hasClass('hisui-checkbox')) {
				pJson[this.id] = $('#' + winId).find('#' + this.id).checkbox('getValue') ? 'Y' : 'N';
			} else {
				pJson[this.id] = $('#' + winId).find('#' + this.id).val();
			}
			var lb = $('#' + winId).find("label[for='" + this.id + "']").text();
			if (checkNumArr.indexOf(this.id) >= 0 && pJson[this.id] !== '' && isNaN(parseFloat(pJson[this.id]))) {
				PHA.Alert("温馨提示", lb + "：" + "请输入数字", -1);
				isErr = true;
				return false;
			}
			if (parseFloat(pJson[this.id]) <= 0) {
				PHA.Alert("温馨提示", lb + "：" + "数字不能小于0", -1);
				isErr = true;
				return false;
			}
		});
		if (isErr)
			return;
		var pJsonStr = JSON.stringify(pJson);
		var pId = $('#' + winId).attr('pageId');
		var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'UpdOtherCfg', pId, pJsonStr);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			return PHA.Alert("温馨提示", retArr[1], retArr[0]);
		}
		$('#' + winId).dialog('close');
		PHA.Popover({
			msg: "保存成功!",
			type: "success"
		});
	}
}

/**
 * @description: 初始化表格-页面元素
 */
function InitGridPageItm() {
	var columns = [
		[{
				field: "pageItmId",
				title: 'pageItmId',
				width: 100,
				hidden: true
			}, {
				field: "pageItmDom",
				title: 'DomId',
				width: 230
			}, {
				field: "pageItmDesc",
				title: '名称',
				width: 230
			}, {
				field: "pageItmEleDesc",
				title: '类型',
				width: 150
			}, {
				field: "pageItmSortNum",
				title: '顺序号',
				width: 90,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'PHAINPageItm',
			page: 1,
			rows: 99999
		},
		pagination: false,
		rownumbers: true,
		columns: columns,
		toolbar: "#gridPageItmBar",
		onSelect: function (rowIndex, rowData) {
			$('#gridPageItm').datagrid('options').selectedRowIndex = rowIndex;
		},
		onDblClickRow: function (rowIndex, rowData) {
			$('#gridPageItm').datagrid('options').selectedRowIndex = rowIndex;
			ShowDiagPageItm({
				id: 'btnEditItm',
				text: $g('修改')
			});
		},
		onLoadSuccess: function(data){
			$('#btnUpItm').prop('disabled', '');
			$('#btnDownItm').prop('disabled', '');
			var selectedRowIndex = $(this).datagrid('options').selectedRowIndex;
			if (selectedRowIndex >= 0 && data.total > selectedRowIndex) {
				$(this).datagrid('selectRow', selectedRowIndex);
			}
		},
		gridSave: false
	};
	PHA.Grid("gridPageItm", dataGridOption);
}
function QueryPageItm() {
	var selectedRow = $("#gridPage").datagrid("getSelected") || "";
	if (selectedRow == "") {
		return;
	}
	var inputStr = selectedRow.pageId + "^" + "";

	$("#gridPageItm").datagrid('options').url = $URL;
	$("#gridPageItm").datagrid("query", {
		inputStr: inputStr,
		page: 1,
		rows: 99999
	});
}

/**
 * @description: 显示页面修改弹窗
 */
function ShowDiagPage(btnOpt) {
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var pageId = "";
	if (ifAdd == false) {
		var gridSelect = $('#gridPage').datagrid('getSelected') || "";
		if (gridSelect == "") {
			PHA.Popover({
				msg: "请选择页面!",
				type: "alert"
			});
			return;
		}
		pageId = gridSelect.pageId || "";
		if (pageId == "") {
			PHA.Popover({
				msg: "请先保存页面后修改!",
				type: "alert"
			});
			return;
		}
	}
	var gridProSelect = $('#gridPro').datagrid('getSelected') || "";
	if (gridProSelect == "") {
		PHA.Popover({
			msg: "请先选择产品线!",
			type: "alert"
		});
		return;
	}
	var proId = gridProSelect.RowId || "";
	if (proId == "" || proId == '0') {
		PHA.Popover({
			msg: "请选择有效的产品线!",
			type: "alert"
		});
		return;
	}

	$('#diagPage').dialog({
		modal: true,
		title: "页面" + btnOpt.text,
		iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
		ifAdd: ifAdd
	})
	$('#diagPage').dialog('open');
	if (ifAdd == false) {
		$("#diagPage_btnAdd").hide();
		$.cm({
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'SelectPHAINPage',
			pageId: pageId,
			ResultSetType: 'Array'
		}, function (arrData) {
			var firstRowData = arrData[0];
			PHA.SetVals([
				{
					pageDesc: firstRowData.pageDesc,
					pageLink: firstRowData.pageLink,
					proId: firstRowData.proId,
					pageModel: firstRowData.pageModel
				}
			]);
		});
		$("#proId").combobox('enable', true);
		$("#pageModel").combobox('disable', true);
	} else {
		var clearValueArr = [
			"pageDesc",
			"pageLink",
			"pageModel"
		];
		PHA.ClearVals(clearValueArr);
		PHA.SetVals([{
				proId: gridProSelect.RowId
			}
		]);
		$("#proId").combobox('disable', true);
		$("#pageModel").combobox('enable', true);
	}
}

/**
 * @description: 保存页面信息
 */
function SavePage(type) {
	var diagPageOpts = $("#diagPage").panel('options');
	var ifAdd = diagPageOpts.ifAdd;
	var pageId = "";
	if (ifAdd == false) {
		var gridSelect = $('#gridPage').datagrid('getSelected');
		pageId = gridSelect.pageId || "";
	}
	var proId = $("#proId").combobox('getValue') || "";
	if (proId == "" || proId == '0') {
		PHA.Popover({
			msg: "产品线无效!",
			type: "alert"
		});
		return;
	}

	var domIdArr = [
		"pageDesc",
		"pageLink",
		"pageModel"
	];
	var jsonDataArr = PHA.GetVals(domIdArr, "Json");
	if (jsonDataArr.length == 0) {
		return;
	}
	var jsonDataObj = jsonDataArr[0];
	jsonDataObj.proId = proId;
	var jsonDataStr = JSON.stringify(jsonDataObj);
	var pageModel = jsonDataObj.pageModel || '';
	var pageLink = jsonDataObj.pageLink || '';
	if (pageModel != '' && pageLink.substr(pageLink.length - 4).toLowerCase() == '.csp') {
		PHA.Popover({
			msg: "自定义页面其[链接]不能设置为csp!",
			type: "alert"
		});
		return;
	}
	
	/*
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'Save',
		pageId: pageId,
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	*/
	var saveRet = tkMakeServerCall('PHA.SYS.Page.Save', 'Save', pageId, jsonDataStr);
	var saveArr = saveRet.split("^");
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert("温馨提示", saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: "保存成功!",
			type: "success",
			timeout: 1000
		});
	}
	if (type == 1) {
		PHA.ClearVals(domIdArr);
		$("#pageDesc").focus();
	} else {
		$('#diagPage').dialog('close');
	}
	QueryPage();
}

/**
 * @description: 删除页面
 */
function Delete() {
	var gridSelect = $('#gridPage').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择页面!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pageId = gridSelect.pageId || "";
	var chkRet = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'CheckDelete',
		pageId: pageId,
		dataType: 'text',
	}, false);
	var chkArr = chkRet.toString().split("^");
	var delInfo = "是否确认删除?";
	if (chkArr[0] < 0) {
		delInfo += "</br>" + chkArr[1];
	}
	PHA.Confirm("温馨提示", delInfo, function () {
		var saveRet = $.cm({
			ClassName: 'PHA.SYS.Page.Save',
			MethodName: 'Delete',
			pageId: pageId,
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('温馨提示', saveInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: 'success'
			});
			QueryPage();
		}
	});
}

/**
 * @description: 页面元素修改弹窗
 */
function ShowDiagPageItm(btnOpt) {
	var gridPageSelect = $('#gridPage').datagrid('getSelected') || "";
	if (gridPageSelect == "") {
		PHA.Popover({
			msg: "请选择页面!",
			type: "alert"
		});
		return;
	}
	
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var pageItmId = "";
	if (ifAdd == false) {
		var gridSelect = $('#gridPageItm').datagrid('getSelected') || "";
		if (gridSelect == "") {
			PHA.Popover({
				msg: "请选择页面元素!",
				type: "alert"
			});
			return;
		}
		pageItmId = gridSelect.pageItmId || "";
		if (pageItmId == "") {
			PHA.Popover({
				msg: "请先保存页面元素后修改!",
				type: "alert"
			});
			return;
		}
	}
	
	$('#diagPageItm').dialog({
		modal: true,
		title: "页面元素" + btnOpt.text,
		iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
		ifAdd: ifAdd
	}).dialog('open');
	
	if (ifAdd == false) {
		$("#diagPageItm_btnAdd").hide();
		$.cm({
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'SelectPHAINPageItm',
			pageItmId: pageItmId,
			ResultSetType: 'Array'
		}, function (arrData) {
			PHA.SetVals(arrData);
			// 不允许修改的情况
			if (gridPageSelect.pageModel != '' && gridPageSelect.pageModel != null) {
				if (arrData && 
					arrData.length > 0 && 
					['gridMain', 'gridDetail', 'btnFind', 'btnClean'].indexOf(arrData[0].pageItmDom) >= 0) {
					$('#pageItmDom').prop('disabled', 'disabled');
					$("#pageItmEleDR").combobox('disable', true);
					return;
				}
			}
			$('#pageItmDom').prop('disabled', '');
			$("#pageItmEleDR").combobox('enable', true);
		});
	} else {
		var clearValueArr = [
			"pageItmDom",
			"pageItmDesc",
			"pageItmEleDR"
		];
		PHA.ClearVals(clearValueArr);
		$('#pageItmDom').prop('disabled', '');
		$("#pageItmEleDR").combobox('enable', true);
	}
}

/**
 * @description: 保存页面元素
 * @param {String} type 1(继续新增)
 */
function SavePageItm(type) {
	var diagPageItmOpts = $("#diagPageItm").panel('options');
	var ifAdd = diagPageItmOpts.ifAdd;
	var pageItmId = "";
	if (ifAdd == false) {
		var gridSelect = $('#gridPageItm').datagrid('getSelected') || {};
		pageItmId = gridSelect.pageItmId || "";
	}
	var gridPageSelect = $('#gridPage').datagrid('getSelected') || {};
	var pageId = gridPageSelect.pageId || "";
	var domIdArr = [
		"pageItmDom",
		"pageItmDesc",
		"pageItmEleDR"
	];
	var jsonDataArr = PHA.GetVals(domIdArr, "Json");
	if (jsonDataArr.length == 0) {
		return;
	}
	var jsonDataObj = jsonDataArr[0];
	jsonDataObj.pageId = pageId;
	var jsonDataStr = JSON.stringify(jsonDataObj);
	
	/*
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'SaveItm',
		pageItmId: pageItmId,
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	*/
	var saveRet = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveItm', pageItmId, jsonDataStr);
	var saveArr = saveRet.split("^");
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert("温馨提示", saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: "保存成功!",
			type: "success",
			timeout: 500
		});
	}
	if (type == 1) {
		PHA.ClearVals(domIdArr);
		$("#pageItmDom").focus();
	} else {
		$('#diagPageItm').dialog('close');
	}
	QueryPageItm();
}

/**
 * @description: 删除页面元素
 */
function DeleteItm() {
	var gridSelect = $('#gridPageItm').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择页面元素!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pageItmId = gridSelect.pageItmId || "";
	var chkRet = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'CheckDeleteItm',
		pageItmId: pageItmId,
		dataType: 'text',
	}, false);
	var chkArr = chkRet.toString().split("^");
	var delInfo = "是否确认删除?";
	if (chkArr[0] < 0) {
		delInfo += "</br>" + chkArr[1];
	}
	PHA.Confirm("温馨提示", delInfo, function () {
		var saveRet = $.cm({
			ClassName: 'PHA.SYS.Page.Save',
			MethodName: 'DeleteItm',
			pageItmId: pageItmId,
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('温馨提示', saveInfo, saveVal);
			return;
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: 'success'
			});
			QueryPageItm();
		}
	});
}

function UpAndDownItm(e){
	if ($('#btnUpItm').prop('disabled') == 'disabled') {
		PHA.Popover({
			msg: '您点击太快!',
			type: 'alert'
		});
		return;
	}
	var ret = PHA_GridEditor.__UpAndDown_Exchange({
		gridID: 'gridPageItm',
		ifUp: (e.currentTarget.id.indexOf('Up') > 0 ? true : false)
	});
	if (!ret) {
		return;
	}
	
	var selectedRow = $('#gridPageItm').datagrid('getSelected');
	var selectedRowIndex = $('#gridPageItm').datagrid('getRowIndex', selectedRow);
	$('#gridPageItm').datagrid('options').selectedRowIndex = selectedRowIndex;
	
	$('#btnUpItm').prop('disabled', 'disabled');
	$('#btnDownItm').prop('disabled', 'disabled');
	var rowsData = $('#gridPageItm').datagrid('getRows');
	var pJsonStr = JSON.stringify(rowsData);
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'UpdateItmSort',
		pJsonStr: pJsonStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('温馨提示', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: '操作成功!',
			type: 'success'
		});
		QueryPageItm();
	}
}

