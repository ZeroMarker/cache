/**
  *name:bonussubitem
  *author:ruanchenglin
  *Date:2011-1-19
 */


//================ȥ���ַ����ո�==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//============================================================
//================����ColumnTree�������Ϣ====================
//���νṹ������
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});


//���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'����������Ŀ',
	value:'',
	expanded:false
});

//����ǰ�¼�
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.bonus.bonussubitemexe.csp?action=list";
		detailTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});

//����չ����ť
var colButton = new Ext.Toolbar.Button({
	text:'ȫ������',
	tooltip:'���ȫ��չ����ر�',
	listeners:{click:{fn:detailReportControl}}
});

//���ͽṹ����
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	height:590,
    rootVisible:true,
    autoScroll:true,
    title: '������������Ŀ',
	columns:[{
    	header:'��Ŀ����',
    	align: 'right',
    	width:200,
    	dataIndex:'name'
	},{
    	header:'��Ŀ����',
    	width:100,
    	dataIndex:'code'
	},{
    	header:'��Ŀ����',
    	align: 'right',
    	width:80,
    	dataIndex:'type',
		renderer : function(v, p, record){
			var name="";
			if(v==1){
				name="������Ŀ"
			}
			if(v==2){
				name="��������Ŀ"
			}
			if(v==3){
				name="֧����Ŀ"
			}
			return name;
		}
	},{
    	header:'�ϼ�����Ԫ',
    	align: 'right',
    	width:120,
    	dataIndex:'SuperiorItemName'
	},{
    	header:'ĩ����־',
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
	
	//������������һ��������ʽ��'i'�������ִ�Сд
	var re = new RegExp(Ext.escapeRe(text), 'i');
	 //��Ҫ��ʾ�ϴ����ص��Ľڵ�
	 Ext.each(hiddenPkgs,function(n){
	   n.ui.show();
	 });
	 
	//this.matched = [];
	//�����������ݲ����ڣ���ִ��clear()
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
//��ȡҪ�����Ľڵ�
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
//================���幤�����Լ���ӡ��޸ġ�ɾ����ť==========
//��Ӱ�ť

var addButton=new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls: 'add',
	handler:function(){
		addFun(getNode());
	}
});
//�޸İ�ť
var updateButton=new Ext.Toolbar.Button({
	text:'�޸�',
	tooltip:'�޸�',
	iconCls: 'option',
	handler:function(){
		updateFun(getNode());
	}
});
//ɾ����ť
var delButton=new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls: 'add',
	handler:function(){
		delFun(getNode());
	}
});
//��ѯ��ť
this.filterBtn = new Ext.Button({
text : '��ѯ',
scope : this,
iconCls: 'option',
//icon:ctx+'/images/task/buttonicon/addtask.gif',
handler : function(b, e) {
   detailReport.expandAll();
   setTimeout(filterByName,500);
}
});

var expandAllBtn = new Ext.Button({
text : '��Ŀ����',
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
//������
var menubar = [expandAllBtn,'-',filterFieldName,'-',filterBtn,'-',addButton,'-',updateButton,'-',delButton];
//============================================================


//================�����ȡҪ�����ڵ�ĺ���====================

//����չ������ִ�к���
function detailReportControl(){
	if(colButton.getText()=='ȫ��չ��'){
		colButton.setText('ȫ������');
		detailReport.expandAll();
	}else{
		colButton.setText('ȫ��չ��');
		detailReport.collapseAll();
	}
};
//============================================================

detailReport.on('render',function(){
	//alert('aa');
});