/**
 * FileName: dhcbill.opbill.accpinv.js
 * Anchor: ZhYW
 * Date: 2019-08-29
 * Description: 门诊集中打印发票
 */

var GV = {
	AccPINVYBConFlag: 1,
	AccPINVXMLName: "INVPrtFlagCPP",
	AdmSource: 0
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	showBannerTip();
	initDoc();
	initQueryMenu();
	initPayList();
	initCateList();
	initInvList();
});

function initDoc() {
	getReceiptNo();
	$.m({
		ClassName: "web.DHCOPConfig",
		MethodName: "GetOPBaseConfig",
		type: "GET",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.AccPINVYBConFlag = myAry[9];
	});
	
	$.m({
		ClassName: "web.UDHCOPGSConfig",
		MethodName: "ReadCFByGRowID",
		type: "GET",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.AccPINVXMLName = myAry[11];
	});
}

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
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
	
	//跳号
	$HUI.linkbutton("#btn-skipNo", {
		onClick: function () {
			skipNoClick();
		}
	});
	
	$("#btn-more").click(function () {
		var t = $(this);
		if (t.find(".l-btn-text").text() == "更多") {
			t.find(".l-btn-text").text("隐藏");
			$("#head-menu").layout("panel","north").panel("resize",{height: 90});
			$("#head-menu").layout("resize");
			$("tr.display-more-tr").show();
		} else {
			t.find(".l-btn-text").text("更多");
			$("#head-menu").layout("panel","north").panel("resize",{height: 50});
			$("#head-menu").layout("resize");
			$("tr.display-more-tr").hide();
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
	
	$("#stDate, #endDate").datebox({
		onSelect: function(date) {
			loadPayList();
		}
	});
	
	$(".spacing-ck>.checkbox-f[id]").checkbox({
		onCheckChange: function(e, value) {
			loadPayList();
		}
	});
	
	//患者类型
	$HUI.combobox("#patType", {
		panelHeight: 180,
		method: 'GET',
		url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadPatTypeFYB&JSFunName=GetPatTypeFYBToHUIJson&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		editable: false,
		valueField: 'value',
		textField: 'text'
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
	case 120: //F9
		printClick();
		break;
	default:
	}
}

function initPayList() {
	GV.PayList = $HUI.datagrid("#payList", {
		fit: true,
		striped: true,
		title: '支付列表',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		checkOnSelect: false,   //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: [],
		frozenColumns: [[{title: 'ck', field: 'ck', checkbox: true}]],
		columns: [[{title: '结算ID', field: 'prtRowId', width: 80,
				    formatter: function (value, row, index) {
					   	if (value) {
							return "<a href='javascript:;' onclick=\"orderDetail(\'" + value + "\')\">" + value + "</a>";
						}
				   	}
				   },
				   {title: '费用总额', field: 'acount', align: 'right', width: 100},
				   {title: '支付日期', field: 'date', width: 100},
				   {title: '支付时间', field: 'time', width: 100},
				   {title: '操作员', field: 'usrName', width: 100},
				   {title: 'accPLRowId', field: 'accPLRowId', hidden: true},
				   {title: '支付方式', field: 'paymStr', width: 150},
				   {title: '支付号码', field: 'accPayNo', width: 130},
				   {title: '支付额', field: 'accPayAmt', hidden: true},
				   {title: '余额', field: 'accPayLeft', align: 'right', width: 100},
				   {title: '自付金额', field: 'patAmt', align: 'right', width: 100},
				   {title: '折扣金额', field: 'discAmt', align: 'right', width: 100},
				   {title: '记账金额', field: 'payorAmt', align: 'right', width: 100},
			]],
		onLoadSuccess: function (data) {
			if (data.total == 0) {
				$(this).datagrid("clearChecked");
			}else {
				$(this).datagrid("checkAll");
			}
		},
		onCheck: function (rowIndex, rowData) {
			checkPayListHandler();
		},
		onUncheck: function (rowIndex, rowData) {
			checkPayListHandler();
		},
		onCheckAll: function (rows) {
			checkPayListHandler();
		},
		onUncheckAll: function (rows) {
			checkPayListHandler();
		}
	});
	GV.PayList.loadData({total: 0, rows: []});
}

function orderDetail(prtRowId) {
	var url = "dhcbill.opbill.invoeitm.csp?&invRowId=" + prtRowId + "&invType=PRT";
	websys_showModal({
		url: url,
		title: '医嘱明细',
		iconCls: 'icon-w-list'
	});
}

function initCateList() {
	GV.CateList = $HUI.datagrid("#cateList", {
		fit: true,
		striped: true,
		title: '分类信息',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		singleSelect: true,
		rownumbers: true,
		remoteSort: false,
		showFooter: true,
		loadMsg: '',
		toolbar: [],
		pageSize: 99999999,
		columns: [[{title: '分类', field: 'cateDesc', width: 70},
				   {title: '金额',field: 'cateAmt', align: 'right', width: 70, sortable: true,
					   	sorter: function (a, b) {
						   	return ((numCompute(a, b, "-") > 0) ? 1 : -1);
						}
				   }
			]],
		onLoadSuccess: function(data) {
			if (data.footer && (data.footer.length > 0)) {
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").css("visibility","visible");
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").text(data.total + 1);
			}
		}
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		width: 400,
		height: 180,
		fitColumns: true,
		singleSelect: true,
		bodyCls: 'panel-header-gray',
		rownumbers: true,
		loadMsg: '',
		pageSize: 999999999,
		columns: [[{title: 'errCode', field: 'errCode', hidden: true},
				   {title: 'insTypeDR', field: 'insTypeDR', hidden: true},
				   {title: '费别', field: 'insTypeDesc', width: 100},
				   {title: '金额', field: 'invAmt', width: 110, align: 'right'},
				   {title: 'invPrtValue', field: 'invPrtValue', hidden: true}
			]]
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

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").linkbutton("options").disabled) {
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
			setValueById("accMRowId", myAry[7]);
			setPatDetail(myAry[4]);
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			setPatDetail(myAry[4]);
			break;
		default:
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
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
			var cardAccountRelation = cardTypeAry[24];
			var securityNo = "";
			var myRtn = "";
			if((cardAccountRelation == "CA") || (cardAccountRelation == "CL")){
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "");
			}else {
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
			}
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				setValueById("accMRowId", myAry[7]);
				setPatDetail(myAry[4]);
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
				setPatDetail(myAry[4]);
				break;
			default:
			}
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
				setValueById("papmi", "");
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				focusById("patientNo");
			}else {
				setPatDetail(papmi);
			}
		});
	}
}

function setPatDetail(papmi) {
	setValueById("papmi", papmi);
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: ""
	}, function(rtn) {
		var myAry = rtn.split("^");
		var myPatientNo = myAry[1];
		var myPatType = myAry[7];
		var myAccMRowId = myAry[19];
		setValueById("patientNo", myPatientNo);
		setValueById("accMRowId", myAccMRowId);
		$.each($("#patType").combobox("getData"), function(index, item) {
			var val = item.value;
			if (myPatType == val.split("^")[0]) {
				setValueById("patType", val);
				return false;
			}
		});
	});
	refreshBar(papmi, "");
	loadPayList();
}

function loadPayList() {
	var papmi = getValueById("papmi");
	if (!papmi) {
		return;
	}
	var queryParams = {
		ClassName: "web.DHCACPayList",
		QueryName: "FindPatPayList",
		patientId: getValueById("papmi"),
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		isRegInv: getValueById("regInvCK") ? "Y" : "N",
		isInsuDiv: getValueById("insuDivCK") ? "Y" : "N",
		isStayInv: getValueById("stayInvCK") ? "Y" : "N",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999999
	}
	loadDataGridStore("payList", queryParams);
}

function getReceiptNo() {
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: PUBLIC_CONSTANT.SESSION.USERID,
		GroupDR: "",   //这里不考虑安全组
		ExpStr: "F^^" + PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == "0") {
			var currNo = myAry[1];
			var rowId = myAry[2];
			var endNo = myAry[3];
			var title = myAry[4];
			var leftNum = myAry[5];
			var tipFlag = myAry[6];
			var receiptNo = title + "[" + currNo + "]";
			setValueById("receiptNo", receiptNo);
			var color = "green";
			if ($("#receiptNo").hasClass("newClsInvalid")) {
				$("#receiptNo").removeClass("newClsInvalid");
			}
			if (tipFlag == "1") {
				color = "red";
				$("#receiptNo").addClass("newClsInvalid");
			}
			var content = "该号段可用票据剩余 <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> 张";
			$("#btn-tip").popover({cache: false, trigger: 'hover', content: content});
		}else {
			disableById("btn-print");
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
		}
	});
}

function getPrtRowIdStr() {
	var prtRowIdAry = [];
	$.each(GV.PayList.getChecked(), function (index, row) {
		prtRowIdAry.push(row.prtRowId);
	});
	var prtRowIdStr = prtRowIdAry.join("^");
	return prtRowIdStr;
}

function checkPayListHandler() {
	var prtRowIdStr = getPrtRowIdStr();
	loadCateList(prtRowIdStr);
	parseINVInfo(prtRowIdStr);
	$(".layout-panel-south .layout-panel-east").find(".numberbox-f[id]").numberbox("clear");   //清空打印面板numberbox的值
}

function loadCateList(prtRowIdStr) {
	var queryParams = {
		ClassName: "web.DHCACPayList",
		QueryName: "FindCateList",
		prtRowIdStr: prtRowIdStr,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		totalFields: "cateAmt",
		totalFooter: '"cateDesc":"合计"',
		rows: 99999999
	}
	loadDataGridStore("cateList", queryParams);
}

function parseINVInfo(prtRowIdStr) {
	if (!prtRowIdStr) {
		$("#invList").datagrid("loadData", {total: 0, rows: []});
		return;
	}
	delServerTMP();
	
	var isInsuDiv = getValueById("insuDivCK") ? 1: 0;      //医保已结算标识
	var isStayInv = getValueById("stayInvCK") ? "Y" : "N";
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
	expStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + isStayInv + "^" + isInsuDiv;
	$.cm({
		ClassName: "web.UDHCAccPrtPayFoot",
		QueryName: "ParPrtToINVList",
		type: "GET",
		INVPrtStr: prtRowIdStr,
		ExpStr: expStr,
		rows: 99999999
	}, function(data) {
		if (data.rows[0].errCode != 0) {
			$.messager.alert("提示", "分解发票错误：" + data.rows[0].errCode, "error");
		}else {
			$("#invList").datagrid("loadData", data);
			var invPrtValue = data.rows[0].invPrtValue;
			var myCID = invPrtValue.split("|")[5];   //进程号
			setValueById("CID", myCID);
		}
	});
}

/**
* 清除临时global
*/
function delServerTMP() {
	var myCID = getValueById("CID");
	if (myCID) {
		$.m({ClassName: "web.UDHCACINVColPrt", MethodName: "KillINVTMP", wantreturnval: 0, ID: myCID});
	}
	$.m({ClassName: "web.UDHCACINVColPrt", MethodName: "KTMP", wantreturnval: 0});
}

/**
* 打印发票
*/
function printClick() {
	if ($("#btn-print").linkbutton("options").disabled) {
		return;
	}
	if (GV.PayList.getChecked().length == 0) {
		$.messager.popover({msg: "请勾选需要打印的结算记录", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认打印发票？", function(r) {
		if (r) {
			var patType = getValueById("patType");
			var myAry = patType.split("^");
			var myInsType = myAry[0];
			GV.AdmSource = myAry[2];
			var admReason = myAry[3];    //取病人类型对照的默认费别
			
			var myCID = getValueById("CID");
			if (!myCID) {
				$.messager.alert("提示", "没有可打印数据", "info");
				return;
			}
			
			if (isCallInsuDiv()) {
				var myYBHand = "0";
				var myStrikeFlag = "";
				var myInsuNo = "";
				var myCardType = "";
				var myYLLB = "";
				var myDicCode = "";
				var myDicDesc = "";//数据库连接串
				var myDYLB = "";
				var myChargeSource = "01";
				var myDBConStr = "";
				var myLeftAmt = "";
				var accMRowId = getValueById("accMRowId");
				var myMoneyType = "";
				var mySelPayMDR = "";
				var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
				myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + mySelPayMDR + "!" + myLeftAmt + "^" + myMoneyType;
				var CPPFlag = "Y";
				var myYBRtn = InsuOPDivide(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myCID, GV.AdmSource, admReason, myYBExpStr, CPPFlag);
				if (myYBRtn != "0") {
					$.messager.alert("提示", "医保分解错误：" + myYBRtn, "error");
					return;
				}
			}

			var isInsuDiv = getValueById("insuDivCK") ? 1: 0;
			var expStr = "^^^^^" + isInsuDiv;
			$.cm({
				ClassName: "web.UDHCAccPrtPayFoot",
				QueryName: "ReadInvListForYB",
				type: "GET",
				TMPGID: myCID,
				ExpStr: expStr,
				rows: 99999999
			}, function(data) {
				if (data.rows[0].errCode != 0) {
					$.messager.alert("提示", "打印时分解发票错误：" + data.rows[0].errCode, "error");
					return;
				}
				
				$("#invList").datagrid("loadData", data);    //重新载入发票信息	
				var myYBSum = 0;
				var mySelfPaySum = 0;
				var myRefSum = 0;
				var myYBAccPaySum = 0;
				var myYBTCPaySum = 0;
				var myYBDBPaySum = 0;
				var myPrtColAry = [];
				$.each(data.rows, function(index, row) {
					var myVal = row.invPrtValue.replace(/\|/g, PUBLIC_CONSTANT.SEPARATOR.CH3).replace(/\#/g, PUBLIC_CONSTANT.SEPARATOR.CH4);
					myPrtColAry.push(myVal);
					var myListAry = myVal.split(PUBLIC_CONSTANT.SEPARATOR.CH3);
					var myAry3 = myListAry[3];
					var myAry33 = myAry3.split("^");
					myYBSum = numCompute(myYBSum, myAry33[0], "+");
					mySelfPaySum = numCompute(mySelfPaySum, myAry33[1], "+");
					myRefSum = numCompute(myRefSum, myAry33[2], "+");
					var myAry4 = myListAry[4];
					var myAry44 = myAry4.split("^");
					myYBAccPaySum = numCompute(myYBAccPaySum, myAry44[1], "+");
					myYBTCPaySum = numCompute(myYBTCPaySum, myAry44[2], "+");
					myYBDBPaySum = numCompute(myYBDBPaySum, myAry44[3], "+");
			    });
				var myINVSum = numCompute(myYBSum, mySelfPaySum, "+");
				setValueById("insuTotalSum", myYBSum);
				setValueById("selfPaySum", mySelfPaySum);
				setValueById("refundSum", myRefSum);
				setValueById("insuAccPaySum", myYBAccPaySum);
				setValueById("insuPaySum", myYBTCPaySum);
				setValueById("insuDBSum", myYBDBPaySum);
				setValueById("totalSum", myINVSum);
				
			    var myPrtColStr = myPrtColAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			    //保存发票
			    saveInv(myPrtColStr);
			});
		}
	});
}

function saveInv(myColStr) {
	var myCID = getValueById("CID");
	var insuRtn = "Y!";
	if (isCallInsuDiv()) {
		insuRtn = $.m({ClassName: "web.DHCOPINVCons", MethodName: "CheckAPIInsuData", TMPGID: myCID, ExpStr: ""}, false);
	}
	var insuAry = insuRtn.split("!");
	if (!myColStr || (insuAry[0] != "Y")) {
		if (insuAry[1] != "") {
			$.each(insuAry[1].split("@"), function (index, val) {
				var myAry = val.split("^");
				var outString = "";
				var myYBHand = "0";
				var myInsuDivDR = myAry[0];
				var myInsuType = myAry[1];
				var myAdmSource = myAry[2];
				if (myInsuDivDR == "") {
					return true;
				}
				var myYBExpStr = "^^^";
				var myCPPFlag = "Y";
				var outString = InsuOPDivideStrike(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myInsuDivDR, myAdmSource, myInsuType, myYBExpStr, myCPPFlag);
			});
		}
		$.messager.popover({msg: "请清屏后，重新读卡", type: "info"});
		return;
	}
	
	var accMRowId = getValueById("accMRowId");
	var papmi = getValueById("papmi");
	var isStayInv = getValueById("stayInvCK") ? "Y" : "N";
	var oldAPIRowID = "";
	var isInsuDiv = getValueById("insuDivCK") ? 1 : 0;
	var newInsType = "";
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	expStr += "^" + oldAPIRowID + "^" + isStayInv + "^" + isInsuDiv + "^" + newInsType;

	$.m({
		ClassName: "web.UDHCAccPrtPayFoot",
		MethodName: "APayColPrtUpdate",
		APINVInfo: myColStr,
		UserDR: PUBLIC_CONSTANT.SESSION.USERID,
		AccMDR: accMRowId,
		PAPMIDR: papmi,
		ExpStr: expStr
	}, function (rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == "0") {
			delServerTMP();
			var accPInvIdStr = myAry.slice(1).join("^");
			accPInvPrint(accPInvIdStr);
			$.messager.alert("提示", "打印成功", "success", function() {
				clearDocWin(papmi);
			});
		}else {
			$.messager.alert("提示", "打印失败：" + rtn, "error");
		}
	});
}

/**
* 是否调用医保分解
*/
function isCallInsuDiv() {
	var bool = true;
	if (!(+GV.AdmSource > 0)) {
		return false;
	}
	$(".spacing-ck>.checkbox-f[id]").each(function(index, element) {
		if ($(this).checkbox("getValue")) {
			bool = false;
			return false;
		}
	});
	return bool;
}

function accPInvPrint(accPInvIdStr) {
	if (GV.AccPINVXMLName == "") {
		return;
	}
	var myAry = accPInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			getXMLConfig(GV.AccPINVXMLName);
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.AccPINVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}

function clearDocWin(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCACPayList",
		MethodName: "GetNoPrintNum",
		patientId: papmi,
		expStr: expStr
	}, function(rtn) {
		if (rtn == "0") {
			initAllDoc();
		}else {
			initPartDoc();
		}
	});
}

function initAllDoc() {
	setValueById("papmi", "");
	setValueById("accMRowId", "");
	setValueById("CID", "");
	$(".PatInfoItem").html("");
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f").combobox("reload");
	$(".numberbox-f").numberbox("clear");
	$(".datebox-f").datebox("clear");
	$(".checkbox-f").checkbox("uncheck");
	GV.AdmSource = 0;
	showBannerTip();
	GV.PayList.loadData({total: 0, rows: []});
	getReceiptNo();
}

function initPartDoc() {
	GV.PayList.reload();
	getReceiptNo();
}

/**
* 清屏
*/
function clearClick() {
	initAllDoc();
}

/**
* 跳号
*/
function skipNoClick() {
	var receiptType = "OP";
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&receiptType=" + receiptType;
	websys_showModal({
		url: url,
		title: '门诊发票跳号',
		iconCls: 'icon-skip-no',
		width: 520,
		height: 227,
		onClose: function() {
			getReceiptNo();
		}
	});
}

/**
* 离开页面时清除临时global
*/
$(window).unload(function() {
  	delServerTMP();
});

