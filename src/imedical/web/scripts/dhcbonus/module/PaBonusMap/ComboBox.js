var StratagemTabUrl = '../csp/dhc.bonus.pabonusmapexe.csp';

//����ָ��
var DeptDataStor  = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'Code','Name'])
		});

DeptDataStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetDept&str='+DeptFiled.getValue(),
	method : 'POST'
					})
});


var DeptFiled = new Ext.form.ComboBox({
    id:'DeptFiled',
	fieldLabel:'����ָ��',
	width:125,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : DeptDataStor,
	triggerAction : 'all',
	name : 'DeptFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//ָ�����

	var periodTypeStore = new Ext.data.SimpleStore({
	fields:['rowid','Name'],
	data:[[0,'��ֵ'],[1,'�����ܷ�'],[2,'����ά��'],[3,'����ָ��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: 'ָ�����',
	width:125,
	//listWidth : 180,
	selectOnFocus: true,
	//allowBlank: false,
	store: periodTypeStore,
	anchor: '100%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'Name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	editable:false,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});
