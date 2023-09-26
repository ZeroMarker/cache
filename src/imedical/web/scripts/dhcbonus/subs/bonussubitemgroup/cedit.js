cEditFun = function() {

	var rowObj = cMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	var tmpType="";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("BonusSubItemGroupMapID");
		tmpType = rowObj[0].get("SubItemType");
		SubItemID= rowObj[0].get("BonusSubItemID");
		ItemName=rowObj[0].get("SubItemName");
	}

//	var bonusUnitTypeDs = new Ext.data.Store({
//		proxy: "",
//		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
//	});
//	
//	bonusUnitTypeDs.on('beforeload', function(ds, o){
//		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubitemgroupexe.csp?action=itemtypelist',method:'GET'});
//	});

	var bonusUnitTypeDs = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[    
				['1','����'],            
				['2','������'],            
				['3','֧��']	
			]                                 
	});        
	
	var bonusUnitTypeCombo = new Ext.form.ComboBox({
		name:'SubItemTypeName',
		fieldLabel: '��Ŀ���',
		anchor: '100%',
		allowBlank: false,
		store: bonusUnitTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		mode: 'local',
		emptyText:'��ѡ',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true
	});
	
	bonusUnitTypeCombo.on('select',function(){
		unitDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubitemgroupexe.csp?action=listitem&type='+bonusUnitTypeCombo.getValue(), method:'GET'});
		unitCombo.setRawValue('');
		unitDs.load({params:{start:0, limit:10}});
	});
	
	var unitDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['BonusSubItemID','SubItemCode','SubItemName'])
	});
	
	unitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubitemgroupexe.csp?action=listitem&type='+tmpType,method:'GET'});
	});

	var unitCombo = new Ext.form.ComboBox({
		fieldLabel:'��Ŀ����',
		name:'SubItemName',
		store: unitDs,
		displayField:'SubItemName',
		valueField:'BonusSubItemID',
		allowBlank: false,
		typeAhead: true,
		pageSize: 10,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'��ѡ',
		selectOnFocus:true,
		anchor: '100%'
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
		bonusUnitTypeCombo,
			unitCombo
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		unitCombo.setValue(SubItemID);
		unitCombo.setRawValue(ItemName);
		
		// calField.setValue(rowObj[0].get('calFlagId'));
	});

	var cEditWin = new Ext.Window({
		title: '�޸�',
		width: 300,
		height: 130,
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
				//alert(unitCombo.getValue()+","+unitCombo.getRawValue())
				
				//if(unitCombo.getValue()==unitCombo.getRawValue()){
				//	cEditWin.close();
				//	return
				//}
				
				if (formPanel.form.isValid()) {
					tmpData=cSelected+'^'+unitCombo.getValue(),
					Ext.Ajax.request({
						url: cUrl+'?action=cedit&data='+tmpData+'&rowid='+tmpRowid,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								cDs.load({params:{start:0, limit:cPagingToolbar.pageSize}});
								cEditWin.close();
							}else{
								var tmpmsg='';
								if(jsonData.info!='0'){
									tmpmsg='�����ظ�!';
								}
								Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
				else{
					Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: 'ȡ��',
			handler: function(){cEditWin.close();}
		}]
	});
	
	cEditWin.show();
};