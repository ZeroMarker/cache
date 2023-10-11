/*
 * @Descripttion: ���������
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
* @description ��ʼ��UI
*/
function initUI() {
	initSearchCondition();
	initAuditGrid();
	listenEvents();
}
/**
* @description ��ʼ����ѯ����
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
			{ id: 1, text: "ȫ��" },
			{ id: 2, text: "�����" },
			{ id: 3, text: "δ���" }
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
			{ id: 1, text: "����" },
			{ id: 2, text: "�ǼǺ�" }
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
		text: '���',
		handler: function () {
			audit('A');
		}
	}, '-', {
		id: 'btnCancelAudit',
		iconCls: 'icon-reset',
		text: '�������',
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
			{ field: 'BedCode', title: '����', width: 100 },
			{ field: 'PatName', title: '����', width: 100 },
			{ field: 'RegNo', title: '�ǼǺ�', width: 120 }
		]],
		columns: [[
			{ field: 'Sex', title: '�Ա�', width: 120 },
			{ field: 'Age', title: '����', width: 120 },
			{ field: 'AdmLocDesc', title: '�������', width: 150 },
			{ field: 'DischDateTime', title: '��Ժʱ��', width: 180 },
			{ field: 'AuditUserName', title: '�����', width: 120 },
			{ field: 'AuditDateTime', title: '���ʱ��', width: 180 },
			{ field: 'CancelUserName', title: '���������', width: 120, hidden: true },
			{ field: 'CancelDateTime', title: '�������ʱ��', width: 180, hidden: true },
			{ field: 'DischDateTime', title: '��Ժʱ��', width: 180 },
			{ field: 'EpisodeId', title: '�����', width: 120, hidden: true },
			{ field: 'Id', title: 'ID', width: 120, hidden: true }
		]],
		toolbar: toolbar,
		rownumbers: true,
		pagination: true,  //�Ƿ��ҳ
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
 * @description: ���
 */
function audit(type) {
	var selRows = $('#gridAudit').datagrid('getSelections');
	if (selRows == 0) {
		$.messager.alert('��ʾ', $g('��ѡ���¼'), 'info');
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
				msg: $g('�����ɹ���'),
				type: 'success',
				style: {
					bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
					right: 10
				}
			});
		} else {
			$.messager.popover({
				msg: $g('����ʧ�ܣ�'),
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
 * @description: �¼�����
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
			$.messager.alert('��ʾ', $g('��ѡ���¼'), 'info');
			return false;
		}
		var admId = selRows[0].Id;
		var lnk = "dhc.nurse.vue.mainentry.csp?ViewName=TemperatureMeasureMutiply&EpisodeID=" + EpisodeID;
		window.open(buildMWTokenUrl(lnk), "htm", 'toolbar=no,left=0,top=0,location=no,directories=no,resizable=yes,width=' + screen.availWidth + ',height=' + screen.availHeight);
	});
	$('#btnRecord').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('��ʾ', $g('��ѡ���¼'), 'info');
			return false;
		}
		var admId = selRows[0].Id;
		var lnk = "nur.hisui.nursingRecords.csp?EpisodeID=" + EpisodeID;
		window.open(buildMWTokenUrl(lnk), "htm", 'toolbar=no,left=0,top=0,location=no,directories=no,resizable=yes,width=' + screen.availWidth + ',height=' + screen.availHeight);
	});
	$('#btnOrderSheet').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('��ʾ', $g('��ѡ���¼'), 'info');
			return false;
		}

	});
	$('#btnOrderSearch').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('��ʾ', $g('��ѡ���¼'), 'info');
			return false;
		}

	});
	$('#btnOrderCheck').bind('click', function () {
		var selRows = $('#gridAudit').datagrid('getSelections');
		if (selRows == 0) {
			$.messager.alert('��ʾ', $g('��ѡ���¼'), 'info');
			return false;
		}

	});
}