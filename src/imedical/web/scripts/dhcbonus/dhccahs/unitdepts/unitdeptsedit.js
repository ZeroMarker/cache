editFun = function(dataStore,grid,pagingTool) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var unitDeptDr = "";
	var unitDr = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		unitDeptDr = rowObj[0].get("rowId");
		unitDr = rowObj[0].get("unitDr");
	}

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'��λ���Ŵ���...',
    name:'code',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'��λ��������...',
    name:'name',
    anchor: '95%'
	});
	
	var addressField = new Ext.form.TextField({
		id:'addressField',
    fieldLabel: '��ַ',
    allowBlank: true,
    emptyText:'��λ���ŵ�ַ...',
    name:'address',
    anchor: '95%'
	});

	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '��ע',
    allowBlank: true,
    emptyText:'��λ���ű�ע...',
    name:'remark',
    anchor: '95%'
	});
	
	var startField = new Ext.form.DateField({
		id: 'startField',
		fieldLabel: '����ʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		value: rowObj[0].data['startTime'],
		anchor: '95%'
	});
	
	var stopField = new Ext.form.DateField({
		id: 'stopField',
		fieldLabel: 'ͣ��ʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		value: rowObj[0].data['stop'],
		anchor: '95%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		labelSeparator: '��Ч:',
    allowBlank: false,
    //name:'active',
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    				codeField,
            nameField,
            addressField,
            remarkField,
            startField,
            stopField,
            activeField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ĵ�λ����',
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
      		var address = addressField.getValue();
          var remark  = remarkField.getValue();
          var startTime = (startField.getValue()=='')?'':startField.getValue().format('Y-m-d');
      		var stop = (stopField.getValue()=='')?'':stopField.getValue().format('Y-m-d');
      		var active = (activeField.getValue()==true)?'Y':'N';
      		
      		code = code.trim();
      		name = name.trim();
      		address = address.trim();
      		remark = remark.trim();
      		
      		if(unitDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��λ�������δ֪!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(code=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: unitDeptsUrl+'?action=edit&unitDr='+unitDr+'&id='+unitDeptDr+'&code='+code+'&name='+name+'&address='+address+'&remark='+remark+'&startTime='+startTime+'&stop='+stop+'&active='+active,
							//alert("asdffas");
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
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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