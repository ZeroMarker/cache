/**
 * FileName: dhcbill.opbill.refund.inv.js
 * Author: ZhYW
 * Date: 2019-04-23
 * Description: ��ͨ���﷢Ʊ�˷�
 */

/**
* ��ͨ��Ʊ�˷�
*/
function invRefSaveInfo() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if ((invFlag == "API") && (row.prtRowId > 0)) {    //���д�ӡ��Ʊ�Զ�����ʱ��С���˷ѣ����˷ѳ����г������д�ӡ��Ʊ
				accPInvId = invRowId;
				invRowId = row.prtRowId;
				invFlag = "PRT";
			}
			if (!invRowId || (invFlag == "API")) {
				return reject();
			}
			var prtFlag = getPropValById("DHC_INVPRT", invRowId, "PRT_Flag");
			if (prtFlag != "N") {
				$.messager.popover({msg: "�÷�Ʊ���˷ѣ������˷�", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "JudgeINVTPFlag", PrtRowid: invRowId, ExpStr: ""}, false);
			if (rtn != 0) {
				$.messager.popover({msg: "��δ������쳣��Ʊ�����ȴ�������˷�", type: "info"});
				return reject();
			}
			//�����жϷ�Ʊ���˷����������շ�����ʱ���ܽ���
			var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsValidRefQty", prtRowId: invRowId}, false);
			if (rtn > 0) {
				$.messager.popover({msg: "�˷����������շ��������ʵ", type: "info"});
				return reject();
			}
			//+2022-11-22 ZhYW ҽ���շѿ����Ƿ����˷�
			if (insuDivId > 0) {
				var rtn = isAllowedRefInsuDiffMth(invRowId, invFlag);
				if (!rtn) {
					$.messager.popover({msg: "ҽ�����㷢Ʊ�ѿ��£��������˷�", type: "info"});
					return reject();
				}
			}
			admStr = getAdmByPrtRowId(invRowId);
			//+2022-03-29 ZhYW �ж��Ƿ�����ֱ���˷����
			if (GV.IsDirRefAudited == 1) {
				GV.ReBillFlag = 0;     //����ֱ���˷����ʱ��ȫ���˷�
			}
			isPassNo = isPassNoReChg();
			//+2022-11-01 ZhYW �жϵ�����֧���������շ��Ƿ�����ԭ·��
			if (!isPassNo) {
				var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsAllowedInitModeToRefund", prtRowId: invRowId, refModeId: refundMode}, false);
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
					return reject();
				}
			}
			if ((GV.ReBillFlag == 1) && (admSource > 0)) {
				//+2023-04-04 ZhYW ҽ��סԺ�����Ƿ��������ﲿ���˷�
				var rtn = isAllowedIPPatPartRef(patientId);
				if (!rtn) {
					$.messager.popover({msg: "�û�������סԺ������ҽ�������˷�", type: "info"});
					return reject();
				}
				//+2023-03-28 WangXQ ҽ���շѲ����˷�ʱҽ������Ƿ����
				if (!insuAdmType) {
					var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsInsuAdmTypeRequired", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
					if (rtn != 0)  {
						$.messager.popover({msg: "����ѡ��ҽ�����", type: "info"});
						return reject();
					}
				}
			}
			patPayAmt = Number(row.patShareAmt).sub(refundAmt).toFixed(2);  //���ս��
			return resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			var msg = "�Ƿ�ȷ���˷�? ";
			if (isPassNo) {
				msg = "û����Ҫ�˷ѵ�ҽ�����Ƿ�ȷ�Ϲ����ش�Ʊ? ";
			}else {
				var invStr = invRowId + ":" + invFlag;
				var invIsOPToIP = $.m({ClassName: "web.DHCOPBillEmergTrans2IP", MethodName: "CheckInvIsOPToIP", invStr: invStr}, false);
				if (invIsOPToIP == 1) {
					msg = "��ҽ����ת��סԺ���˷Ѻ�ת���ҽ�������ܳ��أ�" + msg;
				}
			}
			$.messager.confirm("ȷ��", msg, function (r) {
				return r ? resolve() : reject();
			});
		}).then(function() {
			return new Promise(function (resolve, reject) {
				var bool = hasNoCancelAuditOrd();
				if (!bool) {
					return resolve();
				}
				var msg = "�����˷���˵�ҽ��δ����ִ�л�δ�˻أ�������������֪���������������˷ѣ�";
				msg += (isPassNo ? "�Ƿ�ȷ�Ϲ����ش�Ʊ" : "�Ƿ�ȷ���˷�") + "? ";
				$.messager.confirm("ȷ��", msg, function (r) {
					return r ? resolve() : reject();
				});
			});
		}).then(function() {
			return new Promise(function (resolve, reject) {
				if (GV.ReBillFlag != 1) {
					return resolve();
				}
				if (newInsType == curInsType) {
					return resolve();
				}
				var msg = "�����շѵ��շ�������仯��" + (isPassNo ? "�Ƿ�ȷ�Ϲ����ش�Ʊ" : "�Ƿ�ȷ���˷�") + "? ";
				$.messager.confirm("ȷ��", msg, function (r) {
					return r ? resolve() : reject();
				});
			});
		});
	};
	
	/**
	* ҽ���˷�
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "���ò�����ҽ������������ϵͳ��������", type: "info"});
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
				$.messager.popover({msg: "ҽ���˷�ʧ�ܣ�������룺" + rtn, type: "info"});
				return reject();
			}
			var insuInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: invRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "S"}, false);
			var myAry = insuInfo.split("!");
			if (myAry[0] != "Y") {
				$.messager.popover({msg: "ҽ���˷�ʧ�ܣ����Ժ�����", type: "info"});
				return reject();
			}
			return resolve();
		});
	};
	
	/**
	* HIS�˷�
	*/
	var _refund = function () {
		return new Promise(function (resolve, reject) {
			var expStr = invPayment + "^" + GV.InvRequireFlag + "^^^" + accPInvId;
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "RefundReceipt",
				INVPRTRowid: invRowId,
				rUser: PUBLIC_CONSTANT.SESSION.USERID,
				sFlag: getValueById("refBtnFlag"),
				StopOrdStr: invOrderStr,
				NInvPay: patPayAmt,
				gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
				RebillFlag: GV.ReBillFlag,
				ULoadLocDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
				RPayModeDR: refundMode,
				NewInsType: newInsType,
				ExpStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					chargeErrorTip("refundError", rtn);
					return reject();
				}
				disablePageBtn();
				newPrtRowId = myAry[1] || "";     //��ƱRowId
				strikeRowId = myAry[2] || "";     //��ƱRowId
				refInvFlag = myAry[3] || "N";     //�Ƿ��ӡ����Ʊ��ʶ
				return resolve();
			});
		});
	};
	
	/**
	* ҽ������
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {   //�����˲�����ҽ��
				return resolve();
			}
			if (!(admSource > 0)) {   //��ҽ������
				return resolve();
			}
			//ShangXuehao 2020-11-26 ����Ը�����Ϊ0���ҷ���Ϊ0����ҽ������false
			var zeroAmtUseYB = ((patPayAmt > 0) || (CV.ZeroAmtUseYBFlag == 1));
			if (!zeroAmtUseYB) {
				return resolve();
			}
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";
			var insuNo = "";
			var cardType = "";
			var YLLB = insuAdmType;
			var DicCode = insuDicCode;
			var DicDesc = insuDicDesc;
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";         //���ݿ����Ӵ�
			var moneyType = "";
			var selPaymId = (invPayment == "N") ? refundMode : "";
			var leftAmt = "";
			if (refModeCode != "CPP") {
				myCPPFlag = "NotCPPFlag";
			}else {
				leftAmt = accMLeft;
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, newPrtRowId, admSource, insTypeId, myExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				var msg = "ҽ��" + ((myAry[0] == "YBCancle") ? "ȡ������" : "����ʧ��") + "��HIS�����Է�����շ�";
				$.messager.alert("��ʾ", msg, "warning", function() {
					return resolve();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* ��ȡ�����˷Ѻ���Ҫ�շѵ�֧����ʽ��Ϣ
	*/
	var _getPayInfo = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			payInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetNewInvPayMList", oldPrtRowId: invRowId, strikeRowId: strikeRowId, prtRowId: newPrtRowId, refundPayMode: refundMode}, false);
			return resolve();
		});
	};
	
	/**
	* �Ƿ���Ҫ����
	*/
	var _isNeedToPay = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			//�����˷Ѻ󣬻���֧�������˿���ʱ��Ҫ����
			isNeedToPay = ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsNeedPayAftRef", striRowId: strikeRowId, payInfo: payInfo}, false) == 1);
			return resolve();
		});
	};
	
	/**
	* ����֧����ʽ�б�
	* ����е�����֧��Ҳ�ڴ˷��������
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			if (!isNeedToPay) {
				return resolve();    //����Ҫ����
			}
			var invAmtInfo = getInvAmtInfo(newPrtRowId);
			var aryAmt = invAmtInfo.split("^");
		    var totalAmt = aryAmt[0];
		    var discAmt = aryAmt[1];
		    var payorAmt = aryAmt[2];
		    var patShareAmt = aryAmt[3];
		    var insuAmt = aryAmt[4];
		    var payAmt = Number(patShareAmt).sub(insuAmt).toFixed(2); //�Է�֧����
		    if (payAmt == 0) {
		        return resolve();     //�����Է�֧��ʱ��ֱ��ȷ�����
		    }
		    var argumentObj = {
		        title: "����̨-�����˷�����",
		        cardNo: cardNo,
		        cardTypeId: cardTypeId,
		        accMRowId: accMRowId,
		        accMLeft: accMLeft,
		        patientId: patientId,
		        episodeIdStr: admStr,
		        insTypeId: insTypeId,
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
			    $.messager.alert("��ʾ", "����ʧ�ܣ����ڡ������շ��쳣�������洦��", "error", function() {
				    reject();
				});
		    });
		});
	};
	
	/**
	* ȷ�����
	*/
	var _complete = function() {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();    //û���·�Ʊ��¼ʱ���ɹ�����
			}
			var fairType = "";
			var actualMoney = "";
			var change = "";
			var roundErr = "";
			var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
			expStr += "^" + GV.InvRequireFlag + "^" + fairType + "^" + actualMoney + "^" + change + "^" + roundErr;
			expStr += "^" + newInsType;
			var rtn = $.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "CompleteCharge",
				CallFlag: 3,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				InsTypeDR: curInsType,
				PrtRowIDStr: newPrtRowId,
				SFlag: 1,
				OldPrtInvDR: invRowId,
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
	* ���õ������˷ѽӿ� DHCBillPayService.js
	*/
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			var tradeType = "OP";
			var prtInvId = (!isNeedToPay) ? newPrtRowId : "";  //+2022-11-29 ZhYW ��������ˣ�����Ҫ��ԭƱȫ��
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			refSrvRtnObj = RefundPayService(tradeType, invRowId, strikeRowId, prtInvId, "", tradeType, expStr);
			resolve();
		});
	};
	
	/**
	* ȷ����ɳɹ�
	*/
	var _success = function() {
		if (refInvFlag == "Y") {
			billPrintTask(strikeRowId);
		}
		billPrintTask(newPrtRowId);
		
		//��ʾ��Ϣ
		var msg = isPassNo ? "�����ش�Ʊ�ɹ�" : "�˷ѳɹ�";
		var iconCls = "success";
		if (!$.isEmptyObject(refSrvRtnObj) && (refSrvRtnObj.ResultCode != 0)) {
			msg = $g("HIS�˷ѳɹ����������˿�ʧ�ܣ�") + refSrvRtnObj.ResultMsg + $g("��������룺") + refSrvRtnObj.ResultCode + $g("���벹����");
			iconCls = "error";
		}
		var invStr = invRowId + ":" + "PRT";
		var refMsg = getRefInfoHTML(invStr);
		if (refMsg) {
			msg = "<p class=\"fail-Cls\">" + msg + "</p>";
			msg += refMsg;
		}
		$.messager.alert("��ʾ", msg, iconCls, function() {
			if (GV.IsDirRefAudited == 1) {
				var diffAmt = _getReChgAmt();
				if (diffAmt > 0) {
					$.messager.alert("��ʾ", ("<p class=\"fail-Cls\">���߻��轻�� " + diffAmt + " Ԫ��������շ�</p>"), "info", function() {
						var url = "dhcbill.opbill.charge.main.csp?SelectPatRowId=" + patientId + "&SelectAdmRowId=" +  admStr;
						websys_showModal({
							url: url,
							title: '�����շ�',
							iconCls: 'icon-w-inv',
							width: $(window).width() - 20,
							height: $(window).height() - 50
						});
					});
				}
			}
		});
	};
	
	/**
	* ȷ�����ʧ�ܣ���������������
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
						$.messager.popover({msg: "������֧������ʧ�ܣ�����ϵ����ʦ����", type: "error"});
					}
				}
			}
		});
	};
	
	/**
	* ֱ���˷���˹��ķ�Ʊ��ȫ���˷�ʱ����ʾ���轻��Ľ��
	*/
	var _getReChgAmt = function() {
		var patShareAmt = getPropValById("DHC_INVPRT", invRowId, "PRT_PatientShare");
		var ordRefundAmt = getValueById("ordRefundAmt");
		var diffAmt = Number(patShareAmt).sub(ordRefundAmt).toFixed(2);
		return diffAmt;
	};
	
	if ($("#btn-refund").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refund").linkbutton("disable");
	
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var patientId = getValueById("patientId");
	var accMRowId = getValueById("accMRowId");
	var accMLeft = getAccMLeft();   //�˻����
	var refundMode = getValueById("refundMode");
	var refModeCode = getPropValById("CT_PayMode", refundMode, "CTPM_Code");
	var refundAmt = getValueById("refundAmt");
	var invPayment = getValueById("invPayment");
	
	var newInsType = getValueById("newInsType");
	var curInsType = getValueById("insTypeId");
	var insTypeId = newInsType || curInsType;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	var curAdmSource = getPropValById("PAC_AdmReason", curInsType, "REA_AdmSource");
	
	var insuDivId = getValueById("insuDivId");
	var insuAdmType = getValueById("insuAdmType");  //ҽ�����
	var insuDicCode = getValueById("insuDic");      //���ֱ���
	var insuDicDesc = $("#insuDic").combobox("getText");

	var invRowId = "";          //DHC_INVPRT.RowId
	var invFlag = "";
	var accPInvId = "";         //DHC_AccPayInv.RowId
	var admStr = "";            //����RowId(���֮����"^"�ָ�)
	
	var patPayAmt = 0;          //���ս��
	
	var invOrderStr = getInvOrderStr();   //���˷�ҽ��
	var isPassNo = false;   //�Ƿ�����ش�(true:��, false:��)
	
	var newPrtRowId = "";       //��ƱRowId
	var strikeRowId = "";       //��ƱRowId
	var refInvFlag = "";        //�Ƿ��ӡ����Ʊ��ʶ
	
	var isNeedToPay = false;     //�Ƿ���Ҫ������ʶ(�Է�֧��)

	var payInfo = "";
	
	var refSrvRtnObj = {};         //�������˷ѷ��ض���

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_refund)
		.then(_insuDiv)
		.then(_getPayInfo)
		.then(_isNeedToPay)
		.then(_buildPayMList)
		.then(_complete)
		.then(_refSrv)
		.then(function() {
			_success();
		}, function() {
			_fail();
			$("#btn-refund").linkbutton("enable");
		});
}

/**
* ���ݷ�Ʊ��ȡ����
*/
function getAdmByPrtRowId(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: prtRowIdStr}, false);
}

/**
* ��ȡ���㷢Ʊ��Ϣ
*/
function getInvAmtInfo(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: prtRowIdStr}, false);
}

/**
* ��ȡ�˷�ҽ��
*/
function getInvOrderStr() {
	var refOrdAry = [];
	GV.ReBillFlag = 0;
	if (GV.OEItmList.getChecked().length != GV.OEItmList.getRows().length) {
		GV.ReBillFlag = 1;
	}
	$.each(GV.OEItmList.getChecked(), function (index, row) {
		if (row.isAppRep != "Y") {
			if (+row.refQty != +row.billQty) {
				GV.ReBillFlag = 1;
			}
		}else {
			if (+row.refQty == 1) {
				GV.ReBillFlag = 1;
			}
		}
		refOrdAry.push(row.oeori);
	});
	return refOrdAry.join("^");
}

/**
* ����֧����ʽ����
*/
function updatePayment(oldPrtRowId, refPrtRowIdStr) {
	$("#refPaymWin").show().dialog({
		iconCls: 'icon-w-paid',
		title: '����֧���˷�',
		draggable: false,
		modal: true,
		closable: false
	});
	initWinMenu(oldPrtRowId, refPrtRowIdStr);
}

/**
* ԭ���ش�
*/
function invReprt() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	var invNo = row.invNo;
	if (!invNo) {
		$.messager.popover({msg: "û�д�ӡ��Ʊ�������ش�", type: "info"});
		return;
	}
	var prtFlag = getPropValById("DHC_INVPRT", invRowId, "PRT_Flag");
	if (prtFlag != "N") {
		$.messager.popover({msg: "�÷�Ʊ���˷ѣ������ش�", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", $g("�Ƿ�ȷ�Ͻ���Ʊ") +"��<font color='red'>" + invNo + "</font>��" + $g("���´�ӡ? "), function (r) {
		if (!r) {
			return;
		}
		billPrintTask(invRowId);
	});
}

/**
* ����ҽ��
*/
function invReInsuDivide() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if (!invRowId || (invFlag == "API")) {
				return reject();
			}
			if (getValueById("insuDivId")) {
				$.messager.popover({msg: "�ü�¼�Ѿ�ҽ�����㣬�����ٲ���", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRT", invRowId);
			if (jsonObj.PRTFlag != "N") {
				$.messager.popover({msg: "�ü�¼���˷ѣ����ܲ���ҽ��", type: "info"});
				return reject();
			}
			if (jsonObj.PRTDHCINVPRTRDR > 0) {
				$.messager.popover({msg: "�ü�¼�����ս��ˣ����ܲ���ҽ��", type: "info"});
				return reject();
			}
			if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "�������˵��շѼ�¼�����ܲ���ҽ��", type: "info"});
				return reject();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "���ò�����ҽ������������ϵͳ��������", type: "info"});
				return reject();
			}
			if (!(newAdmSource > 0)) {
				$.messager.popover({msg: "��ѡ��ҽ���ѱ���в���ҽ��", type: "info"});
				return reject();
			}
			resolve();
		});
	};
		
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϲ���ҽ��? ", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* ҽ������
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			//����ҽ���ӿ�
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";    //����ҽ���ӿ�ʱ��"S"
			var insuNo = "";
			var cardType = "";
			var YLLB = insuDicDesc;
			var DicCode = getValueById("insuDic");
			var DicDesc = $("#insuDic").combobox("getText");
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";       //���ݿ����Ӵ�
			var selPaymId = (invPayment == "N") ? refundMode : "";
			var moneyType = "";
			var leftAmt = "";
			if (refModeCode != "CPP") {
				myCPPFlag = "NotCPPFlag";
			}else {
				leftAmt = accMLeft;
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, invRowId, newAdmSource, newInsType, myExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				return reject();
			}
			resolve();
		});
	};
	
	var _updateInv = function () {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "UpdateInvInsuDiv",
				prtRowId: invRowId,
				insTypeId: newInsType,
				userId: PUBLIC_CONSTANT.SESSION.USERID
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					$.messager.alert("��ʾ", "���·�Ʊʧ�ܣ�����ϵ����Ա�޸ķ�Ʊ�ѱ�", "error");
					return resolve();
				}
				$.messager.alert("��ʾ", "����ҽ���ɹ������˿�: " + myAry[1] + "Ԫ", "success"); //�˴���ʾ�����Ƕ���֧����ʽ
				reject();
			});
		});
	};
	
	var _success = function () {
		//��ȡҽ������Id
		var insuDivId = getPropValById("DHC_INVPRT", invRowId, "PRT_InsDiv_DR");
		setValueById("insuDivId", insuDivId);
	};
	
	if ($("#btn-reInsuDivide").linkbutton("options").disabled) {
		return;
	}
	$("#btn-reInsuDivide").linkbutton("disable");
	
	var accMRowId = getValueById("accMRowId");
	var accMLeft = getAccMLeft();   //�˻����
	
	var refundMode = getValueById("refundMode");
	var refModeCode = getPropValById("CT_PayMode", refundMode, "CTPM_Code");
	var invPayment = getValueById("invPayment");
	
	var newInsType = getValueById("newInsType");
	var newAdmSource = getPropValById("PAC_AdmReason", newInsType, "REA_AdmSource");

	var invRowId = "";          //DHC_INVPRT.RowId
	var invFlag = "";

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuDiv)
		.then(_updateInv)
		.then(function() {
			_success();
		}, function () {
			$("#btn-reInsuDivide").linkbutton("enable");
		});
}

/**
* �������۽���
*/
function cancleStayCharge() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if ((invFlag == "API") && (row.prtRowId > 0)) {    //���д�ӡ��Ʊ����ʱ��С���������ڳ������۳����г������д�ӡ��Ʊ
				accPInvId = invRowId;
				invRowId = row.prtRowId;
				invFlag = "PRT";
			}
			if (!invRowId || (invFlag == "API")) {
				return reject();
			}
			var stayFlag = getPropValById("DHC_INVPRT", invRowId, "PRT_StayFlag");
			if (stayFlag != "Y") {
				$.messager.popover({msg: "�����۷�Ʊ�����ܳ���", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϳ������۽���? ", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* ҽ���˷�
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			var insuDivId = getValueById("insuDivId");
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "���ò�����ҽ������������ϵͳ��������", type: "info"});
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
				$.messager.popover({msg: "ҽ���˷�ʧ�ܣ�������룺" + rtn, type: "info"});
				return reject();
			}
			return resolve();
		});
	};
	
	/**
	* �������۽���
	*/
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			var expStr = accPInvId + "^";
			$.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "StayChargeCancel",
				prtRowId: invRowId,
				sessionStr: getSessionStr(),
				expStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					newPrtRowId = myAry[1] || "";    //��ƱRowId
					strikeRowId = myAry[2] || "";    //��ƱRowId
					return resolve();
				}
				$.messager.alert("��ʾ", "����ʧ�ܣ�" + (myAry[1] || myAry[0]), "error");
				reject();
			});
		});
	};
	
	/**
	* ���õ������˷ѽӿ� DHCBillPayService.js
	*/
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			var tradeType = "OP";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			refSrvRtnObj = RefundPayService(tradeType, invRowId, strikeRowId, newPrtRowId, "", tradeType, expStr);
			resolve();
		});
	};
	
	var _success = function() {
		var msg = "��������ɹ�";
		var iconCls = "success";
		if (!$.isEmptyObject(refSrvRtnObj) && (refSrvRtnObj.ResultCode != 0)) {
			msg = $g("HIS��������ɹ����������˿�ʧ�ܣ�") + refSrvRtnObj.ResultMsg + $g("��������룺") + refSrvRtnObj.ResultCode + $g("���벹����");
			iconCls = "error";
		}
		$.messager.alert("��ʾ", msg, iconCls);
		disablePageBtn();
	};
	
	if ($("#btn-cancleStayCharge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancleStayCharge").linkbutton("disable");
	
	var curInsType = getValueById("insTypeId");
	var curAdmSource = getPropValById("PAC_AdmReason", curInsType, "REA_AdmSource");

	var invRowId = "";
	var invFlag = "";
	var accPInvId = "";
	var newPrtRowId = "";    //��ƱRowId
	var strikeRowId = "";    //��ƱRowId
	var refSrvRtnObj = {};   //�������˷ѷ��ض���
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_cancel)
		.then(_refSrv)
		.then(function() {
			_success();
		}, function () {
			$("#btn-cancleStayCharge").linkbutton("enable");
		});
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
			return;
		}
		invPrint(prtInvIdStr);
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
			//����ʵ�ʷ�Ʊ���շ�������ģ������
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //�˴�ֻ�޸ĵ���ģ��, ����Ҫ�޸�PrtXMLName
			var paymDesc = $("#refundMode").combobox("getText");
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}
