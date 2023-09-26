var editFun = function(dataStore,grid,pagingTool) {
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
	//------------------------------------------------------------------------------
	var feeField = new Ext.form.NumberField({
		id: 'feeField',
		fieldLabel: '���',
		//allowDecimals:false,
		name:'fee',
		allowBlank: false,
		anchor: '90%'
	});
	
	var costField = new Ext.form.NumberField({
		id: 'costField',
		fieldLabel: '�ɱ�',
		//allowDecimals:false,
		name:'cost',
		allowBlank: false,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		name:'remark',
		allowBlank: true,
		emptyText: '�������ݱ�ע...',
		anchor: '90%'
	});
	var itemCodeField = new Ext.form.TextField({
		id: 'itemCodeField',
		fieldLabel: '��Ŀ����',
		name:'itemCode',
		allowBlank: true,
		emptyText: '��Ŀ����...',
		anchor: '90%'
	});
	var itemNameField = new Ext.form.TextField({
		id: 'itemNameField',
		fieldLabel: '��Ŀ����',
		name:'itemName',
		allowBlank: true,
		emptyText: '������Ŀ����...',
		anchor: '90%'
	});
	var fDeptCodeField = new Ext.form.TextField({
		id: 'fDeptCodeField',
		fieldLabel: '�������Ŵ���',
		name:'fDeptCode',
		allowBlank: true,
		emptyText: '�������Ŵ���...',
		anchor: '90%'
	});
	var fDeptNameField = new Ext.form.TextField({
		id: 'fDeptNameField',
		fieldLabel: '������������',
		name:'fDeptName',
		allowBlank: true,
		emptyText: '������������...',
		anchor: '90%'
	});
	var tDeptCodeField = new Ext.form.TextField({
		id: 'tDeptCodeField',
		fieldLabel: '���ղ��Ŵ���',
		name:'tDeptCode',
		allowBlank: true,
		emptyText: '���ղ��Ŵ���...',
		anchor: '90%'
	});
	var tDeptNameField = new Ext.form.TextField({
		id: 'tDeptNameField',
		fieldLabel: '���ղ�������',
		name:'tDeptName',
		allowBlank: true,
		emptyText: '���ղ�������...',
		anchor: '90%'
	});
	var patDeptCodeField = new Ext.form.TextField({
		id: 'pattDeptCodeField',
		fieldLabel: '���˲��Ŵ���',
		name:'patDeptCode',
		allowBlank: true,
		emptyText: '���˲��Ŵ���...',
		anchor: '90%'
	});
	var patDeptNameField = new Ext.form.TextField({
		id: 'patDeptNameField',
		fieldLabel: '���˲�������',
		name:'patDeptName',
		allowBlank: true,
		emptyText: '���˲�������...',
		anchor: '90%'
	});
	//------------------------------------------------------------------------------
	
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 90,
    items: [
			itemCodeField,
			itemNameField,
			fDeptCodeField,
			fDeptNameField,
			tDeptCodeField,
			tDeptNameField,
			patDeptCodeField,
			patDeptNameField,
			feeField,
			//costField,
			remarkField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸��������ݱ�',
    width: 400,
    height:400,
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
		
			var itemCode=itemCodeField.getValue();
			var itemName=itemNameField.getValue();
			var fDeptCode=fDeptCodeField.getValue();
			var fDeptName=fDeptNameField.getValue();
			var tDeptCode=tDeptCodeField.getValue();
			var tDeptName=tDeptNameField.getValue();
			var patDeptCode=patDeptCodeField.getValue();
			var patDeptName=patDeptNameField.getValue();
			
			itemCode=itemCode.trim();
			itemName=itemName.trim();
			fDeptCode=fDeptCode.trim();
			fDeptName=fDeptName.trim();
			tDeptCode=tDeptCode.trim();
			tDeptName=tDeptName.trim();
			patDeptCode=patDeptCode.trim();
			patDeptName=patDeptName.trim();
			
      		var remark = remarkField.getValue();
			var fee=feeField.getValue();
			var cost=costField.getValue();
      		  		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: incomeDatasUrl+'?action=edit&id='+myRowid+'&itemCode='+itemCode+'&itemName='+itemName+'&remark='+remark+'&fee='+fee+'&cost='+cost+'&monthDr='+monthDr+'&userDr='+userDr+'&fDeptCode='+fDeptCode+'&fDeptName='+fDeptName+'&tDeptCode='+tDeptCode+'&tDeptName='+tDeptName+'&patDeptCode='+patDeptCode+'&patDeptName='+patDeptName,
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
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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