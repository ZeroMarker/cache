addFun = function() {

	/////////////////////////////////////////////////////////////
	var schemeTypeSt = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name'])
	});

	schemeTypeSt.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonusschemtypeexe.csp?action=list&start=0&limit=25',method:'GET'});
	});

	var schemeTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'方案类别',
		store: schemeTypeSt,
		displayField:'name',
		valueField:'rowid',
		allowBlank : false,
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		selectOnFocus:true,
		anchor: '100%'
	});

	var schemeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name','schemeState'])
	});

	schemeTypeCombo.on('select',function(){
		schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=schemelist&type='+schemeTypeCombo.getValue()+'&state=0&start=0&limit=100',method:'GET'});
		schemeCombo.setRawValue('');
		schemeDs.load();
		
	});

	var schemeCombo = new Ext.form.ComboBox({
		fieldLabel: '方案名称',
		store: schemeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		allowBlank : false,
		//pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		anchor: '100%'
	});

	/////////////////////////////////////////////////////////////
	var targetTypeSt = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	targetTypeSt.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.targettypeexe.csp?action=list&start=0&limit=25',method:'GET'});
	});

	var targetTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'指标类别',
		store: targetTypeSt,
		displayField:'name',
		valueField:'rowid',
		allowBlank : false,
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		selectOnFocus:true,
		anchor: '100%'
	});

	var targetDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','BonusTargetName'])
	});

	targetTypeCombo.on('select',function(){
		targetDs.proxy=new Ext.data.HttpProxy({url:schemeTargetUrl+'?action=bonusTargertList&targetType='+targetTypeCombo.getValue()+'&start=0&limit=100',method:'GET'});
		targetCombo.setRawValue('');
		targetDs.load();
		
	});

	var targetCombo = new Ext.form.ComboBox({
		fieldLabel: '指标名称',
		store: targetDs,
		valueField: 'rowid',
		displayField: 'BonusTargetName',
		triggerAction: 'all',
		allowBlank : false,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		anchor: '100%'
	});

	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			schemeTypeCombo,
			schemeCombo,
			targetTypeCombo,
			targetCombo
		]
	});

	var addWin = new Ext.Window({
		title: '添加',
		width: 250,
		height: 180,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[
			{
				text: '保存',
				handler: function() {
					if (formPanel.form.isValid()) {
						var tmpSchemeDr=schemeCombo.getValue();
						var tmpTargetDr=targetCombo.getValue();
						var dt = new Date();
					    dt = dt.format('Y-m-d');
						Ext.Ajax.request({
							url: schemeTargetUrl+'?action=add&targetDr='+tmpTargetDr+'&schemeDr='+tmpSchemeDr+'&date='+ dt,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeTargetDs.load({params:{start:0, limit:schemeTargetPagingToolbar.pageSize}});
								}else{
									var tmpmsg='';
									if(jsonData.info=='RepCode'){
										tmpmsg='核算指标重复!';
									}
									Ext.Msg.show({title:'错误',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'错误', msg:tmpWrongName+'不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: '取消',
				handler: function(){
					addWin.close();
				}
			}
		]
		
	});

	addWin.show();
};
