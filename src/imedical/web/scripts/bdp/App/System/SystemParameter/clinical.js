 /// 名称:系统配置 - 安全组系统配置-临床和电子病历
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   
    var PATCFMRCTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetMRCDiagnosType";
	var PATCFDefNewBornDepDR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var PATCFNewBornEpisSubTypeDR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACEpisodeSubType&pClassQuery=GetDataForCmb1";
	var PATCFFemaleSexDR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	var PATCFAllergyDR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAllergy&pClassQuery=GetDataForCmb1";
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
                                        {name: 'PATCFMRCType2DR',mapping:'PATCFMRCType2DR'},
                                        {name: 'PATCFMRCType1DR',mapping:'PATCFMRCType1DR'},
                                        {name: 'PATCFDefNewBornDepDR',mapping:'PATCFDefNewBornDepDR'},
                                        {name: 'PATCFNewBornEpisSubTypeDR',mapping:'PATCFNewBornEpisSubTypeDR'},
                                        {name: 'PATCFFemaleSexDR',mapping:'PATCFFemaleSexDR'},
                                        {name: 'PATCFAllergyDR',mapping:'PATCFAllergyDR'},
                                        {name: 'OECFTextForDeletedTestItem',mapping:'OECFTextForDeletedTestItem'},
                                        {name: 'PATCFActivateAdvancdEPRSecu',mapping:'PATCFActivateAdvancdEPRSecu'},
                                        {name: 'PATCFActivateAdvancdSOAPCon',mapping:'PATCFActivateAdvancdSOAPCon'},
                                        {name: 'PATCFAutomaticReadLinkedProvide',mapping:'PATCFAutomaticReadLinkedProvide'},
                                        {name: 'PATCFExtendDiagnosis',mapping:'PATCFExtendDiagnosis'},
                                        {name: 'PATCFRestrictSingleDiagType',mapping:'PATCFRestrictSingleDiagType'},
                                        {name: 'PATCFShowPreviousEMR',mapping:'PATCFShowPreviousEMR'},
                                        {name: 'PATCFSortByQueue',mapping:'PATCFSortByQueue'},
                                        {name: 'PATCFGestationMaxWeeks',mapping:'PATCFGestationMaxWeeks'},
                                        {name: 'PATCFGestationMinWeeks',mapping:'PATCFGestationMinWeeks'},
                                        {name: 'PATCFGestationMaxDays',mapping:'PATCFGestationMaxDays'},
                                        {name: 'PATCFGestationMinDays',mapping:'PATCFGestationMinDays'},
                                        {name: 'PATCFBirthWeightMax',mapping:'PATCFBirthWeightMax'},
                                        
                                        {name: 'PATCFBirthWeightMin',mapping:'PATCFBirthWeightMin'}
                                 ]),
		
		items:[
			
				{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'def diagnosis type for additional diagnoses',
				hiddenName : 'PATCFMRCType2DR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMRCType2DR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMRCType2DR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'DTYPDesc',
				valueField : 'DTYPRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFMRCTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'DTYPRowId',mapping:'DTYPRowId'},
							{name:'DTYPDesc',mapping:'DTYPDesc'} ])
					})

			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'def for first diagnosis type',
				hiddenName : 'PATCFMRCType1DR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMRCType1DR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMRCType1DR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'DTYPDesc',
				valueField : 'DTYPRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFMRCTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'DTYPRowId',mapping:'DTYPRowId'},
							{name:'DTYPDesc',mapping:'DTYPDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '新生儿默认科室',
				hiddenName : 'PATCFDefNewBornDepDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDefNewBornDepDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDefNewBornDepDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTLOCDesc',
				valueField : 'CTLOCRowID',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFDefNewBornDepDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTLOCRowID',mapping:'CTLOCRowID'},
							{name:'CTLOCDesc',mapping:'CTLOCDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '新生儿默认就诊类型',
				hiddenName : 'PATCFNewBornEpisSubTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNewBornEpisSubTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNewBornEpisSubTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'SUBTDesc',
				valueField : 'SUBTRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFNewBornEpisSubTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'SUBTRowId',mapping:'SUBTRowId'},
							{name:'SUBTDesc',mapping:'SUBTDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Newborn menu Restricted to sex',  ///bug5577
				hiddenName : 'PATCFFemaleSexDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFFemaleSexDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFFemaleSexDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTSEXDesc',
				valueField : 'CTSEXRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFFemaleSexDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTSEXRowId',mapping:'CTSEXRowId'},
							{name:'CTSEXDesc',mapping:'CTSEXDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'nil过敏源',
				hiddenName : 'PATCFAllergyDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllergyDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllergyDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'ALGDesc',
				valueField : 'ALGRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFAllergyDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'ALGRowId',mapping:'ALGRowId'},
							{name:'ALGDesc',mapping:'ALGDesc'} ])
					})
					
			},{
				fieldLabel : 'text for deleted value',
				xtype:'textfield',
				width:200,
				id:'OECFTextForDeletedTestItem',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFTextForDeletedTestItem'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFTextForDeletedTestItem')),
				name : 'OECFTextForDeletedTestItem'
			},{	
				boxLabel:'active advanced EPR security',
				xtype : 'checkbox',
				name : 'PATCFActivateAdvancdEPRSecu',
				id:'PATCFActivateAdvancdEPRSecu',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFActivateAdvancdEPRSecu'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFActivateAdvancdEPRSecu')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Activate Advancd SOAP Consult security',
				xtype : 'checkbox',
				name : 'PATCFActivateAdvancdSOAPCon',
				id:'PATCFActivateAdvancdSOAPCon',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFActivateAdvancdSOAPCon'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFActivateAdvancdSOAPCon')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'auto read for linked care provider',
				xtype : 'checkbox',
				name : 'PATCFAutomaticReadLinkedProvider',
				id:'PATCFAutomaticReadLinkedProvider',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAutomaticReadLinkedProvider'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAutomaticReadLinkedProvider')),
				inputValue : true?'Y':'N',
				checked:false
			},{	
				boxLabel:'Extend Diagnosis listbox to full screen',
				xtype : 'checkbox',
				name : 'PATCFExtendDiagnosis',
				id:'PATCFExtendDiagnosis',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFExtendDiagnosis'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFExtendDiagnosis')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict to Single Diagnosis Type',
				xtype : 'checkbox',
				name : 'PATCFRestrictSingleDiagType',
				id:'PATCFRestrictSingleDiagType',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictSingleDiagType'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictSingleDiagType')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show Previous EMR',
				xtype : 'checkbox',
				name : 'PATCFShowPreviousEMR',
				id:'PATCFShowPreviousEMR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowPreviousEMR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowPreviousEMR')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Sort patients By Queue number',
				xtype : 'checkbox',
				name : 'PATCFSortByQueue',
				id:'PATCFSortByQueue',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSortByQueue'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSortByQueue')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				fieldLabel : 'max Gestation Weeks',
				xtype:'numberfield',
				id:'PATCFGestationMaxWeeks',
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMaxWeeks'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMaxWeeks')),
				name : 'PATCFGestationMaxWeeks'
			},{
				fieldLabel : 'min Gestation Weeks',
				xtype:'numberfield',
				id:'PATCFGestationMinWeeks',
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMinWeeks'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMinWeeks')),
				name : 'PATCFGestationMinWeeks'
			},{
				fieldLabel : 'max Gestation Days',
				xtype:'numberfield',
				id:'PATCFGestationMaxDays',
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMaxDays'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMaxDays')),
				name : 'PATCFGestationMaxDays'
			},{
				fieldLabel : 'min Gestation Days',
				xtype:'numberfield',
				id:'PATCFGestationMinDays',
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMinDays'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGestationMinDays')),
				name : 'PATCFGestationMinDays'
			},{
				fieldLabel : 'max Birth Weight',
				xtype:'numberfield',
				id:'PATCFBirthWeightMax',
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFBirthWeightMax'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFBirthWeightMax')),
				name : 'PATCFBirthWeightMax'
			},{
				fieldLabel : 'min Birth Weight',
				xtype:'numberfield',
				id:'PATCFBirthWeightMin',
				width:200,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFBirthWeightMin'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFBirthWeightMin')),
				name : 'PATCFBirthWeightMin'
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntityclinical&pEntityName=web.Entity.CT.SystemParameter";
	
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