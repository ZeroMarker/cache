editFun = function(dataStore,grid) {
	
	Ext.QuickTips.init();

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
	}

//	var acctSysModeDrField = new Ext.form.TextField({
//		id:'acctSysModeDrField',
//		fieldLabel: 'ģ�����',
//		name:'acctSysModeDr',
//		allowBlank: false,
//		anchor: '95%'
//	});

	var acctSysModeST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['name','rowid'])
	});
	
	acctSysModeST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsysmode', method:'GET'});
			}
		);	
		
	var acctSysModeCB = new Ext.form.ComboBox({
			//id:'acctSysModeCB',
			store: acctSysModeST,
			valueField:'rowid',
			displayField:'name',
			fieldLabel: 'ģ�����',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			valueNotFoundText:rowObj[0].get("acctSysModeName"),
			triggerAction:'all',
			emptyText:'ѡ��ģ�����...',
			allowBlank: false,
			name:'acctSysModeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});

	var typeCodeField = new Ext.form.TextField({
		id:'typeCodeField',
		fieldLabel: '���ͱ��',
		name:'typeCode',
		allowBlank: false,
		anchor: '95%'
	});

	var typeNameField = new Ext.form.TextField({
		id:'typeNameField',
		fieldLabel: '��������',
		name:'typeName',
		allowBlank: false,
		anchor: '95%'
	});
	
	var whileSqlField = new Ext.form.TextField({
		id:'whileSqlField',
		fieldLabel: '��ѯ����',
		name:'whileSql',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isPhaseField = new Ext.form.Checkbox({
		id:'isPhaseField',
		fieldLabel: '�Ƿ�ֽ׶�',
		name:'isPhase',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isInstallField = new Ext.form.Checkbox({
		id:'isInstallField',
		fieldLabel: '�Ƿ�װ',
		name:'isInstall',
		allowBlank: false,
		anchor: '95%'
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
    		acctSysModeCB,
            typeCodeField,
            typeNameField,
			whileSqlField,
			isPhaseField,
			isInstallField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			acctSysModeCB.setValue(rowObj[0].get("acctSysModeDr"));
			isPhaseField.setValue((rowObj[0].data['isPhase'])=='1'?true:false);
			isInstallField.setValue((rowObj[0].data['isInstall'])=='1'?true:false);
		});
    
	var window = new Ext.Window({
		title: '�޸�',
		width: 300,
		height:250,
		minWidth: 300,
		minHeight: 250,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {
				
				//var	acctSysModeDr = acctSysModeDrField.getValue();
				var	typeCode = typeCodeField.getValue();
				var	typeName = typeNameField.getValue();
				var	whileSql = whileSqlField.getValue();
				var	isPhase = (isPhaseField.getValue()==true)?'1':'0';
				var	isInstall = (isInstallField.getValue()==true)?'1':'0';
				
				//acctSysModeDr = acctSysModeDr.trim();
				typeCode = typeCode.trim();
				typeName = typeName.trim();
				whileSql = whileSql.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=editacctsysbusitype&rowid='+rowid+'&acctSysModeDr='+acctSysModeCB.getValue()+'&typeCode='+typeCode+'&typeName='+typeName+'&whileSql='+whileSql+'&isPhase='+isPhase+'&isInstall='+isInstall,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
								window.close();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
					scope: this
					});
				}
				else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
				}
			},
			{
					text: 'ȡ��',
			handler: function(){window.close();}
		}]
	});
    window.show();
};