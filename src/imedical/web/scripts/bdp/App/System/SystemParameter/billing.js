 /// 名称:系统配置 - 安全组系统配置-计费和出纳
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   	var CTCFPayMode_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTPayMode&pClassQuery=GetDataForCmb1";
	var CFCTCTCURDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetCTCurrency";
    var PATCFStampDutyChargeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	var PATCFDefaultTariffDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetARCTariff";
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
	var formSearch = new Ext.form.FormPanel({
		frame:true,
		autoScroll:true,///滚动条
		border:false,
		region: 'center',
		width:500,
		iconCls:'icon-find',
		///collapsible:true,
		split: true,
		//bodyStyle:'padding:5px 5px 0',
		//baseCls:'x-plain',
		buttonAlign:'center',
		labelAlign : 'right',
		labelWidth : 160,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'CTCFPayMode',mapping:'CTCFPayMode'},
                                        {name: 'CTCFCTCURDR',mapping:'CTCFCTCURDR'},
                                        {name: 'OECFInpatientBilling',mapping:'OECFInpatientBilling'},
                                        {name: 'PATCFPriceToDisplayOnRB',mapping:'PATCFPriceToDisplayOnRB'},
                                        {name: 'PATCFStampDutyChargeDR',mapping:'PATCFStampDutyChargeDR'},
                                        {name: 'PATCFDefaultTariffDR',mapping:'PATCFDefaultTariffDR'},
                                        {name: 'PATCFAllowPartialPaymentPayorBi',mapping:'PATCFAllowPartialPaymentPayorBi'},
                                        {name: 'PATCFApplyMaxPatDiscount',mapping:'PATCFApplyMaxPatDiscount'},
                                        {name: 'PATCFApplyNewRoomRates',mapping:'PATCFApplyNewRoomRates'},
                                        {name: 'PATCFCompleteOnZeroBills',mapping:'PATCFCompleteOnZeroBills'},
                                        {name: 'PATCFConvertCurrencyInBilling',mapping:'PATCFConvertCurrencyInBilling'},
                                        {name: 'PATCFDisableMultiselectBills',mapping:'PATCFDisableMultiselectBills'},
                                        {name: 'PATCFCashRecptDiscntReadOnly',mapping:'PATCFCashRecptDiscntReadOnly'},
                                        {name: 'PATCFEligMechVentCopayment',mapping:'PATCFEligMechVentCopayment'},
                                        {name: 'PATCFEligMechVentCopaymentNICU',mapping:'PATCFEligMechVentCopaymentNICU'},
                                        {name: 'PATCFAllowDirectCashPayment',mapping:'PATCFAllowDirectCashPayment'},
                                        {name: 'CTCFChequeDate',mapping:'CTCFChequeDate'},
                                       // {name: 'PATCFEnableMultipleDiscountsOut',mapping:'PATCFEnableMultipleDiscountsOut'},
                                        {name: 'CTCFMultipleCurr',mapping:'CTCFMultipleCurr'},
                                        {name: 'PATCFOTCPayor',mapping:'PATCFOTCPayor'},
                                        {name: 'PATCFReasonCancelBill',mapping:'PATCFReasonCancelBill'},
                                        {name: 'PATCFRefreshCashiierAfterOE',mapping:'PATCFRefreshCashiierAfterOE'},
                                        {name: 'PATCFRestrictNegOutsAmt',mapping:'PATCFRestrictNegOutsAmt'},
                                        {name: 'PATCFSameBillPatientPayor',mapping:'PATCFSameBillPatientPayor'}
                                        
                                 ]),
		
		items:[
			{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '收银时默认支付方式',
				hiddenName : 'CTCFPayMode',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCFPayMode'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCFPayMode')),
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : CTCFPayMode_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTPMRowId',mapping:'CTPMRowId'},
							{name:'CTPMDesc',mapping:'CTPMDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTPMDesc',
				valueField : 'CTPMRowId'
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '默认系统货币',
				hiddenName : 'CTCFCTCURDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCFCTCURDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCFCTCURDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTCURDesc',
				valueField : 'CTCURRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : CFCTCTCURDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTCURRowId',mapping:'CTCURRowId'},
							{name:'CTCURDesc',mapping:'CTCURDesc'} ])
					})
			},{
				xtype : "combo",
				//emptyText:'请选择',
				fieldLabel : '住院收费逻辑',
				hiddenName : 'OECFInpatientBilling',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFInpatientBilling'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFInpatientBilling')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'Bill Upon Ordering',
								value : 'BUO'
							}, {
								name : 'Bill Upon Execution',
								value : 'BUE'
							}]
				})
			},{
				xtype : "combo",
				//emptyText:'请选择',
				fieldLabel : '预约时显示的价格',
				hiddenName : 'PATCFPriceToDisplayOnRB',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPriceToDisplayOnRB'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPriceToDisplayOnRB')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'Italian Price',
								value : 'I'
							}, {
								name : 'Default Tariff',
								value : 'T'
							}]
				})	
			
				
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '计费时使用的印花税费',
				hiddenName : 'PATCFStampDutyChargeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFStampDutyChargeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFStampDutyChargeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'ARCIMDesc',
				valueField : 'ARCIMRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFStampDutyChargeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'ARCIMRowId',mapping:'ARCIMRowId'},
							{name:'ARCIMDesc',mapping:'ARCIMDesc'} ])
					})
			
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '用于所有订单的关税',
				hiddenName : 'PATCFDefaultTariffDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDefaultTariffDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDefaultTariffDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'TARDesc',
				valueField : 'TARRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFDefaultTariffDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'TARRowId',mapping:'TARRowId'},
							{name:'TARDesc',mapping:'TARDesc'} ])
					})
			
			
			}
			,{
				boxLabel:'在付款人计费管理时允许部分支付',
				xtype : 'checkbox',
				name : 'PATCFAllowPartialPaymentPayorBi', //ll
				id:'PATCFAllowPartialPaymentPayorBi',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowPartialPaymentPayorBi'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowPartialPaymentPayorBi')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'对病人使用最大付款人折扣',
				xtype : 'checkbox',
				name : 'PATCFApplyMaxPatDiscount',
				id:'PATCFApplyMaxPatDiscount',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFApplyMaxPatDiscount'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFApplyMaxPatDiscount')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'对已存在的病人应用新的房费',
				xtype : 'checkbox',
				name : 'PATCFApplyNewRoomRates',
				id:'PATCFApplyNewRoomRates',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFApplyNewRoomRates'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFApplyNewRoomRates')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'完成零收费项',
				xtype : 'checkbox',
				name : 'PATCFCompleteOnZeroBills',
				id:'PATCFCompleteOnZeroBills',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCompleteOnZeroBills'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCompleteOnZeroBills')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'计费时转换货币',
				xtype : 'checkbox',
				name : 'PATCFConvertCurrencyInBilling',
				id:'PATCFConvertCurrencyInBilling',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFConvertCurrencyInBilling'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFConvertCurrencyInBilling')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'计费多选不可用',
				xtype : 'checkbox',
				name : 'PATCFDisableMultiselectBills',
				id:'PATCFDisableMultiselectBills',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDisableMultiselectBills'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDisableMultiselectBills')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'对于已存在的收据，显示自由折扣且自由折扣配置按钮为只读模式',
				xtype : 'checkbox',
				name : 'PATCFCashRecptDiscntReadOnly',
				id:'PATCFCashRecptDiscntReadOnly',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCashRecptDiscntReadOnly'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCashRecptDiscntReadOnly')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'机械通风设备费用均摊可选(重症监护病房)',
				xtype : 'checkbox',
				name : 'PATCFEligMechVentCopayment',
				id:'PATCFEligMechVentCopayment',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFEligMechVentCopayment'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFEligMechVentCopayment')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'机械通风设备费用均摊可选(新生儿监护病房)',
				xtype : 'checkbox',
				name : 'PATCFEligMechVentCopaymentNICU',
				id:'PATCFEligMechVentCopaymentNICU',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFEligMechVentCopaymentNICU'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFEligMechVentCopaymentNICU')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'收银时允许现金支付',
				xtype : 'checkbox',
				name : 'PATCFAllowDirectCashPayment',
				id:'PATCFAllowDirectCashPayment',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowDirectCashPayment'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowDirectCashPayment')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'收银时允许支票支付.',
				xtype : 'checkbox',
				name : 'CTCFChequeDate',
				id:'CTCFChequeDate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCFChequeDate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCFChequeDate')),
				inputValue : true?'Y':'N',
				checked:false
			/*},{
				boxLabel:'每笔账单允许多选折扣.',
				xtype : 'checkbox',
				name : 'PATCFEnableMultipleDiscountsOut',
				id:'PATCFEnableMultipleDiscountsOut',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFEnableMultipleDiscountsOut'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFEnableMultipleDiscountsOut')),
				inputValue : true?'Y':'N',
				checked:false*/
			},{
				boxLabel:'收银时多种货币支付',
				xtype : 'checkbox',
				name : 'CTCFMultipleCurr',
				id:'CTCFMultipleCurr',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCFMultipleCurr'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCFMultipleCurr')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'销售非处方药时提示支付者',
				xtype : 'checkbox',
				name : 'PATCFOTCPayor',
				id:'PATCFOTCPayor',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFOTCPayor'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFOTCPayor')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'完全取消账单的理由.',
				xtype : 'checkbox',
				name : 'PATCFReasonCancelBill',
				id:'PATCFReasonCancelBill',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFReasonCancelBill'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFReasonCancelBill')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'从订单更新刷新出纳.',
				xtype : 'checkbox',
				name : 'PATCFRefreshCashiierAfterOE',
				id:'PATCFRefreshCashiierAfterOE',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRefreshCashiierAfterOE'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRefreshCashiierAfterOE')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'限制负余额',
				xtype : 'checkbox',
				name : 'PATCFRestrictNegOutsAmt',
				id:'PATCFRestrictNegOutsAmt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictNegOutsAmt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictNegOutsAmt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'病人和付款人使用相同的账单',
				xtype : 'checkbox',
				name : 'PATCFSameBillPatientPayor',
				id:'PATCFSameBillPatientPayor',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSameBillPatientPayor'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSameBillPatientPayor')),
				inputValue : true?'Y':'N',
				checked:false
			
			}
			
			
		]
	
		,
		buttons: [{
			text: '保存',
			iconCls : 'icon-save',
			id:'savepanel',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('savepanel'),
      		handler: function (){ 
      			///alert("ss");
				formSearch.form.submit({
						url : SystemParameter_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST', 
						success : function(form, action) {
							if (action.result.success == 'true') {
								
								Ext.Msg.show({
											title : '提示',
											msg : '设置成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '设置失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '设置失败！');
						}
					})
      			
      			
      			
      	} 
		}]
	});
	
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=GetSysPara";
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitybilling&pEntityName=web.Entity.CT.SystemParameter";
	
	// 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
      
            formSearch.form.load( {
                url : OPEN_ACTION_URL ,///+'id=',
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	///alert("sssssss");
                },
                failure : function(form,action) {
                	Ext.Msg.alert('提示','载入失败！');
                }
            });
         
    };	
    loadFormData();
    
    
	
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch]
    });
	
	});