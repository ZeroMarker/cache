addFun = function(dataStore, grid, pagingTool) {

    var feeField = new Ext.form.NumberField({
        id: 'feeField',
        fieldLabel: '金额',
        allowDecimals: true,
        allowBlank: false,
        emptyText: '金额...',
        anchor: '90%'
    });

    var cyclesField = new Ext.form.NumberField({
        id: 'cyclesField',
        fieldLabel: '分期数',
        allowDecimals: false,
        allowNegative: false,
        allowBlank: false,
        emptyText: '分期数...',
        anchor: '90%'
    });

    var inDateField = new Ext.form.DateField({
        id: 'inDateField',
        fieldLabel: '凭证日期',
        allowBlank: true,
        dateFormat: 'Y-m-d',
        emptyText: '选择凭证日期...',
        anchor: '90%'
    });

    var vouchNumField = new Ext.form.TextField({
        id: 'vouchNumField',
        fieldLabel: '凭证号',
        allowBlank: true,
        emptyText: '凭证号...',
        anchor: '90%'
    });

    var abstractField = new Ext.form.TextField({
        id: 'abstractField',
        fieldLabel: '摘要',
        allowBlank: true,
        emptyText: '摘要...',
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
        fieldLabel: '项目类别',
        store: itemTypeDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        anchor: '90%',
        listWidth: 250,
        triggerAction: 'all',
        emptyText: '选择数据项类别...',
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
        fieldLabel: '数据项',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 10,
        minChars: 1,
        anchor: '90%',
        listWidth: 250,
        triggerAction: 'all',
        emptyText: '选择数据项...',
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
        fieldLabel: '单元类别',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: unitTypeDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择单元类别...',
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
        fieldLabel: '单元',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: unitsDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择单元...',
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
        fieldLabel: '部门',
        anchor: '90%',
        listWidth: 260,
        allowBlank: false,
        store: assLocDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择部门...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    assLocDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue=' + Ext.getCmp('assLoc').getRawValue() + '&unitsDr=' + units.getValue(), method: 'GET' });
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
			cyclesField


		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '添加数据项',
        width: 400,
        height: 350,
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

                vouchNum = vouchNum.trim();
                myAbstract = myAbstract.trim();

                if (!fee > 0) {
                    Ext.Msg.show({ title: '注意', msg: '金额必须大于0!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                    return;
                }

                if (!cycles > 0) {
                    Ext.Msg.show({ title: '注意', msg: '分期数必须大于0!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
                    return;
                }

                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: largCostUrl + '?action=add&vouchDate=' + vouchDate + '&order=' + order + '&vouchNum=' + vouchNum + '&abstract=' + myAbstract + '&fee=' + fee + '&itemDr=' + itemDr + '&deptDr=' + deptDr + '&cycles=' + cycles + '&inPersonDr=' + userDr,
                        waitMsg: '保存中...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: '注意', msg: '添加成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
								largCostDetailGrid.setTitle("大额成本分期");
							   dataStore.load({ params: { start: 0, limit: pagingTool.pageSize} });
                                largCostDetailDs.load({ params: { start: 0, limit: 0} });
                                //window.close();
                            }
                            else {
                                var message = "";
                                message = "SQLErr: " + jsonData.info;
                                if (jsonData.info == 'EmptyCode') message = '输入的代码为空!';
                                if (jsonData.info == 'EmptyName') message = '输入的名称为空!';
                                if (jsonData.info == 'EmptyOrder') message = '输入的序号为空!';
                                if (jsonData.info == 'RepCode') message = '输入的代码已经存在!';
                                if (jsonData.info == 'RepName') message = '输入的名称已经存在!';
                                if (jsonData.info == 'RepOrder') message = '输入的序号已经存在!';
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