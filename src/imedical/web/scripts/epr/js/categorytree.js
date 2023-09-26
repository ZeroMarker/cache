	var simpleStore = new Ext.data.SimpleStore
                ({
                    fields: ["retrunValue", "displayText"],                    
                    proxy: new Ext.data.HttpProxy({ url: '../web.eprajax.cboConfig.eprType.cls' })     //后台读取的aspx
                    })
    simpleStore.load();
    simpleStore.on('load', function() {
   		Ext.getCmp("cmbCondition").setValue("cName")
    });
	  
	  var treeTbar = [                                   
                            '病例类型: ',           
                            {
                                id : 'cmbCondition',
                                xtype:'combo',
                                store:simpleStore,
                               
                                valueField : "retrunValue",
                                displayField : "displayText",
                                mode : 'local',
                                width : 110,
                                forceSelection : true,
                                blankText : '请选择查询条件',
                                emptyText : '请选择查询条件',
                                //hiddenName : 'education',
                                editable : false,
                                triggerAction : 'all',
                                allowBlank : false,
                                fieldLabel : '',
                                name : '',
                                value : 'cName',
                                anchor : '90%'
                             }];
	  
	  
	  

      var Tree = Ext.tree;
      var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.categorytreedata.cls?EpisodeID=" + EpisodeID});
      var tree = new Tree.TreePanel( {
				el:"currentDocs",
				rootVisible: false,
				autoScroll:true,
				animate:false,
				//enableDD:true,
				containerScroll:true,
				lines:true, 
				checkModel:'cascade',
				autoHeight:true,
				border:false,
				loader : treeLoader,
				id:"myTree",
				tbar:treeTbar
      });
      
      var root = new Tree.AsyncTreeNode( {
				text : '电子病历',
				nodeType: 'async',
				draggable : false,
				id : "RT0"
      });
	
	treeLoader.on("load", function(tree, node, response) {
				    if (isPrevAuto) {
				        //debugger;
				        isCallBack = true;
				        isPrevAuto = false;
                                        if (node.childNodes.length > 0) {                                            
        				        findPreviousSibling(node);
                                        }
                                        else {
                                            isCallBack = false;
                                        }
				    }

				    if (isNextAuto) {
				        isCallBack = true;
				        isNextAuto = false;
                                        if (node.childNodes.length > 0) {                                               
        				        findNextSibling(node);
                                        }
                                        else {
                                            isCallBack = false;
                                        }
				    }

				})

     tree.on('click',function(node,event){  	
	if (!node.isLeaf()){return;}
	selectTreeNode = node;	
	var nodeNote = node.id;

	//add by zhuj on 2009-8-7
	var parentID = node.parentNode.id;	
	printTemplateDocId = parentID.substring(2, parentID.length);
	templateId = node.id;

	var nodeID = nodeNote.substring(2,nodeNote.length);
	var nodeType = nodeNote.substring(0,2);
	
	if (nodeType == "TS")
	{
		//frames['centerTab'].createEprEdit();
		showTab('single', '../csp/epr.newfw.epreditor.csp?PatientID=' + PatientID + '&EpisodeID=' + EpisodeID + '&ChartItemID=' + nodeID, 'epredit');
     	}
	else
	{
		//frames['centerTab'].createEprList();
		showTab('multiple', '../csp/epr.newfw.eprlist.csp?PatientID=' + PatientID + '&EpisodeID=' + EpisodeID + '&EPRTemplateID=' + nodeID, 'eprlist');
	} 
     }); 

      tree.setRootNode(root);
      tree.render();
      root.expand(); 

