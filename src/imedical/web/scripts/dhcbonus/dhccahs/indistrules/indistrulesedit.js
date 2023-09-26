editLocsFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form
	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '��ʾ',msg: '��ѡ��һ�����ݣ�',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
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
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'flag', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('itemsCommbo').getRawValue() + '&id=' + itemTypesCombo.getValue(), method: 'GET' });
    });

    var itemsCommbo = new Ext.form.ComboBox({
        id: 'itemsCommbo',
        fieldLabel: '������',
        store: itemsDs,
        valueField: 'flag',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        anchor: '90%',
		valueNotFoundText: selectedRow[0].get("itemShortCut"),
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ��������...',
        allowBlank: true,
        selectOnFocus: true,
        forceSelection: true
    });
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		name:'code',
		emptyText: '������...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		name:'name',
		allowBlank: false,
		emptyText: '�������...',
		anchor: '90%'
	});
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '��Ч:',
		allowBlank: false,
		checked: (selectedRow[0].data['active'])=='Y'?true:false
	});
	
	var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
        fields: ['type', 'rowid'],
        data: [['�������', 'LocType'], ['ָ������', 'Locs']]
    });
    var formComm = new Ext.form.ComboBox({
        id: 'formComm',
        fieldLabel: '�����־',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: formStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
		valueNotFoundText: selectedRow[0].get("flag"),
        emptyText: '�����־...',
        mode: 'local',
        name: 'Flag',
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
			codeField,
			nameField,
			formComm,
			activeField
		]
	});
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(selectedRow[0]);
		var tmpFlag="";
		if(selectedRow[0].get("flag")=="�������"){
			tmpFlag="LocType";
		}else{
			tmpFlag="Locs";
		}
		formComm.setValue(tmpFlag);
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸�����������',
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
			var code = codeField.getValue();
      		var name = nameField.getValue();
      		code = code.trim();
      		name = name.trim();
      		var flag=formComm.getValue();

      		if(code=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			var active = (activeField.getValue()==true)?'Y':'N';
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.ca.indistrulesexe.csp?action=editrule&code='+code+'&name='+name+'&flag='+flag+'&id='+selectedRow[0].get("rowid")+'&active='+active,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									if("LocType"==flag){
										inFiltfDeptsGrid.disable();
										specialUnitGrid.enable();						
									}if("Locs"==flag){
										specialUnitGrid.disable();
										inFiltfDeptsGrid.enable();
									}
									specialUnitDs.load({params:{start:0, limit:specialUnitPagingToolbar.pageSize,parRef:inFiltRulesId}});
									inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize,parRef:inFiltRulesId}});
									window.close();
								}
								else
								{
									var message="";
									if(jsonData.info=='EmptyCode') message='����Ĵ���Ϊ��!';
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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