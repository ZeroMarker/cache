/*
 * @Descripttion: ������ҵ��������
 * @Author: yaojining
 */

var GV = {
	BaseFlag: true,
	SwitchInfo: new Object(),
	ArrSort: new Object(),
	PatNode: new Object(),
	TempNodeState: new Object(),
	LocRootId: null,
	Steps: ['banner', 'patlist', 'templist', 'recordtab', 'dialog'],
	TransPage: 'nur.hisui.nursingRecords.csp'
};

/**
 * @description: ���
 */
$(function () {
	if (typeof updateStyle == 'function') {
		updateStyle();
	}
	checkVersion();
});

/**
 * @description: ���汾
 */
function checkVersion() {
	$m({
		ClassName: 'NurMp.Service.Editor.Update',
		MethodName: 'GetUpdateLog'
	}, function (result) {
		if (result == '-1') {
			updateEmr(requestSwitch);
		} else if (result == '0') {
			requestSwitch();
		} else {
			$.messager.popover({ msg: result, type: 'error', timeout: 1000 });
			requestSwitch();
		}
	});
}

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
		initLayout();
		if (typeof updatePatBanner == 'function') {
			updatePatBanner();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
		}
		if (typeof requestPatient == 'function') {
			requestPatient();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('patlist');
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
 * @description: ��ʼ������
 */
function initLayout() {
	if ($('#patientTree').length > 0) {
		// ��ѡ���˾����¼�󣬽�������Զ��������
		if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
			setTimeout(function () {
				$('.main-layout').layout('collapse', 'west');
			}, 200);
		}
	}
	if ($('#curTemplateTree').length > 0) {
		if (GV.SwitchInfo.TemplatePanelExpandFlag == 'true') {
			setTimeout(function () {
				$('.content-layout').layout('collapse', 'west');
			}, 300);
		}
	}
}

/**
 * @description: �Զ�������װ��
 * @param {*} data
 */
function beforeLoadData(data) {
	GV.ArrSort = data.ArrSort;
}

/**
 * @description: �Զ��岡��tree���سɹ���Ĵ���
 * @param {*} node
 * @param {*} data
 */
function customPatTreeLoadSuccess(node, data) {
	GV.PatNode = $('#patientTree').tree('getSelected');
}

/**
 * @description: �Զ����������б��¼�
 * @param {object} node
 */
function customClickPatient(node) {
	GV.PatNode = node;
	if (typeof updatePatBanner == 'function') {
		updatePatBanner();
	}
	if (typeof refreshTempTree == 'function') {
		refreshTempTree();
	}
	// ��ѡ���˾����¼�󣬽�������Զ��������
	if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
		$('.main-layout').layout('collapse', 'west');
	}
	//���»�������
	if (typeof refreshTempTree == 'function') {
		var currentTab = $('#recordTabs').tabs('getSelected');
		var index = $('#recordTabs').tabs('getTabIndex', currentTab);
		updateRecordTabByIndex(index, true);
	}
}

/**
 * @description: �Զ��岡���б��Ҽ��˵�
 * @param {*} event
 * @param {*} node
 */
function customPatTreeMenu(event, node) {
	if (GV.SwitchInfo.PlaceFileFlag == 'true' && node.visitStatus == 'D') {
		GV.PatNode = node;
		initPatTreeMenu(node);
		event.preventDefault();
		$('#patientTree').tree('select', node.target);
		$('#menuTree').menu('show', {
			left: event.pageX,
			top: event.pageY
		});
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
		// �ǼǺ�
		var regNo = !!GV.PatNode ? GV.PatNode.regNo : '';
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
			initMenuTemplate(node, 'outPatEdit', $g('��Ժ������������'), 'icon-checkin', 'nur.emr.dischargerecordauthorizeapply.csp', '?mouldType=HLBL&regNo=' + regNo, 165);
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