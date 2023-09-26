/**
 * FileName: dhcbill.ipbill.deposit.main.js
 * Anchor: ZhYW
 * Date: 2019-07-03
 * Description: 押金管理
 */

var GV = {};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	showBannerTip();
	initQueryMenu();
	initAdmList();
	initPayDepPanel();
	initRefDepPanel();
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
	$("#cardNo").keydown(function (e) {
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
		if (t.find(".arrows-b-text").text() == "更多") {
			t.find(".arrows-b-text").text("收起");
			t.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text("更多");
			t.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
			$("tr.display-more-tr").slideUp("normal", setHeight(-40));
		}
	});

	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
	
	//就诊类型
	$("#admType").combobox({
		panelHeight: 'auto',
		editable: false,
		valueField: 'id',
		textField: 'text',
		data: [{id: '', text: '全部'},
			   {id: 'I', text: '住院'},
			   {id: 'P', text: '预住院'}
			 ]
	});
	
	//病区
	$("#ward").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindWard&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
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
	
	var tabsObj = $HUI.tabs("#deposit-tabs", {
		onSelect: function (title, index) {
			if (index == 0) {
				initPayDepDoc();
			}else {
				initRefDepDoc();
			}
		}
	});
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
		setValueById("payAmt", $("#payAmt").val());   //numberbox在光标未离开时getValue取不到值，故先赋值
		payClick();
		break;
	case 121:
		refundClick();
		break;
	default:
	}
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
			$("#cardNo").attr("readOnly", true);
			focusById("btn-readCard");
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
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
			var securityNo = "";
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "PatInfo");
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
			case "-201":
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

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $("#head-menu");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (+num > 0) {
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
		striped: true,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns: [[{title: 'TPapmi', field: 'TPapmi', hidden: true},
		           {title: '登记号', field: 'Tpapno', width: 100},
				   {title: '病案号', field: 'Tzyno', width: 100},
				   {title: '患者姓名', field: 'Tadmname', width: 100},
				   {title: '性别', field: 'Tsex', width: 50},
				   {title: '就诊类型', field: 'TAdmType', width: 80},
				   {title: '费别', field: 'Tadmreason', width: 100},
				   {title: '科室病区', field: 'Tdepdesc', width: 150,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.Tward;
					}
				   },
				   {title: '入院时间', field: 'Tadmdate', width: 155},
				   {title: '出院时间', field: 'Tdisdate', width: 155},
				   {title: '床位', field: 'Tbed', width: 60},
				   {title: 'Tadmid', field: 'Tadmid', hidden: true}
			]],
		onLoadSuccess: function (data) {
			admRowIndex = undefined;
			setValueById("papmi", "");
			setValueById("episodeId", "");
			if (data.total == 1) {
				$(this).datagrid("selectRow", 0);
			}else {
				showBannerTip();
				$("#deposit-tabs .datagrid-f").datagrid("loadData", {
					total: 0,
					rows: []
				});
			}
		},
		onSelect: function (index, row) {
			if (admRowIndex == index) {
				return;
			}
			admRowIndex = index;
			setValueById("papmi", row.TPapmi);
			setValueById("episodeId", row.Tadmid);
			refreshBar(row.TPapmi, row.Tadmid);
			if (getSelTabIndex() == 0) {
				initPayDepDoc();
			}else {
				initRefDepDoc();
			}
		}
	});
}

function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillDeposit",
		QueryName: "FindAdmInfo",
		patName: getValueById("patName"),
		patientNo: getValueById("patientNo"),
		wardId: getValueById("ward") || "",
		medicareNo: getValueById("medicareNo"),
		admType: getValueById("admType"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
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
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f").combobox("clear");
	$(".combobox-f:not(#bank)").combobox("reload");
	$("#bank").combobox("loadData", []);
	setValueById("admType", "");
	getAccPreRcptNo();
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
  	$(".datagrid-f").datagrid("loadData", {
		total: 0,
		rows: []
	});
}