var objLeftPanel = null;

function LeftMaintainPane() {
	var obj = new Object();
	obj.BaseLinkItemTreeLoader = new Ext.tree.TreeLoader({
		clearOnLoad : true ,
		nodeParameter: 'Arg1',
		dataUrl: ExtToolSetting.TreeQueryPageURL,
		baseParams: {
			ClassName: 'web.DHCCPW.MRC.BaseLinkItemSrv',
			QueryName: 'BuildBaseLinkItemJson',
			Arg2 : 1,
			ArgCnt: 2
		}
	});
	
	obj.BaseLinkItemTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: false,
		loader: obj.BaseLinkItemTreeLoader,
		//collapsible : true,
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			,text: "root"
			,id: "-root"
			,draggable: false
			,iconCls : 'icon-pro'
		})
    });
    
	obj.pn = new Ext.Panel({
		width: "25%"
		,title : '关联项目'
		,autoScroll : true
		//, collapsible : true
		, region: "west"
		, layout: "form"
		, items:[
			obj.BaseLinkItemTree
		]
	});
	
	obj.BaseLinkItemTree.on("click",
		function(objNode)
		{
			if(objNode == null) return;
			var args = objNode.id.split("-");
			switch(args[1])
			{
				case "Categ":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "Categ",
						"【" + "关联项目大类】",
						"./dhccpw.mrc.baselink.categ.csp?",
						function()
						{
							var objRootNode = obj.BaseLinkItemTree.getRootNode();
							obj.BaseLinkItemTreeLoader.load(
								objRootNode,
								function(){
									obj.BaseLinkItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				case "SubCat":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "SubCat",
						"【" + objNode.parentNode.text + ".关联项目子类】",
						"./dhccpw.mrc.baselink.subcat.csp?CategID=" + tmpArgs[0],
						function()
						{
							var objRootNode = obj.BaseLinkItemTree.getRootNode();
							obj.BaseLinkItemTreeLoader.load(
								objRootNode,
								function(){
									obj.BaseLinkItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				case "ItemDic":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "ItemDic",
						"【" + objNode.parentNode.parentNode.text + "." + objNode.parentNode.text + ".关联项目】",
						"./dhccpw.mrc.baselink.item.csp?SubCatID=" + tmpArgs[0],
						function()
						{
							var objRootNode = obj.BaseLinkItemTree.getRootNode();
							obj.BaseLinkItemTreeLoader.load(
								objRootNode,
								function(){
									obj.BaseLinkItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				default:
					window.alert("关联项目数据加载错误,请及时检查？NodeID="+ objNode.id);
					break;
			}
		},
		obj
	);
	
	obj.ShowInNewTab = function(windowName, caption, cspUrl, closeCallBack, objScope)
	{
		var tabs=Ext.getCmp('cpwMainTab');
		var tabId = "tab_"+windowName;
		var obj = Ext.getCmp(tabId);
		if (obj){
		}else{
			tabs.removeAll(true);
			obj=tabs.add({
				id:tabId
				,title:caption
				,html:"<iframe id='" + windowName + "'height='100%' width='100%' src='" + cspUrl + "'/>"
				,closable:false
			})
			if(closeCallBack)
			{
				obj.on("close", closeCallBack, objScope);
			}
		}
		obj.show();
	}
	
	obj.ShowInNewTab("winLogo","Logo","./dhccpw.mrc.main.csp");
	objLeftPanel = obj;
	window.RefreshLeftTree = function()
	{
		obj.BaseLinkItemTreeLoader.load(
			obj.BaseLinkItemTree.getRootNode(),
			function()
			{
				obj.BaseLinkItemTree.getRootNode().expand(true);
			}
		);	
	}
	return obj.pn;
}