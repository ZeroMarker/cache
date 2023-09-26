/**
  *name:bonussubitem
  *author:ruanchenglin
  *Date:2011-1-19
 */


//================去掉字符串空格==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
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


//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'辅助核算项目',
	value:'',
	expanded:false
});

//加载前事件
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.bonus.bonussubitemexe.csp?action=list";
		detailTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});

//收缩展开按钮
var colButton = new Ext.Toolbar.Button({
	text:'全部收缩',
	tooltip:'点击全部展开或关闭',
	listeners:{click:{fn:detailReportControl}}
});

//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:590,
    rootVisible:true,
    autoScroll:true,
    title: '奖金辅助核算项目',
	columns:[{
    	header:'项目名称',
    	align: 'right',
    	width:200,
    	dataIndex:'name'
	},{
    	header:'项目代码',
    	width:100,
    	dataIndex:'code'
	},{
    	header:'项目属性',
    	align: 'right',
    	width:80,
    	dataIndex:'type',
		renderer : function(v, p, record){
			var name="";
			if(v==1){
				name="收入项目"
			}
			if(v==2){
				name="工作量项目"
			}
			if(v==3){
				name="支出项目"
			}
			return name;
		}
	},{
    	header:'上级奖金单元',
    	align: 'right',
    	width:120,
    	dataIndex:'SuperiorItemName'
	},{
    	header:'末级标志',
    	align: 'right',
    	width:80,
    	dataIndex:'lastStage',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v==1?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
//this.add(this.tree);
var treeFilter = new Ext.tree.TreeFilter(detailReport, {
	clearBlank: true,
	autoClear: true
});

//detailReport.expandAll();
var hiddenPkgs=[];
//this.matched = [];
var filterByName = function(){
	
	var text = this.filterFieldName.getValue();
	
	//根据输入制作一个正则表达式，'i'代表不区分大小写
	var re = new RegExp(Ext.escapeRe(text), 'i');
	 //先要显示上次隐藏掉的节点
	 Ext.each(hiddenPkgs,function(n){
	   n.ui.show();
	 });
	 
	//this.matched = [];
	//如果输入的数据不存在，就执行clear()
	if(!text){
	    this.treeFilter.clear();
		return;
	}
	
	
	this.treeFilter.filterBy(function(n){
	   
	   return !n.isLeaf()||re.test(n.text);
	});

	
	hiddenPkgs=[];
	detailReport.root.cascade(function(n){
	  
	  if(!n.isLeaf()&&n.ui.ctNode.offsetHeight<3&&!re.test(n.text))
	  {
	    
	    n.ui.hide();
		hiddenPkgs.push(n);
	  }
	  if(n.id!='roo')
	  {
	 
	    if(!n.isLeaf()&& n.ui.ctNode.offsetHight>=3&&hasChild(n,re)==false&&!re.test(n.text))
		{
		  
		  n.ui.hide();
		  hiddenPkgs.push(n);
		}
	  }
	});
	
	function hasChild(n,re)
	{
	  var str=false;
	  n.cascade(function(n1){
	     if(n1.isLeaf()&&re.test(n1.attributes.text))
		 {
		 str=true;
		 return;
		 }
	  });
	  return str;
	}
	
	


};

//============================================================
//获取要操作的节点
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
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
	iconCls: 'option',
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
//查询按钮
this.filterBtn = new Ext.Button({
text : '查询',
scope : this,
iconCls: 'option',
//icon:ctx+'/images/task/buttonicon/addtask.gif',
handler : function(b, e) {
   detailReport.expandAll();
   setTimeout(filterByName,500);
}
});

var expandAllBtn = new Ext.Button({
text : '项目名称',
scope : this,
iconCls: 'option',
//icon:ctx+'/images/task/buttonicon/addtask.gif',
handler : function(b, e) {
  detailReport.expandAll();
}
});
this.filterFieldName = new Ext.form.TextField({
name:'fdcName'
});

	

//============================================================
//工具栏
var menubar = [expandAllBtn,'-',filterFieldName,'-',filterBtn,'-',addButton,'-',updateButton,'-',delButton];
//============================================================


//================定义获取要操作节点的函数====================

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
//============================================================

detailReport.on('render',function(){
	//alert('aa');
});