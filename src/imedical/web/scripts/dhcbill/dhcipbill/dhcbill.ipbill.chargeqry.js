/**
 * FileName: dhcbill.ipbill.chargeqry.js
 * Author: ZhYW
 * Date: 2020-09-16
 * Description: 住院收费查询
 */

$(function () {
	initQueryMenu();
	initBillList();
});

function initQueryMenu() {
	setValueById("endDate", CV.DefDate);

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadBillList();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号、病案号回车查询事件
	$("#patientNo, #medicareNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			if ($(e.target).val()) {
				getPatInfo();
			}
		}
	});
	
	//发票号回车查询事件
	$("#invNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			if ($(e.target).val()) {
				loadBillList();
			}
		}
	});
	
	//就诊科室
	$HUI.combobox("#admDept", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	//费别
	$HUI.combobox("#insType", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true
	});
	
	//结算状态
	$HUI.combobox("#discStatus", {
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data: [{id: '', text: $g('全部')},
		      {id: 'billed', text: $g('未结算')},
			  {id: 'paid', text: $g('结算历史')},
			  {id: 'disch', text: $g('最终结算')},
			  {id: 'tobill', text: $g('新入院')}]
	});
}

function initBillList() {
	GV.BillList = $HUI.datagrid("#billList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFCASHIER",
		queryName: "QryBillList",
		frozenColumns: [[{title: '登记号', field: 'Tregno', width: 110,
							formatter: function (value, row, index) {
								return "<a href=\"javascript:;\" onclick=orderDetail(\"" + row.Tadm + "\")>" + value + "</a>";
							}
						  },
						  {title: '病案号', field: 'Tzyno', width: 80},
						  {title: '患者姓名', field: 'Tname', width: 100}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tregno", "Tname", "Tzyno", "Tward", "Tadmdate", "Tpatdisdate", "Tdischargedate", "Tamountpaid", "TpayedFlag", "Trefund"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TpatientId", "Tadmno", "Tadm", "Tbillrowid", "TPatBillDateFrom", "TPatBillDateTo"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "Tadmtime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tadmdate + " " + value;
					}
				}
				if (cm[i].field == "Tpatdistime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tpatdisdate + " " + value;
					}
				}
				if (cm[i].field == "Tdischargetime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tdischargedate + " " + value;
					}
				}
				if (cm[i].field == "Tloc") {
					cm[i].title = '科室病区';
					cm[i].showTip = true;
					cm[i].formatter = function (value, row, index) {
						return value + " " + row.Tward;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Tbed") {
						cm[i].width = 60;
					}
					if ($.inArray(cm[i].field, ["Tloc"]) != -1) {
						cm[i].width = 160;
					}
					if ($.inArray(cm[i].field, ["Tadmtime", "Tdischargetime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		}
	});
}

function loadBillList() {
	var queryParams = {
		ClassName: "web.UDHCJFCASHIER",
		QueryName: "QryBillList",
		regno: getValueById("patientNo"),
		medicareNo: getValueById("medicareNo"),
		patientName: getValueById("patName"),
		frmdat: getValueById("stDate"),
		todat: getValueById("endDate"),
		loc: getValueById("admDept"),
		insTypeId: getValueById("insType"),
		InvoiceNO: getValueById("invNo"),
		CurrentFlag: getValueById("discStatus"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("billList", queryParams);
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	DHCACC_GetAccInfo7(magCardCallback);
}

/**
* 卡号回车事件
*/
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
		$.messager.alert("提示", "卡无效", "info", function() {
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
	
	if (patientId != "") {
		getPatInfo();
	}
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	var medicareNo = getValueById("medicareNo");
	if (patientNo || medicareNo) {
		$.cm({
			ClassName: "web.UDHCJFCASHIER",
			MethodName: "GetPatInfo",
			patientNo: patientNo,
			medicareNo: medicareNo,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function(json) {
			if (!json.PatientId) {
				$.messager.popover({msg: "没有此患者信息", type: "info"});
				return;
			}
			setValueById("patientNo", json.PatientNo);
			setValueById("medicareNo", json.MedicareNo);
			setValueById("patName", json.PatName);
			
			loadBillList();
		});
	}
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f,.datebox-f").combobox("clear");
	$("#discStatus").combobox("setValue", "");
	setValueById("endDate", CV.DefDate);
	GV.BillList.options().pageNumber = 1;   //跳转到第一页
	GV.BillList.loadData({total: 0, rows: []});
}

/**
* 医嘱费用查询
*/
function orderDetail(adm) {
	var url = "dhcbill.ipbill.patordfee.csp?EpisodeID=" + adm;
	websys_showModal({
		url: url,
		title: "医嘱费用查询",
		iconCls: "icon-w-find",
		width: "95%",
		height: "87%"
	});
}