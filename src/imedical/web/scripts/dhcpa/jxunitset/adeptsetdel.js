delFun = function(ds,grid,pagingToolbar){
    var rowObj = grid.getSelections();
        var len = rowObj.length;
        if(len > 0){
            Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?',
                function(btn) {
                    if(btn == 'yes'){
                        for(var i = 0; i < len; i++){
                            Ext.Ajax.request({
                                url: deptSetUrl+'?action=delete&rowid='+rowObj[i].get("rowid"),
                                waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                    Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                    if (jsonData.success=='true') {
                                        Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
                                        ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
                                    }else {
                                        if(jsonData.info=='childNode'){
							                Ext.Msg.show({title:'��ʾ',msg:'�÷ֲ����´����ӽڵ㣬����ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						                }
                                        if(jsonData.info=='leafNode'){
							                Ext.Msg.show({title:'��ʾ',msg:'�÷ֲ����´���ʵ�岿�ţ�����ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						                }
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                }
            );
        }else{
            Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        }

};