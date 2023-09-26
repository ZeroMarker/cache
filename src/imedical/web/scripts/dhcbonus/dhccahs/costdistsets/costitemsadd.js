addCostItemsFun = function(dataStore, grid, pagingTool, costCombo, layerDr, deptLevelSetsDr) {

	var parRef=distMethodsDr;
	if (parRef==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ɱ���̯�׺�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var type=itemType;
    var itemsDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('items').getRawValue() + '&id=' + costId + '&parRef=' + parRef + '&type=' + type, method: 'GET' });
    });

    var items = new Ext.form.ComboBox({
        id: 'items',
        fieldLabel: '��̯�ɱ���',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        anchor: '90%',
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ���̯�ɱ���...',
        allowBlank: false,
        selectOnFocus: true,
        forceSelection: true
    });


    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
			items
		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '�ɱ������',
        width: 400,
        height: 200,
        minWidth: 400,
        minHeight: 200,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
            text: '����',
            handler: function() {
				//alert('id=' + parRef + '&itemDr=' + items.getValue() + '&type=' + type);
				//return;
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: costDistSetsUrl + '?action=addCostItems&id=' + parRef + '&itemDr=' + items.getValue() + '&type=' + type,
                        waitMsg: '������...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: 'ע��', msg: '��ӳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                if ((type == "in") || (type == "out")) {
                                    costCombo.disable();
                                } else {
                                    recCombo.disable();
                                }
                                items.setValue("");
                                items.setRawValue("");
                                itemsDs.load({ params: { start: 0, limit: items.pageSize} });
                                dataStore.load({ params: { start: 0, limit: pagingTool.pageSize, id: parRef, type: type} });


                                //window.close();

                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyCode') message = '����Ϊ��!';
                                if (jsonData.info == 'EmptyName') message = '����Ϊ��!';
                                if (jsonData.info == 'EmptyOrder') message = '���Ϊ��!';
                                if (jsonData.info == 'RepCode') message = '�����Ѿ�����!';
                                if (jsonData.info == 'RepName') message = '�����Ѿ�����!';
                                if (jsonData.info == 'RepPriority') message = '���ȼ��Ѿ�����!';
                                Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                            }
                        },
                        scope: this
                    });
                }
                else {
                    Ext.Msg.show({ title: '����', msg: '��ѡ�����ݺ��ύ��', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                }
            }
        },
    	{
    	    text: 'ȡ��',
    	    handler: function() { window.close(); }
}]
    });

    window.show();
};