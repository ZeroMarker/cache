/// DHCBillMisPosPay.js

/**
 * @fileOverview <MisPos交互调用>
 * @author <zfb>
 * @version <MisPos调用交互>
 * @updateDate <2018-04-22>
 * @desc <错误代码>
 * @param -1001 未读取到配置信息
 * @param -1002 创建订单失败
 * @param -1003 POS接口调用失败
 * @param -1004 POS交易失败
 */

document.write("<OBJECT ID='MISPOSPay' CLASSID='CLSID:9555A07C-0810-49E0-AA5A-59DF5593A0C5' CODEBASE='../addins/client/MISPOSPay.CAB#version=1,0,0,1'>");
document.write("</OBJECT>");

//pos配置文件信息
var PUBLIC_POSCONFIG = {
	POSTYPE: "", //[银行pos机类型 例:联迪LD/创识CS]
	TID: "", //终端号
	ISLOG: "", //是否保存日志
	LOGPATH: "" //日志保存路径
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos缴费入口>
 * @param {[String]}	tradeType		[业务类型 OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]}	tradeAmt		[交易金额]
 * @param {[String]}	bankType		[银行pos机类型 例:联迪LD/创识CS]
 * @param {[String]}	payMode			[支付方式id]
 * @param {[String]}	expStr			[扩展 科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)]
 * @return{[String]} 	代码^描述^订单表ID	[代码(0:成功;1交易成功,保存数据异常需提醒;其他失败)]
 */
function BankCardPay(tradeType, tradeAmt, payMode, expStr) {
	//1:创建订单
	//var bankTradeType = "C";
	var posConfig = PUBLIC_POSCONFIG.POSTYPE + "^" + PUBLIC_POSCONFIG.TID;
	var myRtn = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreatePayOrder", tradeType, payMode, tradeAmt, posConfig, expStr);
	var RtnCode = myRtn.split("^")[0];
	var ETPRowID = myRtn.split("^")[1];
	var RtnDesc = myRtn.split("^")[2];
	if (RtnCode != 0) {
		return "-1002^" + RtnDesc + "^";
	}
	//2:根据银行类型组织参数
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
	//3:调用接口
	var bankData = CallDLLFun(bankInput);
	if (bankData == "-1003") {
		return bankData + "^" + "MisPos调用失败" + "^" + ETPRowID;
	} else {
		//4:保存数据到交易表
		var myResult = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "SaveMisPosData", ETPRowID, bankData);
		var ReslutCode = myResult.split("^")[0];
		var SaveCode = myResult.split("^")[1];
		var ReslutDesc = myResult.split("^")[2];
		if (ReslutCode == 0) {
			if (SaveCode == 0) {
				return "0" + "^" + ReslutDesc + "^" + ETPRowID;
			} else {
				return "1" + "^" + ReslutDesc + "^" + ETPRowID;
			}
		} else {
			return "-1004" + "^" + ReslutDesc + "^" + ETPRowID;
		}

	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <POS退费/退货>
 * @param {[String]}	OrgETPRowID		[原正记录对应交易表id]
 * @param {[String]}	tradeAmt		[交易金额]
 * @param {[String]}	tradeType		[业务类型 OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]}	bankTradeType	[银行交易类型 C/D/T]
 * @param {[String]}	payMode			[支付方式id]
 * @param {[String]}	expStr			[扩展 科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)]
 * @return{[String]} 	代码^描述		[代码(0:成功;1交易成功,保存数据异常需提醒;其他失败)]
 */
function BankCardRefund(OrgETPRowID, tradeAmt, tradeType, bankTradeType, payMode, expStr) {
	var posConfig = PUBLIC_POSCONFIG.POSTYPE + "^" + PUBLIC_POSCONFIG.TID;
	var myRtn = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreateRefOrder", OrgETPRowID, tradeType, payMode, tradeAmt, bankTradeType, posConfig, expStr);
	var RtnCode = myRtn.split("^")[0];
	var ETPRowID = myRtn.split("^")[1];
	var RtnDesc = myRtn.split("^")[2];
	if (RtnCode != 0) {
		return "-1002^" + RtnDesc + "^";
	}
	//1:根据银行类型组织参数
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
	//2:调用接口
	var bankData = CallDLLFun(bankInput);
	if (bankData == "-1003") {
		return "-1003" + "^" + "MisPos调用失败^";
	} else {
		//3:保存数据到交易表
		var myResult = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "SaveMisPosData", ETPRowID, bankData);
		var ReslutCode = myResult.split("^")[0];
		var SaveCode = myResult.split("^")[1];
		var ReslutDesc = myResult.split("^")[2];
		if (ReslutCode == 0) {
			if (SaveCode == 0) {
				return "0" + "^" + ReslutDesc + "^" + ETPRowID;
			} else {
				return "1" + "^" + ReslutDesc + "^" + ETPRowID;
			}
		} else {
			return "-1004" + "^" + ReslutDesc + "^";
		}

	}
	return rtn + "^";
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos其他业务功能调用方法>
 * @param {[String]}	bankTradeType	[银行交易类型 C/D/T]
 * @param {[String]}	bankType 		[银行pos类型，例如联迪LD]
 * @param {[String]}	expStr 			[扩展参数:可不传]
 * @return{[obj]} 		bankData		[返回值]
 */
function PosOtherService(bankTradeType, expStr) {
	//his定义：Q-00-签到,C-01-消费,D-02-消费撤销,T-03-隔日退货,S-04-查询,P-05-重打印,H-06-结算
	//bankTradeType:除常规的交易C/D/T外，其他业务还存在Q/S/P/H等，统一定义
	var bool = ReadIniTxt();
	if (!bool) {
		alert("未获取到配置文件");
	}
	var expStr = "";
	var posConfig = PUBLIC_POSCONFIG.POSTYPE + "^" + PUBLIC_POSCONFIG.TID;
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetOtherServicePara", bankTradeType, posConfig, expStr);
	var bankData = CallDLLFun(bankInput);
	if (bankData == "-1003") {
		alert("MisPos调用失败");
	}
	return bankData;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <调用POS DLL/OCX>
 * @param {[String]}	bankInput	[pos交易入参串]
 * @return{[String]} 	bankData	[pos交易返回串]
 */
function CallDLLFun(bankInput) {
	var bankData = "-1003";
	try {
		var bankType = PUBLIC_POSCONFIG.POSTYPE;
		switch (bankType) {
		case "POSJH":
			var boolRtn = false;
			do {
				Log("input:" + bankType + "!" + bankInput, "");
				var obj = document.getElementById("MISPOSPay");
				var bankDataStr = obj.TestTransPay(bankInput);
				Log("", "onput:" + bankType + "!" + bankData);
				var bankDataClassFlag = bankDataStr.split("|")[0];
				var bankData = bankDataStr.split("|")[1];
				var posRtn = bankData.substr(0, 2);
				if (bankData.substr(0, 2) != "00") {
					//此处判断银行返回值的前2位是否成功(00),不成功，提示是否再进行一次交易
					//一般银行返回值的前2位是成功失败标志，具体以接口文档为准
					var truthBeTold = window.confirm(posRtn + ":POS机交易失败,是否再次发起交易");
					if (!truthBeTold) {
						boolRtn = true;
					}
				} else {
					boolRtn = true;
				}
			} while (!boolRtn)
			break;
		case "POSCS":
			var boolRtn = false;
			do {
				Log("input:" + bankType + "!" + bankInput, "");
				var obj = document.getElementById("MISPOSPay");
				var bankData = obj.PayCardPay(bankInput);
				//测试串
				//bankData = "00|123456|4047390069421560|000000100000|120000782231|1211|20091102|134256|交易成功|03|000000000000001|00000001|";
				Log("", "onput:" + bankType + "!" + bankData);
				var posRtn = bankData.substr(0, 2);
				if (bankData.substr(0, 2) != "00") {
					//此处判断银行返回值的前2位是否成功(00),不成功，提示是否再进行一次交易
					//一般银行返回值的前2位是成功失败标志，具体以接口文档为准
					var truthBeTold = window.confirm(posRtn + ":POS机交易失败,是否再次发起交易");
					if (!truthBeTold) {
						boolRtn = true;
					}
				} else {
					boolRtn = true;
				}
			} while (!boolRtn)
			break;
		case "POSLKL":
			var boolRtn = false;
			do {
				Log("input:" + bankType + "!" + bankInput, "");
				var obj = document.getElementById("MISPOSPay");
				var bankData = obj.cardtrans(bankInput);
				Log("", "onput:" + bankType + "!" + bankData);
				var payCode = bankData.substr(13, 2);
				if (payCode != "00") {
					//此处判断银行返回值的前2位是否成功(00),不成功，提示是否再进行一次交易
					//一般银行返回值的前2位是成功失败标志，具体以接口文档为准
					var truthBeTold = window.confirm(payCode + ":POS机交易失败,是否再次发起交易");
					if (!truthBeTold) {
						boolRtn = true;
					}
				} else {
					boolRtn = true;
				}
			} while (!boolRtn)
			break;
		default:
			bankData = "DHCBillMisPosPay.js中CallDLLFun方法未修改,请检查";
			break;
		}
		return bankData;
	} catch (e) {
		return bankData;
	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <JS生成客户端日志文件,记录POS机接口的入参，出参信息>
 * @param {[String]}	input	[入参]
 * @param {[String]}	output	[出参]
 */
function Log(input, output) {
	//根据配置判断是否保存日志
	if (PUBLIC_POSCONFIG.ISLOG == "Y") {
		var GuserCode = session['LOGON.USERCODE'];
		var GuserName = session['LOGON.USERNAME'];
		var date = new Date(); //日期对象
		var now = "";
		now = date.getFullYear() + "-";           //读英文就行了
		now = now + (date.getMonth() + 1) + "-";  //取月的时候取的是当前月-1如果想取当前月+1就可以了
		now = now + date.getDate() + " ";
		now = now + date.getHours() + ":";
		now = now + date.getMinutes() + ":";
		now = now + date.getSeconds() + "";
		var FileNameDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
		try {
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			//var LogFolder = "C:\\POSTradeDataLogFolder";
			//获取配置文件中的日志保存路径
			var LogFolder = PUBLIC_POSCONFIG.LOGPATH;
			if (!fso.FolderExists(LogFolder)) {
				fso.CreateFolder(LogFolder);
			}
			ts = fso.OpenTextFile(LogFolder + "\\" + FileNameDate + "POSLog.txt", 8, true);
			ts.WriteLine("-------------------------------------------------------------------");
			ts.WriteLine("日期:" + now + ",操作员:" + GuserName + "(" + GuserCode + ")");
			ts.WriteLine("入参:" + input);
			ts.WriteLine("出参:" + output);
			ts.WriteLine("-------------------------------------------------------------------");
			ts.Close();
		} catch (e) {
			alert("交易日志保存失败,请检查配置的日志保存路径是否正确")
		}
	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <读取本地配置文件,获取【pos厂家(HIS自行定义);终端号;是否保存日志;日志保存路径】保存到全局变量PUBLIC_POSCONFIG中
 * @param {[String]}	input	[入参]
 * @return{[String]} 	bool	[true:读取成功,false:读取失败]
 */
function ReadIniTxt() {
	try {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var f = fso.OpenTextFile("C:\\Windows\\POSConfig.ini", 1);
		while (!f.AtEndOfStream) {
			var s = f.ReadLine();
			var sname = s.split("=")[0];
			var svalue = s.split("=")[1];
			for (var name in PUBLIC_POSCONFIG) {
				if (name == sname) {
					PUBLIC_POSCONFIG[name] = svalue;
					break;
				}
			}
		}
		f.Close();
		return true;
	} catch (e) {
		return false;
	}
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos收费入口>
 * @param {[String]}	tradeType	[交易类型 OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]} 	hisPrtStr	[业务表id ! 业务表id]
 * @param {[String]}	payMode		[支付方式id]
 * @param {[String]}	expStr		[扩展 科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)]
 * @return{[obj]} 		rtnValue	[返回值 obj.returnCode 代码、obj.returnMsg 描述、obj.ETPRowID 订单ID 多个^分隔]
 */
function posPay(tradeType, tradeAmt, payMode, expStr) {
	rtnValue = {
		ResultCode: "-1004",
		ResultMsg: "交易失败",
		ETPRowID: ""
	}
	//var prtRowIDAry = hisPrtStr.split("!");
	var posConfig = ReadIniTxt();    //调用本地配置文件获取银行pos机厂家及终端号
	if (!posConfig) {
		rtnValue = {
			ResultCode: "-1001",
			ResultMsg: "未读取到MisPos配置信息",
			ETPRowID: ""
		};
		return rtnValue;
	}

	//支持退货
	var rtnPosPay = BankCardPay(tradeType, tradeAmt, payMode, expStr);
	var rtnResultCode = rtnPosPay.split("^")[0];
	var rtnResultMsg = rtnPosPay.split("^")[1];
	var ETPRowID = rtnPosPay.split("^")[2];
	rtnValue = {
		ResultCode: rtnResultCode,
		ResultMsg: rtnResultMsg,
		ETPRowID: ETPRowID
	};
	return rtnValue;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <pos退费入口>
 * @param {[String]}	receipRowID		[原正记录id]
 * @param {[String]}	abortPrtRowID	[负记录id]
 * @param {[String]}	newPrtRowID		[新纪录id]
 * @param {[String]}	tradeType		[业务类型 OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]}	bankTradeType	[银行交易类型 C/D/T]	---
 * @param {[String]}	bankType		[银行pos机类型 例:联迪LD/创识CS]-----------
 * @param {[String]}	payMode			[支付方式id]
 * @param {[String]} 	OrgETPRowID		[原正记录对应交易表id]
 * @param {[String]}	originalType	[原业务类型 OP/PRE/DEP/IP/INSU/CARD 主要针对住院押金出院结算使用]
 * @param {[String]}	expStr			[扩展 科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)]
 * @return{[String]} 	rtnValue		[返回值:代码,描述()1^交易成功	[返回值 0^成功/错误描述]
 */
function posPayRefund(receipRowID, abortPrtRowID, newPrtRowID, tradeType, payMode, OrgETPRowID, originalType, refundAmt, expStr) {
	var rtnValue = {};
	var posTypeRtn = ReadIniTxt();     //调用配置文件获取银行及终端号
	if (!posTypeRtn) {
		rtnValue = {
			rtnCode: "-1001",
			rtnMsg: "未读取到MisPos配置信息"
		};
		return rtnValue;
	}
	var bankType = PUBLIC_POSCONFIG.POSTYPE; //区分银行(工农中建等,按第三方厂商编码,比如建行联迪-LD,农行创识-CS)
	var posTerminal = PUBLIC_POSCONFIG.TID;
	var PosConfig = bankType + "^" + posTerminal;
	//判断交易类型(D:当日退费，T:隔日退货)
	var bankTradeTypeRtn = GetBankTradeType(OrgETPRowID, PosConfig);
	var bankTradeType = bankTradeTypeRtn.split("^")[0];
	var posUser = bankTradeTypeRtn.split("^")[1];
	if (bankTradeType == "-2003") {
		//这块判断需要放到外层退费开始吧？？？
		var ErrMsg = "退费终端pos银行跟原收款行不一致,不能退费,请去" + posUser + "处退费！";
		rtnValue = {
			rtnCode: bankTradeType,
			rtnMsg: ErrMsg
		};
		return rtnValue;
	} else if (bankTradeType == "-2001") {
		var ErrMsg = "未取到退费的正交易数据";
		rtnValue = {
			rtnCode: bankTradeType,
			rtnMsg: ErrMsg
		};
		return rtnValue;
	} else if (bankTradeType == "-2002") {
		var ErrMsg = "获取原交易日期出错";
		rtnValue = {
			rtnCode: bankTradeType,
			rtnMsg: ErrMsg
		};
		return rtnValue;
	}
	//newPrtRowID: 非空为全退
	//m_RefFlag: 0-表示允许差额退费 1-表示只能走全退再收
	//bankTradeType: D 撤销, T 退货
	if ((m_RefFlag == 1) && (newPrtRowID != "") && (bankTradeType == "D")) {
		var refundAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetRefundAmt", originalType, abortPrtRowID, "", payMode);
		var myExpStr = expStr + "^" + abortPrtRowID; //注意必须把业务ID加到扩展串第5位,否则订单不会与业务关联
		var rtnPosPay = BankCardRefund(OrgETPRowID, refundAmt, tradeType, bankTradeType, payMode, myExpStr);
		var rtnResultCode = rtnPosPay.split("^")[0]; //退费是否成功标志（0-退费成功，1-退费失败）
		var rtnResultMsg = rtnPosPay.split("^")[1];
		switch (rtnResultCode) {
		case "0":
			//退费成功再收
			var tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, newPrtRowID, payMode);
			var PosPay = BankCardPay(tradeType, tradeAmt, payMode, expStr);
			var ResultCode = PosPay.split("^")[0];
			var ResultMsg = PosPay.split("^")[1];
			var ETPRowID = PosPay.split("^")[2];
			//退费无异常,根据再收情况返回
			rtnValue = {
				rtnCode: ResultCode,
				rtnMsg: ResultMsg
			};
			//收费成功关联收费订单
			if ((ResultCode == "0") || (ResultCode == "1")) {
				var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
				if (RelaRtn.ResultCode != "0") {
					rtnValue = {
						rtnCode: "1",
						rtnMsg: ResultMsg + "," + RelaRtn.ResultMsg
					};
				}
			}
			break
		case "1":
			rtnValue.rtnCode = ResultCode;
			//退费成功再收
			var tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, newPrtRowID, payMode);
			var myExpStr = expStr + "^" + newPrtRowID;
			var PosPay = BankCardPay(tradeType, tradeAmt, payMode, myExpStr);
			var ResultCode = PosPay.split("^")[0];
			var ResultMsg = PosPay.split("^")[1];
			switch (ResultCode) {
			case "0":
				rtnValue.rtnMsg = "退费信息保存失败,再收成功";
				//关联收费订单
				if ((ResultCode == "0") || (ResultCode == "1")) {
					var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
					if (RelaRtn.ResultCode != "0") {
						rtnValue = {
							rtnCode: "1",
							rtnMsg: "退费信息保存失败,再收成功,关联收费订单失败"
						};
					}
				}
				break;
			case "1":
				rtnValue.rtnMsg = "退费信息保存失败,再收保存失败";
				//关联收费订单
				if ((ResultCode == "0") || (ResultCode == "1")) {
					var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
					if (RelaRtn.ResultCode != "0") {
						rtnValue = {
							rtnCode: "1",
							rtnMsg: "退费信息保存失败,再收成功,关联收费订单失败"
						};
					}
				}
				break;
			default:
				rtnValue.rtnMsg = "退费信息保存失败,新票再收失败";
				break;
			}
			break;
		default:
			rtnValue = {
				rtnCode: ResultCode,
				rtnMsg: ResultMsg
			};
			break;
		}
	} else {
		//退货或全退
		var myExpStr = expStr + "^" + abortPrtRowID + "!" + newPrtRowID;
		var rtnPosPay = BankCardRefund(OrgETPRowID, refundAmt, tradeType, bankTradeType, payMode, myExpStr);
		//退费是否成功标志（0-退费成功;1-退费成功数据保存失败;退费失败）
		var ResultCode = rtnPosPay.split("^")[0];
		var ResultMsg = rtnPosPay.split("^")[1];
		rtnValue = {
			rtnCode: ResultCode,
			rtnMsg: ResultMsg
		};
	}
	return rtnValue;
}
