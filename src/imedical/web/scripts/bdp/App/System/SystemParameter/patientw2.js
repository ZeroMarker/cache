 /// 名称:系统配置 - 安全组系统配置-病人管理(WEB)2
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
                                        {name: 'PATCFAllowCarePlanIntApptDCONOu',mapping:'PATCFAllowCarePlanIntApptDCONOu'},
                                        {name: 'PATCFAllowMultipleActiveGP',mapping:'PATCFAllowMultipleActiveGP'},
                                        {name: 'PATCFAllowOverlapGP',mapping:'PATCFAllowOverlapGP'},
                                        {name: 'PATCFAllowOverlapIPEpisodes',mapping:'PATCFAllowOverlapIPEpisodes'},
                                        {name: 'PATCFConfirmCreateAliasSexDOB',mapping:'PATCFConfirmCreateAliasSexDOB'},
                                        {name: 'PATCFConfirmToSaveAsPreviousAdd',mapping:'PATCFConfirmToSaveAsPreviousAdd'},
                                        {name: 'PATCFCopyAlrgAlrtToBothPatU',mapping:'PATCFCopyAlrgAlrtToBothPatU'},
                                        {name: 'PATCFDefProcDateSameDay',mapping:'PATCFDefProcDateSameDay'},
                                        {name: 'PATCFShowPreAdmInfoOnEDBedReque',mapping:'PATCFShowPreAdmInfoOnEDBedReque'},
                                        {name: 'PATCFNoOrdersCopyFromOrigAdm',mapping:'PATCFNoOrdersCopyFromOrigAdm'},
                                       
                                        {name: 'PATCFDontDischOutPatOnDecease',mapping:'PATCFDontDischOutPatOnDecease'},
                                        {name: 'PATCFDontDisplayInactiveAlias',mapping:'PATCFDontDisplayInactiveAlias'},
                                        {name: 'PATCFNoExecuteOrdUponDisc',mapping:'PATCFNoExecuteOrdUponDisc'},
                                        {name: 'PATCFNoGenPRNforEMergPats',mapping:'PATCFNoGenPRNforEMergPats'},
                                        {name: 'PATCFNoTempLocUpdateOnPatArriva',mapping:'PATCFNoTempLocUpdateOnPatArriva'},
                                        {name: 'PATCFErrorOnExtractCodingIncomp',mapping:'PATCFErrorOnExtractCodingIncomp'},
                                        {name: 'PATCFExternalPatValid',mapping:'PATCFExternalPatValid'},
                                        {name: 'PATCFInclRecsAfterExtrctEndDate',mapping:'PATCFInclRecsAfterExtrctEndDate'},
                                        {name: 'PATCFIPInclDischPat',mapping:'PATCFIPInclDischPat'},
                                        {name: 'PATCFConfirmCreateAliasName',mapping:'PATCFConfirmCreateAliasName'},
                                        {name: 'PATCFRestCancerRegLogonHosp',mapping:'PATCFRestCancerRegLogonHosp'},
                                        {name: 'PATCFRestrictAdmListForLogonHos',mapping:'PATCFRestrictAdmListForLogonHos'},
                                        {name: 'PATCFRestWardDeptBook',mapping:'PATCFRestWardDeptBook'},
                                        {name: 'PATCFSameDayPreAdm',mapping:'PATCFSameDayPreAdm'},
                                        {name: 'PATCFSearchStartswithRego',mapping:'PATCFSearchStartswithRego'},
                                        {name: 'PATCFTBCAlrgAlertEpisMove',mapping:'PATCFTBCAlrgAlertEpisMove'},
                                        {name: 'PATCFShowMRNumberFloorPlan',mapping:'PATCFShowMRNumberFloorPlan'},
                                        {name: 'PATCFShowRegWaitTimeFloorPlan',mapping:'PATCFShowRegWaitTimeFloorPlan'},
                                        {name: 'PATCFSMRReporting',mapping:'PATCFSMRReporting'},
                                        {name: 'PATCFShowWarnProcDateOutEpis',mapping:'PATCFShowWarnProcDateOutEpis'},
                                        {name: 'PATCFSortBySurnameFirstOther',mapping:'PATCFSortBySurnameFirstOther'},
                                        {name: 'PATCFSuppressMRRego',mapping:'PATCFSuppressMRRego'},
                                        {name: 'PATCFUseBedReqDateTimeEm',mapping:'PATCFUseBedReqDateTimeEm'},
                                        {name: 'PATCFEmergStandAlone',mapping:'PATCFEmergStandAlone'},
                                        {name: 'PATCFUseSoundexSearchAllNames',mapping:'PATCFUseSoundexSearchAllNames'}
                                 ]),
		
		items:[
			{
				boxLabel:'Allow D/C all Care Plan Intervention and associated appointment on outcome close',
				xtype : 'checkbox',
				name : 'PATCFAllowCarePlanIntApptDCONOu',
				id:'PATCFAllowCarePlanIntApptDCONOu',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowCarePlanIntApptDCONOu'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowCarePlanIntApptDCONOu')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'allow Multiple Active GP',
				xtype : 'checkbox',
				name : 'PATCFAllowMultipleActiveGP',
				id:'PATCFAllowMultipleActiveGP',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowMultipleActiveGP'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowMultipleActiveGP')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow Overlapping dates in doctor history',
				xtype : 'checkbox',
				name : 'PATCFAllowOverlapGP',
				id:'PATCFAllowOverlapGP',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowOverlapGP'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowOverlapGP')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow Overlapping IP Episodes',
				xtype : 'checkbox',
				name : 'PATCFAllowOverlapIPEpisodes',
				id:'PATCFAllowOverlapIPEpisodes',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowOverlapIPEpisodes'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowOverlapIPEpisodes')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Confirm to Create Alias Sex DOB',
				xtype : 'checkbox',
				name : 'PATCFConfirmCreateAliasSexDOB',
				id:'PATCFConfirmCreateAliasSexDOB',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFConfirmCreateAliasSexDOB'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFConfirmCreateAliasSexDOB')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Confirm To Save As Previous Address',
				xtype : 'checkbox',
				name : 'PATCFConfirmToSaveAsPreviousAdd',
				id:'PATCFConfirmToSaveAsPreviousAdd',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFConfirmToSaveAsPreviousAdd'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFConfirmToSaveAsPreviousAdd')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Copy Allergies Alerts To Both Patient on Unmerge',
				xtype : 'checkbox',
				name : 'PATCFCopyAlrgAlrtToBothPatU',
				id:'PATCFCopyAlrgAlrtToBothPatU',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyAlrgAlrtToBothPatU'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyAlrgAlrtToBothPatU')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Default Procedure Date if Same Day',
				xtype : 'checkbox',
				name : 'PATCFDefProcDateSameDay',
				id:'PATCFDefProcDateSameDay',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDefProcDateSameDay'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDefProcDateSameDay')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'display PreAdm episode Info On ED Bed Request',
				xtype : 'checkbox',
				name : 'PATCFShowPreAdmInfoOnEDBedReque',
				id:'PATCFShowPreAdmInfoOnEDBedReque',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowPreAdmInfoOnEDBedRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowPreAdmInfoOnEDBedRequest')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot copy orders from Original admission',
				xtype : 'checkbox',
				name : 'PATCFNoOrdersCopyFromOrigAdm',
				id:'PATCFNoOrdersCopyFromOrigAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoOrdersCopyFromOrigAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoOrdersCopyFromOrigAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Donot Discharge OutPatient On Decease',
				xtype : 'checkbox',
				name : 'PATCFDontDischOutPatOnDecease',
				id:'PATCFDontDischOutPatOnDecease',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDontDischOutPatOnDecease'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDontDischOutPatOnDecease')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Dont Display Inactive Alias',
				xtype : 'checkbox',
				name : 'PATCFDontDisplayInactiveAlias',
				id:'PATCFDontDisplayInactiveAlias',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDontDisplayInactiveAlias'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDontDisplayInactiveAlias')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot Execute Orders Upon patient Discharge',
				xtype : 'checkbox',
				name : 'PATCFNoExecuteOrdUponDisc',
				id:'PATCFNoExecuteOrdUponDisc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoExecuteOrdUponDisc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoExecuteOrdUponDisc')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'donot Generate PRN for Emergency Patients',
				xtype : 'checkbox',
				name : 'PATCFNoGenPRNforEMergPats',
				id:'PATCFNoGenPRNforEMergPats',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoGenPRNforEMergPats'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoGenPRNforEMergPats')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'doNot update/Temp Location on Patient Arrival',
				xtype : 'checkbox',
				name : 'PATCFNoTempLocUpdateOnPatArriva',
				id:'PATCFNoTempLocUpdateOnPatArriva',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoTempLocUpdateOnPatArriva'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoTempLocUpdateOnPatArriva')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Error On Extract if Coding Incomplete',
				xtype : 'checkbox',
				name : 'PATCFErrorOnExtractCodingIncomp',
				id:'PATCFErrorOnExtractCodingIncomp',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFErrorOnExtractCodingIncomp'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFErrorOnExtractCodingIncomp')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'External Patient Validation',
				xtype : 'checkbox',
				name : 'PATCFExternalPatValid',
				id:'PATCFExternalPatValid',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFExternalPatValid'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFExternalPatValid')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Include Records After Extrct End Date',
				xtype : 'checkbox',
				name : 'PATCFInclRecsAfterExtrctEndDate',
				id:'PATCFInclRecsAfterExtrctEndDate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFInclRecsAfterExtrctEndDate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFInclRecsAfterExtrctEndDate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Include recently Discharge Patient on inpatient search',
				xtype : 'checkbox',
				name : 'PATCFIPInclDischPat',
				id:'PATCFIPInclDischPat',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFIPInclDischPat'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFIPInclDischPat')),
				inputValue : true?'Y':'N',
				checked:false
	
			},{boxLabel:'never Create Alias Name',
				xtype : 'checkbox',
				name : 'PATCFConfirmCreateAliasName',
				id:'PATCFConfirmCreateAliasName',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFConfirmCreateAliasName'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFConfirmCreateAliasName')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict Cancer Registration to Logon Hospital',
				xtype : 'checkbox',
				name : 'PATCFRestCancerRegLogonHosp',
				id:'PATCFRestCancerRegLogonHosp',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRestCancerRegLogonHosp'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRestCancerRegLogonHosp')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict episode List For Logon Hosp',
				xtype : 'checkbox',
				name : 'PATCFRestrictAdmListForLogonHos',
				id:'PATCFRestrictAdmListForLogonHos',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictAdmListForLogonHos'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictAdmListForLogonHos')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict Ward/Department for Booking',
				xtype : 'checkbox',
				name : 'PATCFRestWardDeptBook',
				id:'PATCFRestWardDeptBook',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRestWardDeptBook'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRestWardDeptBook')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Same Day PreAdmission',
				xtype : 'checkbox',
				name : 'PATCFSameDayPreAdm',
				id:'PATCFSameDayPreAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSameDayPreAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSameDayPreAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Search on Startswith Rego on patient find',
				xtype : 'checkbox',
				name : 'PATCFSearchStartswithRego',
				id:'PATCFSearchStartswithRego',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchStartswithRego'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchStartswithRego')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'set Allergies and alerts to TBC after episode move',
				xtype : 'checkbox',
				name : 'PATCFTBCAlrgAlertEpisMove',
				id:'PATCFTBCAlrgAlertEpisMove',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTBCAlrgAlertEpisMove'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTBCAlrgAlertEpisMove')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show MR Number on FloorPlan',
				xtype : 'checkbox',
				name : 'PATCFShowMRNumberFloorPlan',
				id:'PATCFShowMRNumberFloorPlan',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowMRNumberFloorPlan'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowMRNumberFloorPlan')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show registration waiting time on FloorPlan',
				xtype : 'checkbox',
				name : 'PATCFShowRegWaitTimeFloorPlan',
				id:'PATCFShowRegWaitTimeFloorPlan',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowRegWaitTimeFloorPlan'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowRegWaitTimeFloorPlan')),
				inputValue : true?'Y':'N',
				checked:false
					
			},{
				boxLabel:'SMR Reporting',
				xtype : 'checkbox',
				name : 'PATCFSMRReporting',
				id:'PATCFSMRReporting',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSMRReporting'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSMRReporting')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Show Warning message when Procedure Date Out of Episode',
				xtype : 'checkbox',
				name : 'PATCFShowWarnProcDateOutEpis',
				id:'PATCFShowWarnProcDateOutEpis',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowWarnProcDateOutEpis'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowWarnProcDateOutEpis')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Sort By Surname,First,Other name',
				xtype : 'checkbox',
				name : 'PATCFSortBySurnameFirstOther',
				id:'PATCFSortBySurnameFirstOther',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSortBySurnameFirstOther'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSortBySurnameFirstOther')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Suppress medical record number if same as registration number',
				xtype : 'checkbox',
				name : 'PATCFSuppressMRRego',
				id:'PATCFSuppressMRRego',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSuppressMRRego'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSuppressMRRego')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Bed Request Datea and Time for preadmission from Emergency',
				xtype : 'checkbox',
				name : 'PATCFUseBedReqDateTimeEm',
				id:'PATCFUseBedReqDateTimeEm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseBedReqDateTimeEm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseBedReqDateTimeEm')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'use Emergency as Stand Alone',
				xtype : 'checkbox',
				name : 'PATCFEmergStandAlone',
				id:'PATCFEmergStandAlone',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFEmergStandAlone'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFEmergStandAlone')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Soundex Search on All Names',
				xtype : 'checkbox',
				name : 'PATCFUseSoundexSearchAllNames',
				id:'PATCFUseSoundexSearchAllNames',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseSoundexSearchAllNames'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseSoundexSearchAllNames')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypatientw2&pEntityName=web.Entity.CT.SystemParameter";
	
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