/*
 * @Descripttion: 护理病历业务主界面
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
 * @description: 入口
 */
$(function () {
	if (typeof updateStyle == 'function') {
		updateStyle();
	}
	checkVersion();
});

/**
 * @description: 检查版本
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
 * @description: 获取开关配置数据
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
 * @description: 初始化布局
 */
function initLayout() {
	if ($('#patientTree').length > 0) {
		// 当选择了就诊记录后，进入界面自动收缩面板
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
 * @description: 自定义数据装载
 * @param {*} data
 */
function beforeLoadData(data) {
	GV.ArrSort = data.ArrSort;
}

/**
 * @description: 自定义病人tree加载成功后的处理
 * @param {*} node
 * @param {*} data
 */
function customPatTreeLoadSuccess(node, data) {
	GV.PatNode = $('#patientTree').tree('getSelected');
}

/**
 * @description: 自定义点击病人列表事件
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
	// 当选择了就诊记录后，进入界面自动收缩面板
	if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
		$('.main-layout').layout('collapse', 'west');
	}
	//更新护理病历表单
	if (typeof refreshTempTree == 'function') {
		var currentTab = $('#recordTabs').tabs('getSelected');
		var index = $('#recordTabs').tabs('getTabIndex', currentTab);
		updateRecordTabByIndex(index, true);
	}
}

/**
 * @description: 自定义病人列表右键菜单
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
 * @description: 自定义模板tree加载成功后的处理
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
 * @description: 自定义模板点击事件
 * @param {object} node
 */
function customClickTemplate(node) {
	if (typeof (openRecord) == 'function') {
		openRecord(node);
	}
}

/**
 * @description: 自定义模板列表的右键菜单
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
	// 判断是否是更多弹窗
	var moreWindowFlag = !$('#windowMore').parent().is(':hidden');
	if (!moreWindowFlag) {
		// 登记号
		var regNo = !!GV.PatNode ? GV.PatNode.regNo : '';
		// 病人就诊状态
		var visitStatus = !!GV.PatNode ? GV.PatNode.visitStatus : '';
		// 出院天数
		var outDays = !!GV.PatNode ? GV.PatNode.outDays : 0;
		//操作日志
		var ifGotoLog = JSON.parse(node.GotoUrl);
		//出院病历编辑控制
		var ifOutEdit = JSON.parse(node.OutPatientEditFlag);
		//出院病历编辑限制天数
		var editDays = parseFloat(node.OutPatientEditDays);
		if (ifGotoLog) {
			initMenuTemplate(node, 'operationLog', $g('操作日志'), 'icon-green-line-eye', 'nur.hisui.nurseRecordLog.csp', node.UrlParameter, '');
			emptyFlag = false;
		}
		if ((visitStatus == 'D') && (ifOutEdit) && (outDays >= editDays)) {
			initMenuTemplate(node, 'outPatEdit', $g('出院病历操作申请'), 'icon-checkin', 'nur.emr.dischargerecordauthorizeapply.csp', '?mouldType=HLBL&regNo=' + regNo, 165);
			emptyFlag = false;
		}
	} else {
		var tab = $('#templateTabs').tabs('getSelected');
		if (tab) {
			var showType = tab.children(0).attr('showType');
			if (showType == 'A') {
				tmpGuid = node.id;
				initMenuTemplate(node, 'addIntoModel', $g('移入科室模板'), 'icon-redo', '', '', 150);
				emptyFlag = false;
			} else if (showType == 'L') {
				tmpGuid = node.id;
				initMenuTemplate(node, 'removeFromModel', $g('移出科室模板'), 'icon-arrow-left-top', '', '', 150);
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
 * @description: 打开更多模板
 * @param {string} locRootId
 */
function setLocRootId(locRootId) {
	GV.LocRootId = locRootId;
}

/**
 * @description: 自定义模板列表改变状态
 * @param {object} node
 */
function customChangeState(node) {
	GV.TempNodeState[node.id] = node.state;
}