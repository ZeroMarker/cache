/*
 * @Descripttion: 护理病历审核
 * @Author: yaojining
 * @Date: 2022-01-07 15:48:48
 */
$(function () {
	initUI();
});
var GLOBAL = {
	HospitalID: session['LOGON.HOSPID'],
	WardID: session['LOGON.WARDID'],
	UserID: session['LOGON.USERID']
}
/**
* @description 初始化UI
*/
function initUI() {
	initSearchCondition();
	initAuditGrid();
	listenEvents();
}
/**
* @description 初始化查询条件
*/
function initSearchCondition() {
	$("#cbWard").combobox({
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=NurMp.Common.Base.Loc&MethodName=GetWards&HospitalID=' + GLOBAL.HospitalID,
		value: GLOBAL.WardID,
		defaultFilter: 4,
		onSelect: function (rec) {
			$('#btnFind').click();
		}
	});
	$('#startDate').datebox('setValue', 'Today');
	$('#endDate').datebox('setValue', 'Today');
	$("#cbStatus").combobox({
		valueField: 'id',
		textField: 'text',
		value: 1,
		data: [
			{ id: 1, text: "全部" },
			{ id: 2, text: "已审核" },
			{ id: 3, text: "未审核" }
		],
		onChange: function (newval, oldval) {
			$('#btnFind').click();
		},
		defaultFilter: 4
	});
	$("#cbSearchKey").combobox({
		valueField: 'id',
		textField: 'text',
		value: 1,
		data: [
			{ id: 1, text: "姓名" },
			{ id: 2, text: "登记号" }
		],
		onChange: function (newval, oldval) {
			$('#btnFind').click();
		},
		defaultFilter: 4
	});
	$('#sbSearchDesc').searchbox({
		searcher: function (value) {
			$('#btnFind').click();
		}
	});
}
function initAuditGrid() {
	var toolbar = [{
		id: 'btnAudit',
		iconCls: 'icon-ok',
		text: '审核',
		handler: function () {
			audit('A');
		}
	}, '-', {
		id: 'btnCancelAudit',
		iconCls: 'icon-reset',
		text: '撤销审核',
		handler: function () {
			audit('U');
		}
	}];
	$('#gridAudit').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'NurMp.Service.Patient.Audit',
			QueryName: 'FindDischPat',
			Parr: $('#cbWard').combobox('getValue') + '^' + $('#startDate').datebox('getValue') + '^' + $('#endDate').datebox('getValue') + '^' + $('#cbStatus').combobox('getValue') + '^' + $('#cbSearchKey').combobox('getValue') + '^' + $('#sbSearchDesc').searchbox('getValue')
		},
		nowrap: false,
		frozenColumns: [[
			{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'BedCode', title: '床号', width: 100 },
			{ field: 'PatName', title: '姓名', width: 100 },
			{ field: 'RegNo', title: '登记号', width: 120 }
		]],
		columns: [[
			{ field: 'Sex', title: '性别', width: 120 },
			{ field: 'Age', title: '年龄', width: 120 },
			{ field: 'AdmLocDesc', title: '就诊科室', width: 150 },
			{ field: 'DischDateTime', title: '出院时间', width: 180 },
			{ field: 'AuditUserName', title: '审核人', width: 120 },
			{ field: 'AuditDateTime', title: '审核时间', width: 180 },
			{ field: 'CancelUserName', title: '撤销审核人', width: 120, hidden: true },
			{ field: 'CancelDateTime', title: '撤销审核时间', width: 180, hidden: true },
			{ field: 'DischDateTime', title: '出院时间', width: 180 },
			{ field: 'EpisodeId', title: '就诊号', width: 120, hidden: true },
			{ field: 'Id', title: 'ID', width: 120, hidden: true }
		]],
		toolbar: toolbar,
		rownumbers: true,
		pagination: true,  //是否分页
		pageSize: 15,
		pageList: [15, 30, 50],
		singleSelect: false,
		rowStyler: function (rowIndex, rowData) {
			if (!!rowData.AuditDateTime.trim()) {
				return 'background-color:lightblue;';
			}
		},
		onRowContextMenu: function (e, rowIndex, rowData) {
			e.preventDefault();
			$(this).datagrid("clearSelections");
			$(this).datagrid("selectRow", rowIndex);
			$('#menuAudit').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
			e.preventDefault();
		}
	});
}
/**
 * @description: 审核
 */
function audit(type) {
	var selRows = $('#gridAudit').datagrid('getSelections');
	if (selRows == 0) {
		$.messager.alert('提示', $g('请选择记录'), 'info');
		return false;
	}
	var admIds = "";
	$.each(selRows, function (index, row) {
		if (!!row.EpisodeId) {
			admIds = !!admIds ? admIds + '^' + row.EpisodeId : row.EpisodeId;
		}
	});
	$m({
		ClassName: 'NurMp.Service.Patient.Audit',
		MethodName: 'AuditPat',
		EpisodeIds: admIds,
		Type: type,
		UserID: GLOBAL.UserID
	}, function (result) {
		if (result == 0) {
			$('#btnFind').click();
			$.messager.popover({
				msg: $g('操作成功！'),
				type: 'success',
				style: {
					bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
					right: 10
				}
			});
		} else {
			$.messager.popover({
				msg: $g('操作失败！'),
				type: 'error',
				style: {
					bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
					right: 10
				}
			});
		}
	});
}
/**
 * @description: 事件监听
 */
function listenEvents() {
	$('#btnFind').bind('click', function () {
		$('#gridAudit').datagrid('reload', {
			ClassName: 'NurMp.Service.Patient.Audit',
			QueryName: 'FindDischPat',
			Parr: $('#cbWard').combobox('getValue') + '^' + $('#startDate').datebox('getValue') + '^' + $('#endDate').datebox('getValue') + '^' + $('#cbStatus').combobox('getValue') + '^' + $('#cbSearchKey').combobox('getValue') + '^' + $('#sbSearchDesc').searchbox('getValue')
		});
		$('#gridAudit').datagrid('clearSelections');
	});
	$('#btnObs').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('提示', $g('请选择记录'), 'info');
			return false;
		}
		var admId = selRows[0].Id;
		var lnk = "dhc.nurse.vue.mainentry.csp?ViewName=TemperatureMeasureMutiply&EpisodeID=" + EpisodeID;
		window.open(buildMWTokenUrl(lnk), "htm", 'toolbar=no,left=0,top=0,location=no,directories=no,resizable=yes,width=' + screen.availWidth + ',height=' + screen.availHeight);
	});
	$('#btnRecord').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('提示', $g('请选择记录'), 'info');
			return false;
		}
		var admId = selRows[0].Id;
		var lnk = "nur.hisui.nursingRecords.csp?EpisodeID=" + EpisodeID;
		window.open(buildMWTokenUrl(lnk), "htm", 'toolbar=no,left=0,top=0,location=no,directories=no,resizable=yes,width=' + screen.availWidth + ',height=' + screen.availHeight);
	});
	$('#btnOrderSheet').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('提示', $g('请选择记录'), 'info');
			return false;
		}

	});
	$('#btnOrderSearch').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('提示', $g('请选择记录'), 'info');
			return false;
		}

	});
	$('#btnOrderCheck').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('提示', $g('请选择记录'), 'info');
			return false;
		}

	});
}