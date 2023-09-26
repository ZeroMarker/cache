/**
  *name:schemsetailmain
  *author:wang ying
  *Date:2010-9-21
 */
//================ȥ���ַ����ո�==============================
var jxfeedbackURL ='dhc.pa.jxfeedbackexe.csp';
var UserCode = session['LOGON.USERCODE'];
var userID = session['LOGON.USERID'];
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
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
	text:'��д������Ϣ',
	tooltip:'�ύ��д������Ϣ',
	iconCls: 'add',
	handler:function(){
		updateSetDetailFun(detailsetReport.getSelectionModel().getSelectedNode());
	}
});
//ɾ����ť
var deldetailButton=new Ext.Toolbar.Button({
	text:'ȡ���ύ',
	tooltip:'ȡ���ύ',
	iconCls: 'remove',
	handler:function(){
		delFun(detailsetReport.getSelectionModel().getSelectedNode());
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
var data="";
var monthStore="";
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

//��������comboBox
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
	width:100,
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

//�ڼ�����comboBox
var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});

var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:90,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//�뿼�����Ͷ�Ӧ�Ŀ����ڼ�comboBox
periodTypeField.on("select",function(cmb,rec,id){

	if(cmb.getValue()=="M"){
	 data=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6�ϰ���'],['2','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','00']];
	}
	periodStore.loadData(data);
	schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=list&cycle='+Ext.getCmp('cycleField').getValue()});
	schemeDs.load({params:{start:0, limit:schemeField.pageSize}});
});
periodStore = new Ext.data.SimpleStore({
     fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:90,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var schemeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

schemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=list&start=0&limit=25&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+encodeURIComponent(schemeField.getValue())});
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
var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:jxfeedbackURL+'?action=unit&schem='+Ext.getCmp('schemeField').getValue()+"&userID="+userID,method:'POST'})
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '����',
	width:100,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: deptDs,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'ѡ�����...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
schemeField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr,userID){
	//��Ч��λ
    deptDs.load({params:{start:0, limit:deptField.pageSize}});
	//KPIָ��
	//KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
};
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
var textfile = [
	{
	xtype:'label',
	text:'',
	align:'right',
	width:265
	},{
	xtype:'label',
	text:'�����ܼ�',
	align:'right'
	},{
	xtype:'label',
	text:'',
	align:'right',
	width:265
	},
	new Ext.form.TextField({id:'total',width:70,disabled:true}),
	{
	xtype:'label',
	text:'',
	align:'right',
	width:210
	}];
var detailsetmenubar = ['���:',cycleField,'-','�����ڼ䣺',periodTypeField,periodField,'-','��Ч����:',schemeField,'-','����',deptField,'-',updatedetailButton,'-',deldetailButton];
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
	  var url=jxfeedbackURL+'?action=list&schem='+schemeField.getValue()+'&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+periodField.getValue()+'&jxUnitDr='+deptField.getValue();
		detailsetTreeLoader.dataUrl=url+'&parent='+node.id;
	}
});
//���νṹ�ĸ�
var detailsetTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'������ϸ',
	value:'',
	expanded:false
});

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
    	width:160,
    	dataIndex:'name'
	},{
    	header:'ָ�����',
    	width:90,
    	dataIndex:'code'
	},{
    	header:'������λ',
    	align: 'right',
    	width:80,
    	dataIndex:'calUnitName'
	},{
    	header:'Ŀ��ֵ',
    	align: 'right',
		renderer:format,
    	width:70,
    	dataIndex:'tValue'
	},{
    	header:'ָ��ֵ',
    	align: 'right',
		renderer:format,
    	width:70,
    	dataIndex:'actValue'
	},{
    	header:'����',
    	align: 'right',
		renderer:format,
    	width:70,
    	dataIndex:'score'
	},{
    	header:'���˷���',
    	align: 'right',
    	width:80,
    	dataIndex:'method'
	},{
    	header:'��ע��',
    	align: 'right',
    	width:80,
    	dataIndex:'attentionName'
	},{
    	header:'������Ϣ',
    	align: 'right',
    	width:150,
    	dataIndex:'fbdesc'
	},{
    	header:'������',
    	align: 'right',
    	width:80,
    	dataIndex:'userName'
	},{
    	header:'���˵���',
    	align: 'right',
    	width:150,
    	dataIndex:'estdesc'
	},{
    	header:'����ʱ��',
    	align: 'right',
    	width:80,
    	dataIndex:'estDateName'
	},{
    	header:'�Ƿ��ύ',
    	align: 'right',
    	width:80,
    	dataIndex:'submit'
	}],
    loader:detailsetTreeLoader,
    root:detailsetTreeRoot
});
//submit
deptField.on("select",function(cmb,rec,id ){

    var url=jxfeedbackURL+'?action=list&schem='+schemeField.getValue()+'&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+periodField.getValue()+'&jxUnitDr='+deptField.getValue();
	detailsetTreeLoader.dataUrl=url+"&parent=0";	
	Ext.getCmp('detailsetReport').getNodeById("roo").reload();  
    
	var url=jxfeedbackURL+'?action=gettotal'
	 detailsetTreeLoader.dataUrl=url;
	 
	 Ext.Ajax.request({
       url: jxfeedbackURL+'?action=gettotal&schem='+schemeField.getValue()+'&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+periodField.getValue()+'&jxUnitDr='+deptField.getValue(),
       success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var data =jsonData.rows;
            Ext.getCmp('total').setValue(data[0].total);

			if (jsonData.success=='true') {
				Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				this.store.commitChanges(); //��ԭ�����޸���ʾ
				}
				else{
					if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
					if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
					if(jsonData.info=='RepName') message='����������Ѿ�����!';				
			    }
	    }
	});
});
//============================================================