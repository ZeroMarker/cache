function paramDataLoad(intervalDr,itemDr,userCode,dataStore)
{
	var fileNameField = new Ext.form.TextField({
		id: 'fileName',
		fieldLabel: 'ѡ���ļ�',
		name: 'upload',
		inputType: 'file',
		allowBlank: false,
		blankText: '��ѡ���ϴ��ļ�...',   
		anchor: '95%'
	});

	// create form panel
	var formPanel = new Ext.form.FormPanel({
				frame: true,
    		id: 'fromPanel',
				baseCls : 'x-plain',
				labelWidth : 80,
				fileUpload : true,
				//enctype : 'multipart/form-data',
				items : [ fileNameField ],
				buttons : [{
					text: '��ʼ�ϴ�',
					handler: function(){
						if (formPanel.getForm().isValid()) {
							formPanel.getForm().submit({
								url: ServletURL+'/dhccanow/ParamDataUp?interval='+intervalDr+'&itemDr='+itemDr+'&type=load&user='+userDr,
								//url: 'http://172.26.201.66:1969/dhccanow/paramdataup?interval='+intervalDr+'&itemDr='+itemDr+'&type=load&user='+userDr,
								method : 'POST',
								waitMsg:'�����ϴ�, ��ȴ�...',
								success:function(form, action, o) {
									Ext.Msg.show({title:'ע��',msg:'�ϴ��ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({
                                params: {
                                    start: 0,
                                    limit: 50,
                                    monthDr: intervalDr,
                                    itemDr: itemDr
                                }
                            });
									win.close();
								},
								failure:function(form, action) {
									Ext.Msg.show({title:'ע��',msg:'�ϴ�ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							});    
						}
						else{
							Ext.Msg.show({title:'ע��',msg:'��������������ϴ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				}]
	});
									
	var win = new Ext.Window( {
				title: '�����������',
		    width: 450,
    		height:200,  
    		minWidth: 450,
    		minHeight: 200,  
    		layout: 'fit',   
    		plain:true,
    		bodyStyle:'padding:5px;',  
    		buttonAlign:'center',  
    		items: formPanel,
    		modal : true,
				maximizable : false
	});
	win.show();
};