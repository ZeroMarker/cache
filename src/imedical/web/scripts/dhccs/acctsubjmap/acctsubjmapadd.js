addFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

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
			triggerAction:'all',
			emptyText:'ѡ��ģ�����...',
			allowBlank: true,
			name:'acctSysModeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});

	var acctSubjST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['aCCTSubjName','rowid'])
	});
	
	acctSubjST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubj', method:'GET'});
			}
		);	
		
	var acctSubjCB = new Ext.form.ComboBox({
			//id:'acctSubjCB',
			store: acctSubjST,
			valueField:'rowid',
			displayField:'aCCTSubjName',
			fieldLabel: '��Ŀ����',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ���Ŀ����...',
			allowBlank: true,
			name:'acctSubjCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});

	var typeCodeField = new Ext.form.TextField({
		id:'typeCodeField',
		fieldLabel: '�������',
		allowBlank: true,
		anchor: '95%'
	});
	
	var locsST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['name','code','rowid'])
	});
	
	locsST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=CTLOCList&searchField=name&searchValue=' + Ext.getCmp('locsCB').getRawValue(), method:'GET'});
			}
		);	
		
	var locsCB = new Ext.form.ComboBox({
			id:'locsCB',
			store: locsST,
			valueField:'rowid',
			displayField:'name',
			fieldLabel: '����',
			//typeAhead:true,  ע��ɾ��
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'ѡ��...',
			allowBlank: true,
			name:'locsCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});

	//var docTypeField = new Ext.form.TextField({
	//	id:'docTypeField',
	//	fieldLabel: 'ҽ������',
	//	allowBlank: true,
	//	anchor: '95%'
	//});
	
	var docTypeST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['desc','rowid'])
	});
	
	docTypeST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listincsc', method:'GET'});
			}
		);	
		
	var docTypeCB = new Ext.form.ComboBox({
			//id:'docTypeCB',
			store: docTypeST,
			valueField:'rowid',
			displayField:'desc',
			fieldLabel: '������',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ�������...',
			allowBlank: true,
			name:'docTypeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		autoScroll:true,
		labelWidth: 75,
		items: [
    		acctSysModeCB,
			acctSubjCB,
			docTypeCB,
			locsCB//,
			//typeCodeField
		]
	});

	var window = new Ext.Window({
		title: '���',
		width: 300,
		height:200,
		minWidth: 300,
		minHeight: 200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {

				//var	typeCode = typeCodeField.getValue();
				//typeCode = typeCode.trim();
				
				//var	docType = docTypeField.getValue();
				//docType = docType.trim();
					
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=addacctsubjmap&acctModDr='+acctSysModeCB.getValue()+'&acctSubjDr='+acctSubjCB.getValue()+'&typeCode='+docTypeCB.getValue()+'&locDr='+locsCB.getValue()+'&docType=""',
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
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