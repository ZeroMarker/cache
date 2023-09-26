editFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var id = 0;
	var deptDr = '';
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		id = rowObj[0].get("rowId");
		deptDr = rowObj[0].get("deptDr");
	}
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: 'Ȩ��˳��',
    allowBlank: false,
    emptyText:'Ȩ��˳��...',
    name:'order',
    anchor: '95%'
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: 'Ȩ������',
    allowBlank: false,
    emptyText:'Ȩ������...',
    name:'name',
    anchor: '95%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		labelSeparator: '��Ч:',
    allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
 			nameField,
 			activeField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

  var window = new Ext.Window({
  	title: '�޸�Ȩ��',
    width: 400,
    height:300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����', 
      handler: function() {
				var order = orderField.getValue();
				var name = nameField.getValue();
      	var active = (activeField.getValue()==true)?'Y':'N';
      	
      	order = order.trim();	
      	name = name.trim();
      	
        if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: mainUrl+'?action=edit&id='+id+'&order='+order+'&name='+name+'&active='+active,
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
								if(jsonData.info=='RepOrder') message='�����˳���Ѿ�����!';
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
      handler: function(){
      	window.close();
      }
    }]
  });
  window.show();
};