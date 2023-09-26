var StratagemTabUrl = '../csp/dhc.bonus.pabonusmapexe.csp';

//奖金指标
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
	fieldLabel:'奖金指标',
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

//指标类别

	var periodTypeStore = new Ext.data.SimpleStore({
	fields:['rowid','Name'],
	data:[[0,'空值'],[1,'方案总分'],[2,'方案维度'],[3,'方案指标']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '指标类别',
	width:125,
	//listWidth : 180,
	selectOnFocus: true,
	//allowBlank: false,
	store: periodTypeStore,
	anchor: '100%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'Name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	editable:false,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});
