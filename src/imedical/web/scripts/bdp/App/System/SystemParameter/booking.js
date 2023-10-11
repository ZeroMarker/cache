 /// 名称:系统配置 - 安全组系统配置-预约
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   	
   	var RBCFOverBookReasonDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetRBCReasonOverBook";
	
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
		labelWidth : 170,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'PATCFBedRequestHours',mapping:'PATCFBedRequestHours'},
                                        {name: 'RBCFConditionAutoEpAppt',mapping:'RBCFConditionAutoEpAppt'},
                                        {name: 'RBCFNoDayGenSchedule',mapping:'RBCFNoDayGenSchedule'},
                                        {name: 'RBCFMultipleServicesSearch',mapping:'RBCFMultipleServicesSearch'},
                                        {name: 'RBCFMaxWeeksIrregSchedule',mapping:'RBCFMaxWeeksIrregSchedule'},
                                        {name: 'RBCFPercentIncrServDuration',mapping:'RBCFPercentIncrServDuration'},
                                        {name: 'RBCFOverBookReasonDR',mapping:'RBCFOverBookReasonDR'},
                                        {name: 'RBCFMaxPeriodCheckEpisNum',mapping:'RBCFMaxPeriodCheckEpisNum'},
                                        {name: 'RBCFMaxPeriodCheckEpis1',mapping:'RBCFMaxPeriodCheckEpis1'}
                                 ]),
		
		items:[
			
			{
				fieldLabel : 'bed request hours to estimate discharge',
				xtype:'numberfield',
				width:200,
				id:'PATCFBedRequestHours',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFBedRequestHours'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFBedRequestHours')),
				name : 'PATCFBedRequestHours'
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'conditions for auto-creation of episodes for appointmentS',
				hiddenName : 'RBCFConditionAutoEpAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFConditionAutoEpAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFConditionAutoEpAppt')),
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
								name : 'Location',
								value : 'L'
							}, {
								name : 'Date/Location',
								value : 'DL'
							}, {
								name : 'Resource/Location',
								value : 'RL'
							}, {
								name : 'Responsible Unit',
								value : 'RU'
							}]
				})	
				
			},{
				fieldLabel : '日程表需要的天数',
				xtype:'numberfield',
				width:200,
				minValue : 1,
				maxValue : 9999,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'RBCFNoDayGenSchedule',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFNoDayGenSchedule'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFNoDayGenSchedule')),
				name : 'RBCFNoDayGenSchedule'
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : '默认多种服务搜索',
				hiddenName : 'RBCFMultipleServicesSearch',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFMultipleServicesSearch'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFMultipleServicesSearch')),
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
								name : 'Same Time',
								value : 'S'
							}, {
								name : 'Sequential',
								value : 'D'
							}, {
								name : 'All Times',
								value : 'A'
							
							}]
				})	
			},{
				fieldLabel : '异常情况最大星期',
				width:200,
				xtype:'numberfield',
				id:'RBCFMaxWeeksIrregSchedule',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFMaxWeeksIrregSchedule'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFMaxWeeksIrregSchedule')),
				name : 'RBCFNoDayGenSchedule'
			},{
				fieldLabel : 'maxinum weeks for irregular',
				xtype:'numberfield',
				width:200,
				id:'RBCFPercentIncrServDuration',
				allowNegative : false,//不允许输入负数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFPercentIncrServDuration'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFPercentIncrServDuration')),
				name : 'RBCFPercentIncrServDuration'
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'reason for overbook of reverse deceased status',
				hiddenName : 'RBCFOverBookReasonDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFOverBookReasonDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFOverBookReasonDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'ROBDesc',
				valueField : 'ROBRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : RBCFOverBookReasonDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'ROBRowId',mapping:'ROBRowId'},
							{name:'ROBDesc',mapping:'ROBDesc'} ])
					})
			/*},{
				fieldLabel : 'max period check for auto episode creation of same locat',
				id:'MaxPeriodCheck',	
				name : 'MaxPeriodCheck'*/
			},{
				fieldLabel : '数字',
				xtype:'numberfield',
				width:200,
				id:'RBCFMaxPeriodCheckEpisNum',
				allowNegative : false,//不允许输入负数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFMaxPeriodCheckEpisNum'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFMaxPeriodCheckEpisNum')),
				name : 'RBCFMaxPeriodCheckEpisNum'
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : '时期',
				hiddenName : 'RBCFMaxPeriodCheckEpis1',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFMaxPeriodCheckEpis1'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFMaxPeriodCheckEpis1')),
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
								name : 'Days',
								value : 'D'
							}, {
								name : 'Months',
								value : 'M'
							}, {
								name : 'Years',
								value : 'Y'
							}]
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitybooking&pEntityName=web.Entity.CT.SystemParameter";
	
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