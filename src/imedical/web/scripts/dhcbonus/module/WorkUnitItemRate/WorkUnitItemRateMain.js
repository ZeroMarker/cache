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
		header: "所属科室",
		dataIndex:"bonusunit",
		width: 220,
		sortable: false
	},
	{
		header: "工作量项目",
		dataIndex:"bonusworkItem",
		width: 220,
		sortable: false
	},
	{
		header: "工作量标准",
		dataIndex: "itemrate",
		width: 150,
		sortable: false,
		align:'right'
	},
	{
		header: "操作时间",
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
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
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
					fieldLabel : '所属科室',
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
					fieldLabel : '工作量项目',
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
	nanText:'请输入有效整数',
	allowDecimals:true
});
	
////////////////////////////////////////////
var tmpbonusunit=BonusUnitCombo.getValue();
var tmpWorkItem = BonusWorkItemCombo.getValue();
var tmpItemRate = (ItemRateField.getValue()==undefined)?"":ItemRateField.getValue();
WorkUnitItemRateDs.proxy = new Ext.data.HttpProxy({url: WorkUnitItemRateUrl + '?action=list'});

var searchButton = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
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
	text: '修改',
	tooltip: '修改',
	iconCls: 'option',
	handler: function(){
		editFun();
		
	}
});

var addButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
		addFun();
		
	}
});

var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
	
		var rowObj = WorkUnitItemRateMain.getSelectionModel().getSelections();
	
		var len = rowObj.length;
		
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm(
				'提示', 
				'确定要删除选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: WorkUnitItemRateUrl + '?action=del&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									WorkUnitItemRateDs.load({params:{start:0, limit:WorkUnitItemRateToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
	tbar:['所属科室:',BonusUnitCombo,'工作量项目:',BonusWorkItemCombo,'工作量标准:',ItemRateField,searchButton,'-',addButton,'-',editButton,'-',delButton],
	bbar: WorkUnitItemRateToolbar
});

WorkUnitItemRateDs.load({params:{start:0, limit:WorkUnitItemRateToolbar.pageSize}});