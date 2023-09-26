LargEditFun = function(dataStore, grid, pagingTool, month) {

    var rowObj = grid.getSelections();
    var len = rowObj.length;

    if (len < 1) {
        Ext.Msg.show({ title: '注意', msg: '请选择需要修改的行!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }
    var nowdate = new Date().format('Y-m-d');
    var myId = "";
    var calFlag = "";
    calFlag = rowObj[0].get("calFlag");
    myId = rowObj[0].get("rowid");
    if (calFlag == "Y") {
        Ext.Msg.show({ title: '注意', msg: '计算标志为"Y"的数据不能再次分期!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }
    var inDate = new Ext.form.DateField({
        id: 'inDate',
        fieldLabel: '首期日期',
        allowBlank: false,
        dateFormat: 'y-m-d',
        //minValue:nowdate,
        emptyText: '首期日期...',
        anchor: '90%'
    });

    function getNextMonth(count) {
        var today = Ext.getCmp('inDate').getValue().format('Y-m-d');
        var arys = today.split('-');
        var y, m, d;
        var rs = "";
        //d = 20; 
        m = --arys[1];
        y = arys[0];
        d = arys[2]
        for (var i = 0; i < count; i++) {
            var nextToday = new Date(y, m, d);
            m = m + 1;
            if (m > 12) {
                m = 1; y++;
            }
            if (rs == "") { rs = nextToday.format('Y-m-d') }
            else { rs = rs + "^" + nextToday.format('Y-m-d'); }
        }
        return rs;
    }
    function getNextFee(count, fee) {
        var rs = "";
        var tmp = "";
        for (var i = 0; i < count; i++) {
            if (i == count - 1) { tmp = fee % count + Math.floor(fee / count); }
            else { tmp = Math.floor(fee / count); }
            if (rs == "") { rs = tmp; }
            else { rs = rs + "^" + tmp; }
        }
        return rs;
    }
    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
			inDate
		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '计算分期',
        width: 350,
        height: 100,
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
                var cash = rowObj[0].get("fee");
                var cycles = rowObj[0].get("cycles");
                if (formPanel.form.isValid()) {
                    Ext.Ajax.request({
                        url: largCostUrl + '?action=addDetail&largCostDr=' + myId + '&fee=' + getNextFee(cycles, cash) + '&vouchDate=' + getNextMonth(cycles),
                        waitMsg: '保存中...',
                        failure: function(result, request) {
                            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({ title: '注意', msg: '保存成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                                dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize} });
                                largCostDetailDs.load({ params: { start: 0, limit: largCostDetailPagingToolbar.pageSize} });
                                window.close();
                            }
                            else {
                                var message = "";
                                if (jsonData.info == 'RepCode') message = '输入的代码已经存在!';
                                if (jsonData.info == 'RepName') message = '输入的名称已经存在!';
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