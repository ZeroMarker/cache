 /// 名称:系统配置 - 安全组系统配置-医嘱与结果2
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20


Ext.onReady(function() {	
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
		labelWidth : 80,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'OECFAllowConcurrentOrders',mapping:'OECFAllowConcurrentOrders'},
                                        {name: 'OECFAllowActiveOrdersAdmDates',mapping:'OECFAllowActiveOrdersAdmDates'},
                                        {name: 'OECFDiscontExecutedOrder',mapping:'OECFDiscontExecutedOrder'},
                                        {name: 'OECFAllowPlaceOrderOutsideEpisD',mapping:'OECFAllowPlaceOrderOutsideEpisD'},
                                        {name: 'OECFDefaultOSItemBillingPriceBl',mapping:'OECFDefaultOSItemBillingPriceBl'},
                                        {name: 'OECFChangeLinkedOnUpdate',mapping:'OECFChangeLinkedOnUpdate'},
                                        {name: 'OECFCheckOrdersCovered',mapping:'OECFCheckOrdersCovered'},
                                        {name: 'OECFClearOrdersOnUpdate',mapping:'OECFClearOrdersOnUpdate'},
                                        {name: 'OECFCreate1OrderPerToothFace',mapping:'OECFCreate1OrderPerToothFace'},
                                        {name: 'OECFCreate1OrderPerSpecimen',mapping:'OECFCreate1OrderPerSpecimen'},
                                        {name: 'OECFCreateReturnQueueDisch',mapping:'OECFCreateReturnQueueDisch'},
                                        {name: 'OECFDefaultCheckBsUnselect',mapping:'OECFDefaultCheckBsUnselect'},
                                        {name: 'OECFDisableAddForQtyBlank',mapping:'OECFDisableAddForQtyBlank'},
                                        {name: 'OECFDiscontinueOverlapExTime',mapping:'OECFDiscontinueOverlapExTime'},
                                       {name: 'OECFDisplayDuplDosageTextBox',mapping:'OECFDisplayDuplDosageTextBox'},
                                      
                                        {name: 'OECFNoDefaultPatLocOnOE',mapping:'OECFNoDefaultPatLocOnOE'},
                                        {name: 'OECFNoShowLabEpForAllOrdersIPES',mapping:'OECFNoShowLabEpForAllOrdersIPES'},
                                        {name: 'OECFNoShowReorderNurseWB',mapping:'OECFNoShowReorderNurseWB'},
                                        {name: 'OECFAllowPackUOM',mapping:'OECFAllowPackUOM'},
                                        {name: 'OECFEditNotes',mapping:'OECFEditNotes'},
                                        {name: 'OECFExecuteFutureOrders',mapping:'OECFExecuteFutureOrders'},
                                        {name: 'OECFGenerateExecSchedOutpat',mapping:'OECFGenerateExecSchedOutpat'},
                                        {name: 'OECFIgnorePriorityDEf',mapping:'OECFIgnorePriorityDEf'},
                                        {name: 'OECFKeepPriorDateSession',mapping:'OECFKeepPriorDateSession'},
                                        {name: 'OECFManualVerifLabOrders',mapping:'OECFManualVerifLabOrders'},
                                         {name: 'OECFShowSnomedCodes',mapping:'OECFShowSnomedCodes'},
                                        {name: 'OECFWarnQtyRangeDuration',mapping:'OECFWarnQtyRangeDuration'},
                                        {name: 'OECFSaveOrderCategory',mapping:'OECFSaveOrderCategory'},
                                        {name: 'OECFShowDisOrdersResults',mapping:'OECFShowDisOrdersResults'},
                                        {name: 'OECFShowAllergyDSSQA',mapping:'OECFShowAllergyDSSQA'},
                                        {name: 'OECFShowDeliveryInfoOnPin',mapping:'OECFShowDeliveryInfoOnPin'},
                                        {name: 'OECFUsePreprintedLabelsLab',mapping:'OECFUsePreprintedLabelsLab'}
                                 ]),
		
		items:[{
				  
				
				boxLabel:'Allow Concurrent Orders',
				xtype : 'checkbox',
				name : 'OECFAllowConcurrentOrders',
				id:'OECFAllowConcurrentOrders',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAllowConcurrentOrders'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAllowConcurrentOrders')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow definition of Active Orders other than Active for today',
				xtype : 'checkbox',
				name : 'OECFAllowActiveOrdersAdmDates',
				id:'OECFAllowActiveOrdersAdmDates',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAllowActiveOrdersAdmDates'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAllowActiveOrdersAdmDates')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow Discontinue Executed Orders',
				xtype : 'checkbox',
				name : 'OECFDiscontExecutedOrder',
				id:'OECFDiscontExecutedOrder',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDiscontExecutedOrder'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDiscontExecutedOrder')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow Place Order Outside Episode Dates',
				xtype : 'checkbox',
				name : 'OECFAllowPlaceOrderOutsideEpisD',
				id:'OECFAllowPlaceOrderOutsideEpisD',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAllowPlaceOrderOutsideEpisD'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAllowPlaceOrderOutsideEpisD')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'always Default billing price to blank for OS price Items',
				xtype : 'checkbox',
				name : 'OECFDefaultOSItemBillingPriceBl',
				id:'OECFDefaultOSItemBillingPriceBl',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDefaultOSItemBillingPriceBl'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDefaultOSItemBillingPriceBl')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Change Linked Orders details on Update',
				xtype : 'checkbox',
				name : 'OECFChangeLinkedOnUpdate',
				id:'OECFChangeLinkedOnUpdate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFChangeLinkedOnUpdate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFChangeLinkedOnUpdate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Check Orders isCovered',
				xtype : 'checkbox',
				name : 'OECFCheckOrdersCovered',
				id:'OECFCheckOrdersCovered',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFCheckOrdersCovered'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFCheckOrdersCovered')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Clear Orders entry screen On Update',
				xtype : 'checkbox',
				name : 'OECFClearOrdersOnUpdate',
				id:'OECFClearOrdersOnUpdate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFClearOrdersOnUpdate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFClearOrdersOnUpdate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Create one Order Per selected Tooth Face',
				xtype : 'checkbox',
				name : 'OECFCreate1OrderPerToothFace',
				id:'OECFCreate1OrderPerToothFace',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFCreate1OrderPerToothFace'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFCreate1OrderPerToothFace')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Create one Orders Per Specimen',
				xtype : 'checkbox',
				name : 'OECFCreate1OrderPerSpecimen',
				id:'OECFCreate1OrderPerSpecimen',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFCreate1OrderPerSpecimen'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFCreate1OrderPerSpecimen')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Create Return Queue upon Discharge',
				xtype : 'checkbox',
				name : 'OECFCreateReturnQueueDisch',
				id:'OECFCreateReturnQueueDisch',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFCreateReturnQueueDisch'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFCreateReturnQueueDisch')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'DefaultCheckBoxes on order set list to Unselected',
				xtype : 'checkbox',
				name : 'OECFDefaultCheckBsUnselect',
				id:'OECFDefaultCheckBsUnselect',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDefaultCheckBsUnselect'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDefaultCheckBsUnselect')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Disable Add on OE if Quantity to canculate by user is blank',
				xtype : 'checkbox',
				name : 'OECFDisableAddForQtyBlank',
				id:'OECFDisableAddForQtyBlank',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDisableAddForQtyBlank'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDisableAddForQtyBlank')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Discontinue Overlapping Execution Times',
				xtype : 'checkbox',
				name : 'OECFDiscontinueOverlapExTime',
				id:'OECFDiscontinueOverlapExTime',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDiscontinueOverlapExTime'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDiscontinueOverlapExTime')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Display duplicate dosage text box',
				xtype : 'checkbox',
				name : 'OECFDisplayDuplDosageTextBox',
				id:'OECFDisplayDuplDosageTextBox',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDisplayDuplDosageTextBox'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDisplayDuplDosageTextBox')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot Default Patient Location On OE',
				xtype : 'checkbox',
				name : 'OECFNoDefaultPatLocOnOE',
				id:'OECFNoDefaultPatLocOnOE',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFNoDefaultPatLocOnOE'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFNoDefaultPatLocOnOE')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot Show Lab Episode when All Orders are IP or E status',
				xtype : 'checkbox',
				name : 'OECFNoShowLabEpForAllOrdersIPES',
				id:'OECFNoShowLabEpForAllOrdersIPES',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFNoShowLabEpForAllOrdersIPES'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFNoShowLabEpForAllOrdersIPES')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot Show Reorder warning in Nurse WB',
				xtype : 'checkbox',
				name : 'OECFNoShowReorderNurseWB',
				id:'OECFNoShowReorderNurseWB',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFNoShowReorderNurseWB'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFNoShowReorderNurseWB')),
				inputValue : true?'Y':'N',
				checked:false
			
			}
			
			
			,{
				
				boxLabel:'enter a packing UOM of any value',
				xtype : 'checkbox',
				name : 'OECFAllowPackUOM',
				id:'OECFAllowPackUOM',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAllowPackUOM'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAllowPackUOM')),
				inputValue : true?'Y':'N',
				checked:false
			      
			},{
				boxLabel:'enter/edit access to notes in order entry',
				xtype : 'checkbox',
				name : 'OECFEditNotes',
				id:'OECFEditNotes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFEditNotes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFEditNotes')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Execute Future Orders',
				xtype : 'checkbox',
				name : 'OECFExecuteFutureOrders',
				id:'OECFExecuteFutureOrders',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteFutureOrders'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteFutureOrders')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Generate Execution times for Outpatients',
				xtype : 'checkbox',
				name : 'OECFGenerateExecSchedOutpat',
				id:'OECFGenerateExecSchedOutpat',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFGenerateExecSchedOutpat'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFGenerateExecSchedOutpat')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Ignore system default settings for Priority&start Date',
				xtype : 'checkbox',
				name : 'OECFIgnorePriorityDEf',
				id:'OECFIgnorePriorityDEf',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFIgnorePriorityDEf'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFIgnorePriorityDEf')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Keep Priority and start Date/time during ordering Session',
				xtype : 'checkbox',
				name : 'OECFKeepPriorDateSession',
				id:'OECFKeepPriorDateSession',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFKeepPriorDateSession'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFKeepPriorDateSession')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Manual Verification of Lab Orders',
				xtype : 'checkbox',
				name : 'OECFManualVerifLabOrders',
				id:'OECFManualVerifLabOrders',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFManualVerifLabOrders'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFManualVerifLabOrders')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'promt for Snomed Code in order entry',
				xtype : 'checkbox',
				name : 'OECFShowSnomedCodes',
				id:'OECFShowSnomedCodes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFShowSnomedCodes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFShowSnomedCodes')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Quantity Range message include Duration',
				xtype : 'checkbox',
				name : 'OECFWarnQtyRangeDuration',
				id:'OECFWarnQtyRangeDuration',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFWarnQtyRangeDuration'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFWarnQtyRangeDuration')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'return Order Category after adding orders',
				xtype : 'checkbox',
				name : 'OECFSaveOrderCategory',
				id:'OECFSaveOrderCategory',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFSaveOrderCategory'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFSaveOrderCategory')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show Discontinued Orders with Results',
				xtype : 'checkbox',
				name : 'OECFShowDisOrdersResults',
				id:'OECFShowDisOrdersResults',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFShowDisOrdersResults'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFShowDisOrdersResults')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show Allergy/DSS/QA on update',
				xtype : 'checkbox',
				name : 'OECFShowAllergyDSSQA',
				id:'OECFShowAllergyDSSQA',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFShowAllergyDSSQA'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFShowAllergyDSSQA')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show result Delivery On Pin No form',
				xtype : 'checkbox',
				name : 'OECFShowDeliveryInfoOnPin',
				id:'OECFShowDeliveryInfoOnPin',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFShowDeliveryInfoOnPin'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFShowDeliveryInfoOnPin')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Preprinted Labels for Lab',
				xtype : 'checkbox',
				name : 'OECFUsePreprintedLabelsLab',
				id:'OECFUsePreprintedLabelsLab',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFUsePreprintedLabelsLab'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFUsePreprintedLabelsLab')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntityorders2&pEntityName=web.Entity.CT.SystemParameter";
	
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