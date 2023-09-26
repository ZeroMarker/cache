var editFun = function(dataStore,grid,pagingTool,monthDr) {
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
	
	
	var debitField = new Ext.form.NumberField({
		id: 'debitField',
		fieldLabel: '�跽',
		//allowDecimals:false,
		name:'debit',
		allowBlank: false,
		anchor: '90%'
	});
	
	var loansField = new Ext.form.NumberField({
		id: 'loansField',
		fieldLabel: '����',
		//allowDecimals:false,
		name:'loans',
		allowBlank: true,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		name:'remark',
		allowBlank: true,
		emptyText: 'ƾ֤���ݱ�ע...',
		anchor: '90%'
	});
	
	var deptCodeField = new Ext.form.TextField({
		id: 'deptCodeField',
		fieldLabel: '���Ҵ���',
		name:'deptCode',
		allowBlank: true,
		emptyText: '�޸Ŀ��Ҵ���...',
		anchor: '90%'
	});
var deptNameField = new Ext.form.TextField({
		id: 'deptNameField',
		fieldLabel: '��������',
		name:'deptName',
		allowBlank: true,
		emptyText: '�޸Ŀ�������...',
		anchor: '90%'
	});
	
	var subjCodeField = new Ext.form.TextField({
		id: 'subjCodeField',
		fieldLabel: '��Ŀ����',
		name:'subjCode',
		allowBlank: true,
		emptyText: '�޸Ŀ�Ŀ����...',
		anchor: '90%'
	});
	
	var subjNameField = new Ext.form.TextField({
		id: 'subjNameField',
		fieldLabel: '��Ŀ����',
		name:'subjName',
		allowBlank: true,
		emptyText: '�޸Ŀ�����...',
		anchor: '90%'
	});
	
	
  
	
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 70,
    items: [
			deptCodeField,
			deptNameField,
			subjCodeField,
			subjNameField,
			remarkField,
			debitField,
			loansField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		
		
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸�ƾ֤���ݱ�',
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
		
			var deptCode=deptCodeField.getValue();
			var deptName=deptNameField.getValue();
			var subjCode=subjCodeField.getValue();
			var subjName=subjNameField.getValue();
      		var remark = remarkField.getValue();
			var debit=debitField.getValue();
			var loans=loansField.getValue();	
      		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
						  
						   	//url: vouchDatasUrl+'?action=edit&id='+myRowid+'&deptCode='+deptCode+'&subjCode='+subjCode+'&remark='+remark+'&debit='+debit+'&loans='+loans+'&monthDr='+monthDr+'&userDr='+userDr+'&deptName='+deptName+'&subjName='+subjName,
							url: vouchDatasUrl+'?action=edit&id='+myRowid+'&deptCode='+deptCode+'&deptName='+deptName+'&subjCode='+subjCode+'&subjName='+subjName+'&remark='+remark+'&debit='+debit+'&loans='+loans+'&userDr='+userDr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'ע��',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,monthDr:monthDr}});
									window.close();
								}
								else
								{
									var message = "";
									message =  jsonData.info;
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