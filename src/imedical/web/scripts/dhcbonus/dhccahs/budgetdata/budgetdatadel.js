delFun = function(dataStore, grid, pagingTool) {
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if (len > 0) {
        Ext.MessageBox.confirm('提示',
    	    '确定要删除选定的行?',
    	    function(btn) {
    	        if (btn == 'yes') {
    	            for (var i = 0; i < len; i++) {
    	                Ext.Ajax.request({
    	                    url: budgetDataUrl + '?action=del&id=' + rowObj[i].get("rowid"),
    	                    waitMsg: '删除中...',
    	                    failure: function(result, request) {
    	                        Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                    },
    	                    success: function(result, request) {
    	                        var jsonData = Ext.util.JSON.decode(result.responseText);
    	                        if (jsonData.success == 'true') {
    	                            Ext.MessageBox.alert('提示', '删除完成');
    	                            dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr} });
    	                        }
    	                        else {
    	                            var message = "SQLErr: " + jsonData.info;
    	                            Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                        }
    	                    },
    	                    scope: this
    	                });
    	            }
    	        }
    	    }
		);
    }
    else {
        if (intervalDr == "") {
            Ext.Msg.show({ title: '错误', msg: '请选择核算区间再试!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
        Ext.MessageBox.confirm('提示',
    	    '确定要删除当月数据么?',
    	    function(btn) {
    	        if (btn == 'yes') {

    	            Ext.Ajax.request({
    	                url: budgetDataUrl + '?action=delall&intervalDr=' + intervalDr,
    	                waitMsg: '删除中...',
    	                failure: function(result, request) {
    	                    Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                },
    	                success: function(result, request) {
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
    	                        if (i == len - 1) Ext.MessageBox.alert('提示', '删除完成');
    	                        dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr} });
    	                    }
    	                    else {
    	                        var message = "SQLErr: " + jsonData.info;
    	                        Ext.Msg.show({ title: '错误', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                    }
    	                },
    	                scope: this
    	            });

    	        }
    	    }
		);
    }

};