var schemeTargetUrl = 'dhc.bonus.schemetargetexe.csp';

var schemeTargetDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		"rowid","BonusTargetID","BonusTargetCode","BonusTargetName","BonusSchemeID","BonusSchemeCode","BonusSchemeName","UpdateDate"
	]),
	remoteSort: true
});

var schemeTargetCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: "方案编码",
		dataIndex:"BonusSchemeCode",
		width: 100,
		sortable: false
	},
	{
		header: "方案名称",
		dataIndex:"BonusSchemeName",
		width: 150,
		sortable: false
	},
	{
		header: "指标编码",
		dataIndex: "BonusTargetCode",
		width: 100,
		sortable: false
	},
	{
		header: "指标名称",
		dataIndex: "BonusTargetName",
		width: 150,
		sortable: false
	},
	{
		header: "生成时间",
		dataIndex: "UpdateDate",
		width: 150,
		align:"right",
		sortable: false
	}
]);


var schemeTargetPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: schemeTargetDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
});

/////////////////////////////////////////////////////////////
var schemeTypeSt = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name'])
});

schemeTypeSt.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonusschemtypeexe.csp?action=list&start=0&limit=25',method:'GET'});
});

var schemeTypeCombo = new Ext.form.ComboBox({
	fieldLabel:'方案类别',
	store: schemeTypeSt,
	displayField:'name',
	valueField:'rowid',
	typeAhead: true,
	forceSelection: true,
	triggerAction: 'all',
	selectOnFocus:true,
	width:120,
	anchor: '100%'
});

var schemeDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name','schemeState'])
});

schemeTypeCombo.on('select',function(){
	schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=schemelist&type='+schemeTypeCombo.getValue()+'&state=0&start=0&limit=100',method:'GET'});
	schemeCombo.setRawValue('');
	schemeDs.load();
	
});

var schemeCombo = new Ext.form.ComboBox({
	fieldLabel: '方案名称',
	store: schemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//pageSize: 10,
	minChars: 1,
	width:120,
	selectOnFocus: true,
	forceSelection: true
});

	
var targetField = new Ext.form.TextField({
	width: 120
});
	
////////////////////////////////////////////
var tmpschemeTypeDr = schemeTypeCombo.getValue();
var tmpschemeDr = schemeCombo.getValue();
var tmptargetDr = (targetField.getValue()==undefined)?"":targetField.getValue();
schemeTargetDs.proxy = new Ext.data.HttpProxy({url: schemeTargetUrl + '?action=list&schemeTypeDr='+ tmpschemeTypeDr+'&schemeDr='+ tmpschemeDr+'&targetDr='+tmptargetDr});

var searchButton = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'option',
	handler: function(){
		var tmpschemeTypeDr = schemeTypeCombo.getValue();
		var tmpschemeDr = schemeCombo.getValue();
		var tmptargetDr = (targetField.getValue()==undefined)?"":targetField.getValue();
		schemeTargetDs.proxy = new Ext.data.HttpProxy({url: schemeTargetUrl + '?action=list&schemeTypeDr='+ tmpschemeTypeDr+'&schemeDr='+ tmpschemeDr+'&targetDr='+tmptargetDr});
		schemeTargetDs.load({params:{start:0, limit:schemeTargetPagingToolbar.pageSize}});
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
	
		var rowObj = schemeTargetMain.getSelectionModel().getSelections();
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
							url: schemeTargetUrl + '?action=del&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeTargetDs.load({params:{start:0, limit:schemeTargetPagingToolbar.pageSize}});
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

var schemeTargetMain = new Ext.grid.GridPanel({
	region:'center',
	store: schemeTargetDs,
	cm: schemeTargetCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['方案类别:',schemeTypeCombo,'方案:',schemeCombo,'指标过滤:',targetField,searchButton,'-',addButton,'-',delButton],
	bbar: schemeTargetPagingToolbar
});

schemeTargetDs.load({params:{start:0, limit:schemeTargetPagingToolbar.pageSize}});