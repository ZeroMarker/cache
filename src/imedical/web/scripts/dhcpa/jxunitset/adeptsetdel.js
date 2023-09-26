delFun = function(ds,grid,pagingToolbar){
    var rowObj = grid.getSelections();
        var len = rowObj.length;
        if(len > 0){
            Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
                function(btn) {
                    if(btn == 'yes'){
                        for(var i = 0; i < len; i++){
                            Ext.Ajax.request({
                                url: deptSetUrl+'?action=delete&rowid='+rowObj[i].get("rowid"),
                                waitMsg:'删除中...',
                                failure: function(result, request) {
                                    Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                    if (jsonData.success=='true') {
                                        Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
                                        ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
                                    }else {
                                        if(jsonData.info=='childNode'){
							                Ext.Msg.show({title:'提示',msg:'该分层套下存在子节点，请先删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						                }
                                        if(jsonData.info=='leafNode'){
							                Ext.Msg.show({title:'提示',msg:'该分层套下存在实体部门，请先删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
            Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        }

};