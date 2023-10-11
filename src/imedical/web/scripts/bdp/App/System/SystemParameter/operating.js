 /// 名称:系统配置 - 安全组系统配置-手术室工作台
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
		labelWidth : 140,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'PATCFCanclAdmOnCanclOTAppt',mapping:'PATCFCanclAdmOnCanclOTAppt'},
                                        {name: 'PATCFDisplayTheatreTimeExcWarn',mapping:'PATCFDisplayTheatreTimeExcWarn'},
                                        {name: 'PATCFNAllORBookNA',mapping:'PATCFNAllORBookNA'},
                                        {name: 'PATCFNAllORBookNoSess',mapping:'PATCFNAllORBookNoSess'},
                                        {name: 'PATCFNAllORBookPast',mapping:'PATCFNAllORBookPast'},
                                        {name: 'RBCFGenerateAdmOnOTRequest',mapping:'RBCFGenerateAdmOnOTRequest'},
                                        {name: 'PATCFLinkOTBookToExistPreAdm',mapping:'PATCFLinkOTBookToExistPreAdm'},
                                        {name: 'PATCFWarnORBookingMoveRes',mapping:'PATCFWarnORBookingMoveRes'},
                                       ///{name: 'PATCFAlloweChangeOvertimeBtwOps',mapping:'PATCFAlloweChangeOvertimeBtwOps'},
                                        {name: 'PATCFMaxOperatingTimeMins',mapping:'PATCFMaxOperatingTimeMins'},
                                        {name: 'PATCFExtrInterFixDevice',mapping:'PATCFExtrInterFixDevice'},
                                        {name: 'PATCFProperIncisionPerc',mapping:'PATCFProperIncisionPerc'},
                                        {name: 'PATCFOTDelayMargin',mapping:'PATCFOTDelayMargin'},
                                        {name: 'PATCFOTStartMargin',mapping:'PATCFOTStartMargin'},
                                        {name: 'PATCFAutoCreateOTBookEpConditio',mapping:'PATCFAutoCreateOTBookEpConditio'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'Cancel Admission On Cancel or OT Appointment',
				xtype : 'checkbox',
				name : 'PATCFCanclAdmOnCanclOTAppt',
				id:'PATCFCanclAdmOnCanclOTAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCanclAdmOnCanclOTAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCanclAdmOnCanclOTAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Display Theatre Time Exceeded Warning',
				xtype : 'checkbox',
				name : 'PATCFDisplayTheatreTimeExcWarn',
				id:'PATCFDisplayTheatreTimeExcWarn',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDisplayTheatreTimeExcWarn'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDisplayTheatreTimeExcWarn')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot allow users place bookings in areas marked as not available',
				xtype : 'checkbox',
				name : 'PATCFNAllORBookNA',
				id:'PATCFNAllORBookNA',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNAllORBookNA'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNAllORBookNA')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot allow users place bookings in NonSession areas',
				xtype : 'checkbox',
				name : 'PATCFNAllORBookNoSess',
				id:'PATCFNAllORBookNoSess',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNAllORBookNoSess'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNAllORBookNoSess')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot allow users place bookings in the past',
				xtype : 'checkbox',
				name : 'PATCFNAllORBookPast',
				id:'PATCFNAllORBookPast',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNAllORBookPast'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNAllORBookPast')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'generate episode on OT request creation',
				xtype : 'checkbox',
				name : 'RBCFGenerateAdmOnOTRequest',
				id:'RBCFGenerateAdmOnOTRequest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFGenerateAdmOnOTRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFGenerateAdmOnOTRequest')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'link OT booking to existing preadmission',
				xtype : 'checkbox',
				name : 'PATCFLinkOTBookToExistPreAdm',
				id:'PATCFLinkOTBookToExistPreAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLinkOTBookToExistPreAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLinkOTBookToExistPreAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'warn if user moves booking to another resource',
				xtype : 'checkbox',
				name : 'PATCFWarnORBookingMoveRes',
				id:'PATCFWarnORBookingMoveRes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFWarnORBookingMoveRes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFWarnORBookingMoveRes')),
				inputValue : true?'Y':'N',
				checked:false
			/*},{
				fieldLabel : 'allowed overtime between procedures',
				xtype:'numberfield',
				name : 'PATCFAlloweChangeOvertimeBtwOps',
				id:'PATCFAlloweChangeOvertimeBtwOps',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAlloweChangeOvertimeBtwOps'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAlloweChangeOvertimeBtwOps'))
			*/
			
			},{
				fieldLabel : 'Max Operating Time(MIN)',
				xtype:'numberfield',
				width:200,
				name : 'PATCFMaxOperatingTimeMins',
				id:'PATCFMaxOperatingTimeMins',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMaxOperatingTimeMins'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMaxOperatingTimeMins'))
			},{
				fieldLabel : 'Extraction Internal Fixation Device,%',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				name : 'PATCFExtrInterFixDevice', ///string??
				id:'PATCFExtrInterFixDevice',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFExtrInterFixDevice'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFExtrInterFixDevice'))
			},{
				fieldLabel : 'non peoper incision,&',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				name : 'PATCFNonProperIncisionPerc',
				id:'PATCFNonProperIncisionPerc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNonProperIncisionPerc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNonProperIncisionPerc'))
			},{
				fieldLabel : 'Proper Incision,%',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				name : 'PATCFProperIncisionPerc',
				id:'PATCFProperIncisionPerc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFProperIncisionPerc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFProperIncisionPerc'))
			},{
				fieldLabel : 'OT Delay Margin',
				xtype:'numberfield',
				width:200,
				name : 'PATCFOTDelayMargin',
				id:'PATCFOTDelayMargin',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFOTDelayMargin'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFOTDelayMargin'))
			},{
				fieldLabel : 'OT Start Margin',
				xtype:'numberfield',
				width:200,
				name : 'PATCFOTStartMargin',
				id:'PATCFOTStartMargin',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFOTStartMargin'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFOTStartMargin'))
			},{

				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'conditions for Auto-Creation of episodes for OT Bookings',
				hiddenName : 'PATCFAutoCreateOTBookEpConditio',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAutoCreateOTBookEpConditio'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAutoCreateOTBookEpConditio')),
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
								name : 'Location',
								value : 'L'
							}, {
								name : 'Date/Location',
								value : 'DL'
							}, {
								name : 'Resource/Location',
								value : 'RL'
							}, {
								name : 'Responsible Unit',
								value : 'RU'
							}]
				})	
				
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntityoperating&pEntityName=web.Entity.CT.SystemParameter";
	
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