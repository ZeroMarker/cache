/*
 * @Descripttion: ���������ξ����¼
 * @Author: yaojining
 * @Date: 2022-01-11 10:07:00
 */
var GV = {
	BaseFlag: true,
	SwitchInfo: new Object(),
	CurrentAdmId: '',
	TempNodeState: new Object(),
	LocRootId: null,
	Steps: ['banner', 'templist', 'recordtab', 'dialog']
};

/**
 * @description: ���
 */
$(function () {
	if (typeof updateStyle == 'function') {
		updateStyle();
	}
	requestSwitch();
});

/**
 * @description: ��ȡ������������
 */
function requestSwitch() {
	$cm({
		ClassName: 'NurMp.Service.Switch.Config',
		MethodName: 'GetSwitchValues',
		HospitalID: session['LOGON.HOSPID'],
		LocID: session['LOGON.CTLOCID'],
		GroupID: session['LOGON.GROUPID']
	}, function (switchInfo) {
		GV.SwitchInfo = switchInfo.Main;
		initSearchCondition();
		initGridAdm();
		listenEvents();
		if (typeof updatePatBanner == 'function') {
			updatePatBanner();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
		}
		if (typeof requestTemplate == 'function') {
			requestTemplate();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('templist');
			}
		}
		if (typeof initRecordTab == 'function') {
			initRecordTab();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('recordtab');
			}
		}
		if (typeof initDialog == 'function') {
			initDialog();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('dialog');
			}
		}
	});
}

/**
* @description ��ʼ����ѯ����
*/
function initSearchCondition() {
	var inHospDate = getInHospDateTime(GV.CurrentAdmId);
	var serverDateTime = getServerDateTime();
	$('#startDate').dateboxq('setValue', inHospDate);
	$('#endDate').dateboxq('setValue', serverDateTime.date);
	$('#swType').switchbox('options').onSwitchChange = function () {
		$('#btnFind').click();
	};
}
/**
 * @description: ��ʼ�����
 */
function initGridAdm() {
	$('#gridAdms').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'NurMp.Service.Patient.List',
			QueryName: 'FindAllVisitInfo',
			EpisodeID: GV.CurrentAdmId,
			StartDate: $('#startDate').dateboxq('getValue'),
			EndDate: $('#endDate').dateboxq('getValue'),
			AllVisit: $('#swType').switchbox('getValue')
		},
		columns: [[
			{ field: 'PatName', title: '����', align: 'left', width: 120 },
			{ field: 'AdmType', title: '����', align: 'center', width: 40, formatter: showAdmType },
			{ field: 'AdmDateTime', title: '����ʱ��', align: 'center', width: 160 },
			{ field: 'AdmId', title: '�����', align: 'center', width: 100 },
			{ field: 'DischDateTime', title: '��Ժʱ��', align: 'center', width: 160 },
			{ field: 'PatientId', title: '����ID', align: 'center', width: 100 },
		]],
		nowrap: true,
		singleSelect: true,
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		displayMsg: '',
		onLoadSuccess: onLoadSuccess,
		onClickRow: function (rowIndex, rowData) {
			clickAmd(rowData);
		}
	});
}
/**
 * @description: ���سɹ�֮��
 * @param {} data
 */
function onLoadSuccess(data) {
	var rows = $('#gridAdms').datagrid('getRows');
	$.each(rows, function (index, row) {
		if (row.AdmId == GV.CurrentAdmId) {
			$('#gridAdms').datagrid('selectRow', index);
		}
	});
}
/**
 * @description: �����¼���
 * @param {*} rowData
 * @return {*}
 */
function clickAmd(rowData) {
	if (!rowData.AdmId) {
		return false;
	}
	var node = { episodeID: GV.CurrentAdmId, patientID: rowData.PatientId };
	passPatientToMenu(node);
	EpisodeID = rowData.AdmId;
	if (typeof updatePatBanner == 'function') {
		updatePatBanner();
	}
	if (typeof refreshTempTree == 'function') {
		refreshTempTree();
	}
	//���»�������
	if (typeof refreshTempTree == 'function') {
		var currentTab = $('#recordTabs').tabs('getSelected');
		var index = $('#recordTabs').tabs('getTabIndex', currentTab);
		updateRecordTabByIndex(index, true);
	}
}
/**
 * @description: ��ʽ������
 * @param {*} value
 * @param {*} row
 * @param {*} index
 * @return {*}
 */
function showAdmType(value, row, index) {
	if (row.AdmType == 'E') {
		return "<a class='icon icon-emergency' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
	} else if (row.AdmType == 'O') {
		return "<a class='icon icon-outpatient' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
	} else if (row.AdmType == 'I') {
		return "<a class='icon icon-inpatient' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
	} else {
		return value;
	}
}
/**
 * @description: �Զ���ģ��tree���سɹ���Ĵ���
 * @param {*} node
 * @param {*} data
 */
function customTempTreeLoadSuccess(node, data) {
	var _this = this;
	if (!$.isEmptyObject(GV.TempNodeState)) {
		$.each(GV.TempNodeState, function (id, state) {
			var selRoot = $(_this).tree('find', id);
			if (selRoot) {
				if (state == 'open') {
					$(_this).tree('expand', selRoot.target);
				} else {
					$(_this).tree('collapse', selRoot.target);
				}
			}
		});
	}
}

/**
 * @description: �Զ���ģ�����¼�
 * @param {object} node
 */
function customClickTemplate(node) {
	if (typeof (openRecord) == 'function') {
		openRecord(node);
	}
}

/**
 * @description: �Զ���ģ���б���Ҽ��˵�
 * @param {*} event
 * @param {object} node
 * @param {string} moreWindowFlag
 */
function customTempTreeMenu(event, node) {
	if ($('#menuTemplate').length == 0) {
		return;
	}
	$('#menuTemplate').empty();
	event.preventDefault();
	var emptyFlag = true;
	// �ж��Ƿ��Ǹ��൯��
	var moreWindowFlag = !$('#windowMore').parent().is(':hidden');
	if (!moreWindowFlag) {
		// ���˾���״̬
		var visitStatus = !!GV.PatNode ? GV.PatNode.visitStatus : '';
		// ��Ժ����
		var outDays = !!GV.PatNode ? GV.PatNode.outDays : 0;
		//������־
		var ifGotoLog = JSON.parse(node.GotoUrl);
		//��Ժ�����༭����
		var ifOutEdit = JSON.parse(node.OutPatientEditFlag);
		//��Ժ�����༭��������
		var editDays = parseFloat(node.OutPatientEditDays);
		if (ifGotoLog) {
			initMenuTemplate(node, 'operationLog', $g('������־'), 'icon-green-line-eye', 'nur.hisui.nurseRecordLog.csp', node.UrlParameter, '');
			emptyFlag = false;
		}
		if ((visitStatus == 'D') && (ifOutEdit) && (outDays >= editDays)) {
			initMenuTemplate(node, 'outPatEdit', $g('��Ժ������������'), 'icon-checkin', 'NurMp.Quality.AuthorityV2.csp', '', 165);
			emptyFlag = false;
		}
	} else {
		var tab = $('#templateTabs').tabs('getSelected');
		if (tab) {
			var showType = tab.children(0).attr('showType');
			if (showType == 'A') {
				tmpGuid = node.id;
				initMenuTemplate(node, 'addIntoModel', $g('�������ģ��'), 'icon-redo', '', '', 150);
				emptyFlag = false;
			} else if (showType == 'L') {
				tmpGuid = node.id;
				initMenuTemplate(node, 'removeFromModel', $g('�Ƴ�����ģ��'), 'icon-arrow-left-top', '', '', 150);
				emptyFlag = false;
			}
		}

	}
	if (!emptyFlag) {
		$('#menuTemplate').menu('show', {
			left: event.pageX,
			top: event.pageY
		});
	}
}

/**
 * @description: �򿪸���ģ��
 * @param {string} locRootId
 */
function setLocRootId(locRootId) {
	GV.LocRootId = locRootId;
}

/**
 * @description: �Զ���ģ���б�ı�״̬
 * @param {object} node
 */
function customChangeState(node) {
	GV.TempNodeState[node.id] = node.state;
}

/**
* @description �����¼�
*/
function listenEvents() {
	$('#btnFind').bind('click', function () {
		$('#gridAdms').datagrid('reload', {
			ClassName: 'NurMp.Service.Patient.List',
			QueryName: 'FindAllVisitInfo',
			EpisodeID: EpisodeID,
			StartDate: $('#startDate').dateboxq('getValue'),
			EndDate: $('#endDate').dateboxq('getValue'),
			AllVisit: $('#swType').switchbox('getValue')
		});
	});
}