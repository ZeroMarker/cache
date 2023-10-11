/**
 * description: ҩ��ҩ����־����
 * creator:     Huxt 2022-04-29
 * js:          pha/com/v1/js/log.js
 */
var PHA_LOG = {
	/**
	 * ��¼�û�������־���, ����ʾ��:
	 * PHA_LOG.Operate({
	 *     operate: '��������(����,Q/P/E/A/U/D/O,��ĸ���庬���ͨ���ֵ�)',
	 *     logInput: '����ʱ��¼�Ĳ���(����)',
	 *     type: '��������,һ��д����',
	 *     pointer: '����ID',
	 *     origData: 'ԭ����',
	 *     remarks: '��ע��Ϣ'
	 * });
	 * operate/logInput ����
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
	 * ���ýӿڷ�����������־, ����ʾ��:
	 * PHA_LOG.Face({
	 *     _code: '�ӿڵĴ���,�ӿ��б���ά����Ϊ׼ (����)',
	 *     _loc: '�ӿڵ�ʹ�ÿ���,�ӿ��б���ά����Ϊ׼ (ѡ��)',
	 *     _log: '���ýӿ�ʱ�����־���� (��:SYS/SCI/OP/IP/IN/...,��ĸ���庬���ͨ���ֵ�,Ĭ��ΪSYS)',
	 *     param1: '�ӿڲ���1,����Ӧ����ӿڵĲ�����һ��',
	 *     param2: '�ӿڲ���2,����Ӧ����ӿڵĲ�����һ��'
	 * });
	 * ����_code����
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
	 * ��Ӵ�ӡ��־���, ����ʾ��: -> ͣ��,ͳһ��Operate
	 * PHA_LOG.Print({
	 *     type: 'ҵ�񵥾�����(����)',
	 *     pointer: 'ҵ�񵥾�ID(����)',
	 *     remark: '��ע(ѡ��)'
	 * });
	 * type/pointerΪ����,������Ϣ�Զ���ȡ
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
	 * ������ҩѧ��ҳ��ӵ�MAC��ַ.
	 * ��Ϊ��Щҳ��û�����<ADDINS/>���ȡ����MAC, ����ҩ��ҩ���ϵͳ�������ҩѧ��ҳ,
	 * ����ҩѧ��ҳ��MAC��ȡ��������, Ȼ���������ȡ, �Ͳ���ÿ�����涼���<ADDINS/>��.
	 */
	_getMACByHtml: function(){
		return $(window.parent.document).find('#pha_mac').val() || ''; 
	},
	_getIP: function(){
		return (typeof ClientIPAddress == 'undefined' ? '' : ClientIPAddress);
	}
}

