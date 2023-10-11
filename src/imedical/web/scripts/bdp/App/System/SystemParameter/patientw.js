 /// 名称:系统配置 - 安全组系统配置-病人管理（WEB）
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   
   Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  var PATCFUnknownSexDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	var PATCFAddressTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetCTAddrType";
    
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
                                        {name: 'PATCFAnonymousName',mapping:'PATCFAnonymousName'},
                                        {name: 'PATCFTriageWaitTime1st',mapping:'PATCFTriageWaitTime1st'},
                                        {name: 'PATCFTriageWaitTime2nd',mapping:'PATCFTriageWaitTime2nd'},
                                        {name: 'PATCFAddressTypeDR',mapping:'PATCFAddressTypeDR'},
                                        {name: 'PATCFGovExtract',mapping:'PATCFGovExtract'},
                                        {name: 'PATCFUnknownSexDR',mapping:'PATCFUnknownSexDR'},
                                        {name: 'PATCFYearsSinceLastEpisode',mapping:'PATCFYearsSinceLastEpisode'}
                                 ]),
		
		items:[
			
				{
				fieldLabel : '匿名用户名字',
				xtype:'textfield',
				width:200,
				id:'PATCFAnonymousName',
				maxLength:30,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAnonymousName'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAnonymousName')),
				name : 'PATCFAnonymousName'
			},{
				fieldLabel : '分流等候时间第一指示符',
				xtype:'numberfield',
				width:200,
				name : 'PATCFTriageWaitTime1st',
				id:'PATCFTriageWaitTime1st',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTriageWaitTime1st'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTriageWaitTime1st'))
				
			},{
				fieldLabel : '分流等候时间第二指示符',
				xtype:'numberfield',
				width:200,
				id:'PATCFTriageWaitTime2nd',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTriageWaitTime2nd'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTriageWaitTime2nd')),
				name : 'PATCFTriageWaitTime2nd'
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '地址类型',
				hiddenName : 'PATCFAddressTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFAddressTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFAddressTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTADRDesc',
				valueField : 'CTADRRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : PATCFAddressTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTADRRowId',mapping:'CTADRRowId'},
							{name:'CTADRDesc',mapping:'CTADRDesc'} ])
					})
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'Government Extract',
				hiddenName : 'PATCFGovExtract',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFGovExtract'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFGovExtract')),
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
								name : 'SMR',
								value : 'SMR'
							}, {
								name : 'QHME',
								value : 'QHME'
							}, {
								name : 'NMDS',
								value : 'NMDS'
							}]
				})	
			
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				width:200,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '未知性别',
				hiddenName : 'PATCFUnknownSexDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFUnknownSexDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFUnknownSexDR')),
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
							proxy : new Ext.data.HttpProxy({ url : PATCFUnknownSexDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTSEXRowId',mapping:'CTSEXRowId'},
							{name:'CTSEXDesc',mapping:'CTSEXDesc'} ])
					})
			
			},{
				fieldLabel : 'define number of Years Since Last Episode',
				xtype:'numberfield',
				width:200,
				id:'PATCFYearsSinceLastEpisode',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFYearsSinceLastEpisode'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFYearsSinceLastEpisode')),
				name : 'PATCFYearsSinceLastEpisode'
			
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypatientw&pEntityName=web.Entity.CT.SystemParameter";
	
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