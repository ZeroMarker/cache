/**
 * FileName: dhcbill.opbill.refund.main.js
 * Anchor: ZhYW
 * Date: 2019-04-23
 * Description: 门诊退费
 */

var GV = {
	DefAuditFlag: false,    //已申请退费checkbox默认(true:勾中, false:不勾中)
	INVYBConFlag: 1,
	AccPINVYBConFlag: 1,
	InvRequireFlag: "Y",
	INVXMLName: "INVPrtFlag2007",
	AccPINVXMLName: "INVPrtFlagCPP",
	ReBillFlag: 0,
	RefOrdAry: []
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initInvList();
	initRefundMenu();
	initOrdItmList();
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setText", defDate);
	setValueById("auditFlag", GV.DefAuditFlag);
	
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//查询
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});
	
	//原号重打
	$HUI.linkbutton("#btn-reprt", {
		onClick: function () {
			reprtClick();
		}
	});
	
	//过号重打
	$HUI.linkbutton("#btn-passNoReprt", {
		onClick: function () {
			passNoReprtClick();
		}
	});
	
	//补调医保
	$HUI.linkbutton("#btn-reInsuDivide", {
		onClick: function () {
			reInsuDivideClick();
		}
	});
	
	//撤销留观结算
	$HUI.linkbutton("#btn-cancleStayCharge", {
		onClick: function () {
			cancleStayChargeClick();
		}
	});
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//作废/红冲
	$HUI.linkbutton("#btn-abort, #btn-refund", {
		onClick: function () {
			refundInvClick();
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
		if (t.find(".arrows-b-text").text() == "更多") {
			t.find(".arrows-b-text").text("收起");
			t.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
			$("tr.display-more-tr").slideDown("'normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text("更多");
			t.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
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

	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPBillRefund&QueryName=FindInvUser&ResultSetType=array',
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	//医疗类别
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: "cCode",
		textField: "cDesc",
		blurValidValue: true,
		defaultFilter: 4
	});

	//病种
	$HUI.combobox("#insuDic", {
		panelHeight: 150,
		method: 'GET',
		valueField: "DiagCode",
		textField: "DiagDesc",
		blurValidValue: true,
		defaultFilter: 4
	});
	
	$.m({
		ClassName: "web.DHCOPConfig",
		MethodName: "GetOPBaseConfig",
		type: "GET",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.AccPINVYBConFlag = myAry[9];
		GV.INVYBConFlag = myAry[12];
	});
	
	$.m({
		ClassName: "web.UDHCOPGSConfig",
		MethodName: "ReadCFByGRowID",
		type: "GET",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.AbortFlag = myAry[7];    //作废权限
		GV.RefundFlag = myAry[8];   //红冲权限
		GV.INVXMLName = myAry[10];
		GV.AccPINVXMLName = myAry[11];
	});
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
	case 118: //F7
		clearClick();
		break;
	case 119: //F8
		loadInvList();
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
		columns: [[{title: '发票号', field: 'invNo', width: 100},
				   {title: '登记号', field: 'patNo', width: 100},
				   {title: '患者姓名', field: 'patName', width: 80},
				   {title: '费用总额', field: 'totalAmt', align: 'right', width: 80},
				   {title: '自付金额', field: 'patShareAmt', align: 'right', width: 80},
				   {title: '收费员', field: 'userName', width: 70},
				   {title: '收费时间', field: 'invDate', width: 155,
					formatter: function (value, row, index) {
						return value + " " + row.invTime;
					}
				   },
				   {title: 'invRowId', field: 'invRowId', hidden: true},
				   {title: 'prtRowId', field: 'prtRowId', hidden: true},   //集中打印发票关联的小条RowId
				   {title: 'invFlag', field: 'invFlag', hidden: true},
				   {title: 'auditFlag', field: 'auditFlag', hidden: true}
			]],
		onLoadSuccess: function (data) {
			if (data.total == 1) {
				$(this).datagrid("selectRow", 0);
			}else {
				clearRefPanel();
			}
		},
		rowStyler: function (index, row) {
			if (row.auditFlag == "1") {
				return "background-color: #FFEFD5;";
			}
		},
		onSelect: function (index, row) {
			selectRowHandler(row);
		}
	});
}

function selectRowHandler(row) {
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	var invNo = row.invNo;
	if (!invNo) {
		GV.InvRequireFlag = "N";
	}
	if ((invFlag == "API") && prtRowId) {      //集中打印发票自动撤销时按小条查询发票信息
		invRowId = prtRowId;
		invFlag = "PRT";
		GV.InvRequireFlag = "Y";               //集中打印发票在普通退费界面部分退费时，需要打印发票
	}
	loadOrdItmList();
	var invStr = invRowId + ":" + invFlag;
	getPaymList(invStr);
	getReceiptInfo(invStr);
}

/**
* 获取支付方式信息
*/
function getPaymList(invStr) {
	$.m({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetInvPayModeList",
		invStr: invStr
	}, function(rtn) {
		if (rtn) {
			var invPMAry = rtn.split("#");
			setValueById("invPayment", ((+invPMAry[0] > 1) ? "Y" : "N"));
			var paymAry = invPMAry[1].split("^");
			var myPMAry = [];
			var paymHtml = "<table>";
			$.each(paymAry, function (index, item) {
				myPMAry = item.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
				GV[myPMAry.pop()] = myPMAry[1];    //用支付方式代码记录支付金额
				paymHtml += "<tr>";
				paymHtml += "<td class='paym-desc'>";
				paymHtml += myPMAry[0] + "：";
				paymHtml += "</td>";
				paymHtml += "<td class='paym-amt'>";
				paymHtml += myPMAry[1];
				paymHtml += "</td>";
				paymHtml += "</tr>";
			});
			paymHtml += "</table>";
			$("#paymList").html(paymHtml);
		}
	});
}

/**
* 获取票据信息
*/
function getReceiptInfo(invStr) {
	$.cm({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetReceiptInfo",
		invStr: invStr,
		userId: PUBLIC_CONSTANT.SESSION.USERID
	}, function (jsonObj) {
		if (!jsonObj) {
			return;
		}
		var papmi = jsonObj.papmi;
		var totalAmt = jsonObj.totalAmt;
		var patShareAmt = jsonObj.patShareAmt;
		var userId = jsonObj.userId;
		var prtFlag = jsonObj.prtFlag;
		var reportsId = jsonObj.reportsId;
		var insTypeId = jsonObj.insTypeId;
		var roundErrAmt = jsonObj.roundErrAmt;
		var stayInvFlag = jsonObj.stayInvFlag;
		var invPaymCode = jsonObj.invPaymCode;
		var insuDivId = jsonObj.insuDivId;
		var insuPayAmt = jsonObj.insuPayAmt;
		var refBtnFlag = jsonObj.refBtnFlag;
		var accMRowId = jsonObj.accMRowId;
		var accMBalance = jsonObj.accMBalance;
		var accMStatus = jsonObj.accMStatus;
		var autoFlag = jsonObj.autoFlag;
		var writeOffFlag = jsonObj.writeOffFlag;

		disablePageBtn();
		setValueById("papmi", papmi);
		setValueById("accMRowId", accMRowId);
		setValueById("accMBalance", accMBalance);
		setValueById("insTypeId", insTypeId);
		setValueById("insuDivId", insuDivId);
		setValueById("stayInvFlag", stayInvFlag);
		setValueById("insuPayAmt", insuPayAmt);
		setValueById("invPaymCode", invPaymCode);
		setValueById("refBtnFlag", refBtnFlag);
		setValueById("autoFlag", autoFlag);
		
		initNewInsType(insTypeId);
		
		loadInsuCombo(insTypeId);  //加载医疗类别、病种
		
		var canRefFlag = true;    //是否有退费权限标识(true: 能退, false: 不能退)
		var refModeAry = $("#refundMode").combobox("getData");
		var index = $.hisui.indexOfArray(refModeAry, "CTPMCode", invPaymCode);
		if (index == -1) {
			canRefFlag = false;
			$("#refundMode").combobox("clear");
			if (stayInvFlag != "Y") {
				$.messager.popover({msg: "操作员没有权限退此发票", type: "info"});
			}
		}else {
			setValueById("refundMode", refModeAry[index].CTPMRowID);
		}
		
		if (prtFlag == "A") {
			$.messager.popover({msg: "该记录已作废", type: "info"});
			return;
		}else if (prtFlag == "S") {
			$.messager.popover({msg: "该记录已红冲", type: "info"});
			return;
		}
		if ((accMRowId != "") && (accMStatus != "N")) {
			$.messager.popover({msg: "该患者没有有效帐户，不能办理退费", type: "info"});
			return;
		}
		if (!insuDivId) {
			enableById("btn-reInsuDivide");
		}
		enableById("btn-reprt");
		enableById("btn-passNoReprt");
		
		if (stayInvFlag == "Y") {
			enableById("btn-cancleStayCharge");
			return;    //急诊留观的撤销留观结算后重新结算，不能在此退费
		}
		
		if (writeOffFlag == "Y") {
			disableById("btn-reInsuDivide");   //非卡支付的不能补掉医保接口
			$.messager.alert("提示", "若需退费，请先撤销集中打印发票", "info");
			return;    //需撤销集中打印发票的，不能在此退费
		}
		
		if (canRefFlag) {
			switch(refBtnFlag) {
			case "A":
				if (GV.AbortFlag != "1") {
					$.messager.popover({msg: "该安全组没有作废权限，请检查【安全组功能配置】", type: "info"});
				}else {
					enableById("btn-abort");
				}
				break;
			case "S":
				if (GV.RefundFlag != "1") {
					$.messager.popover({msg: "该安全组没有红冲权限，请检查【安全组功能配置】", type: "info"});
				}else {
					enableById("btn-refund");
				}
				break;
			default:
			}
		}
	});
}

/**
* 初始化新费别
*/
function initNewInsType(insTypeId) {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	$("#newInsType").combobox({
		panelHeight: 150,
		editable: false,
		url: $URL + "?ClassName=web.DHCOPCashier&QueryName=FindPatPrescTypeList&ResultSetType=array&papmi=" + getValueById("papmi") + "&expStr=" + expStr,
		valueField: "insTypeId",
		textField: "insType",
		onLoadSuccess: function (data) {
			if (data.length == 0) {
				return;
			}
			if ($.hisui.indexOfArray(data,"insTypeId",insTypeId) != -1) {
				$("#newInsType").combobox("select", insTypeId);
			}else {
				$.cm({
					ClassName: "web.DHCBillCommon",
					MethodName: "GetClsPropValById",
					clsName: "User.PACAdmReason",
					id: insTypeId
				}, function(jsonObj) {
					var item = {insType: jsonObj.READesc, insTypeId: insTypeId, admSource: jsonObj.REAAdmSource};
					$.hisui.addArrayItem(data, 'insTypeId', item);
					$("#newInsType").combobox("loadData", data).combobox("select", insTypeId);
				});
			}
		},
		onSelect: function(rec) {
			loadInsuCombo(rec.insTypeId);
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOPBillINV",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userId: getValueById("guser"),
		receiptNo: getValueById("invNo"),
		patientNo: getValueById("patientNo"),
		auditFlag: getValueById("auditFlag") ? 1 : 0,
		expStr: PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("invList", queryParams);
}

/**
* 初始化退费面板
*/
function initRefundMenu() {
	$("#item-tip").show();   //显示支付信息
	
	//退费方式
	$("#refundMode").combobox({
		panelHeight: 150,
		editable: false,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
		valueField: "CTPMRowID",
		textField: "CTPMDesc",
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "REF";
		},
		onSelect: function (rec) {
			var invPaymCode = getValueById("invPaymCode");
			var select = true;
			switch (rec.CTPMCode) {
			case "CPP":
				if (invPaymCode && (invPaymCode != "CPP")) {
					select = false;
					$.messager.popover({msg: "非预交金支付发票不能选预交金退费", type: "info"});
				}
				break;
			case "QF":
				if (invPaymCode && (invPaymCode != "QF")) {
					select = false;
					$.messager.popover({msg: "非欠费发票不能选欠费方式退费", type: "info"});
				}
				break;
			default:
				if (invPaymCode == "QF") {
					select = false;
					$.messager.popover({msg: "欠费发票只能选欠费方式退费", type: "info"});
				}
			}
			if (!select) {
				var refModeAry = $("#refundMode").combobox("getData");
				var index = $.hisui.indexOfArray(refModeAry, "CTPMCode", invPaymCode);
				if (index != -1) {
					setValueById("refundMode", refModeAry[index].CTPMRowID);
				}else {
					$("#refundMode").combobox("clear");
				}
			}
		}
	});
}

function initOrdItmList() {
	GV.OrdGridObj = $HUI.datagrid("#ordItmList", {
		fit: true,
		striped: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		data: [],
		toolbar: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: '医嘱', field: 'arcimDesc', width: 150},
				   {title: '退费部位', field: 'repPartTar', width: 80, align: 'center',
					formatter: function (value, row, index) {
						//检查申请单全部执行时不能退
						if ((row.isAppRepFlag == "Y") && (row.disabled == "N")) {
							return "<a href='javascript:;' class='editCls' onclick='openPartWinOnClick(" + JSON.stringify(row) + ", " + index + ")'></a>";
						}
					}
				   },
				   {title: '金额', field: 'patShareAmt', align: 'right', width: 60},
				   {title: '数量/单位', field: 'billQty', width: 85,
					formatter: function (value, row, index) {
						return value + "/" + row.packUom;
					}
				   },
				   {title: '医嘱状态', field: 'itmStat', width: 90},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '接收科室', field: 'recDept', width: 120},
				   {title: 'refQty', field: 'refQty', hidden: true},
				   {title: 'refAmt', field: 'refAmt', hidden: true},
				   {title: 'auditFlag', field: 'auditFlag', hidden: true},
				   {title: 'disabled', field: 'disabled', hidden: true},
				   {title: 'select', field: 'select', hidden: true},
				   {title: '执行情况', field: 'execInfo', width: 160},
				   {title: '医嘱日期', field: 'ordSttDate', width: 100},
				   {title: 'isAppRepFlag', field: 'isAppRepFlag', hidden: true},
				   {title: 'refRepPart', field: 'refRepPart', hidden: true},				   
				   {title: 'isCNMedItem', field: 'isCNMedItem', hidden: true},
				   {title: '医嘱ID', field: 'oeori', width: 70},
				   {title: 'pboRowId', field: 'pboRowId', hidden: true},
				   {title: 'prtId', field: 'prtId', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(".editCls").linkbutton({text: "部位"});
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.disabled == "Y") {
					hasDisabledRow = true;
					$("#ordItmList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
					if (row.select == 1) {
						$("#ordItmList").datagrid("checkRow", index);
					}
				}
			});
			//有disabled行时,表头也disabled
			$("#ordItmList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onCheck: function (index, row) {
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			if (!canCheck(row)) {
				$("#ordItmList").datagrid("uncheckRow", index);
			} else {
				controlCNMedItm(index, row);
				calcRefAmt();
			}
		},
		onUncheck: function (index, row) {
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			controlCNMedItm(index, row);
			calcRefAmt();
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (!canCheck(row)) {
					$("#ordItmList").datagrid("uncheckRow", index);
				}
			});
			calcRefAmt();
		},
		onUncheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if ((row.disabled == "Y") && (row.select == 1)) {
					$("#ordItmList").datagrid("checkRow", index);
				}
			});
			calcRefAmt();
		}
	});
}

/**
 * 判断行能否被勾选
 */
function canCheck(row) {
	if (row.select == 1) {
		return true;
	}
	if (row.disabled == "Y") {
		return false;
	}
	if ((row.isAppRepFlag == "Y") && (row.refRepPart == "")) {
		return false;
	}
	return true;
}

/**
* 新版检查申请单获取部位
*/
function openPartWinOnClick(row, index) {
	var oeori = row.oeori;
	var url = "dhcapp.repparttarwin.csp?oeori=" + oeori;
	websys_showModal({
		url: url,
		title: '部位列表',
		width: 640,
		height: 400,
		callBackFunc: function(rtn) {
			var repReqItmIdAry = [];
			$.each(rtn.split("!!"), function(idx, item) {
				var id = item.split("^")[0];
				repReqItmIdAry.push(id);
			});
			arReqItmIdStr = repReqItmIdAry.join("!!");
			
			HISUIDataGrid.setFieldValue("refRepPart", arReqItmIdStr, index, "ordItmList");
	
			if (arReqItmIdStr != "") {
				var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "UpdateExaReqFlag", oeitm: oeori, arReqItmIdStr: arReqItmIdStr}, false);
				if (+rtn != 0) {
					$.messager.popover({msg: "更新检查申请部位表退费申请状态失败：" + rtn, type: "error"});
					return;
				}
				setOrdItmRowChecked(index, true);
			} else {
				setOrdItmRowChecked(index, false);
			}
			
			//新版检查申请单全退/部分退标识
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "IsAllRefundRepPart",
				oeitm: oeori
			}, function(refPartFlag) {
				HISUIDataGrid.setFieldValue("refQty", refPartFlag, index, "ordItmList");  //0:全部或未退，1:部分退
			});
			
			//计算按部位退费金额
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "GetRepPartRefAmt",
				oeitm: oeori,
				pbo: row.pboRowId,
				arReqItmIdStr: arReqItmIdStr
			}, function (repPartAmt) {
				HISUIDataGrid.setFieldValue("refAmt", repPartAmt, index, "ordItmList");
				calcRefAmt();
			});
		}
	});
}

/**
 * 计算退费金额
 */
function calcRefAmt() {
	var refSum = 0;
	$.each($("#ordItmList").datagrid("getChecked"), function (index, row) {
		refSum = numCompute(refSum, row.refAmt, "+");
	});
	setValueById("refundAmt", refSum);
	setValueById("factRefundAmt", refSum);
}

function loadOrdItmList() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invStr = row.invRowId + ":" + row.invFlag;
	var queryParams = {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOrdItm",
		invStr: invStr,
		rows: 999999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

/**
 * 控制草药按处方退费
 */
function controlCNMedItm(index, row) {
	var prescNo = row.prescNo;
	var isCNMedItem = row.isCNMedItem;
	if ((prescNo == "") || (isCNMedItem != 1)) {
		return;
	}
	var rows = GV.OrdGridObj.getRows();
	$.each(rows, function (idx, row) {
		if ((index == idx) || (prescNo != row.prescNo)) {
			return true;
		}
		setOrdItmRowChecked(idx, getOrdItmRowChecked(index));
	});
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelOrdRowIdx = index;
	if (checked) {
		GV.OrdGridObj.checkRow(index);
	} else {
		GV.OrdGridObj.uncheckRow(index);
	}
	delete GV.SelOrdRowIdx;
}

/**
 * 设置医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return getColumnValue(index, "ck", "ordItmList") == 1;
}

/**
* 原号重打
*/
function reprtClick() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (invFlag == "API") {
		accInvReprt();
	}else {
		invReprt();
	}
}

/**
* 过号重打
*/
function passNoReprtClick() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	var invNo = row.invNo;
	if (!invNo) {
		$.messager.popover({msg: "没有打印发票，不能过号重打", type: "info"});
		return;
	}
	if (invFlag == "API") {
		var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCAccPayINV", id: invRowId}, false);
		if (jsonObj.APIFlag != "N") {
			$.messager.popover({msg: "该发票已退费，不能过号重打", type: "info"});
			return;
		}
		if (jsonObj.APIINVRepDR) {
			$.messager.popover({msg: "该发票已结账，不能过号重打", type: "info"});
			return;
		}
		if (jsonObj.APIPUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
			$.messager.popover({msg: "请联系原收费员（<font color=red>" + row.userName + "</font>）过号重打", type: "info"});
			return;
		}
	}else {
		var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
		if (jsonObj.PRTFlag != "N") {
			$.messager.popover({msg: "该发票已退费，不能过号重打", type: "info"});
			return;
		}
		if (jsonObj.PRTDHCINVPRTRDR) {
			$.messager.popover({msg: "该发票已结账，不能过号重打", type: "info"});
			return;
		}
		if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
			$.messager.popover({msg: "请联系原收费员（<font color=red>" + row.userName + "</font>）过号重打", type: "info"});
			return;
		}
	}
	$.messager.confirm("确认", "是否确认将发票【<font color='red'>" + invNo + "</font>】过号重打? ", function(r) {
		if (r) {
			var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "OPBillRefReCharge",
				invRowId: invRowId,
				invFlag: invFlag,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				expStr: expStr
			}, function(rtn) {
				var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
				if (+myAry[0] == 0) {
					var newPrtRowId = "";    //新票RowId
					if (myAry.length > 1) {
						newPrtRowId = myAry[1];
					}
					if (invFlag == "API") {
						accPInvPrint(newPrtRowId);
					}else {
						billPrintTask(newPrtRowId);
					}
					$.messager.alert("提示", "过号重打成功", "success");
					disablePageBtn();
					return;
				}else {
					switch (myAry[0]) {
					case "109":
						$.messager.alert("提示", "没有票据，不能过号重打", "info");
						break;
					case "110":
						$.messager.alert("提示", "有需要退费的医嘱，不能过号重打", "info");
						break;
					default:
						$.messager.alert("提示", "过号重打失败: " + myAry[0], "error");
					}
				}
			});
		}
	});
}

/**
* 补调医保
*/
function reInsuDivideClick() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (invFlag == "API") {
		accInvReInsuDivide();
	}else {
		invReInsuDivide();
	}
}

/**
* 撤销留观结算
*/
function cancleStayChargeClick() {
	if ($("#btn-cancleStayCharge").hasClass("l-btn-disabled")) {
		return;
	}
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	if ((invFlag == "API") && prtRowId) {    //集中打印发票自动撤销时按小条退费，在退费程序中撤消集中打印发票
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId) {
		return;
	}
	if (invFlag == "PRT") {
		cancleStayCharge();
	}
}

/**
 * 清屏
 */
function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f").combobox("clear");
	$("#cardType,#guser").combobox("reload");
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setText", defDate);
	setValueById("auditFlag", GV.DefAuditFlag);
	$("#invList").datagrid("load", {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOPBillINV",
		stDate: "",
		endDate: "",
		userId: "",
		receiptNo: "",
		patientNo: "",
		auditFlag: "",
		expStr: ""
	});
	clearRefPanel();
}

/**
 * 清除退费Panel内容
 */
function clearRefPanel() {
	$(".combobox-f:not(#cardType,#guser,#refundMode)").combobox("clear").combobox("loadData", []);
	$(".numberbox-f").numberbox("setValue", 0);
	$("#refundMode").combobox("reload");
	setValueById("invPaymCode", "");
	$("#paymList").html("");
	$(".datagrid-f:not(#invList)").datagrid("loadData", {
		total: 0,
		rows: []
	});
	disablePageBtn();
}

/**
* 作废/红冲
*/
function refundInvClick() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	if ((invFlag == "API") && prtRowId) {    //集中打印发票自动撤销时按小条退费，在退费程序中撤消集中打印发票
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId) {
		return;
	}
	if (invFlag == "API") {
		accInvRefSaveInfo();
	}else {
		invRefSaveInfo();
	}
}

function disablePageBtn() {
	disableById("btn-abort");
	disableById("btn-refund");
	disableById("btn-reprt");
	disableById("btn-passNoReprt");
	disableById("btn-reInsuDivide");
	disableById("btn-cancleStayCharge");
}

/**
* 通过医保类型代码加载医疗类别、病种
*/
function loadInsuCombo(insTypeId) {
	//获取医保类型代码
	$.m({
		ClassName: "web.INSUDicDataCom",
		MethodName: "GetDicByCodeAndInd",
		SysType: "AdmReasonDrToDLLType",
		Code: insTypeId,
		Ind: 6,
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(insuTypeCode) {
		//医疗类别
		$("#insuAdmType").combobox("options").url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Code=&OPIPFlag=OP&Type=AKA130" + insuTypeCode + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID;  
		$("#insuAdmType").combobox("clear").combobox("reload");
	});
	
	//病种
	var papmi = getValueById("papmi");
	$("#insuDic").combobox("options").url = $URL + "?ClassName=web.DHCOPAdmFind&QueryName=GetChronicList&ResultSetType=array&papmi=" + papmi + "&insuNo=&admReaId=" + insTypeId + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	$("#insuDic").combobox("clear").combobox("reload");
}