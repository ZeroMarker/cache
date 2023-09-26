var monsCombo = new Ext.ux.form.LovCombo({
	id:'monsCombo',
	fieldLabel: '�·�',
	hideOnSelect: false,
	store: new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url: 'dhc.ca.accountmonthsexe.csp?action=list'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			id: 'rowid'
		},[
			'rowid',
			'name'
		])
	},[
		'rowid', 'name'
    ]),
	valueField:'rowid',
	displayField:'name',
	typeAhead: false,
	triggerAction: 'all',
	pageSize:10,
	listWidth:250,
	emptyText:'ѡ���·�...',
	editable:false,
	//allowBlank: false,
	anchor: '90%'
});

var deptSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
});

deptSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.deptlevelsetsexe.csp?action=listsub&id=roo', method:'GET'});
});

var deptSetComb = new Ext.form.ComboBox({
	id:'deptSetComb',
	fieldLabel:'���ŷֲ���',
	store: deptSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'ѡ���ŷֲ���...',
	allowBlank: false,
	name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
deptSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});

var itemSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
});

itemSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listsub&id=roo', method:'GET'});
});

var itemSetComb = new Ext.form.ComboBox({
	id:'itemSetComb',
	fieldLabel:'���ݷֲ���',
	store: itemSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'ѡ�����ݷֲ���...',
	allowBlank: false,
	name:'itemSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
itemSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});

var checkButton = new Ext.Toolbar.Button({
	text:'�鿴',        
	tooltip:'�鿴',
	iconCls:'add',        
	handler: function(){
		alert('monthDr:'+monsCombo.getValue()+'; deptSet:'+deptSetComb.getValue()+'; itemSet:'+itemSetComb.getValue());
	}
});

////////////////////////////////////////
// create the data store
var record = Ext.data.Record.create([
	{name: 'dept'},
 	{name: 'item'},
 	{name: 'money', type: 'float'},
 	{name: '_id', type: 'int'},
 	{name: '_level', type: 'int'},
 	{name: '_is_leaf', type: 'bool'}
]);

var store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
	autoLoad : true,
	url: 'dhc.ca.deptsdirectcostsreportexe.csp?action=list&parRef=1',
	reader: new Ext.data.JsonReader(
		{
			id: '_id',
			root: 'rows',
			totalProperty: 'results'
		}, 
		record
	)
});
	
// create the Grid
var agrid = new Ext.ux.maximgb.treegrid.GridPanel({
	store: store,
	master_column_id : 'dept',
	columns: [
		{id:'dept',header: "��������", width: 160, sortable: true, dataIndex: 'dept'},
		{header: "�ɱ���Ŀ", width: 160, sortable: true, dataIndex: 'item'},
		{header: "���", width: 160, sortable: true, dataIndex: 'money'}
	],
	stripeRows: true,
	autoExpandColumn: 'dept',
	title: '����ֱ�ӳɱ�����ͳ��',
	root_title: '����', 
	viewConfig : {
		enableRowBody : true
	}
});