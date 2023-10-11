 /// 名称:系统配置 - 安全组系统配置-扫描默认值
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
                                        {name: 'RTCFScannedImageType',mapping:'RTCFScannedImageType'},
                                        {name: 'RTCFResolution',mapping:'RTCFResolution'}
                                 ]),
		
		items:[
			
				{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : '扫描图片类型',
				hiddenName : 'RTCFScannedImageType',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFScannedImageType'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFScannedImageType')),
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
								name : 'Black and White',
								value : '1'
							}, {
								name : 'Gray scale,4bit',
								value : '2'
							}, {
								name : 'Gray scale,8bit',
								value : '3'
							}, {
								name : 'Palet,4bit',
								value : '4'
							}, {
								name : 'Palet,8bit',
								value : '5'
							}, {
								name : 'RGB,24bit',
								value : '6'
							}, {
								name : 'BGR,24bit',
								value : '7'
							}]
				})	
			},{
				fieldLabel : '分辨率',
				xtype:'numberfield',
				width:200,
				id:'RTCFResolution',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFResolution'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFResolution')),
				name : 'RTCFResolution'
			
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntityscanning&pEntityName=web.Entity.CT.SystemParameter";
	
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