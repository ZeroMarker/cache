/**
 * FileName: dhcbill.ipbill.deposit.pay.if.js
 * Anchor: ZhYW
 * Date: 2019-07-11
 * Description: 住院交押金(供界面调用)
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
	initPayDepPanel();
	getPayDepConfig();
	focusById("payAmt");
	setValueById("transferFlag", getParam("TransferFlag"));
	setValueById("payAmt", getParam("PayAmt"));
});

function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 13:
		focusNextEle(e.target.id);
		break;
	case 120:
		setValueById("payAmt", $("#payAmt").val());   //numberbox在光标未离开时getValue取不到值，故先赋值
		payClick();
		break;
	default:
	}
}