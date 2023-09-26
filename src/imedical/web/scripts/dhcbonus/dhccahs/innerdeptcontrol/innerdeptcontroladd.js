var addFun = function(dataStore, grid, pagingTool) {

    var unitTypeDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active'])
    });
    var unitTypeCombo = new Ext.form.ComboBox({
        id: 'unitTypeCombo',
        fieldLabel: '��Ԫ���',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: unitTypeDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Ԫ���...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    unitTypeDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue=' + Ext.getCmp('unitTypeCombo').getRawValue(), method: 'GET' });
    });

    var unitDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active'])
    });
    var unitCombo = new Ext.form.ComboBox({
        id: 'unitCombo',
        fieldLabel: '��Ԫ',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: unitDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Ԫ...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    unitDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=units&searchValue=' + Ext.getCmp('unitCombo').getRawValue() + '&id=' + unitTypeCombo.getValue(), method: 'GET' });
    });

    var oldDeptDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', 'startTime', 'stop', 'unitDr', 'propertyDr', 'active'])
    });
    var oldDeptCombo = new Ext.form.ComboBox({
        id: 'oldDeptCombo',
        fieldLabel: 'ԭʼ����',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: oldDeptDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��ԭʼ����...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    oldDeptDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue=' + Ext.getCmp('oldDeptCombo').getRawValue() + '&unitsDr=' + unitCombo.getValue(), method: 'GET' });
    });


    var newDeptDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', 'startTime', 'stop', 'unitDr', 'propertyDr', 'active'])
    });
    var newDeptCombo = new Ext.form.ComboBox({
        id: 'newDeptCombo',
        fieldLabel: 'ת���ɲ���',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: newDeptDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��ת���ɲ���...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    newDeptDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue=' + Ext.getCmp('newDeptCombo').getRawValue() + '&unitsDr=' + unitCombo.getValue(), method: 'GET' });
    });
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 70,
        items: [
			unitTypeCombo,
			unitCombo,
			oldDeptCombo,
			newDeptCombo
		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '�ڲ�����ת��',
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
                var oldDept = oldDeptCombo.getValue();
                var newDept = newDeptCombo.getValue();
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: innerDeptControlUrl + '?action=add&newDept=' + newDept + '&oldDept=' + oldDept,
                        waitMsg: '������...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: 'ע��', msg: '��ӳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                innerDeptControlDs.setDefaultSort('rowid', 'desc');
                                unitCombo.setRawValue("");
                                unitCombo.setValue("");
                                oldDeptCombo.setValue("");
                                oldDeptCombo.setRawValue("");
                                newDeptCombo.setValue("");
                                newDeptCombo.setRawValue("");
                                unitDs.load({ params: { start: 0, limit: unitTypeCombo.pageSize, id: unitTypeCombo.getValue()} });
                                dataStore.load({ params: { start: 0, limit: pagingTool.pageSize} });
                                //window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyoldDeptDr') message = 'ԭʼ����Ϊ��!';
                                if (jsonData.info == 'EmptynewDeptDr') message = 'ת���ɲ���Ϊ��!';
                                if (jsonData.info == 'RepoldDeptDr') message = 'ԭʼ�����Ѿ�����!';
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
    unitTypeCombo.on("select", function(cmb, rec, id) {
        unitCombo.setRawValue("");
        unitCombo.setValue("");
        oldDeptCombo.setValue("");
        oldDeptCombo.setRawValue("");
        newDeptCombo.setValue("");
        newDeptCombo.setRawValue("");
        unitDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
    unitCombo.on("select", function(cmb, rec, id) {
        oldDeptCombo.setValue("");
        oldDeptCombo.setRawValue("");
        newDeptCombo.setValue("");
        newDeptCombo.setRawValue("");
        oldDeptDs.load({ params: { start: 0, limit: oldDeptCombo.pageSize, id: cmb.getValue()} });
        newDeptDs.load({ params: { start: 0, limit: newDeptCombo.pageSize, id: cmb.getValue()} });
    });
    window.show();
};