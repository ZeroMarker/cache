/*
 * @Descripttion: �Ҽ�����-�����¼���Զ��壩
 * @Author: yaojining
 */

var GV = {
	code: 'Record1',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Record',
	ConfigInfo: new Object()
};
/**
 * @description: ��ʼ������
 */
$(function () {
	initConditions();
	requestConfig(initData);
	listenEvents();
});

/**
 * @description: ��ʼ����ѯ����
 */
function initCondition() {
	$('#searchTemplate').searchbox({
		searcher: function (value) {
			$HUI.tree('#templateTree', 'reload');
		}
	});
}

/**
 * @description: ��ʼ�����ݱ��
 * @param {object} config
 */
function initData(config) {
	$HUI.tree('#templateTree', {
		loader: function (param, success, error) {
			$cm({
				ClassName: config.queryParams.ClassName,
				MethodName: config.queryParams.MethodName,
				HospitalID: GV.hospitalID,
				LocID: session['LOGON.CTLOCID'],
				EpisodeID: EpisodeID,
				RangeFlag: 'S',
				SearchInfo: $HUI.searchbox('#searchTemplate').getValue()
			}, function (data) {
				success(data);
			});
		},
		autoNodeHeight: true,
		onLoadSuccess: function(node, data) {
			initDataDetail('');
		},
		onClick: function (node) {
			if (!!node.guid) {
				initDataDetail(node.guid);
			} else {
				$.messager.popover({ msg: $g('��ѡ��ģ�壡'), type: 'error', timeout: 1000 });
			}
		}
	});
}
/**
 * @description: �����¼1���ݼ���
 */
function initDataDetail(guid) {
	$cm({
		ClassName: GV.ConfigInfo[GV.code].resultParams.ClassName,
		MethodName: GV.ConfigInfo[GV.code].resultParams.MethodName,
		Guid: guid,
		HospitalID: GV.hospitalID,
		LocID: session['LOGON.CTLOCID']
	}, function (columns) {
		var page_list = pageList();
		$HUI.datagrid('#dataGrid', {
			url: $URL,
			queryParams: {
				ClassName: GV.className,
				QueryName: "FindFormatRecords",
				EpisodeID: EpisodeID,
				Guid: guid,
				HospitalID: GV.hospitalID,
				LocID: session['LOGON.CTLOCID'],
				Sort: GV.ConfigInfo[GV.code].gridProperty.isRever == "true" ? -1 : 1
			},
			columns: columns,
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: page_list[0],
			pageList: page_list,
			displayMsg:''
		});
	});
}
/**
 * @description: ��������
 */
function customWriteIn() {
	var result = '';
	var configFlag = false;
	var node = $('#templateTree').tree('getSelected');
	if ((!node) || (node.isLeaf == '0')) {
		$.messager.popover({msg: $g('��ѡ��ģ�壡'),type: 'alert'});
		return false;
	}
	var rows = $('#dataGrid').datagrid('getSelections');
	if (rows.length == 0) {
		$.messager.popover({ msg: $g('��ѡ�м�¼��'), type: 'alert' });
		return false;
	}
	var i = 0;
	$.each(rows[0], function (field, value) {
		var propHidden = $('#dataGrid').datagrid('options').columns[0][i].hidden;
		if ((typeof propHidden == 'undefined') || (!propHidden)) {
			if ((field == "CareDate") || (field == "CareTime") || (field.indexOf("Field") > -1)) {
				if ((value.indexOf('CA') > -1) && (value.indexOf('*') > -1)) {
					value = value.replace('CA', '').split('*')[0];
				}
				result = !!result ? result + ' ' + value : value;
				configFlag = true;
			}
		}
		i++;
	});
	if (!configFlag) {
		$.messager.popover({ msg: $g('δ���������õ����ݣ��뵽������������-�����¼�������á�ҳ�����ά����'), type: 'alert' });
		return false;
	}
	writToPreview(result);
}

/**
 * @description: �����������
 */
function reloadData() {
	$HUI.tree('#templateTree', 'reload');
}