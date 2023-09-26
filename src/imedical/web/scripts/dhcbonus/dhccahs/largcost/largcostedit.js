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

    var feeField = new Ext.form.NumberField({
        id: 'feeField',
        fieldLabel: '���',
        allowDecimals: true,
        name: 'fee',
        allowBlank: false,
        emptyText: '���...',
        anchor: '90%'
    });

    var cyclesField = new Ext.form.NumberField({
        id: 'cyclesField',
        fieldLabel: '������',
        allowDecimals: false,
        allowNegative: false,
        name: 'cycles',
        allowBlank: false,
        emptyText: '������...',
        anchor: '90%'
    });

    var inDateField = new Ext.form.DateField({
        id: 'inDateField',
        fieldLabel: 'ƾ֤����',
        allowBlank: true,
        dateFormat: 'Y-m-d',
        emptyText: 'ѡ��ƾ֤����...',
        anchor: '90%'
    });

    var vouchNumField = new Ext.form.TextField({
        id: 'vouchNumField',
        fieldLabel: 'ƾ֤��',
        name: 'vouchNum',
        allowBlank: true,
        emptyText: 'ƾ֤��...',
        anchor: '90%'
    });

    var abstractField = new Ext.form.TextField({
        id: 'abstractField',
        fieldLabel: 'ժҪ',
        allowBlank: true,
        name: 'abstract',
        emptyText: 'ժҪ...',
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
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue=' + Ext.getCmp('itemsCommbo').getRawValue() + '&id=' + itemTypesCombo.getValue(), method: 'GET' });
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
        valueNotFoundText: rowObj[0].get("itemName"),
        anchor: '90%',
        listWidth: 250,
        triggerAction: 'all',
        emptyText: 'ѡ��������...',
        allowBlank: false,
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
        allowBlank: true,
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
        allowBlank: true,
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
        valueNotFoundText: rowObj[0].get("deptName"),
        emptyText: 'ѡ����...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    assLocDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue=' + Ext.getCmp('assLoc').getRawValue() + '&unitsDr=' + units.getValue(), method: 'GET' });
    });

    var calFlagField = new Ext.form.Checkbox({
        id: 'calFlagField',
        labelSeparator: '�����־:',
        allowBlank: false,
        checked: (rowObj[0].data['calFlag']) == 'Y' ? true : false
    });

    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
    		inDateField,
			vouchNumField,
            abstractField,
			feeField,
			itemTypesCombo,
			itemsCommbo,
			unitType,
			units,
			assLoc,
			cyclesField,
			calFlagField
		]
    });

    formPanel.on('afterlayout', function(panel, layout) {
        this.getForm().loadRecord(rowObj[0]);
        inDateField.setValue(rowObj[0].get("vouchDate"));
        itemsCommbo.setValue(rowObj[0].get("itemDr"));
        assLoc.setValue(rowObj[0].get("deptDr"));
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '�޸�������',
        width: 400,
        height: 370,
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

                var vouchDate = inDateField.getValue();
                if (vouchDate != "") {
                    vouchDate = vouchDate.format('Y-m-d');
                }
                var order = feeField.getValue();
                var vouchNum = vouchNumField.getValue();
                var myAbstract = abstractField.getValue();
                var fee = feeField.getValue();
                var itemDr = itemsCommbo.getValue();
                var deptDr = assLoc.getValue();
                var cycles = cyclesField.getValue();
                var tmpCalFlag = rowObj[0].get("calFlag");
                var calFlag = (calFlagField.getValue() == true) ? 'Y' : 'N';
                vouchNum = vouchNum.trim();
                myAbstract = myAbstract.trim();


                if (!fee > 0) {
                    Ext.Msg.show({ title: 'ע��', msg: '���������0!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                    return;
                }

                if (!cycles > 0) {
                    Ext.Msg.show({ title: 'ע��', msg: '�������������0!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                    return;
                }
                if (tmpCalFlag == calFlag) {
                    if (formPanel.form.isValid()) {
                        Ext.Ajax.request({
                            url: largCostUrl + '?action=edit&id=' + myRowid + '&vouchDate=' + vouchDate + '&order=' + order + '&vouchNum=' + vouchNum + '&abstract=' + myAbstract + '&fee=' + fee + '&itemDr=' + itemDr + '&deptDr=' + deptDr + '&cycles=' + cycles + '&inPersonDr=' + userDr + '&calFlag=' + calFlag,
                            waitMsg: '������...',
                            failure: function(result, request) {
                                Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                            },
                            success: function(result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                if (jsonData.success == 'true') {
                                    Ext.Msg.show({ title: 'ע��', msg: '�޸ĳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                    largCostDetailGrid.setTitle("���ɱ�����");
									dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize} });
                                    largCostDetailDs.load({ params: { start: 0, limit: 0} });
                                    window.close();
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
                } else {

                    Ext.MessageBox.confirm('��ʾ',
							'�˲�����Ӱ����ǰ���ɵ�����,�Ƿ����?',
							function(btn) {
							    if (btn == 'yes') {
							        if (formPanel.form.isValid()) {
							            Ext.Ajax.request({
							                url: largCostUrl + '?action=edit&id=' + myRowid + '&vouchDate=' + vouchDate + '&order=' + order + '&vouchNum=' + vouchNum + '&abstract=' + myAbstract + '&fee=' + fee + '&itemDr=' + itemDr + '&deptDr=' + deptDr + '&cycles=' + cycles + '&inPersonDr=' + userDr + '&calFlag=' + calFlag,
							                waitMsg: '������...',
							                failure: function(result, request) {
							                    Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
							                },
							                success: function(result, request) {
							                    var jsonData = Ext.util.JSON.decode(result.responseText);
							                    if (jsonData.success == 'true') {
							                        Ext.Msg.show({ title: 'ע��', msg: '�޸ĳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
							                        largCostDetailGrid.setTitle("���ɱ�����");
													dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize} });
							                        largCostDetailDs.load({ params: { start: 0, limit: 0} });
							                        window.close();
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
							}
						);

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
        itemsCommbo.setRawValue("");
        itemsCommbo.setValue("");
        itemsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
    unitType.on("select", function(cmb, rec, id) {
        units.setRawValue("");
        units.setValue("");
        assLoc.setValue("");
        assLoc.setRawValue("");
        unitsDs.load({ params: { start: 0, limit: cmb.pageSize, id: cmb.getValue()} });
    });
    units.on("select", function(cmb, rec, id) {
        assLoc.setValue("");
        assLoc.setRawValue("");
        assLocDs.load({ params: { start: 0, limit: assLoc.pageSize, id: cmb.getValue()} });
    });
};