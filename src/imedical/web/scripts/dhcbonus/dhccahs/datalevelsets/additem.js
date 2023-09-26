AddLocFun = function(dataStore,grid,pagingTool) {
	//alert(repdr+","+leaf);
	Ext.QuickTips.init();
	if(leaf)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ�������,�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(repdr == "")
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}

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
		//ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listdatatype&searchfield=shortcut&searchvalue='+Ext.getCmp('itemType').getRawValue(),method:'GET'});		zjw 20160902 ���ļ���
		ds.proxy=new Ext.data.HttpProxy({url:encodeURI('dhc.ca.datalevelsetsexe.csp?action=listdatatype&searchfield=shortcut'),method:'GET'});
		
	});

	itemType.on("select",function(cmb,rec,id ){
		items.setRawValue("");
		items.setValue("");
		//itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listloc&recname='+Ext.getCmp('items').getRawValue()+'&id='+itemType.getValue()+'&repdr='+repdr,method:'GET'});
		//itemsDs.proxy = new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=items&id='+cmb.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});//ˢ��
	});

	var itemsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['itemDr','itemShortCut'])
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

	itemsDs.on('beforeload', function(ds, o){
		//ds.load({params:{start:0, limit:itemType.pageSize,id:itemType.getValue()}});
		//ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listloc&searchfield=itemShortCut&searchvalue='+Ext.getCmp('items').getRawValue()+'&recname='+Ext.getCmp('items').getRawValue()+'&id='+itemType.getValue()+'&repdr='+repdr,method:'GET'});
		//ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.ritemsexe.csp?action=listItem&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&dataTypeDr='+Ext.getCmp('itemType').getValue()+'&itemDr='+repdr, method:'GET'});
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listloc&id='+itemType.getValue()+'&repdr='+repdr+'&searchvalue='+Ext.getCmp('items').getRawValue(), method:'POST'});
		
	});
	

	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '˳��',
		selectOnFocus:true,
		allowBlank: false,
		name:'order',
		emptyText:'˳��...',
		anchor: '90%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			itemType,
			items,
			orderField
		]
	});
	
	function addRqs(){
		Ext.Ajax.request({
			url: encodeURI(deptLevelSetsUrl+'?action=addloc&itemDr='+items.getValue()+'&itemTypeDr='+itemType.getValue()+'&id='+repdr+'&order='+orderField.getValue()),
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
					Ext.getCmp('detailReport').getNodeById(repdr).reload();
					//window.close();
				}
				else
				{
					var message=jsonData.info;
					if(message=="roo")  message="���ݲ�����Ӵ˽ڵ���!";
					else if(message=="RepOrder") message="������Ѿ�����!";
					//Ext.getCmp('detailReport').getNodeById(message).reload();
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});
	}
    
  // define window and show it in desktop
	var window = new Ext.Window({
		title: '������ݷֲ�',
		width: 400,
		height:200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			id:"saveButton",
			handler: function() {
				if (formPanel.form.isValid()) {
					var tmpDept=items.getValue();
					if(tmpDept==""){
						Ext.Msg.show({title:'����',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					Ext.Ajax.request({
						url: encodeURI(deptLevelSetsUrl+'?action=checkexist&itemDr='+items.getValue()+'&id='+repdr),
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success=='true') {
								addRqs();
							
							}
							else
							{
								var message=jsonData.info;
								Ext.MessageBox.confirm('', '�����Ѿ����ڣ��Ƿ������ӣ�', function(btn) {
				        	if(btn=="yes"){
				        		addRqs();
				        	
				        	}
				        });
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