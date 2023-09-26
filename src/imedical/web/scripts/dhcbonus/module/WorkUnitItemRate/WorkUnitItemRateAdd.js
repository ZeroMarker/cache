addFun = function() {

	/////////////////////////////////////////////////////////////
	var BonusUnitSt  = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		BonusUnitSt.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.data.BonusUnit.CSP?action=list&str='
								+ encodeURIComponent(Ext.getCmp('BonusUnitCombo1').getRawValue()),
						method : 'POST'
					})
		});

		var BonusUnitCombo = new Ext.form.ComboBox({
					id : 'BonusUnitCombo1',
					fieldLabel : '所属科室',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : BonusUnitSt,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					//name : 'unitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
					
				});

		var BonusWorkItemDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid','type','code','name'])
				});

		BonusWorkItemDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.data.BonusUnit.CSP?action=itemlist&str='
								+ encodeURIComponent(Ext.getCmp('BonusWorkItemCombo1').getRawValue()),
						method : 'POST'
					})
		});

		var BonusWorkItemCombo= new Ext.form.ComboBox({
					id : 'BonusWorkItemCombo1',
					fieldLabel : '工作量项目',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : BonusWorkItemDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					//name : 'unitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
					
				});

	
var ItemRateField = new Ext.form.NumberField({
	fieldLabel:"工作量标准",
	baseChars:'123456789',
	nanText:'请输入有效整数',
	allowDecimals:true
});


	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,
		items: [
			BonusUnitCombo,
			BonusWorkItemCombo,
			ItemRateField
			
		]
	});

	var addWin = new Ext.Window({
		title: '添加',
		width: 380,
		height: 220,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[
			{
				text: '保存',
				handler: function() {
					if (formPanel.form.isValid()) {
						var tmpbonusunit=BonusUnitCombo.getValue();
						var tmpWorkItem = BonusWorkItemCombo.getValue();
						var tmpItemRate = (ItemRateField.getValue()==undefined)?"":ItemRateField.getValue();
						
						if (tmpbonusunit==""){
						Ext.Msg.show({title:'注意',msg:'请选择科室ID!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
						return null;}
						if (tmpWorkItem==""){
						Ext.Msg.show({title:'注意',msg:'请选择工作量项目ID!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
						return null;}
						if (tmpItemRate==""){
						Ext.Msg.show({title:'注意',msg:'请输入工作量标准!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
						return null;}
						Ext.Ajax.request({
							url: WorkUnitItemRateUrl + '?action=add&bonusunitDr='+ tmpbonusunit+'&WorkItemDr='+tmpWorkItem+'&ItemRate='+tmpItemRate,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									
								}else{
									var tmpmsg='';
									if(jsonData.info=='RepCode'){
										tmpmsg='记录重复!';
									}
									Ext.Msg.show({title:'错误',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
						WorkUnitItemRateDs.load({params:{start:0, limit:WorkUnitItemRateToolbar.pageSize}});
					}else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'错误', msg:tmpWrongName+'不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: '取消',
				handler: function(){
					addWin.close();
				}
			}
		]
		
	});

	addWin.show();
};
