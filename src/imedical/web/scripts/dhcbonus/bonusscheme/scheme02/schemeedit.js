scheme02EditFun = function() {
var supbonusUnitDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});
supbonusUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonusunitexe.csp?action=UnitList&start=0&limit=10&LastStage=0',method:'GET'});
});


var bonusUnitTypeCombo = new Ext.form.ComboBox({
	id: 'bonusUnitTypeCombo',
	name:'name',
	fieldLabel: '所属科室',
	anchor: '100%',
	//listWidth : 260,
	//allowBlank: false,
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
	fieldLabel: '核算单元',
	anchor: '100%',
	store: bonusUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true
});
	
	var rowObj = scheme02Main.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		tmpRowid = rowObj[0].get("rowid");
	}

	bonusUnitTypeCombo.name='SuperUnitName';
	bonusUnitCombo.name='BonusUnitName';
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			bonusUnitTypeCombo,
			bonusUnitCombo
		]
	});
	
	var t1=rowObj[0].get("SuperiorUnitID");		//
	var t2=rowObj[0].get("BonusUnitID");		
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});
	
	if(tmpSelectedScheme=='')	{
		Ext.Msg.show({title:'注意',msg:'请选择奖金方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var editWin = new Ext.Window({
		title: '修改',
		width: 300,
		height: 150,
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
				if (formPanel.form.isValid()) {
					var tmpCreatePerson=session['LOGON.USERCODE'];
					if(bonusUnitTypeCombo.getValue()!=bonusUnitTypeCombo.getRawValue()){      //                                                          //
						t1=bonusUnitTypeCombo.getValue();                                  //                                                          //
					}                                                                   
					if(bonusUnitCombo.getValue()!=bonusUnitCombo.getRawValue()){            //                                                          //
						t2=bonusUnitCombo.getValue();                                     
					}                         
					tmpData=tmpSelectedScheme+"^"+t2;
			
					
					Ext.Ajax.request({
						url: scheme02Url+'?action=scheme02edit&data='+tmpData+'&rowid='+tmpRowid,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								scheme02Ds.load({params:{start:0, limit:scheme02PagingToolbar.pageSize}});
								editWin.close();
							}else{
								var tmpmsg='';
								if(jsonData.info=='1'){
									tmpmsg='核算单元重复!';
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
			handler: function(){editWin.close();}
		}]
	});

	editWin.show();
};