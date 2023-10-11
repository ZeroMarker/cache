/**
 * FileName: dhcbill.opbill.charge.bill.js
 * Anchor: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

function initChargePanel() {
	initChargeMenu();
}

function initChargeMenu() {
	if (CV.ChargeFlag == "N") {
		$.messager.popover({msg: "该安全组没有收费权限", type: "info"});
	}
	
	//公费单位
	$HUI.combobox("#healthCareProvider", {
		panelHeight: 150,
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text'
	});
	
	//结算费别
	if ($("#chargeInsType").length > 0) {
		$HUI.combobox("#chargeInsType", {
			panelHeight: 150,
			method: 'GET',
			editable: false,
			valueField: 'insTypeId',
			textField: 'insType',
			onSelect: function(rec) {
				setValueById("admSource", rec.admSource);
				loadInsuCombo(rec.insTypeId);
			}
		});
	}
	
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
	
	getReceiptNo();
}

function getReceiptNo() {
	var prtInvFlag = "";
	var fairType = "F";
	var insType = getSelectedInsType();
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + prtInvFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + fairType + "^" + insType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var encmeth = getValueById("GetOPReceiptNoEncrypt");
	var rtn = cspRunServerMethod(encmeth, "setReceiptNo", "", expStr);
	if (rtn != 0) {
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
		if (tipFlag == 1) {
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
		var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Code=&OPIPFlag=OP&Type=AKA130" + insuTypeCode + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID;  
		$("#insuAdmType").combobox("clear").combobox("reload", url);
	});
	
	//病种
	if ($("#insuDic").length > 0) {
		var papmi = getValueById("patientId");
		var url = $URL + "?ClassName=web.DHCOPAdmFind&QueryName=GetChronicList&ResultSetType=array&papmi=" + papmi + "&insuNo=&admReaId=" + insTypeId + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$("#insuDic").combobox("clear").combobox("reload", url);
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
	
	checkBill().then(function (rtn) {
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
	});
}

function charge() {
	var myAdmStr = getBillAdmStr();
	if (!myAdmStr) {
		$.messager.popover({msg: "没有需要结算的医嘱", type: "info"});
		return;
	}
	var unBillOrderStr = getUnBillOrderStr();
	var curInsType = getSelectedInsType();
	
	//增加医嘱
	var myAutoOrdInfo = autoAddNewOrder(myAdmStr, unBillOrderStr, curInsType, 0);
	
	var myPatSum = getPatSum();
	
	//唱收唱付
	soundPrice(myPatSum);
	
	var myPayInfo = "";   //Lid 20200601 确认完成时再插入支付方式
	var accMRowId = getValueById("accMRowId");
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
		var billAry = chargeRtn.split("^");
		if (billAry[0] == 0) {
			var myPrtIdAry = billAry.filter(function (item) {
			        return (item > 0);
			    });
			var myPRTStr = myPrtIdAry.join("^");
			var admSource = getValueById("admSource");
			//ShangXuehao 2020-11-25 如果自付费用为0并且费用为0不调医保返回false
			var zeroAmtUseYB = ((myPatSum > 0) || (CV.ZeroAmtUseYBFlag == 1));
			if (!getValueById("reloadFlag") && (CV.INVYBConFlag == 1) && (admSource > 0) && zeroAmtUseYB) {
				var myYBHand = "";
				var myLeftAmt = "";
				var myCPPFlag = "NotCPPFlag";
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
				var selPaymId = "";
				var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
				myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + myLeftAmt + "^" + myMoneyType;
				var myCurrInsType = curInsType;
				if (chargeInsType && (chargeInsType != curInsType)) {
					myCurrInsType = chargeInsType;  //按新费别调用医保接口
				}
				var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myPRTStr, admSource, myCurrInsType, myYBExpStr, myCPPFlag);
				var myYBAry = myYBRtn.split("^");
				if (myYBAry[0] == "YBCancle") {
					clearDocWin();
					return;
				}else if (myYBAry[0] == "HisCancleFailed") {
					$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error", function() {
						clearDocWin();
					});
					return;
				};
			}
			myPRTStr = getSuccPrtRowIdStr(myPRTStr);
			
			$.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "GetPatSelfPayAmt",
				prtRowIdStr: myPRTStr
			}, function(rtn) {
				if (rtn != 0) {
					buildPayMList(myPRTStr, myAdmStr);
				}else {
					completeCharge(myPRTStr, "");
				}
			});
		} else {
			var myAry = chargeRtn.split(PUBLIC_CONSTANT.SEPARATOR.CH3);
			var errCode = myAry[0];
			var job = (myAry.length > 1) ? myAry[1] : "";
			chargeErrorTip("preChargeFail", errCode, job);
		}
	});
}

/**
* 返回重组发票rowId串(过滤回滚的发票rowId)
*/
function getSuccPrtRowIdStr(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillCons12", MethodName: "ValidatePrtRowID", prtRowIdStr: prtRowIdStr}, false);
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
			if (rtnValue == 0) {
				completeCharge(prtRowIdStr, "");
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
	var patientId = getValueById("patientId");
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var accMRowId = getValueById("accMRowId");
	
	var argumentObj = {
		cardNo: cardNo,
		cardTypeId: cardTypeId,
		accMRowId: accMRowId,
		patientId: patientId,
		episodeIdStr: episodeIdStr,
		allowPayMent: CV.AllowPayMent,
		insTypeId: curInsType,
		typeFlag: "FEE",
		prtRowIdStr: prtRowIdStr,
		reloadFlag: reloadFlag
	};
	var url = "dhcbill.opbill.checkout.csp?arguments=" + encodeURIComponent(JSON.stringify(argumentObj));
	websys_showModal({
		url: url,
		title: '收银台-门诊收费',
		iconCls: 'icon-w-card',
		height: 650,
		width: 1000,
		closable: false,
		callbackFunc: function(rtnValue) {
			var code = rtnValue.code;
			var message = rtnValue.message;
			if (code) {
				var payMList = message;
				completeCharge(prtRowIdStr, payMList);
			}else {
				validPrtRowIDStr(prtRowIdStr);
			}
		}
	});
}

/**
* 门诊收费确认完成
*/
function completeCharge(prtRowIdStr, payMList) {
	var myPayInfo = payMList;
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
		if (rtn == 0) {
			//validPrtRowIDStr(prtRowIdStr);    //验证结算记录，失败的回滚
			billPrintTask(prtRowIdStr);     //打印			
			var msg = "结算成功";
			if (getValueById("reloadFlag")) {
				msg += "，本次消费：<font color='red'>" + getPatSum()+ "</font> 元，余额：<font color='red'>" + getAccMBalance() + "</font> 元";
				$.messager.alert("提示", msg, "success", function() {
					if (getValueById("medDeptFlag")) {
						clearDocWin();
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
					clearDocWin();
				});
			}
		}else {
			chargeErrorTip("completeError", rtn);
			//撤销第三方交易
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			$.each(myPayInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2), function(index, item) {
				if (item) {
					var myPayMAry = item.split("^");
					var myETPRowID = myPayMAry[11];
					if (myETPRowID) {
						var rtnValue = CancelPayService(myETPRowID, expStr);
						if (rtnValue.ResultCode != 0){
							$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
						}
					}
				}
			});
			//
		}
	});
}

function getAccMBalance() {
	var accMLeft = "";
	var accMRowId = getValueById("accMRowId");
	if (accMRowId) {
		accMLeft = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
	}
	return accMLeft;
}

function getBillExpStr() {
	var accMRowId = getValueById("accMRowId");
	var actualMoney = "";   //实付、找零 在开发收银台后不在这里使用，传空占位即可
	var changeAmt = "";     //找零
	var roundErr = 0;
	var chargeInsType = getValueById("chargeInsType");
	var localIPAddress = "";  //客户端IP地址
	var stayFlag = "";        //留观标识
	var checkOutMode = "";    //科室卡消费不弹界面标识
	var insuDicCode = ($("#insuDic").length > 0) ? getValueById("insuDic") : "";   //病种编码

	var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID;
	myExpStr += "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	myExpStr += "^" + accMRowId;
	myExpStr += "^" + CV.RequiredInvFlag;
	myExpStr += "^" + "F";
	myExpStr += "^" + actualMoney;
	myExpStr += "^" + changeAmt;
	myExpStr += "^" + roundErr;
	myExpStr += "^" + chargeInsType;
	myExpStr += "^" + localIPAddress;
	myExpStr += "^" + stayFlag;
	myExpStr += "^" + checkOutMode;
	myExpStr += "^" + insuDicCode;
	
	return myExpStr;
}

function checkBill() {
    var _checkMCFPay = function (_callback) {
        new Promise(function (resolve, reject) {
            var myCardNo = getValueById("CardNo");
            var myCardTypeId = getValueById("CardTypeRowId");
            if (!myCardNo || !myCardTypeId) {
                return resolve("0^"); //无卡时按成功返回
            }
            var myPatSum = getPatSum();
            var myAdmStr = getValueById("admStr");
            DHCACC_CheckMCFPay(myPatSum, myCardNo, myAdmStr, myCardTypeId, "", resolve);
        }).then(function (rtnValue) {
            var bool = false;
            var myAry = rtnValue.split("^");
            setValueById("accMRowId", myAry[1]);
            switch (myAry[0]) {
            case "0":
                bool = true;
                break;
            case "-200":
                $.messager.alert("提示", "卡无效", "info", function () {
                    focusById("CardNo");
                });
                break;
            case "-201":
                if (getValueById("reloadFlag")) {
                    $.messager.popover({msg: "账户无效", type: "info"});
                } else {
                    bool = true;
                }
                break;
            case "-204":
                $.messager.popover({msg: "密码验证失败", type: "info"});
                break;
            case "-205":
                if (getValueById("reloadFlag")) {
                    $.messager.popover({msg: "账户余额不足", type: "info"});
                } else {
                    bool = true;
                }
                break;
            case "-206":
                $.messager.popover({msg: "卡号不一致，请插入原卡", type: "info"});
                break;
            case "-208":
                bool = true;
                break;
            default:
            }
            _callback(bool);
        });
    }

    return new Promise(function (resolve, reject) {
        if (CV.BillByAdmSelected && !GV.OEItmList.getChecked().length) {
            $.messager.popover({msg: "没有结算的医嘱", type: "info"});
            return;
        }
        if (!getValueById("receiptNo") && (CV.RequiredInvFlag == "Y")) {
            $.messager.popover({msg: "没有票据，请先领取发票", type: "info"});
            return;
        }
        _checkMCFPay(resolve);
    });
}

function clearDocWin() {
	var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "GetnobilledCount",
		PAADMStr: getValueById("admStr"),
		unBillStr: "",
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
		refreshBar(getValueById("patientId"), getValueById("episodeId"));   //刷新患者信息banner
	}
	$(":text:not(.pagination-num)").val("");

	$(".combobox-f").combobox("clear").combobox("loadData", []);
	
	lockAdm(false);   //就诊解锁

  	setValueById("patientId", "");
  	setValueById("admStr", "");
  	setValueById("accMRowId", "");
  	focusById("CardNo");
  	getReceiptNo();
  	
  	if (GV.EditRowIndex) {
	  	GV.OEItmList.endEdit(GV.EditRowIndex);
	}
 	$(".datagrid-f").datagrid("loadData", {   //处方费别加载成功后即加载就诊列表，故这里不再加载就诊列表
		total: 0,
		rows: []
	});

  	$.m({ClassName: "web.DHCBillCons", MethodName: "KCalTMP", sUser: PUBLIC_CONSTANT.SESSION.USERID});
}

function initFeeDoc() {
	refreshBar(getValueById("patientId"), getValueById("episodeId")); //刷新患者信息banner
	getReceiptNo();
	reloadOrdItmList();
}

function getPatSum() {
	return CV.BillByAdmSelected ? getValueById("curDeptShare") : getValueById("patShareSum");
}

/**
* 插入试管等医嘱
*/
function autoAddNewOrder(admStr, unBillOrderStr, insTypeId, sFlag) {
	var mySessionStr = getSessionPara();
	var myExpStr = "";
	var encmeth = getValueById("AutoAddNewOrdEncrypt");
	var myNOrdInfo = cspRunServerMethod(encmeth, admStr, unBillOrderStr, insTypeId, sFlag, mySessionStr, myExpStr);
	var myOrdAry = myNOrdInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
	if (myOrdAry[0] == 0) {
		var myFeeAry = myOrdAry[2].split("^");
		var myAddPatSum = myFeeAry[3];
		setValueById("patShareSum", numCompute(getValueById("patShareSum"), myAddPatSum, "+"));
		setValueById("patRoundSum", numCompute(getValueById("patRoundSum"), myAddPatSum, "+"));
	}
	return myNOrdInfo;
}

/**
* 唱收唱付
*/
function soundPrice(patSum) {
	var mySoundService = "TotalFee";
	var myValAry = patSum + "^";
	var mySessionStr = getSessionPara();
	var myCFExpStr = "";
	var encmeth = getValueById("ReadSoundServiceEncrypt");
	var myCFRtn = cspRunServerMethod(encmeth, "DHCWCOM_SoundPriceService", mySoundService, myValAry, mySessionStr, myCFExpStr);
}

function billPrintTask(prtInvIdStr) {
	GV.INVXMLName = CV.INVXMLName;
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
* 验证结算记录，失败的倒序撤销
*/
function validPrtRowIDStr(prtRowIdStr) {
	var bool = true;
	//倒序
	prtRowIdStr = prtRowIdStr.split("^").sort(function(a, b) {
		return b - a;
	}).join("^");
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
			if (rtn != 0) {
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
		if (rtn != 0) {
			$.messager.alert("提示", "医保发票冲票错误", "error");
			return rtn;
		}
	}
	
	//HIS数据回滚
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	if (rtn != 0) {
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

function getINVPRTJsonObj(prtRowId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: prtRowId}, false);
}