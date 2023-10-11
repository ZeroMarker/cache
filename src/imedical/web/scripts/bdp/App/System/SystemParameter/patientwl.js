 /// 名称:系统配置 - 安全组系统配置-病人管理（等候列表）
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');


Ext.onReady(function() {	
   Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  var PATCFOTBookCancelReasonDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCReasonForSuspend&pClassQuery=GetDataForCmb1";
	
   
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
                                        {name: 'PATCFAllowWLChangesAfterAdm',mapping:'PATCFAllowWLChangesAfterAdm'},
                                        {name: 'PATCFAllowEditCPforLinkedWLAdm',mapping:'PATCFAllowEditCPforLinkedWLAdm'},
                                        {name: 'PATCFAllowChangePreadmDateWL',mapping:'PATCFAllowChangePreadmDateWL'},
                                        {name: 'PATCFChangeWLStDoneArrAppt',mapping:'PATCFChangeWLStDoneArrAppt'},
                                         {name: 'PATCFChangeOPWLStDoneArrAppt',mapping:'PATCFChangeOPWLStDoneArrAppt'},
                                        {name: 'PATCFClearRefHospOnRemove',mapping:'PATCFClearRefHospOnRemove'},
                                        {name: 'PATCFWLStatInitOnCancel',mapping:'PATCFWLStatInitOnCancel'},
                                        {name: 'PATCFClearWLApptDateOutPCancel',mapping:'PATCFClearWLApptDateOutPCancel'},
                                         {name: 'PATCFPopulateAdmDocForNewWL',mapping:'PATCFPopulateAdmDocForNewWL'},
                                        {name: 'PATCFRestrictLocList',mapping:'PATCFRestrictLocList'},
                                        {name: 'PATCFResetWLDaysPriorIncrease',mapping:'PATCFResetWLDaysPriorIncrease'},
                                        {name: 'PATCFWLSortByDays',mapping:'PATCFWLSortByDays'},
                                         {name: 'PATCFDaysAllowChangeTCI',mapping:'PATCFDaysAllowChangeTCI'},
                                        {name: 'PATCFOTBookCancelReasonDR',mapping:'PATCFOTBookCancelReasonDR'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'登记后允许修改等候列表',
				xtype : 'checkbox',
				name : 'PATCFAllowWLChangesAfterAdm',
				id:'PATCFAllowWLChangesAfterAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowWLChangesAfterAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowWLChangesAfterAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow Edit CP for Linked WL Admissions',
				xtype : 'checkbox',
				name : 'PATCFAllowEditCPforLinkedWLAdm',
				id:'PATCFAllowEditCPforLinkedWLAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowEditCPforLinkedWLAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowEditCPforLinkedWLAdm')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'Allow Change the Preadmission Date for WL',
				xtype : 'checkbox',
				name : 'PATCFAllowChangePreadmDateWL',
				id:'PATCFAllowChangePreadmDateWL',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowChangePreadmDateWL'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowChangePreadmDateWL')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Change IPWL Status to Done on Arrival of outpatient Appointment',
				xtype : 'checkbox',
				name : 'PATCFChangeWLStDoneArrAppt',
				id:'PATCFChangeWLStDoneArrAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFChangeWLStDoneArrAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFChangeWLStDoneArrAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Change OPWL Status to Done on Arrival of outpatient Appointment',
				xtype : 'checkbox',
				name : 'PATCFChangeOPWLStDoneArrAppt',
				id:'PATCFChangeOPWLStDoneArrAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFChangeOPWLStDoneArrAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFChangeOPWLStDoneArrAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Clear Referring Hospital On Remove',
				xtype : 'checkbox',
				name : 'PATCFClearRefHospOnRemove',
				id:'PATCFClearRefHospOnRemove',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFClearRefHospOnRemove'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFClearRefHospOnRemove')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'On Cancel linked WL entry appointment,set WL Status to cancelled',
				xtype : 'checkbox',
				name : 'PATCFWLStatInitOnCancel',
				id:'PATCFWLStatInitOnCancel',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFWLStatInitOnCancel'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFWLStatInitOnCancel')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'on Cancel of outpatient appointment,clear WL appointment date',
				xtype : 'checkbox',
				name : 'PATCFClearWLApptDateOutPCancel',
				id:'PATCFClearWLApptDateOutPCancel',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFClearWLApptDateOutPCancel'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFClearWLApptDateOutPCancel')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Populate Admitting Doctor For New WL',
				xtype : 'checkbox',
				name : 'PATCFPopulateAdmDocForNewWL',
				id:'PATCFPopulateAdmDocForNewWL',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPopulateAdmDocForNewWL'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPopulateAdmDocForNewWL')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Restrict on waiting List',
				xtype : 'checkbox',
				name : 'PATCFRestrictLocList',
				id:'PATCFRestrictLocList',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictLocList'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFRestrictLocList')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Reset WL Days on Priority Increase',
				xtype : 'checkbox',
				name : 'PATCFResetWLDaysPriorIncrease',
				id:'PATCFResetWLDaysPriorIncrease',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFResetWLDaysPriorIncrease'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFResetWLDaysPriorIncrease')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Sort By Days on list in waiting list inquiry',
				xtype : 'checkbox',
				name : 'PATCFWLSortByDays',
				id:'PATCFWLSortByDays',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFWLSortByDays'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFWLSortByDays')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				fieldLabel : 'Allow Change TCI date within x days of TCI date',
				xtype:'numberfield',
				width:200,
				id:'PATCFDaysAllowChangeTCI',
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDaysAllowChangeTCI'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDaysAllowChangeTCI')),
				name : 'PATCFRoundingAmount'
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'OT Booking Cancel Reason',
				hiddenName : 'PATCFOTBookCancelReasonDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFOTBookCancelReasonDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFOTBookCancelReasonDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'SUSPDesc',
				valueField : 'SUSPRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFOTBookCancelReasonDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'SUSPRowId',mapping:'SUSPRowId'},
							{name:'SUSPDesc',mapping:'SUSPDesc'} ])
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypatientwl&pEntityName=web.Entity.CT.SystemParameter";
	
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