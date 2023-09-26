addFun = function(dataStore,grid,pagingTool) {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '�����´���...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����������...',
		anchor: '90%'
	});
	
	var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '��ʼ����',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ��ʼ����...',
		anchor: '90%'
	});
	var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '��������',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ���������...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText:'��ע...',
		anchor: '90%'
	});
	
	remarkField.on('check', function(o, v){
		if(v==true)	inFlagField.setValue(false);
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
            startDate,
			endDate,
			remarkField
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��Ӻ�����',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����', 
		handler: function() {
      		// check form value
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
			
			var sDate=startDate.getValue().format('Y-m-d');
			var eDate=endDate.getValue().format('Y-m-d');
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
			
      		code = code.trim();
      		name = name.trim();
      		
			remark = remark.trim();
      		
      		if(code=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
      		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: AccountMonthsUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='����Ĵ���Ϊ��!';
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='EmptyStart') message='����Ŀ�ʼ����Ϊ��!';
									if(jsonData.info=='EmptyEnd') message='����Ľ�������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
									if(jsonData.info=='NameformatError') message='�뽫��������Ƹ�Ϊ YYYY-MM ��ʽ!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });

    window.show();
};