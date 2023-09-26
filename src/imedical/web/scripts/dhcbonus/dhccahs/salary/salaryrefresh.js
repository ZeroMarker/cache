refreshFun = function(dataStore, grid, pagingTool) {
    if (intervalDr == "") {
        Ext.Msg.show({ title: '����', msg: '��ѡ�������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
        return;
    }
  var loadRulesDs = new Ext.data.Store({
	proxy: "",                                                           
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','order','code','name','deptSetDr','itemSetDr','itemTypeDr','deptSetName','itemSetName','itemTypeName'])
});
var loadRules = new Ext.form.ComboBox({
	id: 'loadRules',
	fieldLabel: '�������',
	anchor: '90%',
	listWidth : 260,
	allowBlank: false,
	store: loadRulesDs,
	valueField: 'rowId',
	displayField: 'name',
	triggerAction: 'all',
	//readOnly:true,
	emptyText:'ѡ�������...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
loadRulesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.incomedatasexe.csp?action=loadrules&searchValue='+Ext.getCmp('loadRules').getRawValue(),method:'GET'});
});	
    // create form panel
    var formPanel = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        items: [
			loadRules
		]
    });

    // define window and show it in desktop
    var window = new Ext.Window({
        title: '�����Ա����',
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
					
				if (loadRules.getValue() == '') {
					Ext.MessageBox.alert('��ʾ', '��ѡ�������!');
					return;
				}
                Ext.MessageBox.confirm('��ʾ',
					'ȷ��Ҫ��������ô?',
					function(btn) {
						if (btn == 'yes') {
							
								Ext.Ajax.request({
									url: salaryUrl + '?action=refresh&loadRules=' + loadRules.getValue()+'&intervalDr='+intervalDr+'&dataTypeDr='+ITEMTYPEID,
									waitMsg: '������...',
									failure: function(result, request) {
										Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
									},
									success: function(result, request) {
										var jsonData = Ext.util.JSON.decode(result.responseText);
										if (jsonData.success == 'true') {
											Ext.MessageBox.alert('��ʾ', '�������');
											dataStore.load({ params: { start: pagingTool.cursor, limit: pagingTool.pageSize, intervalDr: intervalDr, dataTypeDr: ITEMTYPEID} });
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