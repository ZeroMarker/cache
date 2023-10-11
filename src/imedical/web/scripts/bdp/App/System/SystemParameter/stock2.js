 /// 名称:系统配置 - 安全组系统配置-库存2
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
                                        {name: 'INCFAllowMixedTax',mapping:'INCFAllowMixedTax'},
                                        {name: 'INCFNegStk',mapping:'INCFNegStk'},
                                        {name: 'INCFRecvMoreRequest',mapping:'INCFRecvMoreRequest'},
                                        {name: 'INCFDefaultAvePriceOnStRec',mapping:'INCFDefaultAvePriceOnStRec'},
                                        {name: 'INCFAlwaysDefaultToTransfer',mapping:'INCFAlwaysDefaultToTransfer'},
                                        {name: 'INCFDocketDateMandStockRec',mapping:'INCFDocketDateMandStockRec'},
                                        {name: 'INCFDontUpdateStItemCode',mapping:'INCFDontUpdateStItemCode'},
                                        {name: 'INCFRestrictDrugMOrdersByLoc',mapping:'INCFRestrictDrugMOrdersByLoc'},
                                        {name: 'INCFIgnoreOETax',mapping:'INCFIgnoreOETax'},
                                        {name: 'INCFNoSearchByAnyPart',mapping:'INCFNoSearchByAnyPart'},
                                        {name: 'INCFPromptCommercialNameOnPO',mapping:'INCFPromptCommercialNameOnPO'},
                                        {name: 'INCFRecalculateReorderLevel',mapping:'INCFRecalculateReorderLevel'},
                                        {name: 'INCFRecalculateReplenishLevel',mapping:'INCFRecalculateReplenishLevel'},
                                        {name: 'INCFRestrictPObyPOType',mapping:'INCFRestrictPObyPOType'},
                                        {name: 'INCFRestrictTransferSTKGroup',mapping:'INCFRestrictTransferSTKGroup'},
                                        {name: 'INCFReturnNonPharmacyDiscon',mapping:'INCFReturnNonPharmacyDiscon'},
                                        {name: 'INCFReturnPharmStockDiscon',mapping:'INCFReturnPharmStockDiscon'},
                                        {name: 'INCFShowZeroBatchesSTK',mapping:'INCFShowZeroBatchesSTK'},
                                        {name: 'INCFSkipNoStockItemsonAddAll',mapping:'INCFSkipNoStockItemsonAddAll'},
                                        {name: 'INCFStReqDoNotAllowMultItems',mapping:'INCFStReqDoNotAllowMultItems'},
                                        {name: 'INCFStTakeGDFNewWay',mapping:'INCFStTakeGDFNewWay'},
                                        {name: 'INCFStTakeNoCountQtyDefault',mapping:'INCFStTakeNoCountQtyDefault'},
                                        {name: 'INCFStTkSecondCountRequired',mapping:'INCFStTkSecondCountRequired'},
                                        {name: 'INCFStTransFormatNumber',mapping:'INCFStTransFormatNumber'},
                                        {name: 'INCFTransDecimalRestrict',mapping:'INCFTransDecimalRestrict'},
                                        {name: 'INCFTransAckReasonMandatory',mapping:'INCFTransAckReasonMandatory'},
                                        {name: 'INCFAckFlag',mapping:'INCFAckFlag'},
                                        {name: 'INCFUnifyTakeNAdjustment',mapping:'INCFUnifyTakeNAdjustment'},
                                        {name: 'INCFUpdateARCost',mapping:'INCFUpdateARCost'},
                                        {name: 'INCFUseStkLocRestrInquiry',mapping:'INCFUseStkLocRestrInquiry'}
                                 ]),
		
		items:[
			{
				
				boxLabel:'Allow Mixed Taxes',
				xtype : 'checkbox',
				name : 'INCFAllowMixedTax',
				id:'INCFAllowMixedTax',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFAllowMixedTax'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFAllowMixedTax')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow Negetive Stock',
				xtype : 'checkbox',
				name : 'INCFNegStk',
				id:'INCFNegStk',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFNegStk'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFNegStk')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow receive More than Requested',
				xtype : 'checkbox',
				name : 'INCFRecvMoreRequest',
				id:'INCFRecvMoreRequest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFRecvMoreRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFRecvMoreRequest')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'default average price on stock receive',
				xtype : 'checkbox',
				name : 'INCFDefaultAvePriceOnStRec',
				id:'INCFDefaultAvePriceOnStRec',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFDefaultAvePriceOnStRec'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFDefaultAvePriceOnStRec')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Default issue/Transfer to transfer',
				xtype : 'checkbox',
				name : 'INCFAlwaysDefaultToTransfer',
				id:'INCFAlwaysDefaultToTransfer',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFAlwaysDefaultToTransfer'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFAlwaysDefaultToTransfer')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Docket Date is Mandatory',
				xtype : 'checkbox',
				name : 'INCFDocketDateMandStockRec',
				id:'INCFDocketDateMandStockRec',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFDocketDateMandStockRec'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFDocketDateMandStockRec')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Donot allow Update Stock Item Code',
				xtype : 'checkbox',
				name : 'INCFDontUpdateStItemCode',
				id:'INCFDontUpdateStItemCode',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFDontUpdateStItemCode'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFDontUpdateStItemCode')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'drugs manufacture:Restrict Orders list to selected location',
				xtype : 'checkbox',
				name : 'INCFRestrictDrugMOrdersByLoc',
				id:'INCFRestrictDrugMOrdersByLoc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFRestrictDrugMOrdersByLoc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFRestrictDrugMOrdersByLoc')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Ignore Order item Tax',
				xtype : 'checkbox',
				name : 'INCFIgnoreOETax',
				id:'INCFIgnoreOETax',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFIgnoreOETax'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFIgnoreOETax')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'No context Search',
				xtype : 'checkbox',
				name : 'INCFNoSearchByAnyPart',
				id:'INCFNoSearchByAnyPart',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFNoSearchByAnyPart'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFNoSearchByAnyPart')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'prompt Commercial Name On PO',
				xtype : 'checkbox',
				name : 'INCFPromptCommercialNameOnPO',
				id:'INCFPromptCommercialNameOnPO',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFPromptCommercialNameOnPO'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFPromptCommercialNameOnPO')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Recalculate Reorder Level/quantity',
				xtype : 'checkbox',
				name : 'INCFRecalculateReorderLevel',
				id:'INCFRecalculateReorderLevel',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFRecalculateReorderLevel'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFRecalculateReorderLevel')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Recalculate Replenish Level/quantity',
				xtype : 'checkbox',
				name : 'INCFRecalculateReplenishLevel',
				id:'INCFRecalculateReplenishLevel',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFRecalculateReplenishLevel'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFRecalculateReplenishLevel')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict Purchase order by group PO Type',
				xtype : 'checkbox',
				name : 'INCFRestrictPObyPOType',
				id:'INCFRestrictPObyPOType',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFRestrictPObyPOType'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFRestrictPObyPOType')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict stock Transfers',
				xtype : 'checkbox',
				name : 'INCFRestrictTransferSTKGroup',
				id:'INCFRestrictTransferSTKGroup',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFRestrictTransferSTKGroup'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFRestrictTransferSTKGroup')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Return NonPharmacy stock upon Discontinue of orders',
				xtype : 'checkbox',
				name : 'INCFReturnNonPharmacyDiscon',
				id:'INCFReturnNonPharmacyDiscon',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFReturnNonPharmacyDiscon'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFReturnNonPharmacyDiscon')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Return Pharmacy Stock upin Discontinue of orders',
				xtype : 'checkbox',
				name : 'INCFReturnPharmStockDiscon',
				id:'INCFReturnPharmStockDiscon',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFReturnPharmStockDiscon'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFReturnPharmStockDiscon')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show Zero Batch "stock take" and "stock take adjustment" screens',
				xtype : 'checkbox',
				name : 'INCFShowZeroBatchesSTK',
				id:'INCFShowZeroBatchesSTK',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFShowZeroBatchesSTK'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFShowZeroBatchesSTK')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'stock replenishment:Skip item not in stock for add all',
				xtype : 'checkbox',
				name : 'INCFSkipNoStockItemsonAddAll',
				id:'INCFSkipNoStockItemsonAddAll',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFSkipNoStockItemsonAddAll'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFSkipNoStockItemsonAddAll')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'Stock Requset:DoNot Allow Multiple ordering',
				xtype : 'checkbox',
				name : 'INCFStReqDoNotAllowMultItems',
				id:'INCFStReqDoNotAllowMultItems',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFStReqDoNotAllowMultItems'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFStReqDoNotAllowMultItems')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Stock Take:GDF New Way',
				xtype : 'checkbox',
				name : 'INCFStTakeGDFNewWay',
				id:'INCFStTakeGDFNewWay',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFStTakeGDFNewWay'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFStTakeGDFNewWay')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Stock Take:No default for Counted Quantity',
				xtype : 'checkbox',
				name : 'INCFStTakeNoCountQtyDefault',
				id:'INCFStTakeNoCountQtyDefault',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFStTakeNoCountQtyDefault'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFStTakeNoCountQtyDefault')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Stock Take:Second Count Required',
				xtype : 'checkbox',
				name : 'INCFStTkSecondCountRequired',
				id:'INCFStTkSecondCountRequired',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFStTkSecondCountRequired'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFStTkSecondCountRequired')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'stock Transfer modules:display quantities in PC regional Format',
				xtype : 'checkbox',
				name : 'INCFStTransFormatNumber',
				id:'INCFStTransFormatNumber',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFStTransFormatNumber'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFStTransFormatNumber')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'stock Transfer modules:do not allow Decimal quantities for all UOM',
				xtype : 'checkbox',
				name : 'INCFTransDecimalRestrict',
				id:'INCFTransDecimalRestrict',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFTransDecimalRestrict'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFTransDecimalRestrict')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Transfer Acknowledge:Reason for Mandatory..',
				xtype : 'checkbox',
				name : 'INCFTransAckReasonMandatory',
				id:'INCFTransAckReasonMandatory',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFTransAckReasonMandatory'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFTransAckReasonMandatory')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'transfer Acknowledge required',
				xtype : 'checkbox',
				name : 'INCFAckFlag',
				id:'INCFAckFlag',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFAckFlag'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFAckFlag')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Unify "stock Take" and "stock take Adjustment" screens',
				xtype : 'checkbox',
				name : 'INCFUnifyTakeNAdjustment',
				id:'INCFUnifyTakeNAdjustment',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFUnifyTakeNAdjustment'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFUnifyTakeNAdjustment')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Update item cost upon stock receive',
				xtype : 'checkbox',
				name : 'INCFUpdateARCost',
				id:'INCFUpdateARCost',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFUpdateARCost'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFUpdateARCost')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Stock Location Restrictions on stock location Inquiry',
				xtype : 'checkbox',
				name : 'INCFUseStkLocRestrInquiry',
				id:'INCFUseStkLocRestrInquiry',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFUseStkLocRestrInquiry'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFUseStkLocRestrInquiry')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitystock2&pEntityName=web.Entity.CT.SystemParameter";
	
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