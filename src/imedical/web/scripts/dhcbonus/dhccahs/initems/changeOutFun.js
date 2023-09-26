changeOutFun=function(dataStore,grid,pagingTool) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form
    var itemSetsId=inItemSetSelecter.getValue();
	if(itemSetsId==""||itemSetsId==null){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿ���Ŀ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var rowId = "";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		rowId = rowObj[0].get("rowId");
	}
	var inItemDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','shortcut'])
	});
	var inItems = new Ext.form.ComboBox({
		id: 'inItems',
		fieldLabel: '������Ŀ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: inItemDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�������Ŀ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	inItemDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listInItems&inItemSetsDr='+itemSetsId+'&str='+Ext.getCmp('inItems').getRawValue(),method:'GET'});
	});
	var window = new Ext.Window({
        title: '�ӿ���Ŀת����',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [inItems],
        buttons: [{
            text: 'ȷ��',
            handler: function(){
                if (inItems.getValue() == "") {
                    Ext.Msg.show({
                        title: 'ע��',
                        msg: '��ѡ�������Ŀ!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.WARNING
                    });
                    return;
                }
                Ext.Ajax.request({
                    url: 'dhc.ca.initemsexe.csp' + '?action=outItemChange&rowid=' + rowId+'&parRef='+inItems.getValue(),//rowid�ⲿ��Ŀid
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
                                msg: '�ӿ���Ŀ�ƶ��ɹ�!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
							dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
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
