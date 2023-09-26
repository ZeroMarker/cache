/**
 * FileName: dhcbill.opbill.singleinvquery.js
 * Anchor: ZhYW
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
	$("#cardNo").keydown(function (e) {
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
	
	$("#more-container").click(function () {
		var t = $(this);
		if (t.find('.arrows-b-text').text() == "更多") {
			t.find('.arrows-b-text').text("收起");
			t.find('.spread-b-down').removeClass('spread-b-down').addClass('retract-b-up');
			$('tr.display-more-tr').slideDown('normal', setHeight(40));
		} else {
			t.find('.arrows-b-text').text("更多");
			t.find('.retract-b-up').removeClass('retract-b-up').addClass('spread-b-down');
			$('tr.display-more-tr').slideUp('fast', setHeight(-40));
		}
	});

	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
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
			loadInvList();
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			loadInvList();
			break;
		default:
		}
	} catch (e) {
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
				loadInvList();
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
				loadInvList();
				break;
			default:
			}
		}
	} catch (e) {
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
				if (rtn == "0") {
					$.messager.popover({msg: "该发票号不存在", type: "info"});
					return;
				} else {
					loadInvList();
				}
			});
		}
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
			setValueById("cardNo", "");
			$("#cardNo").attr("readOnly", true);
			focusById("btn-readCard");
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

function initInvList() {
	$HUI.datagrid("#invList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '发票号', field: 'TINVNO', width: 100},
				   {title: '登记号', field: 'TPatID', width: 100},
				   {title: '患者姓名', field: 'TPatName', width: 80},
				   {title: '费用总额', field: 'TotSum', align: 'right', width: 80},
				   {title: '自付金额', field: 'TAcount', align: 'right', width: 80},
				   {title: '收费员', field: 'TUser', width: 70},
				   {title: '收费时间', field: 'TDate', width: 155,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.TTime;
						}
					}
				   },
				   {title: 'TINVRowid', field: 'TINVRowid', hidden: true},
				   {title: 'TabFlag', field: 'TabFlag', hidden: true}
			]],
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
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f").combobox("clear");
	$("#cardType,#guser").combobox("reload");
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setValue", defDate);
	$HUI.datagrid("#invList").load({
		ClassName: "web.udhcOPQUERY",
		QueryName: "INVQUERY",
		sFlag: "ALL",
		ChargeUser: "",
		ReceipNO: "",
		PatientNO: "",
		PatientName: "",
		StartDate: "",
		EndDate: "",
		INVFlag: "N",
		INVStatus: "N",
		gLocDR: PUBLIC_CONSTANT.SESSION.GROUPID,
		ULoadLocDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
		INVFootFlag: ""
	});
	clearOrdItmList();
}