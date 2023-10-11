/*
 * @Descripttion: ����
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
 * @description: ��ȡ������������
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
 * @description: ��ʼ������
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
				selected: false  // ��ҳǩ���Զ���
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
 * @description: ����tab
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
 * @description: ��ȡ������Ĭ��ֵ
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
 * @description: ���ں�-����
 */
function referValue() {
	// ��ȡԤ��ֵ
	var str = getEditorContent();
	if (!str) {
		$.messager.alert('��ʾ', $g('û��Ҫ���õ����ݣ�'));
		return;
	}
	if (typeof websys_emit == 'function') {
		try {
			websys_emit('onRecordRefer', { EditContent: str, ToPreview: GV.SwitchInfo.ToPreview });
		} catch (error) {
			console.log(error.message);
			if (error.message == "Cannot read properties of null (reading 'opener')") {
				$.messager.alert('����', $g('����δ֪������ˢ�²�����ҳ������ԣ�'));
				return false;
			}
		}
	}
}
