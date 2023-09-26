addFun = function(dataStore,grid,pagingTool,unitDr,dataItemDr) {
	Ext.QuickTips.init();
  // pre-define fields in the form
  
  var orderField = new Ext.form.TextField({
		id:'orderField',
    fieldLabel: '���',
    allowBlank: false,
    emptyText:'��λ������ƴ���...',
    anchor: '95%'
	});

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'��λ������ƴ���...',
    anchor: '95%'
	});


	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '��ע',
    allowBlank: true,
    emptyText:'��λ������Ʊ�ע...',
    anchor: '95%'
	});
	
		var startField = new Ext.form.DateField({
		id: 'startField',
		fieldLabel: '����ʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		anchor: '95%'
	});

	var stopField = new Ext.form.DateField({
		id: 'stopField',
		fieldLabel: 'ͣ��ʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		anchor: '95%'
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
            stopField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵ�λ�������',
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
      		
      		order = order.trim();
      		code = code.trim();
      		remark = remark.trim();

        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: unitMeasDevUrl+'?action=add&unitDr='+unitDr+'&dataItemDr='+dataItemDr+'&order='+order+'&code='+code+'&remark='+remark+'&startTime='+startTime+'&stop='+stop,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
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