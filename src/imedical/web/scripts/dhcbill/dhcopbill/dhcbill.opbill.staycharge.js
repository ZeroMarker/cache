/**
 * FileName: dhcbill.opbill.staycharge.js
 * Anchor: ZhYW
 * Date: 2019-08-19
 * Description: 急诊留观结算
 */

var GV = {
	DefSelfPayFlag: false,        //是否自费结算checkbox默认(true:勾中，false:不勾中)
	INVYBConFlag: 1
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initChargeMenu();
	initEPDepList();
});

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 118: //F7
		clearClick();
		break;
	case 120: //F9
		chargeClick();
		break;
	default:
	}
}

function initChargeMenu() {
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//结算
	$HUI.linkbutton("#btn-charge", {
		onClick: function () {
			chargeClick();
		}
	});
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//医嘱明细
	$HUI.linkbutton("#btn-ordDtl", {
		onClick: function () {
			ordDtlClick();
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
	
	getOPBillConfig();
	
	getCFByGRowID();
	
	getReceiptNo();
	
	//就诊费别
	$HUI.combobox("#insType", {
		panelHeight: 150,
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text'
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
		var securityNo = "";
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
			var cardAccountRelation = cardTypeAry[24];
			var securityNo = "";
			var myRtn = "";
			if((cardAccountRelation == "CA") || (cardAccountRelation == "CL")) {
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

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		getPatInfo();
	}
}

function initEPDepList() {
	GV.EPDepList = $HUI.datagrid("#accDepList", {
		fit: true,
		border: true,
		title: '留观押金明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [],
		data: [],
		columns: [[{title: '金额', field: 'TAccPDPreSum', align: 'right', width: 100},
		           {title: '收据号', field: 'TAccPDBillNum', width: 180},
				   {title: '支付方式', field: 'TPayModeDesc', width: 100},
				   {title: '交款日期', field: 'TAccPDPreDate', width: 100},
				   {title: '收费员', field: 'TAccPDUserName', width: 100},
				   {title: '银行', field: 'TAPPMCMBank', width: 150},
				   {title: '账号/支票号', field: 'TAPPMCardChequeNo', width: 150},
				   {title: '单位', field: 'TCompany', width: 100},
				   {title: '状态', field: 'TAccPDType', width: 100},
				   {title: '支票日期', field: 'TAPPMChequeDate', width: 100},
				   {title: '备注', field: 'TAPPMRemark', width: 150}
			]]
	});
}

function getOPBillConfig() {
	$.m({
		ClassName: "web.DHCOPConfig",
		MethodName: "GetOPBaseConfig",
		type: "GET",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.INVYBConFlag = myAry[12];
	});
}

function getCFByGRowID() {
	$.m({
		ClassName: "web.UDHCOPGSConfig",
		MethodName: "ReadCFByGRowID",
		type: "GET",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.INVXMLName = myAry[10];   //发票模板
	});
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
			$("#btn-tip").popover({cache: false, trigger: 'hover', content: content});
		}else {
			disableById("btn-charge");
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
		}
	});
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (!patientNo) {
		return;
	}
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
			setPatientDetail(papmi);
		}
	});
}

function setPatientDetail(papmi) {
	$.m({
		ClassName: "web.DHCOPBillStayCharge",
		MethodName: "GetPatInfo",
		PatDR: papmi,
		SessionStr: getSessionStr()
	}, function(rtn) {
		var myAry = rtn.split("^");
		var episodeId = myAry[1];
		setValueById("episodeId", episodeId);
		setValueById("patientNo", myAry[2]);
		setValueById("patName", myAry[3]);
		setValueById("patSex", myAry[4]);
		if (myAry[0] == "2") {
			enableById("btn-charge");
		}else {
			disableById("btn-charge");
			var msg = (myAry[0] == "-1") ? "该患者没有急诊留观" : "未办理留观出院，不能做财务结算";
			$.messager.popover({msg: msg, type: "info"});
			return;
		}
		
		$("#insType").combobox("clear");
		var admReasonData = [{"id": myAry[8], "text": myAry[7]}];
		$("#insType").combobox("loadData", admReasonData).combobox("setValue", myAry[8]);
		
		setValueById("ward", myAry[9]);
		setValueById("dept", myAry[10]);
		setValueById("bedCode", myAry[11]);
		setValueById("disDate", myAry[12]);
		
		var accMRowId = myAry[17];
		setValueById("accMRowId", accMRowId);
		
		$.m({
			ClassName: "web.DHCOPBillStayCharge",
			MethodName: "GetBillByAdm",
			Adm: episodeId,
			ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.USERCODE + "^"
		}, function(billId) {
			setValueById("billId", billId);
			if (billId == "") {
				disableById("btn-charge");
				$.messager.popover({msg: "该患者无账单信息", type: "info"});
			}
		});
		
		//取留观押金信息
		var accMLeft = $.m({ClassName: "web.DHCOPBillEPManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
		setValueById("accMLeft", accMLeft);
		
		//取费用信息
		$.m({
			ClassName: "web.DHCOPBillStayCharge",
			MethodName: "GetStayTotalAmt",
			Adm: episodeId,
			Bill: "",
			ExpStr: "^^^^"
		}, function(rtn) {
			var myAry = rtn.split("^");
			var totalAmt = myAry[0];        //总金额
			var discAmt = myAry[1];         //折扣金额
			var payorAmt = myAry[2];        //记账金额
			var patShareAmt = myAry[3];     //自付金额
			var returnFlag = myAry[4];      //退药/退材料标识
			setValueById("patShareAmt", patShareAmt);
			setValueById("discAmt", discAmt);
			setValueById("payorAmt", payorAmt);
			var amountToPay = numCompute(patShareAmt, accMLeft, "-");
			setValueById("amountToPay", amountToPay);
			
			if (returnFlag == "1") {
				disableById("btn-charge");
				$.messager.popover({msg: "患者有已停止但未退的药品或材料医嘱，请先退回再结算", type: "info"});
			}
		});
		
		loadEPDepList();
	});
}

function loadEPDepList() {
	var queryParams = {
		ClassName: "web.DHCOPBillStayCharge",
		QueryName: "StayDepList",
		Adm: getValueById("episodeId"),
		AccountID: getValueById("accMRowId")
	};
	loadDataGridStore("accDepList", queryParams);
}

function chargeClick() {
	if ($("#btn-charge").linkbutton("options").disabled) {
		return;
	}
	$.messager.confirm("确认", "是否确认结算?", function (r) {
		if (r) {
			charge();
		}
	});
}

function charge() {
	var episodeId = getValueById("episodeId");
	if (!episodeId) {
		$.messager.popover({msg: "该患者无急诊留观就诊信息，不能结算", type: "info"});
		return;
	}
	var stayFlag = getAdmStayFlag(episodeId);
	if (stayFlag != "Y") {
		$.messager.popover({msg: "非留观患者，不能结算", type: "info"});
		return;
	}
	var stayRtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetObsPatYetDisHosp", episodeId);
	if (stayRtn != "1") {
		$.messager.popover({msg: "该患者未离院，不能结算", type: "info"});
		return;
	}
	
	var accMLeft = getValueById("accMLeft");
	if (!(+accMLeft > 0)) {
		$.messager.popover({msg: "请先交押金后再进行结算", type: "info"});
		return;
	}
	
	var patPaySum = getValueById('patShareAmt');                  //总费用
	if (!(+patPaySum > 0)) {
		$.messager.popover({msg: "无费用不需结算", type: "info"});
		return;
	}
	
	var insType = getValueById("insType");
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: insType}, false);
	var admSource = jsonObj.REAAdmSource;
	
	var requiredInvFlag = "Y";
	var accMRowId = getValueById("accMRowId");
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	expStr += "^" + accMRowId + "^" + requiredInvFlag;
	expStr += "^" + "F" + "^^^^^^" + stayFlag;

	$.m({
		ClassName: "web.DHCOPBillStayCharge",
		MethodName: "StayCharge",
		episodeId: episodeId,
		guser: PUBLIC_CONSTANT.SESSION.USERID,
		insType: insType,
		patPaySum: patPaySum,
		expStr: expStr
	}, function(rtn) {
		var billAry = rtn.split("^");
		if (billAry[0] == "0") {
			var myPRTStr = billAry.slice(1).join("^");
			if ((!getValueById("selfPayCK")) && (+GV.INVYBConFlag == 1) && (+admSource > 0)) {
				var myYBHand = "";
				var myCPPFlag = "ECPP";
				var myLeftAmt = accMLeft;
				//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^账户余额^结算来源^数据库连接串^待遇类型^账户ID^院区DR^自费支付方式DR！Money^MoneyType
				var myStrikeFlag = "N";
				var myInsuNo = "";
				var myCardType = "";
				var myYLLB = "";
				var myDicCode = "";
				var myDicDesc = "";
				var myDYLB = "";
				var myChargeSource = "01";
				var myDBConStr = "";         //数据库连接串
				var myMoneyType = "";
				var mySelPayMDR = getValueById("paymRowId");
				var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
				myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + mySelPayMDR + "!" + myLeftAmt + "^" + myMoneyType;
				var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myPRTStr, admSource, insType, myYBExpStr, myCPPFlag);
				var myYBAry = myYBRtn.split("^");
				if (myYBAry[0] == "YBCancle") {
					return;
				}
				if (myYBAry[0] == "HisCancleFailed") {
					$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
					return;
				}
			}
			myPRTStr = $.m({ClassName: "web.DHCBillCons12", MethodName: "ValidatePrtRowID", prtRowidStr: myPRTStr}, false);
			var myPayInfo = buildPayStr(myPRTStr, accMRowId);
			$.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "CompleteStayCharge",
				episodeId: episodeId,
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				insType: insType,
				prtRowIdStr: myPRTStr,
				expStr: expStr,
				payInfo: myPayInfo
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.alert("提示", "结算成功", "success", function() {
						clearDocWin();
					});
					invPrint(myPRTStr);   //打印
				}else {
					$.messager.popover({msg: "确认完成失败：" + rtn, type: "error"});
				}
			});
		}else {
			var msg = "";
			switch(billAry[0]) {
			case "101":
				msg = "留观结算没有数据：";
				break;
			case "102":
				msg = "患者的支付金额不符：";
				break;
			case "105":
				msg = "支付方式输入为空：";
				break;
			case "120":
				msg = "有异常结算记录需要处理：";
				break;
			case "125":
				msg = "账户余额不足：";
				break;
			case "133":
				msg = "账单表金额不平：";
				break;
			case "134":
				msg = "发票表与账单表金额不平：";
				break;
			default:
				msg = "结算失败：";
			}
			$.messager.popover({msg: msg + billAry[0], type: "error"});
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

function clearDocWin() {
	$(":text:not(.pagination-num)").val("");
	$(".numberbox-f").numberbox("clear");
	$(".combobox-f").combobox("clear").combobox("loadData", []);
	$("#cardType").combobox("reload");
	disableById("btn-charge");
	setValueById("accMRowId", "");
	setValueById("billId", "");
	setValueById("selfPayCK", GV.DefSelfPayFlag);
	loadEPDepList();
	getReceiptNo();
}

/**
* 清屏
*/
function clearClick() {
	clearDocWin();
}

function getAdmStayFlag(episodeId) {
	var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmStayStat", Adm: episodeId}, false);
	var myAry = rtn.split("^");
	var stayFlag = myAry[0];
	return stayFlag;
}

function ordDtlClick() {
	var billId = getValueById("billId");
	if (!billId) {
		$.messager.popover({msg: "账单为空", type: "info"});
		return;
	}
	var url = 'dhcbill.opbill.billoeitm.csp?&billId=' + billId;
	websys_showModal({
		url: url,
		title: '医嘱费用明细',
		iconCls: 'icon-w-list'
	});
}

function buildPayStr(prtRowIdStr, accMRowId) {
	var payStr = "";
	var payMCode = "ECPP";
	var payMInfo = tkMakeServerCall("web.DHCBillCommon", "GetPayModeByCode",payMCode );;
	var paymode = payMInfo.split("^")[0];
	var myPayCard = accMRowId;
	var patUnit = ""
	var myBankDR = ""
	var myCheckNo = "";
	var myChequeDate = "";
	var myPayAccNo = "";
	var myPayMAmt = "";
	
	var mySelfPayAmt = GetPatSelfPayAmt(prtRowIdStr);
	var myInvRoundErrDetails = ""; //发票分币误差明细
	var actualMoney = ""; //实收
	var backChange = ""; //找零
	          
	payStr = paymode + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard + "^" + patUnit + "^" + myChequeDate + "^" + myPayAccNo + "^" + mySelfPayAmt + "^" + myInvRoundErrDetails + "^" + actualMoney + "^" + backChange ;
	payStr = payStr.replace(/undefined/g, "");   //替换所有的undefined

	return payStr;
}

///20200608
///Lid
///获取患者自费金额
function GetPatSelfPayAmt(prtRowIdStr){
	var patSelfPayAmt = tkMakeServerCall("web.DHCBillConsIF", "GetPatSelfPayAmt", prtRowIdStr);
	return patSelfPayAmt;
}

///20200608
///Lid
///计算分币误差
function CalcInvPayMAmtRound(prtRowIdStr,payAmt){
	var invRoundInfo = tkMakeServerCall("web.DHCBillConsIF", "GetManyInvRoundErrAmt", prtRowIdStr, payAmt);
	return invRoundInfo;
}