 /// 名称:系统配置 - 安全组系统配置-计费和出纳
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   
   var PATCFLabCounterTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetPACCounterType";
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
		labelWidth : 180,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'PATCFLabEpisodeNumberMethod',mapping:'PATCFLabEpisodeNumberMethod'},
                                        {name: 'SMCFLabtrakUserID',mapping:'SMCFLabtrakUserID'},
                                        {name: 'SMCFLabtrakUserPassword',mapping:'SMCFLabtrakUserPassword'},
                                        {name: 'PATCFDailyCounterLength',mapping:'PATCFDailyCounterLength'},
                                        {name: 'PATCFLabCounterTypeDR',mapping:'PATCFLabCounterTypeDR'},
                                        {name: 'OECFSendWebNRtoLabTrak',mapping:'OECFSendWebNRtoLabTrak'},
                                        {name: 'SMCFLinkExtLab',mapping:'SMCFLinkExtLab'},
                                        {name: 'OECFExecuteLabOrder',mapping:'OECFExecuteLabOrder'},
                                        {name: 'OECFSendHospitalCodeToLab',mapping:'OECFSendHospitalCodeToLab'},
                                        {name: 'OECFSendOrderingDoctorToLab',mapping:'OECFSendOrderingDoctorToLab'},
                                        {name: 'OECFSendRecLocToLab',mapping:'OECFSendRecLocToLab'},
                                        {name: 'PATCFUseAntibioticSeqInLab',mapping:'PATCFUseAntibioticSeqInLab'},
                                        {name: 'SSGRPRestrictWardsToDepartment',mapping:'SSGRPRestrictWardsToDepartment'}
                                 ]),
		
		items:[
			
				{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'Lab Episode Number Method',
				hiddenName : 'PATCFLabEpisodeNumberMethod',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLabEpisodeNumberMethod'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLabEpisodeNumberMethod')),
				mode : 'local',
				shadow:false,
				//queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'System Counter',
								value : 'S'
							}, {
								name : 'Daily Counter',
								value : 'D'
							}, {
								name : 'User Defined Counter',
								value : 'U'
							}]
				})	
			},{
				fieldLabel:'Labtrak User ID',
				xtype:'textfield',
				width:200,
				id:'SMCFLabtrakUserID',
				maxLength:30,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFLabtrakUserID'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFLabtrakUserID')),
				name : 'SMCFLabtrakUserID'
			},{
				fieldLabel: '<font color=red>*</font>Labtrak User Password',
				xtype:'textfield',
				width:200,
				inputType : 'password',
				maxLength:30,
				id:'SMCFLabtrakUserPassword',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFLabtrakUserPassword'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFLabtrakUserPassword')),
				name : 'SMCFLabtrakUserPassword'
			},{
				fieldLabel:'length of DailyCounter',
				xtype:'numberfield',
				width:200,
				id:'PATCFDailyCounterLength',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDailyCounterLength'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDailyCounterLength')),
				name : 'PATCFDailyCounterLength'
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'user defined Lab Counter Type',
				hiddenName : 'PATCFLabCounterTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLabCounterTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLabCounterTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CNTDesc',
				valueField : 'CNTRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFLabCounterTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CNTRowId',mapping:'CNTRowId'},
							{name:'CNTDesc',mapping:'CNTDesc'} ])
					})	
			},{
				boxLabel:'Send Web NR to LabTrak',
				xtype : 'checkbox',
				name : 'OECFSendWebNRtoLabTrak',
				id:'OECFSendWebNRtoLabTrak',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFSendWebNRtoLabTrak'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFSendWebNRtoLabTrak')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'Link to External Lab system',
				xtype : 'checkbox',
				name : 'SMCFLinkExtLab',
				id:'SMCFLinkExtLab',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFLinkExtLab'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFLinkExtLab')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Order must be Executed before using receive specimen',
				xtype : 'checkbox',
				name : 'OECFExecuteLabOrder',
				id:'OECFExecuteLabOrder',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteLabOrder'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteLabOrder')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Send Hospital Code To Labtrak',
				xtype : 'checkbox',
				name : 'OECFSendHospitalCodeToLab',
				id:'OECFSendHospitalCodeToLab',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFSendHospitalCodeToLab'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFSendHospitalCodeToLab')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Send Ordering Doctor To Labtrak',
				xtype : 'checkbox',
				name : 'OECFSendOrderingDoctorToLab',
				id:'OECFSendOrderingDoctorToLab',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFSendOrderingDoctorToLab'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFSendOrderingDoctorToLab')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Send Receiving Location To Labtrak',
				xtype : 'checkbox',
				name : 'OECFSendRecLocToLab',
				id:'OECFSendRecLocToLab',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFSendRecLocToLab'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFSendRecLocToLab')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Antibiotic Sequence In Labtrak',
				xtype : 'checkbox',
				name : 'PATCFUseAntibioticSeqInLab',
				id:'PATCFUseAntibioticSeqInLab',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseAntibioticSeqInLab'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseAntibioticSeqInLab')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'use New LabTrak',
				xtype : 'checkbox',
				name : 'SMCFNewLabTrak',
				id:'SMCFNewLabTrak',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFNewLabTrak'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFNewLabTrak')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitylabtrak&pEntityName=web.Entity.CT.SystemParameter";
	
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