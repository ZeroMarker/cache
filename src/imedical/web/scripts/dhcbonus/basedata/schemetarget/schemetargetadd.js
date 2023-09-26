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
		fieldLabel:'�������',
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
		fieldLabel: '��������',
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
		fieldLabel:'ָ�����',
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
		fieldLabel: 'ָ������',
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
		title: '����',
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
				text: '����',
				handler: function() {
					if (formPanel.form.isValid()) {
						var tmpSchemeDr=schemeCombo.getValue();
						var tmpTargetDr=targetCombo.getValue();
						var dt = new Date();
					    dt = dt.format('Y-m-d');
						Ext.Ajax.request({
							url: schemeTargetUrl+'?action=add&targetDr='+tmpTargetDr+'&schemeDr='+tmpSchemeDr+'&date='+ dt,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeTargetDs.load({params:{start:0, limit:schemeTargetPagingToolbar.pageSize}});
								}else{
									var tmpmsg='';
									if(jsonData.info=='RepCode'){
										tmpmsg='����ָ���ظ�!';
									}
									Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'����', msg:tmpWrongName+'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: 'ȡ��',
				handler: function(){
					addWin.close();
				}
			}
		]
		
	});

	addWin.show();
};