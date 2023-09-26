///DHCBillPayByScanCode.js

/**
 * @fileOverview <扫码业务>
 * @author <zhenghao>
 * @version <scancode>
 * @updateDate <2018-03-09>
 */
var PUBLIC_SPCONFIG = {
	WaitPayTime: 60,       //支付等待时间
	WaitScanTime: 60,      //扫码等待时间
	VerifyInterval: 10     //查询间隔
	//ScanRtn: "-1001"     //默认失败
}

var m_VerifyTimeAry = [4, 6]; //轮询队列间隔秒数

var m_SecondPass = 0;         //秒表计数器

var m_onkeydownFlag = false;  //键盘事件

var PUBLIC_SPRETURN = {
	ResultCode: "-1001", //成功失败标志
	ResultMsg: "接口收费失败", //返回描述
	ETPRowID: "" //订单表ID
};
var ParmObj = window.dialogArguments; //传入参数

function BodyLoadHandler() {
	var obj = document.getElementById("mb_btn_no");
	if (obj) {
		obj.onclick = CloseWin;   //关闭按钮
	}
	var obj = document.getElementById("ScanCode");
	if (obj) {
		obj.onkeydown = function (event) {
			var e = event ? event : (window.event ? window.event : null);
			if (e.keyCode == 13) {
				m_onkeydownFlag = true;
			}
		}
	}
	
	var obj = document.getElementById('ScanCode');
	if (obj) {
		obj.focus();
		obj.select();
	}
	waitScan();
}

/**
 * [waitScan 扫码校验]
 */
function waitScan() {
	if (PUBLIC_SPCONFIG.WaitScanTime == 0) {
		window.returnValue = PUBLIC_SPRETURN;
		window.close();
	}
	document.getElementById("mb_second").innerText = PUBLIC_SPCONFIG.WaitScanTime + "S";
	if (m_onkeydownFlag) {
		//创建订单
		var scanCode = document.getElementById("ScanCode").value;
		var buildRtn = createScanCodePay(ParmObj.tradeType, ParmObj.payMode, ParmObj.tradeAmt, scanCode, ParmObj.expStr);
		var rtn = buildRtn.split('^')[0];
		switch (rtn) {
		case "0":
			PUBLIC_SPRETURN.ETPRowID = buildRtn.split('^')[1];
			//提交支付
			document.getElementById("mb_paysta").innerHTML = '<img id="mb_payico" src="../images/paying.png"/>支付中...';
			document.getElementById("mb_second").innerText = PUBLIC_SPCONFIG.WaitPayTime + "S";
			commitPay();
			break;
		case "100":
			PUBLIC_SPRETURN.ResultMsg = "程序异常,创建订单失败,收费失败"; //返回描述
			window.returnValue = PUBLIC_SPRETURN;
			window.close();
			break;
		case "200":
			PUBLIC_SPRETURN.ResultMsg = "接口调用异常,创建订单失败,收费失败"; //返回描述
			window.returnValue = PUBLIC_SPRETURN;
			window.close();
			break;
		case "300":
			PUBLIC_SPRETURN.ResultMsg = "支付方式未配置Adapter类,创建订单失败,收费失败"; //返回描述
			window.returnValue = PUBLIC_SPRETURN;
			window.close();
			break;
		default:
			PUBLIC_SPRETURN.ResultMsg = "创建订单失败,收费失败"; //返回描述
			window.returnValue = PUBLIC_SPRETURN;
			window.close();
		}
	} else {
		setTimeout("waitScan()", 1000);
	}
	PUBLIC_SPCONFIG.WaitScanTime--;
}

/**
 * [commitPay 提交支付]
 */
function commitPay() {
	var scanCode = document.getElementById("ScanCode").value;
	//调用支付接口
	var comitRtn = commitScanCodePay(PUBLIC_SPRETURN.ETPRowID, scanCode);
	var rtn = comitRtn.split('^')[0];    //00 交易成功 01 支付中 02 失败
	switch (rtn) {
	case "00":
		document.getElementById("mb_msg").innerHTML = "支付成功";
		//PUBLIC_SPRETURN.returnCode=comitRtn;
		PUBLIC_SPRETURN.ResultCode = "0";
		PUBLIC_SPRETURN.ResultMsg = "支付成功";
		if (comitRtn.split('^')[1] != "0") {
			//保存数据失败返回1
			PUBLIC_SPRETURN.ResultCode = "1";
			PUBLIC_SPRETURN.ResultMsg = "支付成功,保存订单数据失败";
		}
		window.returnValue = PUBLIC_SPRETURN;
		setTimeout("window.close()", 1000);
		break;
	case "01":
		//轮询查证
		setTimeout("verifyPay()", 1000);
		break;
	case "02":
		PUBLIC_SPRETURN.ResultCode = "-1002";
		PUBLIC_SPRETURN.ResultMsg = "第三方收费失败";
		window.returnValue = PUBLIC_SPRETURN;
		window.close();
		break;
	case "100":
		PUBLIC_SPRETURN.ResultCode = "-1002";
		PUBLIC_SPRETURN.ResultMsg = "程序异常,提交订单失败", //返回描述
		window.close();
	case "200":
		PUBLIC_SPRETURN.ResultCode = "-1002";
		PUBLIC_SPRETURN.ResultMsg = "接口调用异常,提交订单失败"; //返回描述
		window.returnValue = PUBLIC_SPRETURN;
		window.close();
		break;
	default:
		PUBLIC_SPRETURN.ResultCode = "-1002";
		PUBLIC_SPRETURN.ResultMsg = "提交订单失败,收费失败"; //返回描述
		window.returnValue = PUBLIC_SPRETURN;
		window.close();
	}
}
/**
 * [verifyPay 轮询订单状态]
 */
function verifyPay() {
	var ScanCode = document.getElementById("ScanCode").value;
	PUBLIC_SPCONFIG.WaitPayTime--;
	m_SecondPass++;
	//$("#mb_payico").show();
	document.getElementById("mb_second").innerText = PUBLIC_SPCONFIG.WaitPayTime + "S";
	if (PUBLIC_SPCONFIG.WaitPayTime == 0) {
		window.returnValue = PUBLIC_SPRETURN;
		window.close();
	}

	if (m_VerifyTimeAry.length > 0) {
		if (m_SecondPass == m_VerifyTimeAry[0]) {
			//调用查证接口
			var verifyRtn = verifyScanCodePayStatus(PUBLIC_SPRETURN.ETPRowID, ScanCode);
			m_SecondPass = 0;
			var rtn = verifyRtn.split('^')[0];
			switch (rtn) {
			case "00":
				document.getElementById("mb_msg").empty();
				document.getElementById("mb_msg").innerHtml = "支付完成";
				PUBLIC_SPRETURN.ResultCode = "0";
				PUBLIC_SPRETURN.ResultMsg = "支付成功";
				if (verifyRtn.split('^')[1] != "0") {
					//保存数据失败返回1
					PUBLIC_SPRETURN.ResultCode = "1";
					PUBLIC_SPRETURN.ResultMsg = "支付成功,保存订单数据失败";
				}
				window.returnValue = PUBLIC_SPRETURN;
				setTimeout("window.close()", 1000);
				break;
			case "100":
				PUBLIC_SPRETURN.ResultCode = "-1003";
				PUBLIC_SPRETURN.ResultMsg = "程序异常,查证订单失败,收费失败"; //返回描述
				//window.returnValue = PUBLIC_SPRETURN;
				//window.close();
				break;
			case "200":
				PUBLIC_SPRETURN.ResultCode = "-1003";
				PUBLIC_SPRETURN.ResultMsg = "接口调用异常,查证订单失败,收费失败"; //返回描述
				window.returnValue = PUBLIC_SPRETURN;
				window.close();
				break;
			default:
				PUBLIC_SPRETURN.ResultCode = "-1003";
				PUBLIC_SPRETURN.ResultMsg = "查证订单失败,收费失败"; //返回描述
			}
			m_VerifyTimeAry.splice(0, 1);
		}
	} else {
		//默认5秒调用调用一次查证接口
		if (m_SecondPass % PUBLIC_SPCONFIG.VerifyInterval == 0) {
			var verifyRtn = verifyScanCodePayStatus(PUBLIC_SPRETURN.ETPRowID, ScanCode);
			var rtn = verifyRtn.split('^')[0];
			switch (rtn) {
			case "00":
				document.getElementById("mb_msg").empty();
				document.getElementById("mb_msg").innerHtml = "支付完成";
				PUBLIC_SPRETURN.ResultCode = "0";
				PUBLIC_SPRETURN.ResultMsg = "成功";
				if (verifyRtn.split('^')[1] != "0") {
					//保存数据失败返回1
					PUBLIC_SPRETURN.ResultCode = "1";
					PUBLIC_SPRETURN.ResultMsg = "支付成功,保存订单数据失败";
				}
				window.returnValue = PUBLIC_SPRETURN;
				setTimeout("window.close()", 1000);
				break;
			case "100":
				PUBLIC_SPRETURN.ResultCode = "-1003";
				PUBLIC_SPRETURN.ResultMsg = "程序异常,查证订单失败,收费失败"; //返回描述
				//window.returnValue = PUBLIC_SPRETURN;
				//window.close();
				break;
			case "200":
				PUBLIC_SPRETURN.ResultCode = "-1003";
				PUBLIC_SPRETURN.ResultMsg = "接口调用异常,查证订单失败,收费失败"; //返回描述
				window.returnValue = PUBLIC_SPRETURN;
				window.close();
				break;
			default:
				PUBLIC_SPRETURN.ResultCode = "-1003";
				PUBLIC_SPRETURN.ResultMsg = "查证订单失败,收费失败"; //返回描述
			}
			m_SecondPass = 0;
		}
	}
	setTimeout("verifyPay()", 1000);
}

/**
 * [CloseWin 关闭支付组件]
 */
function CloseWin() {
	var ScanCode = document.getElementById("ScanCode").value;
	if (document.getElementById("ScanCode").value != "") {
		var verifyRtn = verifyScanCodePayStatus(PUBLIC_SPRETURN.ETPRowID, ScanCode);
		var rtn = verifyRtn.split('^')[0];
		if (rtn == "00") {
			PUBLIC_SPRETURN.ResultCode = "0";
			PUBLIC_SPRETURN.ResultMsg = "成功";
			if (verifyRtn.split('^')[1] != "0") {
				//保存数据失败返回1
				PUBLIC_SPRETURN.ResultCode = "1";
				PUBLIC_SPRETURN.ResultMsg = "支付成功,保存订单数据失败";
			}
			window.returnValue = PUBLIC_SPRETURN;
		}
	}
	window.returnValue = PUBLIC_SPRETURN;
	window.close();
}

/**
 * [关闭前触发校验]
 */
//window.onbeforeunload = function()
function onbeforeunloadHandler() {
	var n = window.event.screenX - window.screenLeft;
	var b = n > document.documentElement.scrollWidth - 20;
	if (b && window.event.clientY < 0 || window.event.altKey) {
		//关闭前再调一次查证
		var ScanCode = document.getElementById("ScanCode").value;
		if (document.getElementById("ScanCode").value != "") {
			var verifyRtn = verifyScanCodePayStatus(PUBLIC_SPRETURN.ETPRowID, ScanCode);
			var rtn = verifyRtn.split('^')[0];
			if (rtn == "00") {
				PUBLIC_SPRETURN.ResultCode = "0";
				PUBLIC_SPRETURN.ResultMsg = "成功";
				window.returnValue = PUBLIC_SPRETURN;
				window.close();
			} else {
				//调用关闭订单
				//var closeRtn = cancelScanCodePay(PUBLIC_SPRETURN.ETPRowID);
			}
		}
		window.returnValue = PUBLIC_SPRETURN;
	}
	window.returnValue = PUBLIC_SPRETURN;
}

//document.body.onload = BodyLoadHandler;
