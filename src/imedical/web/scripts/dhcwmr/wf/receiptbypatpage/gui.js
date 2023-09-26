function InitReceiptPage(){
	var obj = new Object();
	obj.txtMrNo = Common_TextField("txtMrNo","病案号");
	Common_SetValue(MrNo);
	
	obj.cboMrTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboMrTypeStore = new Ext.data.Store({
		proxy: obj.cboMrTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'NoTypeID'
		}, 
		[
			{name: 'NoTypeID', mapping: 'NoTypeID'}
			,{name: 'NoTypeDesc', mapping: 'NoTypeDesc'}
			,{name: 'MrTypeID', mapping: 'MrTypeID'}
			,{name: 'MrTypeDesc', mapping: 'MrTypeDesc'}
			,{name: 'IsDefault', mapping: 'IsDefault'}
		])
	});
	obj.cboMrType = new Ext.form.ComboBox({
		id : 'cboMrType'
		,store : obj.cboMrTypeStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th align="center" width="60%">病案类型</th>',
					'<th align="center" width="40%">号码类型</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{MrTypeDesc}</td>',
					'<td>{NoTypeDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:150
		,valueField : 'MrTypeID'
		,displayField : 'MrTypeDesc'
		,fieldLabel : '病案类型'
		,editable : false
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
	});
	
	obj.cboNoTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboNoTypeStore = new Ext.data.Store({
		proxy: obj.cboNoTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'NoTypeID'
		}, 
		[
			{name: 'NoTypeID', mapping: 'NoTypeID'}
			,{name: 'NoTypeDesc', mapping: 'NoTypeDesc'}
			,{name: 'MrTypeID', mapping: 'MrTypeID'}
			,{name: 'MrTypeDesc', mapping: 'MrTypeDesc'}
			,{name: 'IsDefault', mapping: 'IsDefault'}
		])
	});
	obj.cboNoType = new Ext.form.ComboBox({
		id : 'cboNoType'
		,store : obj.cboNoTypeStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th align="center" width="60%">病案类型</th>',
					'<th align="center" width="40%">号码类型</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{MrTypeDesc}</td>',
					'<td>{NoTypeDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:150
		,valueField : 'NoTypeID'
		,displayField : 'NoTypeDesc'
		,fieldLabel : '号码类型'
		,editable : false
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
	});
	
	obj.btnReceipt = new Ext.Button({
		id : 'btnReceipt'
		,iconCls : 'icon-wmr'
		,anchor : '95%'
		,text : '接诊'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '关闭'
	});
	
	obj.RecepitViewPort = new Ext.Viewport({
		id : 'RecepitViewPort'
		,layout: 'fit'
		,frame : true
		,items:[
			{
				region: 'center',
				layout : 'form',
				frame : true,
				buttonAlign : 'center',
				labelAlign : 'right',
				labelWidth : 60,
				items : [
					obj.cboMrType
					,obj.cboNoType
					,obj.txtMrNo
				]
				,buttons : [obj.btnReceipt,obj.btnCancel]
			}
		]
	});
	
	obj.cboMrTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.ReceiptSrv';
		param.QueryName = 'QryNoTypeList';
		param.Arg1 = AdmType;
		param.Arg2 = AdmLoc;
		param.ArgCnt = 2;
	});
	
	obj.cboNoTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.ReceiptSrv';
		param.QueryName = 'QryNoTypeList';
		param.Arg1 = AdmType;
		param.Arg2 = AdmLoc;
		param.ArgCnt = 2;
	});
	
	InitReceiptPageEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}