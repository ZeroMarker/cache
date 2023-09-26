addFun = function(dataStore,grid) {
	Ext.QuickTips.init();

	//var acctSysModeDrField = new Ext.form.TextField({
	//	id:'acctSysModeDrField',
	//	fieldLabel: '模块编码',
	//	allowBlank: false,
	//	anchor: '95%'
	//});
	
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
			fieldLabel: '模块编码',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'选择模块编码...',
			allowBlank: false,
			name:'acctSysModeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});

	var typeCodeField = new Ext.form.TextField({
		id:'typeCodeField',
		fieldLabel: '类型编号',
		allowBlank: false,
		anchor: '95%'
	});

	var typeNameField = new Ext.form.TextField({
		id:'typeNameField',
		fieldLabel: '类型名称',
		allowBlank: false,
		anchor: '95%'
	});
	
	var whileSqlField = new Ext.form.TextField({
		id:'whileSqlField',
		fieldLabel: '查询条件',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isPhaseField = new Ext.form.Checkbox({
		id:'isPhaseField',
		fieldLabel: '是否分阶段',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isInstallField = new Ext.form.Checkbox({
		id:'isInstallField',
		fieldLabel: '是否安装',
		allowBlank: false,
		anchor: '95%'
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
    		//acctSysModeDrField,
			acctSysModeCB,
            typeCodeField,
            typeNameField,
			whileSqlField,
			isPhaseField,
			isInstallField
		]
	});

	var window = new Ext.Window({
		title: '添加',
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
			text: '保存', 
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
						url: 'dhc.cs.baseexe.csp?action=addacctsysbusitype&acctSysModeDr='+acctSysModeCB.getValue()+'&typeCode='+typeCode+'&typeName='+typeName+'&whileSql='+whileSql+'&isPhase='+isPhase+'&isInstall='+isInstall,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}             
			}
		},
		{
			text: '取消',
			handler: function(){window.close();}
		}]
    });

    window.show();
};