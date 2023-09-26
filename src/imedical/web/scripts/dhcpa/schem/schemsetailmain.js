/**
  *name:schemsetailmain
  *author:wang ying
  *Date:2010-8-10
 */
//================去掉字符串空格==============================
/*
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
*/
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
	return detailsetReport.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================定义工具栏以及添加、修改、删除按钮==========
//添加按钮
var adddetailButton=new Ext.Toolbar.Button({
	text:'添加',
	tooltip:'添加',
	iconCls: 'add',
	handler:function(){
		addFun(getNode());
	}
});
//修改按钮
var updatedetailButton=new Ext.Toolbar.Button({
	text:'修改',
	tooltip:'修改',
	iconCls: 'add',
	handler:function(){
		updateSetDetailFun(detailsetReport.getSelectionModel().getSelectedNode());
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
var schemeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

schemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemexe.csp?action=list&searchField=name&searchValue='+encodeURIComponent(schemeField.getRawValue())});
});

var schemeField = new Ext.form.ComboBox({
	id: 'schemeField',
	fieldLabel: '绩效方案',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择绩效方案...',
	name: 'schemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var method = new Ext.form.ComboBox({
			id:'method',
			fieldLabel: '考核频率',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["I",'区间法'],["C",'比较法'],["D",'扣分法'],["A",'加分法'],["M",'目标参照法']]
			})			
		});
//工具栏
var detailsetmenubar = ['绩效方案:',schemeField,'-',updatedetailButton];
//============================================================

//================定义ColumnTree的相关信息====================
//树形结构导入器
var detailsetTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//加载前事件
detailsetTreeLoader.on('beforeload', function(detailsetTreeLoader,node){
	if(detailsetTreeRoot.value!="undefined"){
		var url='dhc.pa.schemexe.csp?action=findkpi&schem='+schemeField.getValue();
		//alert(schemeField.getValue());
		detailsetTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//树形结构的根
var detailsetTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'方案明细',
	value:'',
	expanded:false
});
//收缩展开按钮
var colButton = new Ext.Toolbar.Button({
	text:'全部收缩',
	tooltip:'点击全部展开或关闭',
	listeners:{click:{fn:detailsetReportControl}}
});
//收缩展开动作执行函数
function detailsetReportControl(){
	if(colButton.getText()=='全部展开'){
		colButton.setText('全部收缩');
		detailsetReport.expandAll();
	}else{
		colButton.setText('全部展开');
		detailsetReport.collapseAll();
	}
}
//树型结构定义
var detailsetReport = new Ext.tree.RateSetColumnTree({
	id:'detailsetReport',
	height:450,
    rootVisible:true,
    autoScroll:true,
    //title: '权重设置',
	columns:[{
    	header:'指标名称',
    	align: 'right',
    	width:350,
    	dataIndex:'name'
	},{
    	header:'指标代码',
    	width:205,
    	dataIndex:'code'
	},{
    	header:'计量单位',
    	align: 'right',
    	width:120,
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
    	width:250,
    	dataIndex:'target'
	}/*,{
    	header:'上级',
    	align: 'right',
		hidden:true,
    	width:250,
    	dataIndex:'par'
	}*/],
    loader:detailsetTreeLoader,
    root:detailsetTreeRoot
});
schemeField.on("select",function(cmb,rec,id ){
    var url='dhc.pa.schemexe.csp?action=findkpi&schem='+schemeField.getValue();
	detailTreeLoader.dataUrl=url+"&parent=0";	
	Ext.getCmp('detailsetReport').getNodeById("roo").reload();   
});
//============================================================