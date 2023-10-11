 /// 名称:系统配置 - 安全组系统配置-病人管理2
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
                                        {name: 'PATCFEmergencyPatBedOption',mapping:'PATCFEmergencyPatBedOption'},
                                        {name: 'PATCFAllowSelfAdmission',mapping:'PATCFAllowSelfAdmission'},
                                        {name: 'PATCFUsePayorFromPrevEpisode',mapping:'PATCFUsePayorFromPrevEpisode'},
                                        {name: 'PATCFArrivePatientOnReg',mapping:'PATCFArrivePatientOnReg'},
                                        {name: 'PATCFAssignDepartmentToBed',mapping:'PATCFAssignDepartmentToBed'},
                                        {name: 'PATCFShowreasonChangePatData',mapping:'PATCFShowreasonChangePatData'},
                                        {name: 'PATCFUseDRGGrouper',mapping:'PATCFUseDRGGrouper'},
                                        {name: 'PATCFChooseReferalDoctorFromLis',mapping:'PATCFChooseReferalDoctorFromLis'},
                                        {name: 'PATCFCollectRegistrFee',mapping:'PATCFCollectRegistrFee'},
                                        {name: 'PATCFProcess',mapping:'PATCFProcess'},
                                        {name: 'PATCFDefAdmDepartBDMAN',mapping:'PATCFDefAdmDepartBDMAN'},
                                        {name: 'PATCFDef2ndTabEpisDetails',mapping:'PATCFDef2ndTabEpisDetails'},
                                        {name: 'PATCFDisableInsuranceOfficeComb',mapping:'PATCFDisableInsuranceOfficeComb'},
                                        {name: 'PATCFDisplayRegDetAfterBedAssig',mapping:'PATCFDisplayRegDetAfterBedAssig'},
                                        {name: 'PATCFShowPreadmAfterAppoint',mapping:'PATCFShowPreadmAfterAppoint'},
                                        {name: 'PATCFIsRefDoctorMandatory',mapping:'PATCFIsRefDoctorMandatory'},
                                        {name: 'PATCFDisplayZipDescription',mapping:'PATCFDisplayZipDescription'},
                                        {name: 'PATCFRefreshPATMANOE',mapping:'PATCFRefreshPATMANOE'},
                                        {name: 'PATCFSaveOutPatEpUponInConv',mapping:'PATCFSaveOutPatEpUponInConv'},
                                        {name: 'PATCFSaveRegNumExtDB',mapping:'PATCFSaveRegNumExtDB'},
                                        {name: 'PATCFSearchByKeywords',mapping:'PATCFSearchByKeywords'},
                                        {name: 'PATCFSearchOnExactMRN',mapping:'PATCFSearchOnExactMRN'},
                                        {name: 'PATCFShowOEMessageOnAdmUpdate',mapping:'PATCFShowOEMessageOnAdmUpdate'},
                                        {name: 'PATCFTransferReasonMandatory',mapping:'PATCFTransferReasonMandatory'},
                                        {name: 'PATCFUseBedManagementScreen',mapping:'PATCFUseBedManagementScreen'},
                                        {name: 'PATCFUseUserDefPayor',mapping:'PATCFUseUserDefPayor'}
                                 ]),
		
		items:[
			{
				
				boxLabel:'允许急诊病人在非急诊床位上',
				xtype : 'checkbox',
				name : 'PATCFEmergencyPatBedOption',
				id:'PATCFEmergencyPatBedOption',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFEmergencyPatBedOption'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFEmergencyPatBedOption')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow inpatient Self Admission',
				xtype : 'checkbox',
				name : 'PATCFAllowSelfAdmission',
				id:'PATCFAllowSelfAdmission',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowSelfAdmission'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowSelfAdmission')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Payor defaults From Previous Episodes',
				xtype : 'checkbox',
				name : 'PATCFUsePayorFromPrevEpisode',
				id:'PATCFUsePayorFromPrevEpisode',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUsePayorFromPrevEpisode'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUsePayorFromPrevEpisode')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Arrive Patient On Registration',
				xtype : 'checkbox',
				name : 'PATCFArrivePatientOnReg',
				id:'PATCFArrivePatientOnReg',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFArrivePatientOnReg'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFArrivePatientOnReg')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Assign Department To individual Bed',
				xtype : 'checkbox',
				name : 'PATCFAssignDepartmentToBed',
				id:'PATCFAssignDepartmentToBed',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAssignDepartmentToBed'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAssignDepartmentToBed')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'audit changes to patient and episode date',
				xtype : 'checkbox',
				name : 'PATCFShowreasonChangePatData',
				id:'PATCFShowreasonChangePatData',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowreasonChangePatData'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowreasonChangePatData')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'build index of information for DRG Grouper',
				xtype : 'checkbox',
				name : 'PATCFUseDRGGrouper',
				id:'PATCFUseDRGGrouper',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseDRGGrouper'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseDRGGrouper')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Choose Referal Doctor From List',
				xtype : 'checkbox',
				name : 'PATCFChooseReferalDoctorFromLis',
				id:'PATCFChooseReferalDoctorFromLis',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFChooseReferalDoctorFromLis'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFChooseReferalDoctorFromLis')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Collect Registration Fee',
				xtype : 'checkbox',
				name : 'PATCFCollectRegistrFee',
				id:'PATCFCollectRegistrFee',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCollectRegistrFee'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCollectRegistrFee')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'combine episode into Process',
				xtype : 'checkbox',
				name : 'PATCFProcess',
				id:'PATCFProcess',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFProcess'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFProcess')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Default Admitting Department in Bed Management',
				xtype : 'checkbox',
				name : 'PATCFDefAdmDepartBDMAN',
				id:'PATCFDefAdmDepartBDMAN',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDefAdmDepartBDMAN'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDefAdmDepartBDMAN')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Default episode details from "visit details continue tab"',
				xtype : 'checkbox',
				name : 'PATCFDef2ndTabEpisDetails',
				id:'PATCFDef2ndTabEpisDetails',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDef2ndTabEpisDetails'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDef2ndTabEpisDetails')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Disable payor Office Combo',
				xtype : 'checkbox',
				name : 'PATCFDisableInsuranceOfficeComb',
				id:'PATCFDisableInsuranceOfficeComb',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDisableInsuranceOfficeComb'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDisableInsuranceOfficeComb')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Display episode Details After Bed Assignment',
				xtype : 'checkbox',
				name : 'PATCFDisplayRegDetAfterBedAssig',
				id:'PATCFDisplayRegDetAfterBedAssig',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDisplayRegDetAfterBedAssig'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDisplayRegDetAfterBedAssig')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'display episode details after making appointment',
				xtype : 'checkbox',
				name : 'PATCFShowPreadmAfterAppoint',
				id:'PATCFShowPreadmAfterAppoint',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowPreadmAfterAppoint'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowPreadmAfterAppoint')),
				inputValue : true?'Y':'N',
				checked:false
			}
			,{
				boxLabel:'outpatient Referral Doctor Mandatory',
				xtype : 'checkbox',
				name : 'PATCFIsRefDoctorMandatory',
				id:'PATCFIsRefDoctorMandatory',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFIsRefDoctorMandatory'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFIsRefDoctorMandatory')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Display Zip Description',
				xtype : 'checkbox',
				name : 'PATCFDisplayZipDescription',
				id:'PATCFDisplayZipDescription',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDisplayZipDescription'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDisplayZipDescription')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Refresh patient after update and order entry',
				xtype : 'checkbox',
				name : 'PATCFRefreshPATMANOE',
				id:'PATCFRefreshPATMANOE',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRefreshPATMANOE'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRefreshPATMANOE')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Save OutPatient Episode Upon Inpatient Conversation',
				xtype : 'checkbox',
				name : 'PATCFSaveOutPatEpUponInConv',
				id:'PATCFSaveOutPatEpUponInConv',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSaveOutPatEpUponInConv'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSaveOutPatEpUponInConv')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Save Registration Number fron External DataBase',
				xtype : 'checkbox',
				name : 'PATCFSaveRegNumExtDB',
				id:'PATCFSaveRegNumExtDB',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSaveRegNumExtDB'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSaveRegNumExtDB')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'通过关键字搜索',
				xtype : 'checkbox',
				name : 'PATCFSearchByKeywords',
				id:'PATCFSearchByKeywords',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchByKeywords'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchByKeywords')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Search On Exact MRN',
				xtype : 'checkbox',
				name : 'PATCFSearchOnExactMRN',
				id:'PATCFSearchOnExactMRN',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchOnExactMRN'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchOnExactMRN')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'登记时显示医嘱入口信息',
				xtype : 'checkbox',
				name : 'PATCFShowOEMessageOnAdmUpdate',
				id:'PATCFShowOEMessageOnAdmUpdate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowOEMessageOnAdmUpdate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowOEMessageOnAdmUpdate')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Transfer Reason Mandatory',
				xtype : 'checkbox',
				name : 'PATCFTransferReasonMandatory',
				id:'PATCFTransferReasonMandatory',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTransferReasonMandatory'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTransferReasonMandatory')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Bed Management Screen',
				xtype : 'checkbox',
				name : 'PATCFUseBedManagementScreen',
				id:'PATCFUseBedManagementScreen',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseBedManagementScreen'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseBedManagementScreen')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use User Defaults for payor/plan',
				xtype : 'checkbox',
				name : 'PATCFUseUserDefPayor',
				id:'PATCFUseUserDefPayor',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseUserDefPayor'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseUserDefPayor')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypatient2&pEntityName=web.Entity.CT.SystemParameter";
	
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