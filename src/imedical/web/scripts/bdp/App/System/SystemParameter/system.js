 /// 名称:系统配置 - 安全组系统配置-系统信息
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
                                        {name: 'SMCFMainDatabaseServer',mapping:'SMCFMainDatabaseServer'},
                                        {name: 'SMCFCTNamespace',mapping:'SMCFCTNamespace'},
                                        {name: 'SMCFName1',mapping:'SMCFName1'},
                                        {name: 'SMCFBillingVersion',mapping:'SMCFBillingVersion'},
                                         {name: 'SMCFMedTrakVersion',mapping:'SMCFMedTrakVersion'},
                                        {name: 'SMCFWordVersion',mapping:'SMCFWordVersion'},
                                        {name: 'SMCFCrystalRepDSN',mapping:'SMCFCrystalRepDSN'},
                                        {name: 'SMCFCrystalRepUserID',mapping:'SMCFCrystalRepUserID'},
                                         {name: 'SMCFCrystRepPassword',mapping:'SMCFCrystRepPassword'},
                                        {name: 'SMCFHL7QueryTimeoutInSecs',mapping:'SMCFHL7QueryTimeoutInSecs'},
                                        {name: 'SMCFInactivityTimeout',mapping:'SMCFInactivityTimeout'},
                                        {name: 'SMCFPasswordMinLength',mapping:'SMCFPasswordMinLength'},
                                         {name: 'SMCFNowNominator',mapping:'SMCFNowNominator'},
                                        {name: 'SMCFPasswordDaysToExpire',mapping:'SMCFPasswordDaysToExpire'},
                                        {name: 'SMCFInvalidLoginAttempts',mapping:'SMCFInvalidLoginAttempts'},
                                        {name: 'SMCFTodayNominator',mapping:'SMCFTodayNominator'},
                                         {name: 'SMCFCloseAllFormsOnExit',mapping:'SMCFCloseAllFormsOnExit'},
                                        {name: 'SMCFCreateWebIndexes',mapping:'SMCFCreateWebIndexes'},
                                        {name: 'SMCFDoNotDeleteGrouperFile',mapping:'SMCFDoNotDeleteGrouperFile'},
                                        {name: 'SMCFNoRestrictUserSameGroupOE',mapping:'SMCFNoRestrictUserSameGroupOE'},
                                         {name: 'SMCFAllowDeletionFromCodeTables',mapping:'SMCFAllowDeletionFromCodeTables'},
                                        {name: 'SMCFEnableAccessNTLogon',mapping:'SMCFEnableAccessNTLogon'},
                                        {name: 'SMCFPasswContainULSNChars',mapping:'SMCFPasswContainULSNChars'},
                                        {name: 'SMCFRestrictUserSameGroup',mapping:'SMCFRestrictUserSameGroup'}
                                 ]),
		
		items:[{
				fieldLabel : '基础代码表服务器',
				xtype:'textfield',
				width:180,
				id:'SMCFMainDatabaseServer',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFMainDatabaseServer'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFMainDatabaseServer')),
				name : 'SMCFMainDatabaseServer'
			},{
				fieldLabel : '基础代码表命名空间',
				xtype:'textfield',
				width:180,
				maxLength:30,
				id:'SMCFCTNamespace',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCTNamespace'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCTNamespace')),
				name : 'SMCFCTNamespace'
			},{
				fieldLabel : 'System Identification',
				xtype:'textfield',
				width:180,
				hideLabel : 'True',
				hidden : true, 
				id:'SMCFName1',
				maxLength:25,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFName1'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFName1')),
				name : 'SMCFName1'
			},{
				xtype : "combo",
				width:180,
				//emptyText:'请选择',
				fieldLabel : 'billing version',
				hiddenName : 'SMCFBillingVersion',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFBillingVersion'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFBillingVersion')),
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
								name : 'Korean - Inha',
								value : 'KI'
							}, {
								name : 'Italian - Brescia',
								value : 'I'
							}, {
								name : 'European',
								value : 'E'
							}, {
								name : 'Spanish',
								value : 'S'
							}, {
								name : 'Brazilian',
								value : 'B'
							}, {
								name : 'Bahrain',
								value : 'BH'
							}, {
								name : 'Greek',
								value : 'GR'
							}, {
								name : 'Australian',
								value : 'A'
							}, {
								name : 'Malaysia',
								value : 'M'
							}, {
								name : 'Thailand',
								value : 'T'
							}, {
								name : 'UK',
								value : 'UK'
							}, {
								name : 'Philippines',
								value : 'PH'
							}, {
								name : 'Taiwan',
								value : 'TW'
							}, {
								name : 'China',
								value : 'CH'
							}, {
								name : 'India',
								value : 'IN'
							}, {
								name : 'Thailand-BGH',
								value : 'TB'
							}, {
								name : 'Thailand-PHYATHAI',
								value : 'TP'
							}, {
								name : 'Australia-Queensland',
								value : 'QA'
							}, {
								name : 'Indonesia',
								value : 'INDON'
							}, {
								name : 'UK Priory',
								value : 'UKP'
							}, {
								name : 'Portugal',
								value : 'PORT'
							}, {
								name : 'Middle East',
								value : 'ME'
							}, {
								name : 'St George',
								value : 'STG'
							}, {
								name : 'GPS-Portugal',
								value : 'GPS'
							}, {
								name : 'Hong Kong',
								value : 'HK'
							}, {
								name : 'Standard',
								value : 'STD'
							
							
							}]
				})	
			},{
				xtype : "combo",
				width:180,
				//emptyText:'请选择',
				fieldLabel : 'MedTrak版本',
				hiddenName : 'SMCFMedTrakVersion',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFMedTrakVersion'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFMedTrakVersion')),
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
								name : 'Korean - Inha',
								value : 'KI'
							}, {
								name : 'Italian - Brescia',
								value : 'I'
							
							}]
				})	
			},{
				xtype : "combo",
				//emptyText:'请选择',
				width:180,
				fieldLabel : 'Word版本',
				hiddenName : 'SMCFWordVersion',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFWordVersion'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFWordVersion')),
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
								name : 'Italian 95',
								value : 'I'
							}, {
								name : 'Spanish 95',
								value : 'S'
							}, {
								name : 'Office 95',
								value : 'N'
							}, {
								name : 'Office 97',
								value : 'O'
							}, {
								name : 'Portuguese',
								value : 'P'
							}, {
								name : 'German',
								value : 'GE'
							}, {
								name : 'Finnish',
								value : 'FI'
							}, {
								name : 'Greek',
								value : 'GR'
							}, {
								name : 'French',
								value : 'FR'
							}]
				})	
			},{
						xtype: 'fieldset',		
						style:'padding: 0 0 0 0;',
						title:'ODBC Logon Details',
						width:370,
						items:[
				{
				fieldLabel : '数据源名称',
				xtype:'textfield',
				id:'SMCFCrystalRepDSN',
				maxLength:30,
				width:180,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCrystalRepDSN'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCrystalRepDSN')),
				name : 'SMCFCrystalRepDSN'
			},{
				fieldLabel : '用户ID',
				xtype:'textfield',
				maxLength:30,
				width:180,
				id:'SMCFCrystalRepUserID',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCrystalRepUserID'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCrystalRepUserID')),
				name : 'SMCFCrystalRepUserID'
			},{
				fieldLabel : '密码',
				xtype:'textfield',
				inputType : 'password',
				maxLength:30,
				width:180,
				id:'SMCFCrystRepPassword',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCrystRepPassword'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCrystRepPassword')),
				name : 'SMCFCrystRepPassword'
			}]
			},{
				fieldLabel : 'HL7 Query Timeout In Seconds',
				xtype:'numberfield',
				width:180,
				id:'SMCFHL7QueryTimeoutInSecs',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFHL7QueryTimeoutInSecs'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFHL7QueryTimeoutInSecs')),
				name : 'SMCFHL7QueryTimeoutInSecs'
			},{
				fieldLabel : 'Inactivity Timeout in minutes',
				xtype:'numberfield',
				width:180,
				id:'SMCFInactivityTimeout',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFInactivityTimeout'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFInactivityTimeout')),
				name : 'SMCFInactivityTimeout'
			},{
				fieldLabel : '密码长度最小值',
				xtype:'numberfield',
				width:180,
				id:'SMCFPasswordMinLength',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFPasswordMinLength'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFPasswordMinLength')),
				name : 'SMCFPasswordMinLength'
			},{
				fieldLabel : '"Now" Nominator in time fields',
				xtype:'textfield',
				id:'SMCFNowNominator',
				width:180,
				maxLength:1,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFNowNominator'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFNowNominator')),
				name : 'SMCFNowNominator'
			},{
				fieldLabel : '密码过期时间(日)',
				xtype:'numberfield',
				width:180,
				id:'SMCFPasswordDaysToExpire',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFPasswordDaysToExpire'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFPasswordDaysToExpire')),
				name : 'SMCFPasswordDaysToExpire'
			},{
				fieldLabel : 'number of incorrect login sttempts to mark user as not active',
				xtype:'numberfield',
				width:180,
				id:'SMCFInvalidLoginAttempts',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFInvalidLoginAttempts'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFInvalidLoginAttempts')),
				name : 'SMCFInvalidLoginAttempts'
			},{
				fieldLabel : '"Today" Nominator in date fields',
				xtype:'textfield',
				maxLength:1,
				width:180,
				id:'SMCFTodayNominator',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFTodayNominator'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFTodayNominator')),
				name : 'SMCFTodayNominator'
		
			},	
			{
				boxLabel:'Close All Forms when closing logon form',
				xtype : 'checkbox',
				name : 'SMCFCloseAllFormsOnExit',
				id:'SMCFCloseAllFormsOnExit',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCloseAllFormsOnExit'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCloseAllFormsOnExit')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Create Indexes for web',
				xtype : 'checkbox',
				name : 'SMCFCreateWebIndexes',
				id:'SMCFCreateWebIndexes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCreateWebIndexes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCreateWebIndexes')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'DoNot Delete Grouper File',
				xtype : 'checkbox',
				name : 'SMCFDoNotDeleteGrouperFile',
				id:'SMCFDoNotDeleteGrouperFile',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFDoNotDeleteGrouperFile'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFDoNotDeleteGrouperFile')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot Restrict change of User to the Same security Group in OE',
				xtype : 'checkbox',
				name : 'SMCFNoRestrictUserSameGroupOE',
				id:'SMCFNoRestrictUserSameGroupOE',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFNoRestrictUserSameGroupOE'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFNoRestrictUserSameGroupOE')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'enable Deletion From Code Tables',
				xtype : 'checkbox',
				name : 'SMCFAllowDeletionFromCodeTables',
				id:'SMCFAllowDeletionFromCodeTables',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFAllowDeletionFromCodeTables'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFAllowDeletionFromCodeTables')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Enable use of NT logon name',
				xtype : 'checkbox',
				name : 'SMCFEnableAccessNTLogon',
				id:'SMCFEnableAccessNTLogon',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFEnableAccessNTLogon'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFEnableAccessNTLogon')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Password to contain upper,lower,special and numeric characters',
				xtype : 'checkbox',
				name : 'SMCFPasswContainULSNChars',
				id:'SMCFPasswContainULSNChars',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFPasswContainULSNChars'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFPasswContainULSNChars')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict changes of User to the Same security Group',
				xtype : 'checkbox',
				name : 'SMCFRestrictUserSameGroup',
				id:'SMCFRestrictUserSameGroup',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFRestrictUserSameGroup'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFRestrictUserSameGroup')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitysystem&pEntityName=web.Entity.CT.SystemParameter";
	
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