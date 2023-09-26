/**
 * FileName: dhcbill.opbill.refund.inv.js
 * Anchor: ZhYW
 * Date: 2019-04-23
 * Description: ��ͨ���﷢Ʊ�˷�
 */

/**
* ��ͨ��Ʊ�˷�
*/
function invRefSaveInfo() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	var accPInvId = "";    //���д�ӡ��ƱRowId
	if ((invFlag == "API") && prtRowId) {    //���д�ӡ��Ʊ�Զ�����ʱ��С���˷ѣ����˷ѳ����г������д�ӡ��Ʊ
		accPInvId = invRowId;
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
	if (jsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "�÷�Ʊ���˷ѣ������˷�", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "JudgeINVTPFlag", PrtRowid: invRowId, ExpStr: ""}, false);
	if (+rtn != 0) {
		$.messager.popover({msg: "��δ������쳣��Ʊ�����ȴ�������˷�", type: "info"});
		return;
	}
	//�����жϷ�Ʊ���˷����������շ�����ʱ���ܽ���
	var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "CheckOENegativeNum", PrtRowid: invRowId}, false);
	if (+rtn > 0) {
		$.messager.popover({msg: "�˷����������շ��������ʵ", type: "info"});
		return;
	}
	var newInsType = getValueById("newInsType");
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: newInsType}, false);
	var newAdmSource = jsonObj.REAAdmSource;
	var curInsType = getValueById("insTypeId");
	jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: curInsType}, false);
	var curAdmSource = jsonObj.REAAdmSource;
	
	var msg = "�Ƿ�ȷ���˷�? ";
	var invStr = invRowId + ":" + invFlag;
	var invIsOPToIP = $.m({ClassName: "web.DHCOPBillEmergTrans2IP", MethodName: "CheckInvIsOPToIP", invStr: invStr}, false);
	if (invIsOPToIP == "1") {
		msg = "��ҽ����ת��סԺ���˷Ѻ�ת���ҽ�������ܳ��أ��Ƿ�ȷ���˷�? ";
	}
	$.messager.confirm("ȷ��", msg, function (r) {
		if (r) {
			if ((newInsType != "") && (newInsType != curInsType)) {
				$.messager.confirm("ȷ��", "�����շѵ��շ�������仯���Ƿ�ȷ���˷�? ", function (r) {
					if (r) {
						_linkRefund();
					}
				});
			}else {
				_linkRefund();
			}
		}
	});
	
	function _linkRefund() {
		var invOrderStr = getInvOrderStr();
		if (!invOrderStr) {
			$.messager.confirm("ȷ��", "û����Ҫ�˷ѵ�ҽ�����Ƿ�ȷ�Ϲ����ش�Ʊ? ", function (r) {
				if (r) {
					_refund();
				}
			});
		}else {
			_refund();
		}
		
		function _refund() {
			var insuDivId = getValueById("insuDivId");
			if (insuDivId != "") {
				if (GV.INVYBConFlag == "0") {
					$.messager.popover({msg: "���ò�����ҽ������������ϵͳ��������", type: "info"});
					return;
				} else {
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
					var myYBRtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, myCPPFlag);
					if (myYBRtn != "0") {
						$.messager.popover({msg: "ҽ����Ʊ��Ʊ���󣬲����˷ѣ�����ϵ����Ա", type: "info"});
						return;
					}
				}
				var insuInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: invRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "S"}, false);
				var myAry = insuInfo.split("!");
				if (myAry[0] != "Y") {
					$.messager.popover({msg: "ҽ���˷�ʧ�ܣ����Ժ�����", type: "info"});
					return;
				}
			}
			
			var patPayAmt = numCompute(row.patShareAmt, getValueById("refundAmt"), "-");  //���ս��
			var refundMode = getValueById("refundMode");
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: refundMode}, false);
			var refmodeCode = jsonObj.CTPMCode;
			var invPayment = getValueById("invPayment");
			var myExpStr = invPayment + "^^^^" + accPInvId;
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
				myExpStr: myExpStr
			}, function(refRtn) {
				var refAry = refRtn.split("^");
				if (+refAry[0] == 0) {
					var newPrtRowId = "";    //��ƱRowId
					var strikeRowId = "";    //��ƱRowId
					var refInvFlag = "N";
					if (refAry.length > 1) {
						newPrtRowId = refAry[1];
						strikeRowId = refAry[2];
						refInvFlag = refAry[3];
					}
					if ((GV.INVYBConFlag == "1") && ((insuDivId != "") || (+newAdmSource > 0)) && (newPrtRowId != "")) {
						var myYBHand = "";
						var myCPPFlag = "";
						var strikeFlag = "S";
						var insuNo = "";
						var cardType = "";
						var YLLB = getValueById("insuAdmType");
						var DicCode = getValueById("insuDic");
						var DicDesc = $("#insuDic").combobox("getText");
						var DYLB = "";
						var chargeSource = "01";
						var DBConStr = "";       //���ݿ����Ӵ�
						var moneyType = "";
						var selPaymId = (invPayment == "N") ? refundMode : "";
						var accMRowId = getValueById("accMRowId");
						var leftAmt = "";
						if (accMRowId) {
							leftAmt = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
						}
						if (refmodeCode != "CPP") {
							leftAmt = "";
							myCPPFlag = "NotCPPFlag";
						}
						var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
						myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
						myExpStr += "^" + DBConStr + "^" + DYLB + "^" + getValueById("accMRowId") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
						var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, newPrtRowId, newAdmSource, newInsType, myExpStr, myCPPFlag);
						var myYBAry = myYBRtn.split("^");
						if (myYBAry[0] == "YBCancle") {
							return;
						}
						if (myYBAry[0] == "HisCancleFailed") {
							$.messager.alert("��ʾ", "ҽ��ȡ������ɹ�����HISϵͳȡ������ʧ��", "error");
							return;
						}
					}
					
					completeCharge(invRowId, refRtn);
					/*
					if ((invPayment == "Y") && (invOrderStr != "") && (newPrtRowId != "")) {
						updatePayment(invRowId, refRtn);
					}else {
						completeCharge(invRowId, refRtn);
					}
					*/
				}else {
					var myAry = refAry[0].split(PUBLIC_CONSTANT.SEPARATOR.CH3);
					var errCode = myAry[0];
					var job = (myAry.length > 1) ? myAry[1] : "";
					chargeErrorTip("refundError", errCode, job);
				}
			});
		}
	}
}

/**
* �����շ�ȷ�����
*/
function completeCharge(oldPrtRowId, refRtn) {
	
	var newPrtRowId = "";    //��ƱRowId
	var strikeRowId = "";    //��ƱRowId
	var refInvFlag = "N";
	
	var myAry = refRtn.split("^");
	if (myAry.length > 1) {
		newPrtRowId = myAry[1];
		strikeRowId = myAry[2];
		refInvFlag = myAry[3];
	}
	var newInsType = getValueById("newInsType");
	
	if (newPrtRowId != "") {
		
		//20200602 Lid ��ȡ�·�Ʊ֧����ʽ�б�
		var myPayInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetNewInvPayMList", oldPrtRowId: oldPrtRowId, strikeRowId: strikeRowId, prtRowId: newPrtRowId, refundPayMode: getValueById("refundMode")}, false);
		
		//����ȷ����ɷ���
		var accMRowId = getValueById("accMRowId");
		var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
		myExpStr += "^" + GV.InvRequireFlag + "^" + "" + "^" + "" + "^" + "" + "^" + "";
		myExpStr += "^" + newInsType;
		var rtn = $.m({
			ClassName: "web.DHCBillConsIF",
			MethodName: "CompleteCharge",
			CallFlag: 3,
			Guser: PUBLIC_CONSTANT.SESSION.USERID,
			InsTypeDR: getValueById("insTypeId"),
			PrtRowIDStr: newPrtRowId,
			SFlag: 1,
			OldPrtInvDR: oldPrtRowId,
			ExpStr: myExpStr,
			PayInfo: myPayInfo
		}, false);
		if (rtn != "0") {
			chargeErrorTip("completeError", rtn);
			disablePageBtn();
			return;
		}
	}
	var insuDivId = getValueById("insuDivId");
	if ((GV.INVYBConFlag == "1") && (insuDivId != "")) {
		$.m({
			ClassName: "web.udhcOPBillIF",
			MethodName: "ReadParkSum",
			PRTRowID: oldPrtRowId,
			ExpStr: ""
		}, function(rtn) {
			setValueById("factRefundAmt", rtn);
		});
	}
	//�����м��
	$.m({ClassName: "web.udhcOPPHARWIN", MethodName: "UpdateRETFLAG", PRTRowIDStr: newPrtRowId + "^" + strikeRowId});
	
	//�������˷ѽӿ� DHCBillPayService.js
	var tradeType = "OP";
	var refundAmt = "";
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^^";
	var rtnValue = RefundPayService(tradeType, oldPrtRowId, strikeRowId, newPrtRowId, refundAmt, "OP", expStr);
	var msg = "�˷ѳɹ�";
	var iconCls = "success";
	if (rtnValue.rtnCode != "0") {
		msg = "HIS�˷ѳɹ����������˷�ʧ�ܣ�" + rtnValue.rtnMsg + "��������룺" + rtnValue.rtnCode + "���벹����";
		iconCls = "error";
	}
	//
	$.messager.alert("��ʾ", msg, iconCls);
	if (refInvFlag == "Y") {
		billPrintTask(strikeRowId);
	}
	billPrintTask(newPrtRowId);
	disablePageBtn();
	return;
}

/**
* ��ȡ�˷�ҽ��
*/
function getInvOrderStr() {
	GV.RefOrdAry = [];
	GV.ReBillFlag = 0;
	var myAry = [];
	if (GV.OrdGridObj.getChecked().length != GV.OrdGridObj.getRows().length) {
		GV.ReBillFlag = 1;
	}
	$.each(GV.OrdGridObj.getChecked(), function (index, row) {
		if (row.isAppRepFlag != "Y") {
			if (+row.refQty != +row.billQty) {
				GV.ReBillFlag = 1;
			}
		}else {
			if (+row.refQty == 1) {
				GV.ReBillFlag = 1;
			}
		}
		GV.RefOrdAry.push(row.oeori);
	});
	return GV.RefOrdAry.join("^");
}

/**
* ����֧����ʽ����
*/
function updatePayment(oldPrtRowId, refRtn) {
	$("#refPaymWin").show().dialog({
		iconCls: 'icon-w-paid',
		title: '����֧���˷�',
		draggable: false,
		modal: true,
		closable: false
	});
	initWinMenu(oldPrtRowId, refRtn);
}

/**
* ԭ���ش�
*/
function invReprt() {
	var row = $("#invList").datagrid("getSelected");
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
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
	if (jsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "�÷�Ʊ���˷ѣ������ش�", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�Ͻ���Ʊ��<font color='red'>" + invNo + "</font>�����´�ӡ? ", function (r) {
		if (r) {
			billPrintTask(invRowId);
		}
	});
}

/**
* ����ҽ��
*/
function invReInsuDivide() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	if (getValueById("insuDivId")) {
		$.messager.popover({msg: "�÷�Ʊ�Ѿ�ҽ�����㣬�����ٲ���", type: "info"});
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
	if (jsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "�÷�Ʊ���˷ѣ����ܲ���ҽ��", type: "info"});
		return;
	}
	if ((jsonObj.PRTDHCINVPRTRDR) || (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID)) {
		$.messager.popover({msg: "�շ�Ա�ѽ�����Ǳ����վݣ����ܲ���ҽ��", type: "info"});
		return;
	}
	if (GV.INVYBConFlag == "0")  {
		$.messager.popover({msg: "���ò�����ҽ������������ϵͳ��������", type: "info"});
		return;
	}
	var newInsType = getValueById("newInsType");
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: newInsType}, false);
	var newAdmSource = jsonObj.REAAdmSource;
	if (!(+newAdmSource > 0)) {
		$.messager.popover({msg: "��ѡ��ҽ���ѱ���в���ҽ��", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϲ���ҽ��? ", function (r) {
		if (r) {
			var refundMode = getValueById("refundMode");
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: refundMode}, false);
			var refmodeCode = jsonObj.CTPMCode;
			var invPayment = getValueById("invPayment");
			//����ҽ���ӿ�
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";    //����ҽ���ӿ�ʱ��"S"
			var insuNo = "";
			var cardType = "";
			var YLLB = getValueById("insuAdmType");
			var DicCode = getValueById("insuDic");
			var DicDesc = $("#insuDic").combobox("getText");
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";       //���ݿ����Ӵ�
			var selPaymId = (invPayment == "N") ? refundMode : "";
			var moneyType = "";
			var accMRowId = getValueById("accMRowId");
			var leftAmt = ""; 
			if (accMRowId) {
				leftAmt = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
			}
			if (refmodeCode != "CPP") {
				leftAmt = "";
				myCPPFlag = "NotCPPFlag";
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, invRowId, newAdmSource, newInsType, myExpStr, myCPPFlag);
			var myYBAry = myYBRtn.split("^");
			if (myYBAry[0] == "0") {
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
						return;
					}else {
						$.messager.alert("��ʾ", "����ҽ���ɹ������˿�: " + myAry[1] + "Ԫ", "success"); //�˴���ʾ�����Ƕ���֧����ʽ
					}
					$.m({
						ClassName: "web.UDHCJFBaseCommon",
						MethodName: "GetPrtInsDivDR",
						PrtRowID: invRowId,
						PrtFlag: "PRT"
					}, function(myInsuDivId) {
						setValueById("insuDivId", myInsuDivId);
					});
				});
			}
		}
	});
}

/**
* �������۽���
*/
function cancleStayCharge() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	var accPInvId = "";                      //���д�ӡ��ƱRowId
	if ((invFlag == "API") && prtRowId) {    //���д�ӡ��Ʊ����ʱ��С���������ڳ������۳����г������д�ӡ��Ʊ
		accPInvId = invRowId;
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	var stayFlag = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtInvStat", PrtRowID: invRowId}, false);
	if (stayFlag != "Y") {
		$.messager.popover({msg: "�����۷�Ʊ�����ܳ���", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϳ������۽���? ", function (r) {
		if (r) {
			var insTypeId = getValueById("insTypeId");
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: insTypeId}, false);
			var curAdmSource = jsonObj.REAAdmSource;
 			var insuDivId = getValueById("insuDivId");
			if (insuDivId != "") {
				if (GV.INVYBConFlag == "0") {
					$.messager.popover({msg: "���ò�����ҽ������������ϵͳ��������", type: "info"});
					return;
				} else {
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
					var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, insTypeId, myExpStr, myCPPFlag);
					if (rtn != "0") {
						$.messager.popover({msg: "ҽ����Ʊ��Ʊ���󣬲��ܳ���������ϵ����Ա", type: "info"});
						return;
					}
				}
			}
			//�������۽���
			var expStr = accPInvId + "^";
			$.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "StayChargeCancel",
				prtRowId: invRowId,
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				groupDr: PUBLIC_CONSTANT.SESSION.GROUPID,
				ctLocDr: PUBLIC_CONSTANT.SESSION.CTLOCID,
				expStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					$.messager.alert("��ʾ", "�����ɹ�", "success");
					disablePageBtn();
				}else {
					$.messager.alert("��ʾ", "����ʧ�ܣ�" + rtn, "error");
				}
			});
		}
	});
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
			var paymDesc = $("#refundMode").combobox("getText");
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