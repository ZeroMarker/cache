/**
 * ��������֧������  DHCPEPayService.js
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */


/**
 * ��ע��������֧����ʽ������������ɨ�븶  ^DHCPESetting("DHCPE","ExtPayModeCode")="^MISPOS^SMF^"
 * 	 ��������ɨ�븶 ^DHCPESetting("DHCPE","DHCScanCode")="^SMF^"
 */


/**
 * [pePayRtn ���ض���]
 * ResultCode���������				
 * 				-100��ҽ������ʧ��
 * 				-200������ʧ�ܣ���Ʊδ�ع�����Ҫ��Ϣ�ƴ���
 * 				-300������������ʧ��
 * 				-400:�����쳣
 * 				-500:�˷�ʧ��
 * ResultMsg������
 * ETPRowID���Ʒ���Ľ��׶���ID
 * PEBarCodePayStr��������������Ϣ
 * ExpStr:���ص���չ��Ϣ  ��ҽ�������践��  ҽ��ID^�Էѽ��
 */
var pePayRtn = {
	ResultCode: "0",
	ResultMsg: "",
	ETPRowID: "",
	PEBarCodePayStr: "",
	ExpStr: ""
};


/**
 * [ҽ������]
 * @param    {[int]}    invprt    [��췢ƱId]
 * @param    {[float]}    amount    [���]
 * @param    {[int]}    userId    [�û�ID]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
function insurancePay(invprt, amount, userId, AdmSorce, AdmReason) {
	pePayRtn = {
		ResultCode: "0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};

	var StrikeFlag = "N";
	var GroupID = session['LOGON.GROUPID'];
	var HOSPID=session['LOGON.HOSPID'];
	var InsuNo = ""; //ҽ�����˱�š�ҽ�����š�ҽ���ŵļ��ܴ� ���ſ��ĵط��� 
	var CardType = ""; //����ҽ����
	var YLLB = getValueById("YLLB"); //ҽ�������ͨ��������ز������﹤�ˡ�����������
	var DicCode = ""; //���ִ���
	var DicDesc = "";
	var BillSource = "01"; //������Դ
	var Type = "";
	var MoneyType = "";
	var TJPayMode=$("#PayMode").combogrid("getValue");
	
	var ExpStr = StrikeFlag + "^" + GroupID + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + amount + "^" + BillSource + "^" + Type +"^^"+"^"+HOSPID+"^"+TJPayMode+ "!" + amount + "^" + MoneyType
	
	try {
		//var ret = InsuPEDivide("0", userId, invprt, AdmSorce, AdmReason, ExpStr, "N"); //ҽ���麯��  DHCInsuPort.js
		var ret = InsuPEDivide("0", userId, invprt, AdmSorce, AdmReason, ExpStr, "NotCPPFlag"); //ҽ���麯�� DHCInsuPort.js
		var InsuArr = ret.split("^");
		var ret = InsuArr[0];
		if ((ret == "-3") || (ret == "-4")) { //ʧ��
			//�ع����շѵķ�Ʊ


			var Return = tkMakeServerCall("web.DHCPE.DHCPEBillCharge", "CancelCashie", invprt, userId);
			if (Return == "") {
				pePayRtn.ResultCode = -100;
				pePayRtn.ResultMsg = "ҽ������ʧ��";
				return pePayRtn;
			} else {
				pePayRtn.ResultCode = -200;
				pePayRtn.ResultMsg = "�ع�ʧ�ܣ�����ϵ��Ϣ�ƣ�" + Return;
				return pePayRtn;
			}

		} else if (ret == "-1") {
			if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(amount);
			pePayRtn.ExpStr = "^" + amount;
			alert("ҽ������ʧ��,�����շ�Ϊȫ�Է�");
		} else {
			if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(InsuArr[2]);
			pePayRtn.ExpStr = InsuArr[1] + "^" + amount;
			alert("ҽ������ɹ�,�����Էѽ��Ϊ:" + InsuArr[2]);
		}
	} catch (e) {
		pePayRtn.ResultCode = -404;
		pePayRtn.ResultMsg = "����ҽ��ʧ��^" + e.message;
		return pePayRtn;
	}
	return pePayRtn;
}

/**
 * [������֧��]
 * @param    {[int]}    invprt    [��ƱId]
 * @param    {[int]}    userId    [�û�id]
 * @param    {[int]}    InsuID    [ҽ������id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
function extPay(invprt, userId, InsuID, AdmSorce, admReason) {
	pePayRtn = {
		ResultCode: "0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};
	var payInfo = tkMakeServerCall("web.DHCPE.CashierEx", "GetPayInfoByPayCode", invprt); //��֤�Ƿ���Ҫ������֧��
	if (payInfo == "") {
		return pePayRtn;
	}
	var char1 = String.fromCharCode(1)
	var baseInfo = payInfo.split(char1)[1];
	var patId = baseInfo.split("^")[0];
	var paadm = baseInfo.split("^")[1];
	var scanFlag = baseInfo.split("^")[2];
	if (scanFlag == "1") {
		return scancodePay(payInfo, invprt, userId, InsuID, AdmSorce, admReason);
	}
	var payInfo = payInfo.split(char1)[0];
	var payArr = payInfo.split("^");
	var payDR = payArr[0];
	var payCode = payArr[1];
	var payAmt = payArr[2];

	if (parseFloat(payAmt) <= 0) {
		return pePayRtn;
	}
	//����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)
	var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + patId + "^" + paadm + "^^C^" + invprt;
	var PayCenterRtn = PayService("PE", payDR, payAmt, expStr);
	if (PayCenterRtn.ResultCode != "0") {
		return cancelExtCashier(PayCenterRtn.ResultMsg, invprt, userId, InsuID, AdmSorce, admReason);
	} else {
		pePayRtn.ETPRowID = PayCenterRtn.ETPRowID;
		//��¼�¼ƷѶ���ID�������ʽ����ʧ�ܻ��������ʧ��ʱ�����Ը��ݷ�Ʊȡ������ID�ٵ��쳣�����������ֹ�����
		var relate = tkMakeServerCall("web.DHCPE.CashierEx", "SetRelationTrade", invprt, PayCenterRtn.ETPRowID);
	}
	return pePayRtn;
}

/**
 * [������ɨ�븶]
 * @param    {[String]}    payInfo   [֧����Ϣ]
 * @param    {[int]}    invprt    [��ƱId]
 * @param    {[int]}    userId    [�û�id]
 * @param    {[int]}    InsuID    [ҽ������id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2020-01-09
 */
function scancodePay(payInfo, invprt, userId, InsuID, AdmSorce, admReason) {
	pePayRtn = {
		ResultCode: "0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};
	var char1 = String.fromCharCode(1)
	var baseInfo = payInfo.split(char1)[1];
	var patId = baseInfo.split("^")[0];
	var paadm = baseInfo.split("^")[1];
	var scanFlag = baseInfo.split("^")[2];
	if (scanFlag != "1") {
		return pePayRtn;
	}
	var payInfo = payInfo.split(char1)[0];
	var payArr = payInfo.split("^");
	var payDR = payArr[0];
	var payCode = payArr[1];
	var payAmt = payArr[2];
	if (parseFloat(payAmt) <= 0) {
		return pePayRtn;
	}

	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	var expStr = userId + "^" + groupId + "^" + locId + "^" + session['LOGON.HOSPID'];
	var str = "dhcbarcodepay.csp";
	var payBarCode = window.showModalDialog(str, "", 'dialogWidth:300px;dialogHeight:150px;resizable:yes'); //HTML��ʽ��ģ̬�Ի���
	if ((payBarCode == "") || (payBarCode == "undefind")) {
		return cancelExtCashier("δɨ��", invprt, userId, InsuID, AdmSorce, admReason);
	}
	var PEBarCodePayStr = tkMakeServerCall("MHC.BarCodePay", "PEBarCodePay", paadm, payBarCode, invprt, payAmt, payCode, expStr);
	var rtnAry = PEBarCodePayStr.split("^");
	if (rtnAry[0] != 0) {
		return cancelExtCashier("������֧��ʧ��", invprt, userId, InsuID, AdmSorce, admReason);
	} else {
		pePayRtn.PEBarCodePayStr = PEBarCodePayStr;
	}
	return pePayRtn;
}



/**
 * [����Ԥ���� ֧��ʧ��ʱ����]
 * @param    {[String]}    msg       [��ʾ��Ϣ]
 * @param    {[int]}    userId    [�û�id]
 * @param    {[int]}    InsuID    [ҽ������id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2020-01-09
 */
function cancelExtCashier(msg, invprt, userId, InsuID, AdmSorce, AdmReason) {
	pePayRtn = {
		ResultCode: "-300",
		ResultMsg: "������֧��ʧ��:" + msg,
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};
	var Return = tkMakeServerCall("web.DHCPE.DHCPEBillCharge", "CancelCashie", invprt, userId);
	if (Return != "") {
		pePayRtn.ResultCode = -200;
		pePayRtn.ResultMsg = "������֧��ʧ��,��Ʊδ�ع�������ϵ��Ϣ�ƣ�" + Return;
	}
	//���ҽ���ɹ�������ҽ������
	if (InsuID != "") {
		var insuStr = ""
		try {
			var insuRet = InsuPEDivideStrike("0", userId, InsuID, AdmSorce, AdmReason, insuStr, "N");
			if (insuRet != "0") {
				pePayRtn.ResultMsg = "����ʧ��,ҽ��δ�˷�,�����Ϣ������ϵ";
			}
		} catch (e) {
			pePayRtn.ResultMsg = "����ʧ��,ҽ��δ�˷�,�����Ϣ������ϵ\n" + e.message;
		}
	}

	return pePayRtn;
}



/**
 * [�������˷�]
 * @param    {[int]}    dropInvprt [���˵ķ�ƱID]
 * @param    {[int]}    oriInvprt [ԭ��ƱID]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
function extRefund(dropInvprt,oriInvprt){
	pePayRtn = {
		ResultCode:"0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr:"",
		ExpStr:""
	};
	var refundInfo=tkMakeServerCall("web.DHCPE.CashierEx","GetPOSRefundPara","",dropInvprt,oriInvprt);
	if (refundInfo == "") {
		return pePayRtn;
	}
	var char1 = String.fromCharCode(1);
	var PEBarCodePayStr = refundInfo.split(char1)[1]; //������ɨ�븶֧����¼
	refundInfo = refundInfo.split(char1)[0];
	var refundDr = refundInfo.split("^")[1];
	var refundAmt = parseFloat(refundInfo.split("^")[2]);
	var oldETPRowID = refundInfo.split("^")[3];
	var oldINvID = refundInfo.split("^")[4]; //��Ʊ
	var dropInvID = refundInfo.split("^")[5]; //��Ʊ    			
	var newInvID = refundInfo.split("^")[6] //��Ʊ
	var oriInvID = refundInfo.split("^")[7] //ԭʼ��Ʊ
	var paadm = refundInfo.split("^")[8];
	var scanFlag = refundInfo.split("^")[9] //������ɨ�븶


	if (scanFlag == "1") {
		var updateRtn = tkMakeServerCall("MHC.BarCodePay", "updatePEBarCodePay", paadm, PEBarCodePayStr, "D", "");
		if (updateRtn.split("^")[0] != "0") {
			pePayRtn.ResultCode = -500;
			pePayRtn.ResultMsg = "����˷ѳɹ������û������˷ѽӿ�ʧ��,�벹���ף�\n" + updateRtn;
		} else {
			//��¼�������˷ѳɹ� 
			var record = tkMakeServerCall("web.DHCPE.CashierEx", "RecordPOSRefund", dropInvID);
		}
	} else {
		var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^^^^D^";
		var refRtn = RefundPayService("PE", oldINvID, dropInvID, newInvID, refundAmt, "PE", expStr);
		if (refRtn.rtnCode != "0") {
			pePayRtn.ResultCode = -500;
			pePayRtn.ResultMsg = "����˷ѳɹ������õ������˷ѽӿ�ʧ��,�벹���ף�\n" + refRtn.rtnMsg;
		} else {
			//��¼�������˷ѳɹ� 
			var record = tkMakeServerCall("web.DHCPE.CashierEx", "RecordPOSRefund", dropInvID);
		}
	}
	return pePayRtn;
}