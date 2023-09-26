var bankAccountUrl = 'dhc.bonus.bankaccountexe.csp';

var bankAccountDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		"rowid","BonusUnitID","EmpCode","BonusUnitName","BankNo","CardNo","BonusRate","supUnit"
	]),
	remoteSort: true
});

var bankAccountCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: "工号",
		dataIndex:"EmpCode",
		width: 60,
		sortable: false
	},
	{
		header: "姓名",
		dataIndex:"BonusUnitName",
		width: 60,
		sortable: false
	},
	{
		header: "所属科室",
		dataIndex:"supUnit",
		width: 80,
		sortable: false
	},
	{
		header: "身份证号",
		dataIndex:"CardNo",
		width: 130,
		editor:new Ext.form.TextField(),
		sortable: false
	},
	{
		header: "银行账号",
		dataIndex: "BankNo",
		width: 130,
		editor:new Ext.form.TextField(),
		sortable: false
	},
	{
		header: "技能系数",
		dataIndex:"BonusRate",
		width: 60,
		editor:new Ext.form.NumberField(),
		sortable: false
	}
]);


var bankAccountPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: bankAccountDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
});

/////////////////////////////////////////////////////////////
var unitDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url: bankAccountUrl + '?action=unitlist'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});

var unitCombo = new Ext.form.ComboBox({
	fieldLabel: '科室',
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//pageSize: 10,
	minChars: 1,
	width:100,
	selectOnFocus: true,
	forceSelection: true
});
	var bankNoField1 = new Ext.form.TextField({
		fieldLabel: '医院人员',
		allowBlank : false,
		width:100,
		anchor: '100%'
	});
	var CardNoField1 = new Ext.form.TextField({
		fieldLabel: '相关账号',
		allowBlank : false,
		width:100,
		anchor: '100%'
	});
	
////////////////////////////////////////////
var tmpunitDr = unitCombo.getValue();
bankAccountDs.proxy = new Ext.data.HttpProxy({url: bankAccountUrl + '?action=list&unitDr='+ tmpunitDr});

var searchButton = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'option',
	handler: function(){
		var tmpunitDr = unitCombo.getValue();
		var sbankNo = encodeURIComponent(bankNoField1.getValue());
		var sCardNo = encodeURIComponent(CardNoField1.getValue());
		bankAccountDs.proxy = new Ext.data.HttpProxy({url: bankAccountUrl + '?action=list&unitDr='+ tmpunitDr+'&BankNo='+ sbankNo+'&CardNo='+ sCardNo});
		bankAccountDs.load({params:{start:0, limit:bankAccountPagingToolbar.pageSize}});
	}
})

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
	
		var rowObj = bankAccountMain.getSelectionModel().getSelections();
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
							url: bankAccountUrl + '?action=del&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									bankAccountDs.load({params:{start:0, limit:bankAccountPagingToolbar.pageSize}});
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

var bankAccountMain = new Ext.grid.EditorGridPanel({
	region:'center',
	store: bankAccountDs,
	cm: bankAccountCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['科室:',unitCombo,'人员:',bankNoField1,'账号:',CardNoField1,searchButton,'-',addButton,'-',delButton],
	bbar: bankAccountPagingToolbar
});

bankAccountMain.on("afteredit",function(e){
	var tmprowid=e.record.data.rowid;
	var tmpname=e.field;
	var tmpval=e.value;
	//alert(tmpname);
	//alert(tmpval);
	
	Ext.Ajax.request({
		url: bankAccountUrl+'?action=edit&rowid='+tmprowid+'&sName='+tmpname+'&sValue='+tmpval,
		waitMsg:'修改中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
			}else{
				Ext.Msg.show({title:'错误',msg:'修改失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		},
		scope: this
	});
});

bankAccountDs.load({params:{start:0, limit:bankAccountPagingToolbar.pageSize}});