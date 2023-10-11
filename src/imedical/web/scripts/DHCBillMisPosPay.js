/// DHCBillMisPosPay.js

/**
 * @fileOverview <MisPos��������>
 * @author <zfb>
 * @version <MisPos���ý���>
 * @updateDate <2018-04-22>
 * @desc <�������>
 * @param -1001 δ��ȡ��������Ϣ
 * @param -1002 ��������ʧ��
 * @param -1003 POS�ӿڵ���ʧ��
 * @param -1004 POS����ʧ��
 */

document.write("<object id='MISPOSPay' classid='CLSID:9555A07C-0810-49E0-AA5A-59DF5593A0C5' codebase='../addins/client/MISPOSPay.CAB#version=1,0,0,1' style='display:none;'></object>");

//pos�����ļ���Ϣ
var PUBLIC_POSCfG = {
	POSTYPE: "",   //[����pos������ ��:����LD/��ʶCS]
	TID: "",       //�ն˺�
	ISLOG: "",     //�Ƿ񱣴���־
	LOGPATH: ""    //��־����·��
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos�ɷ����>
 * @param {[String]}	tradeType		[ҵ������ OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]}	tradeAmt		[���׽��]
 * @param {[String]}	bankType		[����pos������ ��:����LD/��ʶCS]
 * @param {[String]}	payMode			[֧����ʽid]
 * @param {[String]}	expStr			[��չ ����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)]
 * @return{[String]} 	����^����^������ID	[����(0:�ɹ�;1���׳ɹ�,���������쳣������;����ʧ��)]
 */
function BankCardPay(tradeType, tradeAmt, payMode, expStr) {
	//1:��������
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	var myRtn = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreatePayOrder", tradeType, payMode, tradeAmt, posCfg, expStr);
	var ResultCode = myRtn.split("^")[0];
	var ETPRowID = myRtn.split("^")[1];
	var ResultDesc = myRtn.split("^")[2];
	if (ResultCode != 0) {
		return -1002 + "^" + ResultDesc + "^";
	}
	//2:��������������֯����
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
	//3:���ýӿ�
	var bankData = CallDLLFun(bankInput);
	if (bankData == -1003) {
		return bankData + "^" + "MisPos����ʧ��" + "^" + ETPRowID;
	}
	
	//4:�������ݵ����ױ�
	var RtnValue = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "SaveMisPosData", ETPRowID, bankData);
	var ReslutCode = RtnValue.split("^")[0];
	var SaveCode = RtnValue.split("^")[1];
	var ReslutDesc = RtnValue.split("^")[2];
	if (ReslutCode == 0) {
		if (SaveCode == 0) {
			return 0 + "^" + ReslutDesc + "^" + ETPRowID;
		}
		return 1 + "^" + ReslutDesc + "^" + ETPRowID;
	}
	
	return -1004 + "^" + ReslutDesc + "^" + ETPRowID;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <POS�˷�/�˻�>
 * @param {[String]}	OrgETPRowID		[ԭ����¼��Ӧ���ױ�id]
 * @param {[String]}	tradeAmt		[���׽��]
 * @param {[String]}	tradeType		[ҵ������ OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]}	bankTradeType	[���н������� C/D/T]
 * @param {[String]}	payMode			[֧����ʽid]
 * @param {[String]}	expStr			[��չ ����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)]
 * @return{[String]} 	����^����		[����(0:�ɹ�;1���׳ɹ�,���������쳣������;����ʧ��)]
 */
function BankCardRefund(OrgETPRowID, tradeAmt, tradeType, bankTradeType, payMode, expStr) {
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	var RefOrderValue = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreateRefOrder", OrgETPRowID, tradeType, payMode, tradeAmt, bankTradeType, posCfg, expStr);
	var RefOrderAry = RefOrderValue.split("^");
	var ResultCode = RefOrderAry[0];
	var ETPRowID = RefOrderAry[1];
	var ResultDesc = RefOrderAry[2];
	if (ResultCode != 0) {
		return -1002 + "^" + ResultDesc + "^";
	}
	//1:��������������֯����
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
	//2:���ýӿ�
	var bankData = CallDLLFun(bankInput);
	if (bankData == -1003) {
		return bankData + "^" + "MisPos����ʧ��" + "^";
	}
	//3:�������ݵ����ױ�
	var SaveDataValue = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "SaveMisPosData", ETPRowID, bankData);
	var SaveDataAry = SaveDataValue.split("^");
	var ReslutCode = SaveDataAry[0];
	var SaveCode = SaveDataAry[1];
	var ReslutDesc = SaveDataAry[2];
	if (ReslutCode == 0) {
		if (SaveCode == 0) {
			return 0 + "^" + ReslutDesc + "^" + ETPRowID;
		}
		return 1 + "^" + ReslutDesc + "^" + ETPRowID;
	}
	
	return -1004 + "^" + ReslutDesc + "^";
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos����ҵ���ܵ��÷���>
 * @param {[String]}	bankTradeType	[���н������� C/D/T]
 * @param {[String]}	bankType 		[����pos���ͣ���������LD]
 * @param {[String]}	expStr 			[��չ����:�ɲ���]
 * @return{[obj]} 		bankData		[����ֵ]
 */
function PosOtherService(bankTradeType, expStr) {
	//his���壺Q-00-ǩ��,C-01-����,D-02-���ѳ���,T-03-�����˻�,S-04-��ѯ,P-05-�ش�ӡ,H-06-����
	//bankTradeType:������Ľ���C/D/T�⣬����ҵ�񻹴���Q/S/P/H�ȣ�ͳһ����
	var bool = ReadIniTxt();
	if (!bool) {
		alert("δ��ȡ�������ļ�");
		return "";
	}
	var expStr = "";
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetOtherServicePara", bankTradeType, posCfg, expStr);
	var bankData = CallDLLFun(bankInput);
	if (bankData == -1003) {
		alert("MisPos����ʧ��");
	}
	return bankData;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <����POS DLL/OCX>
 * @param {[String]}	bankInput	[pos������δ�]
 * @return{[String]} 	bankData	[pos���׷��ش�]
 */
function CallDLLFun(bankInput) {
	var bankData = "-1003";
	var bool = false;
	try {
		var bankType = PUBLIC_POSCfG.POSTYPE;
		switch (bankType) {
		case "POSJH":
			do {
				Log("input:" + bankType + "!" + bankInput, "");
				var obj = document.getElementById("MISPOSPay");
				var bankDataStr = obj.TestTransPay(bankInput);
				Log("", "onput:" + bankType + "!" + bankData);
				var bankDataClassFlag = bankDataStr.split("|")[0];
				bankData = bankDataStr.split("|")[1];
				var posRtn = bankData.substr(0, 2);
				if (bankData.substr(0, 2) != "00") {
					//�˴��ж����з���ֵ��ǰ2λ�Ƿ�ɹ�(00),���ɹ�����ʾ�Ƿ��ٽ���һ�ν���
					//һ�����з���ֵ��ǰ2λ�ǳɹ�ʧ�ܱ�־�������Խӿ��ĵ�Ϊ׼
					if (!confirm(posRtn + ":POS������ʧ�ܣ��Ƿ��ٴη�����")) {
						bool = true;
					}
				} else {
					bool = true;
				}
			} while (!bool)
			break;
		case "POSCS":
			do {
				Log("input:" + bankType + "!" + bankInput, "");
				var obj = document.getElementById("MISPOSPay");
				bankData = obj.PayCardPay(bankInput);
				//���Դ�
				//bankData = "00|123456|4047390069421560|000000100000|120000782231|1211|20091102|134256|���׳ɹ�|03|000000000000001|00000001|";
				Log("", "onput:" + bankType + "!" + bankData);
				var posRtn = bankData.substr(0, 2);
				if (bankData.substr(0, 2) != "00") {
					//�˴��ж����з���ֵ��ǰ2λ�Ƿ�ɹ�(00),���ɹ�����ʾ�Ƿ��ٽ���һ�ν���
					//һ�����з���ֵ��ǰ2λ�ǳɹ�ʧ�ܱ�־�������Խӿ��ĵ�Ϊ׼
					if (!confirm(posRtn + ":POS������ʧ�ܣ��Ƿ��ٴη�����")) {
						bool = true;
					}
				} else {
					bool = true;
				}
			} while (!bool)
			break;
		case "POSLKL":
			do {
				Log("input:" + bankType + "!" + bankInput, "");
				var obj = document.getElementById("MISPOSPay");
				bankData = obj.cardtrans(bankInput);
				Log("", "onput:" + bankType + "!" + bankData);
				var payCode = bankData.substr(13, 2);
				if (payCode != "00") {
					//�˴��ж����з���ֵ��ǰ2λ�Ƿ�ɹ�(00),���ɹ�����ʾ�Ƿ��ٽ���һ�ν���
					//һ�����з���ֵ��ǰ2λ�ǳɹ�ʧ�ܱ�־�������Խӿ��ĵ�Ϊ׼
					if (!confirm(payCode + ":POS������ʧ�ܣ��Ƿ��ٴη�����")) {
						bool = true;
					}
				} else {
					bool = true;
				}
			} while (!bool)
			break;
		default:
			bankData = "DHCBillMisPosPay.js��CallDLLFun����δ�޸ģ�����";
			break;
		}
	} catch (e) {
		alert("����MISPOS�ӿڷ����쳣��" + e.message);
	}finally {
		return bankData;
	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <JS���ɿͻ�����־�ļ�,��¼POS���ӿڵ���Σ�������Ϣ>
 * @param {[String]}	input	[���]
 * @param {[String]}	output	[����]
 */
function Log(input, output) {
	//���������ж��Ƿ񱣴���־
	if (PUBLIC_POSCfG.ISLOG != "Y") {
		return;
	}
	//��ȡ�����ļ��е���־����·��
	//var LogPath = "C:/POSLogs";
	var LogPath = PUBLIC_POSCfG.LOGPATH;
	
	var date = new Date();
	var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var hour = date.getHours();
    var minute = date.getMinutes();
    var second = date.getSeconds();
	var now = year + '-' + ((month < 10) ? ('0' + month) : month) + '-' + ((day < 10) ? ('0' + day) : day) + ' ' + ((hour < 10) ? ('0' + hour) : hour) + ':' + ((minute < 10) ? ('0' + minute) : minute) + ':' + ((second < 10) ? ('0' + second) : second);
	var fileName = year + '-' + ((month < 10) ? ('0' + month) : month) + '-' + ((day < 10) ? ('0' + day) : day);

	try {
		var str = "(function() {" + '\n' + 
		"var fso = new ActiveXObject('Scripting.FileSystemObject');" + '\n' + 
		"if (!fso.FolderExists('" + LogPath + "')) {" + '\n' + 
			"fso.CreateFolder('" + LogPath + "');" + '\n' + 
		"}" + '\n' + 
		"f = fso.OpenTextFile('" + LogPath + "/" + fileName + ".txt', 8, true);" + '\n' + 
		"f.WriteLine('-------------------------------------------------------------------');" + '\n' + 
		"f.WriteLine('ʱ�䣺" + now + "������Ա��" + session['LOGON.USERNAME'] + "(" + session['LOGON.USERCODE'] + ")');" + '\n' + 
		"f.WriteLine('��Σ�" + input + "');" + '\n' + 
		"f.WriteLine('���Σ�" + output + "');" + '\n' + 
		"f.WriteLine('-------------------------------------------------------------------');" + '\n' + 
		"f.Close();" + '\n' + 
		"return;" + '\n' + 
		"}());";
		CmdShell.notReturn = 1;   //�����޽�����ã�����������
		CmdShell.EvalJs(str);     //ͨ���м�����д�ӡ����
	} catch (e) {
		alert("������־����ʧ�ܣ��������õ���־����·���Ƿ���ȷ");
	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <��ȡ���������ļ�,��ȡ��pos����(HIS���ж���);�ն˺�;�Ƿ񱣴���־;��־����·�������浽ȫ�ֱ���PUBLIC_POSCONFIG��
 * @param {[String]}	input	[���]
 * @return{[String]} 	bool	[true:��ȡ�ɹ�,false:��ȡʧ��]
 */
function ReadIniTxt() {
	var bool = false;
	try {
		var str = "(function() {" + '\n' + 
			"var cfgAry = [];" + '\n' + 
			"var fso = new ActiveXObject('Scripting.FileSystemObject');" + '\n' + 
			"var f = fso.OpenTextFile('C:/Windows/POSConfig.ini', 1);" + '\n' + 
			"while (!f.AtEndOfStream) {" + '\n' + 
				"var s = f.ReadLine();" + '\n' + 
				"cfgAry.push(s);" + '\n' + 
			"}" + '\n' + 
			"f.Close();" + '\n' + 
			"return cfgAry.join('\\n');" + '\n' + 
		"}());";
		CmdShell.notReturn = 0;          //�з���ֵ����
		var rtn = CmdShell.EvalJs(str);  //ͨ���м�����д�ӡ����
		if (rtn.status == 200) {
			bool = true;
            var cfgAry = rtn.rtn.split("\n");
            $.each(cfgAry, function(index, item) {
            	var myAry = item.split("=");
            	var name = myAry[0];
            	var value = myAry[1];
            	if (PUBLIC_POSCfG[name] !== undefined) {
	            	PUBLIC_POSCfG[name] = value;
	            }
	        });
        }
	} catch (e) {
		alert("��ȡ�������÷����쳣��" + e.message);
	}finally {
		return bool;
	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos�շ����>
 * @param {[String]}	tradeType	[�������� OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]} 	hisPrtStr	[ҵ���id ! ҵ���id]
 * @param {[String]}	payMode		[֧����ʽid]
 * @param {[String]}	expStr		[��չ ����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)]
 * @return{[obj]} 		rtnValue	[����ֵ obj.returnCode ���롢obj.returnMsg ������obj.ETPRowID ����ID ���^�ָ�]
 */
function posPay(tradeType, tradeAmt, payMode, expStr) {
	var rtnValue = {
		ResultCode: -1004,
		ResultMsg: "����ʧ��",
		ETPRowID: ""
	}
	//var prtRowIDAry = hisPrtStr.split("!");
	var bool = ReadIniTxt();    //���ñ��������ļ���ȡ����pos�����Ҽ��ն˺�
	if (!bool) {
		rtnValue = {
			ResultCode: -1001,
			ResultMsg: "δ��ȡ��MisPos������Ϣ",
			ETPRowID: ""
		};
		return rtnValue;
	}

	//֧���˻�
	var PayRtn = BankCardPay(tradeType, tradeAmt, payMode, expStr);
	var PayAry = PayRtn.split("^");
	var ResultCode = PayAry[0];
	var ResultMsg = PayAry[1];
	var ETPRowID = PayAry[2];
	rtnValue = {
		ResultCode: ResultCode,
		ResultMsg: ResultMsg,
		ETPRowID: ETPRowID
	};
	return rtnValue;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos�˷����>
 * @param {[String]}	receipRowID		[ԭ����¼id]
 * @param {[String]}	abortPrtRowID	[����¼id]
 * @param {[String]}	newPrtRowID		[�¼�¼id]
 * @param {[String]}	tradeType		[ҵ������ OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]}	bankTradeType	[���н������� C/D/T]	---
 * @param {[String]}	bankType		[����pos������ ��:����LD/��ʶCS]-----------
 * @param {[String]}	payMode			[֧����ʽid]
 * @param {[String]} 	OrgETPRowID		[ԭ����¼��Ӧ���ױ�id]
 * @param {[String]}	originalType	[ԭҵ������ OP/PRE/DEP/IP/INSU/CARD ��Ҫ���סԺѺ���Ժ����ʹ��]
 * @param {[String]}	expStr			[��չ ����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)]
 * @return{[String]} 	rtnValue		[����ֵ:����,����()1^���׳ɹ�	[����ֵ 0^�ɹ�/��������]
 */
function posPayRefund(receipRowID, abortPrtRowID, newPrtRowID, tradeType, payMode, OrgETPRowID, originalType, refundAmt, expStr) {
	var rtnValue = {};
	var bool = ReadIniTxt();     //���������ļ���ȡ���м��ն˺�
	if (!bool) {
		rtnValue = {
			ResultCode: -1001,
			ResultMsg: "δ��ȡ��MisPos������Ϣ"
		};
		return rtnValue;
	}
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	//�жϽ�������(D:�����˷ѣ�T:�����˻�)
	var bankTradeTypeRtn = GetBankTradeType(OrgETPRowID, posCfg);
	var bankTradeTypeAry = bankTradeTypeRtn.split("^");
	var bankTradeType = bankTradeTypeAry[0];
	var posUser = bankTradeTypeAry[1];
	if (bankTradeType == -2003) {
		//����ж���Ҫ�ŵ�����˷ѿ�ʼ�ɣ�����
		rtnValue = {
			ResultCode: bankTradeType,
			ResultMsg: "�˷��ն�pos���и�ԭ�տ��в�һ�£������˷ѣ���ȥ" + posUser + "���˷ѣ�"
		};
		return rtnValue;
	} 
	if (bankTradeType == -2001) {
		rtnValue = {
			ResultCode: bankTradeType,
			ResultMsg: "δȡ���˷ѵ�����������"
		};
		return rtnValue;
	}
	if (bankTradeType == -2002) {
		rtnValue = {
			ResultCode: bankTradeType,
			ResultMsg: "��ȡԭ�������ڳ���"
		};
		return rtnValue;
	};
	//newPrtRowID: �ǿ�Ϊȫ��
	//m_RefFlag: 0-��ʾ�������˷� 1-��ʾֻ����ȫ������
	//bankTradeType: D ����, T �˻�
	if ((m_RefFlag == 1) && (newPrtRowID != "") && (bankTradeType == "D")) {
		var refundAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetRefundAmt", originalType, abortPrtRowID, "", payMode);
		var myExpStr = expStr + "^" + abortPrtRowID;    //ע������ҵ��ID�ӵ���չ����5λ�����򶩵�������ҵ�����
		var RefundRtn = BankCardRefund(OrgETPRowID, refundAmt, tradeType, bankTradeType, payMode, myExpStr);
		var RefundAry = RefundRtn.split("^");
		var ResultCode = RefundAry[0];       //�˷��Ƿ�ɹ���־��0-�˷ѳɹ���1-�˷�ʧ�ܣ�
		var ResultMsg = RefundAry[1];
		switch (ResultCode) {
		case "0":
			//�˷ѳɹ�����
			var tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, newPrtRowID, payMode);
			var PayRtn = BankCardPay(tradeType, tradeAmt, payMode, expStr);
			var PayAry = PayRtn.split("^");
			var ResultCode = PayAry[0];
			var ResultMsg = PayAry[1];
			var ETPRowID = PayAry[2];
			//�˷����쳣,���������������
			rtnValue = {
				ResultCode: ResultCode,
				ResultMsg: ResultMsg
			};
			//�շѳɹ������շѶ���
			if ([0, 1].indexOf(+ResultCode) != -1) {
				var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
				if (RelaRtn.ResultCode != 0) {
					rtnValue = {
						ResultCode: 1,
						ResultMsg: ResultMsg + "��" + RelaRtn.ResultMsg
					};
				}
			}
			break;
		case "1":
			rtnValue.ResultCode = ResultCode;
			//�˷ѳɹ�����
			var tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, newPrtRowID, payMode);
			var myExpStr = expStr + "^" + newPrtRowID;
			var PayRtn = BankCardPay(tradeType, tradeAmt, payMode, myExpStr);
			var PayAry = PayRtn.split("^");
			var ResultCode = PayAry[0];
			var ResultMsg = PayAry[1];
			switch (ResultCode) {
			case "0":
				rtnValue.ResultMsg = "�˷���Ϣ����ʧ�ܣ����ճɹ�";
				//�����շѶ���
				if ([0, 1].indexOf(+ResultCode) != -1) {
					var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
					if (RelaRtn.ResultCode != 0) {
						rtnValue = {
							ResultCode: 1,
							ResultMsg: "�˷���Ϣ����ʧ�ܣ����ճɹ��������շѶ���ʧ��"
						};
					}
				}
				break;
			case "1":
				rtnValue.ResultMsg = "�˷���Ϣ����ʧ�ܣ����ձ���ʧ��";
				//�����շѶ���
				if ([0, 1].indexOf(+ResultCode) != -1) {
					var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
					if (RelaRtn.ResultCode != 0) {
						rtnValue = {
							ResultCode: 1,
							ResultMsg: "�˷���Ϣ����ʧ�ܣ����ձ���ʧ�ܣ������շѶ���ʧ��"
						};
					}
				}
				break;
			default:
				rtnValue.ResultMsg = "�˷���Ϣ����ʧ�ܣ���Ʊ����ʧ��";
			}
			break;
		default:
			rtnValue = {
				ResultCode: ResultCode,
				ResultMsg: ResultMsg
			};
		}
	} else {
		//�˻���ȫ��
		var myExpStr = expStr + "^" + abortPrtRowID + "!" + newPrtRowID;
		var RefundRtn = BankCardRefund(OrgETPRowID, refundAmt, tradeType, bankTradeType, payMode, myExpStr);
		//�˷��Ƿ�ɹ���־��0-�˷ѳɹ�;1-�˷ѳɹ����ݱ���ʧ��;�˷�ʧ�ܣ�
		var RefundAry = RefundRtn.split("^");
		var ResultCode = RefundAry[0];
		var ResultMsg = RefundAry[1];
		rtnValue = {
			ResultCode: ResultCode,
			ResultMsg: ResultMsg
		};
	}
	return rtnValue;
}

/**
 * @author <xiongwang>
 * @date <2022-03-02>
 * @desc <pos�������>
 * @param {[String]} 	ETPRowID		[ԭ����¼��Ӧ���ױ�id]
 * @param {[String]}	ExpStr			[��չ ����^��ȫ��^Ժ��^����ԱID]
 * @return{[String]} 	rtnValue		[����ֵ:����,����()1^���׳ɹ�	[����ֵ 0^�ɹ�/��������]
 */
function correctPosPay(ETPRowID, ExpStr) {
	var rtnValue = {
		ResultCode: -3001,
		ResultMsg: "��������ʧ��"
	};
    var bool = ReadIniTxt(); //���ñ��������ļ���ȡ����pos�����Ҽ��ն˺�
    if (!bool) {
	    rtnValue.ResultCode = -1001;
		rtnValue.ResultMsg = "δ��ȡ��MisPos������Ϣ";
        return rtnValue;
    }
    var posCfg = PUBLIC_POSCONFIG.POSTYPE + "^" + PUBLIC_POSCONFIG.TID;
    var myRtn = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreatCorrectOrder", ETPRowID, posCfg, ExpStr);
    var resultCode = myRtn.split("^")[0];
    var ETPRowID = myRtn.split("^")[1];
    var resultDesc = myRtn.split("^")[2];
    if (resultCode != 0) {
	    rtnValue.ResultCode = -1002;
		rtnValue.ResultMsg = resultDesc;
        return rtnValue;
    }
    //1:��������������֯����
    var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
    //2:���ýӿ�
    var bankData = CallDLLFun(bankInput);
    if (bankData == -1003) {
	    rtnValue.ResultCode = -1003;
		rtnValue.ResultMsg = "MisPos����ʧ��";
        return rtnValue;
    }
    //3:�������ݵ����ױ�
    var myRtn = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "SaveMisPosData", ETPRowID, bankData);
    var myAry = myRtn.split("^");
    var resultCode = myAry[0];
    var saveCode = myAry[1];
    var resultDesc = myAry[2];
    if (resultCode == 0) {
	    rtnValue.ResultCode = saveCode;
		rtnValue.ResultMsg = resultDesc;
        return rtnValue;
    }
    return rtnValue;
}
/**
 * @author <zhenghao>
 * @date <2020-8-30>
 * @desc <pos��֤���÷���>
 * @param {[String]}	ETPRowID	[����ID]
 * @return{[obj]} 		bankData		[����ֵ]
 */

function BankPayCheck(ETPRowID)
{
	var rtnValue = {
		ResultCode: -1004,
		ResultMsg: "����ʧ��",
		ETPRowID: ETPRowID
	}
	var posCfg = ReadIniTxt();    //���ñ��������ļ���ȡ����pos�����Ҽ��ն˺�
	if (!posCfg) {
		rtnValue = {
			ResultCode: -1001,
			ResultMsg: "δ��ȡ��MisPos������Ϣ",
			ETPRowID: ETPRowID
		};
		return rtnValue;
	}
	var ResultMsg="";
	var ResultCode="";
		
	var payMode = tkMakeServerCall("web.DHCBillCommon", "GetPropValById", "DHC_BillExtTradePay", ETPRowID, "ETP_PayMode");
	var bankInput=tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic","GetMisPosCheckInput",ETPRowID);	
	
	var bankData = CallDLLFun(bankInput);
	
	if (bankData == -1003) {
		return bankData + "^" + "MisPos����ʧ��" + "^";
	}else{
		//�������еķ���ֵ�ֶΣ�his���׳ɹ��󣬱��浽���ױ�
		var rtn=tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic","SaveMisPosCheckData",ETPRowID,bankData,"");
		ResultCode=rtn.split("^")[0];
		ResultMsg=rtn.split("^")[2];
		
	}
	rtnValue = {
		ResultCode: ResultCode,
		ResultMsg: ResultMsg,
		ETPRowID: ETPRowID
	};
	return rtnValue;
}
