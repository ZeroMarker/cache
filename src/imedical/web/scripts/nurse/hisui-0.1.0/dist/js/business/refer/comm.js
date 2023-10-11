/*
 * @Descripttion: 引用
 * @Author: yaojining
 */

GV = {
	tabs: new Array(),
	SwitchInfo: new Object(),
	CurrentDomID: null,
	EditorSelection: new Object(),
}

$(function () {
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
		GroupID: session['LOGON.GROUPID'],
		PageCode: 'Edit'
	}, function (switchInfo) {
		GV.SwitchInfo = switchInfo.Main;
		initData();
		setDefValue();
	});
}

/**
 * @description: 初始化数据
 */
function initData() {
	$cm({
		ClassName: 'NurMp.Service.Refer.Setting',
		MethodName: 'referTabs',
		HospitalID: session['LOGON.HOSPID'],
		LocID: session['LOGON.CTLOCID'],
		TabStr: Tabs
	}, function (tabs) {
		GV.tabs = tabs;
		for (var i = 0; i < GV.tabs.length; i++) {
			$('#tabs').tabs('add', {
				title: $g(GV.tabs[i].Title),
				selected: false  // 该页签不自动打开
			});
		}
		$('#tabs').tabs({
			onSelect: function (title, index) {
				if (GV.tabs[index].ActiveFlag == '0') {
					updateTab(index);
				}
			}
		});
		updateTab(0);
		$('#tabs').tabs('select', 0);

		GV.tabs[0].ActiveFlag = '1';
	}); 

}
/**
 * @description: 更新tab
 */
function updateTab(index) {
	var targetTab = $('#tabs').tabs('getTab', index);
	var tabSrc = GV.tabs[index].Csp + '?EpisodeID=' + EpisodeID + '&ListWidth=' + ListWidth + '&ModelId=' + ModelId;
	var content = '<iframe id="' + targetTab.Code + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + buildMWTokenUrl(tabSrc) + '"></iframe>';
	$('#tabs').tabs('update', {
		tab: targetTab,
		options: {
			content: content
		}
	});
	GV.tabs[index].ActiveFlag = '1';
}

/**
 * @description: 获取并带入默认值
 * @return {*}
 */
function setDefValue() {
	if (JSON.parse(GV.SwitchInfo.ToPreview)) {
		var oriData = "";
		var curElementId = parent.getRecordWindow().getCurElementId();
		var type = parent.getRecordWindow().GetElementStringType(curElementId);
		var testReg = /^edit/;
		if (testReg.test(curElementId) && parent.getRecordWindow().IsTableCellEdit(parent.getRecordWindow().GetTableIdByIndentity(curElementId))) {
			oriData = parent.getRecordWindow().GetTableCellData(curElementId)
		}
		else {
			if (parent.getRecordWindow().ElementUtility[type] != undefined) {
				oriData = parent.getRecordWindow().getCurElementValue();
			}
		}
		setTimeout(function(){
			setContent(oriData);
		},1000);
	}
}

/**
 * @description: 超融合-引用
 */
function referValue() {
	// 获取预览值
	var str = getEditorContent();
	if (!str) {
		$.messager.alert('提示', $g('没有要引用的内容！'));
		return;
	}
	if (typeof websys_emit == 'function') {
		try {
			websys_emit('onRecordRefer', { EditContent: str, ToPreview: GV.SwitchInfo.ToPreview });
		} catch (error) {
			console.log(error.message);
			if (error.message == "Cannot read properties of null (reading 'opener')") {
				$.messager.alert('错误', $g('发生未知错误！请刷新病历表单页面后重试！'));
				return false;
			}
		}
	}
}
