/**
 * FileName: dhcbill.ipbill.deposit.main.js
 * Author: ZhYW
 * Date: 2019-07-03
 * Description: 押金管理
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	showBannerTip();
	initQueryMenu();
	initAdmList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadAdmList();
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

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//病案号回车查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});

	$("#more-container").click(function () {
		var t = $(this);
		if (t.find(".arrows-b-text").text() == $g("更多")) {
			t.find(".arrows-b-text").text($g("收起"));
			t.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("更多"));
			t.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
			$("tr.display-more-tr").slideUp("normal", setHeight(-40));
		}
	});
	
	//就诊类型
	$("#admType").combobox({
		panelHeight: 'auto',
		editable: false,
		valueField: 'id',
		textField: 'text',
		data: [{id: '', text: $g('全部')},
			   {id: 'I', text: $g('住院')},
			   {id: 'P', text: $g('预住院')}
			 ]
	});
	
	//病区
	$("#ward").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
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
		},
		onChange: function (newValue, oldValue) {
			$("#bed").combogrid("clear").combogrid("grid").datagrid("reload");
		}
	});
	
	$("#bed").combogrid({
		panelWidth: 400,
		panelHeight: 300,
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindBed',
		fitColumns: true,
		pagination: true,
		mode: 'remote',
		delay: 300,
		idField: 'regNo',
		textField: 'bed',
		lazy: true,
		columns: [[{field: 'regNo', title: '登记号', width: 120},
				   {field: 'patName', title: '姓名', width: 100},
				   {field: 'bed', title: '床号', width: 100}
			]],
		onBeforeLoad: function (param) {
			param.wardId = getValueById("ward") || "";
			param.bedCode = param.q;
		},
		onHidePanel: function() {
			var row = $(this).combogrid("grid").datagrid("getSelected");
			if (row) {
				setValueById("patientNo", row.regNo);
				setValueById("patName", row.patName);
			}
		}
	});
	
	$HUI.tabs("#deposit-tabs", {
		onSelect: function (title, index) {
			initTabDoc(index);
		}
	});
}

function initTabDoc(index) {
	switch(index) {
	case 0:
		initPayDepDoc();
		break;
	case 1:
		initRefDepDoc();
		break;
	case 2:
		initLostDepDoc();
		break;
	default:
	}
}

/**
 * 获取选中的tabs索引
 */
function getSelTabIndex() {
	var tabsObj = $HUI.tabs('#deposit-tabs');
	return tabsObj.getTabIndex(tabsObj.getSelected());
}

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
	case 121:
		e.preventDefault();
		refundClick();
		break;
	default:
	}
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
		getPatInfo();
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

function initAdmList() {
	var admRowIndex = undefined;
	$HUI.datagrid("#admList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		className: 'web.DHCIPBillDeposit',
		queryName: 'FindAdmInfo',
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TAdmDate", "TDischDate", "TDept"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TPatientId", "TAdm"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TWard") {
					cm[i].title = "科室病区";
					cm[i].formatter = function (value, row, index) {
						return row.TDept + " " + value;
					};
				}
				if (cm[i].field == "TAdmTime") {
					cm[i].formatter = function (value, row, index) {
					   	return row.TAdmDate + " " + value;
					};
				}
				if (cm[i].field == "TDischTime") {
					cm[i].formatter = function (value, row, index) {
					   	return row.TDischDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TAdmTime", "TDischTime"]) != -1) {
						cm[i].width = 155;
					}
					if (cm[i].field == "TWard") {
						cm[i].width = 160;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			admRowIndex = undefined;
			setValueById("PatientId", "");
			setValueById("EpisodeId", "");
			if (data.total == 1) {
				$(this).datagrid("selectRow", 0);
			}else {
				showBannerTip();
				$("#deposit-tabs .datagrid-f").datagrid("loadData", {total: 0, rows: []});
			}
		},
		onSelect: function (index, row) {
			if (admRowIndex == index) {
				return;
			}
			admRowIndex = index;
			setValueById("PatientId", row.TPatientId);
			setValueById("EpisodeId", row.TAdm);
			refreshBar(row.TPatientId, row.TAdm);
			initTabDoc(getSelTabIndex());
		}
	});
}

function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillDeposit",
		QueryName: "FindAdmInfo",
		patientName: getValueById("patName"),
		patientNo: getValueById("patientNo"),
		wardId: getValueById("ward") || "",
		medicareNo: getValueById("medicareNo"),
		admType: getValueById("admType"),
		sessionStr: getSessionStr()
	}
	loadDataGridStore("admList", queryParams);
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("medicareNo", "");
		setValueById("patName", "");
		getPatInfo();
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("patientNo", "");
		setValueById("patName", "");
		getPatInfo();
	}
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	var medicareNo = getValueById("medicareNo");
	if (patientNo || medicareNo) {
		if (patientNo) {
			patientNo = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "regnocon", PAPMINo: patientNo}, false);
			setValueById("patientNo", patientNo);
		}
		loadAdmList();
	}
}

function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,#payRcptNo,#refRcptNo,#accPreRcptNo),textarea").val("");
	$(".combobox-f").combobox("clear");
	$(".combobox-f:not(#bank)").combobox("reload");
	$("#bank").combobox("loadData", []);
	setValueById("admType", "");
	$(".datagrid-f").datagrid("options").pageNumber = 1;   //跳转到第一页
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {total: 0, rows: []});
  	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
}