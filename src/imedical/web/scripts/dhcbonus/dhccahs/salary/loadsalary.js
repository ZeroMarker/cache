function loadSalary()
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
								//url: 'http://127.0.0.1:8080/dhccanow/salaryup?interval='+intervalDr+'&sysType=cost&dataType='+ITEMTYPEID+'&user='+userDr,
								url: 'http://172.26.201.66:1969/dhccanow/salaryup?interval='+intervalDr+'&sysType=cost&dataType='+ITEMTYPEID+'&user='+userDr,
								method : 'POST',
								waitMsg:'�����ϴ�, ��ȴ�...',
								success:function(form, action, o) {
									Ext.Msg.show({title:'ע��',msg:action.result.mess,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
				title: '���빤������',
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