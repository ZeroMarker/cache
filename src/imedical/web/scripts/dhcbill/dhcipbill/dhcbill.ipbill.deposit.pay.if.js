/**
 * FileName: dhcbill.ipbill.deposit.pay.if.js
 * Author: ZhYW
 * Date: 2019-07-11
 * Description: 住院交押金(供界面调用)
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	
	var patienId = getValueById("PatientId");
	var episodeId = getValueById("EpisodeId");
	if (patienId) {
		refreshBar(patienId, episodeId);
	}
	
	getPayDepConfig();
	focusById("payAmt");
});

function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 13:
		focusNextEle(e.target.id);
		break;
	case 120:
		e.preventDefault();
		setValueById("payAmt", $("#payAmt").val());   //numberbox在光标未离开时getValue取不到值，故先赋值
		payClick();
		break;
	default:
	}
}