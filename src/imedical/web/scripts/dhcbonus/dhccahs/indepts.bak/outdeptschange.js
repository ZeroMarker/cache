outdeptschange=function(parRef,rowId,code,name,patType,remark){
	
	var inDeptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut'])
	});
	var inDepts = new Ext.form.ComboBox({
		id: 'inDepts',
		fieldLabel: '���㲿��',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: inDeptDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����㲿��...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	inDeptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.indeptsexe.csp?action=listInDepts&inDeptSetsId='+inDeptSetsId+'&str='+encodeURIComponent(Ext.getCmp('inDepts').getRawValue()),method:'POST'});
	});
	var window = new Ext.Window({
        title: '����ת��',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [inDepts],
        buttons: [{
            text: 'ȷ��',
            handler: function(){
                if (inDepts.getValue() == "") {
                    Ext.Msg.show({
                        title: 'ע��',
                        msg: '��ѡ����㲿��!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.WARNING
                    });
                    return;
                }
                Ext.Ajax.request({
                    url: outDeptsUrl + '?action=outdeptschange&inDeptId=' + inDepts.getValue() + '&outDeptId=' + rowId+'&code='+code+'&name='+name+'&patType='+patType+'&remark='+remark,
                    waitMsg: '������...',
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
                            Ext.Msg.show({
                                title: '�ɹ�!',
                                msg: '�ӿ��ƶ��ɹ�!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
							outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId='+parRef+'&sort=rowid&dir=DESC'});
							outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
						}else {
                            var message = "";
                            message = jsonData.info;
                            Ext.Msg.show({
                                title: 'ʧ��!',
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
            text: 'ȡ��',
            handler: function(){
                window.close();
            }
        }]
    });
	window.show();
};
