/**
 * FileName: dhcbill.opbill.qfpayback.js
 * Anchor: ZhYW
 * Date: 2019-10-10
 * Description: 门诊欠费补回
 */﻿

var GV = {
	INVYBConFlag: 1,
	INVXMLName: "INVPrtFlag2007"
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initInvList();
	initOrdItmList();
});

$(window).load(function() {
	$("#item-tip").show();
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setText", defDate);
	
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
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//补回
	$HUI.linkbutton("#btn-restore", {
		onClick: function () {
			restoreClick();
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
	
	$("#refundMode").combobox({
		panelHeight: 150,
		editable: false,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "FEE";
		},
		loadFilter: function(data) {
			var paymCodeAry = ["CPP", "QF"];
			data = data.filter(function (item) {
		   		return paymCodeAry.indexOf(item.CTPMCode) == -1;
		  	});
			return data;
		}
	});
	
	getReceiptNo();
	
	$.m({
		ClassName: "web.DHCOPConfig",
		MethodName: "GetOPBaseConfig",
		type: "GET",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
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
		GV.INVXMLName = myAry[10];
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
	case 120: //F9
		restoreClick();
		break;
	default:
	}
}

function getReceiptNo() {
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: PUBLIC_CONSTANT.SESSION.USERID,
		GroupDR: PUBLIC_CONSTANT.SESSION.GROUPID,
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
			$("#btn-tip").popover({cache: false, trigger: 'hover', content: content, placement: 'bottom'});
		}else {
			disableById("btn-restore");
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
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

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: 'TPrtID', field: 'TPrtID', hidden: true},
				   {title: '登记号', field: 'TPatNo', width: 100},
				   {title: '患者姓名', field: 'TPatName', width: 80},
				   {title: '结算时间', field: 'PDate', width: 150,
				   	formatter: function (value, row, index) {
						return value + " " + row.PTime;
					}
				   },
				   {title: '收费员', field: 'Pusr', width: 70},
				   {title: '总金额', field: 'Acount', align: 'right', width: 80},
				   {title: 'TInsTypeDr', field: 'TInsTypeDr', hidden: true},
				   {title: 'TAdmSource', field: 'TAdmSource', hidden: true},
				   {title: '收费类别', field: 'TInsType', width: 80},
				   {title: 'TPatDr', field: 'TPatDr', hidden: true}
			]],
		onLoadSuccess: function(data) {
			setValueById("papmi", "");
			setValueById("insTypeId", "");
			$("#newInsType").combobox("clear").combobox("loadData", []);
			$("#refundMode").combobox("reload");
			$(".numberbox-f").numberbox("setValue", 0);
			$("#paymList").html("");
			$("#ordItmList").datagrid("loadData", {
				total: 0,
				rows: []
			});
			disableById("btn-restore");
		},
		onSelect: function (index, row) {
			selectRowHandler(row);
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPQFPat",
		QueryName: "PatQFDetail",
		RegNo: getValueById("patientNo"),
		Papmi: "",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("invList", queryParams);
}

function initOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		striped: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers: false,
		pageSize: 999999999,
		data: [],
		toolbar: [],
		columns: [[{title: '医嘱名称', field: 'TOrder', width: 100},
				   {title: '金额', field: 'TOrderSum', align: 'right', width: 60},
				   {title: '数量', field: 'TOrderQty', width: 60},
				   {title: '接收科室', field: 'TRecloc', width: 100},
				   {title: '就诊医生', field: 'TAdmDoctorName', width: 80},
				   {title: '医嘱状态', field: 'TStatDesc', width: 80},
				   {title: '开单医生', field: 'TCareProDesc', width: 80},
				   {title: '折扣金额', field: 'TDiscSum', align: 'right', width: 80},
				   {title: '记账金额', field: 'TPayorSum', align: 'right', width: 80},
				   {title: '医嘱开始时间', field: 'TOEORIStartTime', width: 150},
				   {title: '处方号', field: 'TOEORIPresNo', width: 100},
				   {title: '检验标本号', field: 'TOEORILabNo', width: 100}
			]]
	});
}

/**
 * 清屏
 */
function clearClick() {
	setValueById("papmi", "");
	setValueById("insTypeId", "");
	$(":text:not(#receiptNo,.pagination-num)").val("");
	$("#newInsType").combobox("clear").combobox("loadData", []);
	$("#cardType,#refundMode").combobox("reload");
	$(".datebox-f").datebox("setText", "");
	$(".numberbox-f").numberbox("setValue", 0);
	$("#paymList").html("");
	$(".datagrid-f:not(#invList)").datagrid("loadData", {
		total: 0,
		rows: []
	});
	loadInvList();
	
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setText", defDate);
	
	disableById("btn-restore");
}

function loadOrdItmList(prtRowId) {
	var queryParams = {
		ClassName: "web.UDHCOEORDOP1",
		QueryName: "ReadOEByINVRowID",
		invRowId: prtRowId,
		invType: "PRT"
	}
	loadDataGridStore("ordItmList", queryParams);
}

function selectRowHandler(row) {
	setValueById("papmi", row.TPatDr);
	setValueById("restoreAmt", row.Acount);
	var prtRowId = row.TPrtID;
	loadOrdItmList(prtRowId);
	
	var invStr = prtRowId + ":" + "PRT";
	getPaymList(invStr);
	
	//加载费别
	var insTypeId = row.TInsTypeDr;
	setValueById("insTypeId", insTypeId);
	initNewInsType(insTypeId);
	
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetClsPropValById",
		clsName: "User.DHCINVPRT",
		id: prtRowId
	}, function(jsonObj) {
		switch(jsonObj.PRTFlag) {
		case "N":
			enableById("btn-restore");
			break;
		case "A":
			$.messager.popover({msg: "该记录已作废", type: "info"});
			disableById("btn-restore");
			break;
		case "S":
			$.messager.popover({msg: "该记录已红冲", type: "info"});
			disableById("btn-restore");
			break;
		default:
		}
	});
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
					var item = {insType: jsonObj.READesc, insTypeId: insTypeId, admSource:jsonObj.REAAdmSource};
					$.hisui.addArrayItem(data, 'insTypeId', item);
					$("#newInsType").combobox("loadData", data).combobox("select", insTypeId);
				});
			}
		}
	});
}

/**
* 欠费补回
*/
function restoreClick() {
	if ($("#btn-restore").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.InvList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择要补交的结算记录", type: "info"});
		return;
	}
	var prtRowId = row.TPrtID;
	if (!prtRowId) {
		$.messager.popover({msg: "结算记录不存在", type: "info"});
		return;
	}
	var refundMode = getValueById("refundMode");
	if (!refundMode) {
		$.messager.popover({msg: "请选择补回方式", type: "info"});
		return;
	}
	var restoreAmt = getValueById("restoreAmt");
	
	var newInsType = getValueById("newInsType");
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: newInsType}, false);
	var newAdmSource = jsonObj.REAAdmSource;

	var curInsType = getValueById("insTypeId");
	$.messager.confirm("确认", "是否确认补回? ", function (r) {
		if (r) {
			if ((newInsType != "") && (newInsType != curInsType)) {
				$.messager.confirm("确认", "重新收费的收费类别发生变化，是否确认退费? ", function (r) {
					if (r) {
						_linkRestore();
					}
				});
			}else {
				_linkRestore();
			}
		}
	});
	
	function _linkRestore() {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$.m({
			ClassName: "web.DHCOPQFPat",
			MethodName: "Restoring",
			PrtRowId: prtRowId,
			RestoreAmt: restoreAmt,
			UserID: PUBLIC_CONSTANT.SESSION.USERID,
			NewInsType: newInsType,
			ExpStr: expStr
		}, function(rtn) {
			var myAry = rtn.split("^");
			switch(myAry[0]) {
			case "0":
				var myPRTStr = myAry.slice(1).join("^");
				if (!myPRTStr) {
					$.messager.alert("提示", "新票不存在", "error");
					break;
				}
				var accMRowId = "";
				if ((GV.INVYBConFlag == "1") && (+newAdmSource > 0)) {
					var myYBHand = "";
					var strikeFlag = "S";
					var insuNo = "";
					var cardType = "";
					var YLLB = "";
					var DicCode = "";
					var DicDesc = "";
					var DYLB = "";
					var chargeSource = "01";
					var DBConStr = "";       //数据库连接串
					var moneyType = "";
					var selPaymId = refundMode;
					var leftAmt = "";
					var myCPPFlag = "NotCPPFlag";
					var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
					myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
					myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
					var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myPRTStr, newAdmSource, newInsType, myExpStr, myCPPFlag);
					var myYBAry = myYBRtn.split("^");
					if (myYBAry[0] == "YBCancle") {
						//return;
					}
					if (myYBAry[0] == "HisCancleFailed") {
						$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
						//return;
					}
				}
				
				//获取新发票支付方式列表
				var myPayInfo = $.m({ClassName: "web.DHCOPQFPat", MethodName: "GetNewInvPayMList", prtRowId: prtRowId, refundMode: refundMode}, false);
				
				var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
				myExpStr += "^" + "Y" + "^" + "" + "^" + "" + "^" + "" + "^" + "";
				myExpStr += "^" + newInsType;
				$.m({
					ClassName: "web.DHCBillConsIF",
					MethodName: "CompleteCharge",
					CallFlag: 3,
					Guser: PUBLIC_CONSTANT.SESSION.USERID,
					InsTypeDR: getValueById("insTypeId"),
					PrtRowIDStr: myPRTStr,
					SFlag: 1,
					OldPrtInvDR: prtRowId,
					ExpStr: myExpStr,
					PayInfo: myPayInfo
				}, function(rtn) {
					if (rtn == "0") {
						$.messager.alert("提示", "补回成功", "success");
						billPrintTask(myPRTStr);
						reloadPanel();
					}else {
						chargeErrorTip("completeError", rtn);
					}
				});
				break;
			case "PayModeErr":
				$.messager.alert("提示", "不能选择欠费支付方式补回费用", "info");
				break;
			default:
				$.messager.alert("提示", "补回失败：" + myAry[0], "error");
			}
		});
	}
}

function reloadPanel() {
	disableById("btn-restore");
	getReceiptNo();
}

function billPrintTask(prtInvIdStr) {
	var myOldXmlName = GV.INVXMLName;
	$.m({
		ClassName: "web.UDHCOPGSPTEdit",
		MethodName: "GetPrtListByGRowID",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		PrtType: "CP"
	}, function(rtn) {
		var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
		if (myAry[0] == "Y") {
			billPrintList(myAry[1], prtInvIdStr);
			GV.INVXMLName = myOldXmlName;
			getXMLConfig(GV.INVXMLName);
		} else {
			invPrint(prtInvIdStr);
		}
		GV.INVXMLName = myOldXmlName;
	});
}

function billPrintList(prtTaskStr, prtInvIdStr) {
	var myTListAry = prtTaskStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	$.each(myTListAry, function(index, myTStr) {
		if (myTStr) {
			var myAry = myTStr.split("^");
			var myPrtXMLName = myAry[0];
			GV.INVXMLName = myPrtXMLName;
			var myClassName = myAry[1];
			var myMethodName = myAry[2];
			if ((myAry[3] == "") || (myAry[3] == "XML")) {
				if (myPrtXMLName) {
					getXMLConfig(myPrtXMLName);
					commBillPrint(prtInvIdStr, myClassName, myMethodName);
				}
			}
		}
	});
}

function commBillPrint(prtInvIdStr, className, methodName) {
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadCommOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", className, methodName, GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERID, paymDesc, myExpStr);
		}
	});
}

function invPrint(prtInvIdStr) {
	if (GV.INVXMLName == "") {
		return;
	}
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			//根据实际发票的收费类别查找模板名称
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //此处只修改调用模板, 不需要修改PrtXMLName
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}