scheme02AddFun = function() {

var supbonusUnitDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});
supbonusUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonusunitexe.csp?action=UnitList&LastStage=0',method:'GET'});
});

var bonusUnitTypeCombo = new Ext.form.ComboBox({
	id: 'bonusUnitTypeCombo',
	name:'bonusUnitTypeCombo',
	fieldLabel: '��������',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: supbonusUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true//,
	//forceSelection: true
});
bonusUnitTypeCombo.on('select',function(){
	bonusUnitDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=GetUnitList&supUnitID='+bonusUnitTypeCombo.getValue(),method:'GET'});
	bonusUnitCombo.setRawValue('');
	bonusUnitDs.load({params:{start:0, limit:10}});
});

var bonusUnitCombo = new Ext.form.ComboBox({
	id: 'bonusUnitCombo',
	name:'name',
	fieldLabel: '���㵥Ԫ',
	anchor: '100%',
	//listWidth : 260,
	allowBlank: false,
	store: bonusUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true//,
	//forceSelection: true
});

	if(tmpSelectedScheme=='')	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񽱽𷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			bonusUnitTypeCombo,
			bonusUnitCombo
		]
	});

	var addWin = new Ext.Window({
		title: '���',
		width: 300,
		height: 150,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[
			{
				text: '����',
				handler: function() {
					if (formPanel.form.isValid()) {
						var tmpCreatePerson=session['LOGON.USERCODE'];
						tmpData=tmpSelectedScheme+"^"+bonusUnitCombo.getValue();
						Ext.Ajax.request({
							url: scheme02Url+'?action=scheme02add&data='+tmpData,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									scheme02Ds.load({params:{start:0, limit:scheme02PagingToolbar.pageSize}});
								}else{
									var tmpmsg='';
									if(jsonData.info=='1'){
										tmpmsg='���㵥Ԫ�ظ�!';
									}
									Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
					else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'����', msg:tmpWrongName+'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: 'ȡ��',
				handler: function(){addWin.close();}
			}
		]
		
	});

	addWin.show();

};
