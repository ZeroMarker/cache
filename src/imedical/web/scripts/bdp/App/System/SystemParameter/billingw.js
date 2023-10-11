 /// 名称:系统配置 - 安全组系统配置-计费和出纳
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');


Ext.onReady(function() {	
   
   	var PATCFRoundingPaymentAdjustmentDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetARCReasonWriteOff";
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
                                        {name: 'PATCFTitleOfDeceasedPat',mapping:'PATCFTitleOfDeceasedPat'},
                                        {name: 'PATCFParentGuardianTitle',mapping:'PATCFParentGuardianTitle'},
                                        {name: 'PATCFAgeCutOffMinors',mapping:'PATCFAgeCutOffMinors'},
                                        {name: 'PATCFInvoiceRounding',mapping:'PATCFInvoiceRounding'},
                                        {name: 'PATCFRoundingAmount',mapping:'PATCFRoundingAmount'},
                                        {name: 'PATCFRoundingPaymentAdjustmentD',mapping:'PATCFRoundingPaymentAdjustmentD'},
                                        {name: 'PATCFTimeRoomChargeApply',mapping:'PATCFTimeRoomChargeApply'},
                                        {name: 'PATCFDepositAllocAlert',mapping:'PATCFDepositAllocAlert'},
                                        {name: 'PATCFAddLinkedPlansOnAdm',mapping:'PATCFAddLinkedPlansOnAdm'},
                                        {name: 'PATCFAllowPartialPaymentSystemB',mapping:'PATCFAllowPartialPaymentSystemB'},
                                        {name: 'PATCFMotherBabyEpisAutoLink',mapping:'PATCFMotherBabyEpisAutoLink'},
                                        {name: 'OECFBillAdminDrugs',mapping:'OECFBillAdminDrugs'},
                                        {name: 'PATCFCopyPayorPlanFromPrevAdm',mapping:'PATCFCopyPayorPlanFromPrevAdm'},
                                        {name: 'PATCFCopyPayorPlanDetFromPrevAd',mapping:'PATCFCopyPayorPlanDetFromPrevAd'},
                                        {name: 'PATCFShowZeroBillsUnpaid',mapping:'PATCFShowZeroBillsUnpaid'},
                                        {name: 'PATCFLinkEDOUTEpisToIP',mapping:'PATCFLinkEDOUTEpisToIP'},
                                        {name: 'PATCFLastCPPaidForED',mapping:'PATCFLastCPPaidForED'},
                                        {name: 'PATCFShowNegativeInvUnpaid',mapping:'PATCFShowNegativeInvUnpaid'},
                                        {name: 'PATCFStoreAppPayPlanOverAdm',mapping:'PATCFStoreAppPayPlanOverAdm'},
                                        {name: 'PATCFTenderPayment',mapping:'PATCFTenderPayment'},
                                        {name: 'PATCFUseCRAFTFunctionality',mapping:'PATCFUseCRAFTFunctionality'},
                                        {name: 'PATCFUseWIESVICDRGFunction',mapping:'PATCFUseWIESVICDRGFunction'}
                                 ]),
		
		items:[
			
			{
				fieldLabel : '对死亡病人的称呼',
				xtype:'textfield',
				id:'PATCFTitleOfDeceasedPat',
				maxLength:80,
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTitleOfDeceasedPat'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTitleOfDeceasedPat')),
				name : 'PATCFTitleOfDeceasedPat'
			},{
				fieldLabel : '对父母或监护人的称呼',
				xtype:'textfield',
				maxLength:50,
				width:200,
				id:'PATCFParentGuardianTitle',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFParentGuardianTitle'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFParentGuardianTitle')),
				name : 'PATCFParentGuardianTitle'
			},{
				fieldLabel : '未成年人截止年龄',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'PATCFAgeCutOffMinors',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAgeCutOffMinors'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAgeCutOffMinors')),
				name : 'PATCFAgeCutOffMinors'
			},{
				fieldLabel : '单据四舍五入',
				xtype:'numberfield',
				width:200,
				name : 'PATCFInvoiceRounding',
				id:'PATCFInvoiceRounding',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFInvoiceRounding'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFInvoiceRounding'))
				
			},{
				fieldLabel : '总额四舍五入',
				width:200,
				xtype:'numberfield',
				id:'PATCFRoundingAmount',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRoundingAmount'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRoundingAmount')),
				name : 'PATCFRoundingAmount'
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				width:200,
				//emptyText:'请选择',
				fieldLabel : '四舍五入付款校准',
				hiddenName : 'PATCFRoundingPaymentAdjustmentD',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRoundingPaymentAdjustmentD'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRoundingPaymentAdjustmentD')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'RWDesc',
				valueField : 'RWRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFRoundingPaymentAdjustmentDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'RWRowId',mapping:'RWRowId'},
							{name:'RWDesc',mapping:'RWDesc'} ])
					})
				
			},{
				fieldLabel : '房间收费时间',
				xtype:'timefield',
				format:'H:i:s',
				width:200,
				id:'PATCFTimeRoomChargeApply',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTimeRoomChargeApply'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTimeRoomChargeApply')),
				name : 'PATCFTimeRoomChargeApply'
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : '押金配置警报类型',
				hiddenName : 'PATCFDepositAllocAlert',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDepositAllocAlert'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDepositAllocAlert')),
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
								name : 'No Message',
								value : 'NM'
							}, {
								name : 'Warning Message',
								value : 'WN'
							}, {
								name : 'Fatal Error',
								value : 'FE'
							}]
				})	
				
			},{
				boxLabel:'add linked plans on admission',
				xtype : 'checkbox',
				name : 'PATCFAddLinkedPlansOnAdm',
				id:'PATCFAddLinkedPlansOnAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAddLinkedPlansOnAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAddLinkedPlansOnAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'系统计费管理时允许部分支付',
				xtype : 'checkbox',
				name : 'PATCFAllowPartialPaymentSystemB',
				id:'PATCFAllowPartialPaymentSystemB',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowPartialPaymentSystemB'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowPartialPaymentSystemB')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'自动关联母亲和婴儿.',
				xtype : 'checkbox',
				name : 'PATCFMotherBabyEpisAutoLink',
				id:'PATCFMotherBabyEpisAutoLink',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMotherBabyEpisAutoLink'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMotherBabyEpisAutoLink')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'把管理的药品登记入账',
				xtype : 'checkbox',
				name : 'OECFBillAdminDrugs',
				id:'OECFBillAdminDrugs',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFBillAdminDrugs'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFBillAdminDrugs')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'取消账单时取消支付',
				xtype : 'checkbox',
				name : 'PATCFCancelPaymUponCancelBill',
				id:'PATCFCancelPaymUponCancelBill',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCancelPaymUponCancelBill'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCancelPaymUponCancelBill')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'copy payor/plan from previous episode',
				xtype : 'checkbox',
				name : 'PATCFCopyPayorPlanFromPrevAdm',
				id:'PATCFCopyPayorPlanFromPrevAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyPayorPlanFromPrevAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyPayorPlanFromPrevAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'copy payor/plan details from previous episode',
				xtype : 'checkbox',
				name : 'PATCFCopyPayorPlanDetFromPrevAd',
				id:'PATCFCopyPayorPlanDetFromPrevAd',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyPayorPlanDetFromPrevAd'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyPayorPlanDetFromPrevAd')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'不支付的时候包括零收费项',
				xtype : 'checkbox',
				name : 'PATCFShowZeroBillsUnpaid',
				id:'PATCFShowZeroBillsUnpaid',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowZeroBillsUnpaid'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowZeroBillsUnpaid')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'link ED/Out episode to inpatient episode',
				xtype : 'checkbox',
				name : 'PATCFLinkEDOUTEpisToIP',
				id:'PATCFLinkEDOUTEpisToIP',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLinkEDOUTEpisToIP'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLinkEDOUTEpisToIP')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				///右边
				boxLabel:'only last CP paid for ED',
				xtype : 'checkbox',
				name : 'PATCFLastCPPaidForED',
				id:'PATCFLastCPPaidForED',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLastCPPaidForED'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLastCPPaidForED')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'当支付参数为Yes时显示负的单据',
				xtype : 'checkbox',
				name : 'PATCFShowNegativeInvUnpaid',
				id:'PATCFShowNegativeInvUnpaid',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowNegativeInvUnpaid'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowNegativeInvUnpaid')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'stre appointment payor/plan as override if payor/plan exists at episode',
				xtype : 'checkbox',
				name : 'PATCFStoreAppPayPlanOverAdm',
				id:'PATCFStoreAppPayPlanOverAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFStoreAppPayPlanOverAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFStoreAppPayPlanOverAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'招标付款',
				xtype : 'checkbox',
				name : 'PATCFTenderPayment',
				id:'PATCFTenderPayment',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTenderPayment'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTenderPayment')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'use craft functionality',
				xtype : 'checkbox',
				name : 'PATCFUseCRAFTFunctionality',
				id:'PATCFUseCRAFTFunctionality',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseCRAFTFunctionality'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseCRAFTFunctionality')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'use WIES&VIC-DRG functionality',
				xtype : 'checkbox',
				name : 'PATCFUseWIESVICDRGFunction',
				id:'PATCFUseWIESVICDRGFunction',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseWIESVICDRGFunction'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseWIESVICDRGFunction')),
				inputValue : true?'Y':'N',
				checked:false
			
			}
			
		]
	
		,
		buttons: [{
			text: '保存',
			iconCls : 'icon-save',
			width: 100,
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitybillingw&pEntityName=web.Entity.CT.SystemParameter";
	
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