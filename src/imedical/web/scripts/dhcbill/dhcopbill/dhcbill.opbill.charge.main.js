/**
 * FileName: dhcbill.opbill.charge.main.js
 * Author: ZhYW
 * Date: 2019-06-03
 * Description: �����շ�
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
* ͨ�����￨�ص���ȡ������Ϣ
*/
function setPatInfoByCard(cardNo, cardTypeId, patientId) {
	setValueById("CardNo", cardNo);
	setValueById("CardTypeRowId", cardTypeId);
	setValueById("CardTypeNew", getPropValById("DHC_CardTypeDef", cardTypeId, "CTD_Desc"));
	setValueById("accMRowId", "");    //+2023-02-03 ZhYW
	setPatientDetail(patientId, "");
}

/**
 * ��ݼ�
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
 * �����б���ѡ�����л�
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