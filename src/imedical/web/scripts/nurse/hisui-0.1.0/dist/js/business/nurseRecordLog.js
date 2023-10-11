/*
 * @Descripttion: ������������־
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
* @description ��ʼ����ѯ����
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
	initSearchCondition();
	reloadOpGrid();
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
	initSearchCondition();
	reloadOpGrid();
}

/**
 * @description: �Զ���ģ���б�ı�״̬
 * @param {object} node
 */
function customChangeState(node) {
	GV.TempNodeState[node.id] = node.state;
}


function initOperationLogGrid() {
	$HUI.datagrid('#operationLogGrid', {
		title: '������־',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true,
		url: $URL,
		columns: [[
			{ field: 'OpDate', title: '��������', width: 110 },
			{ field: 'OpTime', title: '����ʱ��', width: 80 },
			{ field: 'OpModel', title: '����ģ��', width: 70, align: 'center', formatter: showRecord },
			{ field: 'OpLeaveMark', title: '����', width: 40, align: 'center', formatter: showLeaveMark },
			{ field: 'OpType', title: '��������', width: 140 },
			{ field: 'OpUser', title: '������', width: 100 },
			{ field: 'OpIP', title: 'IP��ַ', width: 130 },
			{ field: 'OpMac', title: '�����ַ', width: 130 },
			{ field: 'OpPCName', title: '�ͻ�������', width: 130 },
			{ field: 'OpPatName', title: '��������', width: 130 },
			{ field: 'OpTemplate', title: 'ģ������', width: 200 },
			//{field:'OpLoc', title:'����', width:200},
			{ field: 'OpWard', title: '��ǰ����', width: 200 },
			{ field: 'OpID', title: 'ID', width: 100 },
			{ field: 'OpGuid', title: 'ģ��GUID', width: 300, hidden: true }
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
		title: '������־',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true,
		url: $URL,
		nowrap: false,
		columns: [[
			{ field: 'LmItemDesc', title: '�޸�������', width: 200 },
			{ field: 'LmItemKey', title: '�޸���ؼ���', width: 100 },
			{ field: 'LmOldVal', title: '��ֵ', width: 300 },
			{ field: 'LmNewVal', title: '��ֵ', width: 300 },
			{ field: 'LmMultID', title: '��¼ID', width: 80 },
			{ field: 'LmID', title: 'ID', width: 80 }
		]],
		singleSelect: true,
		pagination: true,
		pageSize: 8,
		pageList: [8, 30, 50, 100],
	});
}

/**
 * @description: ͨ��ModelID��ȡModel
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
* @description ���ز�����־
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
* @description ����������־
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
* @description  ��ϸ
*/
function detail(MultDataDR, TcIndent, OpTemplate, OpID) {
	if (MultDataDR == '') {
		$.messager.alert($g('��ʾ'), $g('��ѡ������Ϊ�½����޸ġ����ϵļ�¼��'), 'info');
		return;
	}
	var url = 'hisui.nurserecordlogmudetail.csp?multDataDr=' + MultDataDR + '&OpId=' + OpID;
	var title = $g('��ϸ');
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
	if (row.OpType == '�޸�') {
		return "<a class='icon-eye' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
	}
	return "<a class='icon-ignore' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
}
function listenEvents() {
	$('#searchBtn').bind('click', function () {
		reloadOpGrid();
	});
}