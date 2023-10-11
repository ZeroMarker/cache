 /// 名称:系统配置 - 安全组系统配置-妇产科
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
	
	var PATCFBookingTypeForMaternityEqu_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetPACApptBookingSystem";
    var PATCFAlertCategoryDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetPACAlertCategory";
    
	
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
                                        {name: 'PATCFAutoCreatePregnanForBookMA',mapping:'PATCFAutoCreatePregnanForBookMA'},
                                        {name: 'PATCFPlacentaDetailsRequired',mapping:'PATCFPlacentaDetailsRequired'},
                                        {name: 'PATCFDaysToClosePregnEvent',mapping:'PATCFDaysToClosePregnEvent'},
                                        {name: 'PATCFBookingTypeForMaternityEqu',mapping:'PATCFBookingTypeForMaternityEqu'},
                                        {name: 'PATCFBreastfeedAlertCategoryDR',mapping:'PATCFBreastfeedAlertCategoryDR'},
                                        {name: 'PATCFPregnancyAlertCategoryDR',mapping:'PATCFPregnancyAlertCategoryDR'}
                                 ]),
		
		items:[
			
				{
				boxLabel:'Auto Create Pregnancy event if booking type is MAT',
				xtype : 'checkbox',
				name : 'PATCFAutoCreatePregnanForBookMA',
				id:'PATCFAutoCreatePregnanForBookMA',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAutoCreatePregnanForBookMA'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAutoCreatePregnanForBookMA')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'Placenta Details Required',
				xtype : 'checkbox',
				name : 'PATCFPlacentaDetailsRequired',
				id:'PATCFPlacentaDetailsRequired',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPlacentaDetailsRequired'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPlacentaDetailsRequired')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				fieldLabel : 'Days To Close open Pregnancy Event',
				xtype:'numberfield',
				width:200,
				allowNegative : false, //不允许输入负数
				allowDecimals : false, //不允许输入小数
				id:'PATCFDaysToClosePregnEvent',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDaysToClosePregnEvent'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDaysToClosePregnEvent')),
				name : 'PATCFDaysToClosePregnEvent'
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Booking Type For Maternity Equals',
				hiddenName : 'PATCFBookingTypeForMaternityEqu',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFBookingTypeForMaternityEqu'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFBookingTypeForMaternityEqu')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'APPTBSDesc',
				valueField : 'APPTBSRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFBookingTypeForMaternityEqu_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'APPTBSRowId',mapping:'APPTBSRowId'},
							{name:'APPTBSDesc',mapping:'APPTBSDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Breastfeed Alert Category',
				hiddenName : 'PATCFBreastfeedAlertCategoryDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFBreastfeedAlertCategoryDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFBreastfeedAlertCategoryDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'ALERTCATDesc',
				valueField : 'ALERTCATRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFAlertCategoryDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'ALERTCATRowId',mapping:'ALERTCATRowId'},
							{name:'ALERTCATDesc',mapping:'ALERTCATDesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Pregnancy Alert Category',
				hiddenName : 'PATCFPregnancyAlertCategoryDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFPregnancyAlertCategoryDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFPregnancyAlertCategoryDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'ALERTCATDesc',
				valueField : 'ALERTCATRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFAlertCategoryDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'ALERTCATRowId',mapping:'ALERTCATRowId'},
							{name:'ALERTCATDesc',mapping:'ALERTCATDesc'} ])
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitymaternity&pEntityName=web.Entity.CT.SystemParameter";
	
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