/**
 * FileName: dhcbill.opbill.charge.main.js
 * Anchor: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initPatInfoPanel();
	initOEListPanel();
	initChargePanel();
});

$(window).load(function() {
	var reloadFlag = getValueById("reloadFlag");
	if (reloadFlag) {
		setValueById("cardNo", getParam("CardNo"));
		var selectPatRowId = getParam("SelectPatRowId");
		var selectAdmRowId = getParam("SelectAdmRowId");
		if ((selectPatRowId != "") && (selectAdmRowId != "")) {
			setPatientDetail(selectPatRowId, selectAdmRowId);
		}
		disableById("btn-readCard");
		disableById("cardNo");
		disableById("btn-clear");
	}
	
	//医技科室单独挂的收费界面时，也不能调用医保，只能卡消费
	var medDeptFlag = getValueById("medDeptFlag");
	if (medDeptFlag) {
		setValueById("reloadFlag", medDeptFlag);
	}
	if (getValueById("reloadFlag")) {
		disableById("patientNo");
		disableById("paymode");
		disableById("chargeInsType");
	}
});

/**
* 通过就诊卡回调获取患者信息
*/
function setPatInfoByCard(cardNo, cardTypeRowId, patientId) {
	setValueById("cardNo", cardNo);
	$.each($("#cardType").combobox("getData"), function(index, item) {
		var id = item.value.split("^")[0];
		if (id == cardTypeRowId) {
			$("#cardType").combobox("select", item.value);
			return false;
		}
	});
	setPatientDetail(patientId, "");
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		readHFMagCardClick();
		break;
	case 117: //F6
		regClick();
		break;
	case 118: //F7
		clearClick();
		break;
	case 120: //F9
		chargeClick();
		break;
	case 121: //F10
		saveClick();
		break;
	default:
	}
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	$("#InpatListDiv").data("AutoOpen", 0);
	clearMenu();
	setPatientDetail(patientId, episodeId);
}

function clearMenu() {
	$(":text:not(.pagination-num)").val("");
	$("#cardType").combobox("reload");
	$(".combobox-f:not(#paymode,#cardType)").combobox("clear").combobox("loadData", []);
  	setValueById("accMRowId", "");
  	setValueById("accMLeft", "");
}