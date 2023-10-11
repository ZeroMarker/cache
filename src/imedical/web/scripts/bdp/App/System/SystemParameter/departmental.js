 /// 名称:系统配置 - 安全组系统配置-部门职能
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
                                        {name: 'OECFExecuteConfirmation',mapping:'OECFExecuteConfirmation'},
                                        {name: 'OECFDisableExecuteNotArrAppt',mapping:'OECFDisableExecuteNotArrAppt'},
                                        {name: 'OECFIgnorePayorPlanRest',mapping:'OECFIgnorePayorPlanRest'},
                                        {name: 'RBCFOrderBySlotOrQueue',mapping:'RBCFOrderBySlotOrQueue'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'confirm Execution of orders',
				xtype : 'checkbox',
				name : 'OECFExecuteConfirmation',
				id:'OECFExecuteConfirmation',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteConfirmation'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFExecuteConfirmation')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Disable Execute for Non Arrived Appointments',
				xtype : 'checkbox',
				name : 'OECFDisableExecuteNotArrAppt',
				id:'OECFDisableExecuteNotArrAppt',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDisableExecuteNotArrAppt'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDisableExecuteNotArrAppt')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Ignore Payor/Plan Restrictions when arriving appointment',
				xtype : 'checkbox',
				name : 'OECFIgnorePayorPlanRest',
				id:'OECFIgnorePayorPlanRest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFIgnorePayorPlanRest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFIgnorePayorPlanRest')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				xtype : "combo",
				//emptyText:'请选择',
				fieldLabel : 'appointments Sloting',
				hiddenName : 'RBCFOrderBySlotOrQueue',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RBCFOrderBySlotOrQueue'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RBCFOrderBySlotOrQueue')),
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
								name : 'Slot',
								value : 'S'
							}, {
								name : 'Queue',
								value : 'Q'
							
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitydepartment&pEntityName=web.Entity.CT.SystemParameter";
	
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