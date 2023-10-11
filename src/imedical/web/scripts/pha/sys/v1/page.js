/**
 * ����:	 ҩ������-ϵͳ����-ҳ��ά��
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-21
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
 * @description: �¼���
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
 * @description: ��ʼ���ֵ�
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
 * @description: ��ʼ�����-��Ʒ��
 */
function InitGridPro() {
	var columns = [
		[{
				field: "RowId",
				title: '��Ʒ��Id',
				hidden: true,
				width: 100
			}, {
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
				Description: $g('δά��')
			});
		},
		gridSave: false
	};
	PHA.Grid("gridPro", dataGridOption);
}

/**
 * @description: ��ʼ�����-ҳ��
 */
function InitGridPage() {
	var columns = [
		[{
				field: "pageId",
				title: 'ҳ��ID',
				width: 100,
				hidden: true
			}, {
				field: "pageDesc",
				title: '����',
				width: 300
			}, {
				field: "pageLink",
				title: '����',
				width: 300
			}, {
				field: "pageModel",
				title: 'ҳ��ģ�����',
				width: 200,
				hidden: true
			}, {
				field: "pageModelDesc",
				title: 'ҳ��ģ��',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return '<label style="color:#017bce;cursor:pointer;" onclick=OpenModelSetWin("' + rowData.pageId + '")>' + value + '</label>';
				}
			}, {
				field: "proDesc",
				title: '��Ʒ��',
				width: 150
			}, {
				field: "proId",
				title: '��Ʒ��ID',
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
				text: $g('�޸�')
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
// ��pageset.js�����һ��,���޸���ͬʱ�޸�
function OpenModelSetWin(pageId){
	// ��ʾ����
	var winId = 'model_set_win';
	if ($('#' + winId).length == 0) {
		var tipImg = '../scripts_lib/hisui-0.1.0/dist/css/icons/tip.png';
		var layoutHtml = '';
		layoutHtml += '<div style="margin:0 10px 0 10px">';
		layoutHtml += '	<table cellspacing="10">';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="cols">' + $g('����������') + '</label></td>';
		layoutHtml += '			<td><input id="cols" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('���ñ���������') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="width">' + $g('��������') + '</label></td>';
		layoutHtml += '			<td><input id="width" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ҳ��ģ��Ϊ���ҽṹʱ��������������(���ֻ����)������ģ��������Ч') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="height">' + $g('�ϲ����߶�') + '</label></td>';
		layoutHtml += '			<td><input id="height" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ҳ��ģ��Ϊ���½ṹʱ�������ϲ����߶�(���ֻ����)������ģ��������Ч') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="pkey">' + $g('��ѯ����') + '</label></td>';
		layoutHtml += '			<td><input id="pkey" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ѯʱ���η�ʽ�����ݱ���ѯ��̨�ķ������ã������̨��ѯQuery�������ΪInputStr�˴�����InputStr����д�˲�����Ὣ���б�ֵ��Ϊjson�����ݵ���̨������˲���Ĭ�ϰ��յ������������ݡ�') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="query">' + $g('�Զ���ѯ') + '</label></td>';
		layoutHtml += '			<td><input id="query" class="hisui-checkbox" data-pha="class:\'hisui-checkbox\',save:true,query:true,clear:true" type="checkbox" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ҳ��������ʱ�Ƿ��Զ�������ѯ��') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '	</table>';
		layoutHtml += '</div>';
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: 'ҳ��ģ������',
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
				text: '����',
				handler: saveOtherCfg
			},{
				text: '�ر�',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	$('#' + winId).attr('pageId', pageId);
	// ��ʾ����
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
	// ��������
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
				PHA.Alert("��ܰ��ʾ", lb + "��" + "����������", -1);
				isErr = true;
				return false;
			}
			if (parseFloat(pJson[this.id]) <= 0) {
				PHA.Alert("��ܰ��ʾ", lb + "��" + "���ֲ���С��0", -1);
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
			return PHA.Alert("��ܰ��ʾ", retArr[1], retArr[0]);
		}
		$('#' + winId).dialog('close');
		PHA.Popover({
			msg: "����ɹ�!",
			type: "success"
		});
	}
}

/**
 * @description: ��ʼ�����-ҳ��Ԫ��
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
				title: '����',
				width: 230
			}, {
				field: "pageItmEleDesc",
				title: '����',
				width: 150
			}, {
				field: "pageItmSortNum",
				title: '˳���',
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
				text: $g('�޸�')
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
 * @description: ��ʾҳ���޸ĵ���
 */
function ShowDiagPage(btnOpt) {
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var pageId = "";
	if (ifAdd == false) {
		var gridSelect = $('#gridPage').datagrid('getSelected') || "";
		if (gridSelect == "") {
			PHA.Popover({
				msg: "��ѡ��ҳ��!",
				type: "alert"
			});
			return;
		}
		pageId = gridSelect.pageId || "";
		if (pageId == "") {
			PHA.Popover({
				msg: "���ȱ���ҳ����޸�!",
				type: "alert"
			});
			return;
		}
	}
	var gridProSelect = $('#gridPro').datagrid('getSelected') || "";
	if (gridProSelect == "") {
		PHA.Popover({
			msg: "����ѡ���Ʒ��!",
			type: "alert"
		});
		return;
	}
	var proId = gridProSelect.RowId || "";
	if (proId == "" || proId == '0') {
		PHA.Popover({
			msg: "��ѡ����Ч�Ĳ�Ʒ��!",
			type: "alert"
		});
		return;
	}

	$('#diagPage').dialog({
		modal: true,
		title: "ҳ��" + btnOpt.text,
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
 * @description: ����ҳ����Ϣ
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
			msg: "��Ʒ����Ч!",
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
			msg: "�Զ���ҳ����[����]��������Ϊcsp!",
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
		PHA.Alert("��ܰ��ʾ", saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: "����ɹ�!",
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
 * @description: ɾ��ҳ��
 */
function Delete() {
	var gridSelect = $('#gridPage').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ��ҳ��!",
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
	var delInfo = "�Ƿ�ȷ��ɾ��?";
	if (chkArr[0] < 0) {
		delInfo += "</br>" + chkArr[1];
	}
	PHA.Confirm("��ܰ��ʾ", delInfo, function () {
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
			PHA.Alert('��ܰ��ʾ', saveInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�!',
				type: 'success'
			});
			QueryPage();
		}
	});
}

/**
 * @description: ҳ��Ԫ���޸ĵ���
 */
function ShowDiagPageItm(btnOpt) {
	var gridPageSelect = $('#gridPage').datagrid('getSelected') || "";
	if (gridPageSelect == "") {
		PHA.Popover({
			msg: "��ѡ��ҳ��!",
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
				msg: "��ѡ��ҳ��Ԫ��!",
				type: "alert"
			});
			return;
		}
		pageItmId = gridSelect.pageItmId || "";
		if (pageItmId == "") {
			PHA.Popover({
				msg: "���ȱ���ҳ��Ԫ�غ��޸�!",
				type: "alert"
			});
			return;
		}
	}
	
	$('#diagPageItm').dialog({
		modal: true,
		title: "ҳ��Ԫ��" + btnOpt.text,
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
			// �������޸ĵ����
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
 * @description: ����ҳ��Ԫ��
 * @param {String} type 1(��������)
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
		PHA.Alert("��ܰ��ʾ", saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: "����ɹ�!",
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
 * @description: ɾ��ҳ��Ԫ��
 */
function DeleteItm() {
	var gridSelect = $('#gridPageItm').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ��ҳ��Ԫ��!",
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
	var delInfo = "�Ƿ�ȷ��ɾ��?";
	if (chkArr[0] < 0) {
		delInfo += "</br>" + chkArr[1];
	}
	PHA.Confirm("��ܰ��ʾ", delInfo, function () {
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
			PHA.Alert('��ܰ��ʾ', saveInfo, saveVal);
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�!',
				type: 'success'
			});
			QueryPageItm();
		}
	});
}

function UpAndDownItm(e){
	if ($('#btnUpItm').prop('disabled') == 'disabled') {
		PHA.Popover({
			msg: '�����̫��!',
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
		PHA.Alert('��ܰ��ʾ', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: '�����ɹ�!',
			type: 'success'
		});
		QueryPageItm();
	}
}

