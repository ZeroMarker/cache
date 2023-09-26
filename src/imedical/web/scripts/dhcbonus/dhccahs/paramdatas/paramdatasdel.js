delFun = function(dataStore, grid, pagingTool){
    // get the selected items
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if (len > 0) {
        Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn){
            if (btn == 'yes') {
                for (var i = 0; i < len; i++) {
                    Ext.Ajax.request({
                        url: paramDatasUrl + '?action=del&id=' + rowObj[i].get("rowid"),
                        waitMsg: 'ɾ����...',
                        failure: function(result, request){
                            Ext.Msg.show({
                                title: '����',
                                msg: '������������!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        },
                        success: function(result, request){
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
                                if (i == len - 1) 
                                    Ext.MessageBox.alert('��ʾ', 'ɾ�����');
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
                                    title: '����',
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
        Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ�����·ݸò�������?', function(btn){
            if (btn == 'yes') {
            
                Ext.Ajax.request({
                    url: paramDatasUrl + '?action=delMonth&id=' + monthDr + '&itemDr=' + itemDr,
                    waitMsg: 'ɾ����...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '����',
                            msg: '������������!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                                Ext.MessageBox.alert('��ʾ', 'ɾ�����');
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
                                title: '����',
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
	
	
	 Ext.MessageBox.confirm('��ʾ', '�˲�����ɾ������ȫ���������ݣ����������!', function(btn){
            if (btn == 'yes') {
            //alert(monthDr),
                Ext.Ajax.request({
                    url: paramDatasUrl + '?action=delMonthAll&id=' + monthDr,
                    waitMsg: 'ɾ����...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '����',
                            msg: '������������!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                                Ext.MessageBox.alert('��ʾ', 'ɾ�����');
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
                                title: '����',
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