function loadBusData(dataStore,pagingTool)
{
	if (intervalDr == "") {
        Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
        return;
    }
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
								url: ServletURL+'/dhccanow/busdataup?interval='+intervalDr+'&sysType=cost&dataType='+itemTypeId+'&user='+userDr,
								method : 'POST',
								waitMsg:'�����ϴ�, ��ȴ�...',
								success:function(form, action, o) {
									Ext.Msg.show({title:'ע��',msg:"�ϴ��ɹ���",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									 dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,intervalDr:intervalDr}});
									win.close();
								},
								failure:function(form, action) {
									Ext.Msg.show({title:'ע��',msg:action.result.mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				title: '����ҵ������',
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