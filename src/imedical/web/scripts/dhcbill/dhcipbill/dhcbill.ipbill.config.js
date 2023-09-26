/**
* dhcbill.ipbill.config.js
*/

/**
* 取住院配置
*/
var IPBILL_CONF = {
	PARAM: $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetIPParamConfig", hospId: session['LOGON.HOSPID']}, false)
}