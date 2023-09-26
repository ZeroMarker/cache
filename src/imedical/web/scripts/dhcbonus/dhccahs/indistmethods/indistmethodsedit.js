editFun = function(dataStore, grid, pagingTool) {
    var rowObj = grid.getSelections();
    var len = rowObj.length;

    if (len < 1) {
        Ext.Msg.show({ title: '注意', msg: '请选择需要修改的行!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
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
        fieldLabel: '收入分配规则',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: distRulesDs,
        valueField: 'rowid',
        valueNotFoundText: rowObj[0].get("inDistRuleName"),
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择收入分配规则...',
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
        fieldLabel: '收入过滤规则',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: filtRulesDs,
        valueField: 'rowid',
        valueNotFoundText: rowObj[0].get("inFiltRuleName"),
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择收入过滤规则...',
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
        fieldLabel: '优先顺序',
        allowDecimals: false,
        allowNegative: false,
        allowBlank: false,
		name:'priority',
        emptyText: '优先顺序...',
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
        title: '收入分配方法',
        width: 400,
        height: 200,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
            text: '保存',
            handler: function() {
                // check form value	


                var priority = priorityField.getValue();
                var inFiltRuleDr = filtRules.getValue();
                var inDistRuleDr = distRules.getValue();
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: inDistMethodsUrl + '?action=edit&id=' + myRowid + '&priority=' + priority + '&inFiltRuleDr=' + inFiltRuleDr + '&inDistRuleDr=' + inDistRuleDr,
                        waitMsg: '保存中...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: '注意', msg: '修改成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize} });
                                window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyPriority') message = '输入的优先顺序为空!';
                                if (jsonData.info == 'EmptyInFiltRuleDr') message = '输入的规律规则为空!';
                                if (jsonData.info == 'EmptyInDistRuleDr') message = '输入的分配规则为空!';
                                if (jsonData.info == 'RepFiltRule') message = '输入的规律已经存在!';
                                Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                            }
                        },
                        scope: this
                    });
                }
                else {
                    Ext.Msg.show({ title: '错误', msg: '请修正页面提示的错误后提交。', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                }
            }
        },
    	{
    	    text: '取消',
    	    handler: function() { window.close(); }
}]
    });
    window.show();
};