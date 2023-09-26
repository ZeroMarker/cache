editFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '�����´���...',
		name: 'code',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����������...',
		name: 'name',
		anchor: '90%'
	});
	
	var dataFinishField = new Ext.form.Checkbox({
		id: 'dataFinishField',
		//hideLabel: true,
		labelSeparator: '����ɼ���־',
		allowBlank: false,
		checked: (rowObj[0].data['dataFinish'])=='Y'?true:false
	});

	var treatFinishField = new Ext.form.Checkbox({
		id: 'treatFinishField',
		labelSeparator: '�ɱ��ɼ���־',
		//hideLabel: true,
		//disabled:true,
		allowBlank: false,
		checked: (rowObj[0].data['treatFinish'])=='Y'?true:false
	});
	
	var tieOffField = new Ext.form.Checkbox({
		id: 'tieOffField',
		labelSeparator: '�����ɼ���־',  //'���ʱ�־',
		//disabled:true,
		//hideLabel: true,
		allowBlank: false,
		checked: (rowObj[0].data['tieOff'])=='Y'?true:false
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: false,
		emptyText: '�������...',
		name: 'remark',
		anchor: '90%'
	});
	
	var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '��ʼʱ��',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ��ʼʱ��...',
		anchor: '90%'
	});
	var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '����ʱ��',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ�����ʱ��...',
		anchor: '90%'
	});
	
	/*
	dataFinishField.on('check', function(o, v){
		if(v==true)	{
			treatFinishField.setDisabled(false);
			tieOffField.setDisabled(true);
		}else{
			treatFinishField.setDisabled(true);
			tieOffField.setDisabled(true);
		}
	});
	
	treatFinishField.on('check', function(o, v){
		if(v==true)	{
			dataFinishField.setDisabled(true);
			tieOffField.setDisabled(false);
		}else{
			dataFinishField.setDisabled(false);
			tieOffField.setDisabled(true);
		}
	});
	tieOffField.on('check', function(o, v){
		if(v==true)	{
			dataFinishField.setDisabled(true);
			treatFinishField.setDisabled(true);
		}else{
			dataFinishField.setDisabled(true);
			treatFinishField.setDisabled(false);
		}
	});
	
	var flagPanel = new Ext.Panel({
			layout: 'column',
			border: false,
			//labelWidth: 80,
			baseCls: 'x-plain',
			autoHeight:true,
			defaults: {
				border: false,
				layout: 'form',
				baseCls: 'x-plain',
				//labelSeparator: ':',
				columnWidth: .3
			},
			items: [
				{
					items: dataFinishField
				},
				{
					items: treatFinishField
				},
				{
					items: tieOffField
				}
			]
	});
	*/
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
			startDate,
			endDate,
            //flagPanel,
            remarkField,
            dataFinishField,
            treatFinishField,
            tieOffField
			
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			startDate.setValue(rowObj[0].data['start']);
			endDate.setValue(rowObj[0].data['end']);
		});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ĺ�����',
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
			var remark=remarkField.getValue();
      		var dataFinish = (dataFinishField.getValue()==true)?'Y':'N';
      		var treatFinish = (treatFinishField.getValue()==true)?'Y':'N';
      		var tieOff = (tieOffField.getValue()==true)?'Y':'N';
      		
      		
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
      		
			var sDate=startDate.getValue().format('Y-m-d');
			var eDate=endDate.getValue().format('Y-m-d');
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: AccountMonthsUrl+'?action=edit&id='+myRowid+'&code='+code+'&name='+name+'&dataFinish='+dataFinish+'&treatFinish='+treatFinish+'&tieOff='+tieOff+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='����Ĵ���Ϊ��!';
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
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