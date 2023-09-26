/**
  *name:kpiindex 
  *author:limingzhong
  *Date:2010-7-24
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
var globalStr2=""
//============================================================

//================定义获取要操作节点的函数====================
//获取要操作的节点
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
//============================================================

//================定义工具栏以及添加、修改、删除按钮==========
//添加按钮
var addButton=new Ext.Toolbar.Button({
	text:'添加',
	tooltip:'添加',
	iconCls: 'add',
	handler:function(){
		addFun(getNode());
	}
});
//修改按钮
var updateButton=new Ext.Toolbar.Button({
	text:'修改',
	tooltip:'设置扣分系数',
	iconCls: 'add',
	handler:function(){
		updateFun(getNode());
	}
});
//删除按钮
var delButton=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls: 'remove',
	handler:function(){
		delFun(getNode());
	}
});

//工具栏
var menubar = [addButton,'-',updateButton,'-',delButton];
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
		var url="../csp/dhc.pa.selfmaintainexe.csp?action=list";
		detailTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'项目管理',
	value:'',
	expanded:false
});
//收缩展开按钮
/*var colButton = new Ext.Toolbar.Button({
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
};*/

//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	title: '自查项目维护',
	height:590,
    rootVisible:true,
    autoScroll:true,
	columns:[
	
	{
    	header:'项目名称',
    	align: 'right',
    	width:300,
    	dataIndex:'name'
	},
	
	{
    	header:'项目代码',
    	width:80,
    	dataIndex:'code'
	},
	{
    	header:'项目id',
    	align: 'right',
    	width:50,
    	dataIndex:'id'
	}
	,{
    	header:'单位',
    	align: 'right',
    	width:80,
    	dataIndex:'unit'
	},{
    	header:'项目类别',
    	align: 'right',
    	width:150,
    	dataIndex:'type'
	}],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
 //树的排序（降序）
     new Ext.tree.TreeSorter(detailReport, {   
              property:'code',
              folderSort: false,  
              dir:'asc'          
        }); 
//============================================================