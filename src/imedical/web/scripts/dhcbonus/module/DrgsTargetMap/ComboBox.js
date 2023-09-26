var StratagemTabUrl = '../csp/dhc.bonus.drgstargetmapexe.csp';

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

var DeptDataStors  = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'DeptCode','DeptName'])
		});

DeptDataStors.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetDept&str='+DeptFiled.getValue(),
	method : 'POST'
					})
});
var DeptFileds = new Ext.form.ComboBox({
    id:'DeptFileds',
	fieldLabel:'����ָ��',
	width:125,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'DeptName',
	store : DeptDataStors,
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


//������Ŀ������
var WorkItemStor = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','Code','Name'])
});

WorkItemStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetWorkItem',
	method : 'POST'
					})
});

var WorkItemFiled = new Ext.form.ComboBox({
    id:'WorkItemFiled',
	fieldLabel:'Drag����',
	width:125,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : WorkItemStor,
	triggerAction : 'all',
	name : 'WorkItemFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});




//���ݽӿ�������
var DataInterfStor = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','DataInter'])
});

DataInterfStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetInterf',
	method : 'POST'
					})
});



var DataInterFiled = new Ext.form.ComboBox({
    //id:'DataInterFileds',
	fieldLabel:'���ݽӿ�',
	width:103,
	listWidth:205,
    anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'DataInter',
	store : DataInterfStor,
	triggerAction : 'all',
	name : 'DataInterFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});