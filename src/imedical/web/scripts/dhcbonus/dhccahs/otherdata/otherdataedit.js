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

    var orderField = new Ext.form.NumberField({
        id: 'orderField',
        fieldLabel: '金额',
        allowDecimals: true,
        name: 'fee',
        allowBlank: false,
        emptyText: '金额...',
        anchor: '90%'
    });

    var remarkField = new Ext.form.TextField({
        id: 'remarkField',
        fieldLabel: '备注',
        name: 'remark',
        allowBlank: true,
        emptyText: '备注...',
        anchor: '90%'
    });

    var itemCodeField = new Ext.form.TextField({
        id: 'itemCodeField',
        fieldLabel: '业务项代码',
        allowBlank: true,
        name: 'itemCode',
        emptyText: '业务项代码...',
        anchor: '90%'
    });

    var itemNameField = new Ext.form.TextField({
        id: 'itemNameField',
        fieldLabel: '业务项名称',
        allowBlank: true,
        name: 'itemName',
        emptyText: '业务项名称...',
        anchor: '90%'
    });

    var servedDeptNameField = new Ext.form.TextField({
        id: 'servedDeptNameField',
        fieldLabel: '部门名称',
        allowBlank: true,
        name: 'servedDeptName',
        emptyText: '部门名称...',
        anchor: '90%'
    });

    var servedDeptCodeField = new Ext.form.TextField({
        id: 'servedDeptCodeField',
        fieldLabel: '部门代码',
        allowBlank: true,
        name: 'servedDeptCode',
        emptyText: '部门代码...',
        anchor: '90%'
    });

    var receiverCodeField = new Ext.form.TextField({
        id: 'receiverCodeField',
        fieldLabel: '人员代码',
        allowBlank: true,
        name: 'receiverCode',
        emptyText: '人员代码...',
        anchor: '90%'
    });

    var receiverNameField = new Ext.form.TextField({
        id: 'receiverNameField',
        fieldLabel: '人员名称',
        allowBlank: true,
        name: 'receiverName',
        emptyText: '人员名称...',
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
        title: '修改其他数据',
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
            text: '保存',
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
                        waitMsg: '保存中...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: '注意', msg: '修改成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr, dataTypeDr: itemTypeId} });
                                window.close();
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
};