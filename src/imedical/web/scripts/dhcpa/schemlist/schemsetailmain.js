/**
  *name:schemsetailmain
  *author:wang ying
  *Date:2010-9-10
 */
//================ȥ���ַ����ո�==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//============================================================

//================���岿��ȫ�ֱ���============================
//��ӻ����޸ı�־
var type="";
//���ʽ(�ؼ�)
var expreField="";
//���ʽ����(�ؼ�)
var expreDescField="";
//���ʽ����(����)
var expreDesc="";
//���ڱ��ʽ�Ĵ洢
var globalStr3="";
//���ڱ��ʽ����ʾ
var globalStr="";
//���ڱ��ʽ���˸���
var globalStr2="";
//============================================================

//================�����ȡҪ�����ڵ�ĺ���====================
//��ȡҪ�����Ľڵ�
var getNode = function(){
	return detailsetReport.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================���幤�����Լ���ӡ��޸ġ�ɾ����ť==========
//��Ӱ�ť
var adddetailButton=new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls: 'add',
	handler:function(){
		addFun(getNode());
	}
});
//�޸İ�ť
var updatedetailButton=new Ext.Toolbar.Button({
	text:'�޸�',
	tooltip:'�޸�',
	iconCls: 'add',
	handler:function(){
		updateSetDetailFun(detailsetReport.getSelectionModel().getSelectedNode());
	}
});
//ɾ����ť
var deldetailButton=new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls: 'add',
	handler:function(){
		delFun(getNode());
	}
});
//���㰴ť
var calculatorButton=new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls: 'add',
	handler:function(){
		alert(MVEL.eval("1+2*3*(5+6)"));
	}
});

var StratagemTabUrl = '../csp/dhc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '��������',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
cycleField.on("select",function(cmb,rec,id ){
	schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=list&cycle='+Ext.getCmp('cycleField').getValue()});
	schemeDs.load({params:{start:0, limit:schemeField.pageSize}});
});

var schemeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

schemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=list&start=0&limit=25&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+encodeURIComponent(Ext.getCmp('schemeField').getRawValue())});
});

var schemeField = new Ext.form.ComboBox({
	id: 'schemeField',
	fieldLabel: '��Ч����',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��Ч����...',
	name: 'schemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var method = new Ext.form.ComboBox({
			id:'method',
			fieldLabel: '����Ƶ��',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["I",'���䷨'],["C",'�ȽϷ�'],["D",'�۷ַ�'],["A",'�ӷַ�'],["M",'Ŀ����շ�']]
			})			
		});
//������
var detailsetmenubar = ['���:',cycleField,'-','��Ч����:',schemeField];
//============================================================

//================����ColumnTree�������Ϣ====================
//���νṹ������
var detailsetTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//����ǰ�¼�
detailsetTreeLoader.on('beforeload', function(detailsetTreeLoader,node){
	if(detailsetTreeRoot.value!="undefined"){
		var url='dhc.pa.schemexe.csp?action=findkpi&schem='+schemeField.getValue();
		detailsetTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//���νṹ�ĸ�
var detailsetTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'������ϸ',
	value:'',
	expanded:false
});
//����չ����ť
var colButton = new Ext.Toolbar.Button({
	text:'ȫ������',
	tooltip:'���ȫ��չ����ر�',
	listeners:{click:{fn:detailsetReportControl}}
});
//����չ������ִ�к���
function detailsetReportControl(){
	if(colButton.getText()=='ȫ��չ��'){
		colButton.setText('ȫ������');
		detailsetReport.expandAll();
	}else{
		colButton.setText('ȫ��չ��');
		detailsetReport.collapseAll();
	}
}
//���ͽṹ����
var detailsetReport = new Ext.tree.ColumnTree({
	id:'detailsetReport',
	height:590,
    rootVisible:true,
    autoScroll:true,
    //title: 'Ȩ������',
	columns:[{
    	header:'ָ������',
    	align: 'right',
    	width:260,
    	dataIndex:'name'
	},{
    	header:'ָ�����',
    	width:205,
    	dataIndex:'code'
	},{
    	header:'������λ',
    	align: 'right',
    	width:120,
    	dataIndex:'calUnitName'
	},{
    	header:'���˷���',
    	align: 'right',
    	width:150,
    	dataIndex:'method'
	},{
    	header:'�ռ�����',
    	align: 'right',
    	width:150,
    	dataIndex:'colDeptName'
	},{
    	header:'����Ŀ��',
    	align: 'right',
    	width:150,
    	dataIndex:'target'
	},{
    	header:'���㹫ʽ',
    	align: 'right',
    	width:250,
    	dataIndex:'expName'
	}],
    loader:detailsetTreeLoader,
    root:detailsetTreeRoot
});
schemeField.on("select",function(cmb,rec,id ){
    var url='dhc.pa.schemexe.csp?action=findkpi&schem='+schemeField.getValue();
	detailsetTreeLoader.dataUrl=url+"&parent=0";	
	Ext.getCmp('detailsetReport').getNodeById("roo").reload();   
});
//============================================================