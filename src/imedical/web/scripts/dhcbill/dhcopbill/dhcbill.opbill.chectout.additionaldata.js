/**
 * @file dhcbill.opbill.chectout.additionaldata.js
 * �����շ�����̨--�������ݶ���
 * @author Lid
 * @date 2020-06-08
 */

var dhcbill = window.dhcbill || {};
dhcbill.opbill = window.dhcbill.opbill || {};
dhcbill.opbill.checkout = window.dhcbill.opbill.checkout || {};
/** 
* @class
* ����̨��
*/
dhcbill.opbill.checkout.AdditionData = function(cfg) {
	cfg = cfg || {};
	/** @cfg {String} [title="����̨"] ����*/
	this.title = cfg['title'] || '��������';
	this.payMode = cfg['payMode'] || '';
	this.patientId = cfg['patientId'] || '';
};

//����һ���鼶������
(function() {
	
	//˽�г�Ա����
	var _titel = "";
	var _payMode = "";
	var _patientId = "";
	
	//˽�з���
	/**
	* ��ʼ������
	* 	��Ҫ�����ã�����֧����ʽ��ʾ������Ϣ
	*/
	var _initPanel = function() {
		//����֧����ʽȡ�丽������ -- ��Ҫ�����ã���д��
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
	
	//���з���
	/**
	* ��ʾ����
	* @return {Boolean} true-�ɹ���false-ʧ��
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
				//����
				$HUI.combobox("#Bank", {
					panelHeight: 150,
					url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson',
					method: 'GET',
					valueField: 'id',
					textField: 'text',
					blurValidValue: true,
					defaultFilter: 4
				});
				
				//���ѵ�λ
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
							var inputs = $container.find(inputsSelector);  //��ȡ���������
							var idx = inputs.index(this);   //��ȡ��ǰ������λ������
							var step = 1;
							if (idx == inputs.length - 1) {
								//�ж��Ƿ������һ�������
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
				//չ������ѡ��򼰸�ѡ��������б�����������--�ṩһ��˼·���ο�
				var inputsSelector = ".paym-additional .combo-text,.paym-additional .combo-arrow:first-child,.paym-additional .item-textbox";  //
				console.log($container.find(inputsSelector));
				$container.find(inputsSelector).each(function(index,ele){
					$(this).on('keydown',function(e){
						var key = websys_getKey(e);
						if (key == 13) {
							var inputs = $container.find(inputsSelector);  //��ȡ���������
							var idx = inputs.index(this); //��ȡ��ǰ������λ������
							var step = 1;
							if (idx == inputs.length - 1) {
								//�ж��Ƿ������һ�������	
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
					text: 'ȷ��',
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
								$.messager.popover({msg: "������<font color=red>" + $(this).text() + "</font>", type: "info"});
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
					text: '�ر�',
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