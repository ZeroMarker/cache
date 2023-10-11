/**
 * FileName: dhcbill.ipbill.deposit.refund.if.js
 * Author: ZhYW
 * Date: 2019-07-11
 * Description: 住院退押金(供界面调用)
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
	$("#refDepList").parents(".layout-panel-center").prev(".layout-panel-north").attr("tabindex", 0).css({outline: "none"}).focus();   	//+2022-08-16 ZhYW 
});


function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 121:
		e.preventDefault();
		refundClick();
		break;
	default:
	}
}