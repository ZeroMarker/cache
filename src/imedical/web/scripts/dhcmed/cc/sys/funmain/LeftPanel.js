var objLeftPanel = null;

function LeftMaintainPane() {
	var obj = new Object();
	var LocPower=ExtTool.GetParam(window,"LocPower");
	if (LocPower){
		var CPWLogLocID=session['LOGON.CTLOCID'];
	}else{
		var CPWLogLocID="";
	}
	obj.PackageMethodTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: 'Arg1',
		dataUrl: ExtToolSetting.TreeQueryPageURL,
		baseParams: {
			ClassName: 'DHCMed.CCService.Sys.CtrlItmTree',
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
		,title : '函数库'
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
						"【包名维护】",
						"./dhcmed.cc.sys.package.csp?",
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
						"【" + objNode.parentNode.text + ".函数维护】",
						"./dhcmed.cc.sys.method.csp?PackageID=" + tmpArgs[0],
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
					window.alert("函数库数据加载错误,请及时检查？NodeID="+ objNode.id);
					break;
			}
		},
		obj
	);
	
	obj.ShowInNewTab = function(windowName, caption, cspUrl, closeCallBack, objScope)
	{
		var tabs=Ext.getCmp('medCCMainTab');
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
	
	obj.ShowInNewTab("winLogo","Logo","./dhcmed.cc.sys.logo.csp");
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