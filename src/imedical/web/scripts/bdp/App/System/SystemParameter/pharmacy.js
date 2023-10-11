 /// 名称:系统配置 - 安全组系统配置-药学
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
		labelWidth : 130,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'OECFPharmacyItemNoStock',mapping:'OECFPharmacyItemNoStock'},
                                        {name: 'OECFAcceptIP',mapping:'OECFAcceptIP'},
                                        {name: 'OECFAcceptOP',mapping:'OECFAcceptOP'},
                                        {name: 'OECFAutoPacking',mapping:'OECFAutoPacking'},
                                        {name: 'OECFDisplayOIDescOnPharmWB',mapping:'OECFDisplayOIDescOnPharmWB'},
                                        {name: 'OECFDisplayRefundReason',mapping:'OECFDisplayRefundReason'},
                                        {name: 'OECFExecuteUponCollection',mapping:'OECFExecuteUponCollection'},
                                        {name: 'OECFExePhDischOrdersOnDisch',mapping:'OECFExePhDischOrdersOnDisch'},
                                        {name: 'OECFGenericPrescribing',mapping:'OECFGenericPrescribing'},
                                        {name: 'OECFPickBlankExpBatchLast',mapping:'OECFPickBlankExpBatchLast'},
                                        {name: 'OECFATCInterface',mapping:'OECFATCInterface'},
                                        {name: 'OECFWarnOutstanAmtExist',mapping:'OECFWarnOutstanAmtExist'},
                                        {name: 'OECFSignOffDisclaimerDays',mapping:'OECFSignOffDisclaimerDays'},
                                        {name: 'OECFDaysToRemainAtPacked',mapping:'OECFDaysToRemainAtPacked'},
                                        {name: 'OECFDaysToRemainAtUncollected',mapping:'OECFDaysToRemainAtUncollected'},
                                        {name: 'OECFExternalMonographURL',mapping:'OECFExternalMonographURL'},
                                        {name: 'OECFPrescriptionGenerated',mapping:'OECFPrescriptionGenerated'},
                                        {name: 'OECFKinetics',mapping:'OECFKinetics'},
                                        {name: 'OECFTPN',mapping:'OECFTPN'}
                                 ]),
		
		items:[
			{
				boxLabel:'allow ordering drugs not linked to Stock item',
				xtype : 'checkbox',
				name : 'OECFPharmacyItemNoStock',
				id:'OECFPharmacyItemNoStock',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPharmacyItemNoStock'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPharmacyItemNoStock')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'自动接收住院病人处方',
				xtype : 'checkbox',
				name : 'OECFAcceptIP',
				id:'OECFAcceptIP',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAcceptIP'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAcceptIP')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'自动接收门诊病人处方',
				xtype : 'checkbox',
				name : 'OECFAcceptOP',
				id:'OECFAcceptOP',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAcceptOP'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAcceptOP')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Auto Packing',
				xtype : 'checkbox',
				name : 'OECFAutoPacking',
				id:'OECFAutoPacking',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAutoPacking'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAutoPacking')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Display Order Item Description On Pharmacy WB',
				xtype : 'checkbox',
				name : 'OECFDisplayOIDescOnPharmWB',
				id:'OECFDisplayOIDescOnPharmWB',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDisplayOIDescOnPharmWB'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDisplayOIDescOnPharmWB')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot Display default messages for Reason for return of stock',
				xtype : 'checkbox',
				name : 'OECFDisplayRefundReason',
				id:'OECFDisplayRefundReason',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDisplayRefundReason'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDisplayRefundReason')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Execute OPD and discharge on Collection',
				xtype : 'checkbox',
				name : 'OECFExecuteUponCollection',
				id:'OECFExecuteUponCollection',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteUponCollection'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteUponCollection')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Execute Pharmacy Discharge Orders On Discharge',
				xtype : 'checkbox',
				name : 'OECFExePhDischOrdersOnDisch',
				id:'OECFExePhDischOrdersOnDisch',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFExePhDischOrdersOnDisch'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFExePhDischOrdersOnDisch')),
				inputValue : true?'Y':'N',
				checked:false
				
					
			},{
				boxLabel:'Generic Prescribing',
				xtype : 'checkbox',
				name : 'OECFGenericPrescribing',
				id:'OECFGenericPrescribing',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFGenericPrescribing'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFGenericPrescribing')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Pick batches with blank expiry date last',
				xtype : 'checkbox',
				name : 'OECFPickBlankExpBatchLast',
				id:'OECFPickBlankExpBatchLast',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPickBlankExpBatchLast'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPickBlankExpBatchLast')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'send details to auto tablet counter',
				xtype : 'checkbox',
				name : 'OECFATCInterface',
				id:'OECFATCInterface',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFATCInterface'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFATCInterface')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Warning Outstanding Amount Exist',
				xtype : 'checkbox',
				name : 'OECFWarnOutstanAmtExist',
				id:'OECFWarnOutstanAmtExist',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFWarnOutstanAmtExist'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFWarnOutstanAmtExist')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				fieldLabel : 'Sign-Off Disclaimer Days',
				xtype:'numberfield',
				width:200,
				allowNegative : false, //不允许输入负数
				allowDecimals : false, //不允许输入小数
				name : 'OECFSignOffDisclaimerDays',
				id:'OECFSignOffDisclaimerDays',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFSignOffDisclaimerDays'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFSignOffDisclaimerDays'))
			},{
				fieldLabel : 'Days To Remain At Packed',
				xtype:'numberfield',
				width:200,
				allowNegative : false, //不允许输入负数
				allowDecimals : false, //不允许输入小数
				name : 'OECFDaysToRemainAtPacked',
				id:'OECFDaysToRemainAtPacked',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDaysToRemainAtPacked'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDaysToRemainAtPacked'))
			},{
				fieldLabel : 'Days To Remain At Uncollected',
				xtype:'numberfield',
				width:200,
				allowNegative : false, //不允许输入负数
				allowDecimals : false, //不允许输入小数
				name : 'OECFDaysToRemainAtUncollected',
				id:'OECFDaysToRemainAtUncollected',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDaysToRemainAtUncollected'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDaysToRemainAtUncollected'))
			}
			,	
			{
				fieldLabel : '外部专著地址',
				xtype:'textfield',
				width:200,
				id:'OECFExternalMonographURL',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFExternalMonographURL'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFExternalMonographURL')),
				name : 'OECFExternalMonographURL'
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : '生成处方号方式',
				hiddenName : 'OECFPrescriptionGenerated',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPrescriptionGenerated'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPrescriptionGenerated')),
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
								name : 'On Order Entry',
								value : 'OE'
							}, {
								name : 'Based on Receiving Location',
								value : 'RL'
							}, {
								name : 'Per Receiving Location Per Day',
								value : 'RD'
							}]
				})	
			
			},{
				
				fieldLabel : '动力学项目路径',
				xtype:'textarea',
				width:200,
				maxLength:255,
				id:'OECFKinetics',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFKinetics'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFKinetics')),
				name : 'OECFKinetics'
			},{
				fieldLabel : '货运项目路径',
				xtype:'textarea',
				width:200,
				maxLength:255,
				id:'OECFTPN',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFTPN'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFTPN')),
				name : 'OECFTPN'
							
			
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypharmacy&pEntityName=web.Entity.CT.SystemParameter";
	
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