specialUnitAddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form

	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '��ʾ',msg: '��ѡ��һ�����ݣ�',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
	var selectedRowid=selectedRow[0].get("rowid");
	
		var itemTypeDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'order', 'code', 'name', 'shortcut', 'remark', 'active'])
    });

    itemTypeDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=listtype&searchField=shortcut&searchValue=' + Ext.getCmp('itemTypesCombo').getRawValue(), method: 'GET' });
    });

    var itemTypesCombo = new Ext.form.ComboBox({
        id: 'itemTypesCombo',
        fieldLabel: '��Ŀ���',
        store: itemTypeDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        anchor: '90%',
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ�����������...',
        allowBlank: true,
        selectOnFocus: true,
        forceSelection: true
    });

    var itemsDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.infiltrulesexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('itemsCommbo').getRawValue() + '&id=' + itemTypesCombo.getValue()+'&parRef='+selectedRowid, method: 'GET' });
    });

    var itemsCommbo = new Ext.form.ComboBox({
        id: 'itemsCommbo',
        fieldLabel: '������',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        anchor: '90%',
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ��������...',
        allowBlank: false,
        selectOnFocus: true,
        forceSelection: true
    });
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
		itemTypesCombo,
		itemsCommbo
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӹ�����Ŀ',
    width: 400,
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
		id:'saveButton',
    	text: '����', 
      handler: function() {
      		// check form value
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.ca.infiltrulesexe.csp?action=additem&itemDr='+itemsCommbo.getValue()+'&parRef='+selectedRowid,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:selectedRowid}});
									itemsCommbo.setRawValue("");
									itemsCommbo.setValue("");
									itemsDs.load({ params: { start: 0, limit: itemTypesCombo.pageSize, id: itemTypesCombo.getValue()} });
									specialUnitLocds.load({params:{start:0, limit:0}});
								}
								else
								{
									var message="";
									if(jsonData.info=='RepExist') message='����ĵ�Ԫ�Ѿ�����!';
									else message='δ֪����!';
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
	itemTypesCombo.on("select", function(cmb, rec, id) {
        itemsCommbo.setRawValue("");
        itemsCommbo.setValue("");
        itemsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
};