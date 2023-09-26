changeOutFun=function(dataStore,grid,pagingTool) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form
    var itemSetsId=inItemSetSelecter.getValue();
	if(itemSetsId==""||itemSetsId==null){
		Ext.Msg.show({title:'注意',msg:'请选择接口项目套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var rowId = "";
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		fieldLabel: '核算项目',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: inItemDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择核算项目...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	inItemDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listInItems&inItemSetsDr='+itemSetsId+'&str='+Ext.getCmp('inItems').getRawValue(),method:'GET'});
	});
	var window = new Ext.Window({
        title: '接口项目转换至',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [inItems],
        buttons: [{
            text: '确定',
            handler: function(){
                if (inItems.getValue() == "") {
                    Ext.Msg.show({
                        title: '注意',
                        msg: '请选择核算项目!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.WARNING
                    });
                    return;
                }
                Ext.Ajax.request({
                    url: 'dhc.ca.initemsexe.csp' + '?action=outItemChange&rowid=' + rowId+'&parRef='+inItems.getValue(),//rowid外部科目id
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
                                msg: '接口项目移动成功!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
							dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
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
