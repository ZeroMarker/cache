editFun = function(dataStore,grid,pagingTool,parRef) {

	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowId = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		rowId = rowObj[0].get("rowid");
	}

	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '���',
		name:'order',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '���...',
		anchor: '90%'
	});
	var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','order','active'])
	});
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ���������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listitemtype&searchvalue='+Ext.getCmp('itemType').getRawValue()+'&searchfield=shortcut',method:'GET'});
	});

	itemType.on("select",function(cmb,rec,id ){
		//alert("asdf");
		items.setRawValue("");
		items.setValue("");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});

	var itemsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','itemDr','itemShortCut'])
	});
	
	itemsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue()+'&searchValue='+Ext.getCmp('items').getRawValue()+'&searchField=shortcut',method:'GET'});
	});
	
	var items = new Ext.form.ComboBox({
		id: 'items',
		fieldLabel: '����',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemsDs,
		valueField: 'itemDr',
		displayField: 'itemShortCut',
		triggerAction: 'all',
		emptyText:'ѡ������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var itemShortCut="";
	items.on("select",function(cmb,rec,id ){
		itemShortCut=rec.get("itemShortCut");
	});
	items.on("focus",function(cmb){
		items.setRawValue("");
		items.setValue("");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		name:'remark',
		allowBlank: true,
		emptyText: '�ӿڲ��ű�ע...',
		anchor: '90%'
	});
	var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
		fields: ['type','rowid'],
		data : [['סԺ','I'],['����','O'],['���','E'],['��','']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '��������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'��������...',
		mode: 'local',
		name:'patType',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
		// create form panel
		var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [	
			orderField,
			itemType,
			items,
			formComm,
			remarkField
		]
	});

		formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});

		// define window and show it in desktop
		var window = new Ext.Window({
			title: '�޸Ľӿڲ���',
			width: 370,
			height:300,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [{
				id:'saveButton',
				text: '����',
				handler: function() {
					var code=itemShortCut.substring(0,itemShortCut.indexOf("-"));
					var name=itemShortCut.substring(itemShortCut.indexOf("-")+1);
		      		var remark = remarkField.getValue();
		      		//code = code.trim();
		      		//name = name.trim();
					remark=remark.trim();
			      	if(itemShortCut=="")
		      		{
		      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		      			return;
		      		};
					if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: outDeptsUrl+'?action=editOutDept&inDeptId='+parRef+'&id='+rowId+'&code='+code+'&name='+name+'&remark='+remark+'&inDeptSetsId='+inDeptSetsId+'&order='+orderField.getValue()+'&patType='+formComm.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
									{
										var message="";
										message = "�ÿ����Ѿ���"+jsonData.info+"���";
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