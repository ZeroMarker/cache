/**
  *name:jxunit
  *author:limingzhong
  *Date:2010-7-27
 */
//================去掉字符串空格==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
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
	tooltip:'修改',
	iconCls: 'add',
	handler:function(){
		updateFun(getNode());
	}
});
//删除按钮
var delButton=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls: 'add',
	handler:function(){
		delFun(getNode());
	}
});
//作废按钮
var stopButton=new Ext.Toolbar.Button({
	text:'停用',
	tooltip:'停用',
	iconCls: 'remove',
	handler:function(){
		stopFun(getNode());
	}	
});
//============================================================
//工具栏
//var menubar = [addButton,'-',updateButton,'-',delButton];
var menubar = [addButton,'-',updateButton,'-',stopButton];
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
		var url="../csp/dhc.pa.jxunitexe.csp?action=list";
		detailTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'绩效单元设置',
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
};

//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:590,
    rootVisible:true,
    autoScroll:true,
    title: '绩效单元设置',
	columns:[{
    	header:'绩效单元名称',
    	align: 'right',
    	width:200,
    	dataIndex:'name'
	},{
    	header:'绩效单元代码',
    	width:100,
    	dataIndex:'code'
	}
	,{
    	header:'绩效单元id',
    	width:100,
    	dataIndex:'id'
	},{
    	header:'拼音码',
    	align: 'right',
    	width:80,
    	dataIndex:'py'
	}/*,{
    	header:'所属应用系统',
    	align: 'right',
    	width:100,
    	dataIndex:'appSysName'
	},{
    	header:'类型编码',
    	align: 'right',
    	width:80,
    	dataIndex:'type'
	}*/,{
    	header:'所属科室类别',
    	align: 'right',
    	width:100,
    	dataIndex:'locTypeName'
	},{
    	header:'上级绩效单元',
    	align: 'right',
    	width:100,
    	dataIndex:'parentName'
	},{
    	header:'是否参与核算标志',
    	align: 'right',
    	width:100,
    	dataIndex:'isEnd',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'单元级别',
    	align: 'right',
    	width:80,
    	dataIndex:'level'
	}/*,{
    	header:'科室名称',
    	align: 'right',
    	width:100,
    	dataIndex:'deptName'
	},{
    	header:'所属战略',
    	align: 'right',
    	width:100,
    	dataIndex:'stratagemName'
	}*/,{
    	header:'末端标志',
    	align: 'right',
    	width:80,
    	dataIndex:'End',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'是否停用',
    	align: 'right',
    	width:80,
    	dataIndex:'isStop',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
//============================================================