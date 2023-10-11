 /// 名称:系统配置 - 安全组系统配置-自动打印
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
                                        {name: 'PATCFPrintAdmissionNotif',mapping:'PATCFPrintAdmissionNotif'},
                                        {name: 'PATCFPrintAdmSheetOnPaym',mapping:'PATCFPrintAdmSheetOnPaym'},
                                        {name: 'PATCFPrintAppointmentSlip',mapping:'PATCFPrintAppointmentSlip'},
                                        {name: 'PATCFPrintReceipt',mapping:'PATCFPrintReceipt'},
                                        {name: 'RTCFPrintMRBarCode',mapping:'RTCFPrintMRBarCode'},
                                        {name: 'RTCFAutoPrintRequest',mapping:'RTCFAutoPrintRequest'},
                                        {name: 'RTCFPrintMRRequestSlip',mapping:'RTCFPrintMRRequestSlip'},
                                        {name: 'PATCFPrintBillOnPayment',mapping:'PATCFPrintBillOnPayment'},
                                        {name: 'PATCFPrLabNewPat',mapping:'PATCFPrLabNewPat'},
                                        {name: 'OECFPrintPresc',mapping:'OECFPrintPresc'},
                                        {name: 'OECFPrintDelLabelOnUpdate',mapping:'OECFPrintDelLabelOnUpdate'},
                                        {name: 'PATCFPrintRegisCard',mapping:'PATCFPrintRegisCard'},
                                        {name: 'PATCFPrintRBINQ01',mapping:'PATCFPrintRBINQ01'},
                                        {name: 'PATCFPrintRBINQ02',mapping:'PATCFPrintRBINQ02'},
                                        {name: 'PATCFPrintRBINQ03',mapping:'PATCFPrintRBINQ03'},
                                        {name: 'PATCFPrintAutom1',mapping:'PATCFPrintAutom1'},
                                        {name: 'PATCFPrintAutom2',mapping:'PATCFPrintAutom2'},
                                        {name: 'PATCFPrintWaitList',mapping:'PATCFPrintWaitList'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'在登记时打印入院通知',
				xtype : 'checkbox',
				name : 'PATCFPrintAdmissionNotif',
				id:'PATCFPrintAdmissionNotif',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAdmissionNotif'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAdmissionNotif')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'收银台支付时打印入院表单',
				xtype : 'checkbox',
				name : 'PATCFPrintAdmSheetOnPaym',
				id:'PATCFPrintAdmSheetOnPaym',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAdmSheetOnPaym'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAdmSheetOnPaym')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'在预约时打印预约单.',
				xtype : 'checkbox',
				name : 'PATCFPrintAppointmentSlip',
				id:'PATCFPrintAppointmentSlip',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAppointmentSlip'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAppointmentSlip')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'自动打印账单收据',
				xtype : 'checkbox',
				name : 'PATCFPrintReceipt',
				id:'PATCFPrintReceipt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintReceipt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintReceipt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'打印磁共振登记条形码',
				xtype : 'checkbox',
				name : 'RTCFPrintMRBarCode',
				id:'RTCFPrintMRBarCode',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFPrintMRBarCode'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFPrintMRBarCode')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'磁共振打印手册要求.',
				xtype : 'checkbox',
				name : 'RTCFAutoPrintRequest',
				id:'RTCFAutoPrintRequest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFAutoPrintRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFAutoPrintRequest')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'在登记时打印磁共振请求.',
				xtype : 'checkbox',
				name : 'RTCFPrintMRRequestSlip',
				id:'RTCFPrintMRRequestSlip',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFPrintMRRequestSlip'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFPrintMRRequestSlip')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'收银台支付时打印病人账单',
				xtype : 'checkbox',
				name : 'PATCFPrintBillOnPayment',
				id:'PATCFPrintBillOnPayment',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintBillOnPayment'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintBillOnPayment')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'登记时打印病人标签',
				xtype : 'checkbox',
				name : 'PATCFPrLabNewPat',
				id:'PATCFPrLabNewPat',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrLabNewPat'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrLabNewPat')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'打印处方.',
				xtype : 'checkbox',
				name : 'OECFPrintPresc',
				id:'OECFPrintPresc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPrintPresc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPrintPresc')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'医嘱入口打印传送标签',
				xtype : 'checkbox',
				name : 'OECFPrintDelLabelOnUpdate',
				id:'OECFPrintDelLabelOnUpdate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPrintDelLabelOnUpdate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPrintDelLabelOnUpdate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'登记时打印注册卡',
				xtype : 'checkbox',
				name : 'PATCFPrintRegisCard',
				id:'PATCFPrintRegisCard',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRegisCard'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRegisCard')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'资源预约查询01',
				xtype : 'checkbox',
				name : 'PATCFPrintRBINQ01',
				id:'PATCFPrintRBINQ01',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRBINQ01'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRBINQ01')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'资源预约查询02',
				xtype : 'checkbox',
				name : 'PATCFPrintRBINQ02',
				id:'PATCFPrintRBINQ02',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRBINQ02'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRBINQ02')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'资源预约查询03',
				xtype : 'checkbox',
				name : 'PATCFPrintRBINQ03',
				id:'PATCFPrintRBINQ03',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRBINQ03'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintRBINQ03')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'注册时使用自定义的打印1',
				xtype : 'checkbox',
				name : 'PATCFPrintAutom1',
				id:'PATCFPrintAutom1',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAutom1'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAutom1')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'注册时使用自定义的打印2',
				xtype : 'checkbox',
				name : 'PATCFPrintAutom2',
				id:'PATCFPrintAutom2',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAutom2'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintAutom2')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'打印新入口等候列表',
				xtype : 'checkbox',
				name : 'PATCFPrintWaitList',
				id:'PATCFPrintWaitList',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintWaitList'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPrintWaitList')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntityprinting&pEntityName=web.Entity.CT.SystemParameter";
	
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