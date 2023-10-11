/**
 * FileName: dhcbill.opbill.staypatlist.js
 * Author: WangXQ
 * Date: 2023-02-15
 * Description: �������ۻ��߲�ѯ
 */

$(function () {
	initQueryMenu();
	initPatList();
});

function initQueryMenu() {
	setValueById("stDate", CV.StDate);
	setValueById("endDate", CV.EndDate);
	
	//����
	$("#btn-readCard").linkbutton({
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$("#btn-find").linkbutton({
		onClick: function () {
			loadPatList();
		}
	});

	$("#btn-clear").linkbutton({
		onClick: function () {
			clearClick();
		}
	});
	
	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//���Żس���ѯ�¼�
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//����״̬
	$("#stayStatus").combobox({
		panelHeight: 150,
		valueField: 'value',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		data: [
			{value: '1', text: '���۳�Ժ'},
			{value: '2', text: '��������'}
		]
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key != 13) {
		setValueById("PatientId", "");
		return;
	}
	if (!$(e.target).val()) {
		return;
	}
	var patientId = getPAPMIByRegNo($(e.target).val());
	setValueById("PatientId", patientId);
	if (!patientId) {
		$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
		focusById("patientNo");
		return;
	}
	setPatientInfo(patientId);
}

/**
* ���ݵǼǺŲ�ѯ����������
*/
function getPAPMIByRegNo(patientNo) {
	return (patientNo != "") ? $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetPAPMIByNo", PAPMINo: patientNo, ExpStr: ""}, false) : "";
}
			
/**
 * ����
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("��ʾ", "����Ч", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	
	setValueById("PatientId", patientId);
	if (patientId != "") {
		setPatientInfo(patientId);
	}
}

function initPatList() {
	GV.AdmList = $HUI.datagrid("#admList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		className: "BILL.OP.BL.EMObsvAdmFind",
		queryName: "EMObsvAdmQuery",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TAdmDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TPatientId", "TAdm"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TAdmTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.TAdmDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TAdmTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		onDblClickRow: function (index, row) {
            if (window.parent.frames && window.parent.frames.switchPatient) {
				window.parent.frames.switchPatient(row.TPatientNo, row.TAdm);
				window.parent.frames.hidePatListWin();
			}
		}
	});
}

function setPatientInfo(patientId) {
	$.cm({
		ClassName: "BILL.COM.PAPatMas",
		MethodName: "GetPatientInfo",
		patientId: patientId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(json) {
		setValueById("patientNo", json.PatientNo);
		setValueById("patName", json.PatName);
		loadPatList();
	});
}

function loadPatList() {
	var queryParams = {
		ClassName: "BILL.OP.BL.EMObsvAdmFind",
		QueryName: "EMObsvAdmQuery",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("PatientId"),
		patientName: getValueById("patName"),
		stayStatus: getValueById("stayStatus"),
		sessionStr: getSessionStr(),
	};
	loadDataGridStore("admList", queryParams);
}

/**
 * ����
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	setValueById("PatientId", "");
	setValueById("stDate", CV.StDate);
	setValueById("endDate", CV.EndDate);
	GV.AdmList.options().pageNumber = 1;   //��ת����һҳ
	GV.AdmList.loadData({total: 0, rows: []});
}
