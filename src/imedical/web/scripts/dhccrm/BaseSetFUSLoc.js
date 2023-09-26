var fusctevent = function(fusctstore, selectedbrow, selecteddrow, buttontype){

    Ext.QuickTips.init();
    
    var Locrowid = '';
    
//    if (buttontype == 'fusdedit') {
//        sdrowid = selecteddrow.get('SDRowId');
//    }
    if (buttontype == 'fusctadd') {
        Locrowid = '';
    }
     
    
    var fusctform = new Ext.form.FormPanel({
    
        frame: true,
        labelWidth: 80,
        autoHeight: true,
        items: [{
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    xtype: 'numberfield',
                    fieldLabel: '主题ID',
                    id: 'LocParRef',
                    name: 'LocParRef',
                    auchor: '90%',
                    width: 350
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    xtype: 'textfield',
                    fieldLabel: 'RowID',
                    id: 'LocRowId',
                    name: 'LocRowId',
                    auchor: '90%',
                    width: 350
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    xtype: 'textfield',
                    fieldLabel: '科室编码',
                    id: 'LocCode',
                    name: 'LocCode',
                    auchor: '90%',
                    allowBlank: false,
                    width: 350
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    
                    xtype : 'combo',
					fieldLabel : '科室名称',
					id : 'LocCTDR',
					name : 'LocCTDR',
					width : 350,
					allowBlank: false,
					store : new Ext.data.Store({
										url : 'dhccrmreviewremindsend1.csp?actiontype=CTLocList',
										reader : new Ext.data.JsonReader({
														totalProperty : "results",
														root : "rows",
														id : 'CTLocRowID'
													}, [{ name : 'CTLocRowID'}, 
														{ name : 'CTLocName'}
														]
											)
			
						}),
					triggerAction : 'all',
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					valueField : 'CTLocRowID',
					displayField : 'CTLocName'
                }]
            }]
        }]
    
    });
    
    var fusctsave = function(){
    	//alert(encodeURIComponent( Ext.getCmp('LocDesc').getValue()))
												
        var fusdUrl = 'dhccrmbaseset1.csp?actiontype=' + buttontype +
        '&LocParRef=' +
        Ext.getCmp('LocParRef').getValue() +
        '&LocCTDR=' +
        Ext.getCmp('LocCTDR').getValue() 
        
        
        if (fusctform.form.isValid()) {
            Ext.Ajax.request({
                url: fusdUrl,
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
						/*
                        Ext.Msg.show({
                            title: '提示',
                            msg: '数据保存成功!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });
                        
                        */
                       
                        fusctstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=ctlist&FUSRowId=' + Ext.getCmp('LocParRef').getValue();
                        fusctstore.load({
                            params: {
                                start: 0,
                                limit: 20
                            }
                        });
                        window.close();
                        /*
                        if (sdrowid == '') {
                            sdrowid = jsonData.info;
                        }
                        
                        buttontype = 'fusdedit';
                       
						if (buttontype == 'fusdadd'){
							fusdform.getForm().reset();
						}
						*/
                    }
                    else {
                        Ext.MessageBox.show({
                            title: '错误',
                            msg: jsonData.info,
                            buttons: Ext.MessageBox.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    }
                },
                scope: this
            });
        }
        else {
            Ext.Msg.show({
                title: '错误',
                msg: '请修正页面提示的错误后提交',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        }
    }
    
    fusctform.on('afterlayout', function(form, layout){
        /*if (buttontype == 'fusdedit') {
            this.getForm().loadRecord(selecteddrow);
        }*/
        if (buttontype == 'fusctadd') {
            Ext.getCmp('LocParRef').setValue(selectedbrow.get('FUSRowId'));
        }
        Ext.getCmp('LocParRef').disable();
        Ext.getCmp('LocRowId').disable();
        Ext.getCmp('LocCode').disable();
        
    });
    var fusdreset = function(){
		fusctform.getForm().reset();
		buttontype = 'fusctadd';
    }
    var fusctcancel = function(){
        window.close();
    }
    
    var window = new Ext.Window({
    
        title: '科室',
        width: 500,
        height: 400,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:10px;',
        buttonAlign: 'center',
        items: fusctform,
        buttons: [{
            xtype: 'tbbutton',
            text: '保存',
            handler: fusctsave
        }, {
            xtype: 'tbbutton',
            text: '取消',
            handler: fusctcancel
        }]
    });
    
    window.show();
    
}
