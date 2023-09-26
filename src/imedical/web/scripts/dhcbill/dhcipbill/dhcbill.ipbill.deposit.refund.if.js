/**
 * FileName: dhcbill.ipbill.deposit.refund.if.js
 * Anchor: ZhYW
 * Date: 2019-07-11
 * Description: 住院退押金(供界面调用)
 */

var GV = {};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	$("table.search-table").css({"width": "80%"});
	
	var episodeId = getParam("EpisodeID");
	setValueById("episodeId", episodeId);
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName:"GetClsPropValById",
		clsName: "User.PAAdm",
		id: episodeId
	}, function(jsonObj) {
		setValueById("papmi", jsonObj.PAADMPAPMIDR);
		refreshBar(jsonObj.PAADMPAPMIDR, episodeId);
	});
	initRefDepPanel();
});


function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 121:
		refundClick();
		break;
	default:
	}
}