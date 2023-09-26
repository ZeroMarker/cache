// ��д�ߣ�����
// ��д����:2009-10-26
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var inDeptSetsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','flag','active'])
	});
	var inDeptSets = new Ext.form.ComboBox({
		id: 'inDeptSets',
		fieldLabel: '��Ա�ӿ���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: inDeptSetsDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����Ա�ӿ���...',
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
		title: '�ӿ���Ա��',
		region: 'center',
		layout: 'border',
		tbar: ["��Ա�ӿ���:","-",inDeptSets],
		items: [inDeptsGrid,outDeptsGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                                 //����Tabs
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});