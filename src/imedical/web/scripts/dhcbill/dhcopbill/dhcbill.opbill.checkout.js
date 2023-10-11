/**
 * @file dhcbill.opbill.checkout.js
 * 门诊收费收银台功能
 * @author Lid
 * @date 2020-05-29
 */

/** @class
 * 定义命名空间
 * @abstract
 */
var dhcbill = window.dhcbill || {};

/** @class
 * 定义门诊收费命名空间
 * @abstract
 */
dhcbill.opbill = window.dhcbill.opbill || {};

/** @class
 * 定义收银台名空间
 * @abstract
 */
dhcbill.opbill.checkout = window.dhcbill.opbill.checkout || {};

/** @class
 * 收银台类
 */
dhcbill.opbill.checkout.CheckOut = function (args) {
    args = args || {};
    this.allowPayMent = args.allowPayMent || "";
    this.prtRowIdStr = args.prtRowIdStr || "";
    this.insTypeId = args.insTypeId || "";
    this.typeFlag = args.typeFlag || "";
    this.accMRowId = args.accMRowId || "";
    this.accMLeft = args.accMLeft || "";
    this.episodeIdStr = args.episodeIdStr || "";
    this.patientId = args.patientId || "";
    this.cardNo = args.cardNo || "";
    this.cardTypeId = args.cardTypeId || "";
    this.reloadFlag = args.reloadFlag || "";
};

//构建一个块级作用域
(function () {

    //私有成员属性
    var _allowPayMent = "N";
    var _isManyPayment = false; //是否开启多种支付
    var _accMRowId = "";
    var _prtRowIdStr = "";
    var _episodeIdStr = "";
    var _patientId = "";
    var _cardNo = "";
    var _cardTypeId = "";
    var _reloadFlag = "";
	var _payMConETP = {}          //存放第三方交易表RowId
	
    /**
     * 支付方式容器对象
     * @static @private
     */
    var _$container = null;

    //选中支付方式
    var _selectedPayMode = function ($this) {
        _$container.find('.select-item').removeClass('selected');
        $this.addClass('selected');
    }

    //初始化发票金额信息
    var _initInvAmtData = function () {
        var invAmtInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: _prtRowIdStr}, false);
        var aryAmt = invAmtInfo.split("^");
        setValueById("invAmt", aryAmt[0]);
        setValueById("discAmt", aryAmt[1]);
        setValueById("payorAmt", aryAmt[2]);
        setValueById("patShareAmt", aryAmt[3]);
        setValueById("insuAmt", aryAmt[4]);
        var selfPayAmt = Number(aryAmt[3]).sub(aryAmt[4]).toFixed(2); //自费支付额
        setValueById("selfPayAmt", selfPayAmt);

        _calcRoundErr(selfPayAmt);
    }
	
	var _getAdditionalData = function (paymId) {
        return $.m({ClassName: "web.UDHCOPGSConfig", MethodName: "GetAdditionalData", payMode: paymId, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
    }
    
    //计算现金的分币误差
    var _calcRoundErrCASH = function () {
        var cashAmt = _getCASHPayAmt();
        _calcRoundErr(cashAmt);
    }

    //计算分币误差
    var _calcRoundErr = function (cashAmt) {
        var cashPayAmtRoundInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetManyInvRoundErrAmt", prtRowIdStr: _prtRowIdStr, amt: cashAmt}, false);
        var cashRoundSum = cashPayAmtRoundInfo.split("^")[0];
        setValueById("roundCASHAmt", cashRoundSum);
        setValueById("roundErrAmt", numCompute(cashRoundSum, cashAmt, "-"));
        $("#roundErrAmt").attr("data", cashPayAmtRoundInfo.split("^")[1]);
    }

    //判断是否是默认支付方式金额输入框
    var _isDefaultPayMAmtTxtbox = function ($this) {
        return $this.hasClass('default-paymode-amt');
    }

    //获取默认支付方式文本框当前金额
    var _getDefaultPayMAmt = function () {
        return +$("#" + _getDefaultPayMId()).val();  //考虑误差金额
    }

    //获取默认支付方式文本框id
    var _getDefaultPayMId = function () {
        var $defaultPayMAmt = _$container.find(".select-item-amt .default-paymode-amt");
        return $defaultPayMAmt.attr('id');
    }

    //获取默认支付支付方式代码
    var _getDefaultPayMCode = function () {
        var $defaultPayM = _$container.find(".select-item-amt .default-paymode-amt");
        return $defaultPayM.attr('id').split('z')[1];
    }

    //设置默认支付方式金额
    var _setDefaultPayMAmt = function (val) {
        setValueById(_getDefaultPayMId(), val);
    }

    //获取支付方式列表中现金支付金额
    var _getCASHPayAmt = function () {
        return +$("#txtPayMzCASH").val();
    }

    //获取自费金额
    var _getSelfPayAmt = function () {
        return +$("#selfPayAmt").val();
    }

    //获取分币误差金额
    var _getRoundErrAmt = function () {
        return +$("#roundErrAmt").val();
    }

    //获取现金舍入金额
    var _getRoundCASHAmt = function () {
        return +$("#roundCASHAmt").val();
    }

    //获取获取支付方式金额合计
    var _getAllPayMAmtSum = function () {
        var sum = 0;
        var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
        $.each(inputs, function (index, element) {
            sum = numCompute(sum, $(element).val(), "+");
        });
        return sum;
    }

    //校验支付方式合计金额是否正确
    var _checkAllPayMAmtSum = function () {
        if (_isManyPayment) {
            var sum = _getAllPayMAmtSum();
            var selfPayAmt = _getSelfPayAmt();
            return +sum == +selfPayAmt;
        }
		return true; //单支付方式模式不用校验
    }

    //校验分币误差金额是否正确
    var _checkRoundAmt = function () {
        var roundErrAmt = _getRoundErrAmt();
        var selfPayAmt = _getSelfPayAmt();
        var roundCASHAmt = _getRoundCASHAmt();
        if (_isManyPayment) {
            var cashPayAmt = _getCASHPayAmt();
            return numCompute(cashPayAmt, roundErrAmt, "+") == +roundCASHAmt;
        }
		return numCompute(selfPayAmt, roundErrAmt, "+") == +roundCASHAmt;
    }

    //计算支付方式金额框的
    //算法规则：
    //		1.默认加载时，自费金额在默认支付方式上
    //		2.收费员填写非默认支付方式金额后，自动扣减默认值支付方式金额，如果默认支付金额小于0，则提示异常。
    //算法存在的问题
    //		1.如果收费员修改了默认支付方式的金额，将导致算法异常。
    var _calcTextBoxPayMAmt = function ($this, e) {
        var oldVal = $this.attr('data-oldval') ? +$this.attr('data-oldval') : 0;
        var newVal = $this.val() ? +$this.val() : 0;
        var changeAmt = numCompute(newVal, oldVal, "-");
        var defaultPayMAmt = _getDefaultPayMAmt();   //默认支付方式当前金额
        var balance = numCompute(defaultPayMAmt, changeAmt, "-");
        if (balance < 0) {
            if (oldVal == 0) {
                oldVal = "";
            }
            $this.attr("data-oldval", oldVal);
            $this.val(oldVal);
            $this.validatebox("validate");
            return false;
        }
        _setDefaultPayMAmt(balance);
        if ($this.hasClass("CASH-class")) {
            _calcRoundErr(newVal);
            return;
        }
        _calcRoundErrCASH();
    }

    /**
     * 初始化多种支付方式按钮
     * @static @private
     */
    var _initAllowPaymentBtn = function () {
        $HUI.switchbox('#switchManyPayM', {
            onText: '多种支付',
            offText: '单种支付',
            size: 'small',
            checked: false,
            onSwitchChange: function (e, obj) {
	         	_isManyPayment = obj.value;
                _$container.find(".select-item-amt").toggleClass("hidden");
                var defaultPayMCode = _getDefaultPayMCode();
                var selfPayAmt = numCompute(getValueById("patShareAmt"), getValueById("insuAmt"), "-");
                var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
                if (_isManyPayment) {
                    //开启多种支付时，设置默认支付的金额
                    _setDefaultPayMAmt(selfPayAmt);
                    _calcRoundErrCASH();
                    //定位光标到第一个非默认支付金额框
                    $.each(inputs, function (index, element) {
                        if (!$(element).hasClass("default-paymode-amt")) {
                            $(element).get(0).focus();
                            _selectedPayMode($(element).parent().prev());
                            return false;
                        }
                    });
                } else {
	            	inputs.numberbox("clear");
	                _selectedPayMode($(".default-paymode"));
                    _calcRoundErr(selfPayAmt);
                }
            }
        });
    }

    /**
     * 初始化支付方式列表选择事件
     * @param {String} 支付列表容器选择器
     * @param {String} 回掉事件，暂时不用
     * @static @private
     */
    var _initSelectBox = function (selector, callback) {
        _$container = $(selector);

        //绑定快捷键
        $(document).keydown(function (e) {
            var key = websys_getKey(e);
            //阻止默认事件
            prevDefHotKey(e);
            
			//页面设置的快捷键
            var hotKey = "";
            $.each(_$container.find(".select-item[data]"), function (index, element) {
                hotKey = $(this).attr("data").split("^")[6];
                if (key == KEYCODE[hotKey]) {
                    $(this).click();
                }
            });
            
			cancelBubble(e);
        });

        if (_allowPayMent == "Y") {
            //为所有的金额输入框加验证
            var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
            $.each(inputs, function (index, element) {
                $(element).validatebox({
                    //required: true,
                    validType: "lessthanzero['.container .select-item-amt .paymode-amt', '#selfPayAmt']"
                });
            });
        };

        //框选事件
        _$container
        //将焦点定位到容器
        .focus()
        //点选切换选中事件
        .on('click', '.select-item', function (e) {
            if (!$(this).hasClass('selected')) {
	            _selectedPayMode($(this));
            }
            if ($(this).next().hasClass('hidden')) {
                _selectedPayMClick($(this), e);
            } else {
                $(this).next().find(":first-child").focus();
            }
        })
        //点选全选全不选,预留，以后供多种支付方式使用
        .on('click', '.toggle-all-btn', function (e) {
            if ($(this).attr('data-all')) {
                $(this).removeAttr('data-all');
                _$container.find('.select-item').removeClass('selected');
            } else {
                $(this).attr('data-all', 1);
                _$container.find('.select-item').addClass('selected');
            }
        })
        //支付方式金额框选中事件
        .on('click', '.select-item-amt', function (e) {
            _selectedPayMode($(this).prev());
        })
        .on('keydown', '.select-item-amt input', function (e) {
            var key = websys_getKey(e);
            if (key == 13) {
                if ($(e.target).is('input')) {
                    var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
                    var idx = inputs.index(this);  //获取当前输入框的位置索引
                    var step = 1;
                    if (idx == inputs.length - 1) {
                        //判断是否是最后一个输入框
                        idx = -1;
                        focusById("btn-ok");
                        return;
                    }
                    if (_isDefaultPayMAmtTxtbox($(inputs[idx + step]))) {    //判断是否是默认支付方式输入框，如果是就跳过
                        step++;
                    }
                    $(inputs[idx + step]).focus().select();
                    _selectedPayMode($(inputs[idx + step]).parent().prev());
                    e.stopPropagation();
                }
            }
        })
        .on('focus', '.select-item-amt input', function (e) {
            if ($(e.target).is('input')) {
                $(this).attr('data-oldval', $(this).val());
                enableById('btn-ok');
                e.stopPropagation();
            }
        })
        .on('blur', '.select-item-amt input', function (e) {
            if ($(e.target).is('input')) {
                _calcTextBoxPayMAmt($(this), e);
                if (!+$(this).val()) {
	                return false;
	            }
                //验证金额是否合法
                var thisId = $(this).attr('id');
                var payMCode = thisId.split("z")[1];
                var bool = _checkPayM(payMCode);
                if (!bool) {
                    focusById(thisId);
                    return false;
                }
                e.stopPropagation();
            }
        })
        .on('click', '.select-item .paym-additionaldata-flag', function (e) {
            if ($(e.target).is('span')) {
                var $payMode = $(this).parent();
                _selectedPayMode($payMode);
                _showAddDataDlg($payMode);
            }
            e.stopPropagation();
        });
    };

    //选中支付方式
    var _selectedPayMClick = function ($this, e) {
        enableById('btn-ok');
        var payMCode = $this.attr('id').split('z')[1];
        switch(payMCode) {
	    case "CASH":
	    	setTimeout(function () {
                focusById("actualMoney");
            }, 100);
	    	break;
	    case "QF":
	    	_checkQF(payMCode);
	    	break;
	    case "CPP":
	    	_checkCPP(payMCode);
	    	break;
	    default:
	    	setTimeout(function () {
                focusById("btn-ok");
            }, 100);
	    }
    }

    /**
     * 初始化按钮事件
     * @static @private
     */
    var _initButtonEvents = function (selector, callback) {
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
		            }, 100);
			    }
	        }
	    })
	    .blur(function (e) {
		    if ($(e.target).val()) {
			    return _validActualMoney();
			}
	    });
	}
	
	var _validActualMoney = function() {
		var actualMoney = $("#actualMoney").val();
		if (!CV.NeedActualMoney && !actualMoney) {
			return true;
		}
     	var roundCASHAmt = $("#roundCASHAmt").val();
   		var change = numCompute(actualMoney, roundCASHAmt, "-");
   		if (change < 0) {
            $.messager.popover({msg: "实收金额输入错误", type: "info"});
            $("#actualMoney").focus().select();
        } else {
	        $("#backChange").val(change);
	    }
        return !(change < 0);
	}
	
    //附加数据弹出对话框
    var _showAddDataDlg = function ($this) {
        var payMDr = $this.attr("data").split('^')[0];
        var opt = {
         	title: '附加数据',
        	payMode: payMDr,
        	patientId: _patientId
        };
        var additionObj = new dhcbill.opbill.checkout.AdditionData(opt);
        additionObj.show(function (code, obj) {
            if (code) {
                $this.data("additionalData", obj);
            }
        });
    }
    
    //确认按钮事件
    var _okClick = function (e) {
        if ($("#btn-ok").linkbutton("options").disabled) {
            return;
        }

        if (!_paym.validate() || !_paym.required()) {
            return;
        }

        //调用第三方接口，_ok()在此方法中调用
    	_paySrv.check();
    }
	
	//支付成功后返回主界面
	var _ok = function () {
		var paymStr = _paym.info();
		if (paymStr == "") {
            $.messager.popover({msg: "获取支付方式数据错误", type: "error"});
            return;
        }
        var rtnValue = {
	        code: true,
          	message: paymStr
    	};
        websys_showModal("options").callbackFunc(rtnValue);
        websys_showModal("close");
	}
	
    //取消按钮事件
    var _cancelClick = function (e) {
        var rtnValue = {
		    code: false,
		    message: "取消"
		};
        websys_showModal("options").callbackFunc(rtnValue);
        websys_showModal("close");
    }

    //重置按钮事件
    var _resetClick = function (e) {
        location = location;
    }

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

        if (!_checkCPP(payMCode)) {
            return false;
        }
        
        if (!_checkQF(payMCode)) {
            return false;
        }

        return true;
    }

    //预交金充值
    var _accPayDeposit = function (payMAmt) {
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
                if (_isManyPayment) {
                    //多种支付方式时，光标定位到预交金支付的下一个支付方式
                } else {
                    //单支付方式，触发确定按钮单击事件
                    setTimeout(function () {
                        $("#btn-ok").click();
                    }, 50);
                }
            }
        });
    }

    //校验预交金支付方式
    var _checkCPP = function (payMCode) {
        if (payMCode != "CPP") {
            return true;
        }
        var payMAmt =  _isManyPayment ? $('#txtPayMzCPP').val() : _getSelfPayAmt();
        if (payMAmt == 0) {
            return true;  //金额为0时不用校验
        }
        if (!_accMRowId) {
	        $.messager.popover({msg: "无有效账户，不能使用预交金支付或退款", type: "info"});
	        return false;
	    }
	    if (+_accMLeft >= +payMAmt) {
		    return true;
		}
	   var msg = "余额不足，请先充值 <font color='red'>" + numCompute(payMAmt, accMLeft, "-") + "</font> 元";
	    if (_reloadFlag) {
            $.messager.popover({msg: msg, type: "info"});
            return false;
        }
        msg += "<br>是否充值？";
        $.messager.confirm("确认", msg, function (r) {
            if (!r) {
                return;
            }
            _accPayDeposit(payMAmt);
        });
        return false;
    }

    //校验欠费支付方式
    var _checkQF = function (payMCode) {
        var bool = true;
        if (payMCode != "QF") {
            return bool;
        }
        var payMAmt = _isManyPayment ? $('#txtPayMzQF').val() : _getSelfPayAmt();
        if (payMAmt == 0) {
            return bool;     //金额为0时不用校验
        }
        if (!CV.WarrPay) {
            return bool;     //配置不需担保时不再校验
        }
        var rtn = $.m({ClassName: "web.DHCOPQFPat", MethodName: "CheckWarBal", admStr: _episodeIdStr, payAmt: payMAmt, sFlag: 0}, false);
        if (rtn == 0) {
	        return bool;
	    }
	    var myAry = rtn.split("^");
	    $.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
	    disableById("btn-ok");
        return false;
    }

    //验证支付方式
    var _paym = {
	    validate: function() {
		    var bool = true;
	        if (_$container) {
	            if (_isManyPayment) {
	                var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
	                $.each(inputs, function (index, element) {
	                    var payMAmt = +$(element).val();
	                    if (payMAmt == 0) {
	                        return true;
	                    }
	                    var aryData = $(element).attr('data').split("^");
	                    var payMCode = aryData[1];
	                    if (!_checkPayM(payMCode)) {
	                        bool = false;
	                        return false;
	                    }
	                    if ((payMCode == "CASH") && (!_validActualMoney())) {
	                     	bool = false;
	                        return false;
	                    }
	                });
	            } else {
	                var $selectPayMode = _$container.find(".selected");
	                if ($selectPayMode.length > 0) {
	                    var aryData = $selectPayMode.attr('data').split("^");
	                    var payMCode = aryData[1];
	                    if (!_checkPayM(payMCode)) {
	                        bool = false;
	                    }
	                    if ((payMCode == "CASH") && (!_validActualMoney())) {
	                     	bool = false;
	                        return false;
	                    }
	                }
	            }
	        }
	        return bool;
		},
		//验证附加信息必填项
		required: function() {
			var bool = true;
	        if (_$container) {
	            if (_isManyPayment) {
	                var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
	                $.each(inputs, function (index, element) {
	                    var payMAmt = +$(element).val();
	                    if (payMAmt == 0) {
	                        return true;
	                    }
	                    var aryData = $(element).attr('data').split("^");
	                    var payMDr = aryData[0];
	                    var payMCode = aryData[1];
	                    var payMDesc = aryData[2];
	                    var requiredFlag = aryData[3];
	                    if (requiredFlag == "Y") {
	                        var $payMode = $(element).parent().prev();
	                        var addiObj = $(element).parent().prev().data("additionalData") || {};
	                        var payMAddiStr = _getAdditionalData(payMDr);
	                        var myAry, code, desc, isRequired;
	                        $.each(payMAddiStr.split("^"), function (index, item) {
		                        myAry = item.split("!");
	                          	code = myAry[0];
	                        	desc = myAry[1];
	                          	isRequired = myAry[2];
	                            if (isRequired == "Y") {
	                                if (!addiObj[code]) {
	                                    bool = false;
	                                    _showAddDataDlg($payMode);
	                                    return false;
	                                }
	                            }
	                        });
	                    }
	                    return bool;
	                });
	            } else {
	                var $selectPayMode = _$container.find(".selected");
	                if ($selectPayMode.length > 0) {
	                    var aryData = $selectPayMode.attr('data').split("^");
	                    var payMDr = aryData[0];
	                    var payMCode = aryData[1];
	                    var payMDesc = aryData[2];
	                    var requiredFlag = aryData[3];
	                    if (requiredFlag == "Y") {
	                    	var addiObj = $selectPayMode.data("additionalData") || {};
	                        var payMAddiStr = _getAdditionalData(payMDr);
							var myAry, code, desc, isRequired;
	                        $.each(payMAddiStr.split("^"), function (index, item) {
		                        myAry = item.split("!");
	                          	code = myAry[0];
	                           	desc = myAry[1];
	                           	isRequired = myAry[2];
	                            if (isRequired == "Y") {
	                                if (!addiObj[code]) {
	                                    bool = false;
	                                    _showAddDataDlg($selectPayMode);
	                                    return false;
	                                }
	                            }
	                        });
	                    }
	                }
	            }
	        }
	        return bool;
		},
		//生成支付方式串
		info: function() {
			var payMAry = [];
	        if (_$container) {
	            if (_isManyPayment) {
	                var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
	                $.each(inputs, function (index, element) {
	                    var payMAmt = +$(element).val();
	                    if (payMAmt == 0) {
	                        return true;
	                    }
	                    var aryData = $(element).attr("data").split("^");
	                    var payMDr = aryData[0];
	                    var payMCode = aryData[1];
	                    var addiObj = $(element).parent().prev().data("additionalData") || {};
	                    var myPayCard = addiObj.PayCard || "";  //支付卡号，对院内账号支付时传账号rowid
	                    var myPatUnitDr = addiObj.HCP || "";
	                    var myBankDr = addiObj.Bank || "";
	                    var myCheckNo = addiObj.CheckNO || "";
	                    var myChequeDate = addiObj.CheckDate || "";
	                    var myPayAccNo = addiObj.PayAccNO || "";
	                    var invRoundErrDetails = "";
	                    var actualMoney = "";
	                    var backChange = "";
	                    if (payMCode == "CASH") {
	                        payMAmt = _getRoundCASHAmt();
	                        invRoundErrDetails = $("#roundErrAmt").attr("data");
	                     	actualMoney = $("#actualMoney").val(); //实收
	                     	backChange = $("#backChange").val();   //找零
	                    }
						var ETPRowID = _payMConETP[payMDr] || "";   //第三方支付交易表RowId
						
	                    var tmpStr = payMDr + "^" + myBankDr + "^" + myCheckNo + "^" + myPayCard;
						tmpStr += "^" + myPatUnitDr + "^" + myChequeDate + "^" + myPayAccNo;
						tmpStr += "^" + payMAmt + "^" + invRoundErrDetails + "^" + actualMoney;
						tmpStr += "^" + backChange + "^" + ETPRowID;
	                    tmpStr = tmpStr.replace(/undefined/g, ""); //替换所有的undefined
	                    payMAry.push(tmpStr);
	                });
	            } else {
	                var $selectPayMode = _$container.find(".selected");
	                if ($selectPayMode.length > 0) {
	                    var aryData = $selectPayMode.attr("data").split("^");
	                    var payMDr = aryData[0];
	                    var payMCode = aryData[1];

	                    var addiObj = $selectPayMode.data("additionalData") || {};
	                    var myPayCard = addiObj.PayCard || "";   //支付卡号，对院内账号支付时传账户rowid
	                    var myPatUnitDr = addiObj.HCP || "";
	                    var myBankDr = addiObj.Bank || "";
	                    var myCheckNo = addiObj.CheckNO || "";
	                    var myChequeDate = addiObj.CheckDate || "";
	                    var myPayAccNo = addiObj.PayAccNO || "";

	                    var selfPayAmt = _getSelfPayAmt();
	                    var invRoundErrDetails = "";
	                    if (payMCode == "CASH") {
	                        selfPayAmt = _getRoundCASHAmt();
	                        invRoundErrDetails = $("#roundErrAmt").attr("data");
	                    }
	                    var actualMoney = $("#actualMoney").val();     //实收
	                    var backChange = $("#backChange").val();       //找零
						var ETPRowID = _payMConETP[payMDr] || "";      //第三方支付交易表RowId
						
	                    var tmpStr = payMDr + "^" + myBankDr + "^" + myCheckNo + "^" + myPayCard;
						tmpStr += "^" + myPatUnitDr + "^" + myChequeDate + "^" + myPayAccNo;
						tmpStr += "^" + selfPayAmt + "^" + invRoundErrDetails + "^" + actualMoney;
						tmpStr += "^" + backChange + "^" + ETPRowID;
	                    tmpStr = tmpStr.replace(/undefined/g, ""); //替换所有的undefined
	                    payMAry.push(tmpStr);
	                }
	            }
	        }
	        return payMAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		}
	};

    //判断是否有第三方支付
    var _paySrv = {
	    payMAry: [],
	    check: function() {
		    this.payMAry = [];   //需要初始化，防止在二次调用时已经存在
	        if (_$container) {
	            if (_isManyPayment) {
	                var inputs = _$container.find(".select-item-amt .paymode-amt"); //获取所有输入框
	                $.each(inputs, function (index, element) {
	                    var payMAmt = +$(element).val();
	                    var aryData = $(element).attr('data').split("^");
	                    var payMDr = aryData[0];
	                    if ((payMAmt > 0) && _paySrv.needPaySrv(payMDr)) {
		                    var myObj = {};
		                    myObj[payMDr] = payMAmt;
			            	_paySrv.payMAry.push(myObj);
		                }
	                });
	            } else {
	                var $selectPayMode = _$container.find(".selected");
	                if ($selectPayMode.length > 0) {
	                    var aryData = $selectPayMode.attr("data").split("^");
	                    var payMDr = aryData[0];
	                    var payMCode = aryData[1];
	                    var payMAmt = (payMCode == "CASH") ? _getRoundCASHAmt() : _getSelfPayAmt();
	                    if ((payMAmt > 0) && _paySrv.needPaySrv(payMDr)) {
		                    var myObj = {};
	                        myObj[payMDr] = payMAmt;
			             	_paySrv.payMAry.push(myObj);
	                    }
	                }
	            }
	        }
	        //使用队列"先进先出"方法调用第三方支付接口
	        _paySrv.shiftPay();
		},
		needPaySrv: function(payMode) {
			var rtn = $.m({ClassName: "DHCBILL.Common.DHCBILLCommon", MethodName: "GetCallModeByPayMode", PayMode: payMode}, false);
			var myAry = rtn.split("^");
			//需要调用第三方交易时，若_payMConETP[payMode]存在则不再调用，不存在则调用
			return ((myAry[0] > 0) && !_payMConETP[payMode]);
		},
		shiftPay: function() {
			//_paySrv.payMAry.length == 0时表示全部交易成功，则返回主界面
			if (_paySrv.payMAry.length > 0) {
				var obj = _paySrv.payMAry[0];   //每次取数组第1项
				$.each(Object.keys(obj), function(index, prop) {
					_paySrv.pay(prop, obj[prop]);
				});
				return;
			}
			_ok();
		},
		pay: function(payMode, payMAmt) {
			var adm = "";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	        expStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + _patientId + "^" + adm;
	        expStr += "^" + _prtRowIdStr.replace(/\^/g, "!") + "^^C";
	       	PayService("OP", payMode, payMAmt, expStr, _paySrv.callback);
		},
		callback: function(rtnValue) {
			if (rtnValue.ResultCode == 0) {
				_payMConETP[rtnValue.PayMode] = rtnValue.ETPRowID;    //将交易流水表RowId放入_payMConETP
				_paySrv.payMAry.shift();   //成功时删除第一项
				setTimeout(function() {
					_paySrv.shiftPay();
				}, (1000 * ((_paySrv.payMAry.length > 0) ? 1 : 0)));
				return;
			}
			$.messager.popover({msg: rtnValue.ResultMsg, type: "error"});
		}
	};

    /**
     * 初始化界面
     */
    dhcbill.opbill.checkout.CheckOut.prototype.initPanel = function () {
        _prtRowIdStr = this.prtRowIdStr;
        _accMRowId = this.accMRowId;
        _accMLeft = this.accMLeft;
        _allowPayMent = this.allowPayMent;
        _episodeIdStr = this.episodeIdStr;
        _patientId = this.patientId;
        _cardNo = this.cardNo;
        _cardTypeId = this.cardTypeId;
        _reloadFlag = this.reloadFlag;

        _initInvAmtData();

        _initAllowPaymentBtn();

        _initSelectBox('.container');

        _initButtonEvents('.btn-container .l-btn');
        
        _initTextboxEvents();
    };
})();

$(function () {
    var checkOutObj = new dhcbill.opbill.checkout.CheckOut(CV.Args);
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
            var sum = 0;
            var balance = 0;
            var $inputs = $(param[0]);
            $inputs.each(function (index, element) {
                if ($(element).hasClass('default-paymode-amt')) {
                    balance = +$(element).val();
                }
                sum = numCompute(sum, $(element).val(), "+");
            });
            var selfPayAmt = +$(param[1]).val();
            var temp = 0;
            if (+balance < +value) {
                temp = numCompute(sum, balance, "-");
            } else {
                temp = numCompute(sum, value, "-");
            }
            return !(temp > selfPayAmt);
        },
        message: '支付方式合计金额不能大于自费金额'
    }
});