/**
 * @file dhcbill.opbill.chectout.additionaldata.js
 * 门诊收费收银台--附加数据对象
 * @author Lid
 * @date 2020-06-08
 */

var dhcbill = window.dhcbill || {};
dhcbill.opbill = window.dhcbill.opbill || {};
dhcbill.opbill.checkout = window.dhcbill.opbill.checkout || {};
/** 
* @class
* 收银台类
*/
dhcbill.opbill.checkout.AdditionData = function(cfg) {
	cfg = cfg || {};
	/** @cfg {String} [title="收银台"] 标题*/
	this.title = cfg['title'] || '附加数据';
	this.payMode = cfg['payMode'] || '';
	this.patientId = cfg['patientId'] || '';
};

//构建一个块级作用域
(function() {
	
	//私有成员属性
	var _titel = "";
	var _payMode = "";
	var _patientId = "";
	
	//私有方法
	/**
	* 初始化界面
	* 	需要做配置，根据支付方式显示附属信息
	*/
	var _initPanel = function() {
		//根据支付方式取其附属数据 -- 需要做配置，先写死
		var payMAddiStr = $.m({ClassName: "web.UDHCOPGSConfig", MethodName: "GetAdditionalData", payMode: _payMode, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
		var $container = $("#additionDataDlg");
		$container.find(".paym-additional").addClass('hidden');
		var tmpAry = payMAddiStr.split("^");
		$.each(tmpAry, function(index, val) {
			var code = val.split("!")[0];
			var requiredFlag = val.split("!")[2];
			$label = $("#" + code).prev().find(":first-child");
			if ($label.hasClass('clsRequired')) {
				$label.removeClass('clsRequired');
			}
			if (requiredFlag == "Y") {
				$label.addClass('clsRequired');
			}
			$("#" + code).parent().removeClass('hidden').addClass("clsRequired");
		});
	}
	
	//公有方法
	/**
	* 显示界面
	* @return {Boolean} true-成功，false-失败
	*/
	dhcbill.opbill.checkout.AdditionData.prototype.show = function(callbackFun) {
		_titel = this.title;
		_payMode = this.payMode;
		_patientId = this.patientId;
		
		_initPanel();
	
		$("#additionDataDlg").show();
		var dlgObj = $HUI.dialog("#additionDataDlg", {
			title: _titel,
			iconCls: 'icon-w-plus',
			draggable: false,
			resizable: false,
			cache: false,
			modal: true,
			onBeforeOpen: function() {
				//$("#additionDataDlg").form("clear");
				//银行
				$HUI.combobox("#Bank", {
					panelHeight: 150,
					url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson',
					method: 'GET',
					valueField: 'id',
					textField: 'text',
					blurValidValue: true,
					defaultFilter: 4
				});
				
				//公费单位
				$HUI.combobox("#HCP", {
					panelHeight: 150,
					url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryHCPList&ResultSetType=array&patientId=' + _patientId,
					method: 'GET',
					valueField: 'id',
					textField: 'text',
					blurValidValue: true,
					defaultFilter: 4
				});
			},
			onOpen: function() {
				var $container = $("#additionDataDlg");
				var inputsSelector = ".paym-additional:not(.hidden) .combo-text,.paym-additional:not(.hidden) .item-textbox";
				$container.find(inputsSelector).each(function(index, ele) {
					if (index == 0) {
						ele.focus();
					}
					$(this).on('keydown',function(e) {
						var key = websys_getKey(e);
						if (key == 13) {
							var inputs = $container.find(inputsSelector);  //获取所有输入框
							var idx = inputs.index(this);   //获取当前输入框的位置索引
							var step = 1;
							if (idx == inputs.length - 1) {
								//判断是否是最后一个输入框
								idx = -1;
								focusById("dlg-btn-ok");
								return false;
							}else {
								
							}
							inputs[idx + step].focus();
							inputs[idx + step].select();
							if ($(inputs[idx + step]).hasClass('combo-text')) {
								$(inputs[idx + step]).parent().prev().combo('showPanel');	
							}
						}
						e.stopPropagation();
					});
				})
				
				/*
				//展开日期选择框及复选框的下拉列表，还存在问题--提供一个思路供参考
				var inputsSelector = ".paym-additional .combo-text,.paym-additional .combo-arrow:first-child,.paym-additional .item-textbox";  //
				console.log($container.find(inputsSelector));
				$container.find(inputsSelector).each(function(index,ele){
					$(this).on('keydown',function(e){
						var key = websys_getKey(e);
						if (key == 13) {
							var inputs = $container.find(inputsSelector);  //获取所有输入框
							var idx = inputs.index(this); //获取当前输入框的位置索引
							var step = 1;
							if (idx == inputs.length - 1) {
								//判断是否是最后一个输入框	
								idx = -1;
								focusById("dlg-btn-ok");
								return false ;
							}else {
								
							}
							inputs[idx + step].focus();
							$(inputs[idx + step]).click();
							//inputs[idx + step].select();
						}
						//e.stopPropagation();
					});	
				})
				*/
			},
			buttons: [{
					text: '确认',
					id: 'dlg-btn-ok',
					handler: function () {
						var bool = true;
						var id = "";
						$("#additionDataDlg .paym-additional:not(.hidden) .r-label .clsRequired").each(function(index, item) {
							id = $(this).parent().next().attr('id');
							if (!id) {
								return bool;
							}
							if (!getValueById(id)) {
								bool = false;
								focusById(id);
								$.messager.popover({msg: "请输入<font color=red>" + $(this).text() + "</font>", type: "info"});
								return false;
							}
						});
						if (!bool) {
							return false;
						}
						var rtnObj = {};
						var $container = $("#additionDataDlg");
						var inputsSelector = ".paym-additional .additional-item";
						$container.find(inputsSelector).each(function(index, ele) {
							var id = $(this).attr('id');
							var value = getValueById(id);
							rtnObj[id] = value;
						});
						callbackFun(true, rtnObj);
						dlgObj.close();
					}
				}, {
					text: '关闭',
					handler: function () {
						callbackFun(false, {});
						dlgObj.close();
					}
				}
			]			
		});
		return true;
	};
	
})();