/**
 * FileName: dhcbill.dailymaintabs.js
 * Anchor: ZhYW
 * Date: 2018-03-14
 * Description: 加载Tabs
 */

$(function () {
	$HUI.tabs('#tabItem', {
		onSelect: function (title, index) {
			loadSelTabsContent();
		}
	});
	initTabs();
});

function initTabs() {
	$.cm({
		ClassName: 'web.DHCBillGroupConfig',
		MethodName: 'GetGroupSettingTabs',
		groupId: PUBLIC_CONSTANT.SESSION.GROUPID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		busiType: getParam('businessType')
	}, function (data) {
		$.each(data, function (index, item) {
			$('#tabItem').tabs('add', item);
		});
	});
}

/**
 * Creator: ZhYW
 * CreatDate:2018-03-11
 * Description: 加载选中的Tabs内容
 */
function loadSelTabsContent() {
	var tab = $('#tabItem').tabs('getSelected');
	var tabId = "";
	var tabTitle = "";
	if (tab) {
		var opts = tab.panel('options');
		tabId = opts.id;
		tabTitle = opts.title;
	}
	$.m({
		ClassName: 'web.DHCBillGroupConfig',
		MethodName: 'GetBillTabsUrl',
		tabId: tabId
	}, function (url) {
		switch (getParam('businessType')) {
		case 'OPD':
			loadDetailsList(tabId, tabTitle, url);
			break;
		case 'OPC':
			loadCollectList(tabId, tabTitle, url);
			break;
		case 'IPD':
			loadDetailsList(tabId, tabTitle, url);
			break;
		case 'IPC':
			loadCollectList(tabId, tabTitle, url);
			break;
		case 'BOA':
			loadReconciliationsList(tabId, tabTitle, url);
			break;
		default:
		}
	});
}

function loadDetailsList(tabId, title, url) {
	var stDate = "";
	var stTime = "";
	var endDate = "";
	var endTime = "";
	var footId = "";
	var guser = "";
	var hospDR = PUBLIC_CONSTANT.SESSION.HOSPID;
	if (getParam('linkFlag') != 'Y') {
		var stDateTime = parent.$('#stDateTime').datetimebox('getValue');
		var endDateTime = parent.$('#endDateTime').datetimebox('getValue');
		if (stDateTime != "") {
			var myAry = stDateTime.split(" ");
			stDate = myAry[0];
			stTime = myAry[1];
		}
		if (endDateTime != "") {
			myAry = endDateTime.split(" ");
			endDate = myAry[0];
			endTime = myAry[1];
		}
		footId = parent.$('#footId').val();
		guser = PUBLIC_CONSTANT.SESSION.USERID;
	} else {
		stDate = getParam('stDate');
		stTime = getParam('stTime');
		endDate = getParam('endDate');
		endTime = getParam('endTime');
		footId = getParam('footId');
		guser = getParam('guser');
	}

	var url = url + '&stDate=' + stDate + '&stTime=' + stTime;
	url += '&endDate=' + endDate + '&endTime=' + endTime + '&footId=' + footId;
	url += '&guser=' + guser + '&hospDR=' + hospDR ;
	refreshTab(tabId, url);
}

function loadCollectList(tabId, title, url) {
	var stDate = parent.$('#stDate').datebox('getValue');
	var endDate = parent.$('#endDate').datebox('getValue');
	var guserAry = parent.$('#userCombo').combobox('getValues');
	var guserStr = (guserAry.length > 0) ? guserAry.toString().split(',').join('^') : '';
	var receId = parent.$('#receId').val();
	var url = url + '&stDate=' + stDate + '&endDate=' + endDate + '&guserStr=' + guserStr;
	url += '&receId=' + receId + '&hospDR=' + PUBLIC_CONSTANT.SESSION.HOSPID;
	url += '&groupDR=' + PUBLIC_CONSTANT.SESSION.GROUPID ;
	refreshTab(tabId, url);
}

function loadReconciliationsList(tabId, title, url) {
	var stDate = parent.$('#stDate').datebox('getValue');
	var endDate = parent.$('#endDate').datebox('getValue');
	var transType = parent.$('#transType').combobox('getValue');
	var payChannel = parent.$('#payChannel').combobox('getValue');
	var result = parent.$('#result').combobox('getValue');
	var hospDR = parent.$('#hospital').combobox('getValue');
	var url = url + '&stDate=' + stDate + '&endDate=' + endDate + '&transType=' + transType + '&payChannel=' + payChannel;
	url += '&result=' + result + '&hospDR=' + hospDR;
	refreshTab(tabId, url);
}

function refreshTab(tabId, url) {
	var iframeId = 'iframe_' + tabId;
	var content = '<iframe id="' + iframeId + '" src="' + url + '" width="100%" height="100%" scrolling="auto" frameborder="0"></iframe>';
	$('#' + tabId).css("overflow", "hidden").panel({
		content: content
	}).panel('refresh');
}
