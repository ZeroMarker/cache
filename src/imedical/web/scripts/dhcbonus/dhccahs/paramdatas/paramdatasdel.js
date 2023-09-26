delFun = function(dataStore, grid, pagingTool){
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if (len > 0) {
        Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn){
            if (btn == 'yes') {
                for (var i = 0; i < len; i++) {
                    Ext.Ajax.request({
                        url: paramDatasUrl + '?action=del&id=' + rowObj[i].get("rowid"),
                        waitMsg: '删除中...',
                        failure: function(result, request){
                            Ext.Msg.show({
                                title: '错误',
                                msg: '请检查网络连接!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        },
                        success: function(result, request){
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                if (i == len - 1) 
                                    Ext.MessageBox.alert('提示', '删除完成');
                                dataStore.load({
                                    params: {
                                        start: pagingTool.cursor,
                                        limit: pagingTool.pageSize,
                                        monthDr: monthDr,
                                        itemDr: itemDr
                                    }
                                });
                            }
                            else {
                                var message = "SQLErr: " + jsonData.info;
                                Ext.Msg.show({
                                    title: '错误',
                                    msg: message,
                                    buttons: Ext.Msg.OK,
                                    icon: Ext.MessageBox.ERROR
                                });
                            }
                        },
                        scope: this
                    });
                }
            }
        });
    }
    else {
        Ext.MessageBox.confirm('提示', '确定要删除此月份该参数数据?', function(btn){
            if (btn == 'yes') {
            
                Ext.Ajax.request({
                    url: paramDatasUrl + '?action=delMonth&id=' + monthDr + '&itemDr=' + itemDr,
                    waitMsg: '删除中...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                                Ext.MessageBox.alert('提示', '删除完成');
                            dataStore.load({
                                params: {
                                    start: pagingTool.cursor,
                                    limit: pagingTool.pageSize,
                                    monthDr: monthDr,
                                    itemDr: itemDr
                                }
                            });
                        }
                        else {
                            var message = "SQLErr: " + jsonData.info;
                            Ext.Msg.show({
                                title: '错误',
                                msg: message,
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        }
                    },
                    scope: this
                });
                
            }
        });
    }
    
};


delAllFun=function(dataStore, grid, pagingTool){
	
	
	 Ext.MessageBox.confirm('提示', '此操作将删除本月全部参数数据，请谨慎操作!', function(btn){
            if (btn == 'yes') {
            //alert(monthDr),
                Ext.Ajax.request({
                    url: paramDatasUrl + '?action=delMonthAll&id=' + monthDr,
                    waitMsg: '删除中...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                                Ext.MessageBox.alert('提示', '删除完成');
                            dataStore.load({
                                params: {
                                    start: pagingTool.cursor,
                                    limit: pagingTool.pageSize,
                                    monthDr: monthDr,
                                    itemDr: itemDr
                                }
                            });
                        }
                        else {
                            var message = "SQLErr: " + jsonData.info;
                            Ext.Msg.show({
                                title: '错误',
                                msg: message,
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        }
                    },
                    scope: this
                });
                
            }
        });
	
	
	
	}