var WorkUnitItemRateUrl = 'dhc.bonus.module.WorkUnitItemRateexe.CSP';

var WorkUnitItemRateDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		"rowid","bonusunitid","bonusunit","bonusworkItemid","bonusworkItem","itemrate","upatedate"
	]),
	remoteSort: true
});

var WorkUnitItemRateCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: "��������",
		dataIndex:"bonusunit",
		width: 220,
		sortable: false
	},
	{
		header: "��������Ŀ",
		dataIndex:"bonusworkItem",
		width: 220,
		sortable: false
	},
	{
		header: "��������׼",
		dataIndex: "itemrate",
		width: 150,
		sortable: false,
		align:'right'
	},
	{
		header: "����ʱ��",
		dataIndex: "upatedate",
		width: 200,
		sortable: false,
		align:'right'
	}
]);


var WorkUnitItemRateToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: WorkUnitItemRateDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"
});

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
								+ encodeURIComponent(Ext.getCmp('BonusUnitCombo').getRawValue()),
						method : 'POST'
					})
		});

		var BonusUnitCombo= new Ext.form.ComboBox({
					id : 'BonusUnitCombo',
					fieldLabel : '��������',
					width : 140,
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
//------------------
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
								+ encodeURIComponent(Ext.getCmp('BonusWorkItemCombo').getRawValue()),
						method : 'POST'
					})
		});

		var BonusWorkItemCombo= new Ext.form.ComboBox({
					id : 'BonusWorkItemCombo',
					fieldLabel : '��������Ŀ',
					width : 140,
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
	baseChars:'123456789',
	nanText:'��������Ч����',
	allowDecimals:true
});
	
////////////////////////////////////////////
var tmpbonusunit=BonusUnitCombo.getValue();
var tmpWorkItem = BonusWorkItemCombo.getValue();
var tmpItemRate = (ItemRateField.getValue()==undefined)?"":ItemRateField.getValue();
WorkUnitItemRateDs.proxy = new Ext.data.HttpProxy({url: WorkUnitItemRateUrl + '?action=list'});

var searchButton = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'option',
	handler: function(){
		var tmpbonusunit=BonusUnitCombo.getValue();
		var tmpWorkItem = BonusWorkItemCombo.getValue();
		var tmpItemRate = (ItemRateField.getValue()==undefined)?"":ItemRateField.getValue();
		//WorkUnitItemRateDs.proxy = new Ext.data.HttpProxy({url: WorkUnitItemRateUrl + '?action=list&schemeDr='+ tmpWorkItem+'&searchValue='+tmpItemRate});
		WorkUnitItemRateDs.load({params:{start:0, limit:WorkUnitItemRateToolbar.pageSize,bonusunitDr:tmpbonusunit,WorkItemDr:tmpWorkItem,ItemRate:tmpItemRate}});
	}
})

var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
	tooltip: '�޸�',
	iconCls: 'option',
	handler: function(){
		editFun();
		
	}
});

var addButton = new Ext.Toolbar.Button({
	text: '���',
	tooltip: '���',
	iconCls: 'add',
	handler: function(){
		addFun();
		
	}
});

var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
	
		var rowObj = WorkUnitItemRateMain.getSelectionModel().getSelections();
	
		var len = rowObj.length;
		
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm(
				'��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: WorkUnitItemRateUrl + '?action=del&rowid='+tmpRowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									WorkUnitItemRateDs.load({params:{start:0, limit:WorkUnitItemRateToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'����',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	}
});

var WorkUnitItemRateMain = new Ext.grid.GridPanel({
	region:'center',
	store: WorkUnitItemRateDs,
	cm: WorkUnitItemRateCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['��������:',BonusUnitCombo,'��������Ŀ:',BonusWorkItemCombo,'��������׼:',ItemRateField,searchButton,'-',addButton,'-',editButton,'-',delButton],
	bbar: WorkUnitItemRateToolbar
});

WorkUnitItemRateDs.load({params:{start:0, limit:WorkUnitItemRateToolbar.pageSize}});