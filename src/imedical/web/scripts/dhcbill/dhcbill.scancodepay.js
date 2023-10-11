/**
 * dhcbill.scancodepay.js
 * @file 扫码业务
 * @author ZhYW
 * @date 2020-07-20
 */

var GV = {
	WaitPayTime: 60,        //支付等待时间
    WaitScanTime: 60,       //扫码等待时间
    VerifyInterval: 10,     //查询间隔
    VerifyTimeAry: [4, 6]   //轮循队列间隔秒数
};

var scanPay = function (args) {
	args = args || {};
	this.tradeType = args.tradeType || "";
	this.payMode = args.payMode || "";
	this.tradeAmt = args.tradeAmt || "";
	this.expStr = args.expStr || "";
};

(function () {
	var _counter = 0;               //秒表计数器
	var _tradeType = "";
	var _payMode = "";
	var _tradeAmt = "";
	var _expStr = "";
	var _scanCode = "";           //支付码
	
	//回调返回值
	var _rtnValue = {
		ResultCode: "",
		ResultMsg: "",
		ETPRowID: ""
	};
	
	scanPay.prototype.init = function () {
		_tradeType = this.tradeType;
		_payMode = this.payMode;
		_tradeAmt = this.tradeAmt;
		_expStr = this.expStr;
		
		_preventDefEvents();
		
		_initBtnEvents("#mb_btnbox>.l-btn");
		
		_initTextboxEvents();
		
		_scan();
	};
	
	/**
     * 阻止默认事件
     */
    var _preventDefEvents = function(e) {
	  	$(document)
	  	.keydown(function (e) {
		  	var key = websys_getKey(e);
			if ((e.ctrlKey && (key == 82)) || (key == 116)) {
				if (e.preventDefault) {
					e.preventDefault();
				}
				if (e.returnValue) {
					e.returnValue = false;
				}
				return false;
			}
		})
		.contextmenu(function(e) {
			$("#mb_scancode").focus();
			return false;
		});
	};
	
	/**
     * 初始化按钮事件
     */
	var _initBtnEvents = function (selector, callback) {
		var $linkbuttons = $(selector);
        $linkbuttons.each(function (index, element) {
            $(this).click(function (e) {
                switch ($(this).attr("id")) {
                case "mb_btn_no":
                    _closeWin();   //关闭
                    break;
                default:
                }
            });
        });
	};
	
	/**
     * 初始化文本框事件
     */
	var _initTextboxEvents = function() {
		$("#mb_scancode").imedisabled().focus().keydown(function (e) {
	        var key = websys_getKey(e);
	        if (key == 13) {
		        e.stopPropagation();
				e.preventDefault();
		        if ($(e.target).val() != "") {
			    	_scanCode = $(e.target).val();
			 		if (!$(e.target).prop("disabled")) {
					    $(e.target).prop("disabled", true);   //扫码回车后将扫码框禁用，防止二次扫码
					}
			    }
	        }
	    });
	};
	
	/**
	 * 扫码
	 */
	var _scan = function () {
	    if (GV.WaitScanTime == 0) {
		    _rtnValue.ResultCode = -1001;
		    _rtnValue.ResultMsg = "扫码超时";
	        _closeCallback();
	    }
	    $("#mb_second").html(GV.WaitScanTime + "S");
	    
	    if (_scanCode) {
	        //创建订单
	        var rtn = createScanCodePay(_tradeType, _payMode, _tradeAmt, _scanCode, _expStr);
	      	var myAry = rtn.split("^");
	        switch (myAry[0]) {
	        case "0":
	            _rtnValue.ETPRowID = myAry[1];
	            //提交支付
	            $("#mb_payico").attr("src", "../scripts/dhcbill/themes/default/images/paying.png")
	            $("#mb_paysta>span").text("支付中");
	            $("#mb_second").html(GV.WaitPayTime + "S");
	            _pay();
	            break;
	        default:
	        	_rtnValue.ResultCode = -1001;
	            _rtnValue.ResultMsg = "创建订单失败：" + (myAry[1] || "");
	         	_closeCallback();
	        }
	    } else {
	        setTimeout(function () {
	            _scan();
	        }, 1000);
			
			GV.WaitScanTime--;
	    }
	};
	
	/**
	 * 提交支付
	 */
	var _pay = function () {
	    //调用支付接口
	   	var rtn = commitScanCodePay(_rtnValue.ETPRowID, _scanCode);
	    var myAry = rtn.split("^");   //00:交易成功 01:支付中 02:失败
	    switch (myAry[0]) {
	    case "00":
	    	var code = 0;
	    	var msg = "支付成功";
	        $("#mb_ResultMsg").html(msg);
	        if (myAry[1] != 0) {
	            //保存数据失败返回1
	            code = 1;
	            msg += "，保存订单数据失败";
	        }
        	_rtnValue.ResultCode = code;
            _rtnValue.ResultMsg = msg;
	        _closeCallback();
	        break;
	    case "01":
	        //查证
	        _loopVerify();
	        break;
	    default:
	    	_rtnValue.ResultCode = -1002;
	    	_rtnValue.ResultMsg = "支付失败：" + (myAry[1] || "");
	        _closeCallback();
	    }
	};
	
	/**
	 * 轮循订单状态
	 */
	var _loopVerify = function () {
	    GV.WaitPayTime--;
	    _counter++;
	    $("#mb_second").html(GV.WaitPayTime + "S");
	    if (GV.WaitPayTime == 0) {
		    _rtnValue.ResultCode = -1003;
	     	_rtnValue.ResultMsg = "支付成功，保存订单数据失败";
	        _closeCallback();
	    }
		
		var rtn = "";
	    if (GV.VerifyTimeAry.length > 0) {
	        if (_counter == GV.VerifyTimeAry[0]) {
	            //调用查证接口
	         	_counter = 0;
				GV.VerifyTimeAry.shift();
				rtn = verifyScanCodePayStatus(_rtnValue.ETPRowID, _scanCode);
				_getVerify(rtn);
	        }
	    } else {
	        //默认5秒调用一次查证接口
	        if ((_counter % GV.VerifyInterval) == 0) {
				_counter = 0;
				rtn = verifyScanCodePayStatus(_rtnValue.ETPRowID, _scanCode);
				_getVerify(rtn);
	        }
	    }
	    setTimeout(function () {
	        _loopVerify();
	    }, 1000);
	};
	
	/**
	 * 获取查证结果
	 */
	var _getVerify = function(vStr) {
		var myAry = vStr.split("^");
		switch (myAry[0]) {
		case "00":
			var code = 0;
			var msg = "支付成功";
			$("#mb_ResultMsg").html(msg);
			if (myAry[1] != 0) {
				//保存数据失败返回1
				code = 1;
				msg += "，保存订单数据失败";
			}
			_rtnValue.ResultCode = code;
			_rtnValue.ResultMsg = msg;
			_closeCallback();
			break;
		default:
			_rtnValue.ResultCode = -1003;
			_rtnValue.ResultMsg = "查证订单失败：" + (myAry[1] || "");
		}
	};
	
	/**
	 * 关闭支付组件
	 */
	var _closeWin = function () {
		if ($("#mb_btn_no").linkbutton("options").disabled) {
			return;
		}
		$("#mb_btn_no").linkbutton("disable");

		try {
			var code = -1;
			var msg = "支付取消";
		    if (_scanCode) {
		        var rtn = verifyScanCodePayStatus(_rtnValue.ETPRowID, _scanCode);
		        var myAry = rtn.split("^");
		        if (myAry[0] == "00") {
			      	code = 0;
			      	msg = "支付成功";
		            if (myAry[1] != 0) {
		                //保存数据失败返回1
		                code = 1;
		                msg += "，保存订单数据失败";
		            }
		        }
		    }
	     	_rtnValue.ResultCode = code;
			_rtnValue.ResultMsg = msg;
			_closeCallback();
		}catch(e) {
			$("#mb_btn_no").linkbutton("enable");
			$.messager.popover({msg: e.message, type: "error"});
		}
	};
	
	/**
	* 支付完成回调
	*/
	var _closeCallback = function() {
		websys_showModal("options").callbackFunc(_rtnValue);
		websys_showModal("close");
	};
})();

$(function () {
    var scanPayObj = new scanPay(CV.Args);
    scanPayObj.init();
});