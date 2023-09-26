editFun = function(dataStore, grid, pagingTool) {
    var rowObj = grid.getSelections();
    var len = rowObj.length;

    if (len < 1) {
        Ext.Msg.show({ title: 'ע��', msg: '��ѡ����Ҫ�޸ĵ���!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }
    else {
        myRowid = rowObj[0].get("rowid");
    }

    var distRulesDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'shortcut', 'flag', 'active'])
    });
    var distRules = new Ext.form.ComboBox({
        id: 'distRules',
        fieldLabel: '����������',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: distRulesDs,
        valueField: 'rowid',
        valueNotFoundText: rowObj[0].get("inDistRuleName"),
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ������������...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    distRulesDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.indistrulesexe.csp?action=listrule&searchField=shortcut&searchValue=' + Ext.getCmp('distRules').getRawValue() + '&active=Y', method: 'GET' });
    });

    var filtRulesDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'shortcut', 'flag', 'active'])
    });
    var filtRules = new Ext.form.ComboBox({
        id: 'filtRules',
        fieldLabel: '������˹���',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: filtRulesDs,
        valueField: 'rowid',
        valueNotFoundText: rowObj[0].get("inFiltRuleName"),
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��������˹���...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    filtRulesDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.infiltrulesexe.csp?action=listrule&searchField=shortcut&searchValue=' + Ext.getCmp('filtRules').getRawValue() + '&active=Y', method: 'GET' });
    });
    var priorityField = new Ext.form.NumberField({
        id: 'priorityField',
        fieldLabel: '����˳��',
        allowDecimals: false,
        allowNegative: false,
        allowBlank: false,
		name:'priority',
        emptyText: '����˳��...',
        anchor: '90%'
    });



    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
    		priorityField,
		filtRules,
		distRules
		]
    });

    formPanel.on('afterlayout', function(panel, layout) {
        this.getForm().loadRecord(rowObj[0]);
        filtRules.setValue(rowObj[0].get("inFiltRuleDr"));
        distRules.setValue(rowObj[0].get("inDistRuleDr"))
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '������䷽��',
        width: 400,
        height: 200,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
            text: '����',
            handler: function() {
                // check form value	


                var priority = priorityField.getValue();
                var inFiltRuleDr = filtRules.getValue();
                var inDistRuleDr = distRules.getValue();
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: inDistMethodsUrl + '?action=edit&id=' + myRowid + '&priority=' + priority + '&inFiltRuleDr=' + inFiltRuleDr + '&inDistRuleDr=' + inDistRuleDr,
                        waitMsg: '������...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: 'ע��', msg: '�޸ĳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize} });
                                window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyPriority') message = '���������˳��Ϊ��!';
                                if (jsonData.info == 'EmptyInFiltRuleDr') message = '����Ĺ��ɹ���Ϊ��!';
                                if (jsonData.info == 'EmptyInDistRuleDr') message = '����ķ������Ϊ��!';
                                if (jsonData.info == 'RepFiltRule') message = '����Ĺ����Ѿ�����!';
                                Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                            }
                        },
                        scope: this
                    });
                }
                else {
                    Ext.Msg.show({ title: '����', msg: '������ҳ����ʾ�Ĵ�����ύ��', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
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