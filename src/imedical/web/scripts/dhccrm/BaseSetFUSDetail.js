
var fusdevent = function(fusdstore, selectedbrow, selecteddrow, buttontype){

    Ext.QuickTips.init();
    
    var sdrowid = '';
    var Flag=false;
    
    if (buttontype == 'fusdedit') {
        sdrowid = selecteddrow.get('SDRowId');
    }
    if (buttontype == 'fusdlook') {
        sdrowid = selecteddrow.get('SDRowId');
        Flag=true;
    }
    if (buttontype == 'fusdadd') {
        sdrowid = '';
    }
    
    var typestore = new Ext.data.SimpleStore({
        fields: ['typeid', 'typename'],
        data: [['T', '文本型'], ['N', '数值型'], ['S', '单选型'],['D', '多选型'],['DT', '多文本'],['DN', '多数值']]
    });
    
    var sexstore = new Ext.data.SimpleStore({
        fields: ['sexid', 'sexname'],
        data: [['M', '男'], ['F', '女'], ['N', '不限']]
    });
    
    var fusdform = new Ext.form.FormPanel({
    
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
                    id: 'SDParRef',
                    name: 'SDParRef',
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
                    fieldLabel: '内容ID',
                    id: 'SDRowId',
                    name: 'SDRowId',
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
                    fieldLabel: '编码',
                    id: 'SDCode',
                    name: 'SDCode',
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
                    xtype: 'textfield',
                    fieldLabel: '名称',
                    id: 'SDDesc',
                    name: 'SDDesc',
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
                    xtype: 'combo',
                    fieldLabel: '类型',
                    id: 'SDType',
                    name: 'SDType',
                    auchor: '90%',
                    width: 350,
                    allowBlank: false,
                    store: typestore,
                    displayField: 'typename',
                    valueField: 'typeid',
                    triggerAction: 'all',
                    mode: 'local',
                    editable:false,
                    emptyText: '点击选择类型'
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    xtype: 'combo',
                    fieldLabel: '性别',
                    id: 'SDSex',
                    name: 'SDSex',
                    auchor: '90%',
                    width: 350,
                    store: sexstore,
                    displayField: 'sexname',
                    valueField: 'sexid',
                    triggerAction: 'all',
                    mode: 'local',
                    editable:false,
                    emptyText: '点击选择性别'
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    xtype: 'textfield',
                    fieldLabel: '单位',
                    id: 'SDUnit',
                    name: 'SDUnit',
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
                    fieldLabel: '说明',
                    id: 'SDExplain',
                    name: 'SDExplain',
                    auchor: '90%',
                    width: 350
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: .5,
                layout: 'form',
                items: [{
                    xtype: 'checkbox',
                    boxLabel: '激活',
                    id: 'SDActive',
                    labelSeparator: '',
                    name: 'SDActive'
                }]
            }, {
                columnWidth: .5,
                layout: 'form',
                items: [{
                    xtype: 'checkbox',
                    boxLabel: '必须项',
                    id: 'SDRequired',
                    labelSeparator: '',
                    name: 'SDRequired'
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 1,
                layout: 'form',
                items: [{
                    xtype: 'datefield',
                    fieldLabel: '有效日期',
                    id: 'SDEffDate',
                    name: 'SDEffDate',
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
                    xtype: 'datefield',
                    fieldLabel: '截止日期',
                    id: 'SDEffDateTo',
                    name: 'SDEffDateTo',
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
                    xtype: 'numberfield',
                    fieldLabel: '顺序号',
                    id: 'SDSequence',
                    name: 'SDSequence',
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
                    xtype: 'textfield',
                    fieldLabel: '父层ID',
                    id: 'SDParentDR',
                    name: 'SDParentDR',
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
                    fieldLabel: '层次',
                    id: 'SDCascade',
                    name: 'SDCascade',
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
                    xtype: 'numberfield',
                    fieldLabel: '显示列数',
                    id: 'SDSelectNum',
                    name: 'SDSelectNum',
					allowDecimals : false,
                    auchor: '90%',
                    width: 350
                }]
            }]
        }]
    
    });
    
    var fusdsave = function(){
    
        var effdate = '';
        if (Ext.getCmp('SDEffDate').getValue() != '') {
            effdate = Ext.getCmp('SDEffDate').getValue().format('Y-m-d').toString();
        }
        var enddate = '';
        if (Ext.getCmp('SDEffDateTo').getValue() != '') {
            enddate = Ext.getCmp('SDEffDateTo').getValue().format('Y-m-d').toString();
        }
        
        var fusdUrl = 'dhccrmbaseset1.csp?actiontype=' + buttontype +
        '&SDParRef=' +
        Ext.getCmp('SDParRef').getValue() +
        '&SDRowId=' +
        sdrowid +
        '&SDCode=' +
        Ext.getCmp('SDCode').getValue() +
        '&SDDesc=' +
        encodeURI(encodeURI(Ext.getCmp('SDDesc').getValue())) +
        '&SDType=' +
        encodeURI(encodeURI(Ext.getCmp('SDType').getValue())) +
        '&SDSex=' +
        encodeURI(encodeURI(Ext.getCmp('SDSex').getValue()))+
        '&SDUnit=' +
        encodeURI(encodeURI(Ext.getCmp('SDUnit').getValue())) +
        '&SDExplain=' +
        encodeURI(encodeURI(Ext.getCmp('SDExplain').getValue())) +
        '&SDActive=' +
        Ext.getCmp('SDActive').getValue() +
        '&SDRequired=' +
        Ext.getCmp('SDRequired').getValue() +
        '&SDEffDate=' +
        effdate +
        '&SDEffDateTo=' +
        enddate +
        '&SDSequence=' +
        Ext.getCmp('SDSequence').getValue() +
        '&SDParentDR=' +
        Ext.getCmp('SDParentDR').getValue() +
        '&SDCascade=' +
        Ext.getCmp('SDCascade').getValue() +
        '&SDSelectNum=' +
        Ext.getCmp('SDSelectNum').getValue();
        
		var strtmp=Ext.getCmp('SDSelectNum').getValue();
		var r = /^[0-9]*[1-9][0-9]*$/　　//正整数 

		//r.test(strtmp); 
		
		if (!(r.test(strtmp)))
		{
		//alert(r.test(strtmp)) 
		alert("列数请输入整数")
			return;
			
		}
		
        if (fusdform.form.isValid()) {
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
					//alert(jsonData)
                    if (jsonData.success == 'true') {
						/*
                        Ext.Msg.show({
                            title: '提示',
                            msg: '数据保存成功!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });
                        
                        */
                       
                        fusdstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=fusdlist&FUSRowId=' + Ext.getCmp('SDParRef').getValue();
                        fusdstore.load({
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
    
    fusdform.on('afterlayout', function(form, layout){
        if (buttontype == 'fusdedit') {
            this.getForm().loadRecord(selecteddrow);
        }
        if (buttontype == 'fusdlook') {
            this.getForm().loadRecord(selecteddrow);
            Ext.getCmp('SDCode').disable();
            Ext.getCmp('SDDesc').disable();
            Ext.getCmp('SDType').disable();
            Ext.getCmp('SDSex').disable();
            Ext.getCmp('SDUnit').disable();
            Ext.getCmp('SDExplain').disable();
            Ext.getCmp('SDActive').disable();
            Ext.getCmp('SDRequired').disable();
            Ext.getCmp('SDEffDate').disable();
            Ext.getCmp('SDEffDateTo').disable();
            Ext.getCmp('SDSequence').disable();
            Ext.getCmp('SDParentDR').disable();
            Ext.getCmp('SDCascade').disable();
            Ext.getCmp('SDSelectNum').disable();
            
        }
        if (buttontype == 'fusdadd') {
            Ext.getCmp('SDParRef').setValue(selectedbrow.get('FUSRowId'));
        }
        Ext.getCmp('SDParRef').disable();
        Ext.getCmp('SDRowId').disable();
        
    });
    var fusdreset = function(){
		fusdform.getForm().reset();
		buttontype = 'fusdadd';
    }
    var fusdcancel = function(){
        window.close();
    }
    
    var window = new Ext.Window({
    
        title: '内容信息',
        width: 500,
        height: 550,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:10px;',
        buttonAlign: 'center',
        items: fusdform,
        buttons: [{
        	hidden:Flag,
            xtype: 'tbbutton',
            text: '保存',
            handler: fusdsave
        }, {
            xtype: 'tbbutton',
            text: '取消',
            handler: fusdcancel
        }]
    });
    
    window.show();
    
}
