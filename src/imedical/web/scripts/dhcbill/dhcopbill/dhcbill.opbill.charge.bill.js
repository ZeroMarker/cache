/**
 * FileName: dhcbill.opbill.charge.bill.js
 * Anchor: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

function initChargePanel() {
	//配置不允许使用多种支付时，隐藏多种支付方式行
	//if (GV.AllowPayMent != "Y") {
		$("#payMentFlag").parents("tr").hide();
	//}
	initChargeMenu();
}

function initChargeMenu() {
	//实付
	$("#actualMoney").keydown(function (e) {
		actualMoneyKeydown(e);
	});
	
	//公费单位
	$HUI.combobox("#healthCareProvider", {
		panelHeight: 150,
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text'
	});
	
	getCFByGRowID();
	
	setValueById("billByAdmSelected", GV.BillByAdmSelected);
	
	/*
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: "CTPMRowID",
		textField: "CTPMDesc",
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "FEE";
		},
		onLoadSuccess: function(data) {
			if (data.length == 0) {
				return;
			}
			var defPayMId = $(this).combobox("getValue");
			if (defPayMId) {
				$(this).combobox("clear");   //设置默认支付方式(query中selected=true时不触发onSelect事件)
			}
			if (+getValueById("accMLeft") > 0) {
				$.each(data, function (index, item) {
					if (item.CTPMCode == "CPP") {
						defPayMId = item.CTPMRowID;
						return false;
					}
				});
			}
			$(this).combobox("select", defPayMId);
		},
		onSelect: function(rec) {
			selectPayMode(rec);
		}
	});
	*/
	
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
	
	getReceiptNo();
	
	//结算
	$HUI.linkbutton("#btn-charge", {
		onClick: function () {
			chargeClick();
		}
	});
	
	//计算器
	$HUI.linkbutton("#btn-patCal", {
		onClick: function () {
			patCalClick();
		}
	});
	
	//挂号
	$HUI.linkbutton("#btn-reg", {
		onClick: function () {
			regClick();
		}
	});
	
	//跳号
	$HUI.linkbutton("#btn-skipNo", {
		onClick: function () {
			skipNoClick();
		}
	});
	
	//就诊登记
	$HUI.linkbutton("#btn-rapidReg", {
		onClick: function () {
			rapidRegClick();
		}
	});
}

function getCFByGRowID() {
	var grpCfgAry = GV.OPGroupCfgStr.split("^");
	if (grpCfgAry[2] == "0") {
		GV.DisableChargeBtn = true;
		disableById("btn-charge");
		$.messager.popover({msg: "该安全组没有收费权限", type: "info"});
	}
	GV.RequiredInvFlag = (grpCfgAry[4] == "1") ? "Y" : "N";
	GV.INVXMLName = grpCfgAry[10];
}

function selectPayMode(rec) {
	setValueById("requiredFlag", rec.RPFlag);
	var paymCode = rec.CTPMCode;
	
	setValueById("paymCode", paymCode);
	switch(paymCode) {
	case "CASH":
		setValueById("billByAdmSelected", GV.BillByAdmSelected);
		$("#payMentFlag").checkbox("enable");
		break;
	case "CPP":
		setValueById("billByAdmSelected", GV.BillByAdmSelected);
		$("#payMentFlag").checkbox("disable").checkbox("setValue", false);
		break;
	case "QF":
		setValueById("billByAdmSelected", "1");
		$("#payMentFlag").checkbox("disable").checkbox("setValue", false);
		GV.RequiredInvFlag = "N";   //欠费结算不打印发票
		break;
	default:
		setValueById("billByAdmSelected", GV.BillByAdmSelected);
		$("#payMentFlag").checkbox("enable");
	}

	setValueById("curDeptRoundShare", getRoundAmt(getValueById("curDeptShare")));
	setValueById("patRoundSum", getRoundAmt(getValueById("patShareSum")));
	
	if(isShowCheckOut(paymCode)) {
		$("#actualMoney").parents("tr").hide();
		$("#change").parents("tr").hide();
		$("#paymode").parents("tr").hide();
	}else {
		$("#actualMoney").parents("tr").hide();
		$("#change").parents("tr").hide();
		$("#paymode").parents("tr").show();
	}
}

function actualMoneyKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("actualMoney", $(e.target).val());  //numberbox 在失去焦点时候才能获取到值，所以这里给其赋值以便能取到
		var actualMoney = getValueById("actualMoney");
		var change = numCompute(actualMoney, getPatPaySum(), "-");
		if (+change < 0) {
			$.messager.popover({msg: "实付金额输入错误", type: "info"});
			$(e.target).focus().select();
			return;
		}else {
			setValueById("change", change);
			setTimeout(function() {
				focusById("btn-charge");
			}, 100);
		}
	}
}

function getReceiptNo() {
	var prtInvFlag = "";
	var fairType = "F";
	var insType = getSelectedInsType();
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + prtInvFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + fairType + "^" + insType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var encmeth = getValueById("GetOPReceiptNoEncrypt");
	var rtn = cspRunServerMethod(encmeth, "setReceiptNo", "", expStr);
	if (rtn != "0") {
		GV.DisableChargeBtn = true;
		disableById("btn-charge");
		disableById("btn-skipNo");
		$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
	}
}

function setReceiptNo(rtn) {
	var myAry = rtn.split("^");
	var currNo = myAry[0];
	var rowId = myAry[1];
	var leftNum = myAry[2];
	var endNo = myAry[3];
	var title = myAry[4];
	var tipFlag = myAry[5];
	if (rowId) {
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
		$("#btn-tip").show().popover({placement: 'bottom-left', cache: false, trigger: 'hover', content: content});
	}
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
	if ($("#insuDic").length > 0) {
		var papmi = getValueById("papmi");
		$("#insuDic").combobox("options").url = $URL + "?ClassName=web.DHCOPAdmFind&QueryName=GetChronicList&ResultSetType=array&papmi=" + papmi + "&insuNo=&admReaId=" + insTypeId + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$("#insuDic").combobox("clear").combobox("reload");
	}
}

function chargeClick() {
	if ($("#btn-charge").hasClass("l-btn-disabled")) {
		return;
	}
	var rtn = checkSaveOrder();   //判断医嘱是否已保存
	if (!rtn) {
		$.messager.popover({msg: "请先保存医嘱", type: "info"});
		return;
	}
	var rtn = checkBill();
	if (!rtn) {
		return;
	}
	$.messager.confirm("确认", "是否确认结算?", function (r) {
		if (r) {
			/*
			if (!endEditing()) {
				return;
			}
			var rtn = saveOrdToServer();
			if (!rtn) {
				return;
			}
			*/
			charge();
		}
	});
}

function charge() {
	var myAdmStr = getBillAdmStr();
	if (!myAdmStr) {
		$.messager.popover({msg: "没有需要结算的医嘱", type: "info"});
		return;
	}
	var myPayInfo = "";  //Lid 20200601 确认完成时再插入支付方式
	/*
	var myPayInfo = buildPayStr();
	if (!myPayInfo) {
		return;
	}
	*/
	var unBillOrderStr = getUnBillOrderStr();
	var myBillFlag = true;
	var curInsType = getSelectedInsType();
	var encmeth = getValueById("CheckOrdApprovedEncrypt");
	var checkRtn = cspRunServerMethod(encmeth, myAdmStr, unBillOrderStr, curInsType, "");
	if (checkRtn && (checkRtn != "0")) {
		var myAry = checkRtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
		var toInsType = myAry[1];
		var toInsTypeDesc = myAry[2];
		var str = "医嘱需要审批才能按照当前收费类别结算，不审批可以按照<font color='red'>" + toInsTypeDesc + "</font>的收费类别结算，单击[确定]按照" + toInsTypeDesc + "收费类别结算，单击[取消]取消当前结算操作";
		if (dhcsys_confirm(str, "YES", "14", "确定|取消")) {
			if (curInsType != toInsType) {
				var changeRtn = tkMakeServerCall("web.UDHCOPOrdApproved", "ChangeOrdInstype", checkRtn, toInsType, PUBLIC_CONSTANT.SESSION.USERID, "");
				if (changeRtn == "0") {
					$.messager.popover({msg: "医嘱收费类别发生了改变，请单击[确定]后重新结算", type: "info"});
					clearDocWin(myAdmStr, "");
					return;
				} else {
					myBillFlag = false;
				}
			}
		}
	}
	if (!myBillFlag) {
		return;
	}
	
	var myAutoOrdInfo = autoAddNewOrder(myAdmStr, unBillOrderStr, curInsType, 0);
	
	var myPatSum = getPatSum();
	
	//唱收唱付
	var mySoundService = "TotalFee";
	var myValAry = myPatSum + "^";
	var mySessionStr = getSessionPara();
	var myCFExpStr = "";
	var encmeth = getValueById("ReadSoundServiceEncrypt");
	var myCFRtn = cspRunServerMethod(encmeth, "DHCWCOM_SoundPriceService", mySoundService, myValAry, mySessionStr, myCFExpStr);
	//
	var accMRowId = getValueById("accMRowId");
	var roundErr = numCompute(getValueById("patShareSum"), getValueById("patRoundSum"), "-");
	var chargeInsType = getValueById("chargeInsType");
	var myExpStr = getBillExpStr();
	var oldINVRID = "";
	$.m({
		ClassName: "web.DHCOPINVCons",
		MethodName: "OPBillCharge",
		Paadminfo: myAdmStr,
		Userid: PUBLIC_CONSTANT.SESSION.USERID,
		UnBillOrdStr: unBillOrderStr,
		Instype: curInsType,
		PatPaySum: myPatSum,
		Payinfo: myPayInfo,
		gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
		SFlag: 0,
		OldINVRID: oldINVRID,
		InsPayCtl: 0,
		ExpStr: myExpStr
	}, function(chargeRtn) {
		var myConAry = chargeRtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
		var billAry = myConAry[0].split("^");
		if (billAry[0] == "0") {
			var myPrtIdAry = [];
			$.each(billAry, function (index, item) {
				if (+item > 0) {
					myPrtIdAry.push(item);
				}
			});
			var myPRTStr = myPrtIdAry.join("^");
			var admSource = getValueById("admSource");
			if ((!getValueById("reloadFlag")) && (GV.INVYBConFlag == 1) && (+admSource > 0) && (getValueById("paymCode") != "QF")) {
				var myYBHand = "";
				var myCPPFlag = "";
				var myLeftAmt = getAccMBalance();
				if (getValueById("paymCode") != "CPP") {
					myLeftAmt = "";
					myCPPFlag = "NotCPPFlag";
				}
				//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^账户余额^结算来源^数据库连接串^待遇类型^账户ID^院区DR^自费支付方式DR！Money^MoneyType
				var myStrikeFlag = "N";
				var myInsuNo = "";
				var myCardType = "";
				var myYLLB = getValueById("insuAdmType");
				var myDicCode = "";
				var myDicDesc = "";
				if ($("#insuDic").length > 0) {
					var myDicCode = getValueById("insuDic");
					var myDicDesc = $("#insuDic").combobox("getText");
				}
				var myDYLB = "";
				var myChargeSource = "01";
				var myDBConStr = "";       //数据库连接串
				var myMoneyType = "";
				var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
				myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + getValueById("paymode") + "!" + myLeftAmt + "^" + myMoneyType;
				var myCurrInsType = curInsType;
				if (chargeInsType && (chargeInsType != curInsType)) {
					myCurrInsType = chargeInsType;  //按新费别调用医保接口
				}
				var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myPRTStr, admSource, myCurrInsType, myYBExpStr, myCPPFlag);
				var myYBAry = myYBRtn.split("^");
				if (myYBAry[0] == "YBCancle") {
					clearDocWin(myAdmStr, "");
					return;
				}
				if (myYBAry[0] == "HisCancleFailed") {
					clearDocWin(myAdmStr, "");
					$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
					return;
				}
			}
			myPRTStr = $.m({ClassName: "web.DHCBillCons12", MethodName: "ValidatePrtRowID", prtRowidStr: myPRTStr}, false);
			if (getValueById("payMentFlag")) {
				updatePayment(myPRTStr);
			}else {
				buildPayMList(myPRTStr, myAdmStr);
			}
		} else {
			var myAry = chargeRtn.split(PUBLIC_CONSTANT.SEPARATOR.CH3);
			var errCode = myAry[0];
			var job = (myAry.length > 1) ? myAry[1] : "";
			chargeErrorTip("preChargeFail", errCode, job);
		}
	});
}

/**
* 多种支付方式弹窗
*/
function updatePayment(prtRowIdStr) {
	var url = "dhcbill.opbill.charge.paym.csp?&prtRowIdStr=" + prtRowIdStr;
	websys_showModal({
		url: url,
		title: '多种支付',
		iconCls: 'icon-w-paid',
		closable: false,
		height: 400,
		width: 650,
		callbackFunc: function(rtnValue) {
			if (rtnValue == "0") {
				var payMList = "";
				completeCharge(prtRowIdStr, payMList);
			}else {
				validPrtRowIDStr(prtRowIdStr);
			}
		}
	});
}

/**
* 生成支付方式列表
* 如果有第三方支付也在此方法中完成
*/
function buildPayMList(prtRowIdStr, episodeIdStr) {
	var curInsType = getSelectedInsType();
	var chargeInsType = getValueById("chargeInsType");
	if (chargeInsType != "") {
		curInsType = chargeInsType;
	}
	var reloadFlag = getValueById("reloadFlag");
	var payMCode = getValueById("paymCode");
	var patientId = getValueById("papmi");
	var cardNo = getValueById("cardNo");
	var cardTypeId = getValueById("cardType").split("^")[0];
	if (isShowCheckOut(payMCode)) {
		var url = "dhcbill.opbill.checkout.csp?allowPayMent=" + GV.AllowPayMent + "&insTypeId=" + curInsType
		url += "&typeFlag=FEE" + "&prtRowIdStr=" + prtRowIdStr;
		url += "&accMRowId=" + getValueById("accMRowId") + "&episodeIdStr=" + episodeIdStr;
		url += "&patientId=" + patientId + "&cardNo=" + cardNo;
		url += "&cardTypeId=" + cardTypeId + "&reloadFlag=" + reloadFlag;
		websys_showModal({
			url: url,
			title: '收银台-门诊收费',
			iconCls: 'icon-w-card',
			height: 650,
			width: 1000,
			closable: false,
			callbackFunc: function(returnVal) {
				var code = returnVal.code;
				var message = returnVal.message;
				var accMRowId = returnVal.accMRowId;
				setValueById("accMRowId", accMRowId);    //解决主界面未读卡，但在收银台用了卡支付
				if (code) {
					var payMList = message;
					completeCharge(prtRowIdStr, payMList);
				}else {
					validPrtRowIDStr(prtRowIdStr);
				}
			}
		});
	}else {
		var payMList = buildPayStr(prtRowIdStr);
		var payMDr = payMList.split("^")[0];
		var payMAmt = payMList.split("^")[8];
		//第三方支付接口 start DHCBillPayService.js
		var myExpStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		myExpStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + getValueById("papmi") + "^";
		myExpStr += "^" + prtRowIdStr.replace(/\^/g, "!") + "^^C";
		var payServRtn = PayService("OP", payMDr, payMAmt, myExpStr);
		if (payServRtn.ResultCode != "00") {
			$.messager.alert("提示", "支付失败：" + payServRtn.ResultMsg, "error");
			return;
		}
		
		completeCharge(prtRowIdStr, payMList);
	}
}

/**
* 门诊收费确认完成
*/
function completeCharge(prtRowIdStr, payMList) {
	var myPayInfo= payMList;
	var myAdmStr = getBillAdmStr();
	var curInsType = getSelectedInsType();
	var oldINVRID = "";
	var myExpStr = getBillExpStr();
	$.m({
		ClassName: "web.DHCBillConsIF",
		MethodName: "CompleteCharge",
		CallFlag: 3,
		Guser: PUBLIC_CONSTANT.SESSION.USERID,
		InsTypeDR: curInsType,
		PrtRowIDStr: prtRowIdStr,
		SFlag: 0,
		OldPrtInvDR: oldINVRID,
		ExpStr: myExpStr,
		PayInfo: myPayInfo
	}, function(rtn) {
		if (rtn == "0") {
			
			//validPrtRowIDStr(prtRowIdStr);    //验证结算记录，失败的回滚
			
			billPrintTask(prtRowIdStr);   //打印
			
			var msg = "结算成功";
			if (getValueById("reloadFlag")) {
				msg += "，本次消费：<font color='red'>" + getPatSum()+ "</font> 元，余额：<font color='red'>" + getAccMBalance() + "</font> 元";
				$.messager.alert("提示", msg, "success", function() {
					if (getValueById("medDeptFlag")) {
						clearDocWin(myAdmStr, "");
					}else {
						websys_showModal("close");
					}
				});
			}else {
				var prtRowIdAry = prtRowIdStr.split("^");
				var printInvFlag = getINVPRTJsonObj(prtRowIdAry[0]).PRTINVPrintFlag;
				if (printInvFlag == "P") {
					msg += "，共打印 <font color='red'>" + prtRowIdAry.length + "</font> 张发票";
				}
				$.messager.alert("提示", msg, "success", function() {
					clearDocWin(myAdmStr, "");
				});
			}
		}else {
			chargeErrorTip("completeError", rtn);
			return;
		}
	});
}

function getAccMBalance() {
	var accMLeft = "";
	var accMRowId = getValueById("accMRowId");
	if (accMRowId) {
		accMLeft = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
	}
	setValueById("accMLeft", accMLeft);
	return accMLeft;
}

function getBillExpStr() {
	var accMRowId = getValueById("accMRowId");
	var roundErr = numCompute(getValueById("patShareSum"), getValueById("patRoundSum"), "-");
	var chargeInsType = getValueById("chargeInsType");
	var localIPAddress = "";  //客户端IP地址
	var stayFlag = "";        //留观标识
	var checkOutMode = "";    //科室卡消费不弹界面标识
	var insuDicCode = ($("#insuDic").length > 0) ? getValueById("insuDic") : "";   //病种编码

	var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID;
	myExpStr += "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	myExpStr += "^" + getValueById("accMRowId");
	myExpStr += "^" + GV.RequiredInvFlag;
	myExpStr += "^" + "F";
	myExpStr += "^" + getValueById("actualMoney");
	myExpStr += "^" + getValueById("change");
	myExpStr += "^" + roundErr;
	myExpStr += "^" + chargeInsType;
	myExpStr += "^" + localIPAddress;
	myExpStr += "^" + stayFlag;
	myExpStr += "^" + checkOutMode;
	myExpStr += "^" + insuDicCode;
	
	return myExpStr;
}

function checkBill() {
	if ((getValueById("billByAdmSelected") == "1") && !GV.OEItmList.getChecked().length) {
		$.messager.popover({msg: "没有结算的医嘱", type: "info"});
		return false;
	}
	if (!getValueById("receiptNo") && (GV.RequiredInvFlag == "Y")) {
		$.messager.popover({msg: "没有票据，请先领取发票", type: "info"});
		return false;
	}
	
	//2020-06-19 如果是科室扣费，先读一下账户，以便传账户给收银台
	if (getValueById("reloadFlag")) {
		var myPatSum = getPatSum();
		var myAdmStr = getValueById("admStr");
		var myCardNo = getValueById("cardNo");
		var myCardTypeId = getValueById("cardType").split("^")[0];
		var myRtn = DHCACC_CheckMCFPay(myPatSum, myCardNo, myAdmStr, myCardTypeId);
		var myAry = myRtn.split("^");
		setValueById("accMRowId", myAry[1]);
	}
	
	return true;
	
	/*
	var paymode = getValueById("paymode");
	if (!paymode) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return false;
	}
	if (getValueById("reloadFlag") && (getValueById("paymCode") != "CPP")) {
		$.messager.popover({msg: "只能选择 <font color='red'>预交金</font> 支付", type: "info"});
		return false;
	}
	$("#appendDlg").form("clear");   //需要先清除对话框中表单值
	if (getValueById("requiredFlag") == "Y") {
		openAppendDlg();             //弹出其他必填项对话框
		return false;
	}
	var myPatSum = getPatSum();
	var actualMoney = getValueById("actualMoney");
	if (actualMoney && (+actualMoney < +myPatSum)) {
		$.messager.popover({msg: "实收金额小于应付金额", type: "info"});
		return false;
	}
	var rtn = true;
	var myAdmStr = getValueById("admStr");
	switch (getValueById("paymCode")) {
	case "CPP":
		var myCardNo = getValueById("cardNo");
		var myCardTypeId = getValueById("cardType").split("^")[0];
		var myRtn = DHCACC_CheckMCFPay(myPatSum, myCardNo, myAdmStr, myCardTypeId);
		var myAry = myRtn.split("^");
		//医保病人先运行透支，账户余额大于等于0时才运行透支
		var admSource = getValueById("admSource");
		if (+admSource > 0) {
			if (!getValueById("reloadFlag") && (myAry[0] == "-205") && (numCompute(myPatSum, myAry[4], "-") >= 0)) {
				myAry[0] = "0";
			}
		}
		setValueById("accMRowId", myAry[1]);
		if (myAry[0] != "0") {
			rtn = false;
			switch(myAry[0]) {
			case "-200":
				$.messager.popover({msg: "卡无效", type: "info"});
				break;
			case "-201":
				$.messager.popover({msg: "该患者不存在有效的账户，不能用来支付或退款", type: "info"});
				break;
			case "-205":
				if (+myAry[4] != 0) {
					var msg = "余额不足，请先充值 <font color='red'>" + (+myAry[4]).toFixed(2) + "</font> 元";
					if (getValueById("reloadFlag")) {
						$.messager.popover({msg: msg, type: "info"});
					}else {
						$.messager.alert("提示", msg, "info", function() {
							accPayDeposit();
						});
					}
				}
				break;
			case "-206":
				$.messager.popover({msg: "卡号码不一致，请使用原卡", type: "info"});
				break;
			case "-210":
				$.messager.popover({msg: "卡号验证失败", type: "info"});
				break;
			default: 
				$.messager.popover({msg: "未知错误", type: "info"});
			}
		}
		break;
	case "QF":
		var myRtn = $.m({ClassName: "web.DHCOPQFPat", MethodName: "CheckWarBal", admStr: getValueById("episodeId"), payAmt: myPatSum, sFlag: 0}, false);
		if (myRtn != "0") {
			rtn = false;
			switch(myRtn) {
			case "-1":
				$.messager.popover({msg: "患者没有有效的担保信息，不能欠费结算", type: "info"});
				break;
			case "-2":
				$.messager.popover({msg: "患者担保金额不足，不能欠费结算", type: "info"});
				break;
			}
		}
		break;
	case "CCP":
		if (!getValueById("healthCareProvider")) {
			rtn = false;
			$.messager.popover({msg: "该患者不是公费单位的，不能用此支付方式", type: "info"});
		}
		break;
	default:
	}
	
	return rtn;
	
	*/
}

/**
* 必填项对话框
*/
function openAppendDlg() {
	$("#appendDlg").show();
	var dlgObj = $HUI.dialog("#appendDlg", {
		title: '附加项',
		iconCls: 'icon-w-plus',
		draggable: false,
		resizable: false,
		cache: false,
		modal: true,
		onBeforeOpen: function() {
			$("#appendDlg").form("clear");
			setValueById("chequeDate", getDefStDate(0));   //支票日期
			//银行
			$HUI.combobox("#bank", {
				panelHeight: 150,
				url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson",
				method: 'GET',
				valueField: 'id',
				textField: 'text',
				blurValidValue: true,
				defaultFilter: 4
			});
		},
		onOpen: function() {
			focusById("checkNo");
			var id = "";
			$("#appendDlg").find("input[id]").each(function(index, item) {
				if ($(this).is(":hidden")) {
					$(this).next("span").find("input").keydown(function(e) {
						id = $(this).parents("td").find("input")[0].id;
						var key = websys_getKey(e);
						if (key == 13) {
							_setNextFocus(id);
						}
					});
				}else {
					$(this).keydown(function(e) {
						var key = websys_getKey(e);
						if (key == 13) {
							_setNextFocus(this.id);
						}
					});
				}
			});
			
			function _setNextFocus(id) {
				var myIdx = -1;
				var inputAry = $("#appendDlg").find("input[id]"); 
				inputAry.each(function(index, item) {
					if (this.id == id) {
						myIdx = index;
						return false;
					}
				});
				if (myIdx < 0) {
					return;
				}
				var id = "";
				var $obj = "";
				var nextId = "";
				for (var i = (myIdx + 1); i < inputAry.length; i++) {
					id = inputAry[i].id;
					$obj = $("#" + id);
					if ($obj.parents("tr").is(":hidden")) {
						continue;
					}
					if ($obj.is(":hidden")) {
						if ($obj.next("span").find("input").attr("readonly") == "readonly") {
							continue;
						}
						if ($obj.next("span").find("input").attr("disabled") == "disabled") {
							continue;
						}
					}else {
						if ($obj.attr("disabled") == "disabled") {
							continue;
						}
					}
					nextId = id;
					break;
				}
				if (nextId) {
					focusById(nextId);
					return;
				}else {
					setTimeout("focusById('btn-ok')", 20);
					return;
				}
			}
		},
		buttons: [{
					text: '确认',
					id: 'btn-ok',
					handler: function () {
						var bool = true;
						var id = "";
						$("#appendDlg label.clsRequired").each(function(index, item) {
							id = $($(this).parent().next().find("input"))[0].id;
							if (!id) {
								return true;
							}
							if (!getValueById(id)) {
								bool = false;
								focusById(id);
								$.messager.popover({msg: "请输入<font color=red>" + $(this).text() + "</font>", type: "info"});
								return false;
							}
						});
						if (!bool) {
							return;
						}
						charge();
						dlgObj.close();
					}
				}, {
					text: '关闭',
					handler: function () {
						dlgObj.close();
					}
				}
			]
	});
}

function accPayDeposit() {
	var accMRowId = getValueById("accMRowId");
	var cardNo = getValueById("cardNo");
	var papmi = getValueById("papmi");
	var patOrdSum = getPatPaySum();
	var url = "dhcbill.opbill.accdep.pay.csp?winfrom=opcharge&AccMRowID=" + accMRowId;
	url += "&CardNo=" + cardNo + "&PatientID=" + papmi + "&PatFactPaySum=" + patOrdSum;
	websys_showModal({
		url: url,
		title: '充值',
		iconCls: 'icon-w-inv',
		width: '85%',
		height: '85%',
		callbackFunc: charge
	});
}

function buildPayStrOld() {
	var payStr = "";
	var paymode = getValueById("paymode");
	if (!paymode) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return payStr;
	}
	var patUnit = (getValueById("paymCode") == "CCP") ? getValueById("healthCareProvider") : "";
	var myBankDR = getValueById("bank");
	var myCheckNo = getValueById("checkNo");
	var myChequeDate = getValueById("chequeDate");
	var myPayAccNo = getValueById("payAccNo");
	var myPayMAmt = getValueById("payAccNo");
	if (getValueById("paymCode") == "CASH"){
		
	}
	
	payStr = paymode + "^" + myBankDR + "^" + myCheckNo + "^^" + patUnit + "^" + myChequeDate + "^" + myPayAccNo;
	payStr = payStr.replace(/undefined/g, "");   //替换所有的undefined

	return payStr;
}

///20200530
///Lid
///获取患者自费金额
function GetPatSelfPayAmt(prtRowIdStr){
	var patSelfPayAmt = tkMakeServerCall("web.DHCBillConsIF", "GetPatSelfPayAmt", prtRowIdStr);
	return patSelfPayAmt;
}

///20200530
///Lid
///计算分币误差
function CalcInvPayMAmtRound(prtRowIdStr,payAmt){
	var invRoundInfo = tkMakeServerCall("web.DHCBillConsIF", "GetManyInvRoundErrAmt", prtRowIdStr, payAmt);
	return invRoundInfo;
}

function buildPayStr(prtRowIdStr) {
	var payStr = "";
	var paymode = getValueById("paymode");
	if (!paymode) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return payStr;
	}
	var myPayCard=getValueById("accMRowId");  
	var patUnit = (getValueById("paymCode") == "CCP") ? getValueById("healthCareProvider") : "";
	var myBankDR = getValueById("bank");
	var myCheckNo = getValueById("checkNo");
	var myChequeDate = getValueById("chequeDate");
	var myPayAccNo = getValueById("payAccNo");
	var myPayMAmt = getValueById("payAccNo");
	
	var mySelfPayAmt = GetPatSelfPayAmt(prtRowIdStr);
	var myInvRoundErrDetails=""; //发票分币误差明细
	var actualMoney = ""; //实收
	var backChange = ""; //找零
	if (getValueById("paymCode") == "CASH"){
		var myRoundErrInfo = CalcInvPayMAmtRound(prtRowIdStr,mySelfPayAmt); 
		//分币误差后的收现金金额^发票rowid|误差金额|舍入前金额|舍入后金额!发票rowid|误差金额|舍入前金额|舍入后金额
		mySelfPayAmt=myRoundErrInfo.split("^")[0];
		myInvRoundErrDetails=myRoundErrInfo.split("^")[1];
		var actualMoney = getValueById("actualMoney"); //实收
		var backChange = getValueById("change"); //找零
	}
	payStr = paymode + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard + "^" + patUnit + "^" + myChequeDate + "^" + myPayAccNo + "^" + mySelfPayAmt + "^" + myInvRoundErrDetails + "^" + actualMoney + "^" + backChange ;
	
	payStr = payStr.replace(/undefined/g, "");   //替换所有的undefined

	return payStr;
}

function clearDocWin(admStr, unBillOrderStr) {
	//清屏就诊记录解锁
	$.m({
		ClassName: "web.DHCBillLockAdm",
		MethodName: "UnLockOPAdm",
		admStr: admStr,
		lockType: "User.OEOrder"
	});
	var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "GetnobilledCount",
		PAADMStr: admStr,
		unBillStr: unBillOrderStr,
		ExpStr: myExpStr
	}, function(rtn) {
		if (rtn == 0) {
			initFeeAll();
		}else {
			initFeeDoc();
		}
	});
}

function initFeeAll() {
	if (!getValueById("reloadFlag") || getValueById("medDeptFlag")) {
	  	$(".PatInfoItem").html("");
	}else {
		refreshBar(getValueById("papmi"), getValueById("episodeId"));   //刷新患者信息banner
	}
	$(":text:not(.pagination-num)").val("");
	$("#cardType").combobox("reload");
	var url = $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array";
	$("#paymode").combobox("reload", url);
	$(".combobox-f:not(#paymode,#cardType)").combobox("clear").combobox("loadData", []);
  	getCFByGRowID();
	
  	setValueById("papmi", "");
  	setValueById("admStr", "");
  	setValueById("accMRowId", "");
  	setValueById("accMLeft", "");
  	getReceiptNo();
  	
 	$(".datagrid-f:not(#admList)").datagrid("loadData", {   //处方费别加载成功后即加载就诊列表，故这里不再加载就诊列表
		total: 0,
		rows: []
	});

  	$.m({ClassName: "web.DHCBillCons", MethodName: "KCalTMP", sUser: PUBLIC_CONSTANT.SESSION.USERID});
}

function initFeeDoc() {
	refreshBar(getValueById("papmi"), getValueById("episodeId")); //刷新患者信息banner
	getCFByGRowID();
	getReceiptNo();
	reloadOrdItmList();
}

function getPatPaySum() {
	return (getValueById("billByAdmSelected") == "1") ? getValueById("curDeptRoundShare") : getValueById("patRoundSum");
}

function getPatSum() {
	return (getValueById("billByAdmSelected") == "1") ? getValueById("curDeptShare") : getValueById("patShareSum");
}

function autoAddNewOrder(admStr, unBillOrderStr, insTypeId, sFlag) {
	var mySessionStr = getSessionPara();
	var myExpStr = "";
	var encmeth = getValueById("AutoAddNewOrdEncrypt");
	var myNOrdInfo = cspRunServerMethod(encmeth, admStr, unBillOrderStr, insTypeId, sFlag, mySessionStr, myExpStr);
	var myOrdAry = myNOrdInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
	if (myOrdAry[0] == "0") {
		var myFeeAry = myOrdAry[2].split("^");
		var myAddPatSum = myFeeAry[3];
		setValueById("patShareSum", numCompute(getValueById("patShareSum"), myAddPatSum, "+"));
		setValueById("patRoundSum", numCompute(getValueById("patRoundSum"), myAddPatSum, "+"));
	}
	return myNOrdInfo;
}

function billPrintTask(prtInvIdStr) {
	var myOldXmlName = GV.INVXMLName;
	$.m({
		ClassName: "web.UDHCOPGSPTEdit",
		MethodName: "IGetPrtGuideFlag",
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
			//收费处打印导诊单
			if (!getValueById("reloadFlag")) {
				$.m({
					ClassName: "web.DHCBillInterface", 
					MethodName: "IGetPrtGuideFlag",
					hospId: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function(rtn) {
					if (rtn == "F") {
						directPrint(prtInvIdStr);
					}
				});
			}
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
			var paymDesc = $("#paymode").combobox("getText");
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadCommOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", className, methodName, GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERID, paymDesc, myExpStr);
		}
	});
}

function invPrint(prtInvIdStr) {
	if (!GV.INVXMLName) {
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

/**
* 验证结算记录，失败的回滚
*/
function validPrtRowIDStr(prtRowIdStr) {
	var bool = true;
	var inValidStr = $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetInvalidPrtIDStr", prtRowIdStr: prtRowIdStr}, false);
	if (inValidStr != "") {
		var inValidAry = inValidStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
		$.each(inValidAry, function(index, item) {
			var singleAry = item.split("^");
			var prtRowId = singleAry[0];
			var insTypeId = singleAry[1];
			var admSource = singleAry[2];
			var insuDivId = singleAry[3];
			var rtn = chargeRollback(prtRowId, insTypeId, admSource, insuDivId);
			if (rtn != "0") {
				bool = false;
				return false;
			}
		});
	}
	return bool;
}

/**
* HIS撤销结算
*/
function chargeRollback(prtRowId, insTypeId, admSource, insuDivId) {
	if (insuDivId != "") {
		//撤销医保结算
		var myYBHand = "";
		var myCPPFlag = "";
		var myStrikeFlag = "S";
		var myInsuNo = "";
		var myCardType = "";
		var myYLLB = "";
		var myDicCode = "";
		var myDYLB = "";
		var myLeftAmt = "";
		var myMoneyType = "";  //卡类型
		var myLeftAmtStr = myLeftAmt + "!" + myLeftAmt + "^" + myMoneyType;
		var myExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDYLB + "^" + myLeftAmtStr;
		var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insTypeId, myExpStr, myCPPFlag);
		if (rtn != "0") {
			$.messager.alert("提示", "医保发票冲票错误", "error");
			return rtn;
		}
	}
	
	//HIS数据回滚
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	if (rtn != "0") {
		$.messager.alert("提示", "HIS回滚失败", "error");
	}
	
	return rtn;
}


function patCalClick() {
	var url = "dhcbill.opbill.billcashcalc.csp?&receiptNo=" + getValueById("receiptNo");
	websys_showModal({
		url: url,
		title: '计算器',
		iconCls: 'icon-w-calc',
		width: 525,
		height: 450
	});
}

function regClick() {
	if ($("#btn-reg").hasClass("l-btn-disabled")) {
		return;
	}
	var url = "opadm.reg.hui.csp?&ParaRegType=Reg";
	websys_showModal({
		url: url,
		title: '挂号',
		iconCls: 'icon-w-edit',
		width: '95%',
		height: '85%'
	});
}

function skipNoClick() {
	var receiptType = "OP";
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&CurrentInsType=" + getSelectedInsType();
	url += "&receiptType=" + receiptType + "&GroupID=" + PUBLIC_CONSTANT.SESSION.GROUPID;
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

function rapidRegClick() {
	var url = "opdoc.rapidregist.hui.csp?winfrom=opcharge";
	websys_showModal({
		url: url,
		title: '就诊登记',
		iconCls: 'icon-w-edit',
		callbackFunc: setPatInfoByCard,
		width: 600,
		height: 327
	});
}

/**
* Lid
* 2020-05-30
* 是否显示收银台界面
* (false:不显示，true:显示)
*  payMCode不传时，取默认系统配置，不为空时取该支付方式是否需要显示收银台界面配置。
*/
function isShowCheckOut(payMCode) {
	//预交金、欠费、记账等支付方式不用弹出收银台界面
	//先写死，以后做配置
	return true;  //先写死，都弹出收银台界面
	
	return ["CPP", "QF", "CCP"].indexOf(payMCode) == -1;
}

function getINVPRTJsonObj(prtRowId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: prtRowId}, false);
}