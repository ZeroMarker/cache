/**
 * FileName: dhcbill.ipbill.patientinfo.js
 * Author: ZhYW
 * Date: 2019-04-14
 * Description: 患者信息查询
 */

$(function () {
	initQueryMenu();
	initPatList();
});

function initQueryMenu() {
	setValueById("name", ascTransChar(CV.Name));
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPatList();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	$HUI.combobox("#sex", {
		panelHeight: "auto",
		url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadSex&JSFunName=GetSexToHUIJson",
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		onLoadSuccess: function(data) {
			$(this).combobox("clear");
		}
	});
}

function initPatList() {
	GV.PatList = $HUI.datagrid("#patList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCIPBillPAPERInfo",
		queryName: "CheckPatInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillPAPERInfo",
			QueryName: "CheckPatInfo",
			PAPERNo: getValueById("patientNo"),
			PAPERName: getValueById("name"),
			SexID: getValueById("sex"),
			PAPERID: getValueById("IDNo"),
			BirthDate: getValueById("birthDate"),
			InsuNo: getValueById("healthFundNo"),
			HospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		onDblClickRow: function (index, row) {
			websys_showModal("options").callbackFunc(row.TPAPERNo);
			websys_showModal("close");
		}
	});
}

function loadPatList() {
	var queryParams = {
		ClassName: "web.DHCIPBillPAPERInfo",
		QueryName: "CheckPatInfo",
		PAPERNo: getValueById("patientNo"),
		PAPERName: getValueById("name"),
		SexID: getValueById("sex"),
		PAPERID: getValueById("IDNo"),
		BirthDate: getValueById("birthDate"),
		InsuNo: getValueById("healthFundNo"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("patList", queryParams);
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f").combobox("clear");
	$(".datebox-f").datebox("clear");
	loadPatList();
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		$.cm({
			ClassName: "web.DHCIPBillReg",
			MethodName: "GetRegInfo",
			type: "GET",
			patientNo: $(e.target).val(),
			medicareNo: "",
			IPBookId: "",
			sessionStr: getSessionStr()
		}, function (json) {
			if (json.success == 0) {
				setPatInfo(JSON.parse(json.PatInfo));
			}
		});
	}
}

function setPatInfo(patJson) {
	if (patJson.success != 0) {
		$.messager.popover({msg: patJson.msg, type: "info"});
		return;
	}
	setValueById("patientNo", patJson.PatientNo);
	setValueById("name", patJson.Name);
	setValueById("sex", patJson.Sex);
	setValueById("IDNo", patJson.IDNo);             //身份证号
	setValueById("birthDate", patJson.BirthDate);   //出生日期
	setValueById("healthFundNo", patJson.HealthFundNo);      //医保手册号
	loadPatList();
}