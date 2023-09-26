//Menu
Ext.BLANK_IMAGE_URL = "../scripts/ext2/resources/images/default/s.gif";
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
	allowBlank: false,
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



//���νṹ������
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//����ǰ�¼�
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
		var url="dhc.ca.deptsincomereportexe.csp?action=list&job="+detailTreeRoot.value;
		detailTreeLoader.dataUrl=url
});
//���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'�ϼ�',
	value:'',
	expanded:false
});

//����չ����ť
var colButton = new Ext.Toolbar.Button({
		text:'ȫ������',
		tooltip:'���ȫ��չ����ر�',
		listeners:{click:{fn:detailReportControl}}
		//iconCls:'x-form-search-trigger '
});
//����չ������ִ�к���
function detailReportControl()
{
		if(colButton.getText()=='ȫ��չ��')
		{
				colButton.setText('ȫ������');
				detailReport.expandAll();
		}
		else
		{
				colButton.setText('ȫ��չ��');
				detailReport.collapseAll();
		}
};

var checkButton = new Ext.Toolbar.Button({
	text:'�鿴',        
	tooltip:'�鿴',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")){
				Ext.Msg.alert("��ʾ","����ѡ��������");
			}else{
				detailReportSearch();
				printButton.enable();
			}
		}
});

var printButton = new Ext.Toolbar.Button({
	text:'��ӡ ',
	tooltip:'��ӡ����',
	iconCls:'add',   
	disabled:true, 
	handler: function(){            
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//TODO ���ô˷���ʵ��appelt��ӡ�Ĺ��ܣ���Ҫ����CODEBASE���������ΪҪ���ӵ�appelt��ַ��valueΪҪ���ӵ�servlet�ĵ�ַ
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")){
				Ext.Msg.alert("��ʾ","����ѡ��������");
			}        
       var printApplet=function(){
			return "<APPLET  CODE = 'EmbeddedViewerApplet.class' CODEBASE = 'http://172.26.201.66:1969/report/applets' ARCHIVE = 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar' WIDTH = '100%' HEIGHT = '100%'>"
			+"<PARAM NAME = CODE VALUE = 'EmbeddedViewerApplet.class' >"
			+"<PARAM NAME = CODEBASE VALUE = 'applets' >"
			+"<PARAM NAME = ARCHIVE VALUE = 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar' >"
			+"<PARAM NAME='type' VALUE='application/x-java-applet;version=1.2.2'>"
			+"<PARAM NAME='scriptable' VALUE='false'>"
			+"<PARAM NAME = 'REPORT_URL' VALUE ='../servlets/JasperPrintServlet?Id="+detailTreeRoot.value+"'>"
			+"</APPLET>";
			};
	    win = new Ext.Window({
	        layout:'fit',
	        width:900,
	        height:600,
	        modal:true,
	        maximizable : true,
	        plain: true,
	        items: [{
	            html: printApplet()
            }]
	    });
	    win.show(this);
	}
	
});

function detailReportSearch()
{	
	Ext.Ajax.request({
		url:'dhc.ca.deptsincomereportexe.csp?action=gen&month='+monsCombo.getValue()+'&dept='+deptSetComb.getValue(),
		waitMsg:'���ڲ�ѯ...',
		success: function(result,request){	
				var jsonData = Ext.util.JSON.decode(result.responseText);
				detailTreeRoot.value=jsonData.info;
				detailTreeRoot.reload();
				detailTreeRoot.on('expand',function(node){node.expandChildNodes();})
		}
	});
	//detailTreeRoot.reload();
	//detailTreeRoot.on('expand',function(node){node.expandChildNodes();})			
};

//���ͽṹ����
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:700,
    rootVisible:false,
    autoScroll:true,
    title: '����-ִ�п���ͳ�ƻ���',

	columns:[{
    	header:'��������',
    	width:300,
    	dataIndex:'fdept'
    },{
    	header:'�շ����',
    	width:300,
		dataIndex:'item'
    },{
    	header:'ִ�п���',
    	width:300,
		dataIndex:'tdept'
    },{
    	header:'���',
    	width:300,
    	align: 'right',
    	dataIndex:'money'
    }],
    loader:detailTreeLoader,
    root:detailTreeRoot,
	rootVisible: false,
	tbar:[colButton,'-','������:',monsCombo,'-','���ŷֲ���:',deptSetComb,'-','���ݷֲ���:',itemSetComb,'-',checkButton,'-',printButton,'-']
});
		