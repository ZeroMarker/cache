//变量声明********************************************
var selectNode;

var schemeName = "";
var schemeDesc = "";
var SchemeItems = "";

Ext.QuickTips.init();

//备选范围树******************************************
//增加选中项目到当前方案toolbar
var tbarAddItem = new Ext.Toolbar({
	border:true,
	items:[{
		xtype:'button',
		text:'将选中项目添加到打印方案',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/ok.gif',
		handler:addItems
	},
	'-',
	{
		xtype:'button',
		text:'返回',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/back.gif',
		handler:moveBack
	}]
});

//备选范围树操作toolbar
var tbarChkOp = new Ext.Toolbar({
	border:true,
	items:[{
		xtype:'button',
		text:'全选',
		handler:function(){
			var rootNodes=treeAll.getRootNode();
			selectAll(rootNodes);
		}
	},
	'-',
	{
		xtype:'button',
		text:'全不选',
		handler:function(){
			var nodes=treeAll.getChecked();
			if(nodes && nodes.length){
				for(var i=0;i<nodes.length;i++){
					nodes[i].getUI().toggleCheck(false);
					nodes[i].attributes.checked=false;
				}
			}
		}
	},
	'-',
	{	
		xtype:'button',
		text:'刷新',
		handler:function(){
			var rootNodes=treeAll.getRootNode();
			rootNodes.loaded=false;
			rootNode.expand();
			treeAll.expandAll();
		}	
	}]
});

//备选范围树
var treeAll = new Ext.tree.TreePanel({
	//title: '全部范围',
	id:'treeAll',
	rootVisible: false,
	autoScroll:true,
	trackMouseOver:false,
	animate:false,
	containerScroll:true,
	bodyStyle:'padding:0px 2px 20px 0px',
	lines:true, 
	checkModel:'cascade',
	border:true,
	tbar:tbarChkOp    
});	

//备选范围树root
var rootNode = new Ext.tree.AsyncTreeNode( {
	text : '请选择打印范围',
	nodeType: 'async',
	draggable : false,
	id : "RT00"
});	
    
treeAll.setRootNode(rootNode);

rootNode.loader = new Ext.tree.TreeLoader({
	dataUrl: "../web.eprajax.CentralizedPrintTree.cls?Action=default&EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID,
	timeout: 20000	
});

rootNode.expand(true);

//备选范围树复选框操作联动
treeAll.on("checkchange", function(node,checked) {
	if (node.leaf){
		if (!checked){   
			//任一子节点未选中，则不选中父节点
			node.parentNode.attributes.checked = false;
			node.parentNode.getUI().checkbox.checked = false;
			if(node.parentNode.parentNode.id != "RT00"){
				node.parentNode.parentNode.attributes.checked = false;
				node.parentNode.parentNode.getUI().checkbox.checked = false;
			}
		}
		else{
			//选中所有子节点，则选中父节点
			var totChecked = true;
			for ( var i=0; i<node.parentNode.childNodes.length; i++){
				if (!node.parentNode.childNodes[i].attributes.checked){
					totChecked = false;
					break;
				}
			}
			node.parentNode.attributes.checked = totChecked;
			node.parentNode.getUI().checkbox.checked = totChecked;
			if(node.parentNode.parentNode.id != "RT00"){
				var totCheckedOut = true;
				for ( var i=0; i<node.parentNode.parentNode.childNodes.length; i++){
					if (!node.parentNode.parentNode.childNodes[i].attributes.checked){
						totCheckedOut = false;
						break;
					}
				}
				node.parentNode.parentNode.attributes.checked = totCheckedOut;
				node.parentNode.parentNode.getUI().checkbox.checked = totCheckedOut;
			}
		}   
	}
    else{
		//选中父节点，则选中所有子节点
		for (var i=0; i<node.childNodes.length; i++){
			node.childNodes[i].attributes.checked = checked;
			node.childNodes[i].getUI().checkbox.checked = checked;
			node.childNodes[i].fireEvent("checkchange", node.childNodes[i], checked);
		}
	} 
}); 

//view******************************************
var view = new Ext.Viewport({
	id: 'treeViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:true,
		region:'north',
		layout:'fit',
		height: 30,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:tbarAddItem 
	},{
        border:true,
		region:'center',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		width: 500,
		height: 400,
		split: true,
		collapsible: true,  
		items:treeAll       
	}]
});

treeAll.render('treeAll');
treeAll.doLayout();
