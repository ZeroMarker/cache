 /// 名称:系统配置 - 安全组系统配置-病人管理
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');


Ext.onReady(function() {	
  Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
    var PATCFWLStatOnAdmDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForWLS";
	var PATCFContactTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetPACContactType";
    var PATCFDaySurgeryTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACEpisodeSubType&pClassQuery=GetDataForCmb1";
	var PATCFBedTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedType&pClassQuery=GetDataForCmb1";
	var PATCFLanguageDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetDataForCmb1";
	var PATCFExemptionCounterTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetPACCounterType";
    
	
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
		labelWidth : 160,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'PATCFWLStatOnAdmDR',mapping:'PATCFWLStatOnAdmDR'},
                                        {name: 'PATCFCancelWListStatusDR',mapping:'PATCFCancelWListStatusDR'},
                                        {name: 'PATCFContactTypeDR',mapping:'PATCFContactTypeDR'},
                                        {name: 'PATCFDaySurgeryTypeDR',mapping:'PATCFDaySurgeryTypeDR'},
                                        {name: 'PATCFDeceasedWaitListDR',mapping:'PATCFDeceasedWaitListDR'},
                                        {name: 'PATCFBedTypeDR',mapping:'PATCFBedTypeDR'},
                                        {name: 'PATCFLanguageDR',mapping:'PATCFLanguageDR'},
                                        {name: 'PATCFExemptionCounterTypeDR',mapping:'PATCFExemptionCounterTypeDR'},
                                        {name: 'PATCFGenerateAdmNo',mapping:'PATCFGenerateAdmNo'},
                                        {name: 'PATCFGenerateRego',mapping:'PATCFGenerateRego'},
                                        {name: 'PATCFHICClaimCounterDR',mapping:'PATCFHICClaimCounterDR'},
                                        {name: 'PATCFNextOfKin',mapping:'PATCFNextOfKin'},
                                        {name: 'PATCFUpperLimitDisplayDays',mapping:'PATCFUpperLimitDisplayDays'},
                                        {name: 'PATCFUpperLimitDisplayWeeks',mapping:'PATCFUpperLimitDisplayWeeks'},
                                        {name: 'PATCFUpperLimitDisplayMonths',mapping:'PATCFUpperLimitDisplayMonths'},
                                        {name: 'PATCFSearchOnDays',mapping:'PATCFSearchOnDays'},
                                        {name: 'PATCFSearchOnMonth',mapping:'PATCFSearchOnMonth'},
                                        {name: 'PATCFDefaultTabInRegistration',mapping:'PATCFDefaultTabInRegistration'},
                                        {name: 'PATCFNoRowsDiagProc',mapping:'PATCFNoRowsDiagProc'},
                                        {name: 'PATCFFemalePensionAge',mapping:'PATCFFemalePensionAge'},
                                        {name: 'PATCFLimitNoDaysForSearch',mapping:'PATCFLimitNoDaysForSearch'},
                                        {name: 'PATCFMalePensionAge',mapping:'PATCFMalePensionAge'},
                                        {name: 'PATCFMaxDaysOnLeave',mapping:'PATCFMaxDaysOnLeave'},
                                        {name: 'PATCFFieldLength',mapping:'PATCFFieldLength'},
                                        {name: 'PATCFNoFieldsPatName',mapping:'PATCFNoFieldsPatName'},
                                        {name: 'PATCFNoDaysForAdmSearchToCopyFr',mapping:'PATCFNoDaysForAdmSearchToCopyFr'},
                                        {name: 'PATCFDaysToIncludeDischPat',mapping:'PATCFDaysToIncludeDischPat'},
                                        {name: 'PATCFNoOfYearsAgeSearch',mapping:'PATCFNoOfYearsAgeSearch'},
                                        {name: 'PATCFShowMonthsWhenInactive',mapping:'PATCFShowMonthsWhenInactive'}
                                 ]),
		
		items:[
				{
				 
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Admit wait list',
				hiddenName : 'PATCFWLStatOnAdmDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFWLStatOnAdmDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFWLStatOnAdmDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'WLSDesc',
				valueField : 'WLSRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFWLStatOnAdmDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSRowId',mapping:'WLSRowId'},
							{name:'WLSDesc',mapping:'WLSDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				width:200,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Canceled Wait List',
				hiddenName : 'PATCFCancelWListStatusDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCancelWListStatusDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCancelWListStatusDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'WLSDesc',
				valueField : 'WLSRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFWLStatOnAdmDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSRowId',mapping:'WLSRowId'},
							{name:'WLSDesc',mapping:'WLSDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				width:200,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '联系类型',
				hiddenName : 'PATCFContactTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFContactTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFContactTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CONTTPDesc',
				valueField : 'CONTTPRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFContactTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CONTTPRowId',mapping:'CONTTPRowId'},
							{name:'CONTTPDesc',mapping:'CONTTPDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Day Surgery Type',
				hiddenName : 'PATCFDaySurgeryTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDaySurgeryTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDaySurgeryTypeDR')),
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
							proxy : new Ext.data.HttpProxy({ url : PATCFDaySurgeryTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'SUBTRowId',mapping:'SUBTRowId'},
							{name:'SUBTDesc',mapping:'SUBTDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Deceased Wait List',
				hiddenName : 'PATCFDeceasedWaitListDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDeceasedWaitListDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDeceasedWaitListDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'WLSDesc',
				valueField : 'WLSRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFWLStatOnAdmDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSRowId',mapping:'WLSRowId'},
							{name:'WLSDesc',mapping:'WLSDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '默认床位类型',
				hiddenName : 'PATCFBedTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFBedTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFBedTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'BEDTPDesc',
				valueField : 'BEDTPRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFBedTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'BEDTPRowId',mapping:'BEDTPRowId'},
							{name:'BEDTPDesc',mapping:'BEDTPDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				width:200,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '默认病人为',
				hiddenName : 'PATCFLanguageDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLanguageDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLanguageDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTLANDesc',
				valueField : 'CTLANRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFLanguageDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTLANRowId',mapping:'CTLANRowId'},
							{name:'CTLANDesc',mapping:'CTLANDesc'} ])
					})
			},{
				width:200,
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Exemption Counter Type',
				hiddenName : 'PATCFExemptionCounterTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFExemptionCounterTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFExemptionCounterTypeDR')),
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
							proxy : new Ext.data.HttpProxy({ url : PATCFExemptionCounterTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CNTRowId',mapping:'CNTRowId'},
							{name:'CNTDesc',mapping:'CNTDesc'} ])
					})
			},{
				width:200,
				xtype : "combo",
				//emptyText:'请选择',
				fieldLabel : 'Generate episode Number on',
				hiddenName : 'PATCFGenerateAdmNo',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGenerateAdmNo'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGenerateAdmNo')),
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
								name : 'Admission',
								value : 'A'
							}, {
								name : 'PreAdmission',
								value : 'P'
							
							}]
				})	
			},{
				xtype : "combo",
				//emptyText:'请选择',
				width:200,
				fieldLabel : '生成病人登记号',
				hiddenName : 'PATCFGenerateRego',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGenerateRego'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGenerateRego')),
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
								name : 'Admission',
								value : 'A'
							}, {
								name : 'PreAdmission',
								value : 'P'
							}, {
								name : 'Patient Entry',
								value : 'E'
							
							}]
				})	
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				width:200,
				fieldLabel : 'HIC Claim Counter',
				hiddenName : 'PATCFHICClaimCounterDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFHICClaimCounterDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFHICClaimCounterDR')),
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
							proxy : new Ext.data.HttpProxy({ url : PATCFExemptionCounterTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CNTRowId',mapping:'CNTRowId'},
							{name:'CNTDesc',mapping:'CNTDesc'} ])
					})
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'Next Of Kin',
				hiddenName : 'PATCFNextOfKin',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNextOfKin'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNextOfKin')),
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
								name : 'This Patient Record',
								value : 'T'
							}, {
								name : 'Separate Person Record',
								value : 'S'
							
							}]
				})	
			/*},{
				fieldLabel : 'Display Age',
				id:'DisplayAge',
				name : 'DisplayAge'*/
			},{
				fieldLabel : 'Upper Limit to Display in Days',
				xtype:'numberfield',
				width:200,
				id:'PATCFUpperLimitDisplayDays',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUpperLimitDisplayDays'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUpperLimitDisplayDays')),
				name : 'PATCFUpperLimitDisplayDays'
			},{
				fieldLabel : 'Upper Limit Display in Weeks',
				xtype:'numberfield',
				width:200,
				id:'PATCFUpperLimitDisplayWeeks',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUpperLimitDisplayWeeks'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUpperLimitDisplayWeeks')),
				name : 'PATCFUpperLimitDisplayWeeks'
			},{
				fieldLabel : 'Upper Limit Display in Months',
				xtype:'numberfield',
				width:200,
				id:'PATCFUpperLimitDisplayMonths',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUpperLimitDisplayMonths'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUpperLimitDisplayMonths')),
				name : 'PATCFUpperLimitDisplayMonths'
			
			},{
			
				fieldLabel : 'allow Search On Days',
				xtype:'numberfield',
				width:180,
				id:'PATCFSearchOnDays',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchOnDays'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchOnDays')),
				name : 'PATCFSearchOnDays'
			},{
				fieldLabel : 'allowSearch On Month',
				xtype:'numberfield',
				width:180,
				id:'PATCFSearchOnMonth',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchOnMonth'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFSearchOnMonth')),
				name : 'PATCFSearchOnMonth'
			},{
				fieldLabel : 'Default Tab In Registration',
				xtype:'numberfield',
				width:180,
				id:'PATCFDefaultTabInRegistration',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDefaultTabInRegistration'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDefaultTabInRegistration')),
				name : 'PATCFDefaultTabInRegistration'
			},{
				fieldLabel : 'diagnosis/procedure Rows',
				xtype:'numberfield',
				width:180,
				id:'PATCFNoRowsDiagProc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoRowsDiagProc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoRowsDiagProc')),
				name : 'PATCFNoRowsDiagProc'
			},{
				fieldLabel : 'Female Pension Age',
				xtype:'numberfield',
				width:180,
				id:'PATCFFemalePensionAge',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFFemalePensionAge'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFFemalePensionAge')),
				name : 'PATCFFemalePensionAge'
			},{
				fieldLabel : '搜索限制天数',
				xtype:'numberfield',
				width:180,
				id:'PATCFLimitNoDaysForSearch',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFLimitNoDaysForSearch'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFLimitNoDaysForSearch')),
				name : 'PATCFLimitNoDaysForSearch'
			},{
				fieldLabel : 'Male Pension Age',
				xtype:'numberfield',
				width:180,
				id:'PATCFMalePensionAge',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMalePensionAge'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMalePensionAge')),
				name : 'PATCFMalePensionAge'
			},{
				fieldLabel : 'Maxinum Days On Leave without discharge',
				xtype:'numberfield',
				width:180,
				id:'PATCFMaxDaysOnLeave',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFMaxDaysOnLeave'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFMaxDaysOnLeave')),
				name : 'PATCFMaxDaysOnLeave'
			},{
				fieldLabel : 'maxinum text field Length',
				xtype:'numberfield',
				width:180,
				id:'PATCFFieldLength',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFFieldLength'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFFieldLength')),
				name : 'PATCFFieldLength'
			},{
				fieldLabel : 'No of Fields for Patient Name',
				xtype:'numberfield',
				width:180,
				id:'PATCFNoFieldsPatName',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoFieldsPatName'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoFieldsPatName')),
				name : 'PATCFNoFieldsPatName'
			},{
				fieldLabel : 'No of Days For Admission Search To Copy From',
				xtype:'numberfield',
				width:180,
				id:'PATCFNoDaysForAdmSearchToCopyFr',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoDaysForAdmSearchToCopyFr'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoDaysForAdmSearchToCopyFr')),
				name : 'PATCFNoDaysForAdmSearchToCopyFr'
			},{
				fieldLabel : 'no of Days To Include Discharge Patient',
				xtype:'numberfield',
				width:180,
				id:'PATCFDaysToIncludeDischPat',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDaysToIncludeDischPat'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDaysToIncludeDischPat')),
				name : 'PATCFDaysToIncludeDischPat'
			},{
				fieldLabel : 'Number Of Years for Age Search',
				xtype:'numberfield',
				width:180,
				id:'PATCFNoOfYearsAgeSearch',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoOfYearsAgeSearch'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoOfYearsAgeSearch')),
				name : 'PATCFNoOfYearsAgeSearch'
			},{
				fieldLabel : 'Show Months When Inactive',
				xtype:'numberfield',
				width:180,
				id:'PATCFShowMonthsWhenInactive',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFShowMonthsWhenInactive'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFShowMonthsWhenInactive')),
				name : 'PATCFShowMonthsWhenInactive'
			
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypatient&pEntityName=web.Entity.CT.SystemParameter";
	
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