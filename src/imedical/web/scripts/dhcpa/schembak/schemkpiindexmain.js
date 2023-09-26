/**
  *name:schemkpiindexmain
  *author:wang ying
  *Date:2010-8-6
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
    //alert("node="+detailReport.getSelectionModel().getSelectedNode());
	return detailReport.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================定义工具栏以及添加、修改、删除按钮==========
//添加按钮
var addButton=new Ext.Toolbar.Button({
	text:'添加',
	tooltip:'添加',
	iconCls: 'add',
	handler:function(){
	    if(SchemGrid.getSelectionModel().getSelections()==""){
			Ext.Msg.show({title:'提示',msg:'请选择要制定的方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		else{
		addSchemDetailFun(initemrowid);
		}
	}
});
//修改按钮
var updateButton=new Ext.Toolbar.Button({
	text:'修改',
	tooltip:'修改',
	iconCls: 'add',
	handler:function(){
		if(SchemGrid.getSelectionModel().getSelections()==""){
			Ext.Msg.show({title:'提示',msg:'请选择要制定的方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		else{
			updateSchemDetailFun(detailReport.getSelectionModel().getSelectedNode());
		}
	}
});
//删除按钮
var delButton=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls: 'remove',
	handler:function(){
		//alert(detailReport.getSelectionModel().getSelectedNode());
		delSchemDetailFun(detailReport.getSelectionModel().getSelectedNode());
	}
});
//工具栏
var menubar = [addButton,'-',delButton];
//============================================================

//================定义ColumnTree的相关信息====================
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
	if(detailTreeRoot.value!="undefined"){
	     //alert(node.id);
		var url='dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid;
		detailTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'指标选择',
	value:'',
	expanded:false
});
//收缩展开按钮
var colButton = new Ext.Toolbar.Button({
	text:'全部收缩',
	tooltip:'点击全部展开或关闭',
	listeners:{click:{fn:detailReportControl}}
});
//收缩展开动作执行函数
function detailReportControl(){
	if(colButton.getText()=='全部展开'){
		colButton.setText('全部收缩');
		detailReport.expandAll();
	}else{
		colButton.setText('全部展开');
		detailReport.collapseAll();
	}
}
//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:450,
    rootVisible:true,
    autoScroll:true,
    //title: '指标管理',
	columns:[{
    	header:'指标名称',
    	align: 'right',
    	width:280,
    	dataIndex:'name'
	},{
    	header:'指标代码',
    	width:80,
    	dataIndex:'code'
	},{
    	header:'考核方法',
    	align: 'right',
    	width:80,
    	dataIndex:'method'
	},{
    	header:'顺序',
    	align: 'right',
    	width:40,
    	dataIndex:'order'
	}/*,{
    	header:'id',
    	align: 'right',
    	width:120,
    	dataIndex:'detailid'
	},{
    	header:'上级',
    	align: 'right',
    	width:120,
    	dataIndex:'par'
	}*/],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
//============================================================