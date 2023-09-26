/**
 * @file dhcbill.opbill.checkout.js
 * �����շ�����̨����
 * @author Lid
 * @date 2020-05-29
 */
 
/** @class
* ���������ռ�
* @abstract
*/
var dhcbill = window.dhcbill || {};
 
/** @class
* ���������շ������ռ�
* @abstract
*/
dhcbill.opbill = window.dhcbill.opbill || {};

/** @class
* ��������̨���ռ�
* @abstract
*/
dhcbill.opbill.checkout = window.dhcbill.opbill.checkout || {};

/** @class
* ����̨��
*
*/
dhcbill.opbill.checkout.CheckOut = function(cfg) {
	cfg = cfg || {};
	/** @cfg {String} [title="����̨"] ����*/
	this.title = cfg['title'] || '����̨';
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

//����һ���鼶������
(function(){
	
	//˽�г�Ա����
	var _allowPayMent = "N";
	var _isManyPayment = false;  //�Ƿ�������֧��
	var _accMRowId = "";
	var _prtRowIdStr = "";
	var _episodeIdStr = "";
	var _patientId = "";
	var _cardNo = "";
	var _cardTypeId = "";
	var _reloadFlag = "";
	/**
	* ֧����ʽ�б�
	* @static @private
	*/
	var _payInfo = "";
	/**
	* ֧����ʽ��������
	* @static @private
	*/
	var _$container = null;
	
	//ѡ��֧����ʽ
	var _selectedPayMode = function($this) {
	   _$container.find('.select-item').removeClass('selected').removeAttr('paymode-selected');
       $this.addClass('selected');
       $this.attr('paymode-selected', 1);
	}
	
	//��ʼ����Ʊ�����Ϣ
	var _initInvAmtData = function() {
		var invAmtInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: _prtRowIdStr}, false);
		//ȡҽ��֧����ʽ���
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
	
	//�����ֽ�ķֱ����
	var _calcRoundErrCASH = function() {
		var cashAmt = getValueById("txtPayMzCASH");
		_calcRoundErr(cashAmt);
	}
	
	//����ֱ����
	var _calcRoundErr = function(cashAmt) {
		var cashPayAmtRoundInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetManyInvRoundErrAmt", prtRowIdStr: _prtRowIdStr, amt: cashAmt}, false);
		var cashRoundSum = cashPayAmtRoundInfo.split("^")[0];
		setValueById("roundCASHAmt", cashRoundSum);
		setValueById("roundErrAmt", numCompute(cashRoundSum, cashAmt, "-"));
		$("#roundErrAmt").attr("data", cashPayAmtRoundInfo.split("^")[1]);
	}
	
	//�ж��Ƿ���Ĭ��֧����ʽ��������
	var _isDefaultPayMAmtTxtbox = function($this) {
		return $this.hasClass('default-paymode-amt');
	}
	
	//��ȡĬ��֧����ʽ�ı���ǰ���
	var _getDefaultPayMAmt = function() {
		return +(getValueById(_getDefaultPayMId()));  //���������
	}
	
	//��ȡĬ��֧����ʽ�ı���id
	var _getDefaultPayMId = function() {
		var $defaultPayMAmt = _$container.find(".select-item-amt .default-paymode-amt");
		return $defaultPayMAmt.attr('id');
	}
	
	//��ȡĬ��֧��֧����ʽ����
	var _getDefaultPayMCode = function() {
		var $defaultPayM = _$container.find(".select-item-amt .default-paymode-amt");
		return $defaultPayM.attr('id').split('z')[1];	
	}
	
	//����Ĭ��֧����ʽ���
	var _setDefaultPayMAmt = function(val) {
		setValueById(_getDefaultPayMId(), val);
	}
	
	//��ȡ֧����ʽ�б����ֽ�֧�����
	var _getCASHPayAmt = function() {
		return +getValueById("txtPayMzCASH");
	}
	
	//��ȡ�Էѽ��
	var _getSelfPayAmt = function() {
		return +getValueById("selfPayAmt");	
	}
	
	//��ȡ�ֱ������
	var _getRoundErrAmt = function() {
		return +getValueById("roundErrAmt");	
	}
	
	//��ȡ�ֽ�������
	var _getRoundCASHAmt = function() {
		return +getValueById("roundCASHAmt");
	}
	
	//��ȡ��ȡ֧����ʽ���ϼ�
	var _getAllPayMAmtSum = function() {
		var sum = 0;
		var inputs = _$container.find(".select-item-amt .paymode-amt");   //��ȡ���������
    	$.each(inputs, function(index, element) {
	    	sum += +($(element).val());
	    });
	    return sum;
	}
	
	//��ȡԺ���˻����
	var _getAccMBalance = function() {
		var accMLeft = "";
		if (_accMRowId) {
			accMLeft = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: _accMRowId}, false);
		}
		setValueById("accountBalance", accMLeft);
		return accMLeft;
	}
	
	//У��֧����ʽ�ϼƽ���Ƿ���ȷ
	var _checkAllPayMAmtSum = function() {
		if (_isManyPayment) {
			var sum = _getAllPayMAmtSum();
			var sefPayAmt = _getSelfPayAmt();
			return (+sum == +sefPayAmt);
		}else {
			return true;  //��֧����ʽģʽ����У��
		}
	}
	
	//У��ֱ�������Ƿ���ȷ
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
	
	//����֧����ʽ�б���
	var _resetPayMAmtTextbox = function() {
		var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
    	$.each(inputs, function(index, element) {
	    	$(element).removeAttr("data-oldval");
	    	$(element).val("");
	    });
	}
	
	//����֧����ʽ�����
	//�㷨����
	//		1.Ĭ�ϼ���ʱ���Էѽ����Ĭ��֧����ʽ��
	//		2.�շ�Ԫ��д��Ĭ��֧����ʽ�����Զ��ۼ�Ĭ��ֵ֧����ʽ�����Ĭ��֧�����С��0������ʾ�쳣��
	//�㷨���ڵ�����
	//		1.����շ�Ա�޸���Ĭ��֧����ʽ�Ľ��������㷨�쳣��
	var _calcTextBoxPayMAmt = function($this, e) {
		var oldVal = +($this.attr('data-oldval'));
		var newVal = +($this.val());
		var changeAmt = numCompute(newVal, oldVal, "-");
		var defaultPayMAmt = _getDefaultPayMAmt();  //Ĭ��֧����ʽ��ǰ���
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
	* ��ʼ������֧����ʽ��ť
	* @static @private
	*/
	var _initAllowPayMentBtn = function() {
	    $HUI.switchbox('#switchManyPayM', {
	        onText: '����֧��',
	        offText: '����֧��',
	        size: 'small',
	        checked: false,
	        onSwitchChange: function(e, obj) {
	            _$container.find(".select-item-amt").toggleClass("hidden");
	           	_isManyPayment = obj.value;
	           	var defaultPayMCode = _getDefaultPayMCode();
	           	//����Ĭ��֧���Ľ��
		        var selfPayAmt = numCompute(getValueById("patShareAmt"), getValueById("ybAmt"), "-");
	    		var defaultPayMId = _getDefaultPayMId();
	            
	            if(obj.value) {
		            //��������֧��
	    			_setDefaultPayMAmt(selfPayAmt);
	    			_calcRoundErrCASH();
		            //��λ��굽��һ����Ĭ��֧������
		         	var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
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
	* ��ʼ��֧����ʽ�б�ѡ���¼�
	* @param {String} ֧���б�����ѡ����
	* @param {String} �ص��¼�����ʱ����
	* @static @private
	*/
    var _initSelectBox = function(selector, selectCallback) {
    	_$container = $(selector);
		
		//�󶨿�ݼ�
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

    	//����֧����ʽʱ����Ĭ��֧����ʽ����Ĭ�Ͻ��
    	if (_allowPayMent == "Y") {
	    	//var selfPayAmt = getValueById("patShareAmt") - getValueById("ybAmt");
	    	//var defaultPayMId = _getDefaultPayMId();
	    	//_setDefaultPayMAmt(selfPayAmt);
	    	//Ϊ���еĽ����������֤
	    	var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
	    	$.each(inputs, function(index, element) {
		    	$(element).validatebox({
					//required: true,
		    		validType: "lessthanzero['.container .select-item-amt .paymode-amt', '#selfPayAmt']"
				});
		    });
	    };
		
	    //��ѡ�¼�
	    _$container
	    	//�����㶨λ������
	    	.focus()
	        //��ѡ�л�ѡ���¼�
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
				var requiredFlag = aryData[3];  //Y-�б�����Ϣ��N����
				if(requiredFlag == "Y") {
					$(".required-info").toggleClass("hidden");
				}
				*/
	        })
	        //��ѡȫѡȫ��ѡ,Ԥ�����Ժ󹩶���֧����ʽʹ��
	        .on('click', '.toggle-all-btn', function(e) {
	            if ($(this).attr('data-all')) {
	                $(this).removeAttr('data-all');
	                _$container.find('.select-item').removeClass('selected');
	            } else {
	                $(this).attr('data-all', 1);
	                _$container.find('.select-item').addClass('selected');
	            }
	        })
	        //֧����ʽ����ѡ���¼�
	        .on('click', '.select-item-amt', function(e) {
		        _selectedPayMode($(this).prev());
		    })
		    .on('keydown', '.select-item-amt input', function(e) {
				var key = websys_getKey(e);
				if (key == 13) {
					if ($(e.target).is('input')) {
						//_calcTextBoxPayMAmt($(this), e);
						var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
						var idx = inputs.index(this);  //��ȡ��ǰ������λ������
						var step = 1;
						if (idx == inputs.length - 1) {
							//�ж��Ƿ������һ�������
							idx = -1;
							focusById("btn-ok");
							return;
						}else {
							
						}
						if (_isDefaultPayMAmtTxtbox($(inputs[idx + step]))) { //�ж��Ƿ���Ĭ��֧����ʽ���������Ǿ�����
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
					//��֤����Ƿ�Ϸ�
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
	
	//ѡ��֧����ʽ
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
	* ��ʼ����ť�¼�
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
	* ��ʼ���ı����¼�
	* @static @private
	*/
	var _initTextboxEvents = function() {
		//ʵ��
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
			setValueById("actualMoney", $(e.target).val());  //numberbox ��ʧȥ����ʱ����ܻ�ȡ��ֵ������������丳ֵ�Ա���ȡ��
			var actualMoney = getValueById("actualMoney");
			var roundCASHAmt = getValueById("roundCASHAmt");
			var change = numCompute(actualMoney, roundCASHAmt, "-");
			if (+change < 0) {
				$.messager.popover({msg: "ʵ������������", type: "info"});
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
	
	//�������ݵ����Ի���
	var _showAddDataDlg = function($this) {
		var payMDr = $this.attr('data').split('^')[0];
		var opt = {'title': '��������', 'payMode': payMDr, 'patientId': _patientId};
		var additionObj = new dhcbill.opbill.checkout.AdditionData(opt);
		additionObj.show(function(code, obj) {
			if (code) {
				$this.data("additionalData", obj);
			}
		});
	}
	
	//ȷ�ϰ�ť�¼�
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
			$.messager.popover({msg: "��ȡ֧����ʽ���ݴ���", type: "error"});
			return false;
		}

		var code = true;
		websys_showModal("options").callbackFunc(_getReturnValue(code, payInfo));
		websys_showModal("close");
	}
	
	//ȡ����ť�¼�
	var _btnCancelClick = function(e) {
		var code = false;
		var msg = "ȡ��";
		websys_showModal("options").callbackFunc(_getReturnValue(code, msg));
		websys_showModal("close");
	}
	
	//����̨�ص���������ֵ
	var _getReturnValue = function(code, msg) {
		return {"code": code, "message": msg, "accMRowId": _accMRowId};
	}
	
	//���ð�ť�¼�
	var _btnResetClick = function(e) {
		location = location;
	}
	
	//У��֧����ʽ
	var validatePayM = function(payMCode) {
		
		if (!_checkCPP(payMCode)) {
			return false;
		}
		if (!_checkQF(payMCode)) {
			return false;
		}
		
		if (!_checkAllPayMAmtSum()) {
			//validatePayM������onblur�¼����ã���confirm������ѭ�����ȸ�Ϊ��ʾ
			$.messager.popover({msg: "֧����ʽ���ϼ��뻼���Էѽ��ȣ�������", type: "info"});
			/*
			$.messager.confirm("��ʾ", "֧����ʽ���ϼ��뻼���Էѽ��ȣ��Ƿ�����?", function (r) {
				if (r) {
					_btnResetClick();
				}
			});
			*/
			return false;
		}
		
		if (!_checkRoundAmt) {
			$.messager.popover({msg: "�ֽ�ֱ�����ƽ��������", type: "info"});
			/*
			$.messager.confirm("��ʾ", "�ֽ�ֱ�����ƽ���Ƿ�����?", function (r) {
				if (r) {
					_btnResetClick();
				}
			});
			*/
			return false;
		}
		
		return true;
	}
	
	//Ԥ�����ֵ
	var _accPayDeposit = function(payMAmt) {
		var url = "dhcbill.opbill.accdep.pay.csp?winfrom=opcharge&AccMRowID=" + _accMRowId;
		url += "&CardNo=" + _cardNo + "&PatientID=" + _patientId + "&PatFactPaySum=" + payMAmt;
		websys_showModal({
			url: url,
			title: '��ֵ',
			iconCls: 'icon-w-inv',
			width: '85%',
			height: '85%',
			callbackFunc: function() {
				if (_isManyPayment) {
					//����֧����ʽʱ����궨λ��Ԥ����֧������һ��֧����ʽ
					
				}else{
					//��֧����ʽ������ȷ����ť�����¼�
					setTimeout(function() {
							$("#btn-ok").click();
						}, 50);
				}
			}
		});
	}
	
	//У��Ԥ����֧����ʽ
	var _checkCPP = function(payMCode) {
		var bool = true;
		if (payMCode != "CPP") {
			return bool;
		}
		var payMAmt = +(_isManyPayment ? $('#txtPayMzCPP').val() : _getSelfPayAmt());
		if (payMAmt == 0) {
			return bool;  //���Ϊ0ʱ����У��
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
				$.messager.popover({msg: "����Ч", type: "info"});
				break;
			case "-201":
				$.messager.popover({msg: "�û��߲�������Ч���˻�����������֧�����˿�", type: "info"});
				disableById("btn-ok");
				break;
			case "-205":
				if (+myAry[4] != 0) {
					var msg = "���㣬���ȳ�ֵ <font color='red'>" + (+myAry[4]).toFixed(2) + "</font> Ԫ";
					if (_reloadFlag) {
						$.messager.popover({msg: msg, type: "info"});
					}else {
						msg += "<br>�Ƿ��ֵ��";
						$.messager.confirm("ȷ��", msg, function (r) {
							if (r) {
								_accPayDeposit(payMAmt);
							}
						});
					}
				}
				break;
			case "-206":
				$.messager.popover({msg: "�����벻һ�£���ʹ��ԭ��", type: "info"});
				break;
			case "-210":
				$.messager.popover({msg: "������֤ʧ��", type: "info"});
				break;
			default:
				$.messager.popover({msg: "δ֪����", type: "info"});
			}
		}
		return bool;
	}
	
	//У��Ƿ��֧����ʽ
	var _checkQF = function(payMCode) {
		var bool = true;
		if (payMCode != "QF") {
			return bool;
		}
		var payMAmt = +(_isManyPayment ? $('#txtPayMzQF').val() : _getSelfPayAmt());
		if (payMAmt == 0) {
			return bool;  //���Ϊ0ʱ����У��
		}
		var myRtn = $.m({ClassName: "web.DHCOPQFPat", MethodName: "CheckWarBal", admStr: _episodeIdStr, payAmt: payMAmt, sFlag: 0}, false);
		if (myRtn != "0") {
			bool = false;
			switch(myRtn) {
			case "-1":
				$.messager.popover({msg: "����û����Ч�ĵ�����Ϣ������Ƿ�ѽ���", type: "info"});
				break;
			case "-2":
				$.messager.popover({msg: "���ߵ������㣬����Ƿ�ѽ���", type: "info"});
				break;
			}
		}
		if(!bool){
			disableById("btn-ok");
		}
		return bool;
	}
	
	//��֤֧����ʽ
	var _checkPayM = function() {
		var bool = true;
		if (_$container) {
			if (_isManyPayment) {
				var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
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
	
	//��֤������Ϣ������
	var _checkRequired = function() {
		var bool = true;
		if (_$container) {
			if (_isManyPayment) {
				var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
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
									//$.messager.popover({msg: "������<font color=red>" + payMDesc + "��"  + desc + "</font>", type: "info"});
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
									//$.messager.popover({msg: "������<font color=red>" + payMDesc + "��"  + desc + "</font>", type: "info"});
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
		
	//����֧����ʽ��
	var _bulidPayInfo = function() {
		var payMStr = "";
		if (_$container) {
			if (_isManyPayment) {
				var payMAry = [];
				var inputs = _$container.find(".select-item-amt .paymode-amt");  //��ȡ���������
		    	$.each(inputs, function(index, element){
			    	var payMAmt = +$(element).val();
			    	if (payMAmt == 0) {
				    	return true;
				    }
			    	var aryData = $(element).attr('data').split("^");
			    	var payMDr = aryData[0];
					var payMCode = aryData[1];    	
			    	var addiObj = $(element).parent().prev().data("additionalData") || {};
					var myPayCard = addiObj.PayCard || "";    //֧�����ţ���Ժ���˺�֧��ʱ���˺�rowid
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
						var actualMoney = getValueById("actualMoney"); //ʵ��
						var backChange = getValueById("backChange");   //����
					}
					var tmpStr = payMDr + "^" + myBankDr + "^" + myCheckNo + "^" + myPayCard + "^" + myPatUnitDr + "^" + myChequeDate + "^" + myPayAccNo + "^" + payMAmt + "^" + invRoundErrDetails + "^" + actualMoney + "^" + backChange;
					tmpStr = tmpStr.replace(/undefined/g, "");   //�滻���е�undefined
					
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
					
					var myPayCard = addiObj.PayCard || "";    //֧�����ţ���Ժ���˺�֧��ʱ���˻�rowid
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
					var actualMoney = getValueById("actualMoney"); //ʵ��
					var backChange = getValueById("backChange");   //����
					
					var payMStr = payMDr + "^" + myBankDr + "^" + myCheckNo + "^" + myPayCard + "^" + myPatUnitDr + "^" + myChequeDate + "^" + myPayAccNo + "^" + selfPayAmt + "^" + invRoundErrDetails + "^" + actualMoney + "^" + backChange;
					payMStr = payMStr.replace(/undefined/g, "");   //�滻���е�undefined
				}
			}
			_payInfo = payMStr;
		}
		return payMStr;
	}          
	
	//���г�Ա����
	/**
	* ��ȡ����
	* @return {String} ���ر���
	*/
	dhcbill.opbill.checkout.CheckOut.prototype.getTitle = function(){
		
		return this._title;
	};

	/**
	* ��ȡ֧����ʽ�б���Ϣ
	* @return {String} ���ر���
	*/
	dhcbill.opbill.checkout.CheckOut.prototype.getPayInfo = function(){
		
		return this._payInfo;
	};
	
	/**
	* ��ʼ������
	* @return {Boolean} true-�ɹ���false-ʧ��
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
* ��֤��չ���ȷ��⣬�Ժ�Ҫ�ŵ�ͳһ������
*/
$.extend($.fn.validatebox.defaults.rules, {
    lessthanzero: {
        validator: function(value, param) {
	        //ע�⣺һ��Ҫת��ǿ��ת��ΪNumber���ͣ���������쳣��
	        // ����ʱ��Ϊû����ת�����Ͱ��ַ����Ƚϣ����˺ܶ���·��
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
        message: '֧����ʽ�ϼƽ��ܴ����Էѽ��'  
    }
});
