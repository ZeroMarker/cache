/**
 * FileName: dhcbill.opbill.qfpayback.js
 * Author: ZhYW
 * Date: 2019-10-10
 * Description: 门诊欠费补回
 */﻿

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initInvList();
	initOrdItmList();
});

function initQueryMenu() {
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
		disabled: true,
		onClick: function () {
			restoreClick();
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
	
	$("#item-tip").show();
	
	//新费别
	$("#newInsType").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'insTypeId',
		textField: 'insType'
	});
	
	getReceiptNo();
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 119: //F8
		e.preventDefault();
		loadInvList();
		break;
	case 120: //F9
		e.preventDefault();
		restoreClick();
		break;
	default:
	}
}

function getReceiptNo() {
	var prtInvFlag = "";
	var fairType = "F";
	var insType = "";
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + prtInvFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + fairType + "^" + insType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var encmeth = getValueById("GetOPReceiptNoEncrypt");
	var rtn = cspRunServerMethod(encmeth, "setReceiptNo", "", expStr);
	if (rtn != 0) {
		disableById("btn-restore");
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
		$("#btn-tip").show().popover({cache: false, trigger: 'hover', content: content, placement: 'bottom'});	
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
		loadInvList();
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

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPQFPat",
		queryName: "PatQFDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["PrtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["PatientId", "QFRowID", "PrtRowId", "InsTypeDR", "AdmSource", "InsuDivDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "PrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.PrtDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "PrtTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function(data) {
			setValueById("patientId", "");
			setValueById("insTypeId", "");
			setValueById("insuDivId", "");
			$("#newInsType").combobox("clear").combobox("loadData", []);
			$(".numberbox-f").numberbox("setValue", 0);
			$("#paymList").html("");
			$(".datagrid-f:not(#invList)").datagrid("loadData", {total: 0, rows: []});
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
		PatientNo: getValueById("patientNo"),
		PatientId: "",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		SessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

function initOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		pageSize: 999999999,
		toolbar: [],
		className: "web.UDHCOEORDOP1",
		queryName: "ReadOEByINVRowID",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TOEORIStDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TOEORIStTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TOEORIStDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TOrder") {
						cm[i].width = 130;
					}
					if (cm[i].field == "TOrderQty") {
						cm[i].width = 60;
					}
					if (cm[i].field == "TPackUOM") {
						cm[i].width = 70;
					}
					if (cm[i].field == "TOEORIStTime") {
						cm[i].width = 155;
					}
					if (cm[i].field == "TOEORILabNo") {
						cm[i].width = 130;
					}
				}
			}
		}
	});
}

/**
 * 清屏
 */
function clearClick() {
	setValueById("patientId", "");
	setValueById("insTypeId", "");
	setValueById("insuDivId", "");
	focusById("CardNo");
	$(":text:not(#receiptNo,.pagination-num)").val("");
	$("#newInsType").combobox("clear").combobox("loadData", []);
	$(".datebox-f").datebox("setValue", "");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	$(".numberbox-f").numberbox("setValue", 0);
	$("#paymList").html("");
	$(".datagrid-f").datagrid("options").pageNumber = 1;
	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
	disableById("btn-restore");
}

function loadOrdItmList(prtRowId) {
	var queryParams = {
		ClassName: "web.UDHCOEORDOP1",
		QueryName: "ReadOEByINVRowID",
		invRowId: prtRowId,
		invType: "PRT",
		langId: PUBLIC_CONSTANT.SESSION.LANGID
	}
	loadDataGridStore("ordItmList", queryParams);
}

function selectRowHandler(row) {
	setValueById("patientId", row.PatientId);
	setValueById("restoreAmt", row.Acount);
	setValueById("insuDivId", row.InsuDivDR);
	var prtRowId = row.PrtRowId;
	loadOrdItmList(prtRowId);
	
	var invStr = prtRowId + ":" + "PRT";
	getPaymList(invStr);
	
	//加载费别
	var insTypeId = row.InsTypeDR;
	setValueById("insTypeId", insTypeId);
	loadNewInsType(insTypeId);
	
	var prtFlag = getPropValById("DHC_INVPRT", prtRowId, "PRT_Flag");
	if (prtFlag != "N") {
		var msg = $g("该记录已") + ((prtFlag == "A") ? $g("作废") : ((prtFlag == "S") ? $g("红冲") : ""));
		$.messager.popover({msg: msg, type: "info"});
		disableById("btn-restore");
		return;
	}
	
	enableById("btn-restore");
}

/**
* 获取支付方式信息
*/
function getPaymList(invStr) {
	$.m({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetInvPayModeList",
		invStr: invStr,
		langId: PUBLIC_CONSTANT.SESSION.LANGID
	}, function(rtn) {
		if (!rtn) {
			return;
		}
		var invPMAry = rtn.split("#");
		setValueById("invPayment", ((invPMAry[0] > 1) ? "Y" : "N"));
		var paymAry = invPMAry[1] ? invPMAry[1].split("^") : [];
		var myPMAry = [];
		var paymHtml = "<table>";
		$.each(paymAry, function (index, item) {
			myPMAry = item.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
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
	});
}

/**
* 加载新费别
*/
function loadNewInsType(insTypeId) {
    $.cm({
        ClassName: "web.DHCOPCashier",
        QueryName: "QryChgInsTypeList",
        ResultSetType: "array",
        insTypeId: insTypeId,
        hospId: PUBLIC_CONSTANT.SESSION.HOSPID
    }, function (data) {
	    if (insTypeId && !$.hisui.getArrayItem(data, "insTypeId", insTypeId)) {
            var jsonObj = getPersistClsObj("User.PACAdmReason", insTypeId);
            var insType = $.m({ClassName: "User.PACAdmReason", MethodName: "GetTranByDesc", Prop: "READesc", Desc: jsonObj.READesc, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
            var item = {insType: insType, insTypeId: insTypeId, admSource: jsonObj.REAAdmSource, selected: true};
            $.hisui.addArrayItem(data, "insTypeId", item);
        }
      	$("#newInsType").combobox("clear").combobox("loadData", data);
    });
}

/**
* 欠费补回
*/
function restoreClick() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row || !row.PrtRowId) {
				$.messager.popover({msg: "请选择要补交的结算记录", type: "info"});
				return reject();
			}
			prtRowId = row.PrtRowId;
			return resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			var msg = "";
			if ((newInsType != "") && (newInsType != curInsType)) {
				msg = "重新收费的收费类别发生变化，";
			}
			$.messager.confirm("确认", (msg + "是否确认补回？"), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
				return reject();
			}
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
			var leftAmt = "";
			var moneyType = "";
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource + "^" + DYLB;
			myExpStr += "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, myCPPFlag);
			if (rtn != 0) {
				$.messager.popover({msg: "医保发票冲票错误，不能退费，请联系管理员", type: "info"});
				return reject();
			}
			var insuInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: prtRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "S"}, false);
			var myAry = insuInfo.split("!");
			if (myAry[0] != "Y") {
				$.messager.popover({msg: "医保退费失败，请稍后重退", type: "info"});
				return reject();
			}
			return resolve();
		});
	};
	
	//补回
	var _restore = function () {
		return new Promise(function (resolve, reject) {
			var rtn = $.m({
				ClassName: "web.DHCOPQFPat",
				MethodName: "Restoring",
				PrtRowId: prtRowId,
				RestoreAmt: restoreAmt,
				NewInsType: newInsType,
				SessionStr: getSessionStr()
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				newPrtRowId = myAry[1];   //新票RowId
				strikeRowId = myAry[2];   //负票RowId
				return resolve();
			}
			chargeErrorTip("restoreError", rtn);
			reject();
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {   //配置了不连接医保
				return resolve();
			}
			if (!(admSource > 0)) {   //非医保结算
				return resolve();
			}
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
			var selPaymId = "";
			var leftAmt = "";
			var myCPPFlag = "NotCPPFlag";
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, newPrtRowId, admSource, newInsType, myExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				var msg = "医保" + ((myAry[0] == "YBCancle") ? "取消结算" : "结算失败") + "，HIS将按自费完成收费";
				$.messager.alert("提示", msg, "warning", function() {
					return resolve();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* 生成支付方式列表
	* 如果有第三方支付也在此方法中完成
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			var invAmtInfo = getInvAmtInfo(newPrtRowId);
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
		    var admStr = getAdmByPrtRowId(newPrtRowId);
		    var argumentObj = {
		        title: "收银台-门诊欠费补回",
		        cardNo: cardNo,
		        cardTypeId: cardTypeId,
		        accMRowId: accMRowId,
		        patientId: patientId,
		        episodeIdStr: admStr,
		        allowPayMent: "N",
		        insTypeId: newInsType,
		        typeFlag: "FEE",
		        prtRowIdStr: newPrtRowId,
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
		        reject();
		    });
		});
	};
	
	/**
	* 确认完成
	*/
	var _complete = function() {
		return new Promise(function (resolve, reject) {
			var fairType = "";
			var actualMoney = "";
			var change = "";
			var roundErr = "";
			var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
			expStr += "^" + "Y" + "^" + fairType + "^" + actualMoney + "^" + change + "^" + roundErr;
			expStr += "^" + newInsType;
			var rtn = $.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "CompleteCharge",
				CallFlag: 3,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				InsTypeDR: curInsType,
				PrtRowIDStr: newPrtRowId,
				SFlag: 1,
				OldPrtInvDR: prtRowId,
				ExpStr: expStr,
				PayInfo: payInfo
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				return resolve();
			}
			chargeErrorTip("completeError", rtn);
			return reject();
		});
	};
	
	/*
	* 如果欠费结算时用了第三方支付+欠费，需要将原来的第三方支付全部退掉
	* 调用第三方退费接口 DHCBillPayService.js
	*/
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			var tradeType = "OP";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			refSrvRtnObj = RefundPayService(tradeType, prtRowId, strikeRowId, newPrtRowId, "", tradeType, expStr);
			resolve();
		});
	};
	
	var _success = function() {
		var msg = "欠费补回成功";
		var iconCls = "success";
		if (!$.isEmptyObject(refSrvRtnObj) && (refSrvRtnObj.ResultCode != 0)) {
			msg = $g("HIS退费成功，第三方退款失败：") + refSrvRtnObj.ResultMsg + $g("，错误代码：") + refSrvRtnObj.ResultCode + $g("，请补交易");
			iconCls = "error";
		}
		$.messager.alert("提示", msg, iconCls);
		reloadPanel();
		billPrintTask(newPrtRowId);   //打印发票
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
					if (rtnValue.ResultCode != 0){
						$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
					}
				}
			}
		});
	};

	if ($("#btn-restore").linkbutton("options").disabled) {
		return;
	}
	$("#btn-restore").linkbutton("disable");
	
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	
	var patientId = getValueById("patientId");
	var restoreAmt = getValueById("restoreAmt");
	var insuDivId = getValueById("insuDivId");

	var newInsType = getValueById("newInsType");
	var curInsType = getValueById("insTypeId");
	var insTypeId = newInsType || curInsType;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	var curAdmSource = getPropValById("PAC_AdmReason", curInsType, "REA_AdmSource");
	
	var accMRowId = "";
	
	var prtRowId = "";           //待补回发票RowId
	var newPrtRowId = "";        //新票RowId
	var strikeRowId = "";        //负票RowId
	var payInfo = "";            //重新收费的支付方式信息
	var refSrvRtnObj = {};       //第三方退费返回对象
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_restore)
		.then(_insuDiv)
		.then(_buildPayMList)
		.then(_complete)
		.then(_refSrv)
		.then(function() {
			_success();
			$("#btn-restore").linkbutton("enable");
		}, function () {
			_fail();
			$("#btn-restore").linkbutton("enable");
		});
}

function reloadPanel() {
	disableById("btn-restore");
	getReceiptNo();
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
* 获取结算发票信息
*/
function getInvAmtInfo(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: prtRowIdStr}, false);
}

/**
* 根据发票获取就诊
*/
function getAdmByPrtRowId(prtRowIdStr) {
	return prtRowIdStr ? $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: prtRowIdStr}, false) : "";
}
