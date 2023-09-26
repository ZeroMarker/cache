///	DHCBillPayScanCodeService.js

/**
 * [createScanCodePay ����ɨ�븶����]
 * @param {[String]} tradeType    [ҵ������]
 * @param {[String]} payMode 		[֧����ʽ]
 * @param {[String]} tradeAmt     [���]
 * @param {[String]} expStr       [��չ��(����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)^ԭ����ID^���˱�־(C��D��))]
 */
function createScanCodePay(tradeType, payMode, tradeAmt, scanCode, expStr) {
	var buildRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CreateScanCodePay", tradeType, payMode, tradeAmt, scanCode, expStr);
	return buildRtn;
}

/**
 * [commitScanCodePay �ύɨ��֧��]
 * @param {[String]} ETPRowID    [����ID]
 * @param {[String]} scanCode    [�ֻ�֧����]
 */
function commitScanCodePay(ETPRowID, scanCode) {
	var payRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CommitScanCodePay", ETPRowID, scanCode);
	return payRtn;
}

/**
 * [verifyScanCodePayStatus ��ѯ����״̬]
 * @param {[String]} ETPRowID    [����ID]
 * @param {[String]} scanCode    [�ֻ�֧����]
 */
function verifyScanCodePayStatus(ETPRowID, ScanCode) {
	var payRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "VerifyScanCodePayStatus", ETPRowID, ScanCode);
	return payRtn
}

/**
 * [cancelScanCodePay �����ر�]
 * @param {[String]} ETPRowID    [����ID]
 * @param {[String]} scanCode 	[�ֻ�֧����]
 */
function cancelScanCodePay(ETPRowID, ScanCode) {
	var payRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CancelScanCodePay", ETPRowID, ScanCode);
	return payRtn;
}

/**
 * [refundScanCodePay �˷ѽӿ�]
 * @param {[String]} TradeType    [ҵ������]
 * @param {[String]} ReceipRowID 	[ԭҵ��ID]
 * @param {[String]} RefundAmt    [�˿���]
 * @param {[String]} OriginalType [ԭҵ������]
 * @param {[String]} OriginalID   [ԭ����ID]
 * @param {[String]} ExpStr 	    [��չ��(����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)^ԭ����ID^���˱�־(C��D��))]
 */
function refundScanCodePay(TradeType, RefundAmt, OriginalID, ExpStr) {
	var rtnValue = {
		rtnCode: "-2001",
		rtnMsg: "�ӿ��˷�ʧ��"
	};
	var RefRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "RefundScanCodePay", TradeType, RefundAmt, OriginalID, ExpStr);
	var rtn = RefRtn.split('^')[0];
	switch (rtn) {
	case "00":
		rtnValue.rtnCode = "0";
		rtnValue.rtnMsg = "�ӿ��˷ѳɹ�";
		if (RefRtn.split('^')[1] != "0") {
			//��������ʧ�ܷ���1
			rtnValue.rtnCode = "1";
			rtnValue.rtnMsg = "�ӿ��˷ѳɹ�,���涩������ʧ��";
		}
		break;
	case "100":
		rtnValue.rtnCode = "-2002";
		rtnValue.rtnMsg = "�����쳣,�ӿ��˷�ʧ��"; //��������
		break;
	case "200":
		rtnValue.rtnCode = "-2003";
		rtnValue.rtnMsg = "�ӿڵ����쳣,�ӿ��˷�ʧ��"; //��������
		break;
	case "300":
		rtnValue.rtnCode = "-2004";
		rtnValue.rtnMsg = "֧����ʽδ����Adapter��,�ӿ��˷�ʧ��"; //��������
		break;
	default:
		rtnValue.rtnMsg = "-2005";
		rtnValue.rtnMsg = "�ӿ��˷�ʧ��:" + rtn;   //��������
	}
	return rtnValue;
}

/**
 * [correctScanCodePay �����ӿ�]
 * @param {[String]} ETPRowID   [����ID]
 * @param {[String]} ExpStr 	[��չ��(����^��ȫ��^Ժ��^����ԱID)]
 */
function correctScanCodePay(ETPRowID, ExpStr) {
	var rtnValue = {
		rtnCode: "-3001",
		rtnMsg: "��������ʧ��"
	};
	var RefRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CorrectScanCodePay", ETPRowID, ExpStr);
	var rtn = RefRtn.split('^')[0];
	switch (rtn) {
	case "00":
		rtnValue.rtnCode = "0";
		rtnValue.rtnMsg = "���������ɹ�";
		if (RefRtn.split('^')[1] != "0") {
			//��������ʧ�ܷ���1
			rtnValue.rtnCode = "1";
			rtnValue.rtnMsg = "���������ɹ�,���涩������ʧ��";
		}
		break;
	case "100":
		rtnValue.rtnCode = "-3002";
		rtnValue.rtnMsg = "�����쳣,��������ʧ��"; //��������
		break;
	case "200":
		rtnValue.rtnCode = "-3003";
		rtnValue.rtnMsg = "�ӿڵ����쳣,��������ʧ��"; //��������
		break;
	case "300":
		rtnValue.rtnCode = "-3004";
		rtnValue.rtnMsg = "֧����ʽδ����Adapter��,��������ʧ��"; //��������
		break;
	default:
		rtnValue.rtnMsg = "-3005";
		rtnValue.rtnMsg = "��������ʧ��:" + rtn; //��������
	}
	return rtnValue;
}

/**
 * [linkBussinssToNO ��������ҵ��]
 * @param {[String]} ETPRowID    [����ID]
 * @param {[String]} HisPrtStr   [ҵ��ID]
 */
/*
function scanOrderConHIS(ETPRowID, HisPrtStr) {
	var payRtn=tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic","ScanOrderConHIS",ETPRowID,HisPrtStr);
	return  payRtn;
}
*/
