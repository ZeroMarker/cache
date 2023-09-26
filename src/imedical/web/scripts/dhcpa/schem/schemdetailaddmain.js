/**
  *name:schemdetailaddmain
  *author:wang ying
  *Date:2010-8-10
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
	return detailReport.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================���幤�����Լ���ӡ��޸ġ�ɾ����ť==========
//��Ӱ�ť
var adddetailButton=new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls: 'add',
	handler:function(){
		addFun(detailaddReport.getSelectionModel().getSelectedNode());
	}
});
//�޸İ�ť
var updatedetailaddButton=new Ext.Toolbar.Button({
	text:'�޸�',
	tooltip:'�޸�',
	iconCls: 'add',
	handler:function(){
	    //alert(detailaddReport.getSelectionModel().getSelectedNode());
		updatedetailaddFun(detailaddReport.getSelectionModel().getSelectedNode());
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
var schemeaddDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

schemeaddDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemexe.csp?action=list&searchField=name&searchValue='+encodeURIComponent(schemeaddField.getRawValue())});
});

var schemeaddField = new Ext.form.ComboBox({
	id: 'schemeaddField',
	fieldLabel: '��Ч����',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemeaddDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��Ч����...',
	name: 'schemeaddField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var extremum = new Ext.form.ComboBox({
			id:'extremum',
			fieldLabel: '��ֵ',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["H",'����'],["M",'����'],["L",'����']]
			})			
		});
//������
var detailaddmenubar = ['��Ч����:',schemeaddField,'-',updatedetailaddButton];
//============================================================

//================����ColumnTree�������Ϣ====================
//���νṹ������
var detailaddTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//����ǰ�¼�
detailaddTreeLoader.on('beforeload', function(detailaddTreeLoader,node){
	if(detailaddTreeRoot.value!="undefined"){
		var url=SchemUrl+'?action=detailaddlist&schem='+schemeaddField.getValue();
		detailaddTreeLoader.dataUrl=url+'&parent='+node.id;
	}
});
//���νṹ�ĸ�
var detailaddTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'��������',
	value:'',
	expanded:false
});
//����չ����ť
var colButton = new Ext.Toolbar.Button({
	text:'ȫ������',
	tooltip:'���ȫ��չ����ر�',
	listeners:{click:{fn:detailaddReportControl}}
});
//����չ������ִ�к���
function detailaddReportControl(){
	if(colButton.getText()=='ȫ��չ��'){
		colButton.setText('ȫ������');
		detailaddReport.expandAll();
	}else{
		colButton.setText('ȫ��չ��');
		detailaddReport.collapseAll();
	}
}
//���ͽṹ����
var detailaddReport = new Ext.tree.RateSetColumnTree({
	id:'detailaddReport',
	height:450,
    rootVisible:true,
    autoScroll:true,
    //title: '��������',
	columns:[{
    	header:'ָ������',
    	align: 'right',
		//columnWidth:100,
		width:260,
    	dataIndex:'name'
	},{
    	header:'ָ�����',
    	width:150,
    	dataIndex:'code'
	},{
    	header:'������λ',
    	align: 'right',
    	width:60,
    	dataIndex:'calUnitName'
	},{
    	header:'Ȩ��',
    	align: 'right',
    	width:60,
    	dataIndex:'rate'
	},{
    	header:'���˷���',
    	align: 'right',
    	width:150,
    	dataIndex:'method'
	},{
    	header:'����Ŀ��',
    	align: 'right',
    	width:60,
    	dataIndex:'target'
	},{
    	header:'������',
    	align: 'right',
    	width:90,
    	dataIndex:'changeValue'
	},{
    	header:'������',
    	align: 'right',
    	width:90,
    	dataIndex:'score'
	},{
    	header:'������',
    	align: 'right',
    	width:90,
    	dataIndex:'baseValue'
	},{
    	header:'����ֵ',
    	align: 'right',
    	width:90,
    	dataIndex:'base'
	}],
    loader:detailaddTreeLoader,
    root:detailaddTreeRoot
});
schemeaddField.on("select",function(cmb,rec,id ){
   //alert(schemeaddField.getValue());
    var url=SchemUrl+'?action=detailaddlist&schem='+schemeaddField.getValue();
	detailTreeLoader.dataUrl=url+"&parent=0";	
	Ext.getCmp('detailaddReport').getNodeById("roo").reload();   
});

//============================================================