 /// 名称:系统配置 - 安全组系统配置-卸货
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   	var PATCFUnavailBedStatus_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedReasonNotAvail&pClassQuery=GetDataForCmb1";
	
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
                                        {name: 'PATCFEmergDischDetails',mapping:'PATCFEmergDischDetails'},
                                        {name: 'PATCFUnavailBedStatus',mapping:'PATCFUnavailBedStatus'},
                                        {name: 'PATCFCutOffTimeDischarge',mapping:'PATCFCutOffTimeDischarge'},
                                        {name: 'PATCFAllowEnterDiagnosisDischar',mapping:'PATCFAllowEnterDiagnosisDischar'},
                                         {name: 'PATCFAllowInpatDischWOFin',mapping:'PATCFAllowInpatDischWOFin'},
                                         {name: 'PATCFDisconOrdersOnDischarge',mapping:'PATCFDisconOrdersOnDischarge'},
                                         {name: 'PATCFCopyDiagToInPatAdm',mapping:'PATCFCopyDiagToInPatAdm'},
                                         {name: 'PATCFNotPopDischDateTimeOnLeave',mapping:'PATCFNotPopDischDateTimeOnLeave'},
                                         {name: 'PATCFUseDischargeDateTimeAdm',mapping:'PATCFUseDischargeDateTimeAdm'},
                                         {name: 'PATCFUseMaxDaysOnLeaveDisch',mapping:'PATCFUseMaxDaysOnLeaveDisch'}
                                 ]),
		
		items:[
			{
				xtype : "combo",
				//emptyText:'请选择',
				fieldLabel : 'Emergency Discharge Details',
				hiddenName : 'PATCFEmergDischDetails',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFEmergDischDetails'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFEmergDischDetails')),
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
								name : 'Full Details',
								value : 'F'
							}, {
								name : 'Brief Details',
								value : 'B'
							
							}]
				})	
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '床位不可用原因',
				hiddenName : 'PATCFUnavailBedStatus',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUnavailBedStatus'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUnavailBedStatus')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'RNAVDesc',
				valueField : 'RNAVRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFUnavailBedStatus_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'RNAVRowId',mapping:'RNAVRowId'},
							{name:'RNAVDesc',mapping:'RNAVDesc'} ])
					})
			},{
				fieldLabel : 'Cut Off Time for auto Discharge',
				xtype:'timefield',
				format:'H:i:s',
				id:'PATCFCutOffTimeDischarge',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCutOffTimeDischarge'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCutOffTimeDischarge')),
				name : 'PATCFCutOffTimeDischarge'
			},{
				boxLabel:'allow enter diagnosis on discharge',
				xtype : 'checkbox',
				name : 'PATCFAllowEnterDiagnosisDischar',
				id:'PATCFAllowEnterDiagnosisDischar',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowEnterDiagnosisDischar'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowEnterDiagnosisDischar')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Allow final discharge without Financial discharge',
				xtype : 'checkbox',
				name : 'PATCFAllowInpatDischWOFin',
				id:'PATCFAllowInpatDischWOFin',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowInpatDischWOFin'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAllowInpatDischWOFin')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'by default,Discontinue all Orders',
				xtype : 'checkbox',
				name : 'PATCFDisconOrdersOnDischarge',
				id:'PATCFDisconOrdersOnDischarge',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDisconOrdersOnDischarge'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDisconOrdersOnDischarge')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Copy Diagnosis To InPatient Admission',
				xtype : 'checkbox',
				name : 'PATCFCopyDiagToInPatAdm',
				id:'PATCFCopyDiagToInPatAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyDiagToInPatAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFCopyDiagToInPatAdm')),
				inputValue : true?'Y':'N',
				checked:false
			
			},{
				boxLabel:'do Not Populate Discharge Date&Time for On Leave',
				xtype : 'checkbox',
				name : 'PATCFNotPopDischDateTimeOnLeave',
				id:'PATCFNotPopDischDateTimeOnLeave',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNotPopDischDateTimeOnLeave'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNotPopDischDateTimeOnLeave')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Discharge Date/Time on Admission',
				xtype : 'checkbox',
				name : 'PATCFUseDischargeDateTimeAdm',
				id:'PATCFUseDischargeDateTimeAdm',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseDischargeDateTimeAdm'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseDischargeDateTimeAdm')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Use Max Days On Leave for Discharge',
				xtype : 'checkbox',
				name : 'PATCFUseMaxDaysOnLeaveDisch',
				id:'PATCFUseMaxDaysOnLeaveDisch',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUseMaxDaysOnLeaveDisch'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUseMaxDaysOnLeaveDisch')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitydischarge&pEntityName=web.Entity.CT.SystemParameter";
	
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