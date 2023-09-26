outdeptschange=function(parRef,rowId,code,name,patType,remark){
	
	var inDeptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut'])
	});
	var inDepts = new Ext.form.ComboBox({
		id: 'inDepts',
		fieldLabel: '核算部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: inDeptDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择核算部门...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	inDeptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.indeptsexe.csp?action=listInDepts&inDeptSetsId='+inDeptSetsId+'&str='+encodeURIComponent(Ext.getCmp('inDepts').getRawValue()),method:'POST'});
	});
	var window = new Ext.Window({
        title: '部门转换',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [inDepts],
        buttons: [{
            text: '确定',
            handler: function(){
                if (inDepts.getValue() == "") {
                    Ext.Msg.show({
                        title: '注意',
                        msg: '请选择核算部门!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.WARNING
                    });
                    return;
                }
                Ext.Ajax.request({
                    url: outDeptsUrl + '?action=outdeptschange&inDeptId=' + inDepts.getValue() + '&outDeptId=' + rowId+'&code='+code+'&name='+name+'&patType='+patType+'&remark='+remark,
                    waitMsg: '保存中...',
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
                            Ext.Msg.show({
                                title: '成功!',
                                msg: '接口移动成功!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
							outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId='+parRef+'&sort=rowid&dir=DESC'});
							outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
						}else {
                            var message = "";
                            message = jsonData.info;
                            Ext.Msg.show({
                                title: '失败!',
                                msg: message,
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
                        }
                    },
                    scope: this
                });
                window.close();
            }
        }, {
            text: '取消',
            handler: function(){
                window.close();
            }
        }]
    });
	window.show();
};
