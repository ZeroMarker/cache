/// DHCBillPayService.js

/**
 * @fileOverview <֧�����֧������>
 * @author <zhenghao>
 * @version <Pos��ɨ�롢��������ֱ��>
 * @updateDate <2018-03-20>
 */

/**
 * m_RefFlag����˵��:
 * 		����0: ��ʾ����˷�
 *			   �ŵ�(1.�����������Ʊֻ��ˢposһ��; 2.���ﲿ���˷�ֻ��Ҫ����1��pos[�˲��] 3.�����������ն˽����˷�)
 *	      	   ȱ��(�����˷Ѳ��ܼ�ʱ����)
 * 		����1: ��ʾȫ������
 *			   �ŵ�(�����˷ѿ���ʵʱ����)
 *		  	   ȱ��(1.�����������Ʊ��Ҫˢpos���; 2.���ﲿ���˷���Ҫ����2��pos[��ȫ���ٲ�����]; 3.���뵽ԭ�ɿ�pos�ն˽����˷�;)
 * 		���������ҽԺ��ʵ�����ߵ��ճ������ǵ����˻�(ǰ������֧�ֵ����˻�)
 */

var m_RefFlag = 0;

/**
 * [PayService ֧������]
 * @param  {[String]} tradeType       [ҵ������ OP/PRE/DEP/IP/INSU/CARD]
 * @param  {[String]} payMode   	  [֧����ʽID]
 * @param  {[String]} tradeAmt        [���]
 * @param  {[String]} expStr          [��չ��(����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��))]
 * @param  {[function]} callback      [�ص�����]
 * @return {[obj]}  rtnValue          [����ֵ obj.ResultCode�������(0�ɹ�;1���׳ɹ��򲿷ֽ��׳ɹ�,����ʾResultMsg;����:ʧ��);obj.ResultMsg�������;obj.ETPRowID����ID(���^�ָ�,�����շ���);obj.SuccessPrtStr�ɹ�ҵ��ID(���^�ָ�,�����շ���)]
 */
function PayService() {
	var tradeType = arguments[0];
	var payMode = arguments[1];
	var tradeAmt = arguments[2];
	var expStr = arguments[3];
	var callback = arguments[4];

	//����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)
	var expStrAry = expStr.split("^");
	var hisPrtStr = expStrAry[6] || ""; //ҵ��id

	var rtnValue = {
		ResultCode: 0,
		ResultMsg: "��֧����ʽ������ýӿ��շ�",
		PayMode: payMode,
		ETPRowID: ""
	};
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", payMode);
	var myAry = payModeInfo.split("^");
	var payCallFlag = myAry[0];     //�Ƿ���õ������ӿ�
	var payMethodClass = myAry[1];  //֧����ʽ��Ӧ��adapter��
	var payCallMode = myAry[2];     //�ӿ�����
	
	if (payCallFlag == 0) {
		callback(rtnValue);
		return;
	}
	if (!tradeAmt && hisPrtStr) {
		tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, hisPrtStr, payMode);
	}
	if (tradeAmt == 0) {
		rtnValue.ResultMsg = "֧�����Ϊ0�������õ�����֧��";
		callback(rtnValue);
		return;
	}
	switch(payCallMode) {
	case "DLL":
		//����POS����js����
		rtnValue = posPay(tradeType, tradeAmt, payMode, expStr);  //DHCBillMisPosPay.js
		rtnValue.PayMode = payMode;
		callback(rtnValue);
		break;
	case "WS":
		//������ҽֱ������js����
		break;
	case "SP":
		m_RefFlag = 0;   //ɨ�븶ֻ֧���˻�
		
		//����ɨ��۷����
		var argumentObj = {
			tradeType: tradeType,
			payMode: payMode,
			tradeAmt: tradeAmt,
			expStr: expStr
		};
		var url = "dhcbill.scancodepay.csp?arguments=" + encodeURIComponent(JSON.stringify(argumentObj));
		websys_showModal({
			url: url,
			title: 'ɨ��֧��',
			iconCls: 'icon-w-scan-code',
			height: 260,
			width: 440,
			closable: false,
			callbackFunc: function(rtnValue) {
				rtnValue.PayMode = payMode;
				callback(rtnValue);
			}
		});
		break;
	default:
	}
}

/**
 * [RefundPayService ֧������˿����]
 * @param {[String]} tradeType      [ҵ������]
 * @param {[String]} initPrtRowId   [ԭҵ��ID]
 * @param {[String]} abortPrtRowId  [��ҵ��ID]
 * @param {[String]} newPrtRowId    [�����˷�������Ʊ]
 * @param {[String]} refundAmt    	[�˿���  ��Ժ��Ѻ���������˻���� �ش�]
 * @param {[String]} originalType   [ԭҵ������  ����ҵ��ش�]
 * @param {[String]} expStr         [����^��ȫ��^Ժ��^����ԱID]
 * @param {[String]} rtnValue    	[obj.ResultCode:����(0:���׳ɹ�,���ݴ�������;1:���׳ɹ�,���������ݴ����쳣);obj.ResultMsg:����]
 */
function RefundPayService() {
	var tradeType = arguments[0];
	var initPrtRowId = arguments[1];
	var abortPrtRowId = arguments[2];
	var newPrtRowId = arguments[3];
	var refundAmt = arguments[4];
	var originalType = arguments[5];
	var expStr = arguments[6];
	
	var _getPendRefAry = function() {
		var pendRefJsonStr = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetPendingRefData", tradeType, initPrtRowId, abortPrtRowId, newPrtRowId, originalType);
		return JSON.parse(pendRefJsonStr);
	};
	
	var _callRefSrv = function() {
		var rtnJson = {
			ResultCode: -2001,
			ResultMsg: "�˿�ʧ��"
		};
		switch(payCallMode) {
		case "DLL":
			//����POS����js����
			rtnJson = posPayRefund(initPrtRowId, abortPrtRowId, newPrtRowId, tradeType, payMode, orgETPRowId, originalType, pendRefAmt, expStr);
			break;
		case "WS":
			//������ҽֱ������js����
			rtnJson.ResultMsg = "��ҽֱ���ӿ�δʵ��";
			break;
		case "SP":
			//ɨ���˷�
			//^ҵ���ָ�봮(��!�ָ�,��Ϊ��)^ԭ����ID^���˱�־(C��D��)
			expStr += "^" + hisPrtStr;
			rtnJson = refundScanCodePay(tradeType, orgETPRowId, pendRefAmt, expStr);
			break;
		default:
		}
		return rtnJson;
	};
	
	var hisPrtStr = abortPrtRowId + "!" + newPrtRowId;  //ҵ��id
	var rtnValue = {
		ResultCode: 0,
		ResultMsg: "�˿�ɹ�"
	};
	var pendRefAmt = 0;           //���˿���
	var orgETPRowId = "";         //ԭ֧������Id
	var payMode = "";             //�˷ѷ�ʽId
	var payCallMode = "";         //���ýӿڷ���ģʽ
	
	var refJson = {};
	var pendRefAry = _getPendRefAry();
	if (pendRefAry.length == 0) {
		rtnValue.ResultCode = 0;
		rtnValue.ResultMsg = "�޿��˿��";
		return rtnValue;
	}
	for(var i = 0, len = pendRefAry.length; i < len; i++) {
		refJson = pendRefAry[i];        //{"ETPID": 1, "PayMID":"1", "PendRefAmt":2.00, "PayCallMode":"SP"}
		orgETPRowId = refJson.ETPID;
		payMode = refJson.PayMID;
		payCallMode = refJson.PayCallMode;
		pendRefAmt = (refundAmt == 0) ? refJson.PendRefAmt : refundAmt;
		if (pendRefAmt == 0) {
			//�����ش���Ҫ���ýӿ�
			rtnValue.ResultMsg = "���Ϊ0��������ýӿ�";
			continue;
		}
		var rtnJson = _callRefSrv();
		rtnValue.ResultCode += rtnJson.ResultCode;
		if (rtnValue.ResultCode != 0) {
			rtnValue.ResultMsg += rtnJson.ResultMsg;
		}
	}
	return rtnValue;
}

/**
 * [RelationService ҵ���������]
 * @param {[String]} ETPRowID    [����ID]
 * @param {[String]} hisPrtStr   [ҵ���ID]
 * @param {[String]} tradeType   [ҵ������ OP/PRE/DEP/IP/INSU/CARD]
 * @return{[obj]} 	 rtnValue    [����ֵ obj.ResultCode�������(0�ɹ�;��0ʧ��);obj.ResultMsg�������]
 */
function RelationService(ETPRowID, hisPrtStr, tradeType) {
	var rtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "RelationOrderToHIS", ETPRowID, hisPrtStr, tradeType);
	var myAry = rtn.split("^");
	var code = myAry[0];
	var msg = myAry[1];
	var rtnValue = {
		ResultCode: code,
		ResultMsg: msg
	};
	return rtnValue;
}

/**
 * [CancelPayService ֧����������]
 * @param {[String]} ETPRowID		[����ID]
 * @param {[String]} ExpStr			[��չ��(����^��ȫ��^Ժ��^����ԱID)]
 */
function CancelPayService(ETPRowID, ExpStr) {
	var rtnValue = {
		ResultCode: 0,
		ResultMsg: "���������˷�"
	};
	var rtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCanRevokeFlag", ETPRowID);
	var myAry = rtn.split("^");
	if (myAry[0] != 0) {
		rtnValue.ResultCode = myAry[0];
		rtnValue.ResultMsg = myAry[1];
		return rtnValue;
	}
	
	var paymId = GetETPPayModeID(ETPRowID);
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", paymId);
	var myAry = payModeInfo.split("^");
	var payCallFlag = myAry[0];     //�Ƿ���õ������ӿ�
	var payCallMode = myAry[2];     //�ӿ�����
	if (payCallFlag == 0) {
		return rtnValue;
	}
	switch(payCallMode) {
	case "DLL":
		//����Pos����js����
		var rtnValue = correctPosPay(ETPRowID, ExpStr);
		break;
	case "WS":
		//����ֱ������js����
		rtnValue = "";
		break;
	case "SP":
		rtnValue = correctScanCodePay(ETPRowID, ExpStr);
		break;
	default:
	}
	return rtnValue;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <���ֽ����>
 * @param {[String]} PrtRowID [ҵ���ID]
 * @return{[String]} myrtn [0�ɹ�]
 */
function UpdateCARDToCASH(prtRowIdStr) {
	return tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "UpdateCARDToCASH", prtRowIdStr);
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <��ȡ���н�������>
 * @param {[String]} orgETPRowId [ԭ����¼ҵ����Ӧ���ױ�rowId]
 * @param {[String]} bankType [����pos���� ����:����LD/��ʶCS��]
 * @param {[String]} posTerminal [ҵ���ID]
 * @return{[String]} bankTradeType [���н�������C/D/T]
 */
function GetBankTradeType(orgETPRowId, PosConfig) {
	return tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CheckRefundTradeType", orgETPRowId, PosConfig);
}

/**
 * �����շѵ���
 * ���ýӿ��շѣ�������Ҫ��ɵķ�Ʊ��
 * *
 * �и�Bug,��Ŀ������ɨ�븶,������POS
 * ɨ����Ҫ֧���˻�,POSҪ��ȫ������(���ﲻ�ܵ�������m_RefFlag�ж�)
 * *
 */
function OPPayService(myPRTStr, PayMode, ExpStr) {
	var RtnPrtStr = "";
	
	//����POS����m_RefFlag����(0-��ʾ����˷�;1��ʾȫ������,�շ�ʱ�赥���շ�)
	var prtRowIDAry = myPRTStr.split("^");
	if (m_RefFlag == 1) {
		//����֧��
		var i;
		for (i = 0; i < prtRowIDAry.length; i++) {
			var PrtRowID = prtRowIDAry[i];
			var myExpStr = ExpStr + "^" + PrtRowID;
			var PayRtn = PayService("OP", PayMode, "", myExpStr);
			switch (PayRtn.ResultCode) {
			case "0":
				//ƴ���践�صķ�Ʊ��
				if (RtnPrtStr == "") {
					RtnPrtStr = PrtRowID;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + PrtRowID;
				}
				//֧���ɹ� ���ù�������(����ID��Ϊ��ʱ)
				if (PayRtn.ETPRowID != "") {
					var RelaRtn = RelationService(PayRtn.ETPRowID, PrtRowID, "OP");
					if (RelaRtn.ResultCode != 0) {
						$.messager.alert("��ʾ", "֧���ɹ�," + RelaRtn.ResultMsg + "������ϵ��Ϣ�ƴ���", "error");
					}
				}
				break;
			case "1":
				//ƴ���践�صķ�Ʊ��
				if (RtnPrtStr == "") {
					RtnPrtStr = PrtRowID;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + PrtRowID;
				}
				//֧���ɹ� ���ù�������
				var RelaRtn = RelationService(PayRtn.ETPRowID, PrtRowID, "OP");
				if (RelaRtn.ResultCode != 0) {
					$.messager.alert("��ʾ", "֧���ɹ�," + RelaRtn.ResultMsg + "������ϵ��Ϣ�ƴ���", "error");
				}
				$.messager.alert("��ʾ", PayRtn.ResultMsg + "������ϵ��Ϣ�ƴ���", "error"); //HIS���쳣Ҳ��������
				break;
			default:
				$.messager.alert("��ʾ", PayRtn.ResultMsg, "error");
			}
			
			//����֧���쳣,���ټ���֧��
			if ([0, 1].indexOf(+PayRtn.ResultCode) == -1) {
				var FailPrtStr = "";
				var j;
				for (j = i; j < prtRowIDAry.length; j++) {
					var FailPrtRowID = prtRowIDAry[j];
					if (FailPrtStr == "") {
						FailPrtStr = FailPrtRowID;
					} else {
						FailPrtStr = FailPrtStr + "^" + FailPrtRowID;
					}
				}

				var RtnFailPrtStr = DealtFailPrtData(FailPrtStr);   //����֧��ʧ������
				if (RtnPrtStr == "") {
					RtnPrtStr = RtnFailPrtStr;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + RtnFailPrtStr;
				}
				break;
			}
		}
	} else {
		var payPRTStr = prtRowIDAry.join("!");
		var myExpStr = ExpStr + "^" + payPRTStr;
		var PayRtn = PayService("OP", PayMode, "", myExpStr);
		switch (PayRtn.ResultCode) {
		case "0":
			//֧���ɹ� ���ù�������
			RtnPrtStr = myPRTStr;
			if (PayRtn.ETPRowID != "") {
				var RelaRtn = RelationService(PayRtn.ETPRowID, payPRTStr, "OP");
				if (RelaRtn.ResultCode != 0) {
					$.messager.alert("��ʾ", "֧���ɹ���" + RelaRtn.ResultMsg + "������ϵ��Ϣ�ƴ���", "error");
				}
			}
			break;
		case "1":
			RtnPrtStr = myPRTStr;
			var RelaRtn = RelationService(PayRtn.ETPRowID, payPRTStr, "OP");
			if (RelaRtn.ResultCode != 0) {
				$.messager.alert("��ʾ", "֧���ɹ���" + RelaRtn.ResultMsg + "������ϵ��Ϣ�ƴ���", "error");
			}
			$.messager.alert("��ʾ", PayRtn.ResultMsg + "������ϵ��Ϣ�ƴ���", "error");
			break;
		default:
			$.messager.alert("��ʾ", PayRtn.ResultMsg, "error");
			RtnPrtStr = DealtFailPrtData(myPRTStr);    //����֧��ʧ������
		}
	}
	return RtnPrtStr;
}

/**
 * @param {[String]} FailPrtStr     [���õ�����֧��ʧ�ܵķ�Ʊ��](��"^"�ָ�)
 * @return{[String]} myRtn			[������Ҫ������ɵķ�Ʊ��](��"^"�ָ�)
 */
function DealtFailPrtData(FailPrtStr) {
	var myRtn = "";
	//ҽ�����߽���ʧ����ô����(0:���³��ֽ���Ҫ�������;1:�ع�ҽ��;2:�շ�Ա�Լ����쳣������洦��)
	var HandleFlag = 0;
	
	//���ԷѺ�ҽ��2������ֱ���
	var insTypeId = getValueById("insTypeId");
	var admSource = tkMakeServerCall("web.DHCBillCommon", "GetPropValById", "PAC_AdmReason", insTypeId, "REA_AdmSource");
	if ((CV.INVYBConFlag == 1) && (admSource > 0)) {
		//ҽ�����ߴ���ʽ(���³��ֽ�? �����貹����)
		if (HandleFlag == 0) {
			//���³��ֽ�ɹ���Ҫ�������
			var myrtn = UpdateCARDToCASH(FailPrtStr);
			if (myrtn == 0) {
				myRtn = FailPrtStr;
				$.messager.alert("��ʾ", "ҽ������֧��ʧ�ܣ����ֽ���㣬��ע����ȡ�ֽ�", "info");
			} else {
				$.messager.alert("��ʾ", "ҽ������֧��ʧ�ܣ����ֽ����ʧ�ܣ��뵽�շ��쳣������洦��", "error");
			}
		} else if (HandleFlag == 1) {
			//����ҽ������
			var FailPrtAry = FailPrtStr.split("^");
			var i;
			for (i = FailPrtAry.length; i > 0; i--) {
				var FailPrtRowID = FailPrtAry[i];
				var ExpStr = "" + "^" + session['LOGON.GROUPID'] + "^";
				//�����
				//var rollRtn = HISRollBack(FailPrtRowID, InsDivDR, InsTypeDR, AdmSource, ExpStr);
			}
		} else {
			//������
			$.messager.alert("��ʾ", "ҽ������֧��ʧ�ܣ��뵽�շ��쳣������洦��", "error");
		}
	} else {
		//�Էѻ��߻ع�
		var ExpStr = "" + "^" + session['LOGON.GROUPID'] + "^";
		var myrtn = DHCWebOPYB_DeleteHISData(FailPrtStr, ExpStr);
		if (myrtn == 0) {
			$.messager.alert("�ԷѲ���֧��ʧ�ܣ��ع���Ʊ�ɹ���������");
		} else {
			$.messager.alert("�ԷѲ���֧��ʧ�ܣ��ع���Ʊʧ�ܣ��뵽�쳣����ع���Ʊ");
		}
	}
	return myRtn;
}

/**
 * [CheckPayService ֧����֤���񣨲�ȷ�������Ƿ�ɹ���֤��������]
 * @param {[String]} IBPRowid    [����ID]
 * @return{[obj]} 	 rtnValue    [����ֵ obj.ResultCode�������(0�ɹ�;��0ʧ��);obj.ResultMsg�������]
 */
function CheckPayService(ETPRowID) {
	var rtnValue = {
		ResultCode: -1,
		ResultMsg: "����֧��ʧ��"
	};
	var paymId = GetETPPayModeID(ETPRowID);
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", paymId);
	var payCallMode = payModeInfo.split("^")[2];
	var payCallFlag = payModeInfo.split("^")[0];
	if (payCallFlag == 0) {
		rtnValue.ResultCode = 0;
		rtnValue.ResultMsg = "��֧����ʽ������ýӿ�";
		return rtnValue;
	}
	if (payCallMode == "DLL") {
		//����Pos����js����
		rtnValue = BankPayCheck(ETPRowID);
	} else if (payCallMode == "WS") {
		//����ֱ������js����
	} else if (payCallMode == "SP") {
	}
	return rtnValue;
}

/**
 * @author <suhuide>
 * @date <2021-11-17>
 * @desc <���ݶ�����RowID��ȡ������֧����ʽID>
 * @param {[String]} ETPRowID: DHC_BillExtTradePay.RowId
 * @return{[String]} PayModeID: CT_PayMode.RowId
 */
function GetETPPayModeID(ETPRowID) {
	return tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetETPPayModeID", ETPRowID);
}