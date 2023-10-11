/**
 * FileName: dhcbill.opbill.charge.excepiton.js
 * Author: ZhYW
 * Date: 2019-08-28
 * Description: 门诊收费异常处理
 */

$(function () {
	initQueryMenu();
	initTPInvList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	//读医保卡
	$HUI.linkbutton("#btn-readInsuCard", {
		onClick: function () {
			readInsuCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadTPInvList();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//收费员
	var userName = $.m({ClassName: "User.SSUser", MethodName: "GetTranByDesc", Prop: "SSUSRName", Desc: PUBLIC_CONSTANT.SESSION.USERNAME, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
	$HUI.combobox("#user", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		data: [{id: PUBLIC_CONSTANT.SESSION.USERID, text: userName, selected: true}]
	});
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
	$("#btn-readCard").linkbutton("toggleAble");
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

/**
 * 读医保卡
 */
function readInsuCardClick() {
	if ($("#btn-readInsuCard").linkbutton("options").disabled) {
		return;
	}
	$("#btn-readInsuCard").linkbutton("toggleAble");
	var rtn = InsuReadCard(0, PUBLIC_CONSTANT.SESSION.USERID, "", "", "00A^^^");
	var myAry = rtn.split("|");
	if (myAry[0] == 0) {
		var insuReadInfo = myAry[1];
		var insuReadAry = insuReadInfo.split("^");
		var insuCardNo = insuReadAry[1];	//医保卡号
		var credNo = insuReadAry[7];	    //身份证号
		$("#CardNo").val(credNo);
		if (credNo != "") {
			DHCACC_GetAccInfo("", credNo, "", "", magCardCallback);
		}
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	
	if (patientId != "") {
		setPatInfo(patientId);
	}
}

function initTPInvList() {
	GV.TPInvList = $HUI.datagrid("#TPInvList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillChargExcepiton",
		queryName: "QueryTPInv",
		frozenColumns: [[{title: '操作', field: 'TOperate', align: 'center', width: 80,
			           	  	formatter: function (value, row, index) {
								var btnHtml = "";
								switch(+row.TOperatCode) {
								case 1:
									btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='撤销' onclick='cancelClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
									break;
								case 2:
									btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='完成' onclick='completeClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png'/></a>";
									break;
								default:
									btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='撤销' onclick='cancelClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
									btnHtml += "<a href='javascript:;' class='datagrid-cell-img' title='完成' onclick='completeClick(" + JSON.stringify(row) + ")' style='margin-left: 10px;'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png'/></a>";
								}
							   	return btnHtml;
							}
		           		 }
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPrtDate", "TOperatCode"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TInsuDivDR", "TPAPMIDR", "TAccMDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TPrtRowId") {
					cm[i].formatter = function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick=\"openDtlView(\'" + value + "\')\">" + value + "</a>";
						}
					};
				}
				if (cm[i].field == "TPrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TPrtDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TPrtTime") {
						cm[i].width = 155;
					}
					if (cm[i].field == "TExceptionDesc") {
						cm[i].width = 180;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
	
	//链接过来病人主索引时，触发查询
	if (CV.PatientId) {
		loadTPInvList();
	}
}

function openDtlView(prtRowId) {
	var argObj = {
		invRowId: prtRowId,
		invType: "PRT"
	};
	BILL_INF.showOPChgOrdItm(argObj);
}

function loadTPInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillChargExcepiton",
		QueryName: "QueryTPInv",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		ChgUserId: getValueById("user"),
		PatientNO: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		CardNo: getValueById("CardNo"),
		SessionStr: getSessionStr()
	};
	loadDataGridStore("TPInvList", queryParams);
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: $(e.target).val()
		}, function (papmi) {
			if (papmi) {
				setPatInfo(papmi);
				return;
			}
			$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
			focusById($(e.target));
		});
	}
}

function setPatInfo(papmi) {
	if (!papmi) {
		return;
	}
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
		setValueById("patName", myAry[2]);
		
		loadTPInvList();
	});
}

/**
* 撤销
*/
function cancelClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(prtRowId > 0)) {
				$.messager.popover({msg: "待撤销记录为空，不能撤销", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRT", prtRowId);
			if (jsonObj.PRTFlag != "TP") {
				$.messager.popover({msg: "非预结算状态，不能撤销", type: "info"});
				return reject();
			}
			if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				var rtn = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "ValidRollback", prtRowId: prtRowId, sessionStr: getSessionStr()}, false);
				if (rtn == 0) {
					$.messager.popover({msg: "非原发票收费员，不能撤销", type: "info"});
					return reject();
				}
			}
			insuDivId = jsonObj.PRTInsDivDR;
			insTypeId = jsonObj.PRTInsTypeDR;
			admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");

			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", (row.TExceptionDesc + "，" + $g("是否确认撤销？")), function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!insuDivId && (admSource > 0)) {
				var insuInfo = checkINSUDivFlag(prtRowId);
				var insuAry = insuInfo.split("!");
				if (insuAry[0] == "Y") {
					var myInsuStr = insuAry[1];
					var myInsuAry = myInsuStr.split("^");
					var succ = myInsuAry[0];
					if (succ != 0) {
						//失败时，succ是更新支付方式失败描述
						$.messager.popover({msg: succ, type: "info"});
						return reject();
					}
					insuDivId = myInsuAry[1];
				}
			}
			if (!insuDivId) {
				return resolve();
			}
			//+2023-03-17 ZhYW 增加调用医保冲正交易，可以调用医保冲正交易时，不调用医保撤销交易
			//判断能否调用医保冲正交易
			var rtn = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckIsRevsByDivDr", DivDr: insuDivId}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 1) {
				//可冲正时调用冲正交易
				var reverId = myAry[1];    //冲正交易Id
				var insuType = myAry[2];   //医保类型
				var DBConStr = "";         //数据库连接串
				var expStr = insuType + "^" + reverId + "^" + insuDivId + "^" + DBConStr;
				var rtn = InsuReverse(0, PUBLIC_CONSTANT.SESSION.USERID, "", "", "2207", expStr);
				if (rtn != 0) {
					$.messager.popover({msg: "医保冲正失败，错误代码：" + rtn, type: "info"});
					return reject();
				}
				return resolve();
			}
			//撤销医保结算
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";
			var insuNo = "";
			var cardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var chargeSource = "01";
			var leftAmt = accMLeft;
			var moneyType = "";
			var expStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			expStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource + "^" + DYLB;
			expStr += "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insTypeId, expStr, myCPPFlag);
			if (rtn != 0) {
				$.messager.popover({msg: "医保退费失败，错误代码：" + rtn, type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* HIS回滚
	*/
	var _rollback = function() {
		return new Promise(function (resolve, reject) {
			var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "撤销成功", type: "success"});
				return resolve();
			}
			$.messager.alert("提示", "撤销失败：" + (myAry[1] || myAry[0]), "error");
			reject();
		});
	};
	
	var _success = function() {
		GV.TPInvList.reload();
		closeWin();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var prtRowId = row.TPrtRowId;
	var accMRowId = row.TAccMDR;
	var accMLeft = getAccMLeft(accMRowId);
	
	var insuDivId = "";
	var insTypeId = "";
	var admSource = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_rollback)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
* 确认完成
*/
function completeClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(prtRowId > 0)) {
				$.messager.popover({msg: "待完成结算记录为空，不能完成结算", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRT", prtRowId);
			if (jsonObj.PRTFlag != "TP") {
				$.messager.popover({msg: "非预结算状态，不能完成结算", type: "info"});
				return reject();
			}
			if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非原发票收费员，不能完成结算", type: "info"});
				return reject()
			}
			insTypeId = jsonObj.PRTInsTypeDR;
			oldPrtRowId = jsonObj.PRTOldINVDR;
			insuDivId = jsonObj.PRTInsDivDR;
			patientId = jsonObj.PRTPAPMIDR;
			patPayAmt = jsonObj.PRTPatientShare;
			fairType = jsonObj.PRTFairType;
			admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
			if (oldPrtRowId > 0) {
				strikeRowId = getStrikeIdByOldId(oldPrtRowId);      //获取负票RowId
			}
			admStr = getAdmByPrtRowId(prtRowId);
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", (row.TExceptionDesc + "，" + $g("是否完成结算？")), function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function() {
		return new Promise(function (resolve, reject) {
			if (insuDivId > 0) {
				return resolve();
			}
			if (!(admSource > 0)) {
				return resolve();
			}
			if ((patPayAmt == 0) && (CV.ZeroAmtUseYBFlag != 1)) {
				return resolve();
			}
			var insuInfo = checkINSUDivFlag(prtRowId);
			var insuAry = insuInfo.split("!");
			if (insuAry[0] == "Y") {
				var myInsuStr = insuAry[1];
				var myInsuAry = myInsuStr.split("^");
				var succ = myInsuAry[0];
				if (succ != 0) {
					//失败时，succ是更新支付方式失败描述
					$.messager.alert("提示", succ, "info");
					return reject();
				}
			}
			var myYBHand = "";
			var leftAmt = "";
			var myCPPFlag = "NotCPPFlag";
			var strikeFlag = "S";    //这里传入"S"，让医保结算失败时不删除发票记录
			var insuNo = "";
			var cardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";       //数据库连接串
			var moneyType = "";
			var selPaymId = "";
			var expStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			expStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			expStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, prtRowId, admSource, insTypeId, expStr, myCPPFlag);
			var myAry = myYBRtn.split("^");
			if (myAry[0] == "YBCancle") {
				return reject();
			}
			if (myAry[0] == "HisCancleFailed") {
				$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* 部分退费失败进的异常
	* 获取部分退费后，需要收费的支付方式信息
	*/
	var _getPayInfo = function () {
		return new Promise(function (resolve, reject) {
			if (!(oldPrtRowId > 0)) {
				return resolve();
			}
			payInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetNewInvPayMList", oldPrtRowId: oldPrtRowId, strikeRowId: strikeRowId, prtRowId: prtRowId, refundPayMode: ""}, false);
			return resolve();
		});
	};
	
	/**
	* 是否需要收银
	*/
	var _isNeedToPay = function () {
		return new Promise(function (resolve, reject) {
			if (!(oldPrtRowId > 0)) {
				isNeedToPay = true;      //收费失败进的异常，需要重新收银
				return resolve();
			}
			var isRestoreInv = isQFRestorePrtInvId(prtRowId);
			if (isRestoreInv) {
				isNeedToPay = true;      //欠费补回进的异常，需要重新收银
				return resolve();
			}
			//部分退费后，患者支付大于退款金额时需要收银
			isNeedToPay = ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsNeedPayAftRef", striRowId: strikeRowId, payInfo: payInfo}, false) == 1);
			return resolve();
		});
	};

	/**
	* 收银
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			if (!isNeedToPay) {
				return resolve();    //不需要收银
			}
			var invAmtInfo = getInvAmtInfo(prtRowId);
			var aryAmt = invAmtInfo.split("^");
			var totalAmt = aryAmt[0];
			var discAmt = aryAmt[1];
			var payorAmt = aryAmt[2];
			var patShareAmt = aryAmt[3];
			var insuAmt = aryAmt[4];
			var payAmt = Number(patShareAmt).sub(insuAmt).toFixed(2);   //自费支付额
			if (payAmt == 0) {
				return resolve();   //无需自费支付时，直接确认完成
			}
			var accMLeft = getAccMLeft(accMRowId);
			var argumentObj = {
				title: "收银台-门诊收费异常处理",
				cardNo: cardNo,
				cardTypeId: cardTypeId,
				accMRowId: accMRowId,
				accMLeft: accMLeft,
				patientId: patientId,
				episodeIdStr: admStr,
				insTypeId: insTypeId,
				typeFlag: "FEE",
				prtRowIdStr: prtRowId,
				totalAmt: totalAmt,
				discAmt: discAmt,
				payorAmt: payorAmt,
				patShareAmt: patShareAmt,
				insuAmt: insuAmt,
				payAmt: payAmt,
				bizType: "OP"
			};
			BILL_INF.showCheckout(argumentObj).then(function (payMList) {
				payInfo = payMList;
		        resolve();
		    }, function () {
			    $.messager.alert("提示", "收银失败，请重新确认完成。", "error", function() {
				    reject();
				});
		    });
		});
	};
	
	/**
	* 确认完成
	*/
	var _complete = function() {
		return new Promise(function (resolve, reject) {
			var actualMoney = "";
			var change = "";
			var roundErr = "";
			var newInsType = "";
			var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
			expStr += "^" + CV.RequiredInvFlag + "^" + fairType + "^" + actualMoney + "^" + change + "^" + roundErr;
			expStr += "^" + newInsType;
			var rtn = $.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "CompleteCharge",
				CallFlag: 3,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				InsTypeDR: insTypeId,
				PrtRowIDStr: prtRowId,
				SFlag: ((oldPrtRowId > 0) ? 1 : 0),
				OldPrtInvDR: oldPrtRowId,
				ExpStr: expStr,
				PayInfo: payInfo
			}, false);
			if (rtn != 0) {
				chargeErrorTip("completeError", rtn);
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* 调用第三方退费接口 DHCBillPayService.js
	*/
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			var tradeType = "OP";
			var prtInvId = (!isNeedToPay) ? prtRowId : "";  //+2022-11-29 ZhYW 如果收银了，则需要将原票全退
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			refSrvRtnObj = RefundPayService(tradeType, oldPrtRowId, strikeRowId, prtInvId, "", tradeType, expStr);
			resolve();
		});
	};
	
	/**
	* 确认完成成功
	*/
	var _success = function() {
		var msg = "结算成功";
		var iconCls = "success";
		if (oldPrtRowId > 0) {
			msg = "退费成功";
			if (!$.isEmptyObject(refSrvRtnObj) && (refSrvRtnObj.ResultCode != 0)) {
				msg = $g("HIS退费成功，第三方退款失败：") + refSrvRtnObj.ResultMsg + $g("，错误代码：") + refSrvRtnObj.ResultCode + $g("，请补交易");
				iconCls = "error";
			}
			var invStr = oldPrtRowId + ":" + "PRT";
			var refMsg = getRefInfoHTML(invStr);
			if (refMsg) {
				msg = "<p class=\"fail-Cls\">" + msg + "</p>";
				msg += refMsg;
			}
		}
		
		//打印
		if (getPropValById("DHC_INVPRT", prtRowId, "PRT_INVPrintFlag") == "P") {
			billPrintTask(prtRowId);
		}
		$.messager.alert("提示", msg, iconCls, function() {
			GV.TPInvList.reload();
			closeWin();
		});
	};
	
	/**
	* 确认完成失败，撤销第三方交易
	*/
	var _fail = function() {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
		$.each(payInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2), function(index, item) {
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
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var prtRowId = row.TPrtRowId;
	var accMRowId = row.TAccMDR;
	var admStr = "";

	var insTypeId = "";
	var oldPrtRowId = "";
	var insuDivId = "";
	var patientId = "";
	var patPayAmt = "";
	var fairType = "";
	var admSource = "";
	var strikeRowId = "";
	
	var isNeedToPay = false;     //是否需要收银标识(自费支付)
	
	var payInfo = "";    //自费支付方式信息
	
	var refSrvRtnObj = {};         //第三方退费返回对象
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuDiv)
		.then(_getPayInfo)
		.then(_isNeedToPay)
		.then(_buildPayMList)
		.then(_complete)
		.then(_refSrv)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			_fail();
			$this.removeProp("disabled");
		});
}

/**
* 获取结算发票信息
*/
function getInvAmtInfo(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: prtRowIdStr}, false);
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
				if (myPrtXMLName != "") {
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
			var expStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadCommOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", className, methodName, GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERID, paymDesc, expStr);
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
			var expStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, expStr);
		}
	});
}

function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".datebox-f").datebox("setValue", "");   //先清空日期，防止后台加载数据
	setValueById("user", PUBLIC_CONSTANT.SESSION.USERID);	
	setValueById("stDate", CV.StDate);
	setValueById("endDate", CV.EndDate);
	
	GV.TPInvList.options().pageNumber = 1;   //跳转到第一页
	GV.TPInvList.loadData({total: 0, rows: []});
}

/**
* 获取账户余额
*/
function getAccMLeft(accMRowId) {
	return (accMRowId > 0) ? $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false) : "";
}

/**
* 根据发票获取就诊
*/
function getAdmByPrtRowId(prtRowIdStr) {
	return prtRowIdStr ? $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: prtRowIdStr}, false) : "";
}

/**
* 关闭弹窗
*/
function closeWin() {
	if (CV.PatientId) {
		websys_showModal("options").callbackFunc();
		websys_showModal("close");
	}
}

/**
* 根据原票获取负票RowId
*/
function getStrikeIdByOldId(oldPrtRowId) {
	return $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "GetStrikInvRowId", prtRowId: oldPrtRowId}, false);
}

function getRefInfoHTML(invStr) {
	var html = "";
	var jsonStr = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "GetRefundInfo", invStr: invStr}, false);
	var jsonObj = JSON.parse(jsonStr);
	if ((jsonObj.code == 0) && (jsonObj.refPatSum != 0)) {
		html += "<p class=\"fail-Cls\">" + "退费金额为：" + jsonObj.refPatSum + "元</p>";
		if (jsonObj.refmodeStr) {
			var begSign = "";
			var endSign = "";
			var refmodeAry = jsonObj.refmodeStr.split(",");
			$.each(refmodeAry, function(index, item) {
				begSign = (index == 0) ? "（" : "";
				endSign = (index == (refmodeAry.length - 1)) ? "）" : "";
				item = item.replace(/收/, "<a class=\"succ-Cls\">收</a>") + "元";
				html += "<p class=\"fail-Cls\">" + begSign + item + endSign + "</p>";
			});
		}
	}
	return html;
}

/**
* 判断医保是否已结算，已结算时返回结算信息
*/
function checkINSUDivFlag(prtRowId) {
	return $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: prtRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "N"}, false);
}

/**
* 判断结算记录是否欠费补回
*/
function isQFRestorePrtInvId(prtRowId) {
	return $.m({ClassName: "web.DHCOPQFPat", MethodName: "IsQFRestorePrtInvId", prtRowId: prtRowId}, false) == 1;
}