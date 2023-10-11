/*
 * @Descripttion: 右键引用-护理记录（自定义）
 * @Author: yaojining
 */

var GV = {
	code: 'Record1',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Record',
	ConfigInfo: new Object()
};
/**
 * @description: 初始化界面
 */
$(function () {
	initConditions();
	requestConfig(initData);
	listenEvents();
});

/**
 * @description: 初始化查询条件
 */
function initCondition() {
	$('#searchTemplate').searchbox({
		searcher: function (value) {
			$HUI.tree('#templateTree', 'reload');
		}
	});
}

/**
 * @description: 初始化数据表格
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
				$.messager.popover({ msg: $g('请选择模板！'), type: 'error', timeout: 1000 });
			}
		}
	});
}
/**
 * @description: 护理记录1内容加载
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
 * @description: 返回内容
 */
function customWriteIn() {
	var result = '';
	var configFlag = false;
	var node = $('#templateTree').tree('getSelected');
	if ((!node) || (node.isLeaf == '0')) {
		$.messager.popover({msg: $g('请选中模板！'),type: 'alert'});
		return false;
	}
	var rows = $('#dataGrid').datagrid('getSelections');
	if (rows.length == 0) {
		$.messager.popover({ msg: $g('请选中记录！'), type: 'alert' });
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
		$.messager.popover({ msg: $g('未配置需引用的内容，请到【护理病历配置-护理记录引用配置】页面进行维护！'), type: 'alert' });
		return false;
	}
	writToPreview(result);
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	$HUI.tree('#templateTree', 'reload');
}