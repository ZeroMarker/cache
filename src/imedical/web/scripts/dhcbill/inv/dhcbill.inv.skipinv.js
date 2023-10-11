/**
 * FileName: dhcbill.inv.skipinv.js
 * Author: ZhYW
 * Date: 2021-01-12
 * Description: 跳号
 */

var skipInv = function (args) {
	args = args || {};
	this.receiptType = args.receiptType || "";
	this.insTypeId = args.insTypeId || "";
};

(function () {
	var _receiptType = "";     //票据类型
	var _insTypeId = "";       //费别
	var _abortEndNo = "";      //作废结束号(不含title)
	var _receiptId = "";       //发票发放表RowId
	var _title = "";           //发票号title
	var _curNo = "";           //当前号(不含title)
	var _endNo = "";           //当前号段结束号(不含title)
	var _leftNum = "";         //发票剩余数
	
	/**
     * 初始化按钮事件
     */
	var _initBtnEvents = function () {
		$HUI.linkbutton("#btn-save", {
			onClick: function () {
				_saveClick();
			}
		});
	};
	
	/**
     * 初始化文本框事件
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
	* 获取票据信息
	*/
	var _getReceiptNo = function() {
		switch(_receiptType) {
		case "OP":
			//门诊发票
			_getOPRcptInfo();
			break;
		case "OD":
			//门诊预交金
			_getAccPDRcptInfo();
			break;
		case "IP":
			//住院发票
			_getIPRcptInfo();
			break;
		default:
			//住院押金
			_getIPDepRcptInfo();
		}
	};
	
	/**
	* 获取门诊发票信息
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
	* 获取门诊预交金信息
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
	* 获取住院发票信息
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
	* 获取住院押金信息
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
	* 根据获取到的发票信息给界面元素赋值
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
	* 根据输入的数量计算结束号
	*/
	var _calcAbortEndNo = function () {
		var num = getValueById("abortNum");
		if (!(num > 0)) {
			_abortEndNo = "";
			setValueById("abortEndNo", "");
			return;
		}
		var patt = /^[\d]+$/;
		if (!patt.test(_curNo)) {    //验证是否全是数字
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
	* 保存
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
	
		$.messager.confirm("确认", "是否确认跳号？", function (r) {
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
					$.messager.alert("提示", "作废成功", "success", function() {
						websys_showModal("options").callbackFunc();
						websys_showModal("close");
					});
					return;
				}
				$("#btn-save").linkbutton("enable");
				$.messager.popover({msg: "作废失败：" + (myAry[1] || myAry[0]), type: "error"});
			});
		});
	};
	
	/**
	* 保存前校验
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
				$.messager.popover({msg: ("<font color='red'>" + $(this).parent().prev().children().text() + "</font>" + $g("不能为空")), type: "info"});
				return false;
			}
		});
		if (!bool) {
			return bool;
		}
		if (!_receiptType) {
			$.messager.popover({msg: '票据类型不能为空', type: 'info'});
			return false;
		}
		if (!getValueById("abortEndNo")) {
			$.messager.popover({msg: '结束号码不能为空', type: 'info'});
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