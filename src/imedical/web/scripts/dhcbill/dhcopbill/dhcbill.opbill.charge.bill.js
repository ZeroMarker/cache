/**
 * FileName: dhcbill.opbill.charge.bill.js
 * Anchor: ZhYW
 * Date: 2019-06-03
 * Description: �����շ�
 */

function initChargePanel() {
	//���ò�����ʹ�ö���֧��ʱ�����ض���֧����ʽ��
	//if (GV.AllowPayMent != "Y") {
		$("#payMentFlag").parents("tr").hide();
	//}
	initChargeMenu();
}

function initChargeMenu() {
	//ʵ��
	$("#actualMoney").keydown(function (e) {
		actualMoneyKeydown(e);
	});
	
	//���ѵ�λ
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
	//֧����ʽ
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
				$(this).combobox("clear");   //����Ĭ��֧����ʽ(query��selected=trueʱ������onSelect�¼�)
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
	
	//ҽ�����
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: "cCode",
		textField: "cDesc",
		blurValidValue: true,
		defaultFilter: 4
	});
	
	//����
	$HUI.combobox("#insuDic", {
		panelHeight: 150,
		method: 'GET',
		valueField: "DiagCode",
		textField: "DiagDesc",
		blurValidValue: true,
		defaultFilter: 4
	});
	
	getReceiptNo();
	
	//����
	$HUI.linkbutton("#btn-charge", {
		onClick: function () {
			chargeClick();
		}
	});
	
	//������
	$HUI.linkbutton("#btn-patCal", {
		onClick: function () {
			patCalClick();
		}
	});
	
	//�Һ�
	$HUI.linkbutton("#btn-reg", {
		onClick: function () {
			regClick();
		}
	});
	
	//����
	$HUI.linkbutton("#btn-skipNo", {
		onClick: function () {
			skipNoClick();
		}
	});
	
	//����Ǽ�
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
		$.messager.popover({msg: "�ð�ȫ��û���շ�Ȩ��", type: "info"});
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
		GV.RequiredInvFlag = "N";   //Ƿ�ѽ��㲻��ӡ��Ʊ
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
		setValueById("actualMoney", $(e.target).val());  //numberbox ��ʧȥ����ʱ����ܻ�ȡ��ֵ������������丳ֵ�Ա���ȡ��
		var actualMoney = getValueById("actualMoney");
		var change = numCompute(actualMoney, getPatPaySum(), "-");
		if (+change < 0) {
			$.messager.popover({msg: "ʵ������������", type: "info"});
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
		$.messager.popover({msg: "û�п��÷�Ʊ��������ȡ", type: "info"});
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
		var content = "�úŶο���Ʊ��ʣ�� <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> ��";
		$("#btn-tip").show().popover({placement: 'bottom-left', cache: false, trigger: 'hover', content: content});
	}
}

/**
* ͨ��ҽ�����ʹ������ҽ����𡢲���
*/
function loadInsuCombo(insTypeId) {
	//��ȡҽ�����ʹ���
	$.m({
		ClassName: "web.INSUDicDataCom",
		MethodName: "GetDicByCodeAndInd",
		SysType: "AdmReasonDrToDLLType",
		Code: insTypeId,
		Ind: 6,
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(insuTypeCode) {
		//ҽ�����
		$("#insuAdmType").combobox("options").url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Code=&OPIPFlag=OP&Type=AKA130" + insuTypeCode + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID;  
		$("#insuAdmType").combobox("clear").combobox("reload");
	});
	
	//����
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
	var rtn = checkSaveOrder();   //�ж�ҽ���Ƿ��ѱ���
	if (!rtn) {
		$.messager.popover({msg: "���ȱ���ҽ��", type: "info"});
		return;
	}
	var rtn = checkBill();
	if (!rtn) {
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�Ͻ���?", function (r) {
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
		$.messager.popover({msg: "û����Ҫ�����ҽ��", type: "info"});
		return;
	}
	var myPayInfo = "";  //Lid 20200601 ȷ�����ʱ�ٲ���֧����ʽ
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
		var str = "ҽ����Ҫ�������ܰ��յ�ǰ�շ������㣬���������԰���<font color='red'>" + toInsTypeDesc + "</font>���շ������㣬����[ȷ��]����" + toInsTypeDesc + "�շ������㣬����[ȡ��]ȡ����ǰ�������";
		if (dhcsys_confirm(str, "YES", "14", "ȷ��|ȡ��")) {
			if (curInsType != toInsType) {
				var changeRtn = tkMakeServerCall("web.UDHCOPOrdApproved", "ChangeOrdInstype", checkRtn, toInsType, PUBLIC_CONSTANT.SESSION.USERID, "");
				if (changeRtn == "0") {
					$.messager.popover({msg: "ҽ���շ�������˸ı䣬�뵥��[ȷ��]�����½���", type: "info"});
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
	
	//���ճ���
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
				//StrikeFlag^��ȫ��Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^�˻����^������Դ^���ݿ����Ӵ�^��������^�˻�ID^Ժ��DR^�Է�֧����ʽDR��Money^MoneyType
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
				var myDBConStr = "";       //���ݿ����Ӵ�
				var myMoneyType = "";
				var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
				myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + getValueById("paymode") + "!" + myLeftAmt + "^" + myMoneyType;
				var myCurrInsType = curInsType;
				if (chargeInsType && (chargeInsType != curInsType)) {
					myCurrInsType = chargeInsType;  //���·ѱ����ҽ���ӿ�
				}
				var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myPRTStr, admSource, myCurrInsType, myYBExpStr, myCPPFlag);
				var myYBAry = myYBRtn.split("^");
				if (myYBAry[0] == "YBCancle") {
					clearDocWin(myAdmStr, "");
					return;
				}
				if (myYBAry[0] == "HisCancleFailed") {
					clearDocWin(myAdmStr, "");
					$.messager.alert("��ʾ", "ҽ��ȡ������ɹ�����HISϵͳȡ������ʧ��", "error");
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
* ����֧����ʽ����
*/
function updatePayment(prtRowIdStr) {
	var url = "dhcbill.opbill.charge.paym.csp?&prtRowIdStr=" + prtRowIdStr;
	websys_showModal({
		url: url,
		title: '����֧��',
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
* ����֧����ʽ�б�
* ����е�����֧��Ҳ�ڴ˷��������
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
			title: '����̨-�����շ�',
			iconCls: 'icon-w-card',
			height: 650,
			width: 1000,
			closable: false,
			callbackFunc: function(returnVal) {
				var code = returnVal.code;
				var message = returnVal.message;
				var accMRowId = returnVal.accMRowId;
				setValueById("accMRowId", accMRowId);    //���������δ��������������̨���˿�֧��
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
		//������֧���ӿ� start DHCBillPayService.js
		var myExpStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		myExpStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + getValueById("papmi") + "^";
		myExpStr += "^" + prtRowIdStr.replace(/\^/g, "!") + "^^C";
		var payServRtn = PayService("OP", payMDr, payMAmt, myExpStr);
		if (payServRtn.ResultCode != "00") {
			$.messager.alert("��ʾ", "֧��ʧ�ܣ�" + payServRtn.ResultMsg, "error");
			return;
		}
		
		completeCharge(prtRowIdStr, payMList);
	}
}

/**
* �����շ�ȷ�����
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
			
			//validPrtRowIDStr(prtRowIdStr);    //��֤�����¼��ʧ�ܵĻع�
			
			billPrintTask(prtRowIdStr);   //��ӡ
			
			var msg = "����ɹ�";
			if (getValueById("reloadFlag")) {
				msg += "���������ѣ�<font color='red'>" + getPatSum()+ "</font> Ԫ����<font color='red'>" + getAccMBalance() + "</font> Ԫ";
				$.messager.alert("��ʾ", msg, "success", function() {
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
					msg += "������ӡ <font color='red'>" + prtRowIdAry.length + "</font> �ŷ�Ʊ";
				}
				$.messager.alert("��ʾ", msg, "success", function() {
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
	var localIPAddress = "";  //�ͻ���IP��ַ
	var stayFlag = "";        //���۱�ʶ
	var checkOutMode = "";    //���ҿ����Ѳ��������ʶ
	var insuDicCode = ($("#insuDic").length > 0) ? getValueById("insuDic") : "";   //���ֱ���

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
		$.messager.popover({msg: "û�н����ҽ��", type: "info"});
		return false;
	}
	if (!getValueById("receiptNo") && (GV.RequiredInvFlag == "Y")) {
		$.messager.popover({msg: "û��Ʊ�ݣ�������ȡ��Ʊ", type: "info"});
		return false;
	}
	
	//2020-06-19 ����ǿ��ҿ۷ѣ��ȶ�һ���˻����Ա㴫�˻�������̨
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
		$.messager.popover({msg: "��ѡ��֧����ʽ", type: "info"});
		return false;
	}
	if (getValueById("reloadFlag") && (getValueById("paymCode") != "CPP")) {
		$.messager.popover({msg: "ֻ��ѡ�� <font color='red'>Ԥ����</font> ֧��", type: "info"});
		return false;
	}
	$("#appendDlg").form("clear");   //��Ҫ������Ի����б�ֵ
	if (getValueById("requiredFlag") == "Y") {
		openAppendDlg();             //��������������Ի���
		return false;
	}
	var myPatSum = getPatSum();
	var actualMoney = getValueById("actualMoney");
	if (actualMoney && (+actualMoney < +myPatSum)) {
		$.messager.popover({msg: "ʵ�ս��С��Ӧ�����", type: "info"});
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
		//ҽ������������͸֧���˻������ڵ���0ʱ������͸֧
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
				$.messager.popover({msg: "����Ч", type: "info"});
				break;
			case "-201":
				$.messager.popover({msg: "�û��߲�������Ч���˻�����������֧�����˿�", type: "info"});
				break;
			case "-205":
				if (+myAry[4] != 0) {
					var msg = "���㣬���ȳ�ֵ <font color='red'>" + (+myAry[4]).toFixed(2) + "</font> Ԫ";
					if (getValueById("reloadFlag")) {
						$.messager.popover({msg: msg, type: "info"});
					}else {
						$.messager.alert("��ʾ", msg, "info", function() {
							accPayDeposit();
						});
					}
				}
				break;
			case "-206":
				$.messager.popover({msg: "�����벻һ�£���ʹ��ԭ��", type: "info"});
				break;
			case "-210":
				$.messager.popover({msg: "������֤ʧ��", type: "info"});
				break;
			default: 
				$.messager.popover({msg: "δ֪����", type: "info"});
			}
		}
		break;
	case "QF":
		var myRtn = $.m({ClassName: "web.DHCOPQFPat", MethodName: "CheckWarBal", admStr: getValueById("episodeId"), payAmt: myPatSum, sFlag: 0}, false);
		if (myRtn != "0") {
			rtn = false;
			switch(myRtn) {
			case "-1":
				$.messager.popover({msg: "����û����Ч�ĵ�����Ϣ������Ƿ�ѽ���", type: "info"});
				break;
			case "-2":
				$.messager.popover({msg: "���ߵ������㣬����Ƿ�ѽ���", type: "info"});
				break;
			}
		}
		break;
	case "CCP":
		if (!getValueById("healthCareProvider")) {
			rtn = false;
			$.messager.popover({msg: "�û��߲��ǹ��ѵ�λ�ģ������ô�֧����ʽ", type: "info"});
		}
		break;
	default:
	}
	
	return rtn;
	
	*/
}

/**
* ������Ի���
*/
function openAppendDlg() {
	$("#appendDlg").show();
	var dlgObj = $HUI.dialog("#appendDlg", {
		title: '������',
		iconCls: 'icon-w-plus',
		draggable: false,
		resizable: false,
		cache: false,
		modal: true,
		onBeforeOpen: function() {
			$("#appendDlg").form("clear");
			setValueById("chequeDate", getDefStDate(0));   //֧Ʊ����
			//����
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
					text: 'ȷ��',
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
								$.messager.popover({msg: "������<font color=red>" + $(this).text() + "</font>", type: "info"});
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
					text: '�ر�',
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
		title: '��ֵ',
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
		$.messager.popover({msg: "��ѡ��֧����ʽ", type: "info"});
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
	payStr = payStr.replace(/undefined/g, "");   //�滻���е�undefined

	return payStr;
}

///20200530
///Lid
///��ȡ�����Էѽ��
function GetPatSelfPayAmt(prtRowIdStr){
	var patSelfPayAmt = tkMakeServerCall("web.DHCBillConsIF", "GetPatSelfPayAmt", prtRowIdStr);
	return patSelfPayAmt;
}

///20200530
///Lid
///����ֱ����
function CalcInvPayMAmtRound(prtRowIdStr,payAmt){
	var invRoundInfo = tkMakeServerCall("web.DHCBillConsIF", "GetManyInvRoundErrAmt", prtRowIdStr, payAmt);
	return invRoundInfo;
}

function buildPayStr(prtRowIdStr) {
	var payStr = "";
	var paymode = getValueById("paymode");
	if (!paymode) {
		$.messager.popover({msg: "��ѡ��֧����ʽ", type: "info"});
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
	var myInvRoundErrDetails=""; //��Ʊ�ֱ������ϸ
	var actualMoney = ""; //ʵ��
	var backChange = ""; //����
	if (getValueById("paymCode") == "CASH"){
		var myRoundErrInfo = CalcInvPayMAmtRound(prtRowIdStr,mySelfPayAmt); 
		//�ֱ���������ֽ���^��Ʊrowid|�����|����ǰ���|�������!��Ʊrowid|�����|����ǰ���|�������
		mySelfPayAmt=myRoundErrInfo.split("^")[0];
		myInvRoundErrDetails=myRoundErrInfo.split("^")[1];
		var actualMoney = getValueById("actualMoney"); //ʵ��
		var backChange = getValueById("change"); //����
	}
	payStr = paymode + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard + "^" + patUnit + "^" + myChequeDate + "^" + myPayAccNo + "^" + mySelfPayAmt + "^" + myInvRoundErrDetails + "^" + actualMoney + "^" + backChange ;
	
	payStr = payStr.replace(/undefined/g, "");   //�滻���е�undefined

	return payStr;
}

function clearDocWin(admStr, unBillOrderStr) {
	//���������¼����
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
		refreshBar(getValueById("papmi"), getValueById("episodeId"));   //ˢ�»�����Ϣbanner
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
  	
 	$(".datagrid-f:not(#admList)").datagrid("loadData", {   //�����ѱ���سɹ��󼴼��ؾ����б������ﲻ�ټ��ؾ����б�
		total: 0,
		rows: []
	});

  	$.m({ClassName: "web.DHCBillCons", MethodName: "KCalTMP", sUser: PUBLIC_CONSTANT.SESSION.USERID});
}

function initFeeDoc() {
	refreshBar(getValueById("papmi"), getValueById("episodeId")); //ˢ�»�����Ϣbanner
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
			//�շѴ���ӡ���ﵥ
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
			//����ʵ�ʷ�Ʊ���շ�������ģ������
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //�˴�ֻ�޸ĵ���ģ��, ����Ҫ�޸�PrtXMLName
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}

/**
* ��֤�����¼��ʧ�ܵĻع�
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
* HIS��������
*/
function chargeRollback(prtRowId, insTypeId, admSource, insuDivId) {
	if (insuDivId != "") {
		//����ҽ������
		var myYBHand = "";
		var myCPPFlag = "";
		var myStrikeFlag = "S";
		var myInsuNo = "";
		var myCardType = "";
		var myYLLB = "";
		var myDicCode = "";
		var myDYLB = "";
		var myLeftAmt = "";
		var myMoneyType = "";  //������
		var myLeftAmtStr = myLeftAmt + "!" + myLeftAmt + "^" + myMoneyType;
		var myExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDYLB + "^" + myLeftAmtStr;
		var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insTypeId, myExpStr, myCPPFlag);
		if (rtn != "0") {
			$.messager.alert("��ʾ", "ҽ����Ʊ��Ʊ����", "error");
			return rtn;
		}
	}
	
	//HIS���ݻع�
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	if (rtn != "0") {
		$.messager.alert("��ʾ", "HIS�ع�ʧ��", "error");
	}
	
	return rtn;
}


function patCalClick() {
	var url = "dhcbill.opbill.billcashcalc.csp?&receiptNo=" + getValueById("receiptNo");
	websys_showModal({
		url: url,
		title: '������',
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
		title: '�Һ�',
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
		title: '���﷢Ʊ����',
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
		title: '����Ǽ�',
		iconCls: 'icon-w-edit',
		callbackFunc: setPatInfoByCard,
		width: 600,
		height: 327
	});
}

/**
* Lid
* 2020-05-30
* �Ƿ���ʾ����̨����
* (false:����ʾ��true:��ʾ)
*  payMCode����ʱ��ȡĬ��ϵͳ���ã���Ϊ��ʱȡ��֧����ʽ�Ƿ���Ҫ��ʾ����̨�������á�
*/
function isShowCheckOut(payMCode) {
	//Ԥ����Ƿ�ѡ����˵�֧����ʽ���õ�������̨����
	//��д�����Ժ�������
	return true;  //��д��������������̨����
	
	return ["CPP", "QF", "CCP"].indexOf(payMCode) == -1;
}

function getINVPRTJsonObj(prtRowId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: prtRowId}, false);
}