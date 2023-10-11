/*
 * @Descripttion: 护理病历操作日志
 * @Author: yaojining
 */

var GV = {
	BaseFlag: true,
	SwitchInfo: new Object(),
	ArrSort: new Object(),
	PatNode: new Object(),
	TempNodeState: new Object(),
	ClassName: 'NurMp.Service.Template.Log',
	Steps: ['banner', 'patlist', 'templist', 'dialog']
}

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
		if (typeof initDialog == 'function') {
			initDialog();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('dialog');
			}
		}
		initSearchCondition();
		initOperationLogGrid();
		initLeaveMarkLogGrid();
		listenEvents();
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
* @description 初始化查询条件
*/
function initSearchCondition() {
	var date = new Date();
	//date.setDate(2);
	var dateText = $('#startDate').dateboxq('options').formatter(date);
	$('#startDate').dateboxq('setValue', dateText);
	$('#endDate').dateboxq('setValue', dateText);
	$("#opType").combobox({
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=' + GV.ClassName + '&MethodName=opTypes',
		defaultFilter: 4,
		onSelect: function (rec) {
			reloadOpGrid();
		}
	});
	$("#opUser").combobox({
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=' + GV.ClassName + '&MethodName=opUsers',
		defaultFilter: 4,
		onSelect: function (rec) {
			reloadOpGrid();
		}
	});
	$("#opMac").combobox({
		valueField: 'id',
		textField: 'desc',
		url: $URL + '?ClassName=' + GV.ClassName + '&MethodName=opMacs',
		defaultFilter: 4,
		onSelect: function (rec) {
			reloadOpGrid();
		}
	});
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
	initSearchCondition();
	reloadOpGrid();
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
	initSearchCondition();
	reloadOpGrid();
}

/**
 * @description: 自定义模板列表改变状态
 * @param {object} node
 */
function customChangeState(node) {
	GV.TempNodeState[node.id] = node.state;
}


function initOperationLogGrid() {
	$HUI.datagrid('#operationLogGrid', {
		title: '操作日志',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true,
		url: $URL,
		columns: [[
			{ field: 'OpDate', title: '操作日期', width: 110 },
			{ field: 'OpTime', title: '操作时间', width: 80 },
			{ field: 'OpModel', title: '病历模板', width: 70, align: 'center', formatter: showRecord },
			{ field: 'OpLeaveMark', title: '留痕', width: 40, align: 'center', formatter: showLeaveMark },
			{ field: 'OpType', title: '操作类型', width: 140 },
			{ field: 'OpUser', title: '操作人', width: 100 },
			{ field: 'OpIP', title: 'IP地址', width: 130 },
			{ field: 'OpMac', title: '物理地址', width: 130 },
			{ field: 'OpPCName', title: '客户端名称', width: 130 },
			{ field: 'OpPatName', title: '患者姓名', width: 130 },
			{ field: 'OpTemplate', title: '模板名称', width: 200 },
			//{field:'OpLoc', title:'科室', width:200},
			{ field: 'OpWard', title: '当前病区', width: 200 },
			{ field: 'OpID', title: 'ID', width: 100 },
			{ field: 'OpGuid', title: '模板GUID', width: 300, hidden: true }
		]],
		singleSelect: true,
		pagination: true,
		pageSize: 8,
		pageList: [8, 30, 50, 100],
		onClickRow: function (rowIndex, rowData) {
			reloadLmGrid(rowData.OpID, rowData.OpGuid);
		}
	});
}

function initLeaveMarkLogGrid() {
	$HUI.datagrid('#leaveMarkLogGrid', {
		title: '留痕日志',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true,
		url: $URL,
		nowrap: false,
		columns: [[
			{ field: 'LmItemDesc', title: '修改项描述', width: 200 },
			{ field: 'LmItemKey', title: '修改项关键字', width: 100 },
			{ field: 'LmOldVal', title: '旧值', width: 300 },
			{ field: 'LmNewVal', title: '新值', width: 300 },
			{ field: 'LmMultID', title: '记录ID', width: 80 },
			{ field: 'LmID', title: 'ID', width: 80 }
		]],
		singleSelect: true,
		pagination: true,
		pageSize: 8,
		pageList: [8, 30, 50, 100],
	});
}

/**
 * @description: 通过ModelID获取Model
 * @param {string} modelId
 * @return {string} guid
 */
function getModelInfo(modelId) {
	return $cm({
		ClassName: 'NurMp.Service.Template.Model',
		MethodName: 'GetModelInfoByID',
		ModelID: modelId
	}, false);
}

/**
* @description 重载操作日志
*/
function reloadOpGrid() {
	var episodeID = EpisodeID;
	var modelInfo = getModelInfo(DefaultCode);
	var temNodeId = modelInfo.Guid;
	if ($('#curTemplateTree').length > 0) {
		var temNode = $('#curTemplateTree').tree('getSelected');
		temNodeId = !!temNode ? temNode.guid : '';
	}
	var startDate = $('#startDate').dateboxq('getValue');
	var endDate = $('#endDate').dateboxq('getValue');
	var opType = $('#opType').combobox('getText');
	var opUser = $('#opUser').combobox('getValue');
	var opMac = $('#opMac').combobox('getText');
	$('#operationLogGrid').datagrid('reload', {
		ClassName: GV.ClassName,
		QueryName: "FindOperationLog",
		OpParr: episodeID + '^' + temNodeId + '^' + startDate + '^' + endDate + '^' + opType + '^' + opUser + '^' + opMac
	});
	reloadLmGrid('');
}
/**
* @description 重载留痕日志
*/
function reloadLmGrid(id, guid) {
	//var temNode = $('#curTemplateTree').tree('getSelected');
	//var modelId = !!temNode ? temNode.modelId : '';
	$('#leaveMarkLogGrid').datagrid('reload', {
		ClassName: GV.ClassName,
		QueryName: "FindLeaveMarkLog",
		LmParr: id + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.CTLOCID'] + "^" + guid
	});
}
function showRecord(value, row, index) {
	return '<a class="icon-paper" onclick="detail(\'' + row.MultDataDR + '\',\'' + row.TcIndent + '\',\'' + row.OpTemplate + '\',\'' + row.OpID + '\')">&nbsp&nbsp&nbsp&nbsp</a>'
}
/**
* @description  明细
*/
function detail(MultDataDR, TcIndent, OpTemplate, OpID) {
	if (MultDataDR == '') {
		$.messager.alert($g('提示'), $g('请选择类型为新建、修改、作废的记录！'), 'info');
		return;
	}
	var url = 'hisui.nurserecordlogmudetail.csp?multDataDr=' + MultDataDR + '&OpId=' + OpID;
	var title = $g('明细');
	if (MultDataDR.indexOf(',') == -1) {
		url = "nur.emr." + TcIndent.toLowerCase() + ".csp?EpisodeID=" + EpisodeID + "&NurMPDataID=" + MultDataDR + "&AuthorityFlag=" + 2;
		title = OpTemplate;
	}
	url = buildMWTokenUrl(url);
	$('#dialogRecord').dialog({
		title: title,
		iconCls: 'icon-w-find',
		width: $(window).width() * 0.9,
		height: $(window).height() * 0.9,
		content: "<iframe id='iframeRecord' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
		modal: true
	}).dialog('open');
}
function showLeaveMark(value, row, index) {
	if (row.OpType == '修改') {
		return "<a class='icon-eye' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
	}
	return "<a class='icon-ignore' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
}
function listenEvents() {
	$('#searchBtn').bind('click', function () {
		reloadOpGrid();
	});
}