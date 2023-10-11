/**
 * FileName: dhcbill.opbill.singleinvquery.js
 * Author: ZhYW
 * Date: 2019-12-13
 * Description: 门诊收据查询
 */

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setValue", defDate);

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});

	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//发票回车查询事件
	$("#invNo").keydown(function (e) {
		invNoKeydown(e);
	});
	
	var $tb = $("#more-container");
	if (HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	};
	$tb.click(function () {
		var t = $(this);
		var ui = (HISUIStyleCode == "lite") ? "l" : "b";
		if (t.find(".arrows-b-text").text() == $g("更多")) {
			t.find(".arrows-b-text").text($g("收起"));
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("更多"));
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
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
		$.messager.alert("提示", "卡无效", "info", function () {
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
		loadInvList();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadInvList();
		});
	}
}

/**
 * 发票号回车查询
 */
function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "CheckInvIsValid",
				recepitNo: $(e.target).val(),
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: "该发票号不存在", type: "info"});
					return;
				}
				loadInvList();
			});
		}
	}
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout-panel-west .layout:eq(0)");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (num > 0) {
		$("tr.display-more-tr").show();
	} else {
		$("tr.display-more-tr").hide();
	}
	var c = l.layout("panel", "center");
	var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
	c.panel("resize", {
		height: ch,
		top: nh
	});
}

function initInvList() {
	$HUI.datagrid("#invList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.udhcOPQUERY",
		queryName: "INVQUERY",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TDate", "TAbort", "TRefund", "THandin", "TParkDate", "TParkTime", "TParUName"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TINVRowid", "TabFlag", "IsStayInv"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function(data) {
			if (data.total == 1) {
				$(this).datagrid("selectRow", 0);
			}else {
				unSelectInvListRow();
			}
		},
		onSelect: function (index, row) {
			selectInvListRow(row);
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.udhcOPQUERY",
		QueryName: "INVQUERY",
		ChargeUser: getValueById("userName"),
		ReceipNO: getValueById("invNo"),
		PatientNO: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		StartDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		INVFlag: "N",
		INVStatus: "N",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("invList", queryParams);
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f").combobox("clear");
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setValue", defDate);
	$HUI.datagrid("#invList").options().pageNumber = 1;   //跳转到第一页
	$HUI.datagrid("#invList").loadData({total: 0, rows: []});
	clearOrdItmList();
}
