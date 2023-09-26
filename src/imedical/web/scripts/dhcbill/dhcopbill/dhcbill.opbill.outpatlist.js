/**
 * FileName: dhcbill.opbill.outpatlist.js
 * Anchor: ZhYW
 * Date: 2019-06-13
 * Description: 门诊患者查询
 */
var GV = {};

$(function () {
	initQueryMenu();
	initPatList()
});

function initQueryMenu() {
	setValueById("stDate", getDefStDate(-3));
	setValueById("endDate", getDefStDate(0));
	
	//读卡
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
	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//卡号回车查询事件
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
	
	//科室
	$("#admDept").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPCashier&QueryName=FindOPAdmLoc&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("btn-readCard");
			$("#cardNo").attr("readOnly", false);
			focusById("cardNo");
		} else {
			enableById("btn-readCard");
			setValueById("cardNo", "");
			$("#cardNo").attr("readOnly", true);
			focusById("btn-readCard");
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById("cardType");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatInfo();
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatInfo();
			break;
		default:
		}
	} catch (e) {
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("cardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("cardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatInfo();
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("cardNo");
					});
				}, 300);
				break;
			case '-201':
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function initPatList() {
	GV.PatList = $HUI.datagrid("#patList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		fitColumns: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '登记号', field: 'TPatID', width: 120},
				   {title: '患者姓名', field: 'TName', width: 120},
				   {title: '就诊日期', field: 'TAdmDate', width: 120},
				   {title: '就诊科室', field: 'TAdmLoc', width: 150},
				   {title: '就诊医生', field: 'TAdmDoc', width: 100},
				   {title: 'TRowid', field: 'TRowid', hidden: true},
				   {title: '性别', field: 'TPatSex', hidden: true},
				   {title: '年龄', field: 'TPatAge', hidden: true},
				   {title: '费别', field: 'TAdmReason', width: 100},
				   {title: '金额', field: 'TTotal', align: 'right', hidden: true},
				   {title: '自付金额', field: 'TPatShare', align: 'right', hidden: true},
				   {title: 'TPatDr', field: 'TPatDr', hidden: true},
				   {title: '卡号', field: 'TCardNo', width: 150}			   
			]],
		onDblClickRow: function (rowIndex, rowData) {
			if (window.parent.frames && window.parent.frames.switchPatient) {
				window.parent.frames.switchPatient(rowData.TPatDr, rowData.TRowid);
				window.parent.frames.hidePatListWin();
			}
		}
	});
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				focusById("patientNo");
			}else {
				setPatientInfo(papmi);
			}
		});
	}
}

function setPatientInfo(papmi) {	
	var expStr = "";
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: expStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
		setValueById("patName", myAry[2]);
		loadPatList();
	});
}

function loadPatList() {
	var queryParams = {
		ClassName: "web.DHCOPAdmFind",
		QueryName: "AdmQuery",
		StDate: getValueById("stDate"),
		DateTo: getValueById("endDate"),
		PatientID: getValueById("patientNo"),
		PatName: getValueById("patName"),
		LocRowId: getValueById("admDept"),
		CardNo: getValueById("cardNo"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("patList", queryParams);
}

/**
 * 清屏
 */
function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".hisui-combobox").combobox("clear").combobox("reload");
	setValueById("stDate", getDefStDate(-3));
	setValueById("endDate", getDefStDate(0));
	GV.PatList.load({
		ClassName: "web.DHCOPAdmFind",
		QueryName: "AdmQuery",
		StDate: "",
		DateTo: "",
		PatientID: "",
		PatName: "",
		LocRowId: "",
		CardNo: ""
	});
}