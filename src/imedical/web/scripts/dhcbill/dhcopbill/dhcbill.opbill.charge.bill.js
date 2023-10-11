/**
 * FileName: dhcbill.opbill.charge.bill.js
 * Author: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

$(function () {
	initChargeMenu();
});

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
				loadInsuCombo();
			}
		});
	}
	
	//医疗类别
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'cCode',
		textField: 'cDesc',
		blurValidValue: true,
		defaultFilter: 5
	});
	
	//病种
	$HUI.combobox("#insuDic", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'DiagCode',
		textField: 'DiagDesc',
		blurValidValue: true,
		defaultFilter: 5,
		onChange: function(newValue, oldValue) {
			if (CV.IsChkOrdByChronicCode) {
				//按选择的病种自动勾选对应医嘱
				checkOrdByChronicCode(newValue || "");
			}
		}
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
		var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
		$("#btn-tip").show().popover({placement: 'bottom-left', cache: false, trigger: 'hover', content: content});
	}
}

/**
* 加载医疗类别、病种
*/
function loadInsuCombo() {
	var adm = getValueById("episodeId");
	var curInsTypeId = getSelectedInsType();
	var chgInsTypeId = getValueById("chargeInsType");
	var insTypeId = chgInsTypeId || curInsTypeId;
	
	var CPPFlag = "N";
	var strikeFlag = "";
	var insuDivId = "";
	var expStr = "OP" + "^" + CPPFlag + "^" + strikeFlag + "^" + insuDivId;
	//医疗类别
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryMedType&ResultSetType=array&AdmDr=" + adm + "&AdmReadId=" + insTypeId + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&ExpStr=" + expStr;  
	$("#insuAdmType").combobox("clear").combobox("reload", url);

	//病种
	if ($("#insuDic").length > 0) {
		var patientId = getValueById("patientId");
		var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryChronic&ResultSetType=array&AdmDr=" + adm + "&AdmReadId=" + insTypeId + "&PapmiDr=" + patientId + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&ExpStr=" + expStr;
		$("#insuDic").combobox("clear").combobox("reload", url);
		//+2023-04-17 LUANZH 慢病患者时提示
		$("#insuDic").parents("td").prev().find("label").popover("destroy").removeClass("pseudo-hyper");
		if (isChronicAdm(adm)) {
			$("#insuDic").parents("td").prev().find("label").popover({placement: 'bottom-left', autoHide: 2000, content: $g("该患者为慢病患者")}).popover("show").addClass("pseudo-hyper");
		}
	}
}

function chargeClick() {
	/**
	* 校验能否结算
	*/
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			/*
			if (!endEditing()) {
				return reject();
			}
			var rtn = saveOrdToServer();
			if (!rtn) {
				return reject();
			}
			*/
			var rtn = checkSaveOrder();
			if (!rtn) {
				$.messager.popover({msg: "请先保存医嘱", type: "info"});
				return reject();
			}
			if (!admStr) {
				$.messager.popover({msg: "没有需要结算的就诊", type: "info"});
				return reject();
			}
			if (CV.BillByAdmSelected && !GV.OEItmList.getChecked().length) {
	            $.messager.popover({msg: "没有需要结算的医嘱", type: "info"});
	            return reject();
	        }
	        if (!getValueById("receiptNo") && (CV.RequiredInvFlag == "Y")) {
	            $.messager.popover({msg: "没有票据，请先领取发票", type: "info"});
	            return reject();
	        }
	        if ((reloadFlag != "") && (!(footUserId > 0))) {
				$.messager.alert("提示", "该安全组未对照结算操作员，不能结算，请联系信息中心维护对照", "info");
				return reject();
		    }
	        //2023-02-22 ZhYW 校验支付金额
	        var paySum = $.m({ClassName: "web.DHCOPCashier", MethodName: "GetPatOrdPaySum", admStr: admStr, insTypeId: curInsTypeId, unBillStr: unBillOrderStr, sessionStr: getSessionStr()}, false);
	        if (+paySum != +myPatSum) {
		        $.messager.popover({msg: "患者医嘱有变化，请再次读卡以重新获取医嘱信息", type: "info"});
		        return reject();
		    }
	        var isLock = lockAdm(admStr, true);   //2023-02-22 ZhYW 对当前结算就诊加锁
	        if (isLock) {
		        return reject();
		    }
	        resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var rtn = isStockEnoughAdmOrd(admStr, unBillOrderStr);
	        var myAry = rtn.split("^");
	        var msg = $g("是否确认结算？");
	        if (myAry[0] != 0) {
		        msg = (myAry[1] || myAry[0]) + "，" + msg;
		    }
		    if (typeof(GV.CfgPoint) == "undefined") GV.CfgPoint = {};	// 如果没有配置点的节点，则生成
			if (typeof(GV.CfgPoint.CheckJsTk) == "undefined"){   //如果没有该配置点则获取，如果有则判断
				//适用配置。只有当返回是1时，才会禁用弹框
				var cfgData = $.cm({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetResultByRelaCode", RelaCode: "OPCHRG.OPChrg.JSBDKDAQZ", SourceData: "", TgtData: PUBLIC_CONSTANT.SESSION.GROUPID, HospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
				GV.CfgPoint.CheckJsTk = cfgData.success;
			}
			if(GV.CfgPoint.CheckJsTk) {
				return resolve();
			}
			$.messager.confirm("确认", msg, function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 取后端结算方法需要的扩展参数
	*/
	var _getBillExpStr = function () {
		var fairType = "F"; 
		var actualMoney = "";     //实付、找零 在开发收银台后不在这里使用，传空占位即可
		var changeAmt = "";       //找零
		var roundErr = 0;
		var stayFlag = "";        //留观标识
		var checkOutMode = "";    //科室卡消费不弹界面标识
		var myAry = [];
		myAry.push(PUBLIC_CONSTANT.SESSION.GROUPID);    //1
		myAry.push(PUBLIC_CONSTANT.SESSION.CTLOCID);    //2
		myAry.push(accMRowId);                          //3
		myAry.push(CV.RequiredInvFlag);                 //4
		myAry.push(fairType);                           //5
		myAry.push(actualMoney);                        //6
		myAry.push(changeAmt);                          //7
		myAry.push(roundErr);                           //8
		myAry.push(chgInsTypeId);                       //9
		myAry.push(ClientIPAddress);                    //10
		myAry.push(stayFlag);                           //11
		myAry.push(checkOutMode);                       //12
		myAry.push(insuDicCode);                        //13
		myAry.push(footUserId);                         //14
		return myAry.join("^");
	}
	
	/**
	* HIS预结算
	*/
	var _preChg = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCOPINVCons",
				MethodName: "OPBillCharge",
				Paadminfo: admStr,
				Userid: PUBLIC_CONSTANT.SESSION.USERID,
				UnBillOrdStr: unBillOrderStr,
				Instype: curInsTypeId,
				PatPaySum: myPatSum,
				Payinfo: myPayInfo,
				gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
				SFlag: 0,
				OldINVRID: oldINVRID,
				InsPayCtl: 0,
				ExpStr: billExpStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					//预结算失败
					chargeErrorTip("preChargeError", rtn);
					return reject();
				}
				//预结算成功
				prtRowIdStr = myAry.filter(function (item) {
			        return (item > 0);
			    }).join("^");
				resolve();
			});
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function() {
		return new Promise(function (resolve, reject) {
			if (reloadFlag) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				return resolve();
			}
			if (!(admSource > 0)) {
				return resolve();
			}
			if ((myPatSum == 0) && (CV.ZeroAmtUseYBFlag != 1)) {
				return resolve();
			}
			var myYBHand = "";
			var myLeftAmt = "";
			var myCPPFlag = "NotCPPFlag";
			//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^账户余额^结算来源^数据库连接串^待遇类型^账户ID^院区DR^自费支付方式DR！Money^MoneyType
			var myStrikeFlag = "N";
			var myInsuNo = "";
			var myCardType = "";
			var myYLLB = getValueById("insuAdmType");
			var myDYLB = "";
			var myChargeSource = "01";
			var myDBConStr = "";       //数据库连接串
			var myMoneyType = "";
			var selPaymId = "";
			var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + insuDicCode + "^" + insuDicDesc;
			myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + myLeftAmt + "^" + myMoneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, prtRowIdStr, admSource, insTypeId, myYBExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] == "YBCancle") {
				clearDocWin();
				return reject();
			}
			if (myAry[0] == "HisCancleFailed") {
				$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error", function() {
					clearDocWin();
				});
				return reject();
			};
			resolve();
		});
	};
	
	/**
	* 生成支付方式列表
	* 如果有第三方支付也在此方法中完成
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			prtRowIdStr = getSuccPrtRowIdStr(prtRowIdStr);
			var invAmtInfo = getInvAmtInfo(prtRowIdStr);
			var aryAmt = invAmtInfo.split("^");
		    var totalAmt = aryAmt[0];
		    var discAmt = aryAmt[1];
		    var payorAmt = aryAmt[2];
		    var patShareAmt = aryAmt[3];
		    var insuAmt = aryAmt[4];
		    var payAmt = Number(patShareAmt).sub(insuAmt).toFixed(2); //自费支付额
		    if (payAmt == 0) {
		        return resolve();     //无需自费支付时，直接确认完成
		    }
		    var accMLeft = getAccMLeft();
		    var argumentObj = {
		        title: "收银台-门诊收费",
		        cardNo: cardNo,
		        cardTypeId: cardTypeId,
		        accMRowId: accMRowId,
		        accMLeft: accMLeft,
		        patientId: patientId,
		        episodeIdStr: admStr,
		        allowPayMent: CV.AllowPayMent,
		        insTypeId: insTypeId,
		        typeFlag: "FEE",
		        prtRowIdStr: prtRowIdStr,
		        totalAmt: totalAmt,
		        discAmt: discAmt,
		        payorAmt: payorAmt,
		        patShareAmt: patShareAmt,
		        insuAmt: insuAmt,
		        payAmt: payAmt,
		        reloadFlag: reloadFlag,
		        bizType: "OP"
		    };
		    BILL_INF.showCheckout(argumentObj).then(function (payMList) {
			    myPayInfo = payMList;
		        resolve();
		    }, function () {
		        reject();
		    });
		});
	};
	
	/**
	* HIS确认完成
	*/
	var _complete = function() {
		return new Promise(function (resolve, reject) {
			var rtn = $.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "CompleteCharge",
				CallFlag: 3,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				InsTypeDR: curInsTypeId,
				PrtRowIDStr: prtRowIdStr,
				SFlag: 0,
				OldPrtInvDR: oldINVRID,
				ExpStr: billExpStr,
				PayInfo: myPayInfo
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				return resolve();
			}
			chargeErrorTip("completeError", rtn);
			return reject();
		});
	};
	
	/**
	* 打印发票
	*/
	var _printInv = function() {
		showChangeTip(prtRowIdStr);      //显示找零信息
		//screenDisplayPrice(prtRowIdStr);    //+2022-07-18 ZhYW 外接屏显示收费信息
		billPrintTask(prtRowIdStr);         //打印
		var msg = $g("结算成功");
		if (reloadFlag) {
			msg += "，" + $g("本次消费") + "：<font color=\"red\">" + myPatSum + "</font> " + $g("元") + "，" + $g("余额") + "：<font color='red'>" + getAccMLeft() + "</font> " + $g("元");
			$.messager.alert("提示", msg, "success", function() {
				if (getValueById("medDeptFlag")) {
					clearDocWin();
					return;
				}
				websys_showModal("close");
			});
			return;
		}
		var prtRowIdAry = prtRowIdStr.split("^");
		var printInvFlag = getPropValById("DHC_INVPRT", prtRowIdAry[0], "PRT_INVPrintFlag");
		if (printInvFlag == "P") {
			msg += "，" + $g("共打印") + " <font color='red'>" + prtRowIdAry.length + "</font> " + $g("张发票");
		}
		$.messager.alert("提示", msg, "success", function() {
			clearDocWin();
		});
	};
	
	/**
	* 撤销第三方交易
	*/
	var _cancelPaySrv = function() {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
		$.each(myPayInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2), function(index, item) {
			if (item) {
				var myPayMAry = item.split("^");
				var myETPRowID = myPayMAry[11];
				if (myETPRowID) {
					var rtnValue = CancelPayService(myETPRowID, expStr);
					if (rtnValue.ResultCode != 0) {
						$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
					}
				}
			}
		});
	};
	
	if ($("#btn-charge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-charge").linkbutton("disable");
	
	var patientId = getValueById("patientId");
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var reloadFlag = getValueById("reloadFlag");
	var footUserId = PUBLIC_CONSTANT.SESSION.USERID;   //+2023-03-17 ZhYW 
	if (reloadFlag != "") {
		footUserId = getGrupContFootUser();   //取安全组与结算用户对照的配置值
	}
	var admStr = getBillAdmStr();
	var unBillOrderStr = getUnBillOrderStr();
	var curInsTypeId = getSelectedInsType();
	var chgInsTypeId = getValueById("chargeInsType");
	var insTypeId = chgInsTypeId || curInsTypeId;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	var accMRowId = getValueById("accMRowId");
	
	var insuDicCode = "";    //病种编码
	var insuDicDesc = "";    //病种描述
	if ($("#insuDic").length > 0) {
		insuDicCode = getValueById("insuDic");
		insuDicDesc = $("#insuDic").combobox("getText");
	}
	var billExpStr = _getBillExpStr();
	var prtRowIdStr = "";
	var myPayInfo = "";
	var oldINVRID = "";
	
	//增加医嘱
	var myAutoOrdInfo = autoAddNewOrder(admStr, unBillOrderStr, curInsTypeId, 0);
	
	var myPatSum = getPatSum();
	
	//唱收唱付
	soundPrice(myPatSum);
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_preChg)
		.then(_insuDiv)
		.then(_buildPayMList)
		.then(_complete)
		.then(function() {
			_printInv();
			lockAdm(admStr, false);   //2023-02-22 ZhYW 对当前结算就诊解锁
			$("#btn-charge").linkbutton("enable");
		}, function () {
			_cancelPaySrv();
			validPrtRowIDStr(prtRowIdStr);
			lockAdm(admStr, false);   //2023-02-22 ZhYW 对当前结算就诊解锁
			$("#btn-charge").linkbutton("enable");
		});
}

/**
* 返回重组发票rowId串(过滤回滚的发票rowId)
*/
function getSuccPrtRowIdStr(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillCons12", MethodName: "ValidatePrtRowID", prtRowIdStr: prtRowIdStr}, false);
}

/**
* 获取结算发票信息
*/
function getInvAmtInfo(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: prtRowIdStr}, false);
}

function getAccMLeft() {
	var accMRowId = getValueById("accMRowId");
	return (accMRowId > 0) ? $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false) : "";
}

function clearDocWin() {
	var admStr = getValueById("admStr");
	var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "GetnobilledCount",
		PAADMStr: admStr,
		unBillStr: "",
		ExpStr: myExpStr
	}, function(rtn) {
		if (rtn == 0) {
			initFeeAll();
			return;
		}
		initFeeDoc();
	});
}

function initFeeAll() {
	if (!getValueById("reloadFlag") || getValueById("medDeptFlag")) {
	  	clearBanner();
	}else {
		var patientId = getValueById("patientId");
		var episodeId = getValueById("episodeId"); 
		refreshBar(patientId, episodeId);   //刷新患者信息banner
	}
	$(":text:not(.pagination-num)").val("");

  	setValueById("patientId", "");
  	setValueById("accMRowId", "");
  	focusById("CardNo");
  	getReceiptNo();
  	
	clearAdmsRela();
}

function initFeeDoc() {
	var patientId = getValueById("patientId");
	var episodeId = getValueById("episodeId");
	refreshBar(patientId, episodeId);  //刷新患者信息banner
	
	GV.UnBillOrdObj[episodeId] = [];
	setToPayInsTypeSelected();   //2022-10-17 ZhYW
	
	getReceiptNo();
}

function getPatSum() {
	return CV.BillByAdmSelected ? getValueById("curDeptShare") : getValueById("patShareSum");
}

/**
* 插入试管等医嘱
*/
function autoAddNewOrder(admStr, unBillOrdStr, insTypeId, sFlag) {
	var mySessionStr = getSessionPara();
	var myExpStr = "";
	var encmeth = getValueById("AutoAddNewOrdEncrypt");
	var rtn = cspRunServerMethod(encmeth, admStr, unBillOrdStr, insTypeId, sFlag, mySessionStr, myExpStr);
	var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
	if (myAry[0] == 0) {
		var myFeeAry = myAry[2].split("^");
		var myAddPatSum = myFeeAry[3];
		var patShareSum = getValueById("patShareSum");
		setValueById("patShareSum", Number(patShareSum).add(myAddPatSum));
	}
	return rtn;
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
	var rtn = $.m({
		ClassName: "web.UDHCOPGSPTEdit",
		MethodName: "GetPrtListByGRowID",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		PrtType: "CP"
	}, false);
	var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
	if (myAry[0] == "Y") {
		billPrintList(myAry[1], prtInvIdStr);
		getXMLConfig(GV.INVXMLName);
		return;
	}
	invPrint(prtInvIdStr);
	//收费处打印导诊单
	var rtn = isPrintDirect();
	if (rtn) {
		directPrint(prtInvIdStr);
	}
}

/**
* 是否打印导诊单
* true: 是, false: 否
*/
function isPrintDirect() {
	if (getValueById("reloadFlag")) {
		return false;
	}
	return ($.m({ClassName: "web.DHCBillInterface", MethodName: "IGetPrtGuideFlag", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == "F");
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
	if (!prtRowIdStr) {
		return bool;
	}
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
			bool = chgRollback(prtRowId, insTypeId, admSource, insuDivId);
			if (!bool) {
				return false;
			}
		});
	}
	return bool;
}

/**
* HIS撤销结算
*/
function chgRollback(prtRowId, insTypeId, admSource, insuDivId) {
	if (insuDivId > 0) {
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
			return false;
		}
	}
	
	//HIS数据回滚
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	var myAry = rtn.split("^");
	if (myAry[0] != 0) {
		$.messager.alert("提示", "HIS回滚失败：" + (myAry[1] || myAry[0]), "error");
		return false;
	}
	return true;
}

/**
* 锁定/解锁就诊记录
* admStr: 需加锁/解锁的就诊Id
* isLock：true:加锁, false:解锁
* 返回值：true:有锁定adm, false:无锁定adm
*/
function lockAdm(admStr, isLock) {
	if (!CV.LockAdm) {
		return false;
	}
	if (!admStr) {
		return false;
	}
	if (isLock) {
		//加锁
		var rtn = $.m({ClassName: "web.DHCBillLockAdm", MethodName: "LockAdm", admStr: admStr}, false);
		if (rtn != "") {
			rtn = rtn.replace(/\^/g, "\n");
			$.messager.popover({msg: rtn, type: "info"});
			return true;
		}
		return false;
	}
	//解锁
	$.m({ClassName: "web.DHCBillLockAdm", MethodName: "UnLockAdm", wantreturnval: 0, admStr: admStr}, false);
	return false;
}

function patCalClick() {
	var url = "dhcbill.opbill.billcashcalc.csp?receiptNo=" + getValueById("receiptNo");
	websys_showModal({
		url: url,
		title: $g('计算器'),
		iconCls: 'icon-w-calc',
		width: 525,
		height: 450
	});
}

/**
* 跳号
*/
function skipNoClick() {
	var insTypeId = getSelectedInsType();
	var argumentObj = {
		receiptType: "OP",
		insTypeId: insTypeId
	};
	BILL_INF.showSkipInv(argumentObj).then(getReceiptNo);
}

function rapidRegClick() {
	var url = "opdoc.rapidregist.hui.csp?winfrom=opcharge";
	websys_showModal({
		url: url,
		title: $g('就诊登记'),
		iconCls: 'icon-w-edit',
		width: 600,
		height: 327,
		callbackFunc: setPatInfoByCard
	});
}

/**
* 显示找零信息
*/
function showChangeTip(prtRowIdStr) {
    var jsonStr = $.m({ClassName: "web.DHCOPCashier", MethodName: "GetChgedChangeInfo", prtRowIdStr: prtRowIdStr}, false);
    var json = JSON.parse(jsonStr);
    if ($.isEmptyObject(json)) {
        return;
    }
    var _html = "<table>";
    $.each(Object.keys(json), function (index, prop) {
        _html += "<tr>"
         + "<td class=\"change-desc\">"
         + $g(prop) + "："
         + "</td>"
         + "<td class=\"change-amt\">"
         + json[prop]
         + "</td>"
         + "</tr>";
    });
    _html += "</table>";
    $(".change-content").html(_html);
}

/**
* 2022-07-18
* ZhYW
* 外接屏显示收费信息
*/
function screenDisplayPrice(prtRowIdStr) {
    var url = "dhcbill.scrdisplayprice.csp?prtRowIdStr=" + prtRowIdStr;
	var w = 1024;
	var h = 768;
	var features = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=0,width=" + w + ",height=" + h + ",left=" + screen.width + ",screenindex=1,singlescreendisable=1";
	websys_createWindow(url, "SecondScreenPage", features);
}

/**
* 2023-02-20
* ZhYW
* 判断需结算医嘱当前库存是否足够
*/
function isStockEnoughAdmOrd(admStr, unBillOrdStr) {
   return $.m({ClassName: "web.DHCOPCashier", MethodName: "IsStockEnoughAdmOrd", admStr: admStr, unBillOrdStr: unBillOrdStr, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
}

/**
* 2023-03-17
* ZhYW
* 取安全组与结算用户对照的配置值
*/
function getGrupContFootUser() {
   return $.m({ClassName: "web.DHCOPCashier", MethodName: "GetGrupContFootUser", groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
}

/**
 * 2023-04-17
 * LUANZH
 * 取是否慢病
 */
function isChronicAdm(adm) {
	return ($.m({ClassName: "BILL.Interface.Inside.Invoke", MethodName: "IsChronicAdm", adm: adm}, false) == "Y");
}