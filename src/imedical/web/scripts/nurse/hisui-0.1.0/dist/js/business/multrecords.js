/*
 * @Descripttion: 护理病历历次就诊记录
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
 * @description: 入口
 */
$(function () {
	if (typeof updateStyle == 'function') {
		updateStyle();
	}
	requestSwitch();
});

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
* @description 初始化查询条件
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
 * @description: 初始化表格
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
			{ field: 'PatName', title: '姓名', align: 'left', width: 120 },
			{ field: 'AdmType', title: '类型', align: 'center', width: 40, formatter: showAdmType },
			{ field: 'AdmDateTime', title: '就诊时间', align: 'center', width: 160 },
			{ field: 'AdmId', title: '就诊号', align: 'center', width: 100 },
			{ field: 'DischDateTime', title: '出院时间', align: 'center', width: 160 },
			{ field: 'PatientId', title: '病人ID', align: 'center', width: 100 },
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
 * @description: 加载成功之后
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
 * @description: 就诊记录点击
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
	//更新护理病历表单
	if (typeof refreshTempTree == 'function') {
		var currentTab = $('#recordTabs').tabs('getSelected');
		var index = $('#recordTabs').tabs('getTabIndex', currentTab);
		updateRecordTabByIndex(index, true);
	}
}
/**
 * @description: 格式化类型
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
			initMenuTemplate(node, 'outPatEdit', $g('出院病历操作申请'), 'icon-checkin', 'NurMp.Quality.AuthorityV2.csp', '', 165);
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

/**
* @description 监听事件
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