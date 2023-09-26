////wyy
////�������·ݵ���
var copyOtherMon = function(grid){
	var rowObj = grid.getSelections();
	var monthDr = rowObj[0].get("rowid");
	
	var oldMonthsDs = new Ext.data.Store({
		proxy: "",                                                           
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
	});
	
	var oldMonths = new Ext.form.ComboBox({
		id: 'oldMonths',
		fieldLabel: '����������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: oldMonthsDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'ѡ�񱻸��ƺ�������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	oldMonthsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.paramdatasexe.csp?action=months&searchValue='+Ext.getCmp('oldMonths').getRawValue(),method:'GET'});
	});	
	
	oldMonths.on("select",function(cmb,rec,id ){
		if(monthDr==cmb.getValue()){
			Ext.Msg.show({title:'����',msg:'��Ҫѡ��ǰ�·�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			cmb.setValue('');
			return;
		}
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			oldMonths
		]        
	});
	
	var awindow = new Ext.Window({
		title: '���������·�����',
		width: 300,
		height:150,
		minWidth: 200,
		minHeight: 150,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {
				Ext.Ajax.request({
					url: 'dhc.ca.accperiodsexe.csp?action=copy&oldMon='+oldMonths.getValue()+'&newMon='+monthDr,
					waitMsg:'������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'����'+jsonData.info+'�����ݱ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							awindow.close();
						}else{
							Ext.Msg.show({title:'ע��',msg:'û�����ݱ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							awindow.close();
						}
					},
					scope: this
				});	    	
			}
		},
		{
			text: 'ȡ��',
			handler: function(){awindow.close();}
		}]
	});
    awindow.show();
};