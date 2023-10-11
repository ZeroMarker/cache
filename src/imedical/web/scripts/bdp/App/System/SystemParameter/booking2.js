 /// 名称:系统配置 - 安全组系统配置-预约2
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
                                        {name: 'RBCFAllowOverBookWalkins',mapping:'RBCFAllowOverBookWalkins'},
                                        {name: 'RBCFAllowOverBookingAvailSlots',mapping:'RBCFAllowOverBookingAvailSlots'},
                                        {name: 'RBCFAllowBookOverlapAppoint',mapping:'RBCFAllowBookOverlapAppoint'},
                                        {name: 'RBCFAllowTransferEarlyAdmDate',mapping:'RBCFAllowTransferEarlyAdmDate'},
                                        {name: 'RBCFCancelAdmOnCancelAppt',mapping:'RBCFCancelAdmOnCancelAppt'},
                                        {name: 'RBCFNoWarningOnApptCancel',mapping:'RBCFNoWarningOnApptCancel'},
                                        {name: 'RBCFDischEpCancelFutureAppts',mapping:'RBCFDischEpCancelFutureAppts'},
                                        {name: 'RBCFAdmDateEarliestApptDate',mapping:'RBCFAdmDateEarliestApptDate'},
                                        {name: 'PATCFMakeCurrOPAdmForOPDAttend',mapping:'PATCFMakeCurrOPAdmForOPDAttend'},
                                        {name: 'RBCFDefaultPatientDetPayorPlan',mapping:'RBCFDefaultPatientDetPayorPlan'},
                                        {name: 'RBCFDefResourceLastAppt',mapping:'RBCFDefResourceLastAppt'},
                                        {name: 'RBCFDisableRTCreationAppt',mapping:'RBCFDisableRTCreationAppt'},
                                        {name: 'RBCFDisplayOrderNotes',mapping:'RBCFDisplayOrderNotes'},
                                        {name: 'RBCFExtendReferralPeriod',mapping:'RBCFExtendReferralPeriod'},
                                        {name: 'RBCFGenerate1stWeekOfCycle',mapping:'RBCFGenerate1stWeekOfCycle'},
                                        {name: 'RBCFGroupNoEpisodeCreation',mapping:'RBCFGroupNoEpisodeCreation'},
                                        {name: 'RBCFKeepLocAnResource',mapping:'RBCFKeepLocAnResource'},
                                        {name: 'RBCFWebNotMoveOnHoldOnSchGen',mapping:'RBCFWebNotMoveOnHoldOnSchGen'},
                                        {name: 'RBCFRestrictServices',mapping:'RBCFRestrictServices'},
                                        {name: 'RBCFSetAdmDateTimeToAppt',mapping:'RBCFSetAdmDateTimeToAppt'},
                                        {name: 'RBCFShowBookedAppt',mapping:'RBCFShowBookedAppt'},
                                        {name: 'RBCFShowBookingNotesMessage',mapping:'RBCFShowBookingNotesMessage'},
                                        {name: 'RBCFShowReferralAfterChangeStat',mapping:'RBCFShowReferralAfterChangeStat'},
                                        {name: 'RBCFRestrictPayorPlan',mapping:'RBCFRestrictPayorPlan'},
                                        {name: 'RBCFUseUserDefPayor',mapping:'RBCFUseUserDefPayor'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'allow overbooking for walk-in patients',
				xtype : 'checkbox',
				name : 'RBCFAllowOverBookWalkins',
				id:'RBCFAllowOverBookWalkins',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowOverBookWalkins'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowOverBookWalkins')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow overbooking if there are free slots',
				xtype : 'checkbox',
				name : 'RBCFAllowOverBookingAvailSlots',
				id:'RBCFAllowOverBookingAvailSlots',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowOverBookingAvailSlots'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowOverBookingAvailSlots')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow book overlapping appointment',
				xtype : 'checkbox',
				name : 'RBCFAllowBookOverlapAppoint',
				id:'RBCFAllowBookOverlapAppoint',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowBookOverlapAppoint'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowBookOverlapAppoint')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'cancel admission on cancel appointment',
				xtype : 'checkbox',
				name : 'RBCFAllowTransferEarlyAdmDate',
				id:'RBCFAllowTransferEarlyAdmDate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowTransferEarlyAdmDate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFAllowTransferEarlyAdmDate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow transfer to earlier admission date',
				xtype : 'checkbox',
				name : 'RBCFCancelAdmOnCancelAppt',
				id:'RBCFCancelAdmOnCancelAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFCancelAdmOnCancelAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFCancelAdmOnCancelAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donnot display warning messages on cancellation of appointment',
				xtype : 'checkbox',
				name : 'RBCFNoWarningOnApptCancel',
				id:'RBCFNoWarningOnApptCancel',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFNoWarningOnApptCancel'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFNoWarningOnApptCancel')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'cancel future appts on episode discharge',
				xtype : 'checkbox',
				name : 'RBCFDischEpCancelFutureAppts',
				id:'RBCFDischEpCancelFutureAppts',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFDischEpCancelFutureAppts'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFDischEpCancelFutureAppts')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'change admission date to the earliest appointment date for this admission',
				xtype : 'checkbox',
				name : 'RBCFAdmDateEarliestApptDate',
				id:'RBCFAdmDateEarliestApptDate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFAdmDateEarliestApptDate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFAdmDateEarliestApptDate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'create current OP episode for OPD attendee',
				xtype : 'checkbox',
				name : 'PATCFMakeCurrOPAdmForOPDAttend',
				id:'PATCFMakeCurrOPAdmForOPDAttend',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMakeCurrOPAdmForOPDAttend'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMakeCurrOPAdmForOPDAttend')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'default payor/plan from patient details',
				xtype : 'checkbox',
				name : 'RBCFDefaultPatientDetPayorPlan',
				id:'RBCFDefaultPatientDetPayorPlan',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFDefaultPatientDetPayorPlan'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFDefaultPatientDetPayorPlan')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'default resource form last appointment',
				xtype : 'checkbox',
				name : 'RBCFDefResourceLastAppt',
				id:'RBCFDefResourceLastAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFDefResourceLastAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFDefResourceLastAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'disable creation of requests on appointment',
				xtype : 'checkbox',
				name : 'RBCFDisableRTCreationAppt',
				id:'RBCFDisableRTCreationAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFDisableRTCreationAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFDisableRTCreationAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'display order notes in resource booking',
				xtype : 'checkbox',
				name : 'RBCFDisplayOrderNotes',
				id:'RBCFDisplayOrderNotes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFDisplayOrderNotes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFDisplayOrderNotes')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'extend referral period',
				xtype : 'checkbox',
				name : 'RBCFExtendReferralPeriod',
				id:'RBCFExtendReferralPeriod',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFExtendReferralPeriod'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFExtendReferralPeriod')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'generate first week of cycle',
				xtype : 'checkbox',
				name : 'RBCFGenerate1stWeekOfCycle',
				id:'RBCFGenerate1stWeekOfCycle',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFGenerate1stWeekOfCycle'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFGenerate1stWeekOfCycle')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'group No& episode creation',
				xtype : 'checkbox',
				name : 'RBCFGroupNoEpisodeCreation',
				id:'RBCFGroupNoEpisodeCreation',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFGroupNoEpisodeCreation'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFGroupNoEpisodeCreation')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'keep location and resource',
				xtype : 'checkbox',
				name : 'RBCFKeepLocAnResource',
				id:'RBCFKeepLocAnResource',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFKeepLocAnResource'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFKeepLocAnResource')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'On-hold appointment not moved upon schedule generation',
				xtype : 'checkbox',
				name : 'RBCFWebNotMoveOnHoldOnSchGen',
				id:'RBCFWebNotMoveOnHoldOnSchGen',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFWebNotMoveOnHoldOnSchGen'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFWebNotMoveOnHoldOnSchGen')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'restrict services combos by service group',
				xtype : 'checkbox',
				name : 'RBCFRestrictServices',
				id:'RBCFRestrictServices',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFRestrictServices'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFRestrictServices')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'set episode date/time to appointment date/time',
				xtype : 'checkbox',
				name : 'RBCFSetAdmDateTimeToAppt',
				id:'RBCFSetAdmDateTimeToAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFSetAdmDateTimeToAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFSetAdmDateTimeToAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'show booked appointment only',
				xtype : 'checkbox',
				name : 'RBCFShowBookedAppt',
				id:'RBCFShowBookedAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFShowBookedAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFShowBookedAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'show booking notes message on appointment booking',
				xtype : 'checkbox',
				name : 'RBCFShowBookingNotesMessage',
				id:'RBCFShowBookingNotesMessage',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFShowBookingNotesMessage'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFShowBookingNotesMessage')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'show referral after change status',
				xtype : 'checkbox',
				name : 'RBCFShowReferralAfterChangeStat',
				id:'RBCFShowReferralAfterChangeStat',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFShowReferralAfterChangeStat'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFShowReferralAfterChangeStat')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'use payor/plan restrictions',
				xtype : 'checkbox',
				name : 'RBCFRestrictPayorPlan',
				id:'RBCFRestrictPayorPlan',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFRestrictPayorPlan'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFRestrictPayorPlan')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'use user default for payor/plan on booking',
				xtype : 'checkbox',
				name : 'RBCFUseUserDefPayor',
				id:'RBCFUseUserDefPayor',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFUseUserDefPayor'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFUseUserDefPayor')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitybooking2&pEntityName=web.Entity.CT.SystemParameter";
	
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