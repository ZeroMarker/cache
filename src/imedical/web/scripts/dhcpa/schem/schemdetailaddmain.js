/**
  *name:schemdetailaddmain
  *author:wang ying
  *Date:2010-8-10
 */
//================去掉字符串空格==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//============================================================

//================定义部分全局变量============================
//添加或者修改标志
var type="";
//表达式(控件)
var expreField="";
//表达式描述(控件)
var expreDescField="";
//表达式描述(变量)
var expreDesc="";
//用于表达式的存储
var globalStr3="";
//用于表达式的显示
var globalStr="";
//用于表达式的退格处理
var globalStr2="";
//============================================================

//================定义获取要操作节点的函数====================
//获取要操作的节点
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================定义工具栏以及添加、修改、删除按钮==========
//添加按钮
var adddetailButton=new Ext.Toolbar.Button({
	text:'添加',
	tooltip:'添加',
	iconCls: 'add',
	handler:function(){
		addFun(detailaddReport.getSelectionModel().getSelectedNode());
	}
});
//修改按钮
var updatedetailaddButton=new Ext.Toolbar.Button({
	text:'修改',
	tooltip:'修改',
	iconCls: 'add',
	handler:function(){
	    //alert(detailaddReport.getSelectionModel().getSelectedNode());
		updatedetailaddFun(detailaddReport.getSelectionModel().getSelectedNode());
	}
});
//删除按钮
var deldetailButton=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls: 'add',
	handler:function(){
		delFun(getNode());
	}
});
//计算按钮
var calculatorButton=new Ext.Toolbar.Button({
	text:'计算',
	tooltip:'计算',
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
	fieldLabel: '绩效方案',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemeaddDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择绩效方案...',
	name: 'schemeaddField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var extremum = new Ext.form.ComboBox({
			id:'extremum',
			fieldLabel: '极值',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["H",'趋高'],["M",'趋中'],["L",'趋低']]
			})			
		});
//工具栏
var detailaddmenubar = ['绩效方案:',schemeaddField,'-',updatedetailaddButton];
//============================================================

//================定义ColumnTree的相关信息====================
//树形结构导入器
var detailaddTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//加载前事件
detailaddTreeLoader.on('beforeload', function(detailaddTreeLoader,node){
	if(detailaddTreeRoot.value!="undefined"){
		var url=SchemUrl+'?action=detailaddlist&schem='+schemeaddField.getValue();
		detailaddTreeLoader.dataUrl=url+'&parent='+node.id;
	}
});
//树形结构的根
var detailaddTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'方案管理',
	value:'',
	expanded:false
});
//收缩展开按钮
var colButton = new Ext.Toolbar.Button({
	text:'全部收缩',
	tooltip:'点击全部展开或关闭',
	listeners:{click:{fn:detailaddReportControl}}
});
//收缩展开动作执行函数
function detailaddReportControl(){
	if(colButton.getText()=='全部展开'){
		colButton.setText('全部收缩');
		detailaddReport.expandAll();
	}else{
		colButton.setText('全部展开');
		detailaddReport.collapseAll();
	}
}
//树型结构定义
var detailaddReport = new Ext.tree.RateSetColumnTree({
	id:'detailaddReport',
	height:450,
    rootVisible:true,
    autoScroll:true,
    //title: '方案管理',
	columns:[{
    	header:'指标名称',
    	align: 'right',
		//columnWidth:100,
		width:260,
    	dataIndex:'name'
	},{
    	header:'指标代码',
    	width:150,
    	dataIndex:'code'
	},{
    	header:'计量单位',
    	align: 'right',
    	width:60,
    	dataIndex:'calUnitName'
	},{
    	header:'权重',
    	align: 'right',
    	width:60,
    	dataIndex:'rate'
	},{
    	header:'考核方法',
    	align: 'right',
    	width:150,
    	dataIndex:'method'
	},{
    	header:'评测目的',
    	align: 'right',
    	width:60,
    	dataIndex:'target'
	},{
    	header:'增减量',
    	align: 'right',
    	width:90,
    	dataIndex:'changeValue'
	},{
    	header:'增减分',
    	align: 'right',
    	width:90,
    	dataIndex:'score'
	},{
    	header:'基础分',
    	align: 'right',
    	width:90,
    	dataIndex:'baseValue'
	},{
    	header:'基础值',
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