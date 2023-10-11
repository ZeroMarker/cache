/**
 * FileName: dhcbill.opbill.charge.main.js
 * Author: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
});

$(window).load(function() {
	var selectPatRowId = getValueById("selectPatRowId");
	var selectAdmRowId = getValueById("selectAdmRowId");
	var cardNo = getValueById("CardNo");
    var cardTypeId = getValueById("CardTypeRowId");
	if (selectPatRowId != "") {
		if ((cardNo != "") && (cardTypeId != "")) {
	    	var accMRowId = getPatAccMRowId(cardNo, cardTypeId, selectPatRowId);
			setValueById("accMRowId", accMRowId);
    	}
		setPatientDetail(selectPatRowId, selectAdmRowId);
	}
});

/**
* 通过就诊卡回调获取患者信息
*/
function setPatInfoByCard(cardNo, cardTypeId, patientId) {
	setValueById("CardNo", cardNo);
	setValueById("CardTypeRowId", cardTypeId);
	setValueById("CardTypeNew", getPropValById("DHC_CardTypeDef", cardTypeId, "CTD_Desc"));
	setValueById("accMRowId", "");    //+2023-02-03 ZhYW
	setPatientDetail(patientId, "");
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();
		chargeClick();
		break;
	case 121: //F10
		e.preventDefault();
		saveClick();
		break;
	default:
	}
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	clearMenu();
	setPatientDetail(patientId, episodeId);
}

function clearMenu() {
	$(":text:not(.pagination-num,.numberbox-f)").val("");
	$(".combobox-f").combobox("clear").combobox("loadData", []);
  	setValueById("accMRowId", "");
}

function closeTipWin() {
	$("#exceptlist").panel("close");
}

function openTipWin() {
	$("#exceptlist").panel("open");
}