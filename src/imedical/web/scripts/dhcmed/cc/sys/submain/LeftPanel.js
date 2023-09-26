var objLeftPanel = null;

function LeftMaintainPane() {
	var obj = new Object();
	var LocPower=ExtTool.GetParam(window,"LocPower");
	if (LocPower){
		var CPWLogLocID=session['LOGON.CTLOCID'];
	}else{
		var CPWLogLocID="";
	}
	
	//Add By LiYang 2011-09-15 增加快捷菜单
	obj.mnuTree = new  Ext.menu.Menu({
		minWidth : 80
		,items:[
			{
				id : "mnuCopy",
				text : "拷贝",
				handler: function()
				{
                       obj.objSrcNode = obj.objCurrNode;
				}
			},
			{
				id : "mnuCut",
				text : "剪切",
				handler: function()
				{
                      obj.cutFlag = true;
                      obj.objSrcNode = obj.objCurrNode;
				}
			},
			{
				id : "mnuPaste",
				text : "粘贴",
				handler: function()
				{
                    if(obj.cutFlag == true)
                    {
                    }
                    else
                    {
                        var arryCurrNodeID = obj.objCurrNode.id.split("-");
                        var arrySrcNodeID = obj.objSrcNode.id.split("-");
                       
                        //window.alert(arryCurrNodeID);
                        if((arrySrcNodeID[1] == "Categ")&&(arryCurrNodeID[1] == "Subject")&&(arryCurrNodeID[0] != 0 ))
                        {
                        	var arryTargetRootID = obj.objCurrNode.id.split("-"); 
                            var objManage = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemCatSrv");
                            
                            var ret = objManage.CatCopyTo(arrySrcNodeID[0], arryTargetRootID[0]);
                            obj.SubjectItemTreeLoader.load(
							obj.objCurrNode,
							function()
							{
								obj.objCurrNode.expand(true);
							}
						);
                        }
                         if((arrySrcNodeID[1] == "SubCat")&&(arryCurrNodeID[1] == "Categ")&&(arryCurrNodeID[0] != 0 ))
                        {
                        	var arrySrcRootID = obj.objSrcNode.parentNode.parentNode.id.split("-"); 
                        	var arryTargetRootID = obj.objCurrNode.parentNode.id.split("-"); 
                            var objManage = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemCatSrv");
                            
                            var ret = objManage.SubCatCopyTo(arrySrcRootID[0], arrySrcNodeID[0], arryTargetRootID[0], arryCurrNodeID[0]);
                            window.RefreshLeftTree();
                            //window.alert(ret);
                        }                           
                        if((arrySrcNodeID[1] == "ItemDic")&&(arryCurrNodeID[1] == "SubCat")&&(arryCurrNodeID[0] != 0 ))
                        {
                        	var arryTmp = arrySrcNodeID[2].split("||");
                           var arryTmp1 = arryCurrNodeID[2].split("||");
                           var arryRootID = obj.objCurrNode.parentNode.parentNode.id.split("-");
                           
                            var objManage = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemDicSrv");
                           var ret =  objManage.CopyTo(arryTmp[2], arrySrcNodeID[0], arryRootID[0],arryCurrNodeID[0]);
                           
                           window.RefreshLeftTree();
                          /* obj.SubjectItemTreeLoader.load({
                           		node : obj.SubjectItemTree.getSelectionModel().getSelectedNode().parentNode
                           	});
                           	*/
                        }                      
                        
                     }
				}
			}						
		]
	});
	
	
	
	
	
	
	
	
	obj.SubjectItemTreeLoader = new Ext.tree.TreeLoader({
		clearOnLoad : true , //Add By LiYang 2011-09-18
		nodeParameter: 'Arg1',
		dataUrl: ExtToolSetting.TreeQueryPageURL,
		baseParams: {
			ClassName: 'DHCMed.CCService.Sys.CtrlItmTree',
			QueryName: 'BuildSubjectJson',
			Arg2 : 1,
			ArgCnt: 2
		}
	});
	
	obj.SubjectItemTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: false,
		loader: obj.SubjectItemTreeLoader,
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
		,title : '监控主题'
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
				case "Subject":
					obj.ShowInNewTab(objNode.id + "Subject", 
						"【监控主题维护】",
						"./dhcmed.cc.sys.subject.csp?",
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				case "Categ":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "Categ",
						"【" + objNode.parentNode.text + ".项目大类维护】",
						"./dhcmed.cc.sys.categ.csp?SubjectID=" + tmpArgs[0],
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				case "SubCat":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "SubCat",
						"【" + objNode.parentNode.parentNode.text + "." + objNode.parentNode.text + ".项目子类维护】",
						"./dhcmed.cc.sys.subcat.csp?CategID=" + tmpArgs[0],
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				case "ItemDic":
					var tmpArgs = objNode.parentNode.id.split("-");
					obj.ShowInNewTab(objNode.id + "ItemDic",
						"【" + objNode.parentNode.parentNode.parentNode.text + "." + objNode.parentNode.parentNode.text + "." + objNode.parentNode.text + ".监控项目维护】",
						"./dhcmed.cc.sys.item.csp?SubCatID=" + tmpArgs[0],
						function()
						{
							var objRootNode = obj.SubjectItemTree.getRootNode();
							obj.SubjectItemTreeLoader.load(
								objRootNode,
								function(){
									obj.SubjectItemTree.getRootNode().expand();
								}
							);
						}
					);
					break;
				default:
					window.alert("监控主题数据加载错误,请及时检查？NodeID="+ objNode.id);
					break;
			}
		},
		obj
	);
	
	//Add By LiYang 2011-09-15
	obj.SubjectItemTree.on("contextmenu", 
		function(objNode, objEvent)
		{
			obj.objCurrNode = objNode;
			//window.alert(objNode.id);
              var arryCurrNodeID = obj.objCurrNode.id.split("-");
              var arrySrcNodeID = ["","",""];
              if(obj.objSrcNode != null)
              	arrySrcNodeID = obj.objSrcNode.id.split("-");			
			var objMenu = Ext.getCmp("mnuPaste");
			objMenu.disable();
		    if((arrySrcNodeID[1] == "Categ")&&(arryCurrNodeID[1] == "Subject"))
		    		objMenu.enable();
		    if((arrySrcNodeID[1] == "SubCat")&&(arryCurrNodeID[1] == "Categ"))
		    		objMenu.enable();		    
		    if((arrySrcNodeID[1] == "ItemDic")&&(arryCurrNodeID[1] == "SubCat"))
		    		objMenu.enable();		    
		    
			
			
			obj.mnuTree.showAt(objEvent.getXY());
			objEvent.stopEvent();
		}
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
		var objSelNode = obj.SubjectItemTree.getSelectionModel().getSelectedNode().parentNode;
		obj.SubjectItemTreeLoader.load(
			objSelNode,
			function(){
				//objSelNode.expand(true);
				objSelNode.reload();
			}
		);
	}
	return obj.pn;
}