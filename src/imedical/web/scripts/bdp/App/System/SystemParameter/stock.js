 /// 名称:系统配置 - 安全组系统配置-库存
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');


Ext.onReady(function() {	
   
   Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  var INCFDefRecTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetINCGdRecType";
    
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
		labelWidth : 200,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'INCFDefRecTypeDR',mapping:'INCFDefRecTypeDR'},
                                        {name: 'INCFDaysPastTransaction',mapping:'INCFDaysPastTransaction'},
                                        {name: 'INCFUseExternalStockSytem',mapping:'INCFUseExternalStockSytem'},
                                        {name: 'INCFBatchReq',mapping:'INCFBatchReq'},
                                        {name: 'INCFExpReq',mapping:'INCFExpReq'},
                                        {name: 'INCFWardStk',mapping:'INCFWardStk'}
                                 ]),
		
		items:[
			
				{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '默认货物接收类型',
				hiddenName : 'INCFDefRecTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFDefRecTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFDefRecTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'INCGRDesc',
				valueField : 'INCGRRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : INCFDefRecTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'INCGRRowId',mapping:'INCGRRowId'},
							{name:'INCGRDesc',mapping:'INCGRDesc'} ])
					})
			},{
				fieldLabel : '允许进入过去的交易的天数',
				xtype:'numberfield',
				width:200,
				id:'INCFDaysPastTransaction',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFDaysPastTransaction'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFDaysPastTransaction')),
				name : 'INCFDaysPastTransaction'
			},{
				fieldLabel : '使用外部库存系统',
				xtype:'textfield',
				width:200,
				id:'INCFUseExternalStockSytem',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFUseExternalStockSytem'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFUseExternalStockSytem')),
				name : 'INCFUseExternalStockSytem'
			},{
				xtype : "combo",
				//emptyText:'请选择',
				width:200,
				fieldLabel : '库存项目默认批处理选项',
				hiddenName : 'INCFBatchReq',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFBatchReq'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFBatchReq')),
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
								name : 'Required',
								value : 'R'
							}, {
								name : 'Optional',
								value : 'O'
							}, {
								name : 'Non Required',
								value : 'N'
							}]
				})	
			},{
				xtype : "combo",
				//emptyText:'请选择',
				width:200,
				fieldLabel : '库存项目默认过期日期选项',
				hiddenName : 'INCFExpReq',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFExpReq'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFExpReq')),
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
								name : 'Required',
								value : 'R'
							}, {
								name : 'Optional',
								value : 'O'
							}, {
								name : 'Non Required',
								value : 'N'
							}]
				})	
			},{
				xtype : "combo",
				//emptyText:'请选择',
				width:200,
				fieldLabel : '库存补货选项',
				hiddenName : 'INCFWardStk',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('INCFWardStk'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INCFWardStk')),
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
								name : 'Fixed Replenishment Qty',
								value : 'F'
							}, {
								name : 'Replenish Up To Replenishment Qty',
								value : 'E'
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitystock&pEntityName=web.Entity.CT.SystemParameter";
	
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