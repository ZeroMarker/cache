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
*
*/
dhcbill.opbill.checkout.CheckOut = function(cfg) {
	cfg = cfg || {};
	/** @cfg {String} [title="收银台"] 标题*/
	this.title = cfg['title'] || '收银台';
	this.allowPayMent = cfg['allowPayMent'] || '';
	this.prtRowIdStr = cfg['prtRowIdStr'] || '';
	this.insTypeId = cfg['insTypeId'] || '';
	this.typeFlag = cfg['typeFlag'] || '';
	this.accMRowId = cfg['accMRowId'] || '';
	this.episodeIdStr = cfg['episodeIdStr'] || '';
	this.patientId = cfg['patientId'] || '';
	this.cardNo = cfg['cardNo'] || '';
	this.cardTypeId = cfg['cardTypeId'] || '';
	this.reloadFlag = cfg['reloadFlag'] || '';
};

//构建一个块级作用域
(function(){
	
	//私有成员属性
	var _allowPayMent = "N";
	var _isManyPayment = false;  //是否开启多种支付
	var _accMRowId = "";
	var _prtRowIdStr = "";
	var _episodeIdStr = "";
	var _patientId = "";
	var _cardNo = "";
	var _cardTypeId = "";
	var _reloadFlag = "";
	/**
	* 支付方式列表
	* @static @private
	*/
	var _payInfo = "";
	/**
	* 支付方式容器对象
	* @static @private
	*/
	var _$container = null;
	
	//选中支付方式
	var _selectedPayMode = function($this) {
	   _$container.find('.select-item').removeClass('selected').removeAttr('paymode-selected');
       $this.addClass('selected');
       $this.attr('paymode-selected', 1);
	}
	
	//初始化发票金额信息
	var _initInvAmtData = function() {
		var invAmtInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: _prtRowIdStr}, false);
		//取医保支付方式金额
		var invPayMAmtInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvPayMAmtData", prtRowIdStr: _prtRowIdStr, flag: 0}, false);
		var aryAmt = invAmtInfo.split("^");
		setValueById("invAmt", aryAmt[0]);
		setValueById("discAmt", aryAmt[1]);
		setValueById("payorAmt", aryAmt[2]);
		setValueById("patShareAmt", aryAmt[3]);
		setValueById("ybAmt", aryAmt[4]);
		var selfPayAmt = numCompute(aryAmt[3], aryAmt[4], "-");
		setValueById("selfPayAmt", selfPayAmt);
		setValueById("roundErrAmt", aryAmt[5]);
		
		_calcRoundErr(selfPayAmt);
	}
	
	//计算现金的分币误差
	var _calcRoundErrCASH = function() {
		var cashAmt = getValueById("txtPayMzCASH");
		_calcRoundErr(cashAmt);
	}
	
	//计算分币误差
	var _calcRoundErr = function(cashAmt) {
		var cashPayAmtRoundInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetManyInvRoundErrAmt", prtRowIdStr: _prtRowIdStr, amt: cashAmt}, false);
		var cashRoundSum = cashPayAmtRoundInfo.split("^")[0];
		setValueById("roundCASHAmt", cashRoundSum);
		setValueById("roundErrAmt", numCompute(cashRoundSum, cashAmt, "-"));
		$("#roundErrAmt").attr("data", cashPayAmtRoundInfo.split("^")[1]);
	}
	
	//判断是否是默认支付方式金额输入框
	var _isDefaultPayMAmtTxtbox = function($this) {
		return $this.hasClass('default-paymode-amt');
	}
	
	//获取默认支付方式文本框当前金额
	var _getDefaultPayMAmt = function() {
		return +(getValueById(_getDefaultPayMId()));  //考虑误差金额
	}
	
	//获取默认支付方式文本框id
	var _getDefaultPayMId = function() {
		var $defaultPayMAmt = _$container.find(".select-item-amt .default-paymode-amt");
		return $defaultPayMAmt.attr('id');
	}
	
	//获取默认支付支付方式代码
	var _getDefaultPayMCode = function() {
		var $defaultPayM = _$container.find(".select-item-amt .default-paymode-amt");
		return $defaultPayM.attr('id').split('z')[1];	
	}
	
	//设置默认支付方式金额
	var _setDefaultPayMAmt = function(val) {
		setValueById(_getDefaultPayMId(), val);
	}
	
	//获取支付方式列表中现金支付金额
	var _getCASHPayAmt = function() {
		return +getValueById("txtPayMzCASH");
	}
	
	//获取自费金额
	var _getSelfPayAmt = function() {
		return +getValueById("selfPayAmt");	
	}
	
	//获取分币误差金额
	var _getRoundErrAmt = function() {
		return +getValueById("roundErrAmt");	
	}
	
	//获取现金舍入金额
	var _getRoundCASHAmt = function() {
		return +getValueById("roundCASHAmt");
	}
	
	//获取获取支付方式金额合计
	var _getAllPayMAmtSum = function() {
		var sum = 0;
		var inputs = _$container.find(".select-item-amt .paymode-amt");   //获取所有输入框
    	$.each(inputs, function(index, element) {
	    	sum += +($(element).val());
	    });
	    return sum;
	}
	
	//获取院内账户余额
	var _getAccMBalance = function() {
		var accMLeft = "";
		if (_accMRowId) {
			accMLeft = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: _accMRowId}, false);
		}
		setValueById("accountBalance", accMLeft);
		return accMLeft;
	}
	
	//校验支付方式合计金额是否正确
	var _checkAllPayMAmtSum = function() {
		if (_isManyPayment) {
			var sum = _getAllPayMAmtSum();
			var sefPayAmt = _getSelfPayAmt();
			return (+sum == +sefPayAmt);
		}else {
			return true;  //单支付方式模式不用校验
		}
	}
	
	//校验分币误差金额是否正确
	var _checkRoundAmt = function() {
		var roundErrAmt = _getRoundErrAmt();
		var sefPayAmt = _getSelfPayAmt();
		var roundCASHAmt = _getRoundCASHAmt();
		if (_isManyPayment) {
			var cashPayAmt = _getCASHPayAmt();
			return numCompute(cashPayAmt, roundErrAmt, "+") == +roundCASHAmt;
		}else{
			return numCompute(sefPayAmt, roundErrAmt, "+") == +roundCASHAmt;
		}
		return false;
	}
	
	//重置支付方式列表金额
	var _resetPayMAmtTextbox = function() {
		var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
    	$.each(inputs, function(index, element) {
	    	$(element).removeAttr("data-oldval");
	    	$(element).val("");
	    });
	}
	
	//计算支付方式金额框的
	//算法规则：
	//		1.默认加载时，自费金额在默认支付方式上
	//		2.收费元填写非默认支付方式金额后，自动扣减默认值支付方式金额，如果默认支付金额小于0，则提示异常。
	//算法存在的问题
	//		1.如果收费员修改了默认支付方式的金额，将导致算法异常。
	var _calcTextBoxPayMAmt = function($this, e) {
		var oldVal = +($this.attr('data-oldval'));
		var newVal = +($this.val());
		var changeAmt = numCompute(newVal, oldVal, "-");
		var defaultPayMAmt = _getDefaultPayMAmt();  //默认支付方式当前金额
		var balance = numCompute(defaultPayMAmt, changeAmt, "-");
		if (+balance < 0) {
			if(oldVal == 0) {
				oldVal = "";
			}
			$this.attr('data-oldval', oldVal);
			$this.val(oldVal);
			$this.validatebox("validate");
			return false;
		}
		_setDefaultPayMAmt(balance);
		
		if($this.hasClass("CASH-class")){
			_calcRoundErr(newVal);	
		}else{
			_calcRoundErrCASH();
		}
	}
	
	/**
	* 初始化多种支付方式按钮
	* @static @private
	*/
	var _initAllowPayMentBtn = function() {
	    $HUI.switchbox('#switchManyPayM', {
	        onText: '多种支付',
	        offText: '单种支付',
	        size: 'small',
	        checked: false,
	        onSwitchChange: function(e, obj) {
	            _$container.find(".select-item-amt").toggleClass("hidden");
	           	_isManyPayment = obj.value;
	           	var defaultPayMCode = _getDefaultPayMCode();
	           	//设置默认支付的金额
		        var selfPayAmt = numCompute(getValueById("patShareAmt"), getValueById("ybAmt"), "-");
	    		var defaultPayMId = _getDefaultPayMId();
	            
	            if(obj.value) {
		            //开启多种支付
	    			_setDefaultPayMAmt(selfPayAmt);
	    			_calcRoundErrCASH();
		            //定位光标到第一个非默认支付金额框
		         	var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
			    	$.each(inputs,function(index, element) {
				    	if (!$(element).hasClass("default-paymode-amt")) {
					    	$(element).get(0).focus();
					    	_selectedPayMode($(element).parent().prev());
					    	return false;
					    }
				    });
	            }else {
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
    var _initSelectBox = function(selector, selectCallback) {
    	_$container = $(selector);
		
		//绑定快捷键
		$(document).keydown(function(e) {
			var keyCode = websys_getKey(e);
			var hotKey = "";
			$.each(_$container.find(".select-item[data]"), function(index, element) {
				hotKey = $(this).attr("data").split("^")[6];
				if (keyCode == KEYCODE[hotKey]) {
					$(this).click();
				}
			});
			cancelBubble(e);
		});

    	//多种支付方式时，给默认支付方式设置默认金额
    	if (_allowPayMent == "Y") {
	    	//var selfPayAmt = getValueById("patShareAmt") - getValueById("ybAmt");
	    	//var defaultPayMId = _getDefaultPayMId();
	    	//_setDefaultPayMAmt(selfPayAmt);
	    	//为所有的金额输入框加验证
	    	var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
	    	$.each(inputs, function(index, element) {
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
	        .on('click', '.select-item', function(e) {
		        var payMCode = $(this).attr('id').split("z")[1];
		        var txtPayMAmtId = $(this).next().find(":first-child");
	            if ($(this).hasClass('selected')) {
	                //$(this).removeClass('selected');
	            } else {
		            _$container.find('.select-item').removeClass('selected').removeAttr('paymode-selected');
	                $(this).addClass('selected');
	                $(this).attr('paymode-selected', 1);
	            }
	            if ($(this).next().hasClass('hidden')) {
		        	_selectedPayMClick($(this), e);
		        }else {
			        txtPayMAmtId.focus();
			    }
			    /*
	         	var aryData = $(this).attr('data').split("^");
				var requiredFlag = aryData[3];  //Y-有必填信息，N：无
				if(requiredFlag == "Y") {
					$(".required-info").toggleClass("hidden");
				}
				*/
	        })
	        //点选全选全不选,预留，以后供多种支付方式使用
	        .on('click', '.toggle-all-btn', function(e) {
	            if ($(this).attr('data-all')) {
	                $(this).removeAttr('data-all');
	                _$container.find('.select-item').removeClass('selected');
	            } else {
	                $(this).attr('data-all', 1);
	                _$container.find('.select-item').addClass('selected');
	            }
	        })
	        //支付方式金额框选中事件
	        .on('click', '.select-item-amt', function(e) {
		        _selectedPayMode($(this).prev());
		    })
		    .on('keydown', '.select-item-amt input', function(e) {
				var key = websys_getKey(e);
				if (key == 13) {
					if ($(e.target).is('input')) {
						//_calcTextBoxPayMAmt($(this), e);
						var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
						var idx = inputs.index(this);  //获取当前输入框的位置索引
						var step = 1;
						if (idx == inputs.length - 1) {
							//判断是否是最后一个输入框
							idx = -1;
							focusById("btn-ok");
							return;
						}else {
							
						}
						if (_isDefaultPayMAmtTxtbox($(inputs[idx + step]))) { //判断是否是默认支付方式输入框，如果是就跳过
							step++;
						}
						inputs[idx + step].focus();
						inputs[idx + step].select();
						_selectedPayMode($(inputs[idx + step]).parent().prev());
						e.stopPropagation();
					}
				}
			})
			.on('focus', '.select-item-amt input', function(e) {
				if ($(e.target).is('input')) {
					$(this).attr('data-oldval',$(this).val());
					enableById('btn-ok');
					e.stopPropagation();
				}
			})
			.on('blur', '.select-item-amt input', function(e) {
				if ($(e.target).is('input')) {
					_calcTextBoxPayMAmt($(this), e);
					//验证金额是否合法
					var thisId = $(this).attr('id');
					var payMCode = thisId.split("z")[1];
					var bool = validatePayM(payMCode);
					if (!bool) {
						focusById(thisId);
						return false;
					}
					e.stopPropagation();
				}
			})
			.on('click', '.select-item .paym-additionaldata-flag', function(e) {
				if ($(e.target).is('span')) {
					var $payMode = $(this).parent();
					_selectedPayMode($payMode);
					_showAddDataDlg($payMode);
				}
				e.stopPropagation();
			});
	};
	
	//选中支付方式
	var _selectedPayMClick = function($this, e) {
		enableById('btn-ok');
		var payMCode = $this.attr('id').split("z")[1];
		
		if(!_checkCPP(payMCode)) {
			return false;
		}
		
		if(!_checkQF(payMCode)) {
			return false;
		}
		
		if (payMCode == "CASH") {
			setTimeout(function() {
					focusById("actualMoney");
				}, 100);
		}else if(payMCode=="QF") {
			
		}else if(payMCode=="CPP") {
			
		}else if(payMCode=="CCP") {
				
		}else{
			setTimeout(function() {
					focusById("btn-ok");
				}, 100);
		}
	}

	/**
	* 初始化按钮事件
	* @static @private
	*/
	var _initButtonEvents = function(selector, selectCallback){
		var $linkbuttons = $(selector);
		$linkbuttons.each(function(index, element) {
			$(this).on('click',function(e) {
				switch($(this).attr("id")) {
				case "btn-ok":
					_btnOkClick(e);
					break;
				case "btn-cancel":
					_btnCancelClick(e);
					break;
				case "btn-reset":
					_btnResetClick(e);
					break;
				default:
				}
			});
		})
	};
	
	/**
	* 初始化文本框事件
	* @static @private
	*/
	var _initTextboxEvents = function() {
		//实收
		$("#actualMoney").keydown(function(e) {
			_actualMoneyKeydown(e);
		});
	}
	
	var _actualMoneyKeydown = function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			if (!$(e.target).val()) {
				return;
			}
			setValueById("actualMoney", $(e.target).val());  //numberbox 在失去焦点时候才能获取到值，所以这里给其赋值以便能取到
			var actualMoney = getValueById("actualMoney");
			var roundCASHAmt = getValueById("roundCASHAmt");
			var change = numCompute(actualMoney, roundCASHAmt, "-");
			if (+change < 0) {
				$.messager.popover({msg: "实付金额输入错误", type: "info"});
				$(e.target).focus().select();
				return;
			}else {
				setValueById("backChange", change);
				setTimeout(function() {
						focusById("btn-ok");
					}, 100);
			}
		}
	}
	
	//附加数据弹出对话框
	var _showAddDataDlg = function($this) {
		var payMDr = $this.attr('data').split('^')[0];
		var opt = {'title': '附加数据', 'payMode': payMDr, 'patientId': _patientId};
		var additionObj = new dhcbill.opbill.checkout.AdditionData(opt);
		additionObj.show(function(code, obj) {
			if (code) {
				$this.data("additionalData", obj);
			}
		});
	}
	
	//确认按钮事件
	var _btnOkClick = function(e) {
		if ($("#btn-ok").linkbutton("options").disabled) {
			return false;
		}
		
		if (!_checkPayM()) {
			return false;
		}
		
		if (!_checkRequired()) {
			return false;
		}

		var payInfo = _bulidPayInfo();
		if (payInfo == "") {
			$.messager.popover({msg: "获取支付方式数据错误", type: "error"});
			return false;
		}

		var code = true;
		websys_showModal("options").callbackFunc(_getReturnValue(code, payInfo));
		websys_showModal("close");
	}
	
	//取消按钮事件
	var _btnCancelClick = function(e) {
		var code = false;
		var msg = "取消";
		websys_showModal("options").callbackFunc(_getReturnValue(code, msg));
		websys_showModal("close");
	}
	
	//收银台回调函数返回值
	var _getReturnValue = function(code, msg) {
		return {"code": code, "message": msg, "accMRowId": _accMRowId};
	}
	
	//重置按钮事件
	var _btnResetClick = function(e) {
		location = location;
	}
	
	//校验支付方式
	var validatePayM = function(payMCode) {
		
		if (!_checkCPP(payMCode)) {
			return false;
		}
		if (!_checkQF(payMCode)) {
			return false;
		}
		
		if (!_checkAllPayMAmtSum()) {
			//validatePayM方法在onblur事件调用，用confirm会有死循环，先改为提示
			$.messager.popover({msg: "支付方式金额合计与患者自费金额不等，请重置", type: "info"});
			/*
			$.messager.confirm("提示", "支付方式金额合计与患者自费金额不等，是否重置?", function (r) {
				if (r) {
					_btnResetClick();
				}
			});
			*/
			return false;
		}
		
		if (!_checkRoundAmt) {
			$.messager.popover({msg: "现金分币误差金额不平，请重置", type: "info"});
			/*
			$.messager.confirm("提示", "现金分币误差金额不平，是否重置?", function (r) {
				if (r) {
					_btnResetClick();
				}
			});
			*/
			return false;
		}
		
		return true;
	}
	
	//预交金充值
	var _accPayDeposit = function(payMAmt) {
		var url = "dhcbill.opbill.accdep.pay.csp?winfrom=opcharge&AccMRowID=" + _accMRowId;
		url += "&CardNo=" + _cardNo + "&PatientID=" + _patientId + "&PatFactPaySum=" + payMAmt;
		websys_showModal({
			url: url,
			title: '充值',
			iconCls: 'icon-w-inv',
			width: '85%',
			height: '85%',
			callbackFunc: function() {
				if (_isManyPayment) {
					//多种支付方式时，光标定位到预交金支付的下一个支付方式
					
				}else{
					//单支付方式，触发确定按钮单击事件
					setTimeout(function() {
							$("#btn-ok").click();
						}, 50);
				}
			}
		});
	}
	
	//校验预交金支付方式
	var _checkCPP = function(payMCode) {
		var bool = true;
		if (payMCode != "CPP") {
			return bool;
		}
		var payMAmt = +(_isManyPayment ? $('#txtPayMzCPP').val() : _getSelfPayAmt());
		if (payMAmt == 0) {
			return bool;  //金额为0时不用校验
		}
		var myRtn = DHCACC_CheckMCFPay(payMAmt, _cardNo, _episodeIdStr, _cardTypeId);
		var myAry = myRtn.split("^");
		_accMRowId = myAry[1];
		if (+_accMRowId > 0) {
			_getAccMBalance();
		}
		if (myAry[0] != "0") {
			bool = false;
			switch(myAry[0]) {
			case "-200":
				$.messager.popover({msg: "卡无效", type: "info"});
				break;
			case "-201":
				$.messager.popover({msg: "该患者不存在有效的账户，不能用来支付或退款", type: "info"});
				disableById("btn-ok");
				break;
			case "-205":
				if (+myAry[4] != 0) {
					var msg = "余额不足，请先充值 <font color='red'>" + (+myAry[4]).toFixed(2) + "</font> 元";
					if (_reloadFlag) {
						$.messager.popover({msg: msg, type: "info"});
					}else {
						msg += "<br>是否充值？";
						$.messager.confirm("确认", msg, function (r) {
							if (r) {
								_accPayDeposit(payMAmt);
							}
						});
					}
				}
				break;
			case "-206":
				$.messager.popover({msg: "卡号码不一致，请使用原卡", type: "info"});
				break;
			case "-210":
				$.messager.popover({msg: "卡号验证失败", type: "info"});
				break;
			default:
				$.messager.popover({msg: "未知错误", type: "info"});
			}
		}
		return bool;
	}
	
	//校验欠费支付方式
	var _checkQF = function(payMCode) {
		var bool = true;
		if (payMCode != "QF") {
			return bool;
		}
		var payMAmt = +(_isManyPayment ? $('#txtPayMzQF').val() : _getSelfPayAmt());
		if (payMAmt == 0) {
			return bool;  //金额为0时不用校验
		}
		var myRtn = $.m({ClassName: "web.DHCOPQFPat", MethodName: "CheckWarBal", admStr: _episodeIdStr, payAmt: payMAmt, sFlag: 0}, false);
		if (myRtn != "0") {
			bool = false;
			switch(myRtn) {
			case "-1":
				$.messager.popover({msg: "患者没有有效的担保信息，不能欠费结算", type: "info"});
				break;
			case "-2":
				$.messager.popover({msg: "患者担保金额不足，不能欠费结算", type: "info"});
				break;
			}
		}
		if(!bool){
			disableById("btn-ok");
		}
		return bool;
	}
	
	//验证支付方式
	var _checkPayM = function() {
		var bool = true;
		if (_$container) {
			if (_isManyPayment) {
				var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
		    	$.each(inputs, function(index, element) {
			    	var payMAmt = +$(element).val();
			    	if (payMAmt == 0) {
				    	return true;
				    }
			    	var aryData = $(element).attr('data').split("^");
					var payMCode = aryData[1];
					if (!validatePayM(payMCode)) {
						bool = false;
						return false;
					}
		    	});
			}else {
				var $selectPayMode = _$container.find(".selected");
				if ($selectPayMode.length > 0) {
					var aryData = $selectPayMode.attr('data').split("^");
					var payMCode = aryData[1];
					if (!validatePayM(payMCode)) {
						bool = false;
					}
				}
			}
		}
		return bool;
	}
	
	//验证附加信息必填项
	var _checkRequired = function() {
		var bool = true;
		if (_$container) {
			if (_isManyPayment) {
				var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
		    	$.each(inputs, function(index, element) {
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
						var payMAddiStr = $.m({ClassName: "web.UDHCOPGSConfig", MethodName: "GetAdditionalData", payMode: payMDr, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
						var tmpAry = payMAddiStr.split("^");
						$.each(tmpAry, function(index, val) {
							var code = val.split("!")[0];
							var desc = val.split("!")[1];
							var isRequired = val.split("!")[2];
							if (isRequired == "Y") {
								if (!addiObj[code]) {
									bool = false;
									_showAddDataDlg($payMode);
									//$.messager.popover({msg: "请输入<font color=red>" + payMDesc + "的"  + desc + "</font>", type: "info"});
									return false;
								}
							}
						});
					}
					return bool;
			    });
			}else {
				var $selectPayMode = _$container.find(".selected");
				if ($selectPayMode.length > 0) {
					var aryData = $selectPayMode.attr('data').split("^");
					var payMDr = aryData[0];
					var payMCode = aryData[1];
					var payMDesc = aryData[2];
					var requiredFlag = aryData[3];
					if (requiredFlag == "Y") {
						var addiObj = $selectPayMode.data("additionalData") || {};
						var payMAddiStr = $.m({ClassName: "web.UDHCOPGSConfig", MethodName: "GetAdditionalData", payMode: payMDr, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
						var tmpAry = payMAddiStr.split("^");
						$.each(tmpAry, function(index, val) {
							var code = val.split("!")[0];
							var desc = val.split("!")[1];
							var isRequired = val.split("!")[2];
							if (isRequired == "Y") {
								if (!addiObj[code]) {
									bool = false;
									_showAddDataDlg($selectPayMode);
									//$.messager.popover({msg: "请输入<font color=red>" + payMDesc + "的"  + desc + "</font>", type: "info"});
									return false;
								}
							}
						});
					}	
				}
			}
		}
		return bool;
	}
		
	//生成支付方式串
	var _bulidPayInfo = function() {
		var payMStr = "";
		if (_$container) {
			if (_isManyPayment) {
				var payMAry = [];
				var inputs = _$container.find(".select-item-amt .paymode-amt");  //获取所有输入框
		    	$.each(inputs, function(index, element){
			    	var payMAmt = +$(element).val();
			    	if (payMAmt == 0) {
				    	return true;
				    }
			    	var aryData = $(element).attr('data').split("^");
			    	var payMDr = aryData[0];
					var payMCode = aryData[1];    	
			    	var addiObj = $(element).parent().prev().data("additionalData") || {};
					var myPayCard = addiObj.PayCard || "";    //支付卡号，对院内账号支付时传账号rowid
					var myPatUnitDr = addiObj.HCP || "";
					var myBankDr = addiObj.Bank || "";
					var myCheckNo = addiObj.CheckNO || "";
					var myChequeDate = addiObj.CheckDate || "";
					var myPayAccNo = addiObj.PayAccNO || "";
					
					//var selfPayAmt = getValueById("selfPayAmt");
					var payMTextboxId = $(element).attr('id');
					var payMAmt = +getValueById(payMTextboxId);
					var invRoundErrDetails = "";
					var actualMoney = "";
					var backChange = "";
					if (payMCode == "CASH") {
						payMAmt = getValueById("roundCASHAmt");
						invRoundErrDetails = $("#roundErrAmt").attr("data");
						var actualMoney = getValueById("actualMoney"); //实收
						var backChange = getValueById("backChange");   //找零
					}
					var tmpStr = payMDr + "^" + myBankDr + "^" + myCheckNo + "^" + myPayCard + "^" + myPatUnitDr + "^" + myChequeDate + "^" + myPayAccNo + "^" + payMAmt + "^" + invRoundErrDetails + "^" + actualMoney + "^" + backChange;
					tmpStr = tmpStr.replace(/undefined/g, "");   //替换所有的undefined
					
					payMAry.push(tmpStr);
			    });
			    
			    payMStr = payMAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			    
			}else {
				var $selectPayMode = _$container.find(".selected");
				if ($selectPayMode.length > 0) {
					var aryData = $selectPayMode.attr('data').split("^");
					var payMDr = aryData[0];
					var payMCode = aryData[1];

					var addiObj = $selectPayMode.data("additionalData") || {};
					
					var myPayCard = addiObj.PayCard || "";    //支付卡号，对院内账号支付时传账户rowid
					var myPatUnitDr = addiObj.HCP || "";
					var myBankDr = addiObj.Bank || "";
					var myCheckNo = addiObj.CheckNO || ""; 
					var myChequeDate = addiObj.CheckDate || "";
					var myPayAccNo = addiObj.PayAccNO || "";
					
					var selfPayAmt = getValueById("selfPayAmt");
					var invRoundErrDetails = "";
					if(payMCode == "CASH") {
						selfPayAmt = getValueById("roundCASHAmt");
						invRoundErrDetails = $("#roundErrAmt").attr("data");
					}
					var actualMoney = getValueById("actualMoney"); //实收
					var backChange = getValueById("backChange");   //找零
					
					var payMStr = payMDr + "^" + myBankDr + "^" + myCheckNo + "^" + myPayCard + "^" + myPatUnitDr + "^" + myChequeDate + "^" + myPayAccNo + "^" + selfPayAmt + "^" + invRoundErrDetails + "^" + actualMoney + "^" + backChange;
					payMStr = payMStr.replace(/undefined/g, "");   //替换所有的undefined
				}
			}
			_payInfo = payMStr;
		}
		return payMStr;
	}          
	
	//公有成员方法
	/**
	* 获取标题
	* @return {String} 返回标题
	*/
	dhcbill.opbill.checkout.CheckOut.prototype.getTitle = function(){
		
		return this._title;
	};

	/**
	* 获取支付方式列表信息
	* @return {String} 返回标题
	*/
	dhcbill.opbill.checkout.CheckOut.prototype.getPayInfo = function(){
		
		return this._payInfo;
	};
	
	/**
	* 初始化界面
	* @return {Boolean} true-成功，false-失败
	*/
	dhcbill.opbill.checkout.CheckOut.prototype.initPanel = function() {
		
		_prtRowIdStr = this.prtRowIdStr;
		_accMRowId = this.accMRowId;
		_allowPayMent = this.allowPayMent;
		if(this.episodeIdStr){
			_episodeIdStr = this.episodeIdStr;
		}else{
			_episodeIdStr = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: _prtRowIdStr}, false);
		}
		_patientId = this.patientId;
		_cardNo = this.cardNo;
		_cardTypeId = this.cardTypeId;
		_reloadFlag = this.reloadFlag;
		
		
		_getAccMBalance();
		
		_initInvAmtData();
		
		_initAllowPayMentBtn();
		
		//$("#btnPayMzCASH").addClass('selected');
		_initSelectBox('.container');
		
		_initButtonEvents('.btn-container .hisui-linkbutton');
		//_initButtonEvents('.btn-container');
		_initTextboxEvents();
		
		return true;
	};
})();

$(function () {
	var checkOutObj = new dhcbill.opbill.checkout.CheckOut({
		allowPayMent: getValueById("allowPayMent"),
		prtRowIdStr: getValueById("prtRowIdStr"),
		insTypeId: getValueById("insTypeId"),
		typeFlag: getValueById("typeFlag"),
		accMRowId: getValueById("accMRowId"),
		episodeIdStr: getValueById("episodeIdStr"),
		patientId: getValueById("patientId"),
		cardNo: getValueById("cardNo"),
		cardTypeId: getValueById("cardTypeId"),
		reloadFlag: getValueById("reloadFlag")
	});
	
	checkOutObj.initPanel();
});

$(window).load(function() {
	$(".msg-popover").removeClass("hidden");
});

/**
* 验证扩展，先放这，以后要放到统一方法中
*/
$.extend($.fn.validatebox.defaults.rules, {
    lessthanzero: {
        validator: function(value, param) {
	        //注意：一定要转换强制转换为Number类型，否则会有异常。
	        // 开发时因为没有做转换，就按字符串比较，走了很多弯路。
	        var value = +value;
	        var sum = 0;
	        var balance = 0;
        	var $inputs = $(param[0]);
        	$inputs.each(function(index, element){
	        	if($(element).hasClass('default-paymode-amt')){
		        	balance = +$(element).val();
		        }
	        	sum += +$(element).val();
	        })
        	var selfPayAmt = +$(param[1]).val();
        	var temp = 0;
        	if(Number(balance) < Number(value)){
	        	temp = sum - (+balance);
	        }else{
		    	temp = sum - (+value);
		    }
		    temp = temp.toFixed(2);
            return !(temp > selfPayAmt);
        },  
        message: '支付方式合计金额不能大于自费金额'  
    }
});
