editFun = function(dataStore,grid,pagingTool) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var unitMeasDevDr = "";
	var unitDr = "";
	var dataItemDr = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		unitMeasDevDr = rowObj[0].get("rowId");
		unitDr = rowObj[0].get("unitDr");
		dataItemDr = rowObj[0].get("dataItemDr");
	}

	var orderField = new Ext.form.TextField({
		id:'orderField',
    fieldLabel: '���',
    allowBlank: false,
    emptyText:'��λ������ƴ���...',
    name:'order',
    anchor: '95%'
	});

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'��λ������ƴ���...',
    name:'code',
    anchor: '95%'
	});


	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '��ע',
    allowBlank: true,
    emptyText:'��λ������Ʊ�ע...',
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
    				orderField,
    				codeField,
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
  	title: '�޸ĵ�λ�������',
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
					var order = orderField.getValue();
      		var code = codeField.getValue();
          var remark  = remarkField.getValue();
          var startTime = (startField.getValue()=='')?'':startField.getValue().format('Y-m-d');
      		var stop = (stopField.getValue()=='')?'':stopField.getValue().format('Y-m-d');
      		var active = (activeField.getValue()==true)?'Y':'N';
      		order = order.trim();
      		code = code.trim();
      		remark = remark.trim();
      		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: unitMeasDevUrl+'?action=edit&unitDr='+unitDr+'&dataItemDr='+dataItemDr+'&id='+unitMeasDevDr+'&order='+order+'&code='+code+'&remark='+remark+'&startTime='+startTime+'&stop='+stop+'&active='+active,
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
									if(jsonData.info=='RepOrder') message='����������Ѿ�����!';
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