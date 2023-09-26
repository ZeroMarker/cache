
//病历结构树的窗体
MyDesktop.AccordionWindow = Ext.extend(Ext.app.Module, {
    id:'tree-win',
    init : function(){
        this.launcher = {
            text: '病历列表',
            iconCls:'accordion',
            handler : this.createWindow,
            scope: this
        }
    },

    createWindow : function(){
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('viewTree');
        if(!win){
            win = desktop.createWindow({
                id: 'viewTree',
                title: '病历列表',
                width:250,
                height:400,
                iconCls: 'accordion',
                shim:false,
                animCollapse:false,
                constrainHeader:true,
                layout:'accordion',
                border:false,
                layoutConfig: {
                    animate:false
                },

                items: [
                    {
                        title: '病历结构',
                        items: getBorwserTree(episodeID),
                        autoScroll:true
                    }/*,{
                        title: '设置',
                        html:'<p>Something useful would be in here.</p>',
                        autoScroll:true
                    }*/
                ]
            });
        }
        win.setPosition(30, 50);
        win.show();
    }
});

//创建树形菜单
function getBorwserTree(episodeID)
{
    var Tree = Ext.tree;
    var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.viewerTree.cls?EpisodeID=" + episodeID});
    //抛出异常时的处理				
	treeLoader.on("loadexception", function(tree, node, response) {
		var obj = response.responseText;
		alert(obj);
	});
    var tree = new Tree.TreePanel({
		rootVisible: true,
		autoScroll:true,
		animate:false,
		//enableDD:true,
		containerScroll:true,
		lines:true, 
		checkModel:'cascade',
		autoHeight:true,
		border:false,
		loader : treeLoader,
		id:"browserTree"
    });
      
    var root = new Tree.AsyncTreeNode( {
		text : '电子病历',
		nodeType: 'async',
		draggable : false,
		id : "RT0"
    });	
	
	var count = 1;
	
	
    tree.on('click',function(node,event){
		selectNode = node;
		selectParentNode = node.parentNode;
		//判断是否是叶子节点
		if (node.isLeaf() == true)
		{
			var windowID = 'desktop_browser_' + count;
			var selectNodeID = selectNode.id.substring(2, selectNode.id.length);
			var selectParentNodeID = selectParentNode.id.substring(2, selectParentNode.id.length);
			templateDocID = selectNodeID;
			printTemplateDocID = selectParentNodeID;
			//$('#divViewBrowser').trigger('selfevent', ['browser-win', episodeID, printTemplateDocID, templateDocID]);
			$('#divViewBrowser').trigger('selfevent', [windowID, episodeID, printTemplateDocID, templateDocID]);
			count += 1;
		}
    }); 

    tree.setRootNode(root);
    root.expand(); 
    return tree;
}

