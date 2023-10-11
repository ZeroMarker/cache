 /// 名称:系统配置 - 安全组系统配置-纸质记录追踪2
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
                                        {name: 'RTCFAskReqDetails',mapping:'RTCFAskReqDetails'},
                                        {name: 'RTCFBypassDepartMR',mapping:'RTCFBypassDepartMR'},
                                        {name: 'RTCFApptHoldCancelsMRReq',mapping:'RTCFApptHoldCancelsMRReq'},
                                        {name: 'RTCFDisableVBAutoRequest',mapping:'RTCFDisableVBAutoRequest'},
                                        {name: 'RTCFMarkMRNInactivePatMerge',mapping:'RTCFMarkMRNInactivePatMerge'},
                                        {name: 'RTCFNoShowUVMsgOnMoveMRToHomeLo',mapping:'RTCFNoShowUVMsgOnMoveMRToHomeLo'},
                                        {name: 'RTCFInactivateRTVolumeMerg',mapping:'RTCFInactivateRTVolumeMerg'},
                                        {name: 'RTCFAutoMRRequestToNewVolume',mapping:'RTCFAutoMRRequestToNewVolume'},
                                        {name: 'RTCFReturnMRTHomeFirst',mapping:'RTCFReturnMRTHomeFirst'},
                                        {name: 'RTCFOnlyInactMRNLogHospMerg',mapping:'RTCFOnlyInactMRNLogHospMerg'},
                                        {name: 'RTCFShowMessageForResearchReq',mapping:'RTCFShowMessageForResearchReq'},
                                        {name: 'RTCFViewAllVolumes',mapping:'RTCFViewAllVolumes'},
                                        {name: 'RTCFViewRequestDefaultLoc',mapping:'RTCFViewRequestDefaultLoc'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'Ask for Request Details',
				xtype : 'checkbox',
				name : 'RTCFAskReqDetails',
				id:'RTCFAskReqDetails',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFAskReqDetails'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFAskReqDetails')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Bypass Department medical records',
				xtype : 'checkbox',
				name : 'RTCFBypassDepartMR',
				id:'RTCFBypassDepartMR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFBypassDepartMR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFBypassDepartMR')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'cancel MR requests when appointment is placed on hold',
				xtype : 'checkbox',
				name : 'RTCFApptHoldCancelsMRReq',
				id:'RTCFApptHoldCancelsMRReq',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFApptHoldCancelsMRReq'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFApptHoldCancelsMRReq')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Disable VB AutoRequest',
				xtype : 'checkbox',
				name : 'RTCFDisableVBAutoRequest',
				id:'RTCFDisableVBAutoRequest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFDisableVBAutoRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFDisableVBAutoRequest')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot Inactive MRN upon Patient Merge',
				xtype : 'checkbox',
				name : 'RTCFMarkMRNInactivePatMerge',
				id:'RTCFMarkMRNInactivePatMerge',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFMarkMRNInactivePatMerge'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFMarkMRNInactivePatMerge')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot display Unverified Msg On Move MR To Home Location',
				xtype : 'checkbox',
				name : 'RTCFNoShowUVMsgOnMoveMRToHomeLo',
				id:'RTCFNoShowUVMsgOnMoveMRToHomeLo',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFNoShowUVMsgOnMoveMRToHomeLo'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFNoShowUVMsgOnMoveMRToHomeLo')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'mark medical record volumes as Inactivate upon patient Merg',
				xtype : 'checkbox',
				name : 'RTCFInactivateRTVolumeMerg',
				id:'RTCFInactivateRTVolumeMerg',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFInactivateRTVolumeMerg'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFInactivateRTVolumeMerg')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'move Auto MR Request To New Volume',
				xtype : 'checkbox',
				name : 'RTCFAutoMRRequestToNewVolume',
				id:'RTCFAutoMRRequestToNewVolume',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFAutoMRRequestToNewVolume'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFAutoMRRequestToNewVolume')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Must Return MRT Home First',
				xtype : 'checkbox',
				name : 'RTCFReturnMRTHomeFirst',
				id:'RTCFReturnMRTHomeFirst',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFReturnMRTHomeFirst'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFReturnMRTHomeFirst')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Only Inactivate MRN for Logon Hospital when Merging',
				xtype : 'checkbox',
				name : 'RTCFOnlyInactMRNLogHospMerg',
				id:'RTCFOnlyInactMRNLogHospMerg',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFOnlyInactMRNLogHospMerg'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFOnlyInactMRNLogHospMerg')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show Message For Research Requests',
				xtype : 'checkbox',
				name : 'RTCFShowMessageForResearchReq',
				id:'RTCFShowMessageForResearchReq',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFShowMessageForResearchReq'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFShowMessageForResearchReq')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'View/create All Volumes',
				xtype : 'checkbox',
				name : 'RTCFViewAllVolumes',
				id:'RTCFViewAllVolumes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFViewAllVolumes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFViewAllVolumes')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'View Request Default Location',
				xtype : 'checkbox',
				name : 'RTCFViewRequestDefaultLoc',
				id:'RTCFViewRequestDefaultLoc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFViewRequestDefaultLoc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFViewRequestDefaultLoc')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypaper2&pEntityName=web.Entity.CT.SystemParameter";
	
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