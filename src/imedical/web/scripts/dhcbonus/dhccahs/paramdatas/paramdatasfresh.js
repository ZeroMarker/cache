refreshFun = function(dataStore, grid, pagingTool) {
   if(monthDr==""||itemDr==""){
		Ext.Msg.show({title:'����',msg:'����ѡ������������Ŀ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	var deptSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	deptSetDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.loadrulesexe.csp?action=listDeptSet&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('deptSetSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var deptSetSelecter = new Ext.form.ComboBox({
		id:'deptSetSelecter',
		fieldLabel:'������',
		store: deptSetDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��ӿڲ�����...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});  
    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
			deptSetSelecter
		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '���ݶ���',
        width: 300,
        height: 130,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
            text: '��������',
            handler: function() {
					
                Ext.MessageBox.confirm('��ʾ',
					'ȷ��Ҫ��������ô?',
					function(btn) {
						if (btn == 'yes') {
							
								Ext.Ajax.request({
									url: 'dhc.ca.paramdatasexe.csp?action=refresh&deptSetDr=' + deptSetSelecter.getValue()+'&intervalDr='+monthDr+'&itemDr='+itemDr,
									waitMsg: '������...',
									failure: function(result, request) {
										Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
									},
									success: function(result, request) {
										var jsonData = Ext.util.JSON.decode(result.responseText);
										if (jsonData.success == 'true') {
											Ext.MessageBox.alert('��ʾ', '�������');
											dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize,  monthDr:monthDr, itemDr:itemDr} });
											window.close();
										}
										else {
											var message = "SQLErr: " + jsonData.info;
											Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
										}
									},
									scope: this
								});
							
						}
					}
				);
			}
        },
    	{
    	    text: 'ȡ��',
    	    handler: function() { window.close(); }
}]
    });

    window.show();

};