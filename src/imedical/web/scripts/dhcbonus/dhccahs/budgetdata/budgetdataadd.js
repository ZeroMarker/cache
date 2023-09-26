addFun = function(dataStore, grid, pagingTool) {
    if (intervalDr == "") {
        Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
        return;
    }
    var orderField = new Ext.form.NumberField({
        id: 'orderField',
        fieldLabel: '���',
        allowDecimals: true,
        allowBlank: false,
        emptyText: '���...',
        anchor: '90%'
    });

	var priceField = new Ext.form.NumberField({
        id: 'priceField',
        fieldLabel: '����',
        allowDecimals: true,
        allowBlank: false,
        emptyText: '����...',
        anchor: '90%'
    });
	
	var amountField = new Ext.form.NumberField({
        id: 'amountField',
        fieldLabel: '����',
        allowDecimals: false,
        allowBlank: false,
        emptyText: '����...',
        anchor: '90%'
    });
    var remarkField = new Ext.form.TextField({
        id: 'remarkField',
        fieldLabel: '��ע',
        allowBlank: true,
        emptyText: '��ע...',
        anchor: '90%'
    });

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
        allowBlank: false,
        selectOnFocus: true,
        forceSelection: true
    });

    var itemsDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('items').getRawValue() + '&id=' + itemTypesCombo.getValue(), method: 'GET' });
    });

    var items = new Ext.form.ComboBox({
        id: 'items',
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
        name: 'items',
        selectOnFocus: true,
        forceSelection: true
    });

    var unitTypeDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active'])
    });
    var unitType = new Ext.form.ComboBox({
        id: 'unitType',
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
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue=' + Ext.getCmp('unitType').getRawValue(), method: 'GET' });
    });

    var unitsDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active'])
    });
    var units = new Ext.form.ComboBox({
        id: 'units',
        fieldLabel: '��Ԫ',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: unitsDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Ԫ...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    unitsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=units&searchValue=' + Ext.getCmp('units').getRawValue() + '&id=' + unitType.getValue(), method: 'GET' });
    });

    var assLocDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', 'startTime', 'stop', 'unitDr', 'propertyDr', 'active'])
    });
    var assLoc = new Ext.form.ComboBox({
        id: 'assLoc',
        fieldLabel: '����',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: assLocDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ����...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    assLocDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue=' + Ext.getCmp('assLoc').getRawValue() + '&unitsDr=' + units.getValue(), method: 'GET' });
    });

    var personDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'shortcut', 'gender', 'birthday', 'national', 'birthPlace', 'education', 'title', 'duty', 'state', 'preparation', 'phone', 'remark', 'start', 'stop', 'unitDr', 'unitName', 'active'])
    });
    var person = new Ext.form.ComboBox({
        id: 'person',
        fieldLabel: '��Ա',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: personDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ����Ա...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    personDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitpersonsexe.csp?action=list&searchField=shortcut&searchValue=' + Ext.getCmp('person').getRawValue() + '&id=' + units.getValue() + '&active=Y', method: 'GET' });
    });

    var flagStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
        fields: ['type', 'rowid'],
        data: [['���', 'price'], ['����', 'amount']]
    });
    var flagComm = new Ext.form.ComboBox({
        id: 'flagComm',
        fieldLabel: '���ݱ�ʶ',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: flagStore,
        valueField: 'rowid',
        displayField: 'type',
        triggerAction: 'all',
		value:'price',
        emptyText: '���ݱ�ʶ...',
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
			itemTypesCombo,
			items,
			unitType,
			units,
			assLoc,
			amountField,
			priceField,
			orderField,
			flagComm,
			//formComm,
			remarkField
		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '���Ԥ������',
        width: 400,
        height: 350,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
            text: '����',
            handler: function() {

                var itemTypes = itemTypesCombo.getValue();
                var itemDr = items.getValue();
                var deptDr = assLoc.getValue();
                var remark = remarkField.getValue();
                var fee = orderField.getValue();
                var amount = amountField.getValue();
                var price = priceField.getValue();
				var type = flagComm.getValue();
			
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({                                      
                        url: budgetDataUrl + '?action=add&intervalDr=' + intervalDr + '&deptDr=' + deptDr + '&itemDr=' + itemDr + '&type=' + type + '&amount=' + amount + '&fee=' + fee + '&price=' + price + '&remark=' + remark,
                        waitMsg: '������...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: 'ע��', msg: '��ӳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                budgetDataDs.setDefaultSort('rowid', 'desc');
                                dataStore.load({ params: { start: 0, limit: pagingTool.pageSize, intervalDr: intervalDr} });
                                //window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyCode') message = '����Ĵ���Ϊ��!';
                                if (jsonData.info == 'EmptyName') message = '���������Ϊ��!';
                                if (jsonData.info == 'EmptyOrder') message = '��������Ϊ��!';
                                if (jsonData.info == 'RepCode') message = '����Ĵ����Ѿ�����!';
                                if (jsonData.info == 'RepName') message = '����������Ѿ�����!';
                                if (jsonData.info == 'RepOrder') message = '���������Ѿ�����!';
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
    itemTypesCombo.on("select", function(cmb, rec, id) {
        items.setRawValue("");
        items.setValue("");
        itemsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
    unitType.on("select", function(cmb, rec, id) {
        units.setRawValue("");
        units.setValue("");
        assLoc.setValue("");
        assLoc.setRawValue("");
        person.setValue("");
        person.setRawValue("");
        unitsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
    units.on("select", function(cmb, rec, id) {
        assLoc.setValue("");
        assLoc.setRawValue("");
        person.setValue("");
        person.setRawValue("");
        personDs.load({ params: { start: 0, limit: person.pageSize, id: cmb.getValue()} });
        assLocDs.load({ params: { start: 0, limit: assLoc.pageSize, id: cmb.getValue()} });
    });
};