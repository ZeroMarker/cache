 /// 名称:系统配置 - 安全组系统配置-病人管理（WEB）A&E
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
		labelWidth : 180,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'PATCFFreqAttendAge',mapping:'PATCFFreqAttendAge'},
                                        {name: 'PATCFNumberOfVisits',mapping:'PATCFNumberOfVisits'},
                                        {name: 'PATCFTimeFrame',mapping:'PATCFTimeFrame'},
                                        {name: 'PATCFTimeFrameType',mapping:'PATCFTimeFrameType'},
                                        {name: 'PATCFNoSimultanCurrentIPEDAdms',mapping:'PATCFNoSimultanCurrentIPEDAdms'}
                                 ]),
		
		items:[
			
				{
				/*fieldLabel : 'Frequent Attendees',
				id:'FrequentAttendees',
				name : 'FrequentAttendees'
			},{
*/				fieldLabel : 'Frequent Attend Age limit(years)',
				xtype:'numberfield',
				width:200,
				name : 'PATCFFreqAttendAge',
				id:'PATCFFreqAttendAge',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFFreqAttendAge'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFFreqAttendAge'))
			},{
				fieldLabel : 'Number Of Visits',
				xtype:'numberfield',
				width:200,
				name : 'PATCFNumberOfVisits',
				id:'PATCFNumberOfVisits',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNumberOfVisits'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNumberOfVisits'))
					
			},
			{
				  layout: 'column',          
			      items:[{
					columnWidth:.5,
					baseCls : 'x-plain',//form透明,不显示框框
					layout:'form',
					items:[
			{
				fieldLabel : 'Time Frame',
				xtype:'numberfield',
				width:200,
				id:'PATCFTimeFrame',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTimeFrame'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTimeFrame')),
				name : 'PATCFTimeFrame'
			}]
			
			},{
					columnWidth:.5,
					baseCls : 'x-plain',//form透明,不显示框框
					///style:'margin-left:-200px',///右移20px
					layout:'form',
					items:[		{
				xtype : "combo",
				//emptyText:'请选择',
				width:200,
				
				///fieldLabel : 'PATCFTimeFrameType',
				hiddenName : 'PATCFTimeFrameType',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFTimeFrameType'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFTimeFrameType')),
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
								name : 'Weeks',
								value : 'W'
							}, {
								name : 'Years',
								value : 'Y'
							}]
				})	
					}]
			}]
			},
			{
				boxLabel:'doNot allow Simultaneous Current IP and current ED episodes',
				xtype : 'checkbox',
				name : 'PATCFNoSimultanCurrentIPEDAdms',
				id:'PATCFNoSimultanCurrentIPEDAdms',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFNoSimultanCurrentIPEDAdms'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFNoSimultanCurrentIPEDAdms')),
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypetientwae&pEntityName=web.Entity.CT.SystemParameter";
	
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