/**
 * FileName: dhcbill.dailymaintabs.js
 * Author: ZhYW
 * Date: 2018-03-14
 * Description: 加载Tabs
 */

$(function () {
	loadSelTabsContent();  //在html中设置选中页签时，不会触发onSelect事件，故在此先调用获取选中的页签
	
	$HUI.tabs("#tabItem", {
		onSelect: function (title, index) {
			loadSelTabsContent();
		}
	});
});

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-11
 * Description: 加载选中的Tabs内容
 */
function loadSelTabsContent() {
	var tab = $("#tabItem").tabs("getSelected");
	if (!tab) {
		return;
	}
	var tabId = tab.panel("options").id;
	var url = $("#" + tabId).attr("data");
	switch (CV.BusiType) {
	case "OPD":
		loadDetailsList(tabId, url);
		break;
	case "OPC":
		loadCollectList(tabId, url);
		break;
	case "OPW":
		loadWorkLoadList(tabId, url);
		break;
	case "IPD":
		loadDetailsList(tabId, url);
		break;
	case "IPC":
		loadCollectList(tabId, url);
		break;
	case "BOA":
		loadReconciliationsList(tabId, url);
		break;
	default:
	}
}

function loadDetailsList(tabId, url) {
	var stDate = "";
	var stTime = "";
	var endDate = "";
	var endTime = "";
	var footId = "";
	var guser = "";
	if (CV.LinkFlag != "Y") {
		var stDateTime = parent.$("#stDateTime").datetimebox("getValue");
		var endDateTime = parent.$("#endDateTime").datetimebox("getValue");
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
		footId = parent.$("#footId").val();
		guser = PUBLIC_CONSTANT.SESSION.USERID;
	} else {
		stDate = getParam("stDate");
		stTime = getParam("stTime");
		endDate = getParam("endDate");
		endTime = getParam("endTime");
		footId = getParam("footId");
		guser = getParam("guser");
	}

	var url = url + "&stDate=" + stDate + "&stTime=" + stTime;
	url += "&endDate=" + endDate + "&endTime=" + endTime + "&footId=" + footId;
	url += "&guser=" + guser + "&hospDR=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	refreshTab(tabId, url);
}

function loadCollectList(tabId, url) {
	var stDate = parent.$("#stDate").datebox("getValue");
	var endDate = parent.$("#endDate").datebox("getValue");
	var guserAry = parent.$("#userCombo").combobox("getValues");
	var guserStr = (guserAry.length > 0) ? String(guserAry).split(",").join("^") : "";
	var receId = parent.$("#receId").val();
	var verifyStatus = (parent.$("#verifyCombo").length > 0) ? parent.$("#verifyCombo").combobox("getValue") : "";
	var url = url + "&stDate=" + stDate + "&endDate=" + endDate + "&guserStr=" + guserStr;
	url += "&receId=" + receId + "&hospDR=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	url += "&groupDR=" + PUBLIC_CONSTANT.SESSION.GROUPID+ "&verifyStatus=" + verifyStatus;
	refreshTab(tabId, url);
}

function loadReconciliationsList(tabId, url) {
	var stDate = parent.$("#stDate").datebox("getValue");
	var endDate = parent.$("#endDate").datebox("getValue");
	var transType = parent.$("#transType").combobox("getValue");
	var payChannel = parent.$("#payChannel").combobox("getValue");
	var result = parent.$("#result").combobox("getValue");
	var hospDR = parent.$("#hospital").combobox("getValue");
	var url = url + "&stDate=" + stDate + "&endDate=" + endDate + "&transType=" + transType + "&payChannel=" + payChannel;
	url += "&result=" + result + "&hospDR=" + hospDR;
	refreshTab(tabId, url);
}

/**
* 2023-02-08 ZhYW 增加Token
*/
function refreshTab(tabId, url) {
	var iframeId = "iframe_" + tabId;
	var content = "<iframe id=\"" + iframeId + "\" src=\"" + websys_writeMWToken(url) + "\" width=\"100%\" height=\"100%\" scrolling=\"auto\" frameborder=\"0\"></iframe>";
	$("#" + tabId).css("overflow", "hidden").panel({
		content: content
	}).panel("refresh");
}

function loadWorkLoadList(tabId, url) {
	var stDate = parent.$("#stDate").datebox("getValue");
	var endDate = parent.$("#endDate").datebox("getValue");
	var stTime = parent.$("#stTime").timespinner("getValue");
	var endTime = parent.$("#endTime").timespinner("getValue");
	var guserAry = [];
	if (parent.$("#userCombo").combobox("options").multiple) {
		guserAry = parent.$("#userCombo").combobox("getValues");
	}else {
		guserAry = parent.$("#userCombo").combobox("getValue");
	}
	var guserStr = (guserAry.length > 0) ? String(guserAry).split(",").join("^") : "";
	var selType = parent.$("#selType").combobox("getValue");
	var url = url + "&StDate=" + stDate + "&EndDate=" + endDate;
	url += "&StartTime=" + stTime + "&EndTime=" + endTime + "&UserRowId=" + guserStr;
	url += "&DateFlag=" +selType+ "&HOSPID=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	refreshTab(tabId, url);
}
