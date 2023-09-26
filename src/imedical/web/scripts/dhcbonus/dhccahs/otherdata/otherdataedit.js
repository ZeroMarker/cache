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

    var orderField = new Ext.form.NumberField({
        id: 'orderField',
        fieldLabel: '���',
        allowDecimals: true,
        name: 'fee',
        allowBlank: false,
        emptyText: '���...',
        anchor: '90%'
    });

    var remarkField = new Ext.form.TextField({
        id: 'remarkField',
        fieldLabel: '��ע',
        name: 'remark',
        allowBlank: true,
        emptyText: '��ע...',
        anchor: '90%'
    });

    var itemCodeField = new Ext.form.TextField({
        id: 'itemCodeField',
        fieldLabel: 'ҵ�������',
        allowBlank: true,
        name: 'itemCode',
        emptyText: 'ҵ�������...',
        anchor: '90%'
    });

    var itemNameField = new Ext.form.TextField({
        id: 'itemNameField',
        fieldLabel: 'ҵ��������',
        allowBlank: true,
        name: 'itemName',
        emptyText: 'ҵ��������...',
        anchor: '90%'
    });

    var servedDeptNameField = new Ext.form.TextField({
        id: 'servedDeptNameField',
        fieldLabel: '��������',
        allowBlank: true,
        name: 'servedDeptName',
        emptyText: '��������...',
        anchor: '90%'
    });

    var servedDeptCodeField = new Ext.form.TextField({
        id: 'servedDeptCodeField',
        fieldLabel: '���Ŵ���',
        allowBlank: true,
        name: 'servedDeptCode',
        emptyText: '���Ŵ���...',
        anchor: '90%'
    });

    var receiverCodeField = new Ext.form.TextField({
        id: 'receiverCodeField',
        fieldLabel: '��Ա����',
        allowBlank: true,
        name: 'receiverCode',
        emptyText: '��Ա����...',
        anchor: '90%'
    });

    var receiverNameField = new Ext.form.TextField({
        id: 'receiverNameField',
        fieldLabel: '��Ա����',
        allowBlank: true,
        name: 'receiverName',
        emptyText: '��Ա����...',
        anchor: '90%'
    });



    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
			itemCodeField,
			itemNameField,
			servedDeptCodeField,
			servedDeptNameField,
			//receiverCodeField,
			//receiverNameField,
			orderField,
			remarkField
		]
    });

    formPanel.on('afterlayout', function(panel, layout) {
        this.getForm().loadRecord(rowObj[0]);
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '�޸���������',
        width: 400,
        height: 300,
        minWidth: 400,
        minHeight: 300,
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
                var itemCode = itemCodeField.getValue();
                var itemName = itemNameField.getValue();
                var servedDeptCode = servedDeptCodeField.getValue();
                var servedDeptName = servedDeptNameField.getValue();
                var receiverCode = receiverCodeField.getValue();
                var receiverName = receiverNameField.getValue();
                var fee = orderField.getValue();
                var remark = remarkField.getValue();
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: otherdataUrl + '?action=edit&id=' + myRowid + '&itemCode=' + itemCode + '&itemName=' + itemName + '&servedDeptCode=' + servedDeptCode + '&servedDeptName=' + servedDeptName + '&receiverCode=' + receiverCode + '&fee=' + fee + '&receiverName=' + receiverName + '&remark=' + remark + '&operDr=' + userDr,
                        waitMsg: '������...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: 'ע��', msg: '�޸ĳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
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
        },
    	{
    	    text: 'ȡ��',
    	    handler: function() { window.close(); }
}]
    });
    window.show();
};