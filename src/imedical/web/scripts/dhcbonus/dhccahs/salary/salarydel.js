delFun = function(dataStore, grid, pagingTool) {
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if (len > 0) {
        Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫɾ��ѡ������?',
    	    function(btn) {
    	        if (btn == 'yes') {
    	            for (var i = 0; i < len; i++) {
    	                Ext.Ajax.request({
    	                    url: salaryUrl + '?action=del&id=' + rowObj[i].get("rowid"),
    	                    waitMsg: 'ɾ����...',
    	                    failure: function(result, request) {
    	                        Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                    },
    	                    success: function(result, request) {
    	                        var jsonData = Ext.util.JSON.decode(result.responseText);
    	                        if (jsonData.success == 'true') {
    	                            Ext.MessageBox.alert('��ʾ', 'ɾ�����');
    	                            dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
    	                        }
    	                        else {
    	                            var message = "SQLErr: " + jsonData.info;
    	                            Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
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
            Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            return;
        }
        Ext.MessageBox.confirm('��ʾ',
    	    'ȷ��Ҫɾ����������ô?',
    	    function(btn) {
    	        if (btn == 'yes') {

    	            Ext.Ajax.request({
    	                url: salaryUrl + '?action=delall&intervalDr=' + intervalDr + '&dataTypeDr=' + ITEMTYPEID,
    	                waitMsg: 'ɾ����...',
    	                failure: function(result, request) {
    	                    Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                },
    	                success: function(result, request) {
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
    	                        if (i == len - 1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
    	                        dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
    	                    }
    	                    else {
    	                        var message = "SQLErr: " + jsonData.info;
    	                        Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
    	                    }
    	                },
    	                scope: this
    	            });

    	        }
    	    }
		);
    }

};