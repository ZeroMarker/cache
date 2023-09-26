////wyy
////从其它月份导入
var copyOtherMon = function(grid){
	var rowObj = grid.getSelections();
	var monthDr = rowObj[0].get("rowid");
	
	var oldMonthsDs = new Ext.data.Store({
		proxy: "",                                                           
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
	});
	
	var oldMonths = new Ext.form.ComboBox({
		id: 'oldMonths',
		fieldLabel: '被复制区间',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: oldMonthsDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'选择被复制核算区间...',
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
			Ext.Msg.show({title:'错误',msg:'不要选择当前月份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		title: '复制其它月份数据',
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
			text: '保存', 
			handler: function() {
				Ext.Ajax.request({
					url: 'dhc.ca.accperiodsexe.csp?action=copy&oldMon='+oldMonths.getValue()+'&newMon='+monthDr,
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'共有'+jsonData.info+'条数据被导入!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							awindow.close();
						}else{
							Ext.Msg.show({title:'注意',msg:'没有数据被添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							awindow.close();
						}
					},
					scope: this
				});	    	
			}
		},
		{
			text: '取消',
			handler: function(){awindow.close();}
		}]
	});
    awindow.show();
};