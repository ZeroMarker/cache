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

document.write("<object id='MISPOSPay' classid='CLSID:9555A07C-0810-49E0-AA5A-59DF5593A0C5' codebase='../addins/client/MISPOSPay.CAB#version=1,0,0,1' style='display:none;'></object>");

//pos配置文件信息
var PUBLIC_POSCfG = {
	POSTYPE: "",   //[银行pos机类型 例:联迪LD/创识CS]
	TID: "",       //终端号
	ISLOG: "",     //是否保存日志
	LOGPATH: ""    //日志保存路径
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
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	var myRtn = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreatePayOrder", tradeType, payMode, tradeAmt, posCfg, expStr);
	var ResultCode = myRtn.split("^")[0];
	var ETPRowID = myRtn.split("^")[1];
	var ResultDesc = myRtn.split("^")[2];
	if (ResultCode != 0) {
		return -1002 + "^" + ResultDesc + "^";
	}
	//2:根据银行类型组织参数
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
	//3:调用接口
	var bankData = CallDLLFun(bankInput);
	if (bankData == -1003) {
		return bankData + "^" + "MisPos调用失败" + "^" + ETPRowID;
	}
	
	//4:保存数据到交易表
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
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	var RefOrderValue = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CreateRefOrder", OrgETPRowID, tradeType, payMode, tradeAmt, bankTradeType, posCfg, expStr);
	var RefOrderAry = RefOrderValue.split("^");
	var ResultCode = RefOrderAry[0];
	var ETPRowID = RefOrderAry[1];
	var ResultDesc = RefOrderAry[2];
	if (ResultCode != 0) {
		return -1002 + "^" + ResultDesc + "^";
	}
	//1:根据银行类型组织参数
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
	//2:调用接口
	var bankData = CallDLLFun(bankInput);
	if (bankData == -1003) {
		return bankData + "^" + "MisPos调用失败" + "^";
	}
	//3:保存数据到交易表
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
		return "";
	}
	var expStr = "";
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetOtherServicePara", bankTradeType, posCfg, expStr);
	var bankData = CallDLLFun(bankInput);
	if (bankData == -1003) {
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
					//此处判断银行返回值的前2位是否成功(00),不成功，提示是否再进行一次交易
					//一般银行返回值的前2位是成功失败标志，具体以接口文档为准
					if (!confirm(posRtn + ":POS机交易失败，是否再次发起交易")) {
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
				//测试串
				//bankData = "00|123456|4047390069421560|000000100000|120000782231|1211|20091102|134256|交易成功|03|000000000000001|00000001|";
				Log("", "onput:" + bankType + "!" + bankData);
				var posRtn = bankData.substr(0, 2);
				if (bankData.substr(0, 2) != "00") {
					//此处判断银行返回值的前2位是否成功(00),不成功，提示是否再进行一次交易
					//一般银行返回值的前2位是成功失败标志，具体以接口文档为准
					if (!confirm(posRtn + ":POS机交易失败，是否再次发起交易")) {
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
					//此处判断银行返回值的前2位是否成功(00),不成功，提示是否再进行一次交易
					//一般银行返回值的前2位是成功失败标志，具体以接口文档为准
					if (!confirm(payCode + ":POS机交易失败，是否再次发起交易")) {
						bool = true;
					}
				} else {
					bool = true;
				}
			} while (!bool)
			break;
		default:
			bankData = "DHCBillMisPosPay.js中CallDLLFun方法未修改，请检查";
			break;
		}
	} catch (e) {
		alert("调用MISPOS接口发生异常：" + e.message);
	}finally {
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
	if (PUBLIC_POSCfG.ISLOG != "Y") {
		return;
	}
	//获取配置文件中的日志保存路径
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
		"f.WriteLine('时间：" + now + "，操作员：" + session['LOGON.USERNAME'] + "(" + session['LOGON.USERCODE'] + ")');" + '\n' + 
		"f.WriteLine('入参：" + input + "');" + '\n' + 
		"f.WriteLine('出参：" + output + "');" + '\n' + 
		"f.WriteLine('-------------------------------------------------------------------');" + '\n' + 
		"f.Close();" + '\n' + 
		"return;" + '\n' + 
		"}());";
		CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		CmdShell.EvalJs(str);     //通过中间件运行打印程序
	} catch (e) {
		alert("交易日志保存失败，请检查配置的日志保存路径是否正确");
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
		CmdShell.notReturn = 0;          //有返回值调用
		var rtn = CmdShell.EvalJs(str);  //通过中间件运行打印程序
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
		alert("读取本地配置发生异常：" + e.message);
	}finally {
		return bool;
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
	var rtnValue = {
		ResultCode: -1004,
		ResultMsg: "交易失败",
		ETPRowID: ""
	}
	//var prtRowIDAry = hisPrtStr.split("!");
	var bool = ReadIniTxt();    //调用本地配置文件获取银行pos机厂家及终端号
	if (!bool) {
		rtnValue = {
			ResultCode: -1001,
			ResultMsg: "未读取到MisPos配置信息",
			ETPRowID: ""
		};
		return rtnValue;
	}

	//支持退货
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
	var bool = ReadIniTxt();     //调用配置文件获取银行及终端号
	if (!bool) {
		rtnValue = {
			ResultCode: -1001,
			ResultMsg: "未读取到MisPos配置信息"
		};
		return rtnValue;
	}
	var posCfg = PUBLIC_POSCfG.POSTYPE + "^" + PUBLIC_POSCfG.TID;
	//判断交易类型(D:当日退费，T:隔日退货)
	var bankTradeTypeRtn = GetBankTradeType(OrgETPRowID, posCfg);
	var bankTradeTypeAry = bankTradeTypeRtn.split("^");
	var bankTradeType = bankTradeTypeAry[0];
	var posUser = bankTradeTypeAry[1];
	if (bankTradeType == -2003) {
		//这块判断需要放到外层退费开始吧？？？
		rtnValue = {
			ResultCode: bankTradeType,
			ResultMsg: "退费终端pos银行跟原收款行不一致，不能退费，请去" + posUser + "处退费！"
		};
		return rtnValue;
	} 
	if (bankTradeType == -2001) {
		rtnValue = {
			ResultCode: bankTradeType,
			ResultMsg: "未取到退费的正交易数据"
		};
		return rtnValue;
	}
	if (bankTradeType == -2002) {
		rtnValue = {
			ResultCode: bankTradeType,
			ResultMsg: "获取原交易日期出错"
		};
		return rtnValue;
	};
	//newPrtRowID: 非空为全退
	//m_RefFlag: 0-表示允许差额退费 1-表示只能走全退再收
	//bankTradeType: D 撤销, T 退货
	if ((m_RefFlag == 1) && (newPrtRowID != "") && (bankTradeType == "D")) {
		var refundAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetRefundAmt", originalType, abortPrtRowID, "", payMode);
		var myExpStr = expStr + "^" + abortPrtRowID;    //注意必须把业务ID加到扩展串第5位，否则订单不会与业务关联
		var RefundRtn = BankCardRefund(OrgETPRowID, refundAmt, tradeType, bankTradeType, payMode, myExpStr);
		var RefundAry = RefundRtn.split("^");
		var ResultCode = RefundAry[0];       //退费是否成功标志（0-退费成功，1-退费失败）
		var ResultMsg = RefundAry[1];
		switch (ResultCode) {
		case "0":
			//退费成功再收
			var tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, newPrtRowID, payMode);
			var PayRtn = BankCardPay(tradeType, tradeAmt, payMode, expStr);
			var PayAry = PayRtn.split("^");
			var ResultCode = PayAry[0];
			var ResultMsg = PayAry[1];
			var ETPRowID = PayAry[2];
			//退费无异常,根据再收情况返回
			rtnValue = {
				ResultCode: ResultCode,
				ResultMsg: ResultMsg
			};
			//收费成功关联收费订单
			if ([0, 1].indexOf(+ResultCode) != -1) {
				var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
				if (RelaRtn.ResultCode != 0) {
					rtnValue = {
						ResultCode: 1,
						ResultMsg: ResultMsg + "，" + RelaRtn.ResultMsg
					};
				}
			}
			break;
		case "1":
			rtnValue.ResultCode = ResultCode;
			//退费成功再收
			var tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, newPrtRowID, payMode);
			var myExpStr = expStr + "^" + newPrtRowID;
			var PayRtn = BankCardPay(tradeType, tradeAmt, payMode, myExpStr);
			var PayAry = PayRtn.split("^");
			var ResultCode = PayAry[0];
			var ResultMsg = PayAry[1];
			switch (ResultCode) {
			case "0":
				rtnValue.ResultMsg = "退费信息保存失败，再收成功";
				//关联收费订单
				if ([0, 1].indexOf(+ResultCode) != -1) {
					var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
					if (RelaRtn.ResultCode != 0) {
						rtnValue = {
							ResultCode: 1,
							ResultMsg: "退费信息保存失败，再收成功，关联收费订单失败"
						};
					}
				}
				break;
			case "1":
				rtnValue.ResultMsg = "退费信息保存失败，再收保存失败";
				//关联收费订单
				if ([0, 1].indexOf(+ResultCode) != -1) {
					var RelaRtn = RelationService(ETPRowID, newPrtRowID, tradeType);
					if (RelaRtn.ResultCode != 0) {
						rtnValue = {
							ResultCode: 1,
							ResultMsg: "退费信息保存失败，再收保存失败，关联收费订单失败"
						};
					}
				}
				break;
			default:
				rtnValue.ResultMsg = "退费信息保存失败，新票再收失败";
			}
			break;
		default:
			rtnValue = {
				ResultCode: ResultCode,
				ResultMsg: ResultMsg
			};
		}
	} else {
		//退货或全退
		var myExpStr = expStr + "^" + abortPrtRowID + "!" + newPrtRowID;
		var RefundRtn = BankCardRefund(OrgETPRowID, refundAmt, tradeType, bankTradeType, payMode, myExpStr);
		//退费是否成功标志（0-退费成功;1-退费成功数据保存失败;退费失败）
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
 * @desc <pos冲销入口>
 * @param {[String]} 	ETPRowID		[原正记录对应交易表id]
 * @param {[String]}	ExpStr			[扩展 科室^安全组^院区^操作员ID]
 * @return{[String]} 	rtnValue		[返回值:代码,描述()1^交易成功	[返回值 0^成功/错误描述]
 */
function correctPosPay(ETPRowID, ExpStr) {
	var rtnValue = {
		ResultCode: -3001,
		ResultMsg: "订单冲销失败"
	};
    var bool = ReadIniTxt(); //调用本地配置文件获取银行pos机厂家及终端号
    if (!bool) {
	    rtnValue.ResultCode = -1001;
		rtnValue.ResultMsg = "未读取到MisPos配置信息";
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
    //1:根据银行类型组织参数
    var bankInput = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "GetMisPosInput", ETPRowID);
    //2:调用接口
    var bankData = CallDLLFun(bankInput);
    if (bankData == -1003) {
	    rtnValue.ResultCode = -1003;
		rtnValue.ResultMsg = "MisPos调用失败";
        return rtnValue;
    }
    //3:保存数据到交易表
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
 * @desc <pos查证调用方法>
 * @param {[String]}	ETPRowID	[订单ID]
 * @return{[obj]} 		bankData		[返回值]
 */

function BankPayCheck(ETPRowID)
{
	var rtnValue = {
		ResultCode: -1004,
		ResultMsg: "交易失败",
		ETPRowID: ETPRowID
	}
	var posCfg = ReadIniTxt();    //调用本地配置文件获取银行pos机厂家及终端号
	if (!posCfg) {
		rtnValue = {
			ResultCode: -1001,
			ResultMsg: "未读取到MisPos配置信息",
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
		return bankData + "^" + "MisPos调用失败" + "^";
	}else{
		//处理银行的返回值字段，his交易成功后，保存到交易表
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
