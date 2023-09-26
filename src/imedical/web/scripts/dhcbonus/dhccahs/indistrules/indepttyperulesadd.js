specialUnitAddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form

	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '��ʾ',msg: '��ѡ��һ�����ݣ�',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
	var selectedRowid=selectedRow[0].get("rowid");
	
	var fDeptField = new Ext.form.NumberField({
        id: 'fDeptField',
        fieldLabel: '��������',
		allowDecimals: true,
		allowNegative:false,
        allowBlank: false,
		value:0,
        emptyText: '��������...',
        anchor: '90%'
    });
	var tDeptField = new Ext.form.NumberField({
        id: 'tDeptField',
        fieldLabel: '���տ���',
		allowDecimals: true,
		allowNegative:false,
        allowBlank: false,
		value:0,
        emptyText: '���տ���...',
        anchor: '90%'
    });
	var patDeptField = new Ext.form.NumberField({
        id: 'patDeptField',
        fieldLabel: '���˿���',
        allowBlank: false,
		allowNegative:false,
		allowDecimals: true,
		value:0,
        emptyText: '���˿���...',
        anchor: '90%'
    });
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
		fDeptField,
		tDeptField,
		patDeptField
		]
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸Ŀ������������',
    width: 400,
    height:200,
    minWidth: 300,
    minHeight: 200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
		id:'saveButton',
    	text: '����', 
      handler: function() {
      		// check form value
			var totalStr=fDeptField.getValue()+tDeptField.getValue()+patDeptField.getValue();
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.ca.indistrulesexe.csp?action=addtyperules&fdept='+fDeptField.getValue()+'&tdept='+tDeptField.getValue()+'&patdept='+patDeptField.getValue()+'&parRef='+selectedRowid,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								if(totalStr!=100){
									Ext.Msg.show({title:'ע��',msg:'�����ܺͲ�Ϊ100%,����µ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}else{
									Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:selectedRowid}});
									window.close();
								}
								else
								{
									var message="";
									if(jsonData.info=='RepExist') message='����ĵ�Ԫ�Ѿ�����!';
									else message='δ֪����!';
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