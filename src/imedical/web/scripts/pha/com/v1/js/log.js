/**
 * description: 药房药库日志公共
 * creator:     Huxt 2022-04-29
 * js:          pha/com/v1/js/log.js
 */
var PHA_LOG = {
	/**
	 * 记录用户操作日志入口, 调用示例:
	 * PHA_LOG.Operate({
	 *     operate: '操作类型(必填,Q/P/E/A/U/D/O,字母具体含义见通用字典)',
	 *     logInput: '操作时记录的参数(必填)',
	 *     type: '数据类型,一般写表名',
	 *     pointer: '数据ID',
	 *     origData: '原数据',
	 *     remarks: '备注信息'
	 * });
	 * operate/logInput 必填
	 */
	Operate: function(_params){
		var pJson = $.extend({
			userID: session['LOGON.USERID'],
			clientMAC: this._getMAC(),
			clientIP: this._getIP()
		}, _params);
		return $.m({
			ClassName: 'PHA.COM.Log',
			MethodName: 'Operate',
			pJsonStr: JSON.stringify(pJson)
		}, false);
	},
	/**
	 * 调用接口方法并留痕日志, 调用示例:
	 * PHA_LOG.Face({
	 *     _code: '接口的代码,接口列表中维护的为准 (必填)',
	 *     _loc: '接口的使用科室,接口列表中维护的为准 (选填)',
	 *     _log: '调用接口时存的日志类型 (如:SYS/SCI/OP/IP/IN/...,字母具体含义见通用字典,默认为SYS)',
	 *     param1: '接口参数1,命名应当与接口的参数名一致',
	 *     param2: '接口参数2,命名应当与接口的参数名一致'
	 * });
	 * 其中_code必填
	 */
	Face: function(_params){
		var pJson = $.extend({}, _params);
		return $.m({
			ClassName: 'PHA.COM.Log',
			MethodName: 'Face',
			pJsonStr: JSON.stringify(pJson)
		}, false);
	},
	/**
	 * 添加打印日志入口, 调用示例: -> 停用,统一用Operate
	 * PHA_LOG.Print({
	 *     type: '业务单据类型(必填)',
	 *     pointer: '业务单据ID(必填)',
	 *     remark: '备注(选填)'
	 * });
	 * type/pointer为必填,其余信息自动获取
	 */
	Print: function(_params){
		var pJson = $.extend({
			userID: session['LOGON.USERID'],
			MACAdd: this._getMAC(),
			IPAdd: this._getIP()
		}, _params);
		return $.m({
			ClassName: 'PHA.COM.Log',
			MethodName: 'Print',
			pJsonStr: JSON.stringify(pJson)
		}, false);
	},
	_getMAC: function(){
		if (typeof PHA_LOG.tmpMAC == 'undefined') {
			try {
				var clientStr = getClientIP();
				PHA_LOG.tmpMAC = clientStr.split('^')[2] || '';
			} catch(e) {
				PHA_LOG.tmpMAC = this._getMACByHtml();
			}
		}
		return PHA_LOG.tmpMAC;
	},
	/*
	 * 这是在药学首页添加的MAC地址.
	 * 因为有些页面没有添加<ADDINS/>则获取不到MAC, 但是药房药库的系统都会进入药学首页,
	 * 则在药学首页把MAC获取到存起来, 然后在这里获取, 就不用每个界面都添加<ADDINS/>了.
	 */
	_getMACByHtml: function(){
		return $(window.parent.document).find('#pha_mac').val() || ''; 
	},
	_getIP: function(){
		return (typeof ClientIPAddress == 'undefined' ? '' : ClientIPAddress);
	}
}

