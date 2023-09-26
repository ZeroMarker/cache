var vStation="";
var vLocID=""
var vDesc=""
Ext.onReady(function(){
    Ext.QuickTips.init();
    
	//如果需要检索科室,就是用下面的内容,把Panel渲染到tree上
	var Find=new Ext.Button({
		handler : Find_click,
		text : '检索医嘱信息',
		region : 'north',
		id : 'TreeFind'
	});
	
	var root = new Ext.tree.AsyncTreeNode({  
		id : vStation+"^"+vLocID+"^"+vDesc+"^0",
		text : "医嘱列表"
	});
	var loader = new Ext.tree.TreeLoader({ 
		url : 'dhcpeedtree.csp'
	});
	loader.on("beforeload", function(loader, node) {
		loader.baseParams.nodeId = node.id;
	});
	var tree = new Ext.tree.TreePanel({
		//renderTo : "tree",
		region : 'center',
		root : root,
		autoScroll: true,
		loader : loader,
		frame : false,
		//width : 140,
		//autoWidth:true,
		//autoHeight : true,
		height : TreeHeight-5,
		rootVisible : false,
		id : 'EDTree'
	});
	tree.getRootNode().expand();
	tree.on("dblclick",tree_click);
	var Panel=new Ext.Panel({
		renderTo : "EDTree",
		items : [tree],
		//width : 155,
		height : TreeHeight,
		//autoWidth:true,
		//autoHeight : true,
		frame : true
	});
})
function combo_select()
{
	var tree=Ext.getCmp('EDTree')
	tree.root.reload();
}
function Find_click()
{
	var tree=Ext.getCmp('EDTree')
	tree.root.reload();
}
function tree_click(node)
{
	var Str=node.id;
	ShowPage(Str);
}
function ShowPage(Str)
{
	if (Str==""){  //没有医嘱信息
		var lnk= "websys.default.csp";
		frames("result").location.href=lnk;
		var lnk= "websys.default.csp";
    	frames("diagnosis").location.href=lnk;
    	return false;
	}
	
	vCurID=Str
	var StrArr=Str.split("^");
	var Length=StrArr.length;
	var ID=StrArr[0];
	var Type=StrArr[Length-1];
	if (Type=="3"){
		
	}
	
}


