/*
 * @Descripttion: 右键引用-知识库
 * @Author: yaojining
 */

var GV = {
	code: 'Know',
	hospitalID: session['LOGON.HOSPID'],
	locID: session['LOGON.CTLOCID'],
	ConfigInfo: new Object(),

};

$(function () {
	initConditions();
	requestConfig(initKnowledgeTree);
	listenEvents();
});

/**
 * @description: 初始化查询条件
 */
function initCondition() {
	$m({
		ClassName: 'NurMp.Service.Refer.Handle',
		MethodName: 'getDefaultLoc',
		LocID: GV.locID
	}, function(defaultLoc) {
		$HUI.combobox('#comboLoc', {
			valueField: 'id',
			textField: 'text',
			url: $URL + '?ClassName=NurMp.Service.Refer.Handle&MethodName=GetKnowledgeLocs&HospitalID=' + GV.hospitalID + '&LocId=' + GV.locID,
			value: defaultLoc,
			onSelect: function (record) {
				$('#panelPreview').empty();
				$HUI.tree('#knowledgeTree', 'reload');
			}
		});
	});
}
/**
 * @description: 初始化知识库树结构
 * @param {object} config
 */
function initKnowledgeTree(config) {
	$('#knowledgeTree').tree({
		loader: function (param, success, error) {
			$cm({
				ClassName: config.queryParams.ClassName,
				MethodName: config.queryParams.MethodName,
				LocId: $('#comboLoc').combobox('getValue'),
				HospitalID: GV.hospitalID,
				Filter: $('#sbTree').searchbox('getValue'),
				ModelID: ModelId || ''
			}, function (treeData) {
				success(treeData);
			});
		},
		autoNodeHeight: true,
		checkbox: JSON.parse(parent.GV.SwitchInfo.KnowMultWrite),
		onClick: function (node) {
			$(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);
			requestContent(node);
		},
		onCheck: function (node, checked) {
			var nodeText = '';
			var nodes = $('#knowledgeTree').tree('getChecked');
			for (var i = 0; i < nodes.length; i++) {
				if (typeof nodes[i].children != 'undefined') continue;
				var subText = '';
				var content = $cm({
					ClassName: config.resultParams.ClassName,
					MethodName: config.resultParams.MethodName,
					KnowledgeID: nodes[i].id
				}, false);
				var eleCount = content.length;
				if (eleCount > 0) {
					for (var j = 0; j < eleCount; j++) {
						var eleText = content[j].title;
						subText = !!subText ? subText + eleText : eleText;
					}
				}
				nodeText = !!nodeText ? nodeText + ',' + subText : subText;
			}
			parent.setContent(nodeText, 0);
		}
	});
}

/**
 * @description: 获取知识库内容
 * @param {node} 节点
 * @param {event} 事件
 */
function requestContent(node) {
	if (node.children) {
		return;
	}
	$cm({
		ClassName: GV.ConfigInfo[GV.code].resultParams.ClassName,
		MethodName: GV.ConfigInfo[GV.code].resultParams.MethodName,
		KnowledgeID: node.id,
		EpisodeID: EpisodeID
	}, function (content) {
		if (content.length > 0) {
			parent.loadContent(content);
		}
	});
}

/**
 * @description: 监听事件
 */
function listenEvent() {
	$('#sbTree').searchbox({
		searcher: function (value) {
			$HUI.tree('#knowledgeTree', 'reload');
		}
	});
}
