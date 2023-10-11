/**
 * FileName: dhcbill.inv.skipinv.js
 * Author: ZhYW
 * Date: 2021-01-12
 * Description: ����
 */

var skipInv = function (args) {
	args = args || {};
	this.receiptType = args.receiptType || "";
	this.insTypeId = args.insTypeId || "";
};

(function () {
	var _receiptType = "";     //Ʊ������
	var _insTypeId = "";       //�ѱ�
	var _abortEndNo = "";      //���Ͻ�����(����title)
	var _receiptId = "";       //��Ʊ���ű�RowId
	var _title = "";           //��Ʊ��title
	var _curNo = "";           //��ǰ��(����title)
	var _endNo = "";           //��ǰ�Ŷν�����(����title)
	var _leftNum = "";         //��Ʊʣ����
	
	/**
     * ��ʼ����ť�¼�
     */
	var _initBtnEvents = function () {
		$HUI.linkbutton("#btn-save", {
			onClick: function () {
				_saveClick();
			}
		});
	};
	
	/**
     * ��ʼ���ı����¼�
     */
	var _initTextboxEvents = function() {
		$("#abortNum")
	    .numberbox({
			min: 1,
			isKeyupChange: true,
			fix: false,
			onChange: function (newValue, oldValue) {
				_calcAbortEndNo();
			}
		})
		.focus()
		.keydown(function (e) {
		    var key = websys_getKey(e);
			if (key == 13) {
				if ($(e.target).val()) {
					focusById("abortReason");
				}
			}
	    });
	};
	
	/**
	* ��ȡƱ����Ϣ
	*/
	var _getReceiptNo = function() {
		switch(_receiptType) {
		case "OP":
			//���﷢Ʊ
			_getOPRcptInfo();
			break;
		case "OD":
			//����Ԥ����
			_getAccPDRcptInfo();
			break;
		case "IP":
			//סԺ��Ʊ
			_getIPRcptInfo();
			break;
		default:
			//סԺѺ��
			_getIPDepRcptInfo();
		}
	};
	
	/**
	* ��ȡ���﷢Ʊ��Ϣ
	*/
	var _getOPRcptInfo = function () {
		var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + "F" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetOPReceiptNo",
			userId: PUBLIC_CONSTANT.SESSION.USERID,
			insType: _insTypeId,
			expStr: expStr
		}, function (rtn) {
			_setRcptInfo(rtn);
		});
	};
	
	/**
	* ��ȡ����Ԥ������Ϣ
	*/
	var _getAccPDRcptInfo = function() {
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetAccPreReceiptNo",
			userId: PUBLIC_CONSTANT.SESSION.USERID,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (rtn) {
			_setRcptInfo(rtn);
		});
	};
	
	/**
	* ��ȡסԺ��Ʊ��Ϣ
	*/
	var _getIPRcptInfo = function() {
		var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetIPReceiptNo",
			userId: PUBLIC_CONSTANT.SESSION.USERID,
			insType: _insTypeId,
			expStr: expStr
		}, function (rtn) {
			_setRcptInfo(rtn);
		});
	};
	
	/**
	* ��ȡסԺѺ����Ϣ
	*/
	var _getIPDepRcptInfo = function() {
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetIPDepReceiptNo",
			userId: PUBLIC_CONSTANT.SESSION.USERID,
			depositType: _receiptType,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (rtn) {
			_setRcptInfo(rtn);
		});
	};
	
	/**
	* ���ݻ�ȡ���ķ�Ʊ��Ϣ������Ԫ�ظ�ֵ
	*/
	var _setRcptInfo = function(rtn) {
		var myAry = rtn.split("^");
		_curNo = myAry[0];
		_receiptId = myAry[1];
		_leftNum = +myAry[2];
		_endNo = myAry[3];
		_title = myAry[4];
		setValueById("curNo", (_title + "[" + _curNo + "]"));
		setValueById("abortStNo", (_title + "[" + _curNo + "]"));
		setValueById("leftNum", _leftNum);
		
		$.extend($("#abortNum").numberbox("options"), {max: _leftNum});
	};
	
	/**
	* ����������������������
	*/
	var _calcAbortEndNo = function () {
		var num = getValueById("abortNum");
		if (!(num > 0)) {
			_abortEndNo = "";
			setValueById("abortEndNo", "");
			return;
		}
		var patt = /^[\d]+$/;
		if (!patt.test(_curNo)) {    //��֤�Ƿ�ȫ������
			return;
		}
		var endNo = String(Number(_curNo).add(num) - 1);
		if (endNo.length < _curNo.length) {
			endNo = formatString(endNo, _curNo.length, "0");
		}
		_abortEndNo = endNo;
		setValueById("abortEndNo", (_title + "[" + endNo + "]"));
	}
	
	/**
	* ����
	*/
	var _saveClick = function () {
		if ($("#btn-save").linkbutton("options").disabled) {
			return;
		}		
		if (!_checkData()) {
			return;
		}
		$("#btn-save").linkbutton("disable");
		
		var abortNum = getValueById("abortNum");
		var voidReason = getValueById("abortReason");
	
		$.messager.confirm("ȷ��", "�Ƿ�ȷ�����ţ�", function (r) {
			if (!r) {
				$("#btn-save").linkbutton("enable");
				return;
			}
			var invStr = _curNo + "^" + voidReason + "^" + _abortEndNo + "^" + abortNum
		        + "^" + _endNo + "^" + _title + "^" + _insTypeId + "^" + _receiptType;
		    
			$.m({
				ClassName: "web.DHCBillSkipInvoice",
				MethodName: "SkipInvoice",
				invStr: invStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$("#btn-save").linkbutton("enable");
					$.messager.alert("��ʾ", "���ϳɹ�", "success", function() {
						websys_showModal("options").callbackFunc();
						websys_showModal("close");
					});
					return;
				}
				$("#btn-save").linkbutton("enable");
				$.messager.popover({msg: "����ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
			});
		});
	};
	
	/**
	* ����ǰУ��
	*/
	var _checkData = function () {
		var bool = true;
		$(".validatebox-text").each(function() {
			if (!$(this).validatebox("isValid")) {
				bool = false;
				return false;
			}
		});
		if (!bool) {
			return bool;
		}
		$(".clsRequired").parent().next().children().each(function(index, item) {
			if (!this.id) {
				return true;
			}
			if (!getValueById(this.id)) {
				bool = false;
				focusById(this.id);
				$.messager.popover({msg: ("<font color='red'>" + $(this).parent().prev().children().text() + "</font>" + $g("����Ϊ��")), type: "info"});
				return false;
			}
		});
		if (!bool) {
			return bool;
		}
		if (!_receiptType) {
			$.messager.popover({msg: 'Ʊ�����Ͳ���Ϊ��', type: 'info'});
			return false;
		}
		if (!getValueById("abortEndNo")) {
			$.messager.popover({msg: '�������벻��Ϊ��', type: 'info'});
			return false;
		}
		return true;
	}
	
	skipInv.prototype.init = function () {
		_receiptType = this.receiptType;
		_insTypeId = this.insTypeId;
		
		_initBtnEvents();
		
		_initTextboxEvents();
		
		_getReceiptNo();
	};
})();

$(function () {
    var skipInvObj = new skipInv(CV.Args);
    skipInvObj.init();
});