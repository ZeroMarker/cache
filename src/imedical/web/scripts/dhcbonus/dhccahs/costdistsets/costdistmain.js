
costDistMain = function(dataStore, grid, pagingTool) {

    var rowObj = grid.getSelections();
    var len = rowObj.length;
    var repdr = "";
    var rowid = "";
    var repname = "";
    var monthDr = "";
    var active = "";
    if (len < 1) {
        Ext.Msg.show({ title: '注意', msg: '请选择成本分摊套!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }
    else {
        active = rowObj[0].get("active");
        rowid = rowObj[0].get("rowid");
        repdr = rowObj[0].get("deptSetDr");
        repname = rowObj[0].get("deptSetName");
    }
    if (active != "Y") {
	    //'不能为'+'<span style="color:red;">无效方法</span>'+'进行数据分摊!'  zjw 20160708 前台和后台均可变化使用
        Ext.Msg.show({ title: '注意', msg: '不能为<span style="color:red;">无效方法</span>进行数据分摊!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }


    var monthsDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
    });
    var months = new Ext.form.ComboBox({
        id: 'months',
        fieldLabel: '核算区间',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: monthsDs,
        //readOnly:true,
        valueField: 'rowid',
        displayField: 'name',
        triggerAction: 'all',
        emptyText: '选择核算区间...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    monthsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(), method: 'GET' });
    });
    months.on('select', function(combo, record, index) {
        monthDr = combo.getValue();
    });
    var window = new Ext.Window({
        title: '成本分摊',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [months],
        buttons: [
		{
		    text: '执行分摊',
		    handler: function() {
		        if (months.getValue() == "") {
		            Ext.Msg.show({ title: '注意', msg: '请选择核算区间!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
		            return;
		        }
		        
		        Ext.Ajax.request({
		            url: costDistSetsUrl + '?action=checkResult&monthDr=' + monthDr + '&costSetsDr=' + rowid,
		            waitMsg: '保存中...',
		            failure: function(result, request) {
			           
		                Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		            },
		            success: function(result, request) {
		                var jsonData = Ext.util.JSON.decode(result.responseText);
		                
		                if (jsonData.success == 'true') {
			                Ext.Ajax.timeout=720000; //zjw 20160608
		        			//var mask=ShowLoadMask(Ext.getBody(),"处理中..."); //zjw 20160608
		        			var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
						    loadMask.show();
		                    Ext.Ajax.request({
		                        url: costDistSetsUrl + '?action=doDist&monthDr=' + monthDr + '&costSetsDr=' + rowid,
		                        waitMsg: '保存中...',
		                        failure: function(result, request) {
			                         loadMask.hide(); //zjw 20160608
		                            Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		                        },
		                        success: function(result, request) {
		                            var jsonData = Ext.util.JSON.decode(result.responseText);
		                            loadMask.hide(); //zjw 20160608
		                            if (jsonData.success == 'true') {
		                                Ext.Msg.show({ title: '注意', msg: jsonData.info, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
		                                window.close();
		                            }
		                            else {
		                                var message = "";
		                                message = "SQLErr: " + jsonData.info;
		                                Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		                            }
		                        },
		                        scope: this
		                    });
		                }
		                else {
		                    var message ="请到\"查看分摊结果\"界面删除数据后再试!";
		                    Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		                }
		            },
		            scope: this
		        });
				Ext.Msg.show({ title: '注意', msg: "数据分摊中,请稍等！", buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
				window.close();
		    }
		},
    	{
    	    text: '取消',
    	    handler: function() { window.close(); }
}]
    });

    window.show();
};