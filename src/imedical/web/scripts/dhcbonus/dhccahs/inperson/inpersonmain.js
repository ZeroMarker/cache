// 编写者：杨旭
// 编写日期:2009-10-26
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var inDeptSetsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','flag','active'])
	});
	var inDeptSets = new Ext.form.ComboBox({
		id: 'inDeptSets',
		fieldLabel: '人员接口套',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: inDeptSetsDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择人员接口套...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	inDeptSetsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.personsetsexe.csp?action=list&searchValue='+Ext.getCmp('inDeptSets').getRawValue(),method:'GET'});
	});
	inDeptSets.on("select",function(cmb,rec,id ){
		inDeptSetsId=cmb.getValue();
		inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
	});

	var uPanel = new Ext.Panel({
		title: '接口人员套',
		region: 'center',
		layout: 'border',
		tbar: ["人员接口套:","-",inDeptSets],
		items: [inDeptsGrid,outDeptsGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                                 //添加Tabs
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});