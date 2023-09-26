cEditFun = function() {

	var rowObj = cMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	var tmpType="";
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("BonusSubDoctorGroupMapID");
		tmpType = rowObj[0].get("BonusUnitTypeID");
	}

	var bonusUnitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	
	bonusUnitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubdeptgroupexe.csp?action=bonusunittypelist',method:'GET'});
	});

	var bonusUnitTypeCombo = new Ext.form.ComboBox({
		name:'UnitTypeName',
		fieldLabel: '医生类别',
		anchor: '100%',
		allowBlank: false,
		store: bonusUnitTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'必选',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true
	});
	
	bonusUnitTypeCombo.on('select',function(){
		unitDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubdoctorgroupexe.csp?action=listunit&type='+bonusUnitTypeCombo.getValue(), method:'GET'});
		unitCombo.setRawValue('');
		unitDs.load({params:{start:0, limit:10}});
	});

	var unitDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['BonusUnitID','BonusUnitCode','BonusUnitName'])
	});
	
	unitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubdoctorgroupexe.csp?action=listunit&type='+tmpType,method:'GET'});
	});

	var unitCombo = new Ext.form.ComboBox({
		fieldLabel:'医生名称',
		name:'BonusUnitName',
		store: unitDs,
		displayField:'BonusUnitName',
		valueField:'BonusUnitID',
		allowBlank: false,
		typeAhead: true,
		pageSize: 10,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'必选',
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
	});

	var cEditWin = new Ext.Window({
		title: '修改',
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
			text: '保存',
			handler: function() {
				//alert(unitCombo.getValue()+","+unitCombo.getRawValue())
				
				if(unitCombo.getValue()==unitCombo.getRawValue()){
					cEditWin.close();
					return
				}
				
				if (formPanel.form.isValid()) {
					tmpData=cSelected+'^'+unitCombo.getValue(),
					Ext.Ajax.request({
						url: cUrl+'?action=cedit&data='+tmpData+'&rowid='+tmpRowid,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								cDs.load({params:{start:0, limit:cPagingToolbar.pageSize}});
								cEditWin.close();
							}else{
								var tmpmsg='';
								if(jsonData.info!='0'){
									tmpmsg='编码重复!';
								}
								Ext.Msg.show({title:'错误',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
				else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: '取消',
			handler: function(){cEditWin.close();}
		}]
	});
	
	cEditWin.show();
};