//Menu
var monsCombo = new Ext.ux.form.LovCombo({
	id:'monsCombo',
	fieldLabel: '月份',
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
	emptyText:'选择月份...',
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
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.deptsdirectcostsreportexe.csp?action=deptlistsub&id=roo', method:'GET'});
});

var deptSetComb = new Ext.form.ComboBox({
	id:'deptSetComb',
	fieldLabel:'部门分层套',
	store: deptSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择部门分层套...',
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
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.deptsdirectcostsreportexe.csp?action=datalistsub&id=roo', method:'GET'});
});

var itemSetComb = new Ext.form.ComboBox({
	id:'itemSetComb',
	fieldLabel:'数据分层套',
	store: itemSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择数据分层套...',
	allowBlank: false,
	name:'itemSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
itemSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});



//树形结构导入器
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//加载前事件
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
		var url="dhc.ca.deptsdirectcostsreportexe.csp?action=list&job="+detailTreeRoot.value;
		detailTreeLoader.dataUrl=url
});
//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'合计',
	value:'',
	expanded:false
});

//收缩展开按钮
var colButton = new Ext.Toolbar.Button({
		text:'全部收缩',
		tooltip:'点击全部展开或关闭',
		listeners:{click:{fn:detailReportControl}}
		//iconCls:'x-form-search-trigger '
});
//收缩展开动作执行函数
function detailReportControl()
{
		if(colButton.getText()=='全部展开')
		{
				colButton.setText('全部收缩');
				detailReport.expandAll();
		}
		else
		{
				colButton.setText('全部展开');
				detailReport.collapseAll();
		}
};

var checkButton = new Ext.Toolbar.Button({
	text:'查看',        
	tooltip:'查看',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(itemSetComb.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
				detailReportSearch();
				printButton.enable();
			}
		}
});

var printButton = new Ext.Toolbar.Button({
	text:'打印 ',
	tooltip:'打印报表',
	iconCls:'add',   
	disabled:true, 
	handler: function(){            
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//TODO 调用此方法实现appelt打印的功能，需要更改CODEBASE，将其更改为要连接的appelt地址，value为要连接的servlet的地址
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		var printApplet=function(){
			return "<APPLET  CODE = 'EmbeddedViewerApplet.class' CODEBASE = 'http://172.26.201.66:1969/dhccareport/applets' ARCHIVE = 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar' WIDTH = '100%' HEIGHT = '100%'>"
			+"<PARAM NAME = CODE VALUE = 'EmbeddedViewerApplet.class' >"
			+"<PARAM NAME = CODEBASE VALUE = 'applets' >"
			+"<PARAM NAME = ARCHIVE VALUE = 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar' >"
			+"<PARAM NAME='type' VALUE='application/x-java-applet;version=1.2.2'>"
			+"<PARAM NAME='scriptable' VALUE='false'>"
			+"<PARAM NAME = 'REPORT_URL' VALUE ='../servlets/report/JasperPrint?job="+detailTreeRoot.value+"'>"
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
		url:'dhc.ca.deptsdirectcostsreportexe.csp?action=gen&month='+monsCombo.getValue()+'&dept='+deptSetComb.getValue()+'&item='+itemSetComb.getValue(),
		waitMsg:'正在查询...',
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

//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:700,
    rootVisible:false,
    autoScroll:true,
    title: '科室直接成本汇总统计',

	columns:[{
    	header:'科室名称',
    	width:300,
    	dataIndex:'dept'
    },{
    	header:'成本项目',
    	width:300,
		dataIndex:'item'
    },{
    	header:'金额',
    	width:300,
    	align: 'right',
    	dataIndex:'money'
    }],
    loader:detailTreeLoader,
    root:detailTreeRoot,
	rootVisible: false,
	tbar:[colButton,'-','核算月:',monsCombo,'-','部门分层套:',deptSetComb,'-','数据分层套:',itemSetComb,'-',checkButton,'-',printButton,'-']
});
		