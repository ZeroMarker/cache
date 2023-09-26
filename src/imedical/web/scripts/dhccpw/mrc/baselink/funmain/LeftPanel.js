var objLeftPanel = null;

function LeftMaintainPane() {
	var obj = new Object();
	obj.PackageMethodTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: 'Arg1',
		dataUrl: ExtToolSetting.TreeQueryPageURL,
		baseParams: {
			ClassName: 'web.DHCCPW.MRC.BaseLinkMethodSrv',
			QueryName: 'BuildMethodJson',
			Arg2 : 1,
			ArgCnt: 2
		}
	});
	
	obj.PackageMethodTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: false,
		loader: obj.PackageMethodTreeLoader,
		//collapsible : true,
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			,text: "root"
			,id: "-root-"
			,draggable: false
			,iconCls : 'icon-pro'
		})
    });
    
	obj.pn = new Ext.Panel({
		width: "25%"
		,title : '������'
		,autoScroll : true
		//, collapsible : true
		, region: "west"
		, layout: "form"
		, items:[
			obj.PackageMethodTree
		]
	});
	
	obj.PackageMethodTree.on("click",
		function(objNode)
		{
			if(objNode == null) return;
			var args = objNode.id.split("-");
			switch(args[1])
			{
				case "Package":
					obj.ShowInNewTab(objNode.id + "Package", 
						"������ά����",
						"./dhccpw.mrc.baselink.package.csp?",
						function()
						{
							var objRootNode = obj.PackageMethodTree.getRootNode();
							obj.PackageMethodTreeLoader.load(
								objRootNode,
								function(){
									obj.PackageMethodTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				case "Method":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "Method",
						"��" + objNode.parentNode.text + ".����ά����",
						"./dhccpw.mrc.baselink.method.csp?PackageID=" + tmpArgs[0],
						function()
						{
							var objRootNode = obj.PackageMethodTree.getRootNode();
							obj.PackageMethodTreeLoader.load(
								objRootNode,
								function(){
									obj.PackageMethodTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				default:
					window.alert("���������ݼ��ش���,�뼰ʱ��飿NodeID="+ objNode.id);
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
		obj.PackageMethodTreeLoader.load(
			obj.PackageMethodTree.getRootNode(),
			function()
			{
				obj.PackageMethodTree.getRootNode().expand();
			}
		);
	}
	return obj.pn;
}