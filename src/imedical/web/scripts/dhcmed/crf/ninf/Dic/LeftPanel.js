var objLeftPanel = null;

function LeftMaintainPane() {
	
	var obj = new Object();    
	
	var SetPower=1;
	var FirstLoad=0;
		
	obj.dicTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: 'Arg1',
		dataUrl: "./dhcmed.tree.csp",
		baseParams: {
			ClassName: 'DHCMed.NINF.Dic.Cate',
			QueryName: 'QryCateTree',
			ArgCnt: 1
		}
	});
	
	
	obj.dicTree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		//rootVisible: false,
		region: "west",
		width: 200,
		//title: "表单定义",    
		loader: obj.dicTreeLoader,
		collapsible : true,
		root: new Ext.tree.AsyncTreeNode({
			leaf: false
			, text: "系统字典"
			, id: "root-SYS"
			, draggable: false
		})
	});
	
	//obj.dicTree.getRootNode().on("expand",function(t, n, r){
	obj.dicTreeLoader.on("load",function(t, n, r){
		//if (FirstLoad==0){
		//debugger;
		if (n==obj.dicTree.getRootNode()){
			FirstLoad = 1;
			obj.dicTree.getRootNode().appendChild(
				new Ext.tree.TreeNode({
					leaf: false
					, text: "感染诊断"
					, id: "nodeDiagnose"
					, draggable: false
				})
			);
			obj.dicTree.getRootNode().appendChild(
				new Ext.tree.TreeNode({
					leaf: false
					, text: "感染部位"
					, id: "nodePosition"
					, draggable: false
				})
			);
			obj.dicTree.getRootNode().appendChild(
				new Ext.tree.TreeNode({
					leaf: false
					, text: "病原体"
					, id: "nodePathogeny"
					, draggable: false
				})
			);
			obj.dicTree.getRootNode().appendChild(
				new Ext.tree.TreeNode({
					leaf: false
					, text: "抗菌药物"
					, id: "nodeAntibiotics"
					, draggable: false
				})
			);
			obj.dicTree.getRootNode().appendChild(
				new Ext.tree.TreeNode({
					leaf: false
					, text: "多重耐药菌"
					, id: "nodeMRBs"
					, draggable: false
				})
			);
			obj.dicTree.getRootNode().appendChild(
				new Ext.tree.TreeNode({
					leaf: false
					, text: "ICU三管医嘱"
					, id: "nodeICUIntubate"
					, draggable: false
				})
			);
		}
	})
	
	obj.dicTree.getRootNode().expand();
	
	
	obj.dicTreeContextMenu = new Ext.menu.Menu({
		minWidth : 80
		,items:[
			{
				id : "mnuNew",	
				text:'新建',
				icon:'',
				handler:function(){   
					//alert(obj.objSelNode.id);
					var objFrmEdit = new InitWinCateEdit("",obj.objSelNode.id.split("-")[1],obj);
					objFrmEdit.winEdit.show();
				}
			},{
				id : "mnuEdit",	
				text:'修改',
				icon:'',
				handler:function(){   
					//alert(obj.objSelNode.id);
					var objFrmEdit = new InitWinCateEdit(obj.objSelNode.id.split("-")[2],obj.objSelNode.id.split("-")[1],obj);
					objFrmEdit.winEdit.show();
				}
			}
		]
	});
	
	obj.dicTree.on("contextmenu",function(objNode, eventObj){
		if(objNode == null) return;
		var arryParts = objNode.id.split("-");
		if (arryParts.length < 2) return;
		
		objNode.select();
		obj.objSelNode = objNode;
		if (arryParts[1]=="SYS") return;
		
		obj.dicTreeContextMenu.showAt(eventObj.getXY());
	},obj);
	
    obj.ShowInNewTab = function(windowName, caption, cspUrl, closeCallBack, objScope)
	{
			var objFrame = document.getElementById("ninfDicFrame");
			var parentPanel = Ext.getCmp("ninfDicMainTab");
			parentPanel.setTitle(caption);
			//parentPanel.doLayout();
			objFrame.src = cspUrl;
	}
    obj.dicTree.on("click", function(objNode){ 
		if(objNode == null)
			return;
		obj.SelNode = objNode;
		switch(objNode.id)
		{
			case "nodeDiagnose":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.infdiagnose.csp");
				break;
			case "nodePosition":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.infposition.csp");
				break;
			case "nodePathogeny":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.pathogeny.csp");  
				break;
			case "nodeAntibiotics":
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.antibiotics.csp"); 
				break;
			case "nodeMRBs" :
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.mrbs.csp"); 
				break;
			case "nodeICUIntubate" :
				obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.icuintubate.csp");
				break;
			default:
				//window.alert("未知菜单：" + objNode.id);
				var CateCode=objNode.id.split("-")[1];
				if ((CateCode.indexOf('INFANT') > -1)&&(objNode.leaf == 1)) {
					obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.antibiotics.csp?CateCode="+CateCode);
				} else if ((CateCode.indexOf('INFPY') > -1)&&(objNode.leaf == 1)) {
					obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.pathogeny.csp?CateCode="+CateCode);
				} else if (objNode.leaf == 1) {
					obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.cateitem.csp?CateCode="+CateCode);
				} else {
					obj.ShowInNewTab(objNode.id, objNode.text ,"./dhcmed.ninf.dic.cate.csp?CateCode="+CateCode);
				}
				break;
		}
	},obj);
	
	
	
	return obj.dicTree;
	
}
