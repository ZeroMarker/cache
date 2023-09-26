var objLeftPanel = null;

function LeftMaintainPane() {
	var obj = new Object();
	var LocPower=ExtTool.GetParam(window,"LocPower");
	if (LocPower){
		var CPWLogLocID=session['LOGON.CTLOCID'];
	}else{
		var CPWLogLocID="";
	}
	obj.SubjectItemTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: 'Arg1',
		dataUrl: "./dhccpw.tree.csp",
		baseParams: {
			ClassName: 'web.DHCCPW.MRC.BaseDictionary',
			QueryName: 'QryDicTree',
			ArgCnt: 1
		}
	});
	
	obj.SubjectItemTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: true,
		loader: obj.SubjectItemTreeLoader,
		//collapsible : true,
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			,text: "字典大类"
			,id: "root-root"
			,draggable: false
			,iconCls : 'icon-pro'
		})
    });
    
	obj.pn = new Ext.Panel({
		width: "25%"
		,title : '字典大类'
		,autoScroll : true
		//, collapsible : true
		, region: "west"
		, layout: "form"
		, items:[
			obj.SubjectItemTree
		]
	});
	
	obj.SubjectItemTree.on("click",
		function(objNode)
		{
			if(objNode == null) return;
			var args = objNode.id.split("-");
			switch(args[1])
			{
				case "root":
					obj.ShowInNewTab(objNode.id + "cate", 
						"【字典大类】",
						"./dhccpw.mrc.basediccateg.csp"/*,
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}*/
					);
					break;
				case "cate":
					var tmpArgs = objNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "subcate",
						"【" + objNode.text + "-字典子类】",
						"./dhccpw.mrc.basedicsubcateg.csp?cate=" + tmpArgs[0]/*,
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}*/
					);
					break;
				case "subcate":
					var tmpArgs = objNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "SubCat",
						"【" + objNode.text + "-字典项目】",
						"./dhccpw.mrc.basedictionary.csp?subcate=" + tmpArgs[0]/*,
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}*/
					);
					break;
				default:
					window.alert("数据加载错误,请及时检查？NodeID="+ objNode.id);
					break;
			}
		},
		obj
	);
	
	obj.ShowInNewTab = function(windowName, caption, cspUrl, closeCallBack, objScope)
	{
		var tabs=Ext.getCmp('dicMain');
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
	
	//obj.ShowInNewTab(" ","首页","");
	obj.ShowInNewTab("tab-Logo","Logo","./dhccpw.mrc.main.csp");	
	objLeftPanel = obj;
	window.RefreshLeftTree = function()
	{
		obj.SubjectItemTreeLoader.load(
			obj.SubjectItemTree.getRootNode(),
			function()
			{
				obj.SubjectItemTree.getRootNode().expand();
			}
		);
	}
	return obj.pn;
}