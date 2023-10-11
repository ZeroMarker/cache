/**
 * @file dhcbill.checkout.js
 * 收银台
 * @author ZhYW
 * @date 2021-08-30
 */

/** @class
 * 定义命名空间
 * @abstract
 */
var dhcbill = window.dhcbill || {};

/** @class
 * 定义收银台名空间
 * @abstract
 */
dhcbill.checkout = window.dhcbill.checkout || {};

/** @class
 * 收银台类
 */
dhcbill.checkout.CheckOut = function (args) {
    args = args || {};
    this.allowPayMent = args.allowPayMent || "";
    this.prtRowIdStr = args.prtRowIdStr || "";
    this.typeFlag = args.typeFlag || "";
    this.accMRowId = args.accMRowId || "";
    this.accMLeft = args.accMLeft || "";
	this.patientId = args.patientId || "";
    this.episodeIdStr = args.episodeIdStr || "";
    this.cardNo = args.cardNo || "";
    this.cardTypeId = args.cardTypeId || "";
    this.totalAmt = args.totalAmt || "",
	this.discAmt = args.discAmt || "",
	this.payorAmt = args.payorAmt || "",
	this.patShareAmt = args.patShareAmt || "",
	this.insuAmt = args.insuAmt || "",
	this.payAmt = args.payAmt || "",
    this.reloadFlag = args.reloadFlag || "";
	this.bizType = args.bizType || "";
};

//构建一个块级作用域
(function () {
    //私有成员属性
    var _allowPayMent = "N";
    var _isManyPayment = false;   //是否开启多种支付
    var _accMRowId = "";
    var _accMLeft = "";
    var _prtRowIdStr = "";
    var _typeFlag = "";
    var _episodeIdStr = "";
    var _patientId = "";
    var _cardNo = "";
    var _cardTypeId = "";
    var _patShareAmt = "";    //自付金额
    var _payAmt = "";         //自费支付金额
    var _reloadFlag = "";
    var _bizType = "";            //业务类型
	var _payMConETP = {}          //存放第三方交易表RowId
	var _$paymentAry = [];        //存放使用的支付方式
	
    /**
     * 支付方式容器对象
     * @static @private
     */
    var _$container = null;

    //选中支付方式
    var _selectedPayMode = function ($this) {
        _$container.find(".select-item").removeClass("selected");
        $this.addClass("selected");
    };
	
	//默认焦点定位
	var _initDefaultFocus = function() {
		if ($(".select-item.selected:eq(0)").length == 0) {
			return;
		}
		if (_isNeedFocusActualMUN()) {
			focusById("actualMoney");
		}else {
			focusById("btn-ok");
		}
	};
	
	//是否需要将焦点定位至"实收"
	var _isNeedFocusActualMUN = function() {
		if (!CV.NeedActualMoney) {
			return false;
		}
		if ($("#actualMoney").length == 0) {
			return false;
		}
		var $selectedItem = $(".select-item.selected:eq(0)");
		if ($selectedItem.length == 0) {
			return false;
		}
		return $selectedItem.attr("data").split("^")[1] == "CASH";   //默认选中支付方式为现金时，需要将焦点定位至"实收"
	};
	
	var _getAdditionalData = function (paymId) {
        return $.m({ClassName: "web.UDHCOPGSConfig", MethodName: "GetAdditionalData", payMode: paymId, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
    };
    
    //计算现金的分币误差
    var _calcRoundErrCASH = function () {
	    var cashAmt = _isManyPayment ? _getCASHPayAmt() : _payAmt;
        _calcRoundErr(cashAmt);
    };

    //计算分币误差
    var _calcRoundErr = function (cashAmt) {
	    if (!CV.IsChgBizType) {
		    return;     //非收费业务不计算分币误差
		}
        var cashPayAmtRoundInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetManyInvRoundErrAmt", prtRowIdStr: _prtRowIdStr, amt: cashAmt}, false);
        var cashRoundAry = cashPayAmtRoundInfo.split("^");
        var cashRoundSum = cashRoundAry[0];
        setValueById("roundCASHAmt", cashRoundSum);
        setValueById("roundErrAmt", Number(cashRoundSum).sub(cashAmt).toFixed(2));
        $("#roundErrAmt").attr("data", cashRoundAry[1]);
    };

    //获取默认支付方式文本框当前金额
    var _getDefaultPayMAmt = function () {
        return +$("#" + _getDefaultPayMId()).val();  //考虑误差金额
    };

    //获取默认支付方式文本框id
    var _getDefaultPayMId = function () {
        var $defaultPayMAmt = _$container.find(".select-item-amt .default-paymode-amt");
        return $defaultPayMAmt.attr("id");
    };

    //设置默认支付方式金额
    var _setDefaultPayMAmt = function (val) {
        setValueById(_getDefaultPayMId(), val);
    };

    //获取支付方式列表中现金支付金额
    var _getCASHPayAmt = function () {
        return ($("#txtPayMzCASH").length > 0) ? +$("#txtPayMzCASH").val() : 0;
    };

    //获取分币误差金额
    var _getRoundErrAmt = function () {
        return ($("#roundErrAmt").length > 0) ? +$("#roundErrAmt").val() : 0;
    };

    //获取现金舍入金额
    var _getRoundCASHAmt = function () {
        return ($("#roundCASHAmt").length > 0) ? +$("#roundCASHAmt").val() : 0;
    };

    //获取获取支付方式金额合计
    var _getAllPayMAmtSum = function () {
		var inputs = _$container.find(".select-item-amt .paymode-amt");   //获取所有输入框
		return Array.from(inputs).reduce(function (total, element) {
			return Number(total).add(+$(element).val()).toFixed(2);
	    }, 0);
    };
	
    //校验支付方式合计金额是否正确
    var _checkAllPayMAmtSum = function () {
        if (_isManyPayment) {
            var sum = _getAllPayMAmtSum();
            return +sum == +_payAmt;
        }
		return true; //单种支付方式模式不用校验
    };
	
    //校验分币误差金额是否正确
    var _checkRoundAmt = function () {
	    if (!CV.IsChgBizType) {
			return true;     //非收费业务不校验分币误差
		}
        var roundErrAmt = _getRoundErrAmt();
        var roundCASHAmt = _getRoundCASHAmt();
        if (_isManyPayment) {
            var cashPayAmt = _getCASHPayAmt();
            return Number(cashPayAmt).add(roundErrAmt).toFixed(2) == +roundCASHAmt;
        }
		return Number(_payAmt).add(roundErrAmt).toFixed(2) == +roundCASHAmt;
    };
    
	//是否是现金的收费业务，现金的收费业务需要考虑分币误差
	var _isCASHChgBiz = function (payMCode) {
		if (!CV.IsChgBizType) {
			return false;
		}
		if (payMCode != "CASH") {
			return false;
		}
		return true;
	};
	
    //计算支付方式金额框的
    //算法规则：
    //		1.默认加载时，自费金额在默认支付方式上
    //		2.收费员填写非默认支付方式金额后，自动扣减默认值支付方式金额，如果默认支付金额小于0，则提示异常。
    //算法存在的问题
    //		1.如果收费员修改了默认支付方式的金额，将导致算法异常。
    var _calcTextBoxPayMAmt = function ($this) {
        var oldVal = $this.attr("data-oldval") ? +$this.attr("data-oldval") : 0;
        var newVal = $this.val() ? +$this.val() : 0;
        var diffVal = Number(newVal).sub(oldVal).toFixed(2);
        var defPayMAmt = _getDefaultPayMAmt();   //默认支付方式当前金额
        var balance = Number(defPayMAmt).sub(diffVal).toFixed(2);
        if (balance < 0) {
            if (oldVal == 0) {
                oldVal = "";
            }
            $this.attr("data-oldval", oldVal);
            $this.val(oldVal);
            $this.validatebox("validate");
            return;
        }
        _setDefaultPayMAmt(balance);
        if ($this.hasClass("CASH-class")) {
            _calcRoundErr(newVal);
            return;
        }
        _calcRoundErrCASH();
    };
	
	var _manyPMSwitchChangeHandler = function(checked) {
		_isManyPayment = checked;
        _$container.find(".select-item-amt").toggleClass("hidden");
        var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
        if (_isManyPayment) {
            //开启多种支付时，设置默认支付的金额
            _setDefaultPayMAmt(_payAmt);
            _calcRoundErrCASH();
            //定位光标到第一个非默认支付金额框
            $.each(inputs, function (index, element) {
	            if ($(element).hasClass("default-paymode-amt")) {
		            return true;
		        }
		        if ($(element).numberbox("options").disabled) {   //如果输入框被禁用，则跳过
                    return true;
                }
                $(element).get(0).focus();
             	_selectedPayMode($(element).parent().prev());
             	return false;
            });
        } else {
        	inputs.numberbox("clear");
            _selectedPayMode($(".default-paymode"));
            _calcRoundErr(_payAmt);
        }
	};
	
    /**
     * 初始化多种支付方式按钮
     * @static @private
     */
    var _initAllowPaymentBtn = function () {
        $HUI.switchbox("#switchManyPayM", {
            onText: $g('多种支付'),
            offText: $g('单种支付'),
            onClass:'primary',
            offClass:'gray',
            size: 'small',
            checked: false,
            onSwitchChange: function (e, obj) {
	            _manyPMSwitchChangeHandler(obj.value);
            }
        });
    };
	
    /**
     * 初始化支付方式列表选择事件
     * @param {String} 支付列表容器选择器
     * @param {String} 回调事件，暂时不用
     * @static @private
     */
    var _initSelectBox = function (selector, callback) {
        _$container = $(selector);

        //绑定快捷键
        $(document).keydown(function (e) {
            var key = websys_getKey(e);
            //阻止默认事件
            prevDefHotKey(e);
            
            var $selectItem = $(".select-item.selected:eq(0)");  //+2022-07-13 ZhYW 当前选中的支付方式按钮
            var diffVal = "";
            var $target = null;
            var hotKey = "";  //页面设置的快捷键
            _$container.find(".select-item[data]").each(function() {
                hotKey = $(this).attr("data").split("^")[6];
                if (key == KEYCODE[hotKey]) {
                    $target = $(this);
                    return false;
                }
                //+2022-07-13 ZhYW 上下左右键选中支付方式
                if (($.inArray(key, [37, 38, 39, 40]) != -1) && ($selectItem.length > 0)) {
                    if ($(this).hasClass("selected")) {
                        return true;      //已经被选中的退出
                    }
                    if ($.inArray(key, [37, 39]) != -1) {
                        if ($(this).position().top != $selectItem.position().top) {
                            return true;
                        }
                        if (key == 37) {
                            //left
                            if ((($(this).position().left - $selectItem.position().left) < 0) && ((diffVal == "") || (Math.abs($(this).position().left - $selectItem.position().left) < diffVal))) {
                                diffVal = Math.abs($(this).position().left - $selectItem.position().left);
                                $target = $(this);
                            }
                        }
                        if (key == 39) {
                            //right
                            if ((($(this).position().left - $selectItem.position().left) > 0) && ((diffVal == "") || (Math.abs($(this).position().left - $selectItem.position().left) < diffVal))) {
                                diffVal = Math.abs($(this).position().left - $selectItem.position().left);
                                $target = $(this);
                            }
                        }
                    }
                    if ($.inArray(key, [38, 40]) != -1) {
                        if ($(this).position().left != $selectItem.position().left) {
                            return true;
                        }
                        if (key == 38) {
                            //up
                            if ((($(this).position().top - $selectItem.position().top) < 0) && ((diffVal == "") || (Math.abs($(this).position().top - $selectItem.position().top) < diffVal))) {
                                diffVal = Math.abs($(this).position().top - $selectItem.position().top);
                                $target = $(this);
                            }
                        }
                        if (key == 40) {
                            //down
                            if ((($(this).position().top - $selectItem.position().top) > 0) && ((diffVal == "") || (Math.abs($(this).position().top - $selectItem.position().top) < diffVal))) {
                                diffVal = Math.abs($(this).position().top - $selectItem.position().top);
                                $target = $(this);
                            }
                        }
                    }
                }
            });
            if ($target) {
          		$target.click();
                if ($selectItem.position().top != $target.position().top) {
                    _$container.parent().scrollTop($target.position().top - 10);
                }
            }
            cancelBubble(e);
        });

        if (_allowPayMent == "Y") {
            //为所有的金额输入框加验证
            var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
            $.each(inputs, function (index, element) {
                $(element).validatebox({
                    //required: true,
                    validType: "lessthanzero['.container .select-item-amt .paymode-amt', '#selfPayAmt']"
                });
            });
        }

        //框选事件
        _$container
        //将焦点定位到容器
        .focus()
        //点选切换选中事件
        .on("click", ".select-item", function (e) {
            if (!$(this).hasClass("selected")) {
	            _selectedPayMode($(this));
            }
            if ($(this).next().hasClass("hidden")) {
                _selectedPayMClick($(this), e);
            } else {
                $(this).next().find(":first-child").focus();
            }
        })
        //支付方式金额框选中事件
        .on("click", ".select-item-amt", function (e) {
	        if ($(e.target).is("input") && $(e.target).numberbox("options").disabled) {
		        //如果输入框被禁用，则跳过
		        return false;
		    }
            _selectedPayMode($(this).prev());
        })
        .on("keydown", ".select-item-amt input", function (e) {
            var key = websys_getKey(e);
            if (key != 13) {
	            return;
	        }
            var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
            var idx = inputs.index(this);  //获取当前输入框的位置索引
            if (idx == inputs.length - 1) {
                //判断是否是最后一个输入框
                idx = -1;
                focusById("btn-ok");
                return;
            }
            var nextIdx = -1;
            for(var i = (idx + 1), len = inputs.length; i < len; i++) {
		        if (!$(inputs[i]).numberbox("options").disabled) {   //如果输入框被禁用，则跳过
                    nextIdx = i;
                    break;
                }
		    }
		    if (nextIdx == -1) {
			    _focusEle();      //无下一个金额输入框时，光标定位到"实付"或"确认"按钮
			    return;
			}
            $(inputs[nextIdx]).focus().select();
            _selectedPayMode($(inputs[nextIdx]).parent().prev());
            e.stopPropagation();
        })
        .on("focus", ".select-item-amt input", function (e) {
            $(this).attr("data-oldval", $(this).val());
            enableById("btn-ok");
            e.stopPropagation();
        })
        .on("blur", ".select-item-amt input", function (e) {
	    	var $this = $(this);
	    	_calcTextBoxPayMAmt($this);
            if (!+$(this).val()) {
                return false;
            }
            //验证金额是否合法
            var payMCode = $this.attr("id").split("z")[1];
            if (!_checkPayM(payMCode)) {
	        	$this.focus();
                return false;
            }
            e.stopPropagation();
        });
    };

    //选中支付方式事件
    var _selectedPayMClick = function ($this, e) {
        enableById("btn-ok");
        var payMCode = $this.attr("id").split("z")[1];
        switch(payMCode) {
	    case "CASH":
	    	setTimeout(function () {
                if ($("#actualMoney").length > 0) {
			    	focusById("actualMoney");
			    }else {
					focusById("btn-ok");
				}
            }, 50);
	    	break;
	    case "QF":
	    	_checkQF(payMCode);
	    	break;
	    case "CPP":
	    	_checkAccM(payMCode);
	    	break;
	    case "ECPP":
	    	_checkAccM(payMCode);
	    	break;
	    default:
	    	setTimeout(function () {
                focusById("btn-ok");
            }, 50);
	    }
    };

    /**
     * 初始化按钮事件
     * @static @private
     */
    var _initButtonEvents = function (selector, callback) {
        //+gongxin 2023-05-17 增加确认按钮的hover事件
        $("#btn-ok").hover(function() {
			$("#btn-ok").focus();
        }, function() {
			$("#btn-ok").blur();
        });
        
        var $linkbuttons = $(selector);
        $linkbuttons.each(function (index, element) {
            $(this).click(function (e) {
                switch ($(this).attr("id")) {
                case "btn-ok":
                    _okClick(e);
                    break;
                case "btn-cancel":
                    _cancelClick(e);
                    break;
                case "btn-reset":
                    _resetClick(e);
                    break;
                default:
                }
            });
        });
    };

    /**
     * 初始化文本框事件
     * @static @private
     */
    var _initTextboxEvents = function () {
	    //实收
	    $("#actualMoney")
	    .keydown(function (e) {
	        var key = websys_getKey(e);
	        if (key == 13) {
		        if (!CV.NeedActualMoney || ($(e.target).val())) {
			        setTimeout(function () {
		                focusById("btn-ok");
		            }, 50);
			    }
	        }
	    })
	    .blur(function (e) {
		    if ($(e.target).val()) {
			    return _validActualMoney();
			}
	    });
	};
	
	var _validActualMoney = function() {
		var actualMoney = $("#actualMoney").val();
		if (!CV.NeedActualMoney && !actualMoney) {
			return true;
		}
     	var roundCASHAmt = $("#roundCASHAmt").val();
   		var change = Number(actualMoney).sub(roundCASHAmt).toFixed(2);
   		if (change < 0) {
            $.messager.popover({msg: "实收金额输入错误", type: "info"});
            $("#actualMoney").focus().select();
        } else {
	        $("#backChange").val(change);
	    }
        return !(change < 0);
	};
	
	//配置需要填实付且有现金支付时，默认到"实付"框，否则默认到"确认"按钮
	var _focusEle = function() {
		if (CV.NeedActualMoney && (_getCASHPayAmt() != 0)) {
	        $("#actualMoney").focus().select();
            return;
	    }
	    $("#btn-ok").focus();
	};
	
    //附加数据弹出对话框
    var _showAddDataDlg = function ($this) {
	    return new Promise(function (resolve, reject) {
			var payMDR = $this.attr("data").split("^")[0];
	        var opt = {
	         	title: '附加数据',
	        	payMode: payMDR,
	        	patientId: _patientId
	        };
	        var additionObj = new dhcbill.checkout.AdditionData(opt);
	        additionObj.show(function (code, obj) {
	            if (code) {
	                $this.data("additionalData", obj);
	                return resolve();
	            }
	            reject();
	        });
		});
    };
    
    //给支付方式按钮和金额输入框添加disabled属性
    var _disablePaymBtn = function() {
	    //disable所有支付方式按钮
	    _$container.find(".select-item[data]").each(function (index) {
			$(this).prop("disabled", true);
        });
		//disable所有金额输入框
      	_$container.find(".select-item-amt .paymode-amt").each(function (index) {
			$(this).prop("disabled", true);
        });
	};
	
	//给支付方式按钮和金额输入框移除disabled属性
	var _enablePaymBtn = function() {
		//enable所有支付方式按钮
		_$container.find(".select-item[data]").each(function (index) {
			$(this).removeProp("disabled");
        });
        //enable除原来在csp中被disable的numberbox金额输入框
        _$container.find(".select-item-amt .paymode-amt").each(function (index) {
	        if ($(this).numberbox("options").disabled) {
		        return true;
		    }
			$(this).removeProp("disabled");
        });
	};
	
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var bool = true;
			$(".validatebox-text").each(function(index, item) {
				if (!$(this).validatebox("isValid")) {
					bool = false;
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			resolve();
		});
	};
	
    //确认按钮事件
    var _okClick = function (e) {
        if ($("#btn-ok").linkbutton("options").disabled) {
            return;
        }
		disableById("btn-ok");
		_disablePaymBtn();
		
		var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_paym.setPaymentAry)
			.then(_paym.validate)
			.then(_paym.required)
			.then(_paym.paySrv)
			.then(_paym.info)
			.then(function(paymStr) {
				_ok(paymStr);
			}, function () {
				enableById("btn-ok");
				_enablePaymBtn();
			});
    };
	
	//支付成功后返回主界面
	var _ok = function (paymStr) {
		var rtnValue = {
	        code: true,
          	message: paymStr
    	};
        websys_showModal("options").callbackFunc(rtnValue);
        websys_showModal("close");
	};
	
    //取消按钮事件
    var _cancelClick = function (e) {
        var rtnValue = {
		    code: false,
		    message: "取消"
		};
        websys_showModal("options").callbackFunc(rtnValue);
        websys_showModal("close");
    };

    //重置按钮事件
    var _resetClick = function (e) {
        location = location;
    };

    //校验支付方式
    var _checkPayM = function (payMCode) {
        if (!_checkAllPayMAmtSum()) {
            //_checkPayM方法在onblur事件调用，用confirm会有死循环，先改为提示
            $.messager.popover({msg: "支付方式金额合计与患者自费金额不等，请重置", type: "info"});
            return false;
        }

        if (!_checkRoundAmt()) {
            $.messager.popover({msg: "现金分币误差金额不平，请重置", type: "info"});
            return false;
        }

        if (!_checkAccM(payMCode)) {
            return false;
        }
        
        if (!_checkQF(payMCode)) {
            return false;
        }
        
        return true;
    };
	
    //预交金充值
    var _accPayDeposit = function (payMAmt) {
	    return new Promise(function (resolve, reject) {
		    var succPay = false;
			var url = "dhcbill.opbill.accdep.pay.csp?WinFrom=opcharge&AccMRowID=" + _accMRowId;
	        url += "&CardNo=" + _cardNo + "&CardTypeRowId=" + _cardTypeId + "&PatientID=" + _patientId;
	        url += "&PatFactPaySum=" + payMAmt;
	        websys_showModal({
	            url: url,
	            title: '充值',
	            iconCls: 'icon-w-inv',
	            width: '85%',
	            height: '85%',
	            callbackFunc: function () {
		            succPay = true;
		            _accMLeft = getPropValById("DHC_AccManager", _accMRowId, "AccM_Balance");
		            setValueById("accMLeft", _accMLeft);
	            },
	            onClose: function () {
					return succPay ? resolve() : reject();
		        }
	        });
		});
    };
    
  	//卡消费时校验卡
	var _validCard = function(payMAmt) {
		var _checkMCFPay = function() {
			return new Promise(function (resolve, reject) {
			    if (!_cardTypeId || !_cardTypeId) {
			        return resolve(0 + "^");   //无卡时按成功返回
			    }
			    DHCACC_CheckMCFPay(payMAmt, _cardNo, _episodeIdStr, _cardTypeId, "", resolve);
			});
		};
		return new Promise(function (resolve, reject) {
			_checkMCFPay().then(function (rtnValue) {
		        var myAry = rtnValue.split("^");
		        if (myAry[0] == -200) {
		       		$.messager.popover({msg: "卡无效", type: "info"});
			        return reject();
			    }
			    if (myAry[0] == -204) {
			        $.messager.popover({msg: "密码验证失败", type: "info"});
			        return reject();
			    }
			    if (myAry[0] == -206) {
			        $.messager.popover({msg: "卡号不一致，请插入原卡", type: "info"});
			        return reject();
			    }
			  	if (myAry[1] != _accMRowId) {
			        $.messager.popover({msg: "卡校验获取的账户和传入的账户不符", type: "info"});
			        return reject();
			    }
		        resolve();
			});
		});
	};
	
    //校验门诊预交金账户和留观账户
	var _checkAccM = function (payMCode) {
		if ($.inArray(payMCode, ["CPP", "ECPP"]) == -1) {
			return true;
		}
        var payMAmt =  _isManyPayment ? $("#txtPayMz" + payMCode).val() : _payAmt;
        if (payMAmt == 0) {
            return true;   //金额为0时不用校验
        }
        var payMDesc = $("#btnPayMz" + payMCode + " .paym-btn-text").text();
        if (!_accMRowId) {
	        $.messager.popover({msg: ($g("无有效账户，不能使用") + payMDesc + $g("支付")), type: "info"});
	        return false;
	    }
	    if (+_accMLeft >= +payMAmt) {
		    return true;
		}
	    if (_reloadFlag) {
            $.messager.popover({msg: ($g("余额不足，请先充值") + " <font color=\"red\">" + Number(payMAmt).sub(_accMLeft).toFixed(2) + "</font> " + $g("元")), type: "info"});
            return false;
        }
		return true;
	};
	
	//留观押金充值
    var _emPayDeposit = function (payMAmt) {
	    return new Promise(function (resolve, reject) {
		    var succPay = false;
			var url = "dhcbill.opbill.epdep.pay.csp?WinFrom=opcharge&EpisodeID=" + _episodeIdStr;
	        url += "&CardNo=" + _cardNo + "&CardTypeRowId=" + _cardTypeId + "&PatientID=" + _patientId;
	        url += "&PatFactPaySum=" + payMAmt;
	        websys_showModal({
	            url: url,
	            title: '充值',
	            iconCls: 'icon-w-inv',
	            width: '85%',
	            height: '85%',
	            callbackFunc: function () {
		            succPay = true;
		            _accMLeft = getPropValById("DHC_EPManager", _accMRowId, "EPM_Balance");
		            setValueById("accMLeft", _accMLeft);
	            },
	            onClose: function () {
		            return succPay ? resolve() : reject();
		        }
	        });
		});
    };
    
    //校验欠费支付方式
    var _checkQF = function (payMCode) {
        var bool = true;
        if (payMCode != "QF") {
            return bool;
        }
        var payMAmt = _isManyPayment ? $("#txtPayMzQF").val() : _payAmt;
        if (payMAmt == 0) {
            return bool; //金额为0时不用校验
        }
        if (!CV.WarrPay) {
            return bool;
        }
        var rtn = $.m({ClassName: "web.DHCOPQFPat", MethodName: "CheckWarBal", admStr: _episodeIdStr, payAmt: payMAmt, sFlag: 0}, false);
        if (rtn == 0) {
	        return bool;
	    }
	    var myAry = rtn.split("^");
	    $.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
	    disableById("btn-ok");
        return false;
    };
	
    var _paym = {
	    setPaymentAry: function() {
		    return new Promise(function (resolve, reject) {
				_$paymentAry = [];     //初始化
			    if (!_$container) {
					return reject();
				}
				if (_isManyPayment) {
	            	//多种支付方式
	            	var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
	                $.each(inputs, function (index, element) {
	                    var payMAmt = +$(element).val();
	                    if (payMAmt == 0) {
	                        return true;
	                    }
                        var $paymode = $(element).parent().prev();
                        var payMData = $paymode.attr("data");
                        var payMDataAry = payMData.split("^");
	                    var payMCode = payMDataAry[1];
	                    if (_isCASHChgBiz(payMCode)) {
		                    payMAmt = _getRoundCASHAmt();
		                }
                        _$paymentAry.push([$paymode, payMAmt]);
	                });
	                return resolve();
				}
				//单种支付方式
				var $paymode = _$container.find(".selected");
                if ($paymode.length == 0) {
	                return reject();
	            }
				var payMData = $paymode.attr("data");
	            var payMDataAry = payMData.split("^");
                var payMCode = payMDataAry[1];
	            var payMAmt = (_isCASHChgBiz(payMCode)) ? _getRoundCASHAmt() : _payAmt;
	            _$paymentAry.push([$paymode, payMAmt]);
	            return resolve();
			});
		},
		//验证支付方式
	    validate: function() {
		    return new Promise(function (resolve, reject) {
			    //将需要卡消费的支付方式装载进数组
			    var _setCardPayMAry = function() {
					if (_$paymentAry.length == 0) {
						return reject();
					}
					var bool = true;
					$.each(_$paymentAry, function(index, item) {
						var $element = item[0];
						var payMAmt = item[1];
	                    if (!(payMAmt > 0)) {
		                    return true;
		                }
						var payMData = $element.attr("data");
						var payMDataAry = payMData.split("^");
	                    var payMCode = payMDataAry[1];
	                    if (!_checkPayM(payMCode)) {
	                        bool = false;
	                        return false;
	                    }
	                    if ((payMCode == "CASH") && (!_validActualMoney())) {
	                     	bool = false;
	                        return false;
	                    }
	                    if (_needConsume(payMCode)) {
	                        var myObj = {};
		                    myObj[payMCode] = payMAmt;
		                    cardPayMAry.push(myObj);      //将需要卡消费的支付方式装载进数组
		                }
					});
					if (!bool) {
						return reject();
					}
			    };
			    
				var _needConsume = function (payMCode) {
			        return ($.inArray(payMCode, ["CPP", "ECPP"]) != -1);
				};
				
				var _shift = function() {
					//cardPayMAry.length == 0时表示全部交易成功
					if (cardPayMAry.length == 0) {
						return resolve();
					}
					var obj = cardPayMAry.shift();   //删除第一项，获取数组第一项的值
					$.each(Object.keys(obj), function(index, prop) {
						_validAccMLeft(prop, obj[prop]).then(null, function () {
					        reject();
					    });
					});
				};

				var _validAccMLeft = function(payMCode, payMAmt) {
					return new Promise(function (resolve, reject) {
						if (+_accMLeft >= +payMAmt) {
							if (payMCode == "CPP") {
								return _validCard(payMAmt).then(function () {
							        _shift();
							        resolve();
							    }, function () {
							        reject();
							    });
						    }
							return resolve();
						}
						
						if (payMCode == "ECPP") {
							return _payDeposit(payMCode, payMAmt).then(function () {
						        _shift();
						        resolve();
						    }, function () {
						        reject();
						    });
						}
						
						return _validCard(payMAmt).then(function () {
					   		_payDeposit(payMCode, payMAmt).then(function () {
						    	_shift();
						    	resolve();
						    }, function () {
						        reject();
						    });
					    }, function () {
					        reject();
					    });
				    });
	            };
	            
				var _payDeposit = function (payMCode, payMAmt) {
					return new Promise(function (resolve, reject) {
						var msg = $g("余额不足，请先充值") + " <font color=\"red\">" + Number(payMAmt).sub(_accMLeft).toFixed(2) + "</font> " + $g("元");
						if (_reloadFlag) {
				            $.messager.popover({msg: msg, type: "info"});
				            return reject();
				        }
						msg += "，<br>" + $g("是否充值？");
						$.messager.confirm("确认", msg, function (r) {
				            if (!r) {
					            return reject();
				            }
				            if (payMCode == "ECPP") {
								return _emPayDeposit(payMAmt).then(function () {
							        resolve();
							    }, function () {
							        reject();
							    });
							}
							return _accPayDeposit(payMAmt).then(function () {
								resolve();
							}, function () {
								reject();
							});
				        });
			        });
				};

				var cardPayMAry = [];     //需要卡消费的支付方式数组
				_setCardPayMAry();
				_shift();            //使用队列"先进先出"方法
			});
		},
		//验证附加信息必填项
		required: function() {
			return new Promise(function (resolve, reject) {
				//将需要附加信息的支付方式装载进数组
			    var _setReqPayMAry = function() {
					if (_$paymentAry.length == 0) {
						return reject();
					}
					$.each(_$paymentAry, function(index, item) {
						var $element = item[0];
						var payMData = $element.attr("data");
						var payMDataAry = payMData.split("^");
			          	var payMDR = payMDataAry[0];
			          	var requiredFlag = payMDataAry[3];
	                    if (requiredFlag != "Y") {
		                    return true;
		                }
                        if (_needAddition($element, payMDR)) {
		                    $payMAry.push($element);
		                }
					});
				};
	            
	            var _needAddition = function ($paymode, payMDR) {
		            var bool = false;
	             	var addiObj = $paymode.data("additionalData") || {};					
	             	var payMAddiStr = _getAdditionalData(payMDR);
                    $.each(payMAddiStr.split("^"), function (index, item) {
                        var myAry = item.split("!");
                      	var code = myAry[0];
                      	var isRequired = myAry[2];
                        if ((isRequired == "Y") && (!addiObj[code])) {
	                        bool = true;
	                        return false;
                        }
                    });
                    return bool;
				};
				
	            var _shift = function() {
		            if ($payMAry.length == 0) {
			            return resolve();
			        }
					var obj = $payMAry.shift();   //删除第一项，获取数组第一项的值
					_show(obj);
				};
                
                var _show = function($obj) {
					setTimeout(function() {
						_showAddDataDlg($obj).then(function() {
	                    	_shift();
	                    }, function () {
					        reject();
					    });
					}, 500);
	            };
	            
	            var $payMAry = [];   //有必要条件的支付方式数组
				_setReqPayMAry();
				_shift();            //使用队列"先进先出"方法
			});
		},
		//第三方支付
	    paySrv: function() {
		    return new Promise(function (resolve, reject) {
				//将需要调用第三方支付的支付方式装载进数组
			    var _setSrvPayMAry = function() {
				    if (_$paymentAry.length == 0) {
						return reject();
					}
                    $.each(_$paymentAry, function(index, item) {
	                    var $element = item[0];
	                    var payMAmt = item[1];
	                    if (!(payMAmt > 0)) {
		                    return true;
		                }
		            	var payMData = $element.attr("data");
						var payMDataAry = payMData.split("^");
	                    var payMDR = payMDataAry[0];
	                    if (_needPay(payMDR)) {
		                    var myObj = {};
		                    myObj[payMDR] = payMAmt;
			            	payMAry.push(myObj);
		                }
					});
				};
				
				var _needPay = function (payMode) {
					var rtn = $.m({ClassName: "DHCBILL.Common.DHCBILLCommon", MethodName: "GetCallModeByPayMode", PayMode: payMode}, false);
					var myAry = rtn.split("^");
					//需要调用第三方交易时，若_payMConETP[payMode]存在则不再调用，不存在则调用
					return ((myAry[0] > 0) && !_payMConETP[payMode]);
				};
				
				var _shift = function() {
					if (payMAry.length == 0) {
						//payMAry.length == 0时表示全部交易成功，则返回主界面
						return resolve();
					}
					var obj = payMAry[0];   //每次取数组第1项
					$.each(Object.keys(obj), function(index, prop) {
						_pay(prop, obj[prop]);
					});
				};
				
				var _pay = function(payMode, payMAmt) {
					var adm = _episodeIdStr.replace(/\^/g,"|");
					var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			        expStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + _patientId + "^" + adm;
			        expStr += "^" + _prtRowIdStr.replace(/\^/g, "!") + "^^C";
			       	PayService(_bizType, payMode, payMAmt, expStr, _callback);
				};
				
				var _callback = function(rtnValue) {
					_$container.focus();      //+2022-09-01 ZhYW 将焦点定位到容器
					if (rtnValue.ResultCode == 0) {
						_payMConETP[rtnValue.PayMode] = rtnValue.ETPRowID;    //将交易流水表RowId放入_payMConETP
						payMAry.shift();   //成功时删除第一项
						setTimeout(function() {
							_shift();
						}, (1000 * ((payMAry.length > 0) ? 1 : 0)));
						return;
					}
					$.messager.popover({msg: rtnValue.ResultMsg, type: "error"});
					reject();
				};
				
				var payMAry = [];   //需要调用第三方支付的支付方式数组
				_setSrvPayMAry();
				_shift();          //使用队列"先进先出"方法调用第三方支付接口
			});
		},
		//生成支付方式串
		info: function() {
			return new Promise(function (resolve, reject) {
				var payMAry = [];
				if (_$paymentAry.length == 0) {
					return reject();
				}
				$.each(_$paymentAry, function(index, item) {
					var $element = item[0];
					var payMAmt = item[1];
					var payMData = $element.attr("data");
					var payMDataAry = payMData.split("^");
					var payMDR = payMDataAry[0];
                    var payMCode = payMDataAry[1];
                    var addiObj = $element.data("additionalData") || {};
					var myPayCard = addiObj.PayCard || "";  //支付卡号，对院内账号支付时传账号rowid
					var myPatUnitDR = addiObj.HCP || "";
					var myBankDR = addiObj.Bank || "";
					var myCheckNo = addiObj.CheckNO || "";
					var myChequeDate = addiObj.CheckDate || "";
					var myPayAccNo = addiObj.PayAccNO || "";
					var invRoundErrDetails = "";
					var actualMoney = "";
					var backChange = "";
					if (_isCASHChgBiz(payMCode)) {
						invRoundErrDetails = $("#roundErrAmt").attr("data");
						actualMoney = $("#actualMoney").val();  //实收
						backChange = $("#backChange").val();    //找零
					}
					var ETPRowID = _payMConETP[payMDR] || "";   //第三方支付交易表RowID
					//+2022-09-15 ZhYW 根据订单表RowID获取第三方支付方式ID
					if (ETPRowID > 0) {
						payMDR = GetETPPayModeID(ETPRowID) || payMDR;    //DHCBillPayService.js
					}
					var tmpStr = payMDR + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard;
					tmpStr += "^" + myPatUnitDR + "^" + myChequeDate + "^" + myPayAccNo;
					tmpStr += "^" + payMAmt + "^" + invRoundErrDetails + "^" + actualMoney;
					tmpStr += "^" + backChange + "^" + ETPRowID;
					tmpStr = tmpStr.replace(/undefined/g, "");    //替换所有的undefined
					payMAry.push(tmpStr);
				});
		        return resolve(payMAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2));
			});
		}
	};

    /**
     * 初始化界面
     */
    dhcbill.checkout.CheckOut.prototype.initPanel = function () {
        _prtRowIdStr = this.prtRowIdStr;
        _accMRowId = this.accMRowId;
        _accMLeft = this.accMLeft;
        _allowPayMent = this.allowPayMent;
        _episodeIdStr = this.episodeIdStr;
      	_typeFlag = this.typeFlag;
        _patientId = this.patientId;
        _cardNo = this.cardNo;
        _cardTypeId = this.cardTypeId;
        _patShareAmt = this.patShareAmt;
        _payAmt = this.payAmt;
        _reloadFlag = this.reloadFlag;
		_bizType = this.bizType;

        _initSelectBox(".container");

        _initButtonEvents(".btn-container .l-btn");
        
        _initTextboxEvents();
        
      	_initAllowPaymentBtn();
        
        _initDefaultFocus();
    };
})();

$(function () {
    var checkOutObj = new dhcbill.checkout.CheckOut(CV.Args);
    checkOutObj.initPanel();
});

$(window).load(function () {
    $(".msg-popover").removeClass("hidden");
});

/**
 * 验证扩展，先放这，以后要放到统一方法中
 */
$.extend($.fn.validatebox.defaults.rules, {
    lessthanzero: {
        validator: function (value, param) {
            var balance = 0;
            var sum = Array.from($(param[0])).reduce(function (total, element) {
	            if ($(element).hasClass("default-paymode-amt")) {
                    balance = +$(element).val();
                }
				return Number(total).add(+$(element).val()).toFixed(2);
		    }, 0);
            var selfPayAmt = +$(param[1]).val();
            var temp = 0;
            if (+balance < +value) {
                temp = Number(sum).sub(balance).toFixed(2);
            } else {
                temp = Number(sum).sub(value).toFixed(2);
            }
            return !(temp > selfPayAmt);
        },
        message: $g('支付方式合计金额不能大于自费金额')
    },
    checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 1000000;
		},
		message: $g("金额输入过大")
	}
});